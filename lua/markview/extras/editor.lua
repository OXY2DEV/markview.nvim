local editor = {};

local filetypes = require("markview.filetypes");
local utils = require("markview.utils");

editor.config = {
	--- Default configuration for 
	--- the editor
	style = "float",

	min_width = math.max(math.floor(vim.o.columns * 0.5), 75),
	max_width = math.max(math.floor(vim.o.columns * 0.75), 100),

	min_height = 1,
	max_height = 10,

	create = {
		["markdown"] = {
			init = function (buffer)
				local win = utils.buf_getwin(buffer);
				local row = vim.api.nvim_win_get_cursor(win)[1];

				return { "```lua", "```" }, "lua", { row - 1, 0, row, 0 };
			end,
			formatter = function (buffer, range, lines)
				local this_line = vim.api.nvim_buf_get_lines(buffer, range[1], range[1] + 1, false)[1];
				local before = this_line:match("^[%s%>]*");

				for l, line in ipairs(lines) do
					lines[l] = before .. line;
				end

				return lines;
			end,

			language = function (input)
				if input:match("^```%s*%{(%a+)(.*)%}") then
					return input:match("^```%s*%{(%a+)(.*)%}");
				elseif input:match("^```(%a+)") then
					return input:match("^```(%a+)");
				else
					return "lua";
				end
			end
		},
	},
	edit = {
		["fenced_code_block"] = {
			---+${lua, Edits fenced code blocks in markdown}

			parser = function (buffer, TSNode)
				local range = { TSNode:range() };
				local lines = vim.api.nvim_buf_get_lines(buffer, range[1] + 1, range[3] - 1, false);

				local info_node = TSNode:named_child(1);
				local language;

				if info_node and info_node:named_child(0) then
					local lang_node = info_node:named_child(0);

					if lang_node and lang_node:type() == "language" then
						language = vim.treesitter.get_node_text(lang_node, buffer);
					end
				end

				for l, line in ipairs(lines) do
					lines[l] = line:sub(range[2] + 1);
				end

				range[1] = range[1] + 1;
				range[3] = range[3] - 1;

				return lines, language, range;
			end,
			formatter = function (buffer, range, text)
				local header = vim.api.nvim_buf_get_lines(buffer, range[1] - 1, range[1], false)[1] or "";
				local before = header:match("^[%s%>]*");

				for l, line in ipairs(text) do
					text[l] = before .. line;
				end

				return text;
			end,
			on_open = function (window)
				if type(window) ~= "number" then
					return;
				end

				vim.wo[window].sidescrolloff = 0;
			end

			---_
		}
	}
};

---+${lua, Editor section}

--- Cached data for editor.
---@class extras.editor.e_cache
---
---@field node_config table?
---@field source integer?
---@field range integer[]?
---@field lines string[]?
---@field ft string?
---@field au_mode integer?
---@field au_resi integer?
---@field au_text integer?
editor.e_cache = {
	node_config = nil,
	source = nil,
	range = nil,
	lines = nil,

	ft = nil,

	au_mode = nil,
	au_resi = nil,
	au_text = nil
};

editor.au = vim.api.nvim_create_augroup("extras/editor", { clear = true });
editor.buffer = nil;
editor.window = nil;

--- Gets window coordinates.
---@param lines string[]
---@return { x: integer, y: integer, w: integer, h: integer }
local window_coords = function (lines)
	---+${lua}

	local total_width  = vim.o.columns;
	local total_height = vim.o.lines;

	local win_width = editor.config.min_width;
	local win_height = utils.clamp(#lines, editor.config.min_height, editor.config.max_height);

	for _, line in ipairs(lines) do
		local line_width = vim.fn.strdisplaywidth(line);

		if line_width >= editor.config.max_width then
			win_width = editor.config.max_width;
			break;
		elseif line_width > win_width then
			win_width = line_width;
		end
	end

	return {
		x = math.ceil((total_width - win_width) / 2),
		y = math.ceil((total_height - win_height) / 2),

		w = win_width,
		h = win_height
	};

	---_
end

--- Closes open windows.
editor.close_editor = function ()
	---+${lua}

	pcall(vim.api.nvim_win_close, editor.window, true);
	editor.window = nil;

	pcall(vim.api.nvim_buf_set_lines, editor.buffer, 0, -1, false, {});

	---_
end

--- Applies edited text to the buffer.
editor.apply_edit = function ()
	if not editor.e_cache.node_config then
		return;
	end

	local lines = vim.api.nvim_buf_get_lines(editor.buffer, 0, -1, false);

	if editor.e_cache.node_config.formatter then
		lines = editor.e_cache.node_config.formatter(editor.e_cache.source, editor.e_cache.range, lines);
	end

	vim.api.nvim_buf_set_lines(editor.e_cache.source, editor.e_cache.range[1], editor.e_cache.range[3], false, lines);
end

--- Updates window dimensions.
editor.update_winpos = function ()
	---+${lua}

	if not editor.window or vim.api.nvim_win_is_valid(editor.window) == false then
		editor.close_editor();
		return;
	end

	local coords = window_coords(
		vim.api.nvim_buf_get_lines(editor.buffer, 0, -1, false)
	);

	vim.api.nvim_win_set_config(editor.window, {
		relative = "editor",

		width = coords.w,
		height = coords.h,

		row = coords.y,
		col = coords.x
	});

	---_
end

--- Opens editor window.
editor.open_editor = function ()
	---+${lua}

	---@type string[], string, integer[]
	local lines, ft, edit_range = editor.e_cache.lines, editor.e_cache.ft, editor.e_cache.range;
	local ft_data = filetypes.get(ft);

	--- Title to show.
	local title = {
		{ "╼ ", ft_data.border_hl },
		{ "Range: ", "Comment" },
		{ tostring(edit_range[1] + 1), "Special" },
		{ "-","Conceal" },
		{ tostring(edit_range[3]), "Special" },
		{ " ╾", ft_data.border_hl }
	};
	--- Footer to show.
	--- Also shows tooltips.
	local footer = {
		{ "╼ ", ft_data.border_hl },
		{ "q", "Special" },
		{ ": Quit, ", "Comment" },
		{ "<CR>", "Special" },
		{ ": Confirm", "Comment" },
		{ " ╶╴ ", ft_data.border_hl },
		{ ft_data.icon, ft_data.border_hl },
		{ ft_data.name, ft_data.border_hl },
		{ " ╾", ft_data.border_hl }
	};

	if not editor.buffer or vim.api.nvim_buf_is_valid(editor.buffer) == false then
		---+${lua, Prepares the buffer & needed autocmds}

		pcall(vim.api.nvim_del_autocmd, editor.e_cache.au_text);
		pcall(vim.api.nvim_del_autocmd, editor.e_cache.au_resi);
		pcall(vim.api.nvim_del_autocmd, editor.e_cache.au_mode);

		editor.buffer = vim.api.nvim_create_buf(false, true);
		local timer = vim.uv.new_timer();

		editor.e_cache.au_mode = vim.api.nvim_create_autocmd({ "ModeChanged" }, {
			group = editor.au,
			buffer = editor.buffer,

			callback = function ()
				---+${lua, Removes tooltips based on current VIM mode}

				local mode = vim.api.nvim_get_mode().mode;

				vim.api.nvim_win_set_config(editor.window, {
					footer = mode == "n" and footer or {
						{ "╼ ", ft_data.border_hl },
						{ ft_data.icon, ft_data.border_hl },
						{ ft_data.name, ft_data.border_hl },
						{ " ╾", ft_data.border_hl }
					},
					footer_pos = "right"
				});

				---_
			end
		});

		editor.e_cache.au_text = vim.api.nvim_create_autocmd({ "VimResized", "TextChanged", "TextChangedI" }, {
			group = editor.au,
			buffer = editor.buffer,

			callback = function ()
				---+${lua, Updates window position & size}
				timer:stop();
				timer:start(editor.config.debounce or 100, 0, vim.schedule_wrap(editor.update_winpos));
				---_
			end
		});

		---_
	end

	vim.bo[editor.buffer].filetype = ft;
	vim.api.nvim_buf_set_lines(editor.buffer, 0, -1, false, lines);

	--- New coordinates for the window.
	---@type { x: integer, y: integer, w: integer, h: integer }
	local coords = window_coords(lines);

	---+${lua, Creates/Updates window configuration}
	if editor.window and vim.api.nvim_win_is_valid(editor.window) then
		vim.api.nvim_win_set_config(editor.window, {
			relative = "editor",

			width = coords.w,
			height = coords.h,

			row = coords.y,
			col = coords.x,

			border = "rounded",
			style = "minimal",

			title = title,
			footer = footer,

			title_pos = "left",
			footer_pos = "right"
		});
	else
		editor.window = vim.api.nvim_open_win(editor.buffer, true, {
			relative = "editor",

			width = coords.w,
			height = coords.h,

			row = coords.y,
			col = coords.x,

			border = "rounded",
			style = "minimal",

			title = title,
			footer = footer,

			title_pos = "left",
			footer_pos = "right"
		});
	end
	---_

	--- Execute callback.
	if editor.e_cache.node_config.on_open then
		pcall(editor.e_cache.node_config.on_open, editor.window);
	end

	if ft_data.border_hl then
		vim.wo[editor.window].winhl = "FloatBorder:" .. ft_data.border_hl;
	end

	---+${lua, Sets up keymaps}
	vim.api.nvim_buf_set_keymap(editor.buffer, "n", "q", "", {
		callback = function ()
			editor.close_editor();
		end
	});

	vim.api.nvim_buf_set_keymap(editor.buffer, "n", "<CR>", "", {
		callback = function ()
			editor.apply_edit()
			editor.close_editor();
		end
	});
	---_

	--- Attaches LSP client.
	vim.api.nvim_buf_call(editor.buffer, function ()
		vim.cmd("LspStart");
	end);

	---_
end


editor.edit = function ()
	---+${lua}

	editor.close_editor();
	editor.e_cache.source = vim.api.nvim_get_current_buf();

	if editor.e_cache.source == editor.buffer then
		return;
	end

	local ts_available = function ()
		local ft = vim.bo[editor.e_cache.source].ft;
		local language = vim.treesitter.language.get_lang(ft);

		if language == nil then
			return false;
		elseif utils.parser_installed(language) == false then
			return false;
		end

		return true;
	end

	if ts_available() == false then
		--- Tree-sitter not available.
		return;
	end

	local edit_conf = editor.config.edit;
	local node = vim.treesitter.get_node();

	while node do
		if edit_conf[node:type()] then
			editor.e_cache.node_config = edit_conf[node:type()];

			---@type string[], string, integer[]
			editor.e_cache.lines, editor.e_cache.ft, editor.e_cache.range = editor.e_cache.node_config.parser(editor.e_cache.source, node)
			editor.open_editor();
			break;
		end

		node = node:parent();
	end

	---_
end

---_

editor.c_cache = {
	source = nil,
	node_config = nil,
	range = nil,
	ft = nil,
	delimiters = nil,

	au_mode = nil,
	au_resi = nil,
	au_text = nil
};

editor.create_block = function ()
	local lines = vim.api.nvim_buf_get_lines(editor.buffer, 0, -1, false);
	table.insert(lines, 1, editor.c_cache.delimiters[1]);
	table.insert(lines, editor.c_cache.delimiters[2]);

	---@type integer[]
	local range = editor.c_cache.range;

	if editor.c_cache.node_config.formatter then
		lines = editor.c_cache.node_config.formatter(
			editor.c_cache.source,
			range,
			lines
		);
	end

	vim.api.nvim_buf_set_lines(editor.c_cache.source, range[1], range[3], false, lines);
end

editor.close_creator = function ()
	---+${lua}

	pcall(vim.api.nvim_win_close, editor.window, true);
	editor.window = nil;

	pcall(vim.api.nvim_buf_set_lines, editor.buffer, 0, -1, false, {});

	---_
end

editor.update_editor = function ()
	---+${lua}

	---@type string, integer[]
	local ft, edit_range = editor.c_cache.ft, editor.c_cache.range;
	local ft_data = filetypes.get(ft);

	local lines = vim.api.nvim_buf_get_lines(editor.buffer, 0, -1, false);

	vim.bo[editor.buffer].filetype = ft;

	--- Title to show.
	local title = {
		{ "╼ ", ft_data.border_hl },
		{ "Create: ", "Comment" },
		{ tostring(edit_range[1] + 1), "Special" },
		{ " ╾", ft_data.border_hl }
	};
	--- Footer to show.
	--- Also shows tooltips.
	local footer = {
		{ "╼ ", ft_data.border_hl },
		{ "T", "Special" },
		{ ": Top delim, ", "Comment" },
		{ "B", "Special" },
		{ ": Bottom delim, ", "Comment" },
		{ "<CR>", "Special" },
		{ ": Confirm", "Comment" },
		{ " ╶╴ ", ft_data.border_hl },
		{ ft_data.icon, ft_data.border_hl },
		{ ft_data.name, ft_data.border_hl },
		{ " ╾", ft_data.border_hl }
	};

	--- New coordinates for the window.
	---@type { x: integer, y: integer, w: integer, h: integer }
	local coords = window_coords(lines);

	---+${lua, Creates/Updates window configuration}
	if editor.window and vim.api.nvim_win_is_valid(editor.window) then
		vim.api.nvim_win_set_config(editor.window, {
			relative = "editor",

			width = coords.w,
			height = coords.h,

			row = coords.y,
			col = coords.x,

			border = "rounded",
			style = "minimal",

			title = title,
			footer = footer,

			title_pos = "left",
			footer_pos = "right"
		});
	else
		editor.window = vim.api.nvim_open_win(editor.buffer, true, {
			relative = "editor",

			width = coords.w,
			height = coords.h,

			row = coords.y,
			col = coords.x,

			border = "rounded",
			style = "minimal",

			title = title,
			footer = footer,

			title_pos = "left",
			footer_pos = "right"
		});
	end
	---_

	if ft_data.border_hl then
		vim.wo[editor.window].winhl = "FloatBorder:" .. ft_data.border_hl;
	end

	--- Attaches LSP client.
	vim.api.nvim_buf_call(editor.buffer, function ()
		vim.cmd("LspStop");
		vim.cmd("LspStart");
	end);

	---_
end

editor.open_creator = function ()
	---+${lua}

	if not editor.buffer or vim.api.nvim_buf_is_valid(editor.buffer) == false then
		---+${lua, Prepares the buffer & needed autocmds}

		pcall(vim.api.nvim_del_autocmd, editor.c_cache.au_text);
		pcall(vim.api.nvim_del_autocmd, editor.c_cache.au_resi);
		pcall(vim.api.nvim_del_autocmd, editor.c_cache.au_mode);

		editor.buffer = vim.api.nvim_create_buf(false, true);
		local timer = vim.uv.new_timer();

		editor.c_cache.au_mode = vim.api.nvim_create_autocmd({ "ModeChanged" }, {
			group = editor.au,
			buffer = editor.buffer,

			callback = function ()
				---+${lua, Removes tooltips based on current VIM mode}

				local curr_ft = editor.c_cache.ft;
				local new_data = filetypes.get(curr_ft);

				local mode = vim.api.nvim_get_mode().mode;

				vim.api.nvim_win_set_config(editor.window, {
					footer = mode == "n" and {
						{ "╼ ", new_data.border_hl },
						{ "T", "Special" },
						{ ": Top delim, ", "Comment" },
						{ "B", "Special" },
						{ ": Bottom delim, ", "Comment" },
						{ "<CR>", "Special" },
						{ ": Confirm", "Comment" },
						{ " ╶╴ ", new_data.border_hl },
						{ new_data.icon, new_data.border_hl },
						{ new_data.name, new_data.border_hl },
						{ " ╾", new_data.border_hl }
					} or {
						{ "╼ ", new_data.border_hl },
						{ new_data.icon, new_data.border_hl },
						{ new_data.name, new_data.border_hl },
						{ " ╾", new_data.border_hl }
					},
					footer_pos = "right"
				});

				---_
			end
		});

		editor.c_cache.au_text = vim.api.nvim_create_autocmd({ "VimResized", "TextChanged", "TextChangedI" }, {
			group = editor.au,
			buffer = editor.buffer,

			callback = function ()
				---+${lua, Updates window position & size}
				timer:stop();
				timer:start(editor.config.debounce or 100, 0, vim.schedule_wrap(editor.update_winpos));
				---_
			end
		});

		---_
	end

	vim.api.nvim_buf_set_lines(editor.buffer, 0, -1, false, {});
	editor.update_editor();

	--- Execute callback.
	if editor.c_cache.node_config.on_open then
		pcall(editor.c_cache.node_config.on_open, editor.window);
	end

	---+${lua, Sets up keymaps}
	vim.api.nvim_buf_set_keymap(editor.buffer, "n", "q", "", {
		callback = function ()
			editor.close_creator();
		end
	});

	vim.api.nvim_buf_set_keymap(editor.buffer, "n", "<CR>", "", {
		callback = function ()
			editor.create_block();
			editor.close_creator();
		end
	});

	vim.api.nvim_buf_set_keymap(editor.buffer, "n", "T", "", {
		callback = function ()
			local top = vim.fn.input("Editor, Top delimiter: ", editor.c_cache.delimiters[1]);

			if top ~= nil and top ~= "" then
				editor.c_cache.delimiters[1] = top;
			end

			editor.c_cache.ft = editor.c_cache.node_config.language(top);
			editor.update_editor();
		end
	});

	vim.api.nvim_buf_set_keymap(editor.buffer, "n", "B", "", {
		callback = function ()
			local bottom = vim.fn.input("Editor, Bottom delimiter: ", editor.c_cache.delimiters[2]);

			if bottom ~= nil and bottom ~= "" then
				editor.c_cache.delimiters[2] = bottom;
			end
		end
	});
	---_
	---_
end

editor.create = function ()
	editor.close_creator();
	editor.c_cache.source = vim.api.nvim_get_current_buf();
	editor.c_cache.lines = {};

	if editor.c_cache.source == editor.buffer then
		return;
	end

	local ft = vim.bo[editor.c_cache.source].ft;

	if not editor.config.create[ft] then
		return;
	end

	editor.c_cache.node_config = editor.config.create[ft];

	editor.c_cache.delimiters, editor.c_cache.ft, editor.c_cache.range = editor.c_cache.node_config.init(editor.c_cache.source);
	editor.open_creator();
end


editor.actions = {
	["create"] = function ()
		editor.create();
	end,
	["edit"] = function ()
		editor.edit();
	end
};

editor.__completion = utils.create_user_command_class({
	default = {
		completion = function (arg_lead)
			local comp = {};

			for _, item in ipairs({ "create", "edit" }) do
				if item:match(arg_lead) then
					table.insert(comp, item);
				end
			end

			table.sort(comp);
			return comp;
		end,
		action = function ()
			editor.edit();
		end
	},
	sub_commands = {
		["create"] = {
			action = function ()
				editor.actions.create();
			end
		},
		["edit"] = {
			action = function ()
				editor.actions.edit();
			end,
		}
	}
});

--- New command
vim.api.nvim_create_user_command("Editor", function (params)
	editor.__completion:exec(params)
end, {
	nargs = 1,
	complete = function (...)
		return editor.__completion:comp(...)
	end
});

editor.setup = function (config)
	editor.config = vim.tbl_deep_extend("force", editor.config, config or {});
end

return editor;
