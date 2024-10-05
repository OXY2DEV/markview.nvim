local editor = {};

local utils = require("markview.utils");
local languages = require("markview.languages");

--- Configuration table for the editor.
---@class markview.editor.configuraton
---
--- Table containing various text processors.
---
--- The key is the "node name" where this will run
--- The value is a function that receives the buffer ID
--- & the node itself
---
--- It should return a filetype, A list of lines to show
--- in the editor, the start & the end range of the lines
--- where the edited text will be added.
---
---@field processors { [string]: fun(buffer: integer, TSNode: table): string, string[], integer, integer }
---
--- Table containing various text appliers. Used on
--- the edited text before replacing them in the buffer.
---
---@field appliers { [string]: fun(buffer: integer, TSNode: table, lines: string[]): string[] }
---
--- A tuple containing the minimum width and the maximum width.
--- If the values are <1 then they are used as % of screen columns.
---
---@field width [ number, number ]
---
--- A tuple containing the minimum height and the maximum height.
--- If the values are <1 then they are used as % of screen lines.
---
---@field height [ number, number ]
---@field debounce integer Debounce delay for window resizing.
---
---@field border? string | string[] Window border.
---@field border_hl? string Window border highlight group.
---@field filename_hl? string Filename highlight group.
---@field lnum_hl? string Line number highlight group.
editor.configuraton = {
	processors = {
		["fenced_code_block"] = function (buffer, TSNode)
			local start, col, stop, _ = TSNode:range();
			local lines = vim.api.nvim_buf_get_lines(buffer, start, stop, false);

			local ft = lines[1]:match("```(%S*)") or "lua";
			local _l = {};

			table.remove(lines, 1);
			table.remove(lines, #lines);

			for _, line in ipairs(lines) do
				table.insert(_l, line:sub(col, #line))
			end

			return ft:gsub("[%{%}]", ""), _l, start + 1, stop - 1;
		end
	},
	appliers = {
		["fenced_code_block"] = function (buffer, TSNode, lines)
			local start, _, _, _ = TSNode:range();
			local delimiter = vim.api.nvim_buf_get_lines(buffer, start, start + 1, false)[1];

			local before = delimiter:match("^(.-)```");

			for l, line in ipairs(lines) do
				lines[l] = (before or "") .. line
			end

			return lines;
		end
	},

	width = { 0.5, 0.75 },
	height = { 3, 0.75 },

	debounce = 50,

	border = "rounded",
	border_hl = nil,

	filename_hl = nil,
	lnum_hl = nil,

	callback = function (buf, win)
		vim.wo[win].sidescrolloff = 0;
		vim.bo[buf].expandtab = true;
	end
}

--- Gets the filetype from an info string
---@param delim string
---@return string
local get_ft = function (delim)
	local ft = "";

	if delim:match("^```%{%{(.-)%}%}") then
		ft = languages.get_ft(delim:match("^```%{%{(.-)%}%}"));
	elseif delim:match("^```%{(.-)%}") then
		ft = languages.get_ft(delim:match("^```%{(.-)%}"));
	elseif delim:match("^```(%S+)") then
		ft = languages.get_ft(delim:match("^```(%S+)"));
	end

	return ft;
end

--- Creates a new buffer when not available.
--- Otherwise, returns the current editor buffer.
---@return integer
local set_buf = function ()
	if not editor.buffer or vim.api.nvim_buf_is_valid(editor.buffer) == false then
		local buf = vim.api.nvim_create_buf(false, true);
		return buf;
	end

	return editor.buffer;
end

--- Creates a new window when not available.
--- Otherwise, returns the current editor window
--- and switches to that window
---@param config table
---@return integer
local set_win = function (config)
	if not editor.window or vim.api.nvim_win_is_valid(editor.window) == false then
		local win = vim.api.nvim_open_win(editor.buffer, true, config);
		pcall(editor.configuraton.callback, editor.buffer, win);
		return win;
	elseif vim.api.nvim_win_get_tabpage(editor.window) ~= vim.api.nvim_get_current_tabpage() then
		pcall(vim.api.nvim_win_close, editor.window, true);

		local win = vim.api.nvim_open_win(editor.buffer, true, config);
		pcall(editor.configuraton.callback, editor.buffer, win);
		return win;
	end

	vim.api.nvim_win_set_config(editor.window, config);
	vim.api.nvim_set_current_win(editor.window);

	pcall(editor.configuraton.callback, editor.buffer, editor.window);
	return editor.window;
end

--- When value is <1 returns the value multiplied by
--- the multiplier result, otherwise returns the
--- main value.
---@param val number
---@param multiplier number
---@return number
local get_val = function (val, multiplier)
	return val < 1 and math.floor(multiplier * val) or val;
end

--- Gets the window dimensions
---@param lines string[]
---@param border string | string[]
---@return integer
---@return integer
---@return number
---@return number
local win_dimensions = function (lines, border)
	local min_w = get_val(editor.configuraton.width[1], vim.o.columns);
	local min_h = get_val(editor.configuraton.height[1], vim.o.lines);

	local max_w = get_val(editor.configuraton.width[2], vim.o.columns);
	local max_h = get_val(editor.configuraton.height[2], vim.o.lines);

	local w, h;

	local current_w, current_h = 0, #lines;

	for _, line in ipairs(lines) do
		if vim.fn.strdisplaywidth(line) > current_w then
			current_w = vim.fn.strdisplaywidth(line);
		end
	end

	if border then
		current_w = current_w + 2;
		current_h = current_h + 2;
	end

	w = utils.clamp(current_w, min_w, max_w);
	h = utils.clamp(current_h, min_h, max_h);

	if border then
		w = w - 2;
		h = h - 2;
	end

	return math.floor((vim.o.columns - w) / 2), math.floor((vim.o.lines - h) / 2), w, h;
end

---@type integer? The buffer ID
editor.buffer = nil;
---@type integer? The window ID
editor.window = nil;

---@type integer The autocmd group
editor.augroup = vim.api.nvim_create_augroup("markview_editor", { clear = true });

--- Opens the editor with the node under the cursor
editor.open = function ()
	editor.buffer = set_buf();

	local buffer = vim.api.nvim_get_current_buf();

	if buffer == editor.buffer then
		return;
	end

	local TSNode = vim.treesitter.get_node({ ignore_injections = true });

	local processors = editor.configuraton.processors;
	local ft, lines;
	local from, to;
	local buf_start, buf_stop;

	local file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buffer), ":t");

	while TSNode:parent() do
		local tp = TSNode:type();

		if processors[tp] and pcall(processors[tp], buffer, TSNode) then
			ft, lines, buf_start, buf_stop = processors[tp](buffer, TSNode);
			from, _, to, _ = TSNode:range();
			break;
		end

		TSNode = TSNode:parent();
	end

	if not lines then
		return;
	end

	vim.api.nvim_create_autocmd("BufLeave", {
		group = editor.augroup,
		buffer = editor.buffer,

		callback = function ()
			pcall(vim.api.nvim_win_close, editor.window, true);
		end
	});

	local timer = vim.uv.new_timer();

	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		group = editor.augroup,
		buffer = editor.buffer,

		callback = function ()
			timer:stop();
			timer:start(editor.configuraton.debounce, 0, vim.schedule_wrap(function ()
				local col, row, width, height = win_dimensions(vim.api.nvim_buf_get_lines(editor.buffer, 0, -1, false), editor.configuraton.border);

				vim.api.nvim_win_set_config(editor.window, {
					relative = "editor",

					row = row,
					col = col,

					width = width,
					height = height,
				});
			end))
		end
	});

	vim.api.nvim_buf_set_keymap(editor.buffer, "n", "<CR>", "", {
		callback = function ()
			local edited = vim.api.nvim_buf_get_lines(editor.buffer, 0, -1, false);

			if editor.configuraton.appliers and editor.configuraton.appliers[TSNode:type()] then
				edited = editor.configuraton.appliers[TSNode:type()](buffer, TSNode, edited);
			end

			vim.api.nvim_buf_set_lines(buffer, buf_start, buf_stop, false, edited);
			vim.api.nvim_set_current_buf(buffer);
		end
	})

	vim.api.nvim_buf_set_keymap(editor.buffer, "n", "<ESC>", "", {
		callback = function ()
			pcall(vim.api.nvim_win_close, editor.window, true);
		end
	})

	vim.api.nvim_buf_set_keymap(editor.buffer, "n", "q", "", {
		callback = function ()
			pcall(vim.api.nvim_win_close, editor.window, true);
		end
	})

	vim.api.nvim_buf_set_lines(editor.buffer, 0, -1, false, lines);
	vim.bo[editor.buffer].filetype = ft;

	local col, row, width, height = win_dimensions(lines, editor.configuraton.border);
	local icon, hl = languages.get_icon(ft);

	hl = hl .. "Fg";

	editor.window = set_win({
		relative = "editor",

		row = row,
		col = col,

		width = width,
		height = height,

		border = editor.configuraton.border,

		title = {
			{ "╼ ", editor.configuraton.border_hl or hl },
			{ file, editor.configuraton.filename_hl or "Conceal" },
			{ ": ", "Conceal" },
			{ tostring(from + 1), editor.configuraton.lnum_hl or "Special" },
			{ "-","Conceal" },
			{ tostring(to), editor.configuraton.lnum_hl or "Special" },
			{ " ╾", editor.configuraton.border_hl or hl }
		},
		title_pos = "left",

		footer = {
			{ "╼ ", editor.configuraton.border_hl or hl },
			{ icon, hl },
			{ languages.get_name(ft), hl },
			{ " ╾", editor.configuraton.border_hl or hl }
		},
		footer_pos = "right"
	});

	vim.wo[editor.window].winhl = "FloatBorder:" .. (editor.configuraton.border_hl or hl);
	vim.wo[editor.window].statuscolumn = "";
	vim.wo[editor.window].number = false;
	vim.wo[editor.window].relativenumber = false;
end

--- Creates a simple code block
editor.create = function ()
	local buffer = vim.api.nvim_get_current_buf();
	local cursor = vim.api.nvim_win_get_cursor(0);

	if buffer == editor.buffer then
		return;
	end

	editor.buffer = set_buf();

	local start_delim, end_delim = "```lua", "```";
	local lines, ft = { "" }, "lua";

	vim.api.nvim_create_autocmd("BufLeave", { group = editor.augroup, buffer = editor.buffer, callback = function () pcall(vim.api.nvim_win_close, editor.window, true); end });

	local timer = vim.uv.new_timer();

	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		group = editor.augroup,
		buffer = editor.buffer,

		callback = function ()
			timer:stop();
			timer:start(editor.configuraton.debounce, 0, vim.schedule_wrap(function ()
				local col, row, width, height = win_dimensions(vim.api.nvim_buf_get_lines(editor.buffer, 0, -1, false), editor.configuraton.border);
				vim.api.nvim_win_set_config(editor.window, { relative = "editor", row = row, col = col, width = width, height = height });
			end))
		end
	});

	vim.api.nvim_buf_set_keymap(editor.buffer, "n", "<CR>", "", {
		callback = function ()
			local ln = vim.api.nvim_buf_get_lines(buffer, cursor[1] - 1, cursor[1], false)[1];
			local edited = vim.api.nvim_buf_get_lines(editor.buffer, 0, -1, false);

			local before = ln:match("^([%s%>]*)")

			local _o = {
				before .. start_delim,
			};

			for _, line in ipairs(edited) do
				table.insert(_o, before .. line);
			end

			table.insert(_o, before .. end_delim)

			vim.api.nvim_buf_set_lines(buffer, cursor[1], cursor[1], false, _o);
			vim.api.nvim_set_current_buf(buffer);
		end
	})

	vim.api.nvim_buf_set_keymap(editor.buffer, "n", "<tab>", "", {
		callback = function ()
			vim.ui.input({ prompt = "Start delimiter: ", default = start_delim }, function (input)
				if not input then
					return;
				end

				start_delim = tostring(input);
				vim.bo[editor.buffer].filetype = get_ft(start_delim);
				local icon, hl = languages.get_icon(get_ft(start_delim));

				ft = get_ft(start_delim);

				hl = hl .. "Fg";

				editor.window = set_win({
					title = {
						{ "╼ ", hl },
						{ " Create on line: ", "Conceal" },
						{ tostring(cursor[1]), editor.configuraton.lnum_hl or "Special" },
						{ " ", "Conceal" },
						{ " ╾", hl }
					},

					footer = {
						{ "╼ ", hl },
						{ icon, hl },
						{ languages.get_name(ft), hl },
						{ " ╾", hl }
					},
					footer_pos = "right"
				});
				vim.wo[editor.window].winhl = "FloatBorder:" .. hl;
			end)
		end
	});

	vim.api.nvim_buf_set_keymap(editor.buffer, "n", "<S-tab>", "", {
		callback = function ()
			vim.ui.input({ prompt = "End delimiter: ", default = end_delim }, function (input)
				if not input then
					return;
				end

				end_delim = tostring(input);
			end)
		end
	});

	vim.api.nvim_buf_set_keymap(editor.buffer, "n", "<ESC>", "", {
		callback = function ()
			pcall(vim.api.nvim_win_close, editor.window, true);
		end
	})

	vim.api.nvim_buf_set_keymap(editor.buffer, "n", "q", "", {
		callback = function ()
			pcall(vim.api.nvim_win_close, editor.window, true);
		end
	})

	vim.api.nvim_buf_set_lines(editor.buffer, 0, -1, false, lines);
	vim.bo[editor.buffer].filetype = ft;

	local col, row, width, height = win_dimensions(lines, editor.configuraton.border);
	local icon, hl = languages.get_icon(ft);

	hl = hl .. "Fg";

	editor.window = set_win({
		relative = "editor",

		row = row,
		col = col,

		width = width,
		height = height,

		border = editor.configuraton.border,

		title = {
			{ "╼ ", hl },
			{ " Create on line: ", "Conceal" },
			{ tostring(cursor[1]), editor.configuraton.lnum_hl or "Special" },
			{ " ", "Conceal" },
			{ " ╾", hl }
		},

		footer = {
			{ "╼ ", hl },
			{ icon, hl },
			{ languages.get_name(ft), hl },
			{ " ╾", hl }
		},
		footer_pos = "right"
	});

	vim.wo[editor.window].winhl = "FloatBorder:" .. hl;
	vim.wo[editor.window].statuscolumn = "";
	vim.wo[editor.window].number = false;
	vim.wo[editor.window].relativenumber = false;
end

--- Setup function
---@param config markview.editor.configuraton?
editor.setup = function (config)
	editor.configuraton = vim.tbl_deep_extend("force", editor.configuraton, config or {});

	vim.api.nvim_create_user_command("CodeCreate", function ()
		editor.create();
	end, {
		desc = "Creates a code block"
	})

	vim.api.nvim_create_user_command("CodeEdit", function ()
		editor.open();
	end, {
		desc = "Opens the editor"
	})
end

vim.api.nvim_create_autocmd("VimResized", {
	group = editor.augroup,
	callback = function ()
		if not editor.window or vim.api.nvim_win_is_valid(editor.window) == false then
			return;
		elseif vim.api.nvim_win_get_tabpage(editor.window) ~= vim.api.nvim_get_current_tabpage() then
			return;
		end

		local col, row, width, height = win_dimensions(vim.api.nvim_buf_get_lines(editor.buffer, 0, -1, false), editor.configuraton.border);

		vim.api.nvim_win_set_config(editor.window, {
			relative = "editor",

			row = row,
			col = col,

			width = width,
			height = height,
		});
	end
})

return editor;
