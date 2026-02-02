-- Applies text transformation based on the **filetype**.
--
-- Uses for getting the output text of filetypes that contain
-- special syntaxes(e.g. JSON, markdown).
local visual = {};
local lpeg = vim.lpeg;

---@param match string
---@return string
visual.md_delims_star = function (match)
	---|fS

	local inner = string.gsub(match, "^%*+", ""):gsub("%*+$", "") or "";

	if string.match(inner, "[_~`]") then
		return visual.markdown(inner);
	else
		return inner;
	end

	---|fE
end

---@param match string
---@return string
visual.md_delims_underscore = function (match)
	---|fS

	local inner = string.gsub(match, "^_+", ""):gsub("_+$", "") or "";

	if string.match(inner, "[%*~`]") then
		return visual.markdown(inner);
	else
		return inner;
	end

	---|fE
end

---@param match string
---@return string
visual.md_delims_tilde = function (match)
	---|fS

	local inner = string.gsub(match, "^~+", ""):gsub("~+$", "") or "";

	if string.match(inner, "[%*`]") then
		return visual.markdown(inner);
	else
		return inner;
	end

	---|fE
end

---@param match string
---@return string
visual.md_delims_backtick = function (match)
	local inner = string.gsub(match, "^`+", ""):gsub("`+$", "") or "";
	return inner;
end

---@param match string
---@return string
visual.md_escaped = function (match)
	local char = string.match(match, "\\(.+)$");
	return char;
end

---@param match string
---@return string
visual.md_labeled_link = function (match)
	---|fS

	local label = string.gsub(match, "^%!?%[", ""):gsub("%].-$", "");

	if string.match(label, "[%*_~`]") then
		return visual.markdown(label);
	else
		return label;
	end

	---|fE
end

---@param match string
---@return string
visual.md_autolink = function (match)
	---|fS

	local label = string.gsub(match, "^%[", ""):gsub("%]$", "");

	if string.match(label, "[%*_~`]") then
		return visual.markdown(label);
	else
		return label;
	end

	---|fE
end

---@param str string
---@return string
visual.markdown = function (str)
	---|fS

	local _star = lpeg.P("*")^1;
	local delim_star_content = lpeg.P("\\*") + ( 1 - _star );
	local delim_star = lpeg.C( _star * delim_star_content^1 * _star ) / visual.md_delims_star;

	local _underscore = lpeg.P("_")^1;
	local delim_underscore_content = lpeg.P("\\_") + ( 1 - _underscore );
	local delim_underscore = lpeg.C( _underscore * delim_underscore_content^1 * _underscore ) / visual.md_delims_underscore;

	local _tilde = lpeg.P("~")^1;
	local delim_tilde_content = lpeg.P("\\~") + ( 1 - _tilde );
	local delim_tilde = lpeg.C( _tilde * delim_tilde_content^1 * _tilde ) / visual.md_delims_tilde;

	local _backtick = lpeg.P("`")^1;
	local delim_backtick_content = lpeg.P("\\`") + ( 1 - _backtick );
	local delim_backtick = lpeg.C( _backtick * delim_backtick_content^1 * _backtick ) / visual.md_delims_backtick;

	local escaped = lpeg.C( lpeg.P("\\") * lpeg.P(1) ) / visual.md_escaped;

	local image_label_char = lpeg.P("\\]") + ( 1 - lpeg.P("]") );
	local image_link_char = lpeg.P("\\)") + ( 1 - lpeg.P(")") );
	local image = lpeg.C( lpeg.P("![") * image_label_char^0 * lpeg.P("](") * image_link_char^0 * lpeg.P(")") ) / visual.md_labeled_link;

	local link_label_char = lpeg.P("\\]") + ( 1 - lpeg.P("]") );
	local link_link_char = lpeg.P("\\)") + ( 1 - lpeg.P(")") );
	local link = lpeg.C( lpeg.P("[") * link_label_char^0 * lpeg.P("](") * link_link_char^0 * lpeg.P(")") ) / visual.md_labeled_link;
	local autolink = lpeg.C( lpeg.P("[") * link_label_char^0 * lpeg.P("]") ) / visual.md_autolink;

	local any = lpeg.P(1);
	local token = escaped + delim_backtick + delim_star + delim_underscore + delim_tilde + image + link + autolink + any;

	local inline = lpeg.Cs(token^0);
	return inline:match(str);

	---|fE
end

--------------------------------------------------------------------------------

---@param match string
---@return string
visual.json_string = function (match)
	local inner = string.gsub(match, '^"', ""):gsub('"$', "") or "";

	if string.match(inner, '"') then
		return visual.json(inner);
	else
		return inner;
	end
end

---@param match string
---@return string
visual.json_escaped = function (match)
	local char = string.match(match, "\\(.+)$");
	return char;
end

---@param str string
---@return string
visual.json = function (str)
	---|fS

	local _quote = lpeg.P('"')^1;
	local jstring_content = lpeg.P('\\"') + ( 1 - _quote );
	local jstring = lpeg.C( _quote * jstring_content^1 * _quote ) / visual.json_string;

	local escaped = lpeg.C( lpeg.P("\\") * lpeg.P(1) ) / visual.json_escaped;

	local any = lpeg.P(1);
	local token = escaped + jstring + any;

	local inline = lpeg.Cs(token^0);
	return inline:match(str);

	---|fE
end

---@param language string
---@param line string
---@return string
visual.get_visual_text = function (language, line)
	---|fS

	local ft = vim.filetype.match({
		filename = string.format("example.%s", language)
	}) or language;

	local found_parser = pcall(vim.treesitter.language.inspect, ft);

	if not found_parser then
		return line;
	end

	if ft == nil or visual[ft] == nil then
		return line;
	elseif pcall(visual[ft], line) == false then
		--- Text transformation failed!
		return line;
	end

	local could_get, visual_text = pcall(visual[ft], line);
	return could_get and visual_text or line;

	---|fE
end

return visual;
