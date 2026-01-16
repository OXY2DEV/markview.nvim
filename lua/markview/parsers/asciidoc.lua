--- HTML parser for `markview.nvim`.
local asciidoc = {};

---@type markview.parser.asciidoc.data
asciidoc.data = {};

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

---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.range
asciidoc.doc_attr = function (buffer, TSNode, text, range)
	local _name = TSNode:named_child(1) --[[@as TSNode]];
	local name = vim.treesitter.get_node_text(_name, buffer, {});

	local _value = TSNode:named_child(3);

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
end

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

---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.range
asciidoc.section_title = function (buffer, TSNode, text, range)
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
end

---@param text string[]
---@param range markview.parsed.range
asciidoc.toc_pos = function (_, _, text, range)
	range.col_end = range.col_start + #(text[1] or "");
	asciidoc.data.toc_pos = range;
end

---@param text string[]
---@param range markview.parsed.asciidoc.tocs.range
asciidoc.toc = function (_, _, text, range)
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
	asciidoc.data = {};
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
end

return asciidoc;
