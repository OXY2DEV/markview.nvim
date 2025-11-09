local actions = {};

---|fS "chunk: Hybrid mode related stuff"

---@return boolean in_preview_mode
actions.in_preview_mode = function (mode)
	---|fS

	local spec = require("markview.spec");

	---@type string[] List of modes where to show previews.
	local modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
	mode = mode or vim.api.nvim_get_mode().mode;

	if vim.list_contains(modes, mode) == false then
		return false;
	end

	return true;

	---|fE
end

---@return boolean in_hybrid_mode
---@return boolean in_linewise_hybrid_mode
actions.in_hybrid_mode = function (mode)
	---|fS

	local spec = require("markview.spec");

	---@type string[] List of modes where to use hybrid_mode.
	local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });
	---@type boolean Is line-wise hybrid mode enabled?
	local linewise_hybrid_mode = spec.get({ "preview", "linewise_hybrid_mode" }, { fallback = false, ignore_enable = true })

	mode = mode or vim.api.nvim_get_mode().mode;

	if vim.list_contains(hybrid_modes, mode) == false then
		return false, false;
	elseif not linewise_hybrid_mode then
		return true, false;
	end

	return true, true;

	---|fE
end

---@param from integer
---@param offset [ integer, integer ]
---@param max integer
---@return [ integer, integer ]
---@private
actions.get_range = function (from, offset, max)
	return {
		math.max(0, from - offset[1]),
		math.min(from + offset[2], max)
	};
end

--[[ Handles `hybrid mode` rendering. ]]
---@param linewise boolean
---@param buffer integer
---@param line_count integer
---@param wins integer[]
---@param content table
---@private
actions.handle_hybrid_mode = function (linewise, buffer, line_count, wins, content)
	---|fS

	local spec = require("markview.spec");
	local renderer = require("markview.renderer");

	---@type [ integer, integer ] Number of lines to be considered being edited.
	local edit_range = spec.get({ "preview", "edit_range" }, { fallback = { 0, 0 }, ignore_enable = true });

	--[[
		NOTE(hybrid_mode): Handling `hybrid mode`.

		If `linewise == false`, we iterate over each window and clear nodes within the `editing range`.
		We remove them from the parsed data directly.

		If `linewise == true`, we render first then clear the correct range.
	]]
	if not linewise then
		for _, win in ipairs(wins) do
			---@type [ integer, integer ] Cursor position.
			local cursor = vim.api.nvim_win_get_cursor(win);

			content = renderer.filter(
				content,
				nil,
				actions.get_range(cursor[1] - 1, edit_range, line_count)
			);
		end

		renderer.render(buffer, content);
	else
		renderer.render(buffer, content);

		for _, win in ipairs(wins) do
			---@type [ integer, integer ] Cursor position.
			local cursor = vim.api.nvim_win_get_cursor(win);
			local R = actions.get_range(cursor[1] - 1, edit_range, line_count);

			-- NOTE: We add 1 to the `row_end` because it is inclusive.
			renderer.clear(buffer, R[1], R[2] + 1, true);
		end
	end

	---|fE
end

---|fE

--- Wrapper to clear decorations from a buffer
---@param buffer integer
actions.clear = function (buffer)
	buffer = buffer or vim.api.nvim_get_current_buf();
	require("markview.renderer").clear(buffer, 0, -1);
end

--- Renders preview.
---@param _buffer integer?
---@param _state? markview.state.buf
---@param _config? markview.config
actions.render = function (_buffer, _state, _config)
	---|fS

	local parser = require("markview.parser");
	local renderer = require("markview.renderer");
	local spec = require("markview.spec");

	spec.tmp_setup(_config);

	local buffer = _buffer or vim.api.nvim_get_current_buf();

	local state = require("markview.state");
	local buf_state = _state or state.get_buffer_state(buffer, true);

	---@cast buf_state markview.state.buf

	actions.clear(buffer);

	if buf_state.enable == false then
		spec.tmp_reset();
		return;
	end

	require("markview.health").print({
		from = "markview/actions.lua",
		fn = "render()",

		message = "Rendering preview.",
		nest = true
	});

	---@type integer Number of lines a buffer can have to be fully rendered.
	local line_limit = spec.get({ "preview", "max_buf_lines" }, { fallback = 1000, ignore_enable = true });

	local L = vim.api.nvim_buf_line_count(buffer);
	local H, LH = actions.in_hybrid_mode();

	if L <= line_limit then
		local content, _ = parser.parse(buffer, 0, -1, true);

		if H and buf_state.hybrid_mode then
			actions.handle_hybrid_mode(LH, buffer, L, vim.fn.win_findbuf(buffer), content);
		else
			renderer.render(buffer, content);
		end
	else
		local draw_range = spec.get({ "preview", "draw_range" }, { fallback = { vim.o.lines, vim.o.lines }, ignore_enable = true });

		for _, win in ipairs(vim.fn.win_findbuf(buffer)) do
			local cursor = vim.api.nvim_win_get_cursor(win);
			local R = actions.get_range(cursor[1], draw_range, L);

			-- TODO: See if we need to `R[2] + 1`.
			local content, _ = parser.parse(buffer, R[1], R[2], true);

			if H and buf_state.hybrid_mode then
				actions.handle_hybrid_mode(LH, buffer, L, { win }, content);
			else
				renderer.render(buffer, content);
			end
		end
	end

	spec.tmp_reset();
	require("markview.health").print({ kind = "skip", back = true });

	---|fE
end

actions.splitview_setup = function ()
	---|fS

	local spec = require("markview.spec");
	local state = require("markview.state");
	local src = state.get_splitview_source();

	if not src or state.buf_safe(src) == false then
		actions.splitClose();
		return;
	end

	local win = vim.fn.win_findbuf(src)[1];

	if state.win_safe(win) == false then
		actions.splitClose();
		return;
	end

	local sp_buf = state.get_splitview_buffer();

	vim.bo[sp_buf].ft = vim.bo[src].ft;
	actions.set_query(sp_buf);

	local sp_win = state.get_splitview_window(
		spec.get({ "preview", "splitview_winopts", }, {
			fallback = { split = "right" },
			ignore_enable = true
		})
	);

	vim.wo[sp_win].wrap = vim.wo[win].wrap;
	vim.wo[sp_win].linebreak = vim.wo[win].linebreak;

	vim.wo[sp_win].number = false;
	vim.wo[sp_win].relativenumber = false;
	vim.wo[sp_win].list = false;
	vim.wo[sp_win].winhl = "Normal:Normal";

	---|fE
end

actions.splitview_cursor = function ()
	---|fS

	local state = require("markview.state");

	local buffer = state.get_splitview_source();
	local window = vim.fn.win_findbuf(buffer)[1];

	if state.buf_safe(buffer) == false then
		return;
	elseif not window or state.win_safe(window) == false then
		return;
	end

	local sp_win = state.get_splitview_window({}, false);

	if sp_win then
		require("markview.health").print({
			from = "markview/actions.lua",
			fn = "splitview_cursor()",

			message = "Updated cursor(splitview).",
		});

		local cursor = vim.api.nvim_win_get_cursor(window);
		pcall(vim.api.nvim_win_set_cursor, sp_win, cursor);
	end

	---|fE
end

actions.splitview_render = function ()
	---|fS

	local state = require("markview.state");
	local buffer = state.get_splitview_source();

	if state.buf_safe(buffer) == false then
		pcall(actions.splitClose);
		return;
	end

	require("markview.health").print({
		from = "markview/actions.lua",
		fn = "splitview_render()",

		message = "Rendering splitview.",
		nest = true
	});

	local spec =require("markview.spec");

	actions.splitview_setup();

	local max_lines = spec.get({ "preview", "max_buf_lines" }, { fallback = 1000, ignore_enable = true });
	local line_count = vim.api.nvim_buf_line_count(buffer);

	local main_win = vim.fn.win_findbuf(buffer)[1];
	local cursor = vim.api.nvim_win_get_cursor(main_win);

	---@type integer, integer
	local pre_buf, pre_win = state.get_splitview_buffer(), state.get_splitview_window();
	local pre_cursor = vim.api.nvim_win_get_cursor(pre_win);
	local pre_line_count = vim.api.nvim_buf_line_count(pre_buf);

	local BR  = actions.get_range(cursor[1], { max_lines, max_lines + 1 }, line_count);
	local SR = actions.get_range(pre_cursor[1], { max_lines, max_lines + 1 }, pre_line_count);

	local lines = vim.api.nvim_buf_get_lines(buffer, BR[1], BR[2], false);

	--[[
		BUG: Mismatch line count between `source buffer` & `preview buffer`.

		When deleting lines from the source buffer the line count will be different between th `source buffer` & the `preview buffer`.
		This causes lines to not updated correctly in splitview.

		FIX: Use 2 ranges.

		One range is used for getting the lines from the `source buffer`.
		Another range is used for getting which lines to clear in the `preview buffer`.

		See #408
	]]
	vim.api.nvim_buf_set_lines(pre_buf, SR[1], SR[2], false, lines);

	pcall(vim.api.nvim_win_set_cursor, pre_win, cursor);

	actions.render(pre_buf, {
		enable = true,
		hybrid_mode = false
	});
	require("markview.health").print({ kind = "skip", back = true });

	---|fE
end

------------------------------------------------------------------------------

--- Executes callbacks/autocmds.
---@param autocmd string
---@param ... any
actions.autocmd = function (autocmd, ...)
	---|fS

	local args = { ... };
	local map = {
		on_attach = { "MarkviewAttach", { buffer = args[1], windows = args[2] } },
		on_enable = { "MarkviewEnable", { buffer = args[1], windows = args[2] } },
		on_hybrid_enable = { "MarkviewHybridEnable", { buffer = args[1], windows = args[2] } },
		on_hybrid_disable = { "MarkviewHybridDisable", { buffer = args[1], windows = args[2] } },
		on_disable = { "MarkviewDisable", { buffer = args[1], windows = args[2] } },
		on_detach = { "MarkviewDetach", { buffer = args[1], windows = args[2] } },
		on_splitview_open = { "MarkviewSplitviewOpen", { source = args[1], preview_buffer = args[2], preview_window = args[3] } },
		on_splitview_close = { "MarkviewSplitviewClose", { source = args[1], preview_buffer = args[2], preview_window = args[3] } },
	};

	if not map[autocmd] then
		return;
	end

	local spec = require("markview.spec");

	local callbacks = spec.get({ "preview", "callbacks" }, { fallback = nil, ignore_enable = true });
	pcall(callbacks[autocmd], ...);
	vim.api.nvim_exec_autocmds("User", { pattern = map[autocmd][1], data = map[autocmd][2] });

	require("markview.health").print({
		from = "markview/actions.lua",
		fn = "autocmd() -> " .. autocmd,

		message = "Fired " .. autocmd .. " & " .. map[autocmd][1] .. ".",
	});

	---|fE
end

actions.clean = function ()
	---|fS

	require("markview.state").clean(nil, function ()
		-- NOTE: If the buffer is being previewed in a `split view` we should close the split view window.
		actions.splitClose();
	end);

	---|fE
end

------------------------------------------------------------------------------

--[[ Sets custom `tree-sitter` queries. ]]
---@param buffer integer
actions.set_query = function (buffer)
	---|fS

	local default_path = vim.treesitter.query.get_files("markdown", "highlights")[1];

	if not default_path then
		return;
	end

	require("markview.health").print({
		from = "markview/actions.lua",
		fn = "set_query()",

		message = "Set tree-sitter queries for " .. buffer .. ".",
	});

	local default = table.concat(
		vim.fn.readfile(default_path),
		"\n"
	);
	vim.g.__markdown_default_hl_query = default;

	local capture_1 = table.concat({
		"%(fenced_code_block",
		"%s*%(fenced_code_block_delimiter%) @markup.raw.block",
		'%s*%(#set! conceal ""%)',
		'%s*%(#set! conceal_lines ""%)%)',
	}, "");

	local capture_2 = table.concat({
		"%(fenced_code_block",
		'%s*%(info_string',
		'%s*%(language%) @label',
		'%s*%(#set! conceal ""%)',
		'%s*%(#set! conceal_lines ""%)%)%)',
	}, "");

	local updated = string.gsub(default, capture_1, ""):gsub(capture_2, "");
	vim.treesitter.query.set("markdown", "highlights", updated);

	vim.treesitter.stop(buffer);
	vim.treesitter.start(buffer)

	--[[]
		NOTE: Only set query for `buffer`.

		By restoring the active query, we can prevent new buffers from using *our* queries.
		This allows us to avoid issues with other plugins that make use of the default queries.

		See #404
	]]
	vim.treesitter.query.set("markdown", "highlights", vim.g.__markdown_default_hl_query);

	---|fE
end

--[[ Resets custom `tree-sitter` queries. ]]
---@param buffer integer
actions.reset_query = function (buffer)
	---|fS

	if not vim.g.__markdown_default_hl_query then
		return;
	end

	require("markview.health").print({
		from = "markview/actions.lua",
		fn = "reset_query()",

		message = "Reset tree-sitter queries for " .. buffer .. ".",
	});

	vim.treesitter.query.set("markdown", "highlights", vim.g.__markdown_default_hl_query);

	vim.treesitter.stop(buffer);
	vim.treesitter.start(buffer)

	---|fE
end

------------------------------------------------------------------------------

--[[ Attaches to `buffer`, optionally with a `state`. ]]
---@param buffer? integer
---@param _state markview.state.buf
actions.attach = function (buffer, _state)
	---|fS

	---@type integer
	buffer = buffer or vim.api.nvim_get_current_buf();

	local spec = require("markview.spec");
	local state = require("markview.state");

	if state.can_attach(buffer) == false then
		return;
	end

	require("markview.health").print({
		from = "markview/actions.lua",
		fn = "attach()",

		message = "Attached to " .. buffer .. ".",
		nest = true,
	});

	state.attach(buffer, _state);

	---@type boolean Whether `gx` should be remapped.
	local map_gx = spec.get({ "preview", "map_gx" }, { ignore_enable = true, fallback = true });

	if map_gx then
		vim.api.nvim_buf_set_keymap(buffer, "n", "gx", "<CMD>Markview open<CR>", {
			desc = "Tree-sitter based link opener from `markview.nvim`."
		});
	end

	actions.autocmd("on_attach", buffer, vim.fn.win_findbuf(buffer))
	local buf_state = state.get_buffer_state(buffer, false);

	if buf_state and buf_state.enable then
		actions.set_query(buffer);

		actions.autocmd("on_enable", buffer, vim.fn.win_findbuf(buffer))
		actions.render(buffer);

		if buf_state.hybrid_mode then
			actions.autocmd("on_hybrid_enable", buffer, vim.fn.win_findbuf(buffer))
		else
			actions.autocmd("on_hybrid_disable", buffer, vim.fn.win_findbuf(buffer))
		end
	else
		actions.reset_query(buffer);
		actions.clear(buffer);

		actions.autocmd("on_disable", buffer, vim.fn.win_findbuf(buffer))
	end

	require("markview.health").print({ kind = "skip", back = true });

	---|fE
end

--[[ Detaches from `buffer`. ]]
---@param buffer? integer
actions.detach = function (buffer)
	---|fS

	---@type integer
	buffer = buffer or vim.api.nvim_get_current_buf();

	require("markview.health").print({
		from = "markview/actions.lua",
		fn = "detach()",

		message = "Detached from " .. buffer .. ".",
		nest = true,
	});

	actions.autocmd("on_detach", buffer, vim.fn.win_findbuf(buffer))

	--[[
		Remove buffer from the list of attached buffers.

		NOTE: The `state` should be kept in case we need to reuse them later.
	]]
	require("markview.state").detach(buffer, false);
	actions.clear(buffer);
	require("markview.health").print({ kind = "skip", back = true });

	---|fE
end

------------------------------------------------------------------------------

actions.toggle = function (buffer)
	---|fS

	---@type integer
	buffer = buffer or vim.api.nvim_get_current_buf();

	local state = require("markview.state");

	if state.buf_attached(buffer) == false then
		return;
	elseif state.get_splitview_source() == buffer then
		return;
	end

	local buf_state = state.get_buffer_state(buffer, false);

	if not buf_state then
		return;
	elseif buf_state.enable then
		actions.disable(buffer);
	else
		actions.enable(buffer);
	end

	---|fE
end

actions.enable = function (buffer)
	---|fS

	---@type integer
	buffer = buffer or vim.api.nvim_get_current_buf();

	local spec = require("markview.spec");
	local state = require("markview.state");

	if state.buf_attached(buffer) == false then
		return;
	elseif state.get_splitview_source() == buffer then
		return;
	end

	require("markview.health").print({
		from = "markview/actions.lua",
		fn = "enable()",

		message = "Enabled preview for " .. buffer .. ".",
		nest = true,
	});

	actions.set_query(buffer);
	---@diagnostic disable-next-line: assign-type-mismatch
	state.set_buffer_state(buffer, { enable = true, hybrid_mode = nil });

	local mode = vim.api.nvim_get_mode().mode;
	---@type string[]
	local prev_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });

	if vim.list_contains(prev_modes, mode) == false then
		require("markview.health").print({ kind = "skip", back = true });
		return;
	end

	---|fS 

	--[[
		fix(markdown): Disable `breakindent` before rendering.

		This is to prevent `text wrap support` from being broken due to `breakindent` changing where wrapped text is shown.
	]]

	for _, win in ipairs(vim.fn.win_findbuf(buffer)) do
		vim.w[win].__mkv_cached_breakindet = vim.wo[win].breakindent;
		vim.wo[win].breakindent = false;
	end

	---|fE

	actions.render(buffer);
	actions.autocmd("on_enable", buffer, vim.fn.win_findbuf(buffer))

	local buf_state = state.get_buffer_state(buffer) --[[@as markview.state.buf]];

	if actions.in_hybrid_mode() then
		actions.autocmd(buf_state.hybrid_mode and "on_hybrid_enable" or "on_hybrid_disable", buffer, vim.fn.win_findbuf(buffer))
	end

	require("markview.health").print({ kind = "skip", back = true });

	---|fE
end

actions.disable = function (buffer)
	---|fS

	---@type integer
	buffer = buffer or vim.api.nvim_get_current_buf();

	local state = require("markview.state");

	if state.buf_attached(buffer) == false then
		return;
	elseif state.get_splitview_source() == buffer then
		return;
	end

	require("markview.health").print({
		from = "markview/actions.lua",
		fn = "enable()",

		message = "Disabled preview for " .. buffer .. ".",
		nest = true,
	});

	actions.reset_query(buffer);
	---@diagnostic disable-next-line: assign-type-mismatch
	state.set_buffer_state(buffer, { enable = false, hybrid_mode = nil });

	--[[
		fix(markdown): Restore `breakindent` before clearing.

		We need to *restore* the original value of `breakindent` to respect user preference(we need to check if a cached value exists first).
	]]

	for _, win in ipairs(vim.fn.win_findbuf(buffer)) do
		vim.wo[win].breakindent = vim.w[win].__mkv_cached_breakindet;
	end

	actions.clear(buffer);
	actions.autocmd("on_disable", buffer, vim.fn.win_findbuf(buffer))

	if actions.in_hybrid_mode() then
		actions.autocmd("on_hybrid_disable", buffer, vim.fn.win_findbuf(buffer))
	end

	require("markview.health").print({ kind = "skip", back = true });

	---|fE
end

------------------------------------------------------------------------------

actions.hybridTtoggle = function (buffer)
	---|fS

	buffer = buffer or vim.api.nvim_get_current_buf();

	local state = require("markview.state");
	local old_state = state.get_buffer_state(buffer, false);

	if state.buf_attached(buffer) == false then
		return;
	elseif not old_state then
		return;
	end

	if old_state.hybrid_mode == true then
		actions.hybrid_disable();
	else
		actions.hybrid_enable();
	end

	---|fE
end

actions.hybridEnable = function (buffer)
	---|fS

	buffer = buffer or vim.api.nvim_get_current_buf();

	local state = require("markview.state");
	local old_state = state.get_buffer_state(buffer, false);

	if state.buf_attached(buffer) == false then
		return;
	elseif not old_state then
		return;
	elseif old_state.hybrid_mode == true then
		return;
	end

	old_state.hybrid_mode = true;
	state.set_buffer_state(buffer, old_state);

	if old_state.enable == false then
		return;
	elseif state.get_splitview_source() == buffer then
		return;
	end

	require("markview.health").print({
		from = "markview/actions.lua",
		fn = "hybridEnable()",

		message = "Enabled hybrid mode for " .. buffer .. ".",
		nest = true,
	});

	if actions.in_hybrid_mode() then
		actions.autocmd("on_hybrid_enable", buffer, vim.fn.win_findbuf(buffer))
	end

	actions.render(buffer);
	require("markview.health").print({ kind = "skip", back = true });

	---|fE
end

actions.hybridDisable = function (buffer)
	---|fS

	buffer = buffer or vim.api.nvim_get_current_buf();

	local state = require("markview.state");
	local old_state = state.get_buffer_state(buffer, false);

	if state.buf_attached(buffer) == false then
		return;
	elseif not old_state then
		return;
	elseif old_state.hybrid_mode == false then
		return;
	end

	old_state.hybrid_mode = false;
	state.set_buffer_state(buffer, old_state);

	if old_state.enable == false then
		return;
	elseif state.get_splitview_source() == buffer then
		return;
	end

	require("markview.health").print({
		from = "markview/actions.lua",
		fn = "hybridDisable()",

		message = "Disabled hybrid mode for " .. buffer .. ".",
		nest = true,
	});

	if actions.in_hybrid_mode() then
		actions.autocmd("on_hybrid_disable", buffer, vim.fn.win_findbuf(buffer))
	end

	actions.render(buffer);
	require("markview.health").print({ kind = "skip", back = true });

	---|fE
end

------------------------------------------------------------------------------

actions.splitToggle = function ()
	--|fS

	local state = require("markview.state");

	if state.get_splitview_source() then
		actions.splitClose();
	else
		actions.splitOpen();
	end

	---|fE
end

actions.splitOpen = function (buffer)
	--|fS

	---@type integer
	buffer = buffer or vim.api.nvim_get_current_buf();
	local state = require("markview.state");

	if state.buf_safe(buffer) == false then
		return;
	end

	require("markview.health").print({
		from = "markview/actions.lua",
		fn = "splitOpen()",

		message = "Opened splitview for " .. buffer .. ".",
	});

	actions.splitClose();

	local buf_state = state.get_buffer_state(buffer, false);

	if buf_state and buf_state.enable == true then
		actions.autocmd("on_disable", buffer, vim.fn.win_findbuf(buffer));
	end

	state.set_splitview_source(buffer);

	actions.splitview_setup();
	actions.clear(buffer);

	actions.autocmd("on_splitview_open", buffer, state.get_splitview_buffer(), state.get_splitview_window());
	actions.splitview_render();

	---|fE
end

actions.splitClose = function ()
	---|fS

	local state = require("markview.state");
	local src = state.get_splitview_source();

	if not src then
		return;
	end

	local sp_buf = state.get_splitview_buffer(false);
	local sp_win = state.get_splitview_window({}, false);

	actions.autocmd("on_splitview_close", src, sp_buf, sp_win);
	pcall(vim.api.nvim_win_close, sp_win, true);

	state.set_splitview_source(nil);
	state.vars.splitview_window = nil;

	if state.buf_safe(sp_buf) == true then
		actions.clear(sp_buf);
		vim.api.nvim_buf_set_lines(sp_buf, 0, -1, false, {});
	end

	require("markview.health").print({
		from = "markview/actions.lua",
		fn = "splitClose()",

		message = "Closed splitview.",
	});

	if state.buf_safe(src) == false then
		return;
	elseif not state.get_buffer_state(src, false) then
		return;
	end

	local src_state = state.get_buffer_state(src, false);

	--[[
		NOTE(@OXY2DEV): Only trigger `on_enable` on valid buffers!

		For a buffer to be considered *valid*,
			1. `markview.nvim`'s preview must be **enabled**.
			2. `markview.nvim` should be attached to `buffer`.
			3. Previews must be **enabled** for `buffer`.
	]]
	if state.enabled() and src_state and src_state.enable then
		actions.autocmd("on_enable", src, vim.fn.win_findbuf(src));
		actions.render(src);
	end

	---|fE
end

------------------------------------------------------------------------------

actions.traceExport = function ()
	local scrolloff = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].textoff;
	local buf_width = vim.o.columns - scrolloff;

	local version = vim.version();
	local colorscheme = vim.g.colors_name or "";

	local time_col = math.max(20, math.floor((buf_width - 7) * 0.2));
	local desc_col = buf_width - (time_col + 3);

	local function center (text, width)
		if vim.fn.strdisplaywidth(text) > width then
			return vim.fn.strcharpart(text, width);
		else
			local pad_amount = width - vim.fn.strdisplaywidth(text);
			return string.rep(" ", math.ceil(pad_amount / 2)) .. text .. string.rep(" ", math.floor(pad_amount / 2));
		end
	end

	local lines = {
		"Plugin: markview.nvim",
		"Time: " .. os.date(),
		string.format("Nvim version: %d.%d.%d", version.major, version.minor, version.patch),
		"Colorscheme: " .. colorscheme,
		"",
		"Level description,",
		"  1 = START",
		"  2 = PAUSE",
		"  3 = STOP",
		"  4 = ERROR",
		"  5 = LOG",
		"  6 = ENABLE",
		"  7 = DISABLE",
		"  8 = ATTACH",
		"  9 = DETACH",
		"",
		"Trace,",
		string.rep("-", time_col) .. "•-------•" .. string.rep("-", desc_col),
		center("Time-stamp", time_col) .. "|" .. " Level " .. "|" .. center("Action", desc_col),
		string.rep("-", time_col) .. "•-------•" .. string.rep("-", desc_col)
	};

	for _, entry in ipairs(require("markview.health").log) do
		if entry.kind ~= "trace" then
			goto continue;
		end

		table.insert(lines, string.format(
			"%s|%s| %s",
			center(
				string.format("%-12s", string.rep("  ", entry.indent) .. entry.timestamp),
				time_col
			),
			center(tostring(entry.level or 0), 7),
			entry.message
		));

		::continue::
	end

	table.insert(lines, string.rep("-", time_col) .. "•-------•" .. string.rep("-", desc_col))
	table.insert(lines, "");
	table.insert(lines, "vim:nomodifiable:nowrap:nospell:");

	local trace_file = io.open("trace.txt", "w");

	if not trace_file then
		return;
	end

	trace_file:write(table.concat(lines, "\n"));
	trace_file:close();
end

actions.forEach = function (fn, list)
	for _, item in ipairs(list) do
		pcall(fn, item);
	end
end

return actions;
