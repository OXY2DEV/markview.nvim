---@diagnostic disable: undefined-field

local parser = {};
local health = require("markview.health");

---@type [ integer, integer ][] List of line ranges to ignore.
parser.ignore_ranges = {};

--- Cached contents.
parser.cached = {};

--- Creates ignore ranges from a list of parsed items.
---@param language string
---@param items table[]
---@return [ integer, integer ][]
parser.create_ignore_range = function (language, items)
	---|fS

	local _r = {};

	if language == "markdown" then
		-- Do not parse things inside code block.
		for _, item in ipairs(items["markdown_code_block"] or {}) do
			table.insert(_r, { item.range.row_start, item.range.row_end })
		end
	elseif language == "typst" then
		-- Do not parse things inside raw block.
		for _, item in ipairs(items["typst_raw_block"] or {}) do
			table.insert(_r, { item.range.row_start, item.range.row_end })
		end
	end

	parser.ignore_ranges = vim.list_extend(parser.ignore_ranges, _r);
	return _r;

	---|fE
end

--- Wrapper for `vim.tbl_extend()` that also extends lists.
---@param tbl_1 table
---@param tbl_2 table
---@return table
parser.deep_extend = function (tbl_1, tbl_2)
	---|fS

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

	---|fE
end

--- Checks if a node should be ignored.
---@param TSTree TSTree
---@return boolean
parser.should_ignore = function (TSTree)
	---|fS

	local t_start, _, t_stop, _ = TSTree:root():range();

	for _, range in ipairs(parser.ignore_ranges) do
		if t_start >= range[1] and t_stop <= range[2] then
			return true;
		end
	end

	return false;

	---|fE
end

parser.content = {};
parser.sorted = {};

--- Initializes the parsers on the specified buffer
--- Parsed data is stored as a "view" in renderer.lua
---
---@param buffer number
---@param from integer?
---@param to integer?
---@param cache boolean?
parser.init = function (buffer, from, to, cache)
	---|fS

	local _parsers = {
		markdown = require("markview.parsers.markdown");
		markdown_inline = require("markview.parsers.markdown_inline");
		html = require("markview.parsers.html");
		latex = require("markview.parsers.latex");
		typst = require("markview.parsers.typst");
		yaml = require("markview.parsers.yaml");
	};

	-- Clear the previous contents
	parser.content = {};
	parser.sorted = {};
	parser.ignore_ranges = {};

	if not pcall(vim.treesitter.get_parser, buffer) then
		-- Couldn't call parser retrieval function.
		return parser.content, parser.sorted;
	end

    vim.treesitter.get_parser(buffer):parse(true);
	local root_parser = vim.treesitter.get_parser(buffer);

	if not root_parser then
		-- Can't find root parser.
		return parser.content, parser.sorted;
	end

	---|fS "chore: Announce start of parsing"
	---@type integer Start time
	local start = vim.uv.hrtime();

	health.notify("trace", {
		level = 1,
		message = string.format("Parsing(start): %d", buffer)
	});
	health.__child_indent_in();
	---|fE

	root_parser:for_each_tree(function (TSTree, language_tree)
		language_tree:parse(true);

		local language = language_tree:lang();
		local content, sorted = {}, {};

		if _parsers[language] and not parser.should_ignore(TSTree) then
			content, sorted = _parsers[language].parse(buffer, TSTree, from, to);
			parser.create_ignore_range(language, sorted)
		end

		parser.content[language] = vim.list_extend(parser.content[language] or {}, content);
		parser.sorted[language] = parser.deep_extend(parser.sorted[language] or {}, sorted);
	end)

	if cache ~= false then
		parser.cached[buffer] = parser.sorted;
	end

	---|fS "chore: Announce end of parsing"
	---@type integer End time
	local now = vim.uv.hrtime();

	health.__child_indent_de();
	health.notify("trace", {
		level = 3,
		message = string.format("Parsing(end, %dms): %d", (now - start) / 1e6, buffer)
	});
	---|fE

	return parser.content, parser.sorted;

	---|fE
end

-- Chore: This is for backwards compatibility.
parser.parse = parser.init;


--[[ Parses various `links` from `buffer`. ]]
---
---@param buffer number
parser.parse_links = function (buffer)
	---|fS

	local _parsers = {
		-- markdown = require("markview.parsers.markdown");
		-- markdown_inline = require("markview.parsers.markdown_inline");
		html = require("markview.parsers.links.html");
		-- latex = require("markview.parsers.latex");
		-- typst = require("markview.parsers.typst");
		-- yaml = require("markview.parsers.yaml");
	};

	-- Clear link references.
	require("markview.links").clear(buffer);

	if not pcall(vim.treesitter.get_parser, buffer) then
		-- Couldn't call parser retrieval function.
		return;
	end

    vim.treesitter.get_parser(buffer):parse(true);
	local root_parser = vim.treesitter.get_parser(buffer);

	if not root_parser then
		-- Can't find root parser.
		return parser.content, parser.sorted;
	end

	---|fS "chore: Announce start of parsing"
	---@type integer Start time
	local start = vim.uv.hrtime();

	health.notify("trace", {
		level = 1,
		message = string.format("Link parsing(start): %d", buffer)
	});
	health.__child_indent_in();
	---|fE

	root_parser:for_each_tree(function (TSTree, language_tree)
		language_tree:parse(true);

		local language = language_tree:lang();

		if _parsers[language] and not parser.should_ignore(TSTree) then
			_parsers[language].parse(buffer, TSTree);
		end
	end)

	---|fS "chore: Announce end of parsing"
	---@type integer End time
	local now = vim.uv.hrtime();

	health.__child_indent_de();
	health.notify("trace", {
		level = 3,
		message = string.format("Link parsing(end, %dms): %d", (now - start) / 1e6, buffer)
	});
	---|fE

	---|fE
end

return parser;
