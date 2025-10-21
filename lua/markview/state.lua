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

--- Enable/Disable `markview.nvim`
---@param to boolean
state.enable = function (to)
	state.enable = to;
end

---@param buffer? integer
---@param default? boolean
---@return markview.state.buf?
state.buffer_state = function (buffer, default)
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

return state;
