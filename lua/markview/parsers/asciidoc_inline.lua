--- HTML parser for `markview.nvim`.
local asciidoc_inline = {};

--- Queried contents
---@type table[]
asciidoc_inline.content = {};

--- Queried contents, but sorted
---@type { [string]: table }
asciidoc_inline.sorted = {}

--- Wrapper for `table.insert()`.
---@param data table
asciidoc_inline.insert = function (data)
	table.insert(asciidoc_inline.content, data);

	if not asciidoc_inline.sorted[data.class] then
		asciidoc_inline.sorted[data.class] = {};
	end

	table.insert(asciidoc_inline.sorted[data.class], data);
end

---@param text string[]
---@param range markview.parsed.range
asciidoc_inline.bold = function (_, _, text, range)
	asciidoc_inline.insert({
		class = "asciidoc_inline_bold",

		text = text,
		range = range
	});
end

---@param text string[]
---@param range markview.parsed.range
asciidoc_inline.italic = function (_, _, text, range)
	asciidoc_inline.insert({
		class = "asciidoc_inline_italic",

		text = text,
		range = range
	});
end

--- HTML parser
---@param buffer integer
---@param TSTree table
---@param from integer?
---@param to integer?
---@return markview.parsed.asciidoc_inline[]
---@return markview.parsed.asciidoc_inline_sorted
asciidoc_inline.parse = function (buffer, TSTree, from, to)
	-- Clear the previous contents
	asciidoc_inline.sorted = {};
	asciidoc_inline.content = {};

	local scanned_queries = vim.treesitter.query.parse("asciidoc_inline", [[
		(emphasis) @asciidoc_inline.bold
		(ltalic) @asciidoc_inline.italic
	]]);

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TSTree:root(), buffer, from, to) do
		local capture_name = scanned_queries.captures[capture_id];

		if not capture_name:match("^asciidoc_inline%.") then
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
			asciidoc_inline[capture_name:gsub("^asciidoc_inline%.", "")],

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

				from = "parsers/asciidoc_inline.lua",
				fn = "parse()",

				message = {
					{ tostring(error), "DiagnosticError" }
				}
			});
		end

	    ::continue::
	end

	return asciidoc_inline.content, asciidoc_inline.sorted;
end

return asciidoc_inline;
