--- HTML parser for `markview.nvim`.
local asciidoc_inline = {};

---@type integer[][] Already parsed ranges. Used to prevent re-parsing already parsed regions.
asciidoc_inline.parsed_ranges = {};

--- Queried contents
---@type markview.parsed.asciidoc_inline[]
asciidoc_inline.content = {};

--- Queried contents, but sorted
---@type markview.parsed.asciidoc_inline_sorted
---@diagnostic disable-next-line: missing-fields
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

--[[
Bold text.

```asciidoc
*bold*
```
]]
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.range
asciidoc_inline.bold = function (buffer, TSNode, text, range)
	---|fS

	local delimiters = {};

	for child in TSNode:iter_children() do
		if child:named() == false then
			if delimiters[1] then
				delimiters[2] = vim.treesitter.get_node_text(child, buffer, {});
			else
				delimiters[1] = vim.treesitter.get_node_text(child, buffer, {});
			end
		end
	end

	asciidoc_inline.insert({
		class = "asciidoc_inline_bold",
		delimiters = delimiters,

		text = text,
		range = range
	});

	---|fE
end

--[[
Highlighted text.

```asciidoc
#highlighted#
```
]]
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.range
asciidoc_inline.highlight = function (buffer, TSNode, text, range)
	---|fS

	local delimiters = {};

	for child in TSNode:iter_children() do
		if child:named() == false then
			if delimiters[1] then
				delimiters[2] = vim.treesitter.get_node_text(child, buffer, {});
			else
				delimiters[1] = vim.treesitter.get_node_text(child, buffer, {});
			end
		end
	end

	asciidoc_inline.insert({
		class = "asciidoc_inline_highlight",
		delimiters = delimiters,

		text = text,
		range = range
	});

	---|fE
end

--[[
Italic.

```asciidoc
__italic__
```
]]
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.range
asciidoc_inline.italic = function (buffer, TSNode, text, range)
	---|fS

	local delimiters = {};

	for child in TSNode:iter_children() do
		if child:named() == false then
			if delimiters[1] then
				delimiters[2] = vim.treesitter.get_node_text(child, buffer, {});
			else
				delimiters[1] = vim.treesitter.get_node_text(child, buffer, {});
			end
		end
	end

	asciidoc_inline.insert({
		class = "asciidoc_inline_italic",
		delimiters = delimiters,

		text = text,
		range = range
	});

	---|fE
end

--[[
Labeled URI.

```asciidoc
www.example.com[Example]
```
]]
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.asciidoc_inline.labeled_uris.range
asciidoc_inline.labeled_uri = function (buffer, TSNode, text, range)
	---|fS

	local destination;

	for child in TSNode:iter_children() do
		if child:type() == "uri_label" then
			_, range.label_col_start, _, range.label_col_end = child:range();
		elseif child:type() == "uri" then
			destination = vim.treesitter.get_node_text(child, buffer, {});
		end
	end

	asciidoc_inline.insert({
		class = "asciidoc_inline_labeled_uri",
		destination = destination,

		text = text,
		range = range
	});

	---|fE
end

--[[
Inline macro for labeled URI.

```asciidoc
link:www.example.com[Example]
```
]]
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.asciidoc_inline.labeled_uris.range
asciidoc_inline.uri_macro = function (buffer, TSNode, text, range)
	---|fS

	local kind, destination;

	for child in TSNode:iter_children() do
		if child:type() == "macro_name" then
			kind = vim.treesitter.get_node_text(child, buffer, {});
		elseif child:type() == "target" then
			destination = vim.treesitter.get_node_text(child, buffer, {});
		elseif child:type() == "attr" then
			local attr = vim.treesitter.get_node_text(child, buffer, {});

			if string.match(attr, '^".*"$') or not string.match(attr, "[,=]") then
				_, range.label_col_start, _, range.label_col_end = child:range();
			else
				local R = { child:range() };
				local target = string.match(attr, '^"[^"]*"') or string.match(attr, "^[^,]*") or "";
				target = string.gsub(target, "%s+$", "");

				local spaces_before = #string.match(target, "^%s*");

				range.label_col_start = R[2] + spaces_before;
				range.label_col_end = R[2] + spaces_before + #target;
			end
		end
	end

	asciidoc_inline.insert({
		class = "asciidoc_inline_labeled_uri",
		kind = kind,
		destination = destination,

		text = text,
		range = range
	});

	---|fE
end

--[[
Monospace text.

```asciidoc
`mono`
```
]]
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.range
asciidoc_inline.monospace = function (buffer, TSNode, text, range)
	---|fS

	local delimiters = {};

	for child in TSNode:iter_children() do
		if child:named() == false then
			if delimiters[1] then
				delimiters[2] = vim.treesitter.get_node_text(child, buffer, {});
			else
				delimiters[1] = vim.treesitter.get_node_text(child, buffer, {});
			end
		end
	end

	asciidoc_inline.insert({
		class = "asciidoc_inline_monospace",
		delimiters = delimiters,

		text = text,
		range = range
	});

	---|fE
end

--[[
Unlabeled URI.

```asciidoc
www.example.com
```
]]
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.range
asciidoc_inline.uri = function (buffer, TSNode, text, range)
	---|fS

	local before = vim.api.nvim_buf_get_text(buffer, range.row_start, 0, range.row_start, range.col_start, {})[1];

	-- NOTE: Do not parse a URI if it's part of an image macro.
	if string.match(before, "image::$") then
		return;
	end

	local delimiters = {};
	local destination;

	for child in TSNode:iter_children() do
		if child:named() == false then
			if delimiters[1] then
				delimiters[2] = vim.treesitter.get_node_text(child, buffer, {});
			else
				delimiters[1] = vim.treesitter.get_node_text(child, buffer, {});
			end
		else
			destination = vim.treesitter.get_node_text(child, buffer, {});
		end
	end

	asciidoc_inline.insert({
		class = "asciidoc_inline_uri",
		delimiters = delimiters,
		destination = destination,

		text = text,
		range = range
	});

	---|fE
end

---@param buffer integer
---@param TSTree TSTree
---@param from integer?
---@param to integer?
---@return markview.parsed.asciidoc_inline[]
---@return markview.parsed.asciidoc_inline_sorted
asciidoc_inline.parse = function (buffer, TSTree, from, to)
	---|fS

	---@diagnostic disable-next-line: missing-fields
	asciidoc_inline.sorted = {};
	asciidoc_inline.content = {};

	local root = TSTree:root();
	local r_range = { root:range() };

	for _, entry in ipairs(asciidoc_inline.parsed_ranges) do
		if vim.deep_equal(entry, r_range) then
			return asciidoc_inline.content, asciidoc_inline.sorted;
		end
	end

	table.insert(asciidoc_inline.parsed_ranges, r_range);

	local can_scan, scanned_queries = pcall(vim.treesitter.query.parse, "asciidoc_inline", [[
		(emphasis) @asciidoc_inline.bold
		(ltalic) @asciidoc_inline.italic
		(monospace) @asciidoc_inline.monospace
		(highlight) @asciidoc_inline.highlight

		(autolink
			(uri)) @asciidoc_inline.uri

		(labled_uri
			(uri)) @asciidoc_inline.labeled_uri

		(inline_macro
			((macro_name) @uri_macro_name
				(#any-of? @uri_macro_name "link" "mailto"))
			(target)
			(attr)) @asciidoc_inline.uri_macro
	]]);

	if not can_scan then
		require("markview.health").print({
			kind = "ERR",

			from = "parsers/asciidoc_inline.lua",
			fn = "parse() -> query",

			message = {
				{ tostring(error), "DiagnosticError" }
			}
		});

		return asciidoc_inline.content, asciidoc_inline.sorted;
	end

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

	---|fE
end

return asciidoc_inline;
