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
---@param config? markview.config
actions.render = function (_buffer, _state, config)
	---|fS

	local parser = require("markview.parser");
	local renderer = require("markview.renderer");
	local spec = require("markview.spec");

	spec.tmp_setup(config);

	local buffer = _buffer or vim.api.nvim_get_current_buf();
	local state = _state or require("markview.state").buffer_state(buffer, true);

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

return actions;
