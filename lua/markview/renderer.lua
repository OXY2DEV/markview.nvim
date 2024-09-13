local renderer = {};
local devicons_loaded, devicons = pcall(require, "nvim-web-devicons");

local utils = require("markview.utils");
local entites = require("markview.entites");
local languages = require("markview.languages");
local latex_renderer = require("markview.latex_renderer");

renderer.get_icon = function (language, config_table)
	if config_table.icons == false then
		return "", "Normal";
	end

	if devicons_loaded then
		return devicons.get_icon(nil, language, { default = true })
	end

	return "󰡯", "Normal";
end

_G.__markview_views = {};

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

-- NOTE: Table cells with list chars in a link or image are overindented
local sub_indent_chars = function(text)
	return text:gsub("[+-*]", " ")
end

local display_width = function (text, config)
	local d_width = vim.fn.strdisplaywidth(text);
	local inl_conf = config.inline_codes;

	local final_string = sub_indent_chars(text);

	for escaped_char in final_string:gmatch("\\([\\%.%*%_%{%}%[%]%<%>%(%)%#%+%-%`%!%|%$])") do
		if config.escaped ~= nil and config.escaped.enable ~= false then
			final_string = final_string:gsub("\\" .. escaped_char, " ");
			d_width = d_width - 1;
		else
			final_string = final_string:gsub("\\" .. escaped_char, "  ");
		end
	end

	for inline_code in final_string:gmatch("`([^`]+)`") do
		d_width = d_width - (vim.fn.strdisplaywidth("`" .. inline_code .. "`"));

		if inl_conf ~= nil and inl_conf.enable ~= false then
			d_width = d_width + vim.fn.strdisplaywidth(table.concat({
				inl_conf.corner_left or "",
				inl_conf.padding_left or "",

				inline_code or "",

				inl_conf.padding_right or "",
				inl_conf.corner_right or ""
			}));

			local escaped = inline_code:gsub("%p", "%%%1");

			final_string = final_string:gsub("`" .. escaped .. "`", table.concat({
				inl_conf.corner_left or "",
				inl_conf.padding_left or "",

				inline_code:gsub(".", "|"),

				inl_conf.padding_right or "",
				inl_conf.corner_right or ""
			}));
		end
	end

	local lnk_conf = config.links ~= nil and config.links.hyperlinks or nil;
	---@type markview.render_config.links.link?
	local img_conf = config.links ~= nil and config.links.images or nil;
	local email_conf = config.links ~= nil and config.links.emails or nil;

	--- Image link(normal)
	for link, address in final_string:gmatch("!%[([^%]]+)%]%(([^%)]+)%)") do
		if not img_conf then
			break;
		end

		d_width = d_width - vim.fn.strdisplaywidth("![" .. "](" .. address .. ")");

		d_width = d_width + vim.fn.strdisplaywidth(table.concat({
			img_conf.corner_left or "",
			img_conf.padding_left or "",
			img_conf.icon or "",
			img_conf.padding_right or "",
			img_conf.corner_right or ""
		}));

		final_string = final_string:gsub("!%[" .. link .. "%]%(" .. address .. "%)", table.concat({
			img_conf.corner_left or "",
			img_conf.padding_left or "",
			img_conf.icon or "",
			link,
			img_conf.padding_right or "",
			img_conf.corner_right or ""
		}));
	end

	-- Image link: labels
	for link, address in final_string:gmatch("!%[([^%]]+)%]%[([^%)]+)%]") do
		if not img_conf then
			break;
		end

		d_width = d_width - vim.fn.strdisplaywidth("![" .. "][" .. address .. "]");

		d_width = d_width + vim.fn.strdisplaywidth(table.concat({
			img_conf.corner_left or "",
			img_conf.padding_left or "",
			img_conf.icon or "",
			img_conf.padding_right or "",
			img_conf.corner_right or ""
		}));

		final_string = final_string:gsub("!%[" .. link .. "%]%[" .. address .. "%]", table.concat({
			img_conf.corner_left or "",
			img_conf.padding_left or "",
			img_conf.icon or "",
			link,
			img_conf.padding_right or "",
			img_conf.corner_right or ""
		}));
	end

	-- Hyperlinks: normal
	for link, address in final_string:gmatch("%[([^%]]+)%]%(([^%)]+)%)") do
		local cnf = lnk_conf;

		for _, conf in ipairs(config.links.hyperlinks.custom or {}) do
			if conf.match and string.match(address or "", conf.match) then
				cnf = conf
			end
		end

		d_width = d_width - vim.fn.strdisplaywidth("[" .. "](" .. address .. ")");

		if cnf and lnk_conf and lnk_conf.enable ~= false then
			d_width = d_width + vim.fn.strdisplaywidth(table.concat({
				cnf.corner_left or "",
				cnf.padding_left or "",
				cnf.icon or "",
				cnf.padding_right or "",
				cnf.corner_right or ""
			}));

			final_string = final_string:gsub("%[" .. link .. "%]%(" .. address .. "%)", table.concat({
				cnf.corner_left or "",
				cnf.padding_left or "",
				cnf.icon or "",
				link,
				cnf.padding_right or "",
				cnf.corner_right or ""
			}));
		end
	end

	-- Hyperlink: full_reference_link
	for link, address in final_string:gmatch("[^!]%[([^%]]+)%]%[([^%]]+)%]") do
		local cnf = lnk_conf;

		for _, conf in ipairs(config.links.hyperlinks.custom or {}) do
			if conf.match and string.match(address or "", conf.match) then
				cnf = conf
			end
		end

		d_width = d_width - vim.fn.strdisplaywidth("[" .. "][" .. address .. "]");

		if cnf ~= nil and lnk_conf and lnk_conf.enable ~= false then
			d_width = d_width + vim.fn.strdisplaywidth(table.concat({
				cnf.corner_left or "",
				cnf.padding_left or "",
				cnf.icon or "",
				cnf.padding_right or "",
				cnf.corner_right or ""
			}));

			final_string = final_string:gsub("%[" .. link .. "%]%[" .. address .. "%]", table.concat({
				cnf.corner_left or "",
				cnf.padding_left or "",
				cnf.icon or "",
				link,
				cnf.padding_right or "",
				cnf.corner_right or ""
			}));
		end
	end

	for pattern in final_string:gmatch("%[([^%]]+)%]") do
		d_width = d_width - 2;
		final_string = final_string:gsub( "[" .. pattern .. "]", pattern);
	end

	for str_a, internal, str_b in final_string:gmatch("([*]+)([^*]+)([*]+)") do
		local min_signs = vim.fn.strdisplaywidth(str_a) > vim.fn.strdisplaywidth(str_b) and vim.fn.strdisplaywidth(str_a) or vim.fn.strdisplaywidth(str_b);

		local start_pos, _ = final_string:find("([*]+)[^*]+([*]+)");

		local c_before = final_string:sub(start_pos - 1, start_pos - 1);
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

				final_string = final_string:gsub(a .. internal .. b, internal);
			end
		end

		::invalid::
	end

	for username, domain, tdl in final_string:gmatch("<([%w._%+-]+)@([%w.-]+)%.([%w.-]+)>") do
		d_width = d_width - vim.fn.strdisplaywidth("<" .. ">");

		if email_conf ~= nil and email_conf.enable ~= false then
			d_width = d_width + vim.fn.strdisplaywidth(table.concat({
				email_conf.corner_left or "",
				email_conf.padding_left or "",
				email_conf.icon or "",
				email_conf.padding_right or "",
				email_conf.corner_right or ""
			}));

			final_string = final_string:gsub("<" .. username .. "@" .. domain .. "." .. tdl .. ">", table.concat({
				email_conf.corner_left or "",
				email_conf.padding_left or "",
				email_conf.icon or "",

				username, "@", domain, ".", tdl,

				email_conf.padding_right or "",
				email_conf.corner_right or ""
			}));
		end
	end

	local tmp_string = final_string;
	local iterations = 1;

	local html_conf = config.html;

	while tmp_string:match("<([^>]+)>") do
		-- This shouldn't run so many times
		if not html_conf or html_conf.enable == false then
			break;
		elseif not html_conf.tags or html_conf.tags.enable == false then
			break;
		elseif iterations > 10 then
			break;
		else
			iterations = iterations + 1;
		end

		local start_tag = tmp_string:match("<([^>]+)>");
		local s_tag_start, _ = tmp_string:find("<([^>]+)>");

		--- Only allow, a-z, A-Z, - & _
		local filtered_tag = start_tag:match("[%a%d%-%_]+");

		-- No close tag
		if not tmp_string:match("</" .. filtered_tag .. ">") then
			goto invalid;
		end

		local end_tag = tmp_string:match("</(" .. filtered_tag .. ")>");
		local e_tag_start, _ = tmp_string:find("</" .. filtered_tag .. ">");

		-- Close tag before opening tag
		if e_tag_start < s_tag_start then
			goto invalid;
		end

		local tag_conf = html_conf.tags;
		local conf = tag_conf.default or {};

		if tag_conf.configs and tag_conf.configs[string.lower(filtered_tag)] then
			conf = tag_conf.configs[string.lower(filtered_tag)]
		end

		local internal_text = tmp_string:match("<" .. start_tag .. ">(.-)</" .. end_tag .. ">") or "";

		-- Tag isn't concealed
		if conf.conceal ~= false then
			final_string = final_string:gsub("<" .. start_tag .. ">" .. internal_text .. "</" .. end_tag .. ">", internal_text)
			d_width = d_width - vim.fn.strdisplaywidth("<" .. start_tag .. ">" .. "</" .. end_tag .. ">", internal_text);
		end

		tmp_string = tmp_string:gsub("<" .. start_tag .. ">" .. internal_text .. "</" .. end_tag .. ">", internal_text)

		::invalid::
	end

	for entity_name, semicolon in final_string:gmatch("&([%a%d]+)(;?)") do
		if not html_conf or html_conf.enable == false then
			break;
		elseif not html_conf.entites or html_conf.entites.enable == false then
			break;
		end

		local entity = entites.get(entity_name);

		if not entity then
			goto invalid;
		end

		if semicolon then
			final_string = final_string:gsub("&" .. entity_name .. ";", entity);

			d_width = d_width - vim.fn.strdisplaywidth("&" .. entity_name .. ";");
			d_width = d_width + vim.fn.strdisplaywidth(entity);
		else
			final_string = final_string:gsub("&" .. entity_name, entity);

			d_width = d_width - vim.fn.strdisplaywidth("&" .. entity_name);
			d_width = d_width + vim.fn.strdisplaywidth(entity);
		end

		::invalid::
	end

	return d_width, vim.fn.strdisplaywidth(text), final_string;
end


--- Renderer for table headers
---@param buffer number
---@param content any
---@param config_table markview.config
local table_header = function (buffer, content, config_table)
	local tbl_conf = config_table.tables;
	--- Border structure
	--- 1. ╭ 2. ─ 3. ╮ 4. ┬
	--- 5. │ 6. │ 7. │ 8. ╼

	local row_start = content.__r_start or content.row_start;
	local col_start = content.col_start;

	local curr_col = 0;
	local curr_tbl_col = 1;

	local virt_txt = {};

	if content.content_positions and content.content_positions[1] then
		table.insert(virt_txt, { string.rep(" ", content.content_positions[1].col_start) })
		col_start = content.content_positions[1].col_start;
	end

	for index, col in ipairs(content.rows[1]) do
		if index == 1 then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start, col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[5], set_hl(tbl_conf.hl[5]) }
				},

				end_col = col_start + 1,
				conceal = ""
			});

			table.insert(virt_txt, { tbl_conf.text[1], set_hl(tbl_conf.hl[1]) })
			curr_col = curr_col + 1
		elseif index == #content.rows[1] then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start, col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[7], set_hl(tbl_conf.hl[7]) }
				},

				end_col = col_start + curr_col + 1,
				conceal = ""
			});

			table.insert(virt_txt, { tbl_conf.text[3], set_hl(tbl_conf.hl[3]) })

			if tbl_conf.block_decorator ~= false and config_table.tables.use_virt_lines == true then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start, 0, {
					virt_lines_above = true,
					virt_lines = {
						virt_txt
					}
				});
			elseif tbl_conf.block_decorator ~= false and row_start > 0 then
				-- BUG: Nearby tables can cause text to overlap
				vim.api.nvim_buf_clear_namespace(buffer, renderer.namespace, row_start - 1, row_start);

				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start - 1, 0, {
					virt_text_pos = "inline",
					virt_text = virt_txt
				});
			end

			curr_col = curr_col + 1
		elseif col == "|" then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start, col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[6], set_hl(tbl_conf.hl[6]) }
				},

				end_col = col_start + curr_col + 1,
				conceal = ""
			});

			table.insert(virt_txt, { tbl_conf.text[4], set_hl(tbl_conf.hl[4]) })
			curr_col = curr_col + 1
		else
			local width, actual_width = display_width(col, config_table);
			local align = content.content_alignments[curr_tbl_col];

			-- Extracted width of separator
			local tbl_col_width = content.col_widths[curr_tbl_col];

			-- The column number of headers must match the 
			-- column number of separators
			--
			-- No need to add unnecessary condition
			if tbl_col_width then
				actual_width = math.min(math.max(actual_width, tbl_col_width), tbl_col_width);
			end

			if width < actual_width then
				if align == "left" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start, col_start + curr_col + #col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", (actual_width - width)) }
						}
					});
				elseif align == "right" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start, col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", (actual_width - width)) }
						}
					});
				else
					local before, after = math.floor((actual_width - width) / 2), math.ceil((actual_width - width) / 2);

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start, col_start + curr_col + #col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", after) }
						}
					});

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start, col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", before) }
						}
					});
				end
			end

			table.insert(virt_txt, { string.rep(tbl_conf.text[2], actual_width), set_hl(tbl_conf.hl[2]) })
			curr_col = curr_col + #col;
			curr_tbl_col = curr_tbl_col + 1;
		end
	end
end

--- Renderer for table separator
---@param buffer number
---@param content any
---@param user_config markview.config
---@param r_num number
local table_seperator = function (buffer, content, user_config, r_num)
	local tbl_conf = user_config.tables;
	--- Border structure
	--- 9. ├ 10. ┼ 11. ┤ 12. │ 13. ╴ 14.╶

	local row_start = content.__r_start or content.row_start;
	local col_start = content.col_start;

	local curr_col = 0;
	local curr_tbl_col = 1;

	if content.content_positions and content.content_positions[r_num] then
		col_start = content.content_positions[r_num].col_start;
	end

	for index, col in ipairs(content.rows[r_num]) do
		if index == 1 then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + (r_num - 1), col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[9], set_hl(tbl_conf.hl[9]) }
				},

				end_col = col_start + 1,
				conceal = ""
			});

			curr_col = curr_col + 1;
		elseif index == #content.rows[1] then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + (r_num - 1), col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[11], set_hl(tbl_conf.hl[11]) }
				},

				end_col = col_start + curr_col + 1,
				conceal = ""
			});

			curr_col = curr_col + 1;
		elseif col == "|" then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + (r_num - 1), col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[10], set_hl(tbl_conf.hl[10]) }
				},

				end_col = col_start + curr_col + 1,
				conceal = ""
			});

			curr_col = curr_col + 1;
		else
			local align = content.content_alignments[curr_tbl_col];

			if col:match(":") then
				if align == "left" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + (r_num - 1), col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ tbl_conf.text[8], set_hl(tbl_conf.hl[8]) },
							{ string.rep(tbl_conf.text[12], vim.fn.strchars(col) - 1), set_hl(tbl_conf.hl[12]) }
						},

						end_col = col_start + curr_col + vim.fn.strchars(col) + 1,
						conceal = ""
					});
				elseif align == "right" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + (r_num - 1), col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(tbl_conf.text[12], vim.fn.strchars(col) - 1), set_hl(tbl_conf.hl[12]) },
							{ tbl_conf.text[18], set_hl(tbl_conf.hl[18]) }
						},

						end_col = col_start + curr_col + vim.fn.strchars(col) + 1,
						conceal = ""
					});
				elseif align == "center" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + (r_num - 1), col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ tbl_conf.text[13], set_hl(tbl_conf.hl[13]) },
							{ string.rep(tbl_conf.text[12], vim.fn.strchars(col) - 2), set_hl(tbl_conf.hl[12]) },
							{ tbl_conf.text[14], set_hl(tbl_conf.hl[14]) }
						},

						end_col = col_start + curr_col + vim.fn.strchars(col) + 1,
						conceal = ""
					});
				end
			else
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + (r_num - 1), col_start + curr_col, {
					virt_text_pos = "inline",
					virt_text = {
						{ string.rep(tbl_conf.text[12], vim.fn.strchars(col)), set_hl(tbl_conf.hl[12]) }
					},

					end_col = col_start + curr_col + vim.fn.strchars(col) + 1,
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
	--- Border structure
	--- 15. │ 16. │ 17. │ 18. ╾
	--- 19. ╰ 20. ─ 21. ╯ 22. ┴

	local row_end = content.__r_end or content.row_end;
	local col_start = content.col_start;

	local curr_col = 0;
	local curr_tbl_col = 1;

	local virt_txt = {};

	if content.content_positions and content.content_positions[#content.content_positions] then
		table.insert(virt_txt, { string.rep(" ", content.content_positions[#content.content_positions].col_start) })
		col_start = content.content_positions[#content.content_positions].col_start;
	end

	for index, col in ipairs(content.rows[#content.rows]) do
		if index == 1 then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_end - 1, col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[15], set_hl(tbl_conf.hl[15]) }
				},

				end_col = col_start + 1,
				conceal = ""
			});

			table.insert(virt_txt, { tbl_conf.text[19], set_hl(tbl_conf.hl[19]) })
			curr_col = curr_col + 1
		elseif index == #content.rows[#content.rows] then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_end - 1, col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[17], set_hl(tbl_conf.hl[17]) }
				},

				end_col = col_start + curr_col + 1,
				conceal = ""
			});

			table.insert(virt_txt, { tbl_conf.text[21], set_hl(tbl_conf.hl[21]) })

			if tbl_conf.block_decorator ~= false and config_table.tables.use_virt_lines == true then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_end - 1, 0, {
					virt_lines_above = false,
					virt_lines = {
						virt_txt
					}
				});
			elseif tbl_conf.block_decorator ~= false and content.row_start < vim.api.nvim_buf_line_count(buffer) then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_end, 0, {
					virt_text_pos = "inline",
					virt_text = virt_txt
				});
			end

			curr_col = curr_col + 1
		elseif col == "|" then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_end - 1, col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[16], set_hl(tbl_conf.hl[16]) }
				},

				end_col = col_start + curr_col + 1,
				conceal = ""
			});

			table.insert(virt_txt, { tbl_conf.text[22], set_hl(tbl_conf.hl[22]) })
			curr_col = curr_col + 1
		else
			local width, actual_width = display_width(col, config_table);
			local align = content.content_alignments[curr_tbl_col];

			-- Extracted width of separator
			local tbl_col_width = content.col_widths[curr_tbl_col];

			if #content.rows[#content.rows] == #content.rows[2] and tbl_col_width then
				actual_width = math.min(math.max(actual_width, tbl_col_width), tbl_col_width);
			end

			if width < actual_width then
				if align == "left" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_end - 1, col_start + curr_col + #col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", (actual_width - width)) }
						}
					});
				elseif align == "right" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_end - 1, col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", (actual_width - width)) }
						}
					});
				else
					local before, after = math.floor((actual_width - width) / 2), math.ceil((actual_width - width) / 2);

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_end - 1, col_start + curr_col + #col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", after) }
						}
					});

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_end - 1, col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", before) }
						}
					});
				end
			end

			table.insert(virt_txt, { string.rep(tbl_conf.text[20], actual_width), set_hl(tbl_conf.hl[20]) })
			curr_col = curr_col + #col;
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
	--- Border structure
	--- 15. │ 16. │ 17. │ 18. ╾

	local row_start = content.__r_start or content.row_start;
	local col_start = content.col_start;

	local curr_col = 0;
	local curr_tbl_col = 1;

	if content.content_positions and content.content_positions[r_num] then
		col_start = content.content_positions[r_num].col_start;
	end

	for index, col in ipairs(content.rows[r_num]) do
		if index == 1 then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + r_num - 1, col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[15], set_hl(tbl_conf.hl[15]) }
				},

				end_col = col_start + 1,
				conceal = ""
			});

			curr_col = curr_col + 1
		elseif index == #content.rows[1] then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + r_num - 1, col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[17], set_hl(tbl_conf.hl[17]) }
				},

				end_col = col_start + curr_col + 1,
				conceal = ""
			});

			curr_col = curr_col + 1
		elseif col == "|" then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + r_num - 1, col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ tbl_conf.text[16], set_hl(tbl_conf.hl[16]) }
				},

				end_col = col_start + curr_col + 1,
				conceal = ""
			});

			curr_col = curr_col + 1
		else
			local width, actual_width = display_width(col, config_table);
			local align = content.content_alignments[curr_tbl_col];

			-- Extracted width of separator
			local tbl_col_width = content.col_widths[curr_tbl_col];

			if #content.rows[r_num] == #content.rows[2] and tbl_col_width then
				actual_width = math.min(math.max(actual_width, tbl_col_width), tbl_col_width);
			end

			if width < actual_width then
				if align == "left" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + r_num - 1, col_start + curr_col + #col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", (actual_width - width)) }
						}
					});
				elseif align == "right" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + r_num - 1, col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", (actual_width - width)) }
						}
					});
				else
					local before, after = math.floor((actual_width - width) / 2), math.ceil((actual_width - width) / 2);

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + r_num - 1, col_start + curr_col + #col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", after) }
						}
					});

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + r_num - 1, col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", before) }
						}
					});
				end
			end

			curr_col = curr_col + #col;
			curr_tbl_col = curr_tbl_col + 1;
		end
	end
end

renderer.namespace = vim.api.nvim_create_namespace("markview");
latex_renderer.set_namespace(renderer.namespace);

renderer.views = {};

--- Renderer for custom headings
---@param buffer number
---@param content any
---@param config markview.render_config.headings
renderer.render_headings = function (buffer, content, config)
	if not config or config.enable == false then
		return;
	end

	---@type markview.render_config.headings.h
	local conf = config["heading_" .. content.level] or {};
	local shift = config.shift_width or vim.bo[buffer].shiftwidth;

	-- Do not proceed if config doesn't exist for a heading
	if not conf then
		return;
	end

	if conf.style == "simple" then
		-- Adds a simple background
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			line_hl_group = set_hl(conf.hl),

			hl_mode = "combine"
		});
	elseif conf.style == "label" then
		local conceal_start = string.match(content.line, "^[#]+(%s*)");
		local line_length = #content.line;

		local spaces = shift * (content.level - 1);

		if conf.align then
			if conf.align == "left" then
				spaces = 0;
			elseif conf.align == "center" then
				local win = utils.find_attached_wins(buffer)[1] or vim.api.nvim_get_current_win();
				local textoff = config.textoff or vim.fn.getwininfo(win)[1].textoff;

				local w = vim.api.nvim_win_get_width(win) - textoff;

				local t = vim.fn.strdisplaywidth(table.concat({
					conf.corner_left or "",
					conf.padding_left or "",
					conf.icon or "",

					content.title,

					conf.padding_right or "",
					conf.corner_right or "",
				}));

				spaces = math.floor((w - t) / 2);
			else
				local win = utils.find_attached_wins(buffer)[1] or vim.api.nvim_get_current_win();
				local textoff = config.textoff or vim.fn.getwininfo(win)[1].textoff;

				local w = vim.api.nvim_win_get_width(win) - textoff;

				local t = vim.fn.strdisplaywidth(table.concat({
					conf.corner_left or "",
					conf.padding_left or "",
					conf.icon or "",

					content.title,

					conf.padding_right or "",
					conf.corner_right or "",
				}));

				spaces = w - t;
			end
		end

		-- Heading rules
		-- 1. Must start at the first column
		-- 2. Must have 1 space between the marker and the title
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			virt_text_pos = "inline",
			virt_text = {
				{ string.rep(conf.shift_char or " ", spaces), conf.shift_hl },

				{ conf.corner_left or "", set_hl(conf.corner_left_hl) or set_hl(conf.hl) },
				{ conf.padding_left or "", set_hl(conf.padding_left_hl) or set_hl(conf.hl) },
				{ conf.icon or "", set_hl(conf.icon_hl) or set_hl(conf.hl) }
			},

			sign_text = conf.sign, sign_hl_group = set_hl(conf.sign_hl),
			hl_mode = "combine",

			end_col = content.level + vim.fn.strchars(conceal_start),
			conceal = ""
		});

		vim.api.nvim_buf_add_highlight(buffer, renderer.namespace, set_hl(conf.hl), content.row_start, 0, line_length);

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, line_length, {
			virt_text_pos = "overlay",
			virt_text = {
				{ conf.padding_right or "", set_hl(conf.padding_right_hl) or set_hl(conf.hl) },
				{ conf.corner_right or "", set_hl(conf.corner_right_hl) or set_hl(conf.hl) }
			},

			hl_mode = "combine"
		});
	elseif conf.style == "icon" then
		local conceal_start = string.match(content.line, "^[#]+(%s*)");

		-- Heading rules
		-- 1. Must start at the first column
		-- 2. Must have 1 space between the marker and the title
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			virt_text_pos = "inline",
			virt_text = {
				{ string.rep(conf.shift_char or " ", shift * (content.level - 1)), set_hl(conf.shift_hl) },

				{ conf.icon or "", set_hl(conf.icon_hl) or set_hl(conf.hl) },
			},

			sign_text = conf.sign, sign_hl_group = set_hl(conf.sign_hl),
			line_hl_group = set_hl(conf.hl),
			hl_mode = "combine",

			end_col = content.level + vim.fn.strchars(conceal_start),
			conceal = ""
		});
	end
end

renderer.render_headings_s = function (buffer, content, config)
	if not config or config.enable == false then
		return;
	end

	---@type markview.render_config.headings.h
	local conf = content.marker:match("=") and config["setext_1"] or config["setext_2"];

	-- Do not proceed if setext headings don't have configuraton
	if not conf then
		return;
	end

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
	if not config_table or config_table.enable == false then
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
			end_col = content.col_start + vim.fn.strchars(content.info_string),
			conceal = ""
		});

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + vim.fn.strchars(content.info_string), {
			virt_text_pos = config_table.position or "inline",
			virt_text = {
				{ string.rep(config_table.pad_char or " ", block_length + ((config_table.pad_amount or 1) * 2)), set_hl(config_table.hl) },
			},

			hl_mode = "combine"
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

			local position, width = #text, vim.fn.strdisplaywidth(vim.fn.strcharpart(text, content.col_start) or "");

			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + line, position, {
				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config_table.pad_char or " ", block_length - width), set_hl(config_table.hl) },
					{ string.rep(config_table.pad_char or " ", config_table.pad_amount or 1), set_hl(config_table.hl) }
				}
			})
		end
	elseif config_table.style == "language" then
		local language = languages.get_ft(content.language);
		local icon, hl = renderer.get_icon(language, config_table);
		local block_length = content.largest_line;

		local languageName;
		local icon_section = icon ~= "" and " " .. icon .. " " or " ";

		if config_table.language_names ~= nil then
			for _, lang in ipairs(config_table.language_names) do
				if language == lang[1] then
					languageName = lang[2];
					goto nameFound;
				end
			end
		end

		languageName = languages.get_name(language)
		::nameFound::

		if type(config_table.min_width) == "number" and config_table.min_width > block_length then
			block_length = config_table.min_width
		end

		local lang_width = vim.fn.strchars(icon_section .. languageName .. " ");

		if config_table.language_direction == nil or config_table.language_direction == "left" then
			local rendered_info = vim.fn.strcharpart(content.block_info or "", 0, block_length - lang_width + ((config_table.pad_amount or 1) * 2) - 4);

			if content.block_info ~= "" and vim.fn.strchars(content.block_info) > (block_length - lang_width - ((content.pad_amount or 1) * 2)) then
				rendered_info = rendered_info .. "...";
			end

			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + 3 + vim.fn.strlen(content.language), {
				virt_text_pos = config_table.position or "inline",
				virt_text = {
					{ icon_section, set_hl(hl) },
					{ languageName .. " ", set_hl(config_table.name_hl) or set_hl(hl) },
					{ string.rep(config_table.pad_char or " ", block_length - lang_width - vim.fn.strchars(rendered_info) + ((config_table.pad_amount or 1) * 2)), set_hl(config_table.hl) },
					{ rendered_info, set_hl(config_table.info_hl or config_table.hl) },
				},

				sign_text = config_table.sign == true and icon or nil,
				sign_hl_group = set_hl(config_table.sign_hl) or set_hl(hl),

				hl_mode = "combine",
				end_col = content.col_start + vim.fn.strchars(content.info_string),
				conceal = "",
			});
		elseif config_table.language_direction == "right" then
			local rendered_info = vim.fn.strcharpart(content.block_info or "", 0, block_length - lang_width + ((config_table.pad_amount or 1) * 2) - 4);

			if content.block_info ~= "" and vim.fn.strchars(content.block_info) > (block_length - lang_width - ((content.pad_amount or 1) * 2)) then
				rendered_info = rendered_info .. "...";
			end

			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + 3 + vim.fn.strlen(content.language), {
				end_col = content.col_start + vim.fn.strchars(content.info_string),
				conceal = ""
			});

			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + vim.fn.strchars(content.info_string), {
				virt_text_pos = config_table.position or "inline",
				virt_text = {
					{ rendered_info, set_hl(config_table.info_hl or config_table.hl) },
					{ string.rep(config_table.pad_char or " ", block_length - lang_width - vim.fn.strchars(rendered_info) + ((config_table.pad_amount or 1) * 2)), set_hl(config_table.hl) },
					{ icon_section, set_hl(hl) },
					{ languageName .. " ", set_hl(config_table.name_hl) or set_hl(hl) },
				},

				sign_text = config_table.sign == true and icon or nil,
				sign_hl_group = set_hl(config_table.sign_hl) or set_hl(hl),

				hl_mode = "combine"
			});
		end

		-- The text on the final line
		-- We need to get the tail section to see if it contains ``` 
		local block_end_line = vim.api.nvim_buf_get_lines(buffer, content.row_end - 1, content.row_end, false)[1];
		local tail_section = vim.fn.strcharpart(block_end_line or "", content.col_start);

		if tail_section:match("```$") then
			tail_section = tail_section:gsub("```$", "");
		end

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end - 1, vim.fn.strchars(block_end_line or ""), {
			virt_text_pos = config_table.position or "inline",
			virt_text = {
				{ string.rep(config_table.pad_char or " ", (block_length - vim.fn.strchars(tail_section)) + ((config_table.pad_amount or 1) * 2)), set_hl(config_table.hl) },
			},

			hl_mode = "combine",
		});

		-- NOTE: The last line with ``` doesn't need this so we don't add it to that line
		for line, text in ipairs(content.lines) do
			-- NOTE: Nested code blocks have a different start position
			local length = content.line_lengths[line] - content.col_start;

			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + line, content.col_start, {
				hl_group = set_hl(config_table.hl),

				end_row = content.row_start + line,
				end_col = #text,
			});

			-- NOTE: If the line is smaller than the start position of the code block then subtract it
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + line, length < 0 and content.col_start + length or content.col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config_table.pad_char or " ", config_table.pad_amount or 1), set_hl(config_table.hl) }
				}
			})

			local position, width = #text, vim.fn.strdisplaywidth(vim.fn.strcharpart(text, content.col_start) or "");

			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + line, position, {
				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config_table.pad_char or " ", block_length - width), set_hl(config_table.hl) },
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

	if not config_table or config_table.enable == false then
		return;
	end

	if content.callout ~= nil then
		for _, callout in ipairs(config_table.callouts) do
			if type(callout.match_string) == "string" and string.upper(callout.match_string --[[@as string]]) == content.callout:upper() then
				qt_config = callout;
			elseif vim.islist(callout.match_string) then
				for _, alias in ipairs(callout.match_string --[[@as string[] ]]) do
					if type(alias) == "string" and alias:upper() == content.callout:upper() then
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

	-- Config for a block quote is not available
	if not qt_config then
		return;
	end

	if qt_config.custom_title == true and content.title ~= "" then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			virt_text_pos = "inline",
			virt_text = {
				{ tbl_clamp(qt_config.border, 1), set_hl(tbl_clamp(qt_config.border_hl, 1)) },
				{ " " },
				{ qt_config.custom_icon, set_hl(qt_config.callout_preview_hl) },
			},

			end_col = content.col_start + vim.fn.strdisplaywidth(">[!" .. content.callout .. "]"),
			conceal = ""
		});

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			hl_group = set_hl(qt_config.callout_preview_hl),
			end_col = content.col_start + #content.lines[1],
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

		if config_table.wrap ~= true then
			goto nowrap;
		end

		::nowrap::
	end
end

--- Renders custom horizontal rules
---@param buffer number
---@param content any
---@param config_table markview.render_config.hrs
renderer.render_horizontal_rules = function (buffer, content, config_table)
	local virt_text = {};

	if not config_table or config_table.enable == false then
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

	if not config_table or config_table.enable == false then
		return;
	end

	lnk_conf = config_table.hyperlinks;

	for _, conf in ipairs(config_table.hyperlinks.custom or {}) do
		if conf.match and string.match(content.address or "", conf.match) then
			lnk_conf = vim.tbl_extend("force", lnk_conf or {}, conf);
			break;
		end
	end

	-- Do not render links with no config
	if not lnk_conf then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + 1, {
		virt_text_pos = "inline",
		virt_text = {
			{ lnk_conf.corner_left or "", set_hl(lnk_conf.corner_left_hl) or set_hl(lnk_conf.hl) },
			{ lnk_conf.padding_left or "", set_hl(lnk_conf.padding_left_hl) or set_hl(lnk_conf.hl) },
			{ lnk_conf.icon or "", set_hl(lnk_conf.icon_hl) or set_hl(lnk_conf.hl) },
		},

		end_col = content.col_start,
		conceal = ""
	});

	vim.api.nvim_buf_add_highlight(buffer, renderer.namespace, set_hl(lnk_conf.hl) or "", content.row_start, content.col_start, content.col_end);

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end, content.col_end, {
		virt_text_pos = "inline",
		virt_text = {
			{ lnk_conf.padding_right or "", set_hl(lnk_conf.padding_right_hl) or set_hl(lnk_conf.hl) },
			{ lnk_conf.corner_right or "", set_hl(lnk_conf.corner_right_hl) or set_hl(lnk_conf.hl) },
		},

		end_col = content.col_start,
		conceal = ""
	});
end

--- Renderer for custom emails
---@param buffer number
---@param content any
---@param config_table markview.render_config.links
renderer.render_email_links = function (buffer, content, config_table)
	if not config_table or config_table.enable == false then
		return;
	end

	local email_conf = config_table.emails;

	if not email_conf then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
		virt_text_pos = "inline",
		virt_text = {
			{ email_conf.corner_left or "", set_hl(email_conf.corner_left_hl) or set_hl(email_conf.hl) },
			{ email_conf.padding_left or "", set_hl(email_conf.padding_left_hl) or set_hl(email_conf.hl) },
			{ email_conf.icon or "", set_hl(email_conf.icon_hl) or set_hl(email_conf.hl) },
		},

		end_col = content.col_start + 1,
		conceal = ""
	});

	vim.api.nvim_buf_add_highlight(buffer, renderer.namespace, set_hl(email_conf.hl) or "", content.row_start, content.col_start, content.col_end);

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end, content.col_end - 1, {
		virt_text_pos = "inline",
		virt_text = {
			{ email_conf.padding_right or "", set_hl(email_conf.padding_right_hl) or set_hl(email_conf.hl) },
			{ email_conf.corner_right or "", set_hl(email_conf.corner_right_hl) or set_hl(email_conf.hl) },
		},

		end_col = content.col_end,
		conceal = ""
	});
end

--- Renderer for custom image links
---@param buffer number
---@param content any
---@param config_table markview.render_config.links
renderer.render_img_links = function (buffer, content, config_table)
	if not config_table or config_table.enable == false then
		return;
	end

	local img_conf = config_table.images;

	if not img_conf then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + 1, {
		virt_text_pos = "inline",
		virt_text = {
			{ img_conf.corner_left or "", set_hl(img_conf.corner_left_hl) or set_hl(img_conf.hl) },
			{ img_conf.padding_left or "", set_hl(img_conf.padding_left_hl) or set_hl(img_conf.hl) },
			{ img_conf.icon or "", set_hl(img_conf.icon_hl) or set_hl(img_conf.hl) },
		},

		end_col = content.col_start,
		conceal = ""
	});

	vim.api.nvim_buf_add_highlight(buffer, renderer.namespace, set_hl(img_conf.hl) or "", content.row_start, content.col_start, content.col_end);

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end, content.col_end - vim.fn.strchars(content.address), {
		virt_text_pos = "inline",
		virt_text = {
			{ img_conf.padding_right or "", set_hl(img_conf.padding_right_hl) or set_hl(img_conf.hl) },
			{ img_conf.corner_right or "", set_hl(img_conf.corner_right_hl) or set_hl(img_conf.hl) },
		},

		end_col = content.col_end,
		conceal = ""
	});
end

--- Renderer for custom inline codes
---@param buffer number
---@param content any
---@param config_table markview.render_config.inline_codes
renderer.render_inline_codes = function (buffer, content, config_table)
	if not config_table or config_table.enable == false then
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

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_end, {
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
	if not config_table or config_table.enable == false then
		return;
	end

	local ls_conf = {};

	if string.match(content.marker_symbol, "-") then
		ls_conf = config_table.marker_minus or {};
	elseif string.match(content.marker_symbol, "+") then
		ls_conf = config_table.marker_plus or {};
	elseif string.match(content.marker_symbol, "*") then
		ls_conf = config_table.marker_star or {};
	elseif string.match(content.marker_symbol, "[.%)]") then
		ls_conf = config_table.marker_dot or {};
	end

	-- Do not render list types with no configuration
	if not ls_conf then
		return;
	end

	local use_text = ls_conf.text or content.marker_symbol;

	if ls_conf.add_padding == true then
		local shift = config_table.shift_width or vim.bo[buffer].shiftwidth;

		for l, line in ipairs(content.list_lines) do
			local line_num = content.row_start + (l - 1);
			local before = content.spaces[l] or 0;

			if vim.list_contains(content.list_candidates, l) and l == 1 then
				local conceal_end = content.col_start + vim.fn.strchars(content.marker_symbol) - 1;

				if content.marker_symbol:match("^%d+") then
					conceal_end = vim.fn.strchars(content.list_lines[1]:match("^%s*"));
					use_text = "";
				end

				if content.is_checkbox == true then
					conceal_end = content.col_start + vim.fn.strchars(content.marker_symbol);
					use_text = "";
				end

				local level = math.floor(before / (config_table.indent_size or 2)) + 1;

				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, line_num, content.starts[l] or 0, {
					virt_text_pos = "inline",
					virt_text = {
						{ string.rep(" ", level * shift) },
						{ vim.trim(use_text), set_hl(ls_conf.hl) or "Special" }
					},

					end_col = conceal_end,
					conceal = ""
				})
			elseif vim.list_contains(content.list_candidates, l) then
				local line_len = vim.fn.strchars(line);

				local level = math.floor(before / (config_table.indent_size or 2)) + 1;

				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, line_num, content.starts[l] or 0, {
					virt_text_pos = "inline",
					virt_text = {
						{ string.rep(" ", level * shift) },
						{ string.rep(" ", content.align_spaces[l] or 0) },
					},

					end_col = line_len < before and line_len + (content.align_spaces[l] or 0) or before + (content.align_spaces[l] or 0),
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
	if not config_table or config_table.enable == false then
		return;
	end

	local chk_config = {};

	if content.state == "complete" then
		chk_config = config_table.checked;
	elseif content.state == "incomplete" then
		chk_config = config_table.unchecked;
	elseif content.state == "pending" then
		chk_config = config_table.pending;
	elseif vim.islist(config_table.custom) then
		for _, config in ipairs(config_table.custom) do
			if content.state == config.match then
				chk_config = config;
			end
		end
	end

	if not chk_config or type(chk_config.text) ~= "string" then
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
	if not user_config.tables or user_config.tables.enable == false then
		return;
	end

	for row_number, _ in ipairs(content.rows) do
		if content.row_type[row_number] == "header" then
			table_header(buffer, content, user_config);
		elseif content.row_type[row_number] == "separator" then
			table_seperator(buffer, content, user_config, row_number)
		elseif content.row_type[row_number] == "content" and row_number == #content.rows then
			table_footer(buffer, content, user_config)
		else
			table_content(buffer, content, user_config, row_number)
		end
	end
end

renderer.render_html_inline = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	if not user_config.tags or user_config.tags.enable == false then
		return;
	end

	local html_conf = user_config.tags.default or {};

	if user_config.tags.configs[string.lower(content.tag)] then
		html_conf = user_config.tags.configs[string.lower(content.tag)];
	end

	if html_conf.conceal ~= false then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.start_tag_col_start, {
			end_col = content.start_tag_col_end,
			conceal = ""
		});
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.end_tag_col_start, {
			end_col = content.end_tag_col_end,
			conceal = ""
		});
	end

	if html_conf.hl then
		vim.api.nvim_buf_add_highlight(buffer, renderer.namespace, html_conf.hl, content.row_start, content.start_tag_col_end, content.end_tag_col_start);
	end
end

renderer.render_html_entities = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	if not user_config.entites or user_config.entites.enable == false then
		return;
	end

	local filtered_entity = content.text:gsub("[&;]", "");
	local entity = entites.get(filtered_entity);

	if not entity then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
		virt_text_pos = "inline",
		virt_text = {
			{ entity, set_hl(user_config.entites.hl) }
		},

		end_col = content.col_end,
		conceal = ""
	});
end

renderer.render_escaped = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
		end_col = content.col_start + #"\\",
		conceal = ""
	});
end


renderer.render = function (buffer, parsed_content, config_table, conceal_start, conceal_stop)
	if not _G.__markview_views then
		_G.__markview_views = {};
	end

	if parsed_content ~= nil then
		_G.__markview_views[buffer] = parsed_content;
	end

	-- Prevents errors caused by buffer ranges being nil
	if _G.__markview_render_ranges and _G.__markview_render_ranges[buffer] then
		_G.__markview_render_ranges[buffer] = {};
	end

	for _, content in ipairs(_G.__markview_views[buffer]) do
		local type = content.type;
		local fold_closed = vim.fn.foldclosed(content.row_start + 1);

		if fold_closed ~= -1 then
			goto extmark_skipped;
		end

		-- Unlike `conceal_start`, `conceal_stop` is 1-indexed
		-- Do not render things inside the un-conceal range
		if conceal_start and conceal_stop and content.row_start >= conceal_start and content.row_end <= (conceal_stop - 1) then
			goto extmark_skipped;
		end

		if type == "heading_s" then
			pcall(renderer.render_headings_s, buffer, content, config_table.headings);
		elseif type == "heading" then
			pcall(renderer.render_headings, buffer, content, config_table.headings)
		elseif type == "code_block" then
			pcall(renderer.render_code_blocks, buffer, content, config_table.code_blocks)
		elseif type == "block_quote" then
			pcall(renderer.render_block_quotes, buffer, content, config_table.block_quotes);
		elseif type == "horizontal_rule" then
			pcall(renderer.render_horizontal_rules, buffer, content, config_table.horizontal_rules);
		elseif type == "link" then
			pcall(renderer.render_links, buffer, content, config_table.links);
		elseif type == "email" then
			pcall(renderer.render_email_links, buffer, content, config_table.links);
		elseif type == "image" then
			pcall(renderer.render_img_links, buffer, content, config_table.links);
		elseif type == "inline_code" then
			pcall(renderer.render_inline_codes, buffer, content, config_table.inline_codes)
		elseif type == "list_item" then
			pcall(renderer.render_lists, buffer, content, config_table.list_items)
		elseif type == "checkbox" then
			pcall(renderer.render_checkboxes, buffer, content, config_table.checkboxes)
		elseif type == "html_inline" then
			pcall(renderer.render_html_inline, buffer, content, config_table.html);
		elseif type == "html_entity" then
			pcall(renderer.render_html_entities, buffer, content, config_table.html);
		elseif type == "table" then
			pcall(renderer.render_tables, buffer, content, config_table);
		elseif type == "escaped" then
			pcall(renderer.render_escaped, buffer, content, config_table.escaped);
		elseif type:match("^(latex_)") then
			pcall(latex_renderer.render, type, buffer, content, config_table)
		end

		::extmark_skipped::
	end
end

renderer.clear = function (buffer, from, to)
	vim.api.nvim_buf_clear_namespace(buffer, renderer.namespace, from or 0, to or -1)
end

renderer.update_range = function (buffer, new_range)
	if not _G.__markview_render_ranges then
		_G.__markview_render_ranges = {};
	end

	if not _G.__markview_render_ranges[buffer] then
		_G.__markview_render_ranges[buffer] = {};
	end

	if new_range and not vim.deep_equal(_G.__markview_render_ranges[buffer], new_range) then
		_G.__markview_render_ranges[buffer] = new_range;
	end
end

renderer.clear_content_range = function (buffer, parsed_content)
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

	vim.api.nvim_buf_clear_namespace(buffer, renderer.namespace, max_range[1], max_range[2]);
end

renderer.get_content_range = function (parsed_content)
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

	return max_range;
end

return renderer;
