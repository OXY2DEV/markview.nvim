local actions = {};

---|fS "chunk: Hybrid mode related stuff"

---@return boolean in_hybrid_mode
---@return boolean in_linewise_hybrid_mode
---@private
actions.in_hybrid_mode = function ()
	---|fS

	local spec = require("markview.spec");

	---@type string[] List of modes where to use hybrid_mode.
	local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });
	---@type boolean Is line-wise hybrid mode enabled?
	local linewise_hybrid_mode = spec.get({ "preview", "linewise_hybrid_mode" }, { fallback = false, ignore_enable = true })

	local mode = vim.api.nvim_get_mode().mode;

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

			renderer.clear(buffer, R[1], R[2], true);
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
	local state = _state or require("markview.state").get_buffer_state(buffer, true);

	---@cast state markview.state.buf

	actions.clear(buffer);

	if state.enable == false then
		spec.tmp_reset();
		return;
	end

	---@type integer Number of lines a buffer can have to be fully rendered.
	local line_limit = spec.get({ "preview", "max_buf_lines" }, { fallback = 1000, ignore_enable = true });

	local L = vim.api.nvim_buf_line_count(buffer);
	local H, LH = actions.in_hybrid_mode();

	if L <= line_limit then
		local content, _ = parser.parse(buffer, 0, -1, true);

		if H then
			actions.handle_hybrid_mode(LH, buffer, L, vim.fn.win_findbuf(buffer), content);
		else
			renderer.render(buffer, content);
		end
	else
		for _, win in ipairs(vim.fn.win_findbuf(buffer)) do
			local content, _ = parser.parse(buffer, 0, -1, true);

			if H then
				actions.handle_hybrid_mode(LH, buffer, L, { win }, content);
			else
				renderer.render(buffer, content);
			end
		end
	end

	spec.tmp_reset();

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

	-- health.notify("trace", {
	-- 	level = 1,
	-- 	message = {
	-- 		{ "Callback: ", "Special" },
	-- 		{ " " .. autocmd .. " ", "DiagnosticVirtualTextInfo" }
	-- 	}
	-- });

	---|fE
end

------------------------------------------------------------------------------

actions.set_query = function (buffer)
	---|fS

	local default_path = vim.treesitter.query.get_files("markdown", "highlights")[1];

	if not default_path then
		return;
	end

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

actions.reset_query = function (buffer)
	---|fS

	if not vim.g.__markdown_default_hl_query then
		return;
	end

	vim.treesitter.query.set("markdown", "highlights", vim.g.__markdown_default_hl_query);

	vim.treesitter.stop(buffer);
	vim.treesitter.start(buffer)

	---|fE
end

------------------------------------------------------------------------------

actions.attach = function (buffer, _state)
	---|fS

	---@type integer
	buffer = buffer or vim.api.nvim_get_current_buf();

	local spec = require("markview.spec");
	local state = require("markview.state");

	if state.can_attach(buffer) == false then
		return;
	end

	-- health.notify("trace", {
	-- 	level = 8,
	-- 	message = string.format("Attached: %d", buffer)
	-- });
	-- health.__child_indent_in();

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

	if buf_state and buf_state.enable == true then
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

	-- health.__child_indent_de();

	---|fE
end

actions.detach = function (buffer)
	---|fS

	---@type integer
	buffer = buffer or vim.api.nvim_get_current_buf();

	-- health.notify("trace", {
	-- 	level = 9,
	-- 	message = string.format("Detached: %d", buffer)
	-- });
	-- health.__child_indent_in();

	actions.autocmd("on_detach", buffer, vim.fn.win_findbuf(buffer))

	--[[
		Remove buffer from the list of attached buffers.

		NOTE: The `state` should be kept in case we need to reuse them later.
	]]
	require("markview.state").detach(buffer, false);
	actions.clear(buffer);
	-- health.__child_indent_de()

	---|fE
end

------------------------------------------------------------------------------

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

	-- health.notify("trace", {
	-- 	level = 6,
	-- 	message = string.format("Enabled: %d", buffer)
	-- });
	-- health.__child_indent_in();
	actions.set_query(buffer);
	state.set_buffer_state(buffer, { enable = true, hybrid_mode = nil });

	local mode = vim.api.nvim_get_mode().mode;
	---@type string[]
	local prev_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });

	if vim.list_contains(prev_modes, mode) == false then
		-- health.__child_indent_de();
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

	if actions.in_hybrid_mode() then
		actions.autocmd("on_hybrid_enable", buffer, vim.fn.win_findbuf(buffer))
	end

	-- health.__child_indent_de();

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
		state.enable(false);
		return;
	end

	-- health.notify("trace", {
	-- 	level = 7,
	-- 	message = string.format("Disabled: %d", buffer)
	-- });
	-- health.__child_indent_in();

	actions.reset_query(buffer);

	--[[
		fix(markdown): Restore `breakindent` before clearing.

		We need to *restore* the original value of `breakindent` to respect user preference(we need to check if a cached value exists first).
	]]

	for _, win in ipairs(vim.fn.win_findbuf(buffer)) do
		vim.wo[win].breakindent = vim.w[win].__mkv_cached_breakindet;
	end

	state.enable(false);
	actions.clear(buffer);

	actions.autocmd("on_disable", buffer, vim.fn.win_findbuf(buffer))

	if actions.in_hybrid_mode() then
		actions.autocmd("on_hybrid_disable", buffer, vim.fn.win_findbuf(buffer))
	end

	-- health.__child_indent_de();

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

	old_state.enable = true;
	state.set_buffer_state(buffer, old_state);

	if old_state.enable == false then
		return;
	elseif state.get_splitview_source() == buffer then
		return;
	end


	if actions.in_hybrid_mode() then
		actions.autocmd("on_hybrid_enable", buffer, vim.fn.win_findbuf(buffer))
	end

	actions.render(buffer);

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

	old_state.enable = false;
	state.set_buffer_state(buffer, old_state);

	if old_state.enable == false then
		return;
	elseif state.get_splitview_source() == buffer then
		return;
	end


	if actions.in_hybrid_mode() then
		actions.autocmd("on_hybrid_enable", buffer, vim.fn.win_findbuf(buffer))
	end

	actions.render(buffer);

	---|fE
end

return actions;
