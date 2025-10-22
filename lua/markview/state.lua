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


state.clean = function (on_clear, on_splitview_clear)
	for buffer, _ in pairs(state.vars.attached_buffers) do
		if state.buf_safe(buffer) == false then
			state.vars.attached_buffers[buffer] = nil;
			pcall(on_clear, buffer);
		end

		if buffer == state.get_splitview_source() then
			pcall(on_splitview_clear, buffer);
		end
	end
end

--- Enable/Disable `markview.nvim`
---@param to boolean
state.enable = function (to)
	state.vars.enable = to;
end

state.enabled = function ()
	return state.vars.enable;
end

state.buf_attach = function (buffer, to)
	state.vars.attached_buffers[buffer] = to;

	if not state.vars.buffer_states[buffer] and to then
		state.set_buffer_state(buffer);
	end
end

state.buf_attached = function (buffer)
	return state.vars.attached_buffers[buffer] == true;
end

state.get_splitview_source = function ()
	return state.vars.splitview_source;
end

state.set_splitview_source = function (buffer)
	state.vars.splitview_source = buffer;
end

state.get_splitview_buffer = function (create)
	if create ~= false then
		state.set_splitview_buffer();
	end

	return state.vars.splitview_buffer;
end

state.set_splitview_buffer = function ()
	local old = state.get_splitview_buffer(false);

	if not old or vim.api.nvim_buf_is_valid(old) == false then
		state.vars.splitview_buffer = vim.api.nvim_create_buf(false, true);
	end
end

state.get_splitview_window = function (opts, create)
	if create ~= false then
		state.set_splitview_window(opts);
	end

	return state.vars.splitview_window;
end

state.set_splitview_window = function (opts)
	local old = state.get_splitview_window({}, false);

	if not old or vim.api.nvim_win_is_valid(old) == false then
		state.vars.splitview_window = vim.api.nvim_open_win(
			state.get_splitview_buffer(),
			false,
			opts or { split = "right", }
		);
	end
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
---@param new_state? markview.state.buf
state.set_buffer_state = function (buffer, new_state)
	if state.vars.buffer_states[buffer] and not new_state then
		return;
	end

	local spec = require("markview.spec");

	---@type boolean Should preview be enabled on the buffer?
	local enable = spec.get({ "preview", "enable" }, { fallback = true, ignore_enable = true });
	---@type boolean Should hybrid mode be enabled on the buffer?
	local hm_enable = spec.get({ "preview", "enable_hybrid_mode" }, { fallback = true, ignore_enable = true });

	state.vars.buffer_states[buffer] = vim.tbl_extend("force", state.vars.buffer_states[buffer] or {
		enable = enable,
		hybrid_mode = hm_enable
	}, new_state or {});
end

state.can_attach = function (buffer)
	if state.buf_safe(buffer) == false then
		return false;
	elseif state.vars.attached_buffers[buffer] then
		return false;
	end

	return true;
end

---@param buffer integer
state.attach = function (buffer, _state)
	if state.can_attach(buffer) == false then
		return;
	end

	state.vars.attached_buffers[buffer] = true;
	state.set_buffer_state(buffer, _state);
end

state.detach = function (buffer, reset_state)
	state.vars.attached_buffers[buffer] = nil;

	if reset_state then
		state.vars.buffer_states[buffer] = nil;
	end
end

return state;
