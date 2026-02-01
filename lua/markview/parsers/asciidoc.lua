--- HTML parser for `markview.nvim`.
local asciidoc = {};

---@type markview.parser.asciidoc.data
asciidoc.data = {};

--- Queried contents
---@type markview.parsed.asciidoc[]
asciidoc.content = {};

--- Queried contents, but sorted
---@type markview.parsed.asciidoc_sorted
---@diagnostic disable-next-line: missing-fields
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

--[[
Admonitions.

```asciidoc
NOTE: Some note.
```
]]
---@param buffer integer
---@param _ TSNode
---@param text string[]
---@param range markview.parsed.asciidoc.admonitions.range
asciidoc.admonition = function (buffer, _, text, range)
	---|fS

	local before = vim.api.nvim_buf_get_text(buffer, range.row_start, 0, range.row_start, range.col_start, {})[1] or "";
	local kind = string.match(before, "[A-Z]+$");

	range.kind = {
		range.row_start,
		range.col_start - #(kind or ""),

		range.row_start,
		range.col_start + 1,
	};
	range.col_start = range.kind[2];

	asciidoc.insert({
		class = "asciidoc_admonition",
		kind = kind,

		text = text,
		range = range
	});

	---|fE
end

--[[
Admonition blocks.

```asciidoc
[NOTE]
======
Some note.

Some other note.
======
```
]]
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.asciidoc.admonitions.range
asciidoc.admonition_block = function (buffer, TSNode, text, range)
	---|fS

	local admonition = TSNode:prev_named_sibling() --[[@as TSNode]];

	local _kind = admonition:named_child(1) --[[@as TSNode]];
	local kind = vim.treesitter.get_node_text(_kind, buffer, {});

	range.kind = { _kind:range() };
	range.row_start = range.kind[1];

	asciidoc.insert({
		class = "asciidoc_admonition_block",
		kind = kind,

		text = text,
		range = range
	});

	---|fE
end

--[[
Block quotes.

```asciidoc
[quote]
____
Some quote.

Some other quote.
____
```
]]
---@param buffer integer
---@param _ TSNode
---@param text string[]
---@param range markview.parsed.asciidoc.block_quotes.range
asciidoc.block_quote = function (buffer, _, text, range)
	---|fS

	local from, context;
	local has_attr;

	if range.row_start > 0 then
		local before = vim.api.nvim_buf_get_lines(buffer, range.row_start - 1, range.row_start, false)[1] or "";
		before = string.gsub(before, "^[%s]*%[", "");
		before = string.gsub(before, "%][%s]*$", "");

		if string.match(before, "^quote") then
			has_attr = true;

			local parts = vim.split(before, ",");
			from = parts[2];

			if #parts > 2 then
				context = table.concat(
					vim.list_slice(parts, 3),
					","
				);

				context = string.gsub(context, "^['\"]+", "");
				context = string.gsub(context, "['\"]+$", "");
			end

			range.quote = {
				range.row_start - 1,
				0,
				range.row_start,
				0
			};
			range.row_start = range.quote[1];
		end
	end

	asciidoc.insert({
		class = "asciidoc_block_quote",
		has_attr = has_attr,
		from = from,
		context = context,

		text = text,
		range = range
	});

	---|fE
end

--[[
Block quotes.

```asciidoc
[quote]
____
Some quote.

Some other quote.
____
```
]]
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.asciidoc.code_blocks.range
asciidoc.code_block = function (buffer, TSNode, text, range)
	---|fS

	local _lang = TSNode:named_child(0) --[[@as TSNode]];
	range.language = { _lang:range() };

	local attr_value = _lang:named_child(1);
	local lang;

	if attr_value and attr_value:type() == "attr_value" then
		local attr_text = vim.treesitter.get_node_text(attr_value, buffer, {});

		if string.match(attr_text, "^source,") then
			lang = string.match(attr_text, "^source,(.+)$")
		end
	end

	local listing_block = TSNode:named_child(1) --[[@as TSNode]];
	local delims = {
		listing_block:named_child(0),
		listing_block:named_child(2),
	};

	if delims[1] then
		range.start_delim = { delims[1]:range() };
	end

	if delims[2] then
		range.end_delim = { delims[2]:range() };
	end

	local uses_tab = false;

	for _, line in ipairs(text) do
		if string.match(line, "\t") then
			uses_tab = true;
			break;
		end
	end

	asciidoc.insert({
		class = "asciidoc_code_block",
		language = lang,
		delimiters = {
			delims[1] and vim.treesitter.get_node_text(delims[1], buffer, {}) or "",
			delims[2] and vim.treesitter.get_node_text(delims[2], buffer, {}) or "",
		},
		uses_tab = uses_tab,

		text = text,
		range = range
	});

	---|fE
end

--[[
Delimited blocks.

```asciidoc
======
Foo
======
```
]]
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.range
asciidoc.delimited_block = function (buffer, TSNode, text, range)
	---|fS

	local before = TSNode:prev_named_sibling();

	-- NOTE: Detect `admonitions` first.
	if before and before:type() == "element_attr" then
		local attr_value = before:named_child(1);

		if attr_value and attr_value:type() == "attr_value" then
			local attr_text = vim.treesitter.get_node_text(attr_value, buffer, {});

			if string.match(attr_text, "^[A-Z]+$") then
				---@diagnostic disable-next-line: param-type-mismatch
				asciidoc.admonition_block(buffer, TSNode, text, range);
				return;
			end
		end
	end

	asciidoc.insert({
		class = "asciidoc_delimited_block",

		text = text,
		range = range
	});

	---|fE
end

--[[
Document attributes.

```asciidoc
:toc-title: Some title
```
]]
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.range
asciidoc.doc_attr = function (buffer, TSNode, text, range)
	---|fS

	local _name = TSNode:named_child(1) --[[@as TSNode]];
	local name = vim.treesitter.get_node_text(_name, buffer, {});

	local _value = TSNode:named_child(3);

	-- NOTE: Handle special attributes first.
	if name == "toc" then
		return;
	elseif name == "toc-title" and _value then
		asciidoc.data.toc_title = vim.treesitter.get_node_text(_value, buffer, {});
	elseif name == "toclevels" and _value then
		asciidoc.data.toc_max_depth = math.max(
			math.min(
				tonumber(
					vim.treesitter.get_node_text(_value, buffer, {})
				) or 0,
				5
			),
			0
		);
	end

	asciidoc.insert({
		class = "asciidoc_document_attribute",

		text = text,
		range = range
	});

	---|fE
end

--[[
Document title.

```asciidoc
= Some title
```
]]
---@param text string[]
---@param range markview.parsed.range
asciidoc.doc_title = function (_, _, text, range)
	asciidoc.data.document_title = string.match(text[1] or "", "=%s+(.*)$")

	asciidoc.insert({
		class = "asciidoc_document_title",

		text = text,
		range = range
	});
end

--[[
Horizontal rule or thematic break

```asciidoc
'''
```
]]
---@param text string[]
---@param range markview.parsed.range
asciidoc.hr = function (_, _, text, range)
	asciidoc.insert({
		class = "asciidoc_hr",

		text = text,
		range = range
	});
end

--[[
Image.

NOTE: Images aren't handled by the `asciidoc_inline` parser due to it being a **block macro**.

```asciidoc
image::markview.jpg[]
```
]]
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.asciidoc.images.range
asciidoc.image = function (buffer, TSNode, text, range)
	---|fS

	local _destination = TSNode:named_child(1);

	if not _destination then
		return;
	end

	local destination = vim.treesitter.get_node_text(_destination, buffer, {});
	range.destination = { _destination:range() };

	--[[
		refactor: Range correction

		Block macros end at the start of the next line.
		So, we correct the end column & end row.
	]]
	range.row_end = range.row_end - 1;
	range.col_end = range.col_start + #(text[#text] or "");

	asciidoc.insert({
		class = "asciidoc_image",
		destination = destination,

		text = text,
		range = range
	});

	---|fE
end

--[[
Keycodes.

NOTE: Keycodes are **block macro**.
NIT: Should a separate function be used for `menus`?

```asciidoc
kbd::space[]
```
]]
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.asciidoc.keycodes.range
asciidoc.keycode = function (buffer, TSNode, text, range)
	---|fS

	local _content = TSNode:named_child(1);

	if not _content then
		return;
	end

	local content = vim.treesitter.get_node_text(_content, buffer, {});
	range.content = { _content:range() };

	--[[
		refactor: Range correction

		Block macros end at the start of the next line.
		So, we correct the end column & end row.
	]]
	range.row_end = range.row_end - 1;
	range.col_end = range.col_start + #(text[#text] or "");

	asciidoc.insert({
		class = "asciidoc_keycode",
		content = content,

		text = text,
		range = range
	});

	---|fE
end

--[[ Is the given `list item marker` on the same level as the **current** list item? ]]
---@param buffer integer
---@param now string Current marker.
---@param last TSNode
---@return boolean
local function is_on_same_level(buffer, now, last)
	---|fS

	local _marker = last:child(0);

	if not _marker then
		return false;
	end

	local marker = vim.treesitter.get_node_text(_marker, buffer, {});
	return marker == now;

	---|fE
end

--[[
List item(`ordered` & `unordered`)

```asciidoc
* Unordered
* Unordered 2

. Ordered
. Ordered 2
```
]]
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.asciidoc.list_items.range
asciidoc.list_item = function (buffer, TSNode, text, range)
	---|fS

	---@type integer List item index
	local N = 1;
	local prev = TSNode:prev_named_sibling();

	local marker;

	local checkbox;

	for child in TSNode:iter_children() do
		if child:type() == "checked_list_marker" then
			local _marker = child:named_child(0):named_child(0) --[[@as TSNode]];
			local _checkbox = child:named_child(1) --[[@as TSNode]];

			marker = vim.treesitter.get_node_text(_marker, buffer, {})
			_, _, _, range.marker_end = _marker:range();

			if _checkbox then
				if _checkbox:type() == "checked_list_marker_checked" then
					checkbox = "*";
					_, range.checkbox_start, _, range.checkbox_end = _checkbox:range();

					break;
				elseif _checkbox:type() == "checked_list_marker_unchecked" then
					checkbox = " ";
					_, range.checkbox_start, _, range.checkbox_end = _checkbox:range();

					break;
				end
			end
		elseif vim.list_contains({ "ordered_list_marker", "unordered_list_marker" }, child:type()) then
			local _marker = child:named_child(0) --[[@as TSNode]];

			marker = vim.treesitter.get_node_text(_marker, buffer, {})
			_, _, _, range.marker_end = _marker:range();
		elseif child:type() == "line" then
			local _text = vim.treesitter.get_node_text(child, buffer, {});
			checkbox = string.match(_text, "^%[(.)%]");

			if checkbox then
				local _, tmp = child:range();

				range.checkbox_start = tmp;
				range.checkbox_end = tmp + 3;

				break;
			end
		end
	end

	-- NOTE: Check list index after getting the list marker.
	while prev do
		if prev:type() == "ordered_list_item" then
			if is_on_same_level(buffer, marker, prev) then
				N = N + 1;
			else
				break;
			end
		end

		prev = prev:prev_named_sibling();
	end

	asciidoc.insert({
		class = "asciidoc_list_item",

		checkbox = checkbox,
		marker = marker,
		n = N,

		text = text,
		range = range
	});

	---|fE
end

--[[
Literal block.

```asciidoc
...
Some text literally
...
```
]]
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.asciidoc.literal_blocks.range
asciidoc.literal_block = function (buffer, TSNode, text, range)
	---|fS

	local _delimiters = {
		TSNode:named_child(0),
		TSNode:named_child(2),
	};

	if _delimiters[1] then
		range.start_delim = { _delimiters[1]:range(); };
	end

	if _delimiters[1] then
		range.end_delim = { _delimiters[2]:range(); };
	end

	local uses_tab = false;

	for _, line in ipairs(text) do
		if string.match(line, "\t") then
			uses_tab = true;
			break;
		end
	end

	asciidoc.insert({
		class = "asciidoc_literal_block",
		delimiters = {
			_delimiters[1] and vim.treesitter.get_node_text(_delimiters[1], buffer, {}) or "",
			_delimiters[2] and vim.treesitter.get_node_text(_delimiters[2], buffer, {}) or "",
		},
		uses_tab = uses_tab,

		text = text,
		range = range
	});

	---|fE
end

--[[
Section tiles.

```asciidoc
...
== Section

=== Sub-section

=== Sub-section 2
...
```
]]
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.range
asciidoc.section_title = function (buffer, TSNode, text, range)
	---|fS

	local _marker = TSNode:child(0);

	if not _marker then
		return;
	end

	local marker = vim.treesitter.get_node_text(_marker, buffer, {});
	local prev = TSNode:prev_named_sibling();

	if prev then
		local prev_text = vim.treesitter.get_node_text(prev, buffer, {});

		if prev:type() == "element_attr" and prev_text == "[discrete]" then
			goto dont_add_to_toc;
		end
	end

	if not asciidoc.data.toc_entries then
		asciidoc.data.toc_entries = {};
	end

	table.insert(asciidoc.data.toc_entries, {
		depth = (#marker or 1) - 1,
		text = string.gsub(text[1] or "", "^[=%s]+", ""),

		range = vim.deepcopy(range, true),
	} --[[@as markview.parser.asciidoc.data.toc_entry]]);

	::dont_add_to_toc::

	asciidoc.insert({
		class = "asciidoc_section_title",
		marker = marker,

		text = text,
		range = range
	});

	---|fE
end

--[[
Specified automated TOC position.

NOTE: This needs to be parsed before parsing any TOC nodes!
]]
---@param text string[]
---@param range markview.parsed.range
asciidoc.toc_pos = function (_, _, text, range)
	range.col_end = range.col_start + #(text[1] or "");
	asciidoc.data.toc_pos = range;
end

--[[
Automated Table of Content.

```asciidoc
:toc:
```
]]
---@param text string[]
---@param range markview.parsed.asciidoc.tocs.range
asciidoc.toc = function (_, _, text, range)
	---|fS

	---@type markview.parser.asciidoc.data.toc_entry[] Validated TOC entries(matches heading depth).
	local validated = {};

	for _, entry in ipairs(asciidoc.data.toc_entries or {}) do
		if entry.depth < (asciidoc.data.toc_max_depth or 5) then
			table.insert(validated, entry);
		end
	end

	range.col_end = range.col_start + #(text[1] or "");
	range.position = asciidoc.data.toc_pos;

	asciidoc.insert({
		class = "asciidoc_toc",

		title = asciidoc.data.toc_title,
		max_depth = asciidoc.data.toc_max_depth,
		entries = validated,

		text = text,
		range = range
	});

	---|fE
end

--- Asciidoc parser
---@param buffer integer
---@param TSTree table
---@param from integer?
---@param to integer?
---@return markview.parsed.asciidoc[]
---@return markview.parsed.asciidoc_sorted
asciidoc.parse = function (buffer, TSTree, from, to)
	---|fS

	-- Clear the previous contents
	asciidoc.data = {};
	---@diagnostic disable-next-line: missing-fields
	asciidoc.sorted = {};
	asciidoc.content = {};

	local can_scan, scanned_queries = pcall(vim.treesitter.query.parse, "asciidoc", [[
		(document_title) @asciidoc.doc_title
		(document_attr) @asciidoc.doc_attr

		[
			(title1)
			(title2)
			(title3)
			(title4)
			(title5)
		] @asciidoc.section_title

		(block_macro
			(
				(block_macro_name) @toc_pos_name
				(#eq? @toc_pos_name "toc")
			)) @asciidoc.toc_pos

		(unordered_list_item) @asciidoc.list_item
		(ordered_list_item) @asciidoc.list_item

		(checked_list_item) @asciidoc.list_item

		(block_macro
			(
				(block_macro_name) @image_keyword
				(#eq? @image_keyword "image")
			)) @asciidoc.image

		(block_macro
			(
				(block_macro_name) @kbd_keyword
				(#eq? @kbd_keyword "kbd")
			)) @asciidoc.keycode

		(literal_block) @asciidoc.literal_block

		(admonition) @asciidoc.admonition
		(breaks) @asciidoc.hr

		(delimited_block) @asciidoc.delimited_block

		(quoted_block) @asciidoc.block_quote

		(section_block
			(element_attr
				(
					(attr_value) @code_block_marker
					(#lua-match? @code_block_marker "^source")
				))
			(listing_block)) @asciidoc.code_block
	]]);

	if not can_scan then
		require("markview.health").print({
			kind = "ERR",

			from = "parsers/asciidoc.lua",
			fn = "parse() -> query",

			message = {
				{ tostring(error), "DiagnosticError" }
			}
		});

		return asciidoc.content, asciidoc.sorted;
	end

	local function iter (queries)
		---|fS

		for capture_id, capture_node, _, _ in queries:iter_captures(TSTree:root(), buffer, from, to) do
			local capture_name = queries.captures[capture_id];

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

		---|fE
	end

	iter(scanned_queries);

	--[[
		NOTE: We need to parse TOC nodes separately because certain document attributes changes the TOC

		Parsing them together will require manually finding TOC nodes every time a change needs to be applied.
	]]

	local can_scan_tquery, scanned_tqueries = pcall(vim.treesitter.query.parse, "asciidoc", [[
		(document_attr
			(
				(attr_name) @toc_attr
				(#eq? @toc_attr "toc")
			)) @asciidoc.toc
	]]);

	if not can_scan_tquery then
		require("markview.health").print({
			kind = "ERR",

			from = "parsers/asciidoc.lua",
			fn = "parse() -> toc_query",

			message = {
				{ tostring(error), "DiagnosticError" }
			}
		});
	else
		iter(scanned_tqueries);
	end

	return asciidoc.content, asciidoc.sorted;

	---|fE
end

return asciidoc;
