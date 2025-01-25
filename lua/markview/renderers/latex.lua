local latex = {};

local symbols = require("markview.symbols");
local spec = require("markview.spec");
local utils = require("markview.utils");

--- Cached values.
---@type __latex.cache
latex.cache = {
	font_regions = {},
	style_regions = {
		superscripts = {},
		subscripts = {}
	},
};

--- Namespace for LaTeX previews.
---@type integer
latex.ns = vim.api.nvim_create_namespace("markview/latex");

---@param buffer integer
---@param item __latex.blocks
latex.block = function (buffer, item)
	---+${func}
	local range = item.range;

	---@type latex.blocks_static?
	local config = spec.get({ "latex", "blocks" }, { fallback = nil, eval_args = { buffer, item } });

	if not config then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + #(item.marker or "$$"),
		conceal = "",

		virt_text_pos = "right_align",
		virt_text = { { config.text or "", utils.set_hl(config.text_hl or config.hl) } },

		hl_mode = "combine",
		line_hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_end, math.max(0, range.col_end - #(item.marker or "$$")), {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		line_hl_group = utils.set_hl(config.hl)
	});

	for l = 1, #item.text - 2 do
		vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start + l, math.min(#item.text[l + 1], range.col_start), {
			undo_restore = false, invalidate = true,
			right_gravity = false,

			virt_text_pos = "inline",
			virt_text = {
				{ string.rep(config.pad_char or "", config.pad_amount or 0), utils.set_hl(config.hl) }
			},

			line_hl_group = utils.set_hl(config.hl)
		});
	end
	---_
end

---@param buffer integer
---@param item __latex.commands
latex.command = function (buffer, item)
	--+${func}

	---@type latex.commands?
	local main_config = spec.get({ "latex", "commands" }, { fallback = nil });
	local config;

	local command_name;

	if item.command == nil or item.command.name == nil then
		return;
	else
		command_name = string.format("^%s$", utils.escape_string(item.command.name));
	end

	if not main_config then
		return;
	else
		---@type commands.opts
		config = utils.match(main_config, command_name, { default = false });

		if type(config) ~= "table" or vim.tbl_isempty(config) == true then
			return;
		end
	end

	--- Check if this command is valid.
	if spec.get({ "condition" }, { source = config, eval_args = { item } }) == false then
		return;
	end

	if config.on_command then
		local range = item.command.range;
		local extmark = spec.get({ "on_command" }, { source = config, eval_args = { item.command } });

		if not extmark then
			goto invalid_extmark;
		end

		if pcall(config.command_offset, range) then
			range = config.command_offset(range);
		end

		vim.api.nvim_buf_set_extmark(buffer, latex.ns, range[1], range[2], vim.tbl_extend("force", {
			undo_restore = false, invalidate = true,
			end_row = range[3],
			end_col = range[4]
		}, extmark));

		::invalid_extmark::
	end

	if not config.on_args then return; end

	local on_args = spec.get({ "on_args" }, { source = config, eval_args = { item.command } });

	for a, arg in ipairs(item.args) do
		if not on_args[a] then
			goto continue;
		end

		---@type commands.arg_opts
		local arg_conf = on_args[a];

		if arg_conf.on_before then
			local b_conf = spec.get({ "on_before" }, { source = arg_conf, fallback = {}, eval_args = { arg } });
			local range = arg.range;

			if pcall(arg_conf.before_offset, range) then
				range = arg_conf.before_offset(range);
			end

			vim.api.nvim_buf_set_extmark(buffer, latex.ns, range[1], range[2], vim.tbl_extend("force", {
				undo_restore = false, invalidate = true,
			}, b_conf));
		end

		if arg_conf.on_content then
			local c_conf = spec.get({ "on_content" }, { source = arg_conf, fallback = {}, eval_args = { arg } });
			local range = arg.range;

			if pcall(arg_conf.content_offset, range) then
				range = arg_conf.content_offset(range);
			end

			vim.api.nvim_buf_set_extmark(buffer, latex.ns, range[1], range[2], vim.tbl_extend("force", {
				undo_restore = false, invalidate = true,
				end_row = arg.range[3],
				end_col = arg.range[4]
			}, c_conf));
		end

		if arg_conf.on_after then
			local a_conf = spec.get({ "on_after" }, { source = arg_conf, fallback = {}, eval_args = { arg } });
			local range = arg.range;

			if pcall(arg_conf.after_offset, range) then
				range = arg_conf.after_offset(range);
			end

			vim.api.nvim_buf_set_extmark(buffer, latex.ns, range[3], range[4], vim.tbl_extend("force", {
				undo_restore = false, invalidate = true,
			}, a_conf));
		end

	    ::continue::
	end
	---_
end

---@param buffer integer
---@param item __latex.escapes
latex.escaped = function (buffer, item)
	---+${func}

	---@type latex.escapes?
	local config = spec.get({ "latex", "escapes" }, { fallback = nil, eval_args = { buffer, item } });

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = ""
	});
	---_
end

---@param buffer integer
---@param item __latex.fonts
latex.font = function (buffer, item)
	---+${func}

	---@type latex.fonts?
	local main_config = spec.get({ "latex", "fonts" }, { fallback = nil });

	if main_config == nil then
		return;
	elseif symbols.fonts[item.name] == nil then
		return;
	end

	---@type fonts.opts?
	local config = utils.match(main_config, item.name, { eval_args = { buffer, item } });

	if config == nil then
		return;
	elseif vim.tbl_isempty(config) == true then
		return;
	end

	table.insert(latex.cache.font_regions, item);

	local range = item.range;
	---@type integer[]
	local font = range.font;

	vim.api.nvim_buf_set_extmark(buffer, latex.ns, font[1], font[2], {
		undo_restore = false, invalidate = true,
		end_row = font[3],
		end_col = font[4] + 1,
		conceal = "",
	});

	vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_end, range.col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",
	});

	if config.hl == nil then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl)
	});
	---_
end

---@param buffer integer
---@param item __latex.inlines
latex.inline = function (buffer, item)
	---+${func}

	---@type latex.inlines_static?
	local config = spec.get({ "latex", "inlines" }, { fallback = nil, eval_args = { buffer, item } });
	local range = item.range;

	if not config then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + #item.marker,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
		},

		hl_mode = "combine"
	});

	if #item.text > 1 then
		vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start, range.col_start + #item.text[1], {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) }
			}
		});
	end

	vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl),
	});

	vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_end, range.col_end - (#item.marker or 0), {
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

	if #item.text > 1 then
		vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_end, 0, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
			}
		});
	end

	for l = 1, #item.text - 2 do
		vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start + l, 0, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
			}
		});

		vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start + l, #item.text[l + 1], {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) }
			}
		});
	end
	---_
end

---@param buffer integer
---@param item __latex.parenthesis
latex.parenthesis = function (buffer, item)
	---+${func}

	---@type latex.parenthesis?
	local config = spec.get({ "latex", "parenthesis" }, { fallback = nil });

	if not config then
		return;
	end

	local range = item.range;

	--- Left parenthesis
	vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = ""
	});

	--- Right parenthesis
	vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_end, range.col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = ""
	});
	---_
end

---@param buffer integer
---@param item __latex.subscripts
latex.subscript = function (buffer, item)
	---+${func}

	---@type latex.subscripts?
	local config = spec.get({ "latex", "subscripts" }, { fallback = nil, eval_args = { buffer, item } });

	if not config then
		return;
	end

	local range = item.range;
	local hl;

	if vim.islist(config.hl) then
		hl = config.hl[utils.clamp(item.level, 1, #config.hl)];
	elseif type(config.hl) == "string" then
		hl = config.hl;
	end

	vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + (item.parenthesis and 2 or 1),
		conceal = "",

		virt_text_pos = "inline",
		virt_text = item.preview == false and { { "↓(", utils.set_hl(hl) } } or nil,

		hl_mode = "combine"
	});

	if item.parenthesis then
		table.insert(latex.cache.style_regions.subscripts, item);

		vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_row = range.row_end,
			end_col = range.col_end,

			hl_group = utils.set_hl(hl)
		});

		vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_end, range.col_end - 1, {
			undo_restore = false, invalidate = true,
			end_col = range.col_end,
			conceal = "",

			virt_text_pos = "inline",
			virt_text = item.preview == false and { { ")", utils.set_hl(hl) } } or nil,

			hl_mode = "combine"
		});
	elseif symbols.subscripts[item.text[1]:sub(2)] then
		vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start, range.col_start + 1, {
			undo_restore = false, invalidate = true,
			virt_text_pos = "overlay",
			virt_text = { { symbols.subscripts[item.text[1]:sub(2)], utils.set_hl(hl) } },

			hl_mode = "combine"
		});
	end

	vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(hl)
	});
	---_
end

---@param buffer integer
---@param item __latex.superscripts
latex.superscript = function (buffer, item)
	---+${func}

	---@type latex.superscripts?
	local config = spec.get({ "latex", "superscripts" }, { fallback = nil, eval_args = { buffer, item } });

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + (item.parenthesis and 2 or 1),
		conceal = "",

		virt_text_pos = "inline",
		virt_text = item.preview == false and { { "↑(", utils.set_hl(config.hl) } } or nil,

		hl_mode = "combine"
	});

	if item.parenthesis then
		if item.preview then
			table.insert(latex.cache.style_regions.superscripts, item);
		else
			vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start, range.col_start, {
				undo_restore = false, invalidate = true,
				end_row = range.row_end,
				end_col = range.col_end,

				hl_group = utils.set_hl(config.hl)
			});
		end

		vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_end, range.col_end - 1, {
			undo_restore = false, invalidate = true,
			end_col = range.col_end,
			conceal = "",

			virt_text_pos = "inline",
			virt_text = item.preview == false and { { ")", utils.set_hl(config.hl) } } or nil,

			hl_mode = "combine"
		});
	elseif symbols.superscripts[item.text[1]:sub(2)] then
		vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start, range.col_start + 1, {
			undo_restore = false, invalidate = true,
			virt_text_pos = "overlay",
			virt_text = { { symbols.superscripts[item.text[1]:sub(2)], utils.set_hl(config.hl) } },

			hl_mode = "combine"
		});
	end
	---_
end

--------------------------------------------------------------------------------------------

--- Gets text style.
---@param buffer integer
---@param range node.range
---@param opts { symbol: string?, text: string? }
---@return string | nil
---@return string | nil
local get_style = function (buffer, range, opts)
	---+${lua}
	opts = opts or {};

	local function is_smaller (range_1, range_2)
		local r_diff_1 = range_1.row_end - range_1.row_start;
		local r_diff_2 = range_2.row_end - range_2.row_start;

		local c_diff_1 = range_1.col_end - range_1.col_start;
		local c_diff_2 = range_2.col_end - range_2.col_start;

		if r_diff_1 ~= r_diff_2 then
			return r_diff_2 > r_diff_1 and 1 or 2;
		else
			return c_diff_2 > c_diff_1 and 1 or 2;
		end
	end

	local function result_text (tbl)
		tbl = tbl or {};

		if opts.symbol then
			return tbl[opts.symbol] or symbols.entries[opts.symbol];
		elseif opts.text then
			local _t = "";

			for letter in opts.text:gmatch(".") do
				if tbl[letter] then
					_t = _t .. tbl[letter];
				else
					_t = _t .. letter;
				end
			end

			return _t;
		end
	end

	local _o;
	local text, hl;
	local styles = latex.cache.style_regions or {};

	---+${lua, Get the smallest style node that contains this range}
	for _, entry in ipairs(styles.subscripts or {}) do
		if utils.within_range(entry.range, range) then
			if _o == nil then
				_o = entry;
			elseif is_smaller(entry.range, _o.range) == 1 then
				_o = entry;
			end
		end
	end

	for _, entry in ipairs(styles.superscripts or {}) do
		if utils.within_range(entry.range, range) then
			if _o == nil then
				_o = entry;
			elseif is_smaller(entry.range, _o.range) == 1 then
				_o = entry;
			end
		end
	end

	for _, entry in ipairs(latex.cache.font_regions or {}) do
		if utils.within_range(entry.range, range) then
			if _o == nil then
				_o = entry;
			elseif is_smaller(entry.range, _o.range) == 1 then
				_o = entry;
			end
		end
	end
	---_

	if _o == nil then
		if opts.symbol then
			text = result_text(symbols.entries);
		elseif opts.text then
			text = result_text(symbols.fonts.default);
		end
	elseif _o.class == "latex_subscript" then
		---@type latex.subscripts?
		local config = spec.get({ "latex", "subscripts" }, { fallback = nil, eval_args = { buffer, _o } });

		if not config then
			return;
		end

		if vim.islist(config.hl) then
			---@type string
			hl = config.hl[utils.clamp(_o.level, 1, #config.hl)];
		elseif type(config.hl) == "string" then
			---@type string | nil
			hl = config.hl;
		end

		text = result_text(symbols.subscripts);
	elseif _o.class == "latex_superscript" then
		---@type latex.subscripts?
		local config = spec.get({ "latex", "superscripts" }, { fallback = nil, eval_args = { buffer, _o } });

		if not config then
			return;
		end

		if vim.islist(config.hl) then
			---@type string
			hl = config.hl[utils.clamp(_o.level, 1, #config.hl)];
		elseif type(config.hl) == "string" then
			---@type string | nil
			hl = config.hl;
		end

		text = result_text(symbols.superscripts);
	elseif _o.class == "latex_font" then
		---@type latex.fonts?
		local main_config = spec.get({ "latex", "fonts" }, { fallback = nil });

		if main_config == nil then
			return;
		elseif symbols.fonts[_o.name] == nil then
			return;
		end

		---@type fonts.opts?
		local config = utils.match(main_config, _o.name, { eval_args = { buffer, item } });

		if config == nil then
			return;
		elseif vim.tbl_isempty(config) == true then
			return;
		end

		---@type string | nil
		hl = config.hl;
		text = result_text( symbols.fonts[_o.name] ) or result_text( symbols.fonts.default );
	end

	return text, hl;
	---_
end

---@param buffer integer
---@param item __latex.symbols
latex.symbol = function (buffer, item)
	---+${func}

	---@type latex.symbols?
	local config = spec.get({ "latex", "symbols" }, { fallback = nil, eval_args = { buffer, item } });

	if not config then
		return;
	elseif not item.name or not symbols.entries[item.name] then
		return;
	end

	local range = item.range;
	local _o, hl = get_style(buffer, range, { symbol = item.name });

	if type(hl) ~= "string" then
		hl = config.hl;
	end

	vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = { { _o or "", utils.set_hl(hl) } },

		hl_mode = "combine"
	});
	---_
end

---@param buffer integer
---@param item __latex.text
latex.text = function (buffer, item)
	---+${func}

	---@type latex.texts?
	local config = spec.get({ "latex", "texts" }, { fallback = nil });

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + #"\\text{",
		conceal = ""
	});

	vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_end, range.col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = ""
	});
	---_
end

---@param buffer integer
---@param item __latex.word
latex.word = function (buffer, item)
	---+${func}

	---@type latex.fonts?
	local config = spec.get({ "latex", "fonts" }, { fallback = nil });

	if not config then
		return;
	end

	local range = item.range;
	local _o, hl = get_style(buffer, range, { text = item.text[1] or "" });

	if _o == nil then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, latex.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		virt_text_pos = "overlay",
		virt_text = { { _o, utils.set_hl(hl) } },
		hl_mode = "combine"
	});
	---_
end

--- Renders LaTeX preview.
---@param buffer integer
---@param content table[]
latex.render = function (buffer, content)
	--- Clean up previous caches.
	latex.cache = {
		font_regions = {},
		style_regions = {
			superscripts = {},
			subscripts = {}
		},
	};

	local custom = spec.get({ "renderers" }, { fallback = {} });
	local post = {};

	for _, item in ipairs(content or {}) do
		if vim.list_contains({ "latex_word", "latex_symbol" }, item.class) == true then
			table.insert(post, item);
		else
			local success, err;

			if custom[item.class] then
				success, err = pcall(custom[item.class], latex.ns, buffer, item);
			else
				success, err = pcall(latex[item.class:gsub("^latex_", "")], buffer, item);
			end

			if success == false then
				require("markview.health").notify("trace", {
					level = 4,
					message = {
						{ " r/latex.lua: ", "DiagnosticVirtualTextInfo" },
						{ " " },
						{ err, "DiagnosticError" }
					}
				});
			end
		end
	end

	for _, item in ipairs(post) do
		local success, err;

		if custom[item.class] then
			success, err = pcall(custom[item.class], latex.ns, buffer, item);
		else
			success, err = pcall(latex[item.class:gsub("^latex_", "")], buffer, item);
		end

		if success == false then
			require("markview.health").notify("trace", {
				level = 4,
				message = {
					{ " r/latex.lua: ", "DiagnosticVirtualTextInfo" },
					{ " " },
					{ err, "DiagnosticError" }
				}
			});
		end
	end
end

--- Clears LaTeX previews.
---@param buffer integer
---@param from integer?
---@param to integer!
latex.clear = function (buffer, from, to)
	vim.api.nvim_buf_clear_namespace(buffer, latex.ns, from or 0, to or -1);
end

return latex;
