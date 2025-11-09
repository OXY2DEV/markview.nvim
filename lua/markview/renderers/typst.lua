local typst = {};

local symbols = require("markview.symbols");
local spec = require("markview.spec");
local utils = require("markview.utils");

local filetypes = require("markview.filetypes");

typst.cache = {
	superscripts = {},
	subscripts = {}
};

---@param list string[]
---@return string
local concat = function (list)
	for i, item in ipairs(list) do
		list[i] = vim.pesc(item);
	end

	return table.concat(list);
end

--- Applies text transformation based on the **filetype**.
---
--- Uses for getting the output text of filetypes that contain
--- special syntaxes(e.g. JSON, Markdown).
typst.get_visual_text = {
	["Markdown"] = function (str)
		str = str:gsub("\\%`", " ");

		for inline_code in str:gmatch("`(.-)`") do
			str = str:gsub(concat({
				"`",
				inline_code,
				"`"
			}), inline_code);
		end

		for escaped in str:gmatch("\\([%\\%*%_%{%}%[%]%(%)%#%+%-%.%!%%<%>$])") do
			str = str:gsub(concat({
				"\\",
				escaped
			}), " ");
		end

		for link, _, address, _ in str:gmatch("%!%[([^%)]*)%]([%(%[])([^%)]*)([%)%]])") do
			str = str:gsub(concat({
				"![",
				link,
				"]",
				address,
			}), concat({ link }))
		end

		for link in str:gmatch("%!%[([^%)]*)%]") do
			str = str:gsub(concat({
				"![",
				link,
				"]",
			}), concat({
				string.rep("X", vim.fn.strdisplaywidth(link))
			}))
		end

		for link, _, address, _ in str:gmatch("%[([^%)]*)%]([%(%[])([^%)]*)([%)%]])") do
			str = str:gsub(concat({
				"[",
				link,
				"]",
				address
			}), concat({
				string.rep("X", vim.fn.strdisplaywidth(link))
			}));
		end

		for link in str:gmatch("%[([^%)]+)%]") do
			str = str:gsub(concat({
				"[",
				link,
				"]",
			}), concat({
				string.rep("X", vim.fn.strdisplaywidth(link))
			}))
		end

		for str_b, content, str_a in str:gmatch("([*]+)(.-)([*]+)") do
			if content == "" then
				goto continue;
			elseif #str_b ~= #str_a then
				local min = math.min(#str_b, #str_a);
				str_b = str_b:sub(0, min);
				str_a = str_a:sub(0, min);
			end

			str_b = vim.pesc(str_b);
			content = vim.pesc(content);
			str_a = vim.pesc(str_a);

			str = str:gsub(str_b .. content .. str_a, string.rep("X", vim.fn.strdisplaywidth(content)))

			::continue::
		end

		for striked in str:gmatch("%~%~(.-)%~%~") do
			str = str:gsub(concat({
				"~~",
				striked,
				"~~"
			}), concat({
				string.rep("X", vim.fn.strdisplaywidth(striked))
			}));
		end

		return str;
	end,
	["JSON"] = function (str)
		return str:gsub('"', "");
	end,

	--- Gets the visual text from the source text.
	---@param self table
	---@param ft string?
	---@param line string
	---@return string
	init = function (self, ft, line)
		if ft == nil or self[ft] == nil then
			--- Filetype isn't available or
			--- transformation not available.
			return line;
		elseif pcall(self[ft], line) == false then
			--- Text transformation failed!
			return line;
		end

		return self[ft](line);
	end
};

typst.ns = vim.api.nvim_create_namespace("markview/typst");

---@param buffer integer
---@param item markview.parsed.typst.code_block
typst.code_block = function (buffer, item)
	local config = spec.get({ "typst", "code_blocks" }, { fallback = nil, eval_args = { buffer, item } });
	local range = item.range;

	if not config then
		return;
	end

	if config.style == "simple" then
		vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "right_align",
			virt_text = {
				{ config.text, utils.set_hl(config.text_hl or config.hl) },
			},

			sign_text = config.sign,
			sign_hl_group = utils.set_hl(config.sign_hl or config.hl)
		});


		vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_row = range.row_end, end_col = range.col_end,
			line_hl_group = utils.set_hl(config.hl),
		});
	elseif config.style == "block" then
		local pad_amount = config.pad_amount or 3;
		local block_width = config.min_width - (2 * pad_amount);

		--- Get maximum length of the lines within the code block
		for l, line in ipairs(item.text) do
			if (l ~= 1 and l ~= #item.text) and vim.fn.strdisplaywidth(line) > block_width then
				block_width = vim.fn.strdisplaywidth(line);
			end
		end

		if config.text_direction == nil or config.text_direction == "left" then
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
				undo_restore = false, invalidate = true,

				virt_lines_above = true,
				virt_lines = {
					{
						{ string.rep(" ", range.col_start) },
						{ config.pad_char or " ", utils.set_hl(config.hl) },
						{ config.text or "", utils.set_hl(config.text_hl or config.hl) },
						{ string.rep(config.pad_char or " ", block_width + (pad_amount - 1) - (vim.fn.strdisplaywidth(config.text or ""))), utils.set_hl(config.hl) },
						{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
					}
				},

				sign_text = config.sign,
				sign_hl_group = utils.set_hl(config.sign_hl or config.hl),
			});
		elseif config.text_direction == "right" then
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
				undo_restore = false, invalidate = true,

				virt_lines_above = true,
				virt_lines = {
					{
						{ string.rep(" ", range.col_start) },
						{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
						{ string.rep(config.pad_char or " ", block_width + (pad_amount - 1) - (vim.fn.strdisplaywidth(config.text or ""))), utils.set_hl(config.hl) },
						{ config.text or "", utils.set_hl(config.text_hl or config.hl) },
						{ config.pad_char or " ", utils.set_hl(config.hl) },
					}
				},

				sign_text = config.sign,
				sign_hl_group = utils.set_hl(config.sign_hl or config.hl),
			});
		end

		vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, range.col_end, {
			undo_restore = false, invalidate = true,

			virt_lines = {
				{
					{ string.rep(" ", range.col_start) },
					{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
					{ string.rep(config.pad_char or " ", block_width), utils.set_hl(config.hl) },
					{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
				}
			}
		});

		for l = range.row_start, range.row_end, 1 do
			local line = item.text[(l + 1) - range.row_start];
			local final = line;

			--- Left padding
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, l, range.col_start, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) }
				},
			});

			--- Right padding
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, l, range.col_start + #line, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config.pad_char or " ", block_width - vim.fn.strdisplaywidth(final)), utils.set_hl(config.hl) },
					{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) }
				},
			});

			--- Background color
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, l, range.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + #line,
				hl_group = utils.set_hl(config.hl)
			});
		end
	end
end

---@param buffer integer
---@param item markview.parsed.typst.code_spans
typst.code_span = function (buffer, item)
	---@type markview.config.typst.code_spans?
	local config = spec.get({ "typst", "code_spans" }, { fallback = nil, eval_args = { buffer, item } });
	local range = item.range;

	if not config then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl),
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, range.col_end, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) },
		},

		hl_mode = "combine"
	});

	if range.row_start == range.row_end then
		return;
	end

	for l = range.row_start, range.row_end do
		local line = item.text[(l - range.row_start) + 1];

		if l == range.row_start then
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, l, range.col_start + #line, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
				},

				hl_mode = "combine"
			});
		elseif l == range.row_end then
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, l, 0, {
				undo_restore = false, invalidate = true,
				right_gravity = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
				},

				hl_mode = "combine"
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, l, 0, {
				undo_restore = false, invalidate = true,
				right_gravity = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
				},

				hl_mode = "combine"
			});
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, l, #line, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
				},

				hl_mode = "combine"
			});
		end
	end
end

---@param buffer integer
---@param item markview.parsed.typst.emphasis
typst.emphasis = function (buffer, item)
	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = ""
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, range.col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = ""
	});
end

---@param buffer integer
---@param item markview.parsed.typst.escapes
typst.escaped = function (buffer, item)
	---@type markview.config.typst.escapes?
	local config = spec.get({ "typst", "escapes" }, { fallback = nil, eval_args = { buffer, item } });

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = "",
	});
end

---@param buffer integer
---@param item markview.parsed.typst.headings
typst.heading = function (buffer, item)
	---@type markview.config.typst.headings?
	local main_config = spec.get({ "typst", "headings" }, { fallback = nil });

	if not main_config then
		return;
	elseif not spec.get({ "heading_" .. item.level }, { source = main_config, eval_args = { buffer, item } }) then
		return;
	end

	local range = item.range;
	---@type headings.typst
	local config = spec.get({ "heading_" .. item.level }, { source = main_config, eval_args = { buffer, item } });

	if config.style == "simple" then
		vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			line_hl_group = utils.set_hl(config.hl)
		});
	elseif config.style == "icon" then
		vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + item.level + 1,
			conceal = "",
			sign_text = config.sign,
			sign_hl_group = utils.set_hl(config.sign_hl),
			virt_text_pos = "inline",
			virt_text = {
				{ string.rep(" ", item.level * spec.get({ "typst", "headings", "shift_width" }, { fallback = 1 })) },
				{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) },
			},
			line_hl_group = utils.set_hl(config.hl),

			hl_mode = "combine"
		});
	end
end

---@param buffer integer
---@param item markview.parsed.typst.labels
typst.label = function (buffer, item)
	---@type markview.config.typst.labels?
	local main_config = spec.get({ "typst", "labels" }, { fallback = nil, eval_args = { buffer, item } });

	if not main_config then
		return;
	end

	---@type markview.config.__inline?
	local config = utils.match(
		main_config,
		item.text[1]:gsub("^%@", ""),
		{
			eval_args = { buffer, item }
		}
	);

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) },
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl),
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, range.col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) },
		},

		hl_mode = "combine"
	});
end

---@param buffer integer
---@param item markview.parsed.typst.list_items
typst.list_item = function (buffer, item)
	---@type markview.config.typst.list_items?
	local main_config = spec.get({ "typst", "list_items" }, { fallback = nil });
	---@type markview.config.typst.list_items.typst | nil
	local config;

	if not main_config then return; end

	if item.marker == "-" then
		config = spec.get({ "marker_minus" }, { source = main_config, eval_args = { buffer, item } });
	elseif item.marker == "+" then
		config = spec.get({ "marker_plus" }, { source = main_config, eval_args = { buffer, item } });
	elseif item.marker:match("%d+%.") then
		config = spec.get({ "marker_dot" }, { source = main_config, eval_args = { buffer, item } });
	end

	if not config then
		return;
	end

	local indent = type(main_config.indent_size) == "number" and main_config.indent_size or 1;
	local shift  = type(main_config.shift_width) == "number" and main_config.shift_width or 1;

	---@cast indent integer
	---@cast shift integer

	local range = item.range;

	if config.add_padding == true then
		for l = range.row_start, range.row_end do
			local line = item.text[(l - range.row_start) + 1];

			vim.api.nvim_buf_set_extmark(buffer, typst.ns, l, math.min(#line, range.col_start - item.indent), {
				undo_restore = false, invalidate = true,
				end_col = math.min(#line, range.col_start),
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(" ", math.ceil((item.indent / indent) + 1) * shift) }
				}
			});
		end
	end

	if item.marker == "-" then
		vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + 1,

			virt_text_pos = "overlay",
			virt_text = {
				{ config.text or "", utils.set_hl(config.hl) }
			}
		});
	elseif item.marker == "+" then
		vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + 1,
			conceal = "",

			virt_text_pos = "inline",
			virt_text = {
				{ string.format(config.text or "%d.", item.number), utils.set_hl(config.hl) }
			}
		});
	end
end

---@param buffer integer
---@param item markview.parsed.typst.reference_links
typst.link_ref = function (buffer, item)
	---@type markview.config.typst.reference_links?
	local main_config = spec.get({ "typst", "reference_links" }, { fallback = nil, eval_args = { buffer, item } });

	if not main_config then
		return;
	end

	---@type markview.config.__inline?
	local config = utils.match(
		main_config,
		item.label,
		{
			eval_args = { buffer, item }
		}
	);

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) },
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl),
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, range.col_end, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) },
		},

		hl_mode = "combine"
	});
end

---@param buffer integer
---@param item markview.parsed.typst.url_links
typst.link_url = function (buffer, item)
	---@type markview.config.typst.url_links?
	local main_config = spec.get({ "typst", "url_links" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type markview.config.__inline?
	local config = utils.match(
		main_config,
		item.label,
		{
			eval_args = { buffer, item }
		}
	);

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_end, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) },
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});
end

---@param buffer integer
---@param item markview.parsed.typst.maths
typst.math_block = function (buffer, item)
	local range = item.range;

	---@type markview.config.typst.math_blocks?
	local config = spec.get({ "typst", "math_blocks" }, { fallback = nil, eval_args = { buffer, item } });

	if not config then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = "",

		virt_text_pos = "right_align",
		virt_text = { { config.text or "", utils.set_hl(config.text_hl or config.hl) } },

		hl_mode = "combine",
		line_hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, math.max(0, range.col_end - 1), {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		line_hl_group = utils.set_hl(config.hl)
	});

	for l = 1, #item.text - 2 do
		vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start + l, range.col_start, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ string.rep(config.pad_char or "", config.pad_amount or 0), utils.set_hl(config.hl) }
			},

			line_hl_group = utils.set_hl(config.hl)
		});
	end
end

---@param buffer integer
---@param item markview.parsed.typst.maths
typst.math_span = function (buffer, item)
	---@type markview.config.__inline?
	local config = spec.get({ "typst", "math_spans" }, { fallback = nil, eval_args = { buffer, item } });
	local range = item.range;

	if not config then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
		},

		hl_mode = "combine"
	});

	if range.row_start ~= range.row_end then
		vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start + #item.text[1], {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) }
			}
		});

		vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, 0, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
			}
		});
	end

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl),
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, range.col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) },
		},

		hl_mode = "combine"
	});

	for l = 1, #item.text - 2 do
		vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start + l, math.min(#item.text[l + 1], 0), {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
			}
		});

		vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start + l, #item.text[l + 1], {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) }
			}
		});
	end
end

---@param buffer integer
---@param item markview.parsed.typst.raw_blocks
typst.raw_block = function (buffer, item)
	---@type markview.config.typst.raw_blocks?
	local config = spec.get({ "typst", "raw_blocks" }, { fallback = nil, eval_args = { buffer, item } });
	local range = item.range;

	if not config then
		return;
	end

	local decorations = filetypes.get(item.language);
	local label = { string.format(" %s%s ", decorations.icon, decorations.name), config.label_hl or decorations.icon_hl };
	local win = utils.buf_getwin(buffer);

	--- Gets highlight configuration for a line.
	---@param line string
	---@return markview.config.typst.raw_blocks.opts
	local function get_line_config(line)
		local line_conf = utils.match(config, item.language, {
			eval_args = { buffer, line },
			def_fallback = {
				block_hl = config.border_hl,
				pad_hl = config.border_hl
			},
			fallback = {
				block_hl = config.border_hl,
				pad_hl = config.border_hl
			}
		});

		return line_conf;
	end

	local function render_simple ()
		if config.label_direction == nil or config.label_direction == "left" then
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
				undo_restore = false, invalidate = true,

				end_col = range.col_start + 3,
				conceal = "",

				sign_text = config.sign == true and decorations.sign or nil,
				sign_hl_group = utils.set_hl(config.sign_hl or decorations.sign_hl),

				virt_text_pos = "inline",
				virt_text = { label },

				line_hl_group = utils.set_hl(config.border_hl)
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
				undo_restore = false, invalidate = true,

				end_col = range.col_start + 3,
				conceal = "",

				sign_text = config.sign == true and decorations.sign or nil,
				sign_hl_group = utils.set_hl(config.sign_hl or decorations.sign_hl),

				virt_text_pos = "right_align",
				virt_text = { label },

				line_hl_group = utils.set_hl(config.border_hl)
			});
		end

		--- Background
		for l = range.row_start + 1, range.row_end - 1 do
			local line = item.text[(l - range.row_start) + 1];
			local line_config = get_line_config(line);

			vim.api.nvim_buf_set_extmark(buffer, typst.ns, l, 0, {
				undo_restore = false, invalidate = true,
				end_row = l,

				line_hl_group = utils.set_hl(line_config.block_hl --[[ @as string ]])
			});
		end

		vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, range.col_end - 3, {
			undo_restore = false, invalidate = true,

			end_col = range.col_end,
			conceal = "",

			line_hl_group = utils.set_hl(config.border_hl)
		});
	end

	local function render_block ()
		local pad_amount = config.pad_amount or 0;
		local block_width = config.min_width or 60;

		local line_widths = {};

		--- Get maximum length of the lines within the code block
		for l, line in ipairs(item.text) do
			local final;

			if item.language == "md" then
				--- Bug ```md doesn't get recognized as markdown.
				final = typst.get_visual_text:init("", line);
			else
				final = typst.get_visual_text:init(decorations.name, line);
			end

			if l ~= 1 and l ~= #item.text then
				table.insert(line_widths, vim.fn.strdisplaywidth(final));

				if vim.fn.strdisplaywidth(final) > (block_width - (2 * pad_amount)) then
					block_width = vim.fn.strdisplaywidth(final) + (2 * pad_amount);
				end
			end
		end

		local label_width = utils.virt_len({ label });

		vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
			end_col = range.col_start + #item.text[1],
			conceal = "",

			sign_text = config.sign == true and decorations.sign or nil,
			sign_hl_group = utils.set_hl(config.sign_hl or decorations.sign_hl),
		});

		if config.label_direction == nil or config.label_direction == "left" then
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start + #item.text[1], {
				virt_text_pos = "inline",
				virt_text = {
					label,
					{
						string.rep(config.pad_char or " ", block_width - label_width)
					}
				}
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start + #item.text[1], {
				virt_text_pos = "inline",
				virt_text = {
					{
						string.rep(config.pad_char or " ", block_width - label_width),
						utils.set_hl(config.border_hl)
					},
					label
				}
			});
		end

		--- Line padding
		for l, width in ipairs(line_widths) do
			local line = item.text[l + 1];
			local line_config = get_line_config(line);

			if width ~= 0 then
				vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start + l, line ~= "" and range.col_start or 0, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(" ", pad_amount),
							utils.set_hl(line_config.pad_hl --[[ @as string ]])
						}
					},
				});

				vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start + l, range.col_start + #line, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(" ", block_width - (( 2 * pad_amount) + width)),
							utils.set_hl(line_config.block_hl --[[ @as string ]])
						},
						{
							string.rep(" ", pad_amount),
							utils.set_hl(line_config.pad_hl --[[ @as string ]])
						}
					},
				});

				--- Background
				vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start + l, range.col_start, {
					undo_restore = false, invalidate = true,
					end_col = range.col_start + #line,

					hl_group = utils.set_hl(line_config.block_hl --[[ @as string ]])
				});
			else
				local buf_line = vim.api.nvim_buf_get_lines(buffer, range.row_start + l, range.row_start + l + 1, false)[1];

				vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start + l, #buf_line, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(" ", range.col_start - #buf_line)
						},
						{
							string.rep(" ", pad_amount),
							utils.set_hl(line_config.pad_hl --[[ @as string ]])
						},
						{
							string.rep(" ", block_width - (2 * pad_amount)),
							utils.set_hl(line_config.block_hl --[[ @as string ]])
						},
						{
							string.rep(" ", pad_amount),
							utils.set_hl(line_config.pad_hl --[[ @as string ]])
						},
					},
				});
			end
		end

		--- Bottom border
		vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, range.col_end - 3, {
			undo_restore = false, invalidate = true,
			end_col = range.col_end,
			conceal = ""
		});
		vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, range.col_end, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{
					string.rep(" ", block_width),
					utils.set_hl(config.border_hl)
				}
			}
		});
	end

	if not win or config.style == "simple" or ( vim.o.wrap == true or vim.wo[win].wrap == true ) then
		render_simple();
	elseif config.style == "block" then
		render_block()
	end
end

---@param buffer integer
---@param item markview.parsed.typst.raw_spans
typst.raw_span = function (buffer, item)
	---@type markview.config.typst.raw_spans?
	local config = spec.get({ "typst", "raw_spans" }, { fallback = nil, eval_args = { buffer, item } });

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) },
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl),
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, range.col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) },
		},

		hl_mode = "combine"
	});
end

---@param buffer integer
---@param item markview.parsed.typst.strong
typst.strong = function (buffer, item)
	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = ""
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, range.col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = ""
	});
end

---@param buffer integer
---@param item markview.parsed.typst.subscripts
typst.subscript = function (buffer, item)
	---@type markview.config.typst.subscripts?
	local config = spec.get({ "typst", "subscripts" }, { fallback = nil, eval_args = { buffer, item } });

	if not config then
		return;
	end

	local range = item.range;
	---@type string?
	local hl;

	if type(config.hl) == "string" then
		hl = config.hl --[[ @as string ]];
	elseif vim.islist(config.hl --[[ @as table ]]) == true then
		hl = config.hl[utils.clamp(item.level, 1, #config.hl)];
	end

	local previewable = true;

	local invalid_symbols = vim.list_extend(vim.tbl_keys(symbols.typst_entries), vim.tbl_keys(symbols.typst_shorthands));
	local valid_symbols = vim.tbl_keys(symbols.subscripts);

	local lines = vim.deepcopy(item.text);

	lines[1] = string.gsub(lines[1], "^%{", "");
	lines[#lines] = string.gsub(lines[#lines], "%}$", "");

	for _, line in ipairs(lines) do
		if utils.str_contains(line, invalid_symbols) == true then
			previewable = false;
			break;
		elseif utils.str_contains(line, valid_symbols) == false then
			previewable = false;
			break;
		end
	end

	if config.fake_preview == false or previewable == false then
		if item.parenthesis then
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + 2,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ config.marker_left or "↓(", utils.set_hl(hl) }
				},

				hl_mode = "combine"
			});

			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, range.col_end - 1, {
				undo_restore = false, invalidate = true,
				end_col = range.col_end,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ config.marker_right or ")", utils.set_hl(hl) }
				},

				hl_mode = "combine"
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + 1,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ config.marker_left or "↓(", utils.set_hl(hl) }
				},

				hl_mode = "combine"
			});

			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, range.col_end, {
				undo_restore = false, invalidate = true,
				right_gravity = false,

				virt_text_pos = "inline",
				virt_text = {
					{ config.marker_right or ")", utils.set_hl(hl) }
				},

				hl_mode = "combine"
			});
		end
	else
		if item.parenthesis == true then
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + 2,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = previewable == false and {
					{ config.marker_left or "↓(", utils.set_hl(hl) }
				} or nil,

				hl_mode = "combine"
			});

			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, range.col_end - 1, {
				undo_restore = false, invalidate = true,
				end_col = range.col_end,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = previewable == false and {
					{ config.marker_right or ")", utils.set_hl(hl) }
				} or nil,

				hl_mode = "combine"
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + 1,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = previewable == false and {
					{ config.marker_left or "↓", utils.set_hl(hl) }
				} or nil,

				hl_mode = "combine"
			});
		end
	end

	if previewable == true and config.fake_preview ~= false then
		table.insert(typst.cache.subscripts, item);
	else
		vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_row = range.row_end,
			end_col = range.col_end,

			hl_group = utils.set_hl(hl)
		});
	end
end

---@param buffer integer
---@param item markview.parsed.typst.superscripts
typst.superscript = function (buffer, item)
	---@type markview.config.typst.superscripts?
	local config = spec.get({ "typst", "superscripts" }, { fallback = nil, eval_args = { buffer, item } });

	if not config then
		return;
	end

	local range = item.range;
	---@type string?
	local hl;

	if type(config.hl) == "string" then
		hl = config.hl --[[ @as string ]];
	elseif vim.islist(config.hl --[[ @as table ]]) == true then
		hl = config.hl[utils.clamp(item.level, 1, #config.hl)];
	end

	local previewable = true;

	local invalid_symbols = vim.list_extend(vim.tbl_keys(symbols.typst_entries), vim.tbl_keys(symbols.typst_shorthands));
	local valid_symbols = vim.tbl_keys(symbols.superscripts);

	local lines = vim.deepcopy(item.text);

	lines[1] = string.gsub(lines[1], "^%{", "");
	lines[#lines] = string.gsub(lines[#lines], "%}$", "");

	for _, line in ipairs(lines) do
		if utils.str_contains(line, invalid_symbols) == true then
			previewable = false;
			break;
		elseif utils.str_contains(line, valid_symbols) == false then
			previewable = false;
			break;
		end
	end

	if config.fake_preview == false or previewable == false then
		if item.parenthesis then
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + 2,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ config.marker_left or "↑(", utils.set_hl(hl) }
				},

				hl_mode = "combine"
			});

			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, range.col_end - 1, {
				undo_restore = false, invalidate = true,
				end_col = range.col_end,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ config.marker_right or ")", utils.set_hl(hl) }
				},

				hl_mode = "combine"
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + 1,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ config.marker_left or "↑(", utils.set_hl(hl) }
				},

				hl_mode = "combine"
			});

			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, range.col_end, {
				undo_restore = false, invalidate = true,
				right_gravity = false,

				virt_text_pos = "inline",
				virt_text = {
					{ config.marker_right or ")", utils.set_hl(hl) }
				},

				hl_mode = "combine"
			});
		end
	else
		if item.parenthesis == true then
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + 2,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = previewable == false and {
					{ config.marker_left or "↑(", utils.set_hl(hl) }
				} or nil,

				hl_mode = "combine"
			});

			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_end, range.col_end - 1, {
				undo_restore = false, invalidate = true,
				end_col = range.col_end,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = previewable == false and {
					{ config.marker_right or ")", utils.set_hl(hl) }
				} or nil,

				hl_mode = "combine"
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + 1,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = previewable == false and {
					{ config.marker_left or "↑", utils.set_hl(hl) }
				} or nil,

				hl_mode = "combine"
			});
		end
	end

	if previewable == true and config.fake_preview ~= false then
		table.insert(typst.cache.superscripts, item);
	else
		vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_row = range.row_end,
			end_col = range.col_end,

			hl_group = utils.set_hl(hl)
		});
	end
end

---@param buffer integer
---@param item markview.parsed.typst.symbols
typst.symbol = function (buffer, item)
	---@type markview.config.typst.symbols?
	local config = spec.get({ "typst", "symbols" }, { fallback = nil, eval_args = { buffer, item } });

	if not config then
		return;
	elseif not item.name or not symbols.typst_entries[item.name] then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ symbols.typst_entries[item.name], utils.set_hl(config.hl) }
		},
		hl_mode = "combine"
	});
end

---@param buffer integer
---@param item markview.parsed.typst.terms
typst.term = function (buffer, item)
	---@type markview.config.typst.terms?
	local main_config = spec.get({ "typst", "terms" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type markview.config.typst.terms.opts?
	local config = utils.match(
		main_config,
		item.label,
		{
			eval_args = { buffer, item }
		}
	);

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 2,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.text or "", utils.set_hl(config.hl) }
		}
	});
end

---@param buffer integer
---@param item markview.parsed.typst.text
typst.text = function (buffer, item)
	local range = item.range;
	local style;

	local function modify_style(new_style)
		if style == nil then
			return true;
		elseif new_style.range and utils.within_range(style.range, new_style.range) == true then
			return true;
		end

		return false;
	end

	--- Check for subscript styles.
	for _, node in ipairs(typst.cache.subscripts or {}) do
		if utils.within_range(node.range, range) and modify_style(node) == true then
			style = node;
			break;
		end
	end

	--- Check for superscript styles.
	for _, node in ipairs(typst.cache.superscripts or {}) do
		if utils.within_range(node.range, range) and modify_style(node) == true then
			style = node;
			break;
		end
	end

	local virt_text, virt_hl;

	if style == nil then
		--- No styles were found.
		return;
	elseif style.class == "typst_subscript" then
		local config = spec.get({ "typst", "subscripts", "hl" }, { fallback = nil, eval_args = { buffer, style } });

		virt_text = symbols.tostring("subscripts", item.text[1])
		virt_hl = config.hl;
	elseif style.class == "typst_superscript" then
		local config = spec.get({ "typst", "superscripts", "hl" }, { fallback = nil, eval_args = { buffer, style } });

		virt_text = symbols.tostring("superscripts", item.text[1])
		virt_hl = config.hl;
	else
		--- Unknown style.
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, typst.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		virt_text_pos = "overlay",
		virt_text = {
			{ virt_text, utils.set_hl(virt_hl) }
		},
		hl_mode = "combine"
	});
end

--- Renders typst previews.
---@param buffer integer
---@param content markview.parsed.typst[]
typst.render = function (buffer, content)
	typst.cache = {
		superscripts = {},
		subscripts = {}
	};

	local custom = spec.get({ "renderers" }, { fallback = {} });

	for _, item in ipairs(content or {}) do
		local success, err;

		if custom[item.class] then
			success, err = pcall(custom[item.class], typst.ns, buffer, item);
		else
			success, err = pcall(typst[item.class:gsub("^typst_", "")], buffer, item);
		end

		if success == false then
			require("markview.health").print({
				kind = "ERR",

				from = "renderers/typst.lua",
				fn = item.class .. "()",

				message = {
					{ tostring(err), "DiagnosticError" }
				}
			});
		end
	end
end

--- Clear typst previews.
---@param buffer integer
---@param from integer?
---@param to integer?
typst.clear = function (buffer, from, to)
	vim.api.nvim_buf_clear_namespace(buffer, typst.ns, from or 0, to or -1);
end

return typst;
