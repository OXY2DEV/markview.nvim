--- HTML parser for `markview.nvim`.
local asciidoc = {};

--- Queried contents
---@type table[]
asciidoc.content = {};

--- Queried contents, but sorted
---@type { [string]: table }
asciidoc.sorted = {}

--- Wrapper for `table.insert()`.
---@param data table
asciidoc.insert = function (data)
	table.insert(asciidoc.content, data);

	if not asciidoc.sorted[data.class] then
		asciidoc.sorted[data.class] = {};
	end

	table.insert(asciidoc.sorted[data.class], data);
end

--- Heading element parser
---@param buffer integer
---@param TSNode table
---@param text string[]
---@param range markview.parsed.range
asciidoc.heading = function (buffer, TSNode, text, range)
	local tag = vim.treesitter.get_node_text(TSNode:named_child(0):named_child(0), buffer);

	asciidoc.insert({
		class = "asciidoc_heading",
		level = tonumber(tag:match("^h(%d)$")),

		text = text,
		range = range
	});
end

--- HTML parser
---@param buffer integer
---@param TSTree table
---@param from integer?
---@param to integer?
---@return markview.parsed.asciidoc[]
---@return markview.parsed.asciidoc_sorted
asciidoc.parse = function (buffer, TSTree, from, to)
	-- Clear the previous contents
	asciidoc.sorted = {};
	asciidoc.content = {};

	local scanned_queries = vim.treesitter.query.parse("asciidoc", [[
	]]);

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TSTree:root(), buffer, from, to) do
		local capture_name = scanned_queries.captures[capture_id];

		if not capture_name:match("^asciidoc%.") then
			goto continue;
		end

		---@type string?
		local capture_text = vim.treesitter.get_node_text(capture_node, buffer);
		local r_start, c_start, r_end, c_end = capture_node:range();

		if capture_text == nil then
			goto continue;
		end

		if not capture_text:match("\n$") then
			capture_text = capture_text .. "\n";
		end

		local lines = {};

		for line in capture_text:gmatch("(.-)\n") do
			table.insert(lines, line);
		end

		---@type boolean, string
		local success, error = pcall(
			asciidoc[capture_name:gsub("^asciidoc%.", "")],

			buffer,
			capture_node,
			lines,
			{
				row_start = r_start,
				col_start = c_start,

				row_end = r_end,
				col_end = c_end
			}
		);

		if success == false then
			require("markview.health").print({
				kind = "ERR",

				from = "parsers/asciidoc.lua",
				fn = "parse()",

				message = {
					{ tostring(error), "DiagnosticError" }
				}
			});
		end

	    ::continue::
	end

	return asciidoc.content, asciidoc.sorted;
end

return asciidoc;
