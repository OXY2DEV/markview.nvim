--[[
Manages state for `markview.nvim`.
]]
local state = {};

---@type markview.state
state.vars = {
	enable = true,
	attached_buffers = {},
	buffer_states = {},

	splitview_buffer = nil,
	splitview_source = nil,
	splitview_window = nil,

	modified_queries = false;
};


state.buf_safe = function (buffer)
	---|fS

	if type(buffer) ~= "number" then
		return false;
	elseif vim.api.nvim_buf_is_valid(buffer) == false then
		return false;
	elseif vim.v.exiting ~= vim.NIL then
		--[[
			BUG(no-repro): Crash when exiting Neovim.

			There used to be a bug that caused crashes when exiting `Neovim`.
			I can no longer reproduce it on `main`. So, this is *legacy code*.
		]]
		return false;
	end

	return true;

	---|fE
end

state.win_safe = function (window)
	---|fS

	if not window then
		return false;
	elseif vim.api.nvim_win_is_valid(window) == false then
		return false;
	elseif vim.api.nvim_win_get_tabpage(window) ~= vim.api.nvim_get_current_tabpage() then
		--[[
			NOTE: Some window functions can't be called on some windows.

			This happens if the window isn't *visible*/not in the **current tab**.
		]]
		return false;
	end

	return true;

	---|fE
end


--- Enable/Disable `markview.nvim`
---@param to boolean
state.enable = function (to)
	state.vars.enable = to;
end

---@param buffer? integer
---@param default? boolean
---@return markview.state.buf?
state.get_buffer_state = function (buffer, default)
	if type(buffer) ~= "number" then
		return;
	elseif state.vars.buffer_states[buffer] then
		return state.vars.buffer_states[buffer];
	elseif default == false then
		return;
	end

	local spec = require("markview.spec");

	---@type boolean Should preview be enabled on the buffer?
	local enable = spec.get({ "preview", "enable" }, { fallback = true, ignore_enable = true });
	---@type boolean Should hybrid mode be enabled on the buffer?
	local hm_enable = spec.get({ "preview", "enable_hybrid_mode" }, { fallback = true, ignore_enable = true });

	return {
		enable = enable,
		hybrid_mode = hm_enable
	};
end

---@param buffer integer
---@param new_state markview.state.buf
state.set_buffer_state = function (buffer, new_state)
	if state.vars.buffer_states[buffer] and not new_state then
		return;
	end

	local spec = require("markview.spec");

	---@type boolean Should preview be enabled on the buffer?
	local enable = spec.get({ "preview", "enable" }, { fallback = true, ignore_enable = true });
	---@type boolean Should hybrid mode be enabled on the buffer?
	local hm_enable = spec.get({ "preview", "enable_hybrid_mode" }, { fallback = true, ignore_enable = true });

	state.vars.buffer_states[buffer] = vim.tbl_extend("force", {
		enable = enable,
		hybrid_mode = hm_enable
	}, new_state or {});
end

state.can_attach = function (buffer)
	if state.buf_safe(buffer) == false then
		return false;
	elseif vim.list_contains(state.vars.attached_buffers, buffer) then
		return false;
	end

	return true;
end

---@param buffer integer
state.attach = function (buffer, _state)
	if state.can_attach(buffer) == false then
		return;
	end

	table.insert(state.vars.attached_buffers, buffer);
	state.set_buffer_state(buffer, _state);
end

return state;
