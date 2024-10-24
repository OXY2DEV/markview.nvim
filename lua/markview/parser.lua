local parser = {};
local lang = require("markview.languages")

parser.markdown = require("markview.parsers.markdown");
parser.markdown_inline = require("markview.parsers.markdown_inline");
parser.html = require("markview.parsers.html");
parser.latex = require("markview.parsers.latex");
parser.typst = require("markview.parsers.typst");

parser.ignore_ranges = {};

parser.create_ignore_range = function (language, items)
	local _r = {};

	if language == "markdown" then
		for _, item in ipairs(items["markdown_code_block"] or {}) do
			table.insert(_r, { item.range.row_start, item.range.row_end })
		end
	end

	parser.ignore_ranges = vim.list_extend(parser.ignore_ranges, _r);
	return _r;
end

parser.deep_extend = function (tbl_1, tbl_2)
	for k, v in pairs(tbl_2) do
		if tbl_1[k] then
			if vim.islist(v) and vim.islist(tbl_1[k]) then
				tbl_1[k] = vim.list_extend(tbl_1[k], v);
			elseif type(v) == "table" and type(tbl_1[k]) == "table" then
				tbl_1[k] = parser.deep_extend(tbl_1[k], v);
			else
				tbl_1[k] = v;
			end
		else
			tbl_1[k] = v;
		end
	end

	return tbl_1;
end

parser.should_ignore = function (TSTree)
	local t_start, _, t_stop, _ = TSTree:root():range();

	for _, range in ipairs(parser.ignore_ranges) do
		if t_start >= range[1] and t_stop <= range[2] then
			return true;
		end
	end

	return false;
end

parser.content = {};
parser.sorted = {};

--- Initializes the parsers on the specified buffer
--- Parsed data is stored as a "view" in renderer.lua
---
---@param buffer number
---@param config markview.configuration
---@param from integer?
---@param to integer?
parser.init = function (buffer, config, from, to)
	-- Clear the previous contents
	parser.content = {};
	parser.sorted = {};
	parser.ignore_ranges = {};

	local root_parser = vim.treesitter.get_parser(buffer);
	-- local root_tree = root_parser:parse(true)[1];

	root_parser:for_each_tree(function (TSTree, language_tree)
		local language = language_tree:lang();
		local content, sorted = {}, {};

		if parser[language] and not parser.should_ignore(TSTree) then
			content, sorted = parser[language].parse(buffer, config, TSTree, from, to);
			parser.create_ignore_range(language, sorted)
		end

		parser.content[language] = vim.list_extend(parser.content[language] or {}, content);
		parser.sorted[language] = parser.deep_extend(parser.sorted[language] or {}, sorted);
	end)

	return parser.content, parser.sorted;
end

return parser;
