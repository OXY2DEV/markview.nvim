local utils = {};

--- Clamps a value between a range
---@param val number
---@param min number
---@param max number
---@return number
utils.clamp = function (val, min, max)
	return math.min(math.max(val, min), max);
end

--- Linear interpolation between 2 values
---@param x number
---@param y number
---@param t number
---@return number
utils.lerp = function (x, y, t)
	return x + ((y - x) * t);
end

--- Checks if a highlight group exists or not
---@param hl string
---@return boolean
utils.hl_exists = function (hl)
	if not vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = hl })) then
		return true;
	elseif not vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = "Markview" .. hl })) then
		return true;
	end

	return false;
end

--- Gets attached windows from a buffer ID
---@param buf integer
---@return integer[]
utils.find_attached_wins = function (buf)
	local attached_wins = {};

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == buf then
			table.insert(attached_wins, win);
		end
	end

	return attached_wins;
end

--- Gets the start & stop line for a range from the cursor
---@param buffer integer
---@param window integer
---@return integer
---@return integer
utils.get_cursor_range = function (buffer, window)
	local cursor = vim.api.nvim_win_get_cursor(window or 0);
	local lines = vim.api.nvim_buf_line_count(buffer);

	return math.max(0, cursor[1] - 1), math.min(lines, cursor[1]);
end

return utils;
