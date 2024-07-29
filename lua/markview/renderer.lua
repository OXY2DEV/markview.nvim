local renderer = {};
local devicons = require("nvim-web-devicons");

local utils = require("markview.utils");


_G.__markview_views = {};

renderer.view_ranges = {};
renderer.removed_elements = {};

local get_str_width = function (str)
	local width = 0;
	local overlflow = 0;

	for match in str:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
		overlflow = overlflow + (vim.fn.strdisplaywidth(match) - 1);
		width = width + #match
	end

	return width, overlflow
end


--- Returns a value with the specified index from entry
--- If index is nil then return the last value
--- If entry isn't a table then return it
---
---@param entry any
---@param index number
---@return any
local tbl_clamp = function (entry, index)
	if type(entry) ~= "table" then
		return entry;
	end

	if index <= #entry then
		return entry[index];
	end

	return entry[#entry];
end

local list_shift = function (tbl)
	local tmp = table.remove(tbl, 1);
	table.insert(tbl, tmp)

	return tbl;
end

local set_hl = function (hl)
	if type(hl) ~= "string" then
		return;
	end

	if vim.fn.hlexists("Markview" .. hl) == 1 then
		return "Markview" .. hl;
	elseif vim.fn.hlexists("Markview_" .. hl) == 1 then
		return "Markview_" .. hl;
	else
		return hl;
	end
end

local display_width = function (text, config)
	local d_width = vim.fn.strchars(text);
	local inl_conf = config.inline_codes;

	for inline_code in text:gmatch("`([^`]+)`") do
		d_width = d_width - (vim.fn.strchars("`" .. inline_code .. "`"));

		if inl_conf ~= nil and inl_conf.enable ~= false then
			d_width = d_width + vim.fn.strchars(table.concat({
				inl_conf.corner_left or "",
				inl_conf.padding_left or "",

				inline_code or "",

				inl_conf.padding_right or "",
				inl_conf.corner_right or ""
			}));
		end
	end

	local lnk_conf = config.links ~= nil and config.links.inline_links or nil;
	local img_conf = config.links ~= nil and config.links.images or nil;

	for img_identifier, link, address in text:gmatch("(!?)%[([^%]]+)%]%(([^%)]+)%)") do
		if img_identifier ~= "" then
			d_width = d_width - vim.fn.strchars("![" .. "](" .. address .. ")");

			if img_conf ~= nil and img_conf.enable ~= false then
				d_width = d_width + vim.fn.strchars(table.concat({
					img_conf.corner_left or "",
					img_conf.padding_left or "",
					img_conf.icon or "",
					img_conf.padding_right or "",
					img_conf.corner_right or ""
				}));
			end
		else
			d_width = d_width - vim.fn.strchars("[" .. "](" .. address .. ")");

			if lnk_conf ~= nil and lnk_conf.enable ~= false then
				d_width = d_width + vim.fn.strchars(table.concat({
					lnk_conf.corner_left or "",
					lnk_conf.padding_left or "",
					lnk_conf.icon or "",
					lnk_conf.padding_right or "",
					lnk_conf.corner_right or ""
				}));
			end
		end
	end

	for str_a, str_b in text:gmatch("([*]+)[^*]+([*]+)") do
		local min_signs = vim.fn.strchars(str_a) > vim.fn.strchars(str_b) and vim.fn.strchars(str_a) or vim.fn.strchars(str_b);

		local start_pos, _ = text:find("([*]+)[^*]+([*]+)");

		local c_before = text:sub(start_pos - 1, start_pos - 1);
		-- local c_after = text:sub(end_pos + 1, end_pos + 1);

		-- Needs more flexibility
		if c_before == "[" or c_before == "`" then
			goto invalid
		end

		for s = 1, min_signs do
			local a = str_a:sub(s, s);
			local b = str_b:reverse():sub(s, s);

			if a == b then
				d_width = d_width - 2;
			end
		end

		::invalid::
	end


	return d_width, vim.fn.strchars(text);
end


--- Renderer for table headers
---@param buffer number
---@param content any
---@param config_table markview.config
local table_header = function (buffer, content, config_table)
	local tbl_conf = config_table.tables;

	local curr_col = 0;
	local curr_tbl_col = 1;

	local virt_txt = {};

	for index, col in ipairs(content.rows[1]) do
		if index == 1 then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[6], set_hl(tbl_conf.hl[6]) }
				},

				end_col = content.col_start + 1,
				conceal = ""
			});

			table.insert(virt_txt, { tbl_conf.text[1], set_hl(tbl_conf.hl[1]) })
			curr_col = curr_col + 1
		elseif index == #content.rows[1] then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[6], set_hl(tbl_conf.hl[6]) }
				},

				end_col = content.col_start + curr_col + 1,
				conceal = ""
			});

			table.insert(virt_txt, { tbl_conf.text[3], set_hl(tbl_conf.hl[3]) })

			if config_table.tables.use_virt_lines == true then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
					virt_lines_above = true,
					virt_lines = {
						virt_txt
					}
				});
			elseif content.row_start > 0 then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start - 1, content.col_start, {
					virt_text_pos = "inline",
					virt_text = virt_txt
				});
			end

			curr_col = curr_col + 1
		elseif col == "|" then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[6], set_hl(tbl_conf.hl[6]) }
				},

				end_col = content.col_start + curr_col + 1,
				conceal = ""
			});

			table.insert(virt_txt, { tbl_conf.text[4], set_hl(tbl_conf.hl[4]) })
			curr_col = curr_col + 1
		else
			local width, actual_width = display_width(col, config_table);
			local align = content.content_alignments[curr_tbl_col];

			if width < actual_width then
				if align == "left" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + curr_col + width + 1, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", (actual_width - width)) }
						}
					});
				elseif align == "right" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", (actual_width - width)) }
						}
					});
				else
					local before, after = math.floor((actual_width - width) / 2), math.ceil((actual_width - width) / 2);

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + curr_col + width + 1, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", after) }
						}
					});

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", before) }
						}
					});
				end
			end

			table.insert(virt_txt, { string.rep(tbl_conf.text[2], actual_width), set_hl(tbl_conf.hl[2]) })
			curr_col = curr_col + vim.fn.strchars(col);
			curr_tbl_col = curr_tbl_col + 1;
		end
	end
end

--- Renderer for table seperator
---@param buffer number
---@param content any
---@param user_config markview.config
---@param r_num number
local table_seperator = function (buffer, content, user_config, r_num)
	local tbl_conf = user_config.tables;

	local curr_col = 0;
	local curr_tbl_col = 1;

	for index, col in ipairs(content.rows[r_num]) do
		if index == 1 then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + (r_num - 1), content.col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[5], set_hl(tbl_conf.hl[5]) }
				},

				end_col = content.col_start + 1,
				conceal = ""
			});

			curr_col = curr_col + 1;
		elseif index == #content.rows[1] then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + (r_num - 1), content.col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[7], set_hl(tbl_conf.hl[7]) }
				},

				end_col = content.col_start + curr_col + 1,
				conceal = ""
			});

			curr_col = curr_col + 1;
		elseif col == "|" then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + (r_num - 1), content.col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[8], set_hl(tbl_conf.hl[8]) }
				},

				end_col = content.col_start + curr_col + 1,
				conceal = ""
			});

			curr_col = curr_col + 1;
		else
			local align = content.content_alignments[curr_tbl_col];

			if col:match(":") then
				if align == "left" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + (r_num - 1), content.col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ tbl_conf.text[13], set_hl(tbl_conf.hl[13]) },
							{ string.rep(tbl_conf.text[2], vim.fn.strchars(col) - 1), set_hl(tbl_conf.hl[2]) }
						},

						end_col = content.col_start + curr_col + vim.fn.strchars(col) + 1,
						conceal = ""
					});
				elseif align == "right" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + (r_num - 1), content.col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(tbl_conf.text[2], vim.fn.strchars(col) - 1), set_hl(tbl_conf.hl[2]) },
							{ tbl_conf.text[14], set_hl(tbl_conf.hl[14]) }
						},

						end_col = content.col_start + curr_col + vim.fn.strchars(col) + 1,
						conceal = ""
					});
				elseif align == "center" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + (r_num - 1), content.col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ tbl_conf.text[15], set_hl(tbl_conf.hl[15]) },
							{ string.rep(tbl_conf.text[2], vim.fn.strchars(col) - 2), set_hl(tbl_conf.hl[2]) },
							{ tbl_conf.text[16], set_hl(tbl_conf.hl[16]) }
						},

						end_col = content.col_start + curr_col + vim.fn.strchars(col) + 1,
						conceal = ""
					});
				end
			else
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + (r_num - 1), content.col_start + curr_col, {
					virt_text_pos = "inline",
					virt_text = {
						{ string.rep(tbl_conf.text[2], vim.fn.strchars(col)), set_hl(tbl_conf.hl[8]) }
					},

					end_col = content.col_start + curr_col + vim.fn.strchars(col) + 1,
					conceal = ""
				});
			end

			curr_col = curr_col + vim.fn.strchars(col);
			curr_tbl_col = curr_tbl_col + 1;
		end
	end
end

--- Renderer for table footers
---@param buffer number
---@param content any
---@param config_table markview.config
local table_footer = function (buffer, content, config_table)
	local tbl_conf = config_table.tables;

	local curr_col = 0;
	local curr_tbl_col = 1;

	local virt_txt = {};

	for index, col in ipairs(content.rows[#content.rows]) do
		if index == 1 then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end - 1, content.col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[6], set_hl(tbl_conf.hl[6]) }
				},

				end_col = content.col_start + 1,
				conceal = ""
			});

			table.insert(virt_txt, { tbl_conf.text[9], set_hl(tbl_conf.hl[9]) })
			curr_col = curr_col + 1
		elseif index == #content.rows[1] then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end - 1, content.col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[6], set_hl(tbl_conf.hl[6]) }
				},

				end_col = content.col_start + curr_col + 1,
				conceal = ""
			});

			table.insert(virt_txt, { tbl_conf.text[11], set_hl(tbl_conf.hl[11]) })

			if config_table.tables.use_virt_lines == true then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end - 1, content.col_start, {
					virt_lines_above = false,
					virt_lines = {
						virt_txt
					}
				});
			elseif content.row_start > 0 then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end, content.col_start, {
					virt_text_pos = "inline",
					virt_text = virt_txt
				});
			end

			curr_col = curr_col + 1
		elseif col == "|" then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end - 1, content.col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[6], set_hl(tbl_conf.hl[6]) }
				},

				end_col = content.col_start + curr_col + 1,
				conceal = ""
			});

			table.insert(virt_txt, { tbl_conf.text[12], set_hl(tbl_conf.hl[12]) })
			curr_col = curr_col + 1
		else
			local width, actual_width = display_width(col, config_table);
			local align = content.content_alignments[curr_tbl_col];

			if width < actual_width then
				if align == "left" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end - 1, content.col_start + curr_col + width + 1, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", (actual_width - width)) }
						}
					});
				elseif align == "right" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end - 1, content.col_start, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", (actual_width - width)) }
						}
					});
				else
					local before, after = math.floor((actual_width - width) / 2), math.ceil((actual_width - width) / 2);

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end - 1, content.col_start + curr_col + width + 1, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", after) }
						}
					});

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end - 1, content.col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", before) }
						}
					});
				end
			end

			table.insert(virt_txt, { string.rep(tbl_conf.text[10], actual_width), set_hl(tbl_conf.hl[10]) })
			curr_col = curr_col + vim.fn.strchars(col);
			curr_tbl_col = curr_tbl_col + 1;
		end
	end
end

--- Renderer for table contents
---@param buffer number
---@param content any
---@param config_table markview.config
---@param r_num number
local table_content = function (buffer, content, config_table, r_num)
	local tbl_conf = config_table.tables;

	local curr_col = 0;
	local curr_tbl_col = 1;

	for index, col in ipairs(content.rows[r_num]) do
		if index == 1 then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + r_num - 1, content.col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[6], set_hl(tbl_conf.hl[6]) }
				},

				end_col = content.col_start + 1,
				conceal = ""
			});

			curr_col = curr_col + 1
		elseif index == #content.rows[1] then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + r_num - 1, content.col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[6], set_hl(tbl_conf.hl[6]) }
				},

				end_col = content.col_start + curr_col + 1,
				conceal = ""
			});

			curr_col = curr_col + 1
		elseif col == "|" then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + r_num - 1, content.col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[6], set_hl(tbl_conf.hl[6]) }
				},

				end_col = content.col_start + curr_col + 1,
				conceal = ""
			});

			curr_col = curr_col + 1
		else
			local width, actual_width = display_width(col, config_table);
			local align = content.content_alignments[curr_tbl_col];

			if width < actual_width then
				if align == "left" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + r_num - 1, content.col_start + curr_col + width + 1, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", (actual_width - width)) }
						}
					});
				elseif align == "right" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + r_num - 1, content.col_start, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", (actual_width - width)) }
						}
					});
				else
					local before, after = math.floor((actual_width - width) / 2), math.ceil((actual_width - width) / 2);

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + r_num - 1, content.col_start + curr_col + width + 1, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", after) }
						}
					});

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + r_num - 1, content.col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", before) }
						}
					});
				end
			end

			curr_col = curr_col + vim.fn.strchars(col);
			curr_tbl_col = curr_tbl_col + 1;
		end
	end
end

renderer.namespace = vim.api.nvim_create_namespace("markview");

renderer.views = {};

--- Renderer for custom headings
---@param buffer number
---@param content any
---@param config markview.render_config.headings
renderer.render_headings = function (buffer, content, config)
	if config.enable == false then
		return;
	end

	---@type markview.render_config.headings.h
	local conf = config["heading_" .. content.level] or {};
	local shift = config.shift_width or vim.bo[buffer].shiftwidth;

	if conf.style == "simple" then
		-- Adds a simple background
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			line_hl_group = set_hl(conf.hl),

			hl_mode = "combine"
		});
	elseif conf.style == "label" then
		-- FIX: Make headings editable
		local add_spaces = vim.fn.strchars(table.concat({
			string.rep(conf.shift_char or " ", shift * (content.level - 1)),
			conf.corner_left or "",
			conf.padding_left or "",
			conf.icon or "",
		}));

		-- Adds icons, seperators, paddings etc
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, 0, {
			virt_text_pos = "overlay",
			virt_text = {
				{ string.rep(conf.shift_char or " ", shift * (content.level - 1)), conf.shift_hl },

				{ conf.corner_left or "", set_hl(conf.corner_left_hl) or set_hl(conf.hl) },
				{ conf.padding_left or "", set_hl(conf.padding_left_hl) or set_hl(conf.hl) },
				{ conf.icon or "", set_hl(conf.icon_hl) or set_hl(conf.hl) },
				{ conf.text or content.title or "", set_hl(conf.text_hl) or set_hl(conf.hl) },
				{ conf.padding_right or "", set_hl(conf.padding_right_hl) or set_hl(conf.hl) },
				{ conf.corner_right or "", set_hl(conf.corner_right_hl) or set_hl(conf.hl) },
			},

			sign_text = conf.sign, sign_hl_group = set_hl(conf.sign_hl) or set_hl(conf.hl),

			hl_mode = "combine",
		})

		-- Add extra spaces to match the virtual text
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, 0, {
			virt_text_pos = "inline",
			virt_text = { { string.rep(" ", add_spaces) } },

			end_col = content.title_pos[2] or content.col_end,
			conceal = ""
		});
	elseif conf.style == "icon" then
		-- FIX: Make headings editable
		local add_spaces = vim.fn.strchars(table.concat({
			string.rep(conf.shift_char or " ", shift * (content.level - 1)),
			conf.icon or ""
		}));

		-- Adds simple icons with paddings
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, 0, {
			virt_text_pos = "overlay",
			virt_text = {
				{ string.rep(conf.shift_char or " ", shift * (content.level - 1)), set_hl(conf.shift_hl) },

				{ conf.icon or "", set_hl(conf.icon_hl) or set_hl(conf.hl) },
				{ conf.text or content.title or "", set_hl(conf.text_hl) or set_hl(conf.hl) },
			},

			hl_mode = "combine",
		})

		-- Add extra spaces to match the virtual text
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, 0, {
			virt_text_pos = "inline",
			virt_text = { { string.rep(" ", add_spaces) } },

			end_col = content.title_pos[2] or content.col_end,
			conceal = ""
		});

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, 0, {
			line_hl_group = set_hl(conf.hl),
			sign_text = conf.sign, sign_hl_group = set_hl(conf.sign_hl),
		});
	end
end

renderer.render_headings_s = function (buffer, content, config)
	if config.enable == false then
		return;
	end

	---@type markview.render_config.headings.h
	local conf = content.marker:match("=") and config["setext_1"] or config["setext_2"];
	local shift = config.shift_width or vim.bo[buffer].shiftwidth;

	if conf.style == "simple" then
		-- Adds a simple background

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			line_hl_group = set_hl(conf.hl),

			hl_mode = "combine",
			end_row = content.row_end - 1
		});
	elseif conf.style == "github" then
		local mid = math.floor((content.row_end - content.row_start - 2) / 2);

		for i = 0, (content.row_end - content.row_start) - 1 do
			if i == mid then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + i, content.col_start, {
					virt_text_pos = "inline",
					virt_text = {
						{ conf.icon or "", set_hl(conf.icon_hl or conf.hl) }
					},

					line_hl_group = set_hl(conf.hl),
					hl_mode = "combine",
				});
			elseif i < (content.row_end - content.row_start) - 1 then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + i, content.col_start, {
					virt_text_pos = "inline",
					virt_text = {
						{ string.rep(" ", vim.fn.strchars(conf.icon or "")), set_hl(conf.hl) }
					},

					line_hl_group = set_hl(conf.hl),
					hl_mode = "combine",
				});
			else
				local line = content.marker:match("=") and (conf.line or "=") or (conf.line or "-");

				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + i, content.col_start, {
					virt_text_pos = "overlay",
					virt_text = {
						{ string.rep(line, vim.o.columns), set_hl(conf.line_hl or conf.hl) }
					},

					line_hl_group = set_hl(conf.hl),
					hl_mode = "combine",
				});
			end
		end
	end
end

--- Renderer for custom code blocks
---@param buffer number
---@param content any
---@param config_table markview.render_config.code_blocks
renderer.render_code_blocks = function (buffer, content, config_table)
	if config_table == nil or config_table.enable == false then
		return;
	end

	if config_table.style == "simple" then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			line_hl_group = set_hl(config_table.hl),

			-- NOTE: The node actually ends in the next line after the code block
			end_row = content.row_end - 1, end_col = content.col_end
		});
	elseif config_table.style == "minimal" then
		local block_length = content.largest_line;

		if type(config_table.min_width) == "number" and config_table.min_width > block_length then
			block_length = config_table.min_width
		end

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + 3 + vim.fn.strlen(content.language), {
			virt_text_pos = config_table.position or "inline",
			virt_text = {
				{ string.rep(config_table.pad_char or " ", block_length + ((config_table.pad_amount or 1) * 2)), set_hl(config_table.hl) },
			},

			hl_mode = "combine",
		});

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end - 1, content.col_start + 3, {
			virt_text_pos = config_table.position or "inline",
			virt_text = {
				{ string.rep(config_table.pad_char or " ", block_length + ((config_table.pad_amount or 1) * 2)), set_hl(config_table.hl) },
			},

			hl_mode = "combine",
		});

		-- NOTE: The last line with ``` doesn't need this so we don't add it to that line
		for line, text in ipairs(content.lines) do
			-- NOTE: Nested code blocks have a different start position
			local length = content.line_lengths[line] - content.col_start;

			vim.api.nvim_buf_add_highlight(buffer, renderer.namespace, set_hl(config_table.hl), content.row_start + line, content.col_start, -1)

			-- NOTE: If the line is smaller than the start position of the code block then subtract it
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + line, length < 0 and content.col_start + length or content.col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config_table.pad_char or " ", config_table.pad_amount or 1), set_hl(config_table.hl) }
				}
			})

			local position, reduce_cols = get_str_width(text)

			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + line, position, {
				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config_table.pad_char or " ", block_length - length - reduce_cols), set_hl(config_table.hl) },
					{ string.rep(config_table.pad_char or " ", config_table.pad_amount or 1), set_hl(config_table.hl) }
				}
			})
		end
	elseif config_table.style == "language" then
		local language = content.language;
		local icon, hl = devicons.get_icon(nil, language, { default = true });
		local block_length = content.largest_line;

		if config_table.language_names ~= nil then
			for _, lang in ipairs(config_table.language_names) do
				if language == lang[1] then
					language = lang[2];
					break;
				end
			end
		end

		if type(config_table.min_width) == "number" and config_table.min_width > block_length then
			block_length = config_table.min_width
		end

		local lang_width = vim.fn.strchars(icon .. " " .. language .. " ");

		if config_table.language_direction == nil or config_table.language_direction == "left" then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + 3 + vim.fn.strlen(content.language), {
				virt_text_pos = config_table.position or "inline",
				virt_text = {
					{ icon .. " ", set_hl(hl) },
					{ language .. " ", set_hl(config_table.name_hl) or set_hl(hl) },
					{ string.rep(config_table.pad_char or " ", block_length - lang_width + ((config_table.pad_amount or 1) * 2)), set_hl(config_table.hl) },
				},

				sign_text = config_table.sign == true and icon or nil,
				sign_hl_group = set_hl(config_table.sign_hl) or set_hl(hl),

				hl_mode = "combine",
			});
		elseif config_table.language_direction == "right" then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + 3 + vim.fn.strlen(content.language), {
				virt_text_pos = config_table.position or "inline",
				virt_text = {
					{ string.rep(config_table.pad_char or " ", block_length - lang_width + ((config_table.pad_amount or 1) * 2)), set_hl(config_table.hl) },
					{ icon .. " ", set_hl(hl) },
					{ language .. " ", set_hl(config_table.name_hl) or set_hl(hl) },
				},

				sign_text = config_table.sign == true and icon or nil,
				sign_hl_group = set_hl(config_table.sign_hl) or set_hl(hl),

				hl_mode = "combine",
			});
		end

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end - 1, content.col_start + 3, {
			virt_text_pos = config_table.position or "inline",
			virt_text = {
				{ string.rep(config_table.pad_char or " ", block_length + ((config_table.pad_amount or 1) * 2)), set_hl(config_table.hl) },
			},

			hl_mode = "combine",
		});

		-- NOTE: The last line with ``` doesn't need this so we don't add it to that line
		for line, text in ipairs(content.lines) do
			-- NOTE: Nested code blocks have a different start position
			local length = content.line_lengths[line] - content.col_start;

			vim.api.nvim_buf_add_highlight(buffer, renderer.namespace, set_hl(config_table.hl), content.row_start + line, content.col_start, -1)

			-- NOTE: If the line is smaller than the start position of the code block then subtract it
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + line, length < 0 and content.col_start + length or content.col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config_table.pad_char or " ", config_table.pad_amount or 1), set_hl(config_table.hl) }
				}
			})

			local position, reduce_cols = get_str_width(text)

			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + line, position, {
				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config_table.pad_char or " ", block_length - length - reduce_cols), set_hl(config_table.hl) },
					{ string.rep(config_table.pad_char or " ", config_table.pad_amount or 1), set_hl(config_table.hl) }
				}
			})
		end
	end
end

--- Renderer for the custom block quotes
---@param buffer number
---@param content any
---@param config_table markview.render_config.block_quotes
renderer.render_block_quotes = function (buffer, content, config_table)
	local qt_config;

	if config_table.enable == false then
		return;
	end

	if content.callout ~= nil then
		for _, callout in ipairs(config_table.callouts) do
			if type(callout.match_string) == "string" and callout.match_string:upper() == content.callout:upper() then
				qt_config = callout;
			elseif vim.islist(callout.aliases) then
				for _, alias in ipairs(callout.aliases) do
					if type(alias) == "string" and alias:upper() == content.callout.upper() then
						qt_config = callout;
					end
				end
			end
		end

		if qt_config == nil then
			qt_config = config_table.default;
		end
	else
		qt_config = config_table.default;
	end

	if qt_config.custom_title == true and content.title ~= "" then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			virt_text_pos = "inline",
			virt_text = {
				{ tbl_clamp(qt_config.border, 1), set_hl(tbl_clamp(qt_config.border_hl, 1)) },
				{ " " },
				{ qt_config.custom_icon, set_hl(qt_config.callout_preview_hl) },
				{ content.title, set_hl(qt_config.callout_preview_hl) },
			},

			end_col = content.line_width,
			conceal = ""
		});
	elseif qt_config.callout_preview ~= nil then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			virt_text_pos = "inline",
			virt_text = {
				{ tbl_clamp(qt_config.border, 1), set_hl(tbl_clamp(qt_config.border_hl, 1)) },
				{ " " },
				{ qt_config.callout_preview, set_hl(qt_config.callout_preview_hl) },
			},

			end_col = content.line_width,
			conceal = ""
		});
	else
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			virt_text_pos = "inline",
			virt_text = {
				{ tbl_clamp(qt_config.border, 1), set_hl(tbl_clamp(qt_config.border_hl, 1)) },
			},

			end_col = content.col_start + vim.fn.strchars(tbl_clamp(qt_config.border or "", 1)),
			conceal = ""
		});
	end

	for line = 1, content.row_end - content.row_start - 1 do
		local end_col = content.col_start;

		-- NOTE: If the line is smaller than the border then use the lines width
		if vim.fn.strchars(tbl_clamp(qt_config.border, 1)) > vim.fn.strchars(content.lines[line]) then
			end_col = end_col + vim.fn.strchars(content.lines[line])
		else
			end_col = end_col + vim.fn.strchars(tbl_clamp(qt_config.border, 1));
		end

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + line, content.col_start, {
			virt_text_pos = "inline",
			virt_text = {
				{ tbl_clamp(qt_config.border, line + 1), set_hl(tbl_clamp(qt_config.border_hl, line + 1)) }
			},

			end_col = end_col,
			conceal = "",

			hl_mode = "combine"
		});
	end
end

--- Renders custom horizontal rules
---@param buffer number
---@param content any
---@param config_table markview.render_config.hrs
renderer.render_horizontal_rules = function (buffer, content, config_table)
	local virt_text = {};

	if config_table.enable == false then
		return;
	end

	for _, part in ipairs(config_table.parts or {}) do
		if part.type == "repeating" then
			local repeat_time = 0;

			if type(part.repeat_amount) == "function" and pcall(part.repeat_amount --[[@as function]], buffer) then
				repeat_time = part.repeat_amount(buffer);
			elseif type(part.repeat_amount) == "number" then
				repeat_time = part.repeat_amount --[[@as number]];
			end

			if part.direction == "left" or part.direction == nil then
				for r = 1, repeat_time do
					table.insert(virt_text, {
						tbl_clamp(part.text or "─", r),
						set_hl(tbl_clamp(part.hl, r))
					})
				end
			else
				for r = 1, repeat_time do
					table.insert(virt_text, {
						-- NOTE: The value can't be 0
						tbl_clamp(part.text or "─", (repeat_time - r) + 1),
						set_hl(tbl_clamp(part.hl, (repeat_time - r) + 1))
					})
				end
			end

		elseif part.type == "text" then
			table.insert(virt_text, {
				part.text, set_hl(part.hl)
			})
		end
	end

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
		virt_text_pos = "overlay",
		virt_text = virt_text,

		end_col = vim.fn.strchars(content.text),
		conceal = ""
	});
end

--- Renderer for custom links
---@param buffer number
---@param content any
---@param config_table markview.render_config.links
renderer.render_links = function (buffer, content, config_table)
	local lnk_conf;

	if config_table.enable == false then
		return;
	end

	if content.link_type == "inline_link" then
		lnk_conf = config_table.inline_links;
	elseif content.link_type == "image" then
		lnk_conf = config_table.images;
	elseif content.link_type == "email_autolink" then
		lnk_conf = config_table.emails;
	end

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.link_type == "email_autolink" and content.col_start or content.col_start + 1, {
		virt_text_pos = "inline",
		virt_text = {
			{ lnk_conf.corner_left or "", set_hl(lnk_conf.corner_left_hl) or set_hl(lnk_conf.hl) },
			{ lnk_conf.padding_left or "", set_hl(lnk_conf.padding_left_hl) or set_hl(lnk_conf.hl) },
			{ lnk_conf.icon or "", set_hl(lnk_conf.icon_hl) or set_hl(lnk_conf.hl) },
		},

		end_col = content.link_type == "email_autolink" and content.col_start + 1 or content.col_start,
		conceal = ""
	});

	vim.api.nvim_buf_add_highlight(buffer, renderer.namespace, set_hl(lnk_conf.hl) or "", content.row_start, content.col_start, content.col_end);

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end, content.link_type == "email_autolink" and content.col_end - 1 or content.col_end, {
		virt_text_pos = "inline",
		virt_text = {
			{ lnk_conf.padding_right or "", set_hl(lnk_conf.padding_right_hl) or set_hl(lnk_conf.hl) },
			{ lnk_conf.corner_right or "", set_hl(lnk_conf.corner_right_hl) or set_hl(lnk_conf.hl) },
		},

		end_col = content.link_type == "email_autolink" and content.col_end or content.col_start,
		conceal = ""
	});
end

--- Renderer for custom inline codes
---@param buffer number
---@param content any
---@param config_table markview.render_config.inline_codes
renderer.render_inline_codes = function (buffer, content, config_table)
	if config_table.enable == false then
		return;
	end

	-- NOTE: The ` are hidden by default
	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + 1, {
		virt_text_pos = "inline",
		virt_text = {
			{ config_table.corner_left or "", set_hl(config_table.corner_left_hl) or set_hl(config_table.hl) },
			{ config_table.padding_left or "", set_hl(config_table.padding_left_hl) or set_hl(config_table.hl) },
		},
	});

	vim.api.nvim_buf_add_highlight(buffer, renderer.namespace, set_hl(config_table.hl), content.row_start, content.col_start, content.col_end);

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_end - 1, {
		virt_text_pos = "inline",
		virt_text = {
			{ config_table.padding_right or "", set_hl(config_table.padding_right_hl) or set_hl(config_table.hl) },
			{ config_table.corner_right or "", set_hl(config_table.corner_right_hl) or set_hl(config_table.hl) },
		},
	});
end

--- Renderer for custom image links
---@param buffer number
---@param content any
---@param config_table markview.render_config.list_items
renderer.render_lists = function (buffer, content, config_table)
	if config_table.enable == false then
		return;
	end

	local ls_conf = {};

	if string.match(content.marker_symbol, "-") then
		ls_conf = config_table.marker_minus or {};
	elseif string.match(content.marker_symbol, "+") then
		ls_conf = config_table.marker_plus or {};
	elseif string.match(content.marker_symbol, "*") then
		ls_conf = config_table.marker_star or {};
	elseif string.match(content.marker_symbol, "[.]") then
		ls_conf = config_table.marker_dot or {};
	end

	local use_text = ls_conf.text or content.marker_symbol;

	if ls_conf.add_padding == true then
		local shift = config_table.shift_width or vim.bo[buffer].shiftwidth;

		for l, line in ipairs(content.list_lines) do
			local line_num = content.row_start + (l - 1);
			local before = content.spaces[l] or 0;

			if vim.list_contains(content.list_candidates, l) and l == 1 then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, line_num, 0, {
					virt_text_pos = "inline",
					virt_text = {
						{ string.rep(" ", (math.floor(before / 2) + 1) * shift) },
						{ vim.trim(use_text), set_hl(ls_conf.hl) or "Special" }
					},

					end_col = content.col_start + vim.fn.strchars(content.marker_symbol),
					conceal = " "
				})
			elseif vim.list_contains(content.list_candidates, l) then
				local line_len = vim.fn.strchars(line);

				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, line_num, 0, {
					virt_text_pos = "inline",
					virt_text = {
						{ string.rep(" ", (math.floor(before / 2) + 1) * shift) }
					},

					end_col = line_len < before and line_len or before,
					conceal = ""
				})
			end
		end
	else
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ vim.trim(use_text), set_hl(ls_conf.hl) or "Special" }
			}
		})
	end
end

--- Renderer for custom checkbox
---@param buffer number
---@param content any
---@param config_table markview.render_config.checkboxes
renderer.render_checkboxes = function (buffer, content, config_table)
	if config_table.enable == false then
		return;
	end

	local chk_config = {};

	if content.state == "complete" then
		chk_config = config_table.checked;
	elseif content.state == "incomplete" then
		chk_config = config_table.unchecked;
	elseif content.state == "pending" then
		chk_config = config_table.pending;
	end

	if type(chk_config.text) ~= "string" then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
		virt_text_pos = "inline",
		virt_text = {
			{ chk_config.text, set_hl(chk_config.hl) }
		},

		end_col = content.col_end,
		conceal = "",

		hl_mode = "combine"
	});
end

--- Renderer for custom table
---@param buffer number
---@param content any
---@param user_config markview.config
renderer.render_tables = function (buffer, content, user_config)
	if user_config.tables == nil or user_config.tables.enable == false then
		return;
	end

	for row_number, _ in ipairs(content.rows) do
		if content.row_type[row_number] == "header" then
			table_header(buffer, content, user_config);
		elseif content.row_type[row_number] == "seperator" then
			table_seperator(buffer, content, user_config, row_number)
		elseif content.row_type[row_number] == "content" and row_number == #content.rows then
			table_footer(buffer, content, user_config)
		else
			table_content(buffer, content, user_config, row_number)
		end
	end
end




--- CursorMove listener
renderer.autocmd = nil;

renderer.create_autocmd = function (config_table)
	if renderer.autocmd then
		return;
	end

	local events = { "CursorMovedI" };

	-- if config_table.modes and vim.list_contains(config_table.modes, "i") then
	-- 	table.insert(events, "CursorMovedI");
	-- end

	renderer.autocmd = vim.api.nvim_create_autocmd(events, {
		pattern = config_table.filetypes or "*.md", -- Currently only for markdown
		callback = function (event)
			local buffer = event.buf;
			local mode = vim.api.nvim_get_mode().mode;

			if not vim.list_contains(config_table.modes or {}, mode) then
				return;
			end

			renderer.render_deleted_items(buffer, config_table);
			renderer.removed_elements[buffer] = {};

			if not vim.list_contains(config_table.special_modes or { "i" }, mode) then
				return;
			end

			-- This is for testing purposes
			local cursor = vim.api.nvim_win_get_cursor(0);
			local comps = {};

			for _, component in ipairs(_G.__markview_views[buffer] or {}) do
				if (cursor[1] - 1) >= component.row_start and cursor[1] - 1 <= component.row_end then
					table.insert(comps, component);
					table.insert(renderer.removed_elements[buffer], component);
				end
			end

			renderer.destroy(buffer)
		end
	})
end

renderer.destroy = function (buffer)
	-- if not renderer.removed_elements or not renderer.removed_elements[buffer] or vim.tbl_isempty(renderer.removed_elements[buffer]) then
	-- 	return;
	-- end
	--
	-- local max_range = {};
	--
	-- for _, content in ipairs(renderer.removed_elements[buffer]) do
	-- 	if not max_range[1] or content.row_start < max_range[1] then
	-- 		max_range[1] = content.row_start;
	-- 	end
	--
	-- 	if not max_range[2] or content.row_end > max_range[2] then
	-- 		max_range[2] = content.row_end;
	-- 	end
	-- end
	--
	-- vim.api.nvim_buf_clear_namespace(buffer, renderer.namespace, max_range[1], max_range[2] + 1);
end

renderer.render_deleted_items = function (buffer, config_table)
	if not renderer.removed_elements[buffer] then
		return;
	end

	for _, content in ipairs(renderer.removed_elements[buffer]) do
		local type = content.type;
		local fold_closed = vim.fn.foldclosed(content.row_start + 1);

		if fold_closed ~= -1 then
			goto extmark_skipped;
		end


		if type == "heading_s" then
			renderer.render_headings_s(buffer, content, config_table.headings);
		elseif type == "heading" then
			renderer.render_headings(buffer, content, config_table.headings)
		elseif type == "code_block" then
			renderer.render_code_blocks(buffer, content, config_table.code_blocks)
		elseif type == "block_quote" then
			renderer.render_block_quotes(buffer, content, config_table.block_quotes);
		elseif type == "horizontal_rule" then
			renderer.render_horizontal_rules(buffer, content, config_table.horizontal_rules);
		elseif type == "link" then
			renderer.render_links(buffer, content, config_table.links);
		elseif type == "image" then
			renderer.render_links(buffer, content, config_table.images);
		elseif type == "inline_code" then
			renderer.render_inline_codes(buffer, content, config_table.inline_codes)
		elseif type == "list_item" then
			renderer.render_lists(buffer, content, config_table.list_items)
		elseif type == "checkbox" then
			renderer.render_checkboxes(buffer, content, config_table.checkboxes)
		elseif type == "table" then
			renderer.render_tables(buffer, content, config_table)
		end

		::extmark_skipped::
	end
end

renderer.render = function (buffer, parsed_content, config_table, conceal_start, conceal_stop)
	if not _G.__markview_views then
		_G.__markview_views = {};
	end

	if parsed_content ~= nil then
		_G.__markview_views[buffer] = parsed_content;
	end

	for _, content in ipairs(_G.__markview_views[buffer]) do
		local type = content.type;
		local fold_closed = vim.fn.foldclosed(content.row_start + 1);

		if fold_closed ~= -1 then
			goto extmark_skipped;
		end

		-- if conceal_start and conceal_stop and content.row_start >= conceal_start and content.row_end <= conceal_stop then
		-- 	goto extmark_skipped;
		-- end

		if type == "heading_s" then
			renderer.render_headings_s(buffer, content, config_table.headings);
		elseif type == "heading" then
			renderer.render_headings(buffer, content, config_table.headings)
		elseif type == "code_block" then
			renderer.render_code_blocks(buffer, content, config_table.code_blocks)
		elseif type == "block_quote" then
			renderer.render_block_quotes(buffer, content, config_table.block_quotes);
		elseif type == "horizontal_rule" then
			renderer.render_horizontal_rules(buffer, content, config_table.horizontal_rules);
		elseif type == "link" then
			renderer.render_links(buffer, content, config_table.links);
		elseif type == "image" then
			renderer.render_links(buffer, content, config_table.images);
		elseif type == "inline_code" then
			renderer.render_inline_codes(buffer, content, config_table.inline_codes)
		elseif type == "list_item" then
			renderer.render_lists(buffer, content, config_table.list_items)
		elseif type == "checkbox" then
			renderer.render_checkboxes(buffer, content, config_table.checkboxes)
		elseif type == "table" then
			renderer.render_tables(buffer, content, config_table)
		end

		::extmark_skipped::
	end
end

renderer.clear = function (buffer)
	vim.api.nvim_buf_clear_namespace(buffer, renderer.namespace, 0, -1)
end

renderer.clear_under_cursor = function (buffer, cursor)
	if not _G.__markview_views[buffer] then
		return;
	elseif not renderer.removed_elements then
		renderer.removed_elements = {};
	end

	if not renderer.removed_elements[buffer] then
		renderer.removed_elements[buffer] = {};
	end

	renderer.clear_elements(buffer, cursor);
end

renderer.render_partial = function (buffer, partial_contents, config_table, conceal_start, conceal_stop)
	-- if not renderer.removed_elements[buffer] then
	-- 	return
	-- end

	for _, content in ipairs(partial_contents) do
		local type = content.type;
		local fold_closed = vim.fn.foldclosed(content.row_start + 1);

		if fold_closed ~= -1 then
			goto extmark_skipped;
		end

		if content.row_start >= conceal_start and content.row_end <= conceal_stop then
			goto extmark_skipped;
		end


		if type == "heading_s" then
			renderer.render_headings_s(buffer, content, config_table.headings);
		elseif type == "heading" then
			renderer.render_headings(buffer, content, config_table.headings)
		elseif type == "code_block" then
			renderer.render_code_blocks(buffer, content, config_table.code_blocks)
		elseif type == "block_quote" then
			renderer.render_block_quotes(buffer, content, config_table.block_quotes);
		elseif type == "horizontal_rule" then
			renderer.render_horizontal_rules(buffer, content, config_table.horizontal_rules);
		elseif type == "link" then
			renderer.render_links(buffer, content, config_table.links);
		elseif type == "image" then
			renderer.render_links(buffer, content, config_table.images);
		elseif type == "inline_code" then
			renderer.render_inline_codes(buffer, content, config_table.inline_codes)
		elseif type == "list_item" then
			renderer.render_lists(buffer, content, config_table.list_items)
		elseif type == "checkbox" then
			renderer.render_checkboxes(buffer, content, config_table.checkboxes)
		elseif type == "table" then
			renderer.render_tables(buffer, content, config_table)
		end

		::extmark_skipped::
	end
end

renderer.update = function (buffer, parsed_content)
	if not _G.__markview_views then
		_G.__markview_views = {};
	end

	if parsed_content ~= nil then
		_G.__markview_views[buffer] = parsed_content;
	end
end

renderer.clear_partial_range = function (buffer, parsed_content)
	local max_range = { nil, nil };

	for _, content in ipairs(parsed_content) do
		if not max_range[1] or (content.row_start) < max_range[1] then
			max_range[1] = content.row_start;
		end

		if not max_range[2] or (content.row_end) > max_range[2] then
			max_range[2] = content.row_end;
		end
	end

	if not max_range[1] or not max_range[2] then
		return;
	end

	if max_range[1] == max_range[2] then
		max_range[2] = max_range[2] + 1;
	end

	if not _G.__markview_render_ranges then
		_G.__markview_render_ranges = {};
	end

	_G.__markview_render_ranges[buffer] = max_range;
	vim.api.nvim_buf_clear_namespace(buffer, renderer.namespace, max_range[1], max_range[2]);
end

return renderer;
