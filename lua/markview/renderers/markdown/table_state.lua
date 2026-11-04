-- Layout data belongs to the buffer lifecycle, not serializable vim.b values
-- or a temporary collection of extmarks in the split preview.
local M = {};
local buffers = {};

local function resolve(buffer)
	return buffer == 0 and vim.api.nvim_get_current_buf() or buffer;
end

function M.get(buffer)
	return buffers[resolve(buffer)] or {};
end

function M.add(buffer, plan)
	buffer = resolve(buffer);
	local plans = buffers[buffer] or {};
	for i, existing in ipairs(plans) do
		if existing.first == plan.first then
			plans[i] = plan;
			buffers[buffer] = plans;
			return;
		end
	end
	plans[#plans + 1] = plan;
	buffers[buffer] = plans;
end

function M.clear(buffer, first, last)
	buffer = resolve(buffer);
	if first == nil and last == nil then buffers[buffer] = nil; return; end
	local keep = {};
	for _, plan in ipairs(buffers[buffer] or {}) do
		if not ((last == nil or last < 0 or plan.first < last) and plan.last > (first or 0)) then
			keep[#keep + 1] = plan;
		end
	end
	buffers[buffer] = #keep > 0 and keep or nil;
end

vim.api.nvim_create_autocmd("BufWipeout", {
	group = vim.api.nvim_create_augroup("MarkviewTableState", { clear = true }),
	callback = function(args) buffers[args.buf] = nil; end,
});

return M;
