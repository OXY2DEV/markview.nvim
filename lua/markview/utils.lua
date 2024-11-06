local utils = {};

local ts_available, treesitter_parsers = pcall(require, "nvim-treesitter.parsers");
local ts_utils = require("nvim-treesitter.ts_utils");

--- Checks if a parser is available or not
---@param parser_name string
---@return boolean
utils.parser_installed = function (parser_name)
	return (ts_available and treesitter_parsers.has_parser(parser_name)) or pcall(vim.treesitter.query.get, parser_name, "highlights")
end

utils.within_range = function (range, pos)
	if pos.row_start < range.row_start then
		return false;
	elseif pos.row_end > range.row_end then
		return false;
	elseif
		(pos.row_start == range.row_start and pos.row_end == range.row_end) and
		(pos.col_start < range.col_start or pos.col_end > range.col_end)
	then
		return false;
	end

	return true;
end

--- Escapes magic characters from a string
---@param input string
---@return string
utils.escape_string = function (input)
	input = input:gsub("%%", "%%%%");

	input = input:gsub("%(", "%%(");
	input = input:gsub("%)", "%%)");

	input = input:gsub("%.", "%%.");
	input = input:gsub("%+", "%%+");
	input = input:gsub("%-", "%%-");
	input = input:gsub("%*", "%%*");
	input = input:gsub("%?", "%%?");
	input = input:gsub("%^", "%%^");
	input = input:gsub("%$", "%%$");

	input = input:gsub("%[", "%%[");
	input = input:gsub("%]", "%%]");

	return input;
end

-- vim.print(utils.escape_string(table.concat({ "", "", "󰌷 ", "X[XXXXXX]", "", "" })))

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

--- Checks if a highlight group exists or not
---@param hl string?
---@return string?
utils.set_hl = function (hl)
	if type(hl) ~= "string" then
		return;
	end

	if vim.fn.hlexists("Markview" .. hl) == 1 then
		return "Markview" .. hl;
	elseif vim.fn.hlexists("Markview_" .. hl) == 1 then
		return "Markview_" .. hl;
	else
		return hl;
	end
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

utils.virt_len = function (virt_texts)
	if not virt_texts then
		return 0;
	end

	local _l = 0;

	for _, text in ipairs(virt_texts) do
		_l = _l + vim.fn.strdisplaywidth(text[1]);
	end

	return _l;
end

return utils;
