--[[
Basic renderer for `markdown`. Used to convert regular strings to preview strings.

Used for width calculations.
]]
local md_str = {};

local utils = require("markview.utils");
local spec = require("markview.spec");

md_str.buffer = -1;

md_str.bold = function (match)
	if string.match(match, "%s+%*%*$") or string.match(match, "%s+%_%_$") then
		return match;
	end

	local removed = string.gsub(match, "^%*+", ""):gsub("%*+$", "");
	return removed;
end

md_str.italic = function (match)
	if string.match(match, "%s+%*$") then
		return match;
	end

	local removed = string.gsub(match, "^%*+", ""):gsub("%*+$", "");
	return removed;
end

---@param buffer integer
---@param text string
---@param base_hl string
---@return [ string, string ][]
md_str.tostring = function (buffer, text, base_hl)
	---|fS

	local lpeg = vim.lpeg;
	md_str.buffer = buffer;

	local s_italic_content = lpeg.P("\\*") + ( 1 - lpeg.P("*") );
	local u_italic_content = lpeg.P("\\_") + ( 1 - lpeg.P("_") );
	local s_italic = lpeg.C( lpeg.P("*") * s_italic_content^1 * lpeg.P("*") ) / md_str.italic;
	local u_italic = lpeg.C( lpeg.P("_") * u_italic_content^1 * lpeg.P("_") ) / md_str.italic;
	local italic = s_italic + u_italic;

	local s_bold_content = lpeg.P("\\*") + ( 1 - lpeg.P("*") );
	local u_bold_content = lpeg.P("\\_") + ( 1 - lpeg.P("_") );
	local s_bold = lpeg.C( lpeg.P("**") * s_bold_content^1 * lpeg.P("**") ) / md_str.bold;
	local u_bold = lpeg.C( lpeg.P("__") * u_bold_content^1 * lpeg.P("__") ) / md_str.bold;
	local bold = s_bold + u_bold;

	-- local any = lpeg.C( lpeg.P(1) ) / adoc_str.char;
	-- local token = labeled_url + url + ustrong + strong + uitalic + italic + mono + chl + hl + any;
	local token = bold + italic;

	local inline = lpeg.Ct( token^0 );
	local result = {};

		vim.print(lpeg.match(inline, text or ""))

	for _, item in ipairs(lpeg.match(inline, text or "")) do
		-- local last = result[#result];
		-- item[2] = item[2] or base_hl;
		--
		-- if (not item[2] or item[2] == base_hl) and last and (not last[2] or last[2] == base_hl) then
		-- 	last[1] = last[1] .. item[1];
		-- else
		-- 	if type(item[1]) == "table" then
		-- 		result = vim.list_extend(result, item);
		-- 	else
		-- 		table.insert(result, item)
		-- 	end
		-- end
	end

	return result;

	---|fE
end

-- vim.print(
	md_str.tostring(-1, "**abc d**")
-- )

return md_str;
