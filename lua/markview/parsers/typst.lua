local typst = {};
local utils = require("markview.utils");

typst.cache = {
	list_item_number = 0
};

--- Queried contents
---@type table[]
typst.content = {};

--- Queried contents, but sorted
typst.sorted = {}

typst.insert = function (data)
	table.insert(typst.content, data);

	if not typst.sorted[data.class] then
		typst.sorted[data.class] = {};
	end

	table.insert(typst.sorted[data.class], data);
end

typst.heading = function (_, _, text, range)
	local level = text[1]:match("^(%=+)"):len();

	typst.insert({
		class = "typst_heading",
		level = level,

		text = text,
		range = range
	});
end

typst.escaped = function (_, TSNode, text, range)
	local node = TSNode:parent();

	while node do
		if node:type() == "code" then return; end

		node = node:parent();
	end

	typst.insert({
		class = "typst_escaped",

		text = text,
		range = range
	});
end

typst.list_item = function (buffer, TSNode, text, range)
	local line = vim.api.nvim_buf_get_lines(buffer, range.row_start, range.row_start + 1, false)[1]:sub(0, range.col_start);
	local marker = text[1]:match("^([%-%+])") or text[1]:match("^(%d+%.)");
	local number;

	if marker == "+" then
		local prev_item = TSNode:prev_sibling();
		local item_text = prev_item and vim.treesitter.get_node_text(prev_item, buffer) or "";

		if
			not prev_item or
			(
				prev_item:type() == "item" and
				item_text:match("^(%+)")
			)
		then
			typst.cache.list_item_number = typst.cache.list_item_number + 1;
		else
			typst.cache.list_item_number = 1;
		end

		number = typst.cache.list_item_number;
	end

	typst.insert({
		class = "typst_list_item",
		indent = line:match("(%s*)$"):len(),
		marker = marker,
		number = number,

		text = text,
		range = range
	});
end

typst.code = function (_, TSNode, text, range)
	local node = TSNode:parent();

	while node do
		if node:type() == "code" then return; end

		node = node:parent();
	end

	for l, line in ipairs(text) do
		if l ==1 then goto continue; end

		text[l] = line:sub(range.col_start + 1);

		::continue::
	end

	typst.insert({
		class = "typst_code",
		inline = range.row_start == range.row_end,

		text = text,
		range = range
	});
    ::continue::
end

typst.math = function (buffer, _, text, range)
	local from, to = vim.api.nvim_buf_get_lines(buffer, range.row_start, range.row_start + 1, false)[1]:sub(0, range.col_start), vim.api.nvim_buf_get_lines(buffer, range.row_end, range.row_end + 1, false)[1]:sub(0, range.col_end);
	local inline, closed = false, true;

	if
		not from:match("^(%s*)$") or not to:match("^(%s*)%$$")
	then
		inline = true;
	elseif
		not text[1]:match("%$$")
	then
		inline = true;
	end

	if not text[#text]:match("%$$") then
		closed = false;
	end

	typst.insert({
		class = "typst_math",
		inline = inline,
		closed = closed,

		text = text,
		range = range
	});
end

typst.link_url = function (_, _, text, range)
	typst.insert({
		class = "typst_link_url",
		label = text,

		text = text,
		range = range
	});
end

typst.strong = function (_, _, text, range)
	typst.insert({
		class = "typst_strong",

		text = text,
		range = range
	});
end

typst.emphasis = function (_, _, text, range)
	typst.insert({
		class = "typst_emphasis",

		text = text,
		range = range
	});
end

typst.raw = function (_, _, text, range)
	typst.insert({
		class = "typst_raw_span",

		text = text,
		range = range
	});
end

typst.raw_block = function (buffer, TSNode, text, range)
	local lang_node = TSNode:field("lang")[1];
	local language;

	if lang_node then
		language = vim.treesitter.get_node_text(lang_node, buffer);
	end

	for l, line in ipairs(text) do
		if l == 1 then goto continue; end
		text[l] = line:sub(range.col_start + 1);
	    ::continue::
	end

	typst.insert({
		class = "typst_raw_block",
		language = language,

		text = text,
		range = range
	});
end

typst.label = function (_, _, text, range)
	typst.insert({
		class = "typst_label",

		text = text,
		range = range
	});
end

typst.link_ref = function (_, _, text, range)
	typst.insert({
		class = "typst_link_ref",

		text = text,
		range = range
	});
end

typst.link_function = function (buffer, TSNode, text, range)
	---```query
	---(code
    ---    (call ← TSNode:child(1)
    ---        item: (call ← TSNode:child(1):field("item")[1]
    ---            item: (ident)
    ---               (group) ← TSNode:child(1):field("item")[1]:child(1)
	---        )
	---    )
	---)
	---```
	---@type table
	local lNode = TSNode:child(1):field("item")[1]:child(1);
	local dNode = TSNode:child(1):child(1);

	local label, desc;

	if label then
		label = vim.treesitter.get_node_text(lNode, buffer);

		range.label_start, range.label_end = text[1]:match(utils.escape_string(label));
	end

	if dNode then
		desc = vim.treesitter.get_node_text(dNode, buffer);

		range.desc_start, range.desc_end = text[1]:match(utils.escape_string(desc));
	end

	typst.insert({
		class = "typst_link_function",

		text = text,
		range = range
	});
end

typst.term = function (buffer, TSNode, text, range)
	for l, line in ipairs(text) do
		if l == 1 then goto continue; end
		text[l] = line:sub(range.col_start + 1);
	    ::continue::
	end

	typst.insert({
		class = "typst_term",
		term = vim.treesitter.get_node_text(
			TSNode:field("term")[1],
			buffer
		),

		text = text,
		range = range
	});
end

typst.parse = function (buffer, TSTree, from, to)
	typst.cache = {
		list_item_number = 0
	};

	-- Clear the previous contents
	typst.sorted = {};
	typst.content = {};

	local scanned_queries = vim.treesitter.query.parse("typst", [[
		((code) @typst.link_function
			(#match? @typst.link_function "^#link"))

		((heading) @typst.heading)
		((escape) @typst.escaped)
		((item) @typst.list_item)

		((code) @typst.code)
		((math) @typst.math)

		((url) @typst.link_url)

		((strong) @typst.strong)
		((emph) @typst.emphasis)
		((raw_span) @typst.raw)
		((raw_blck) @typst.raw_block)

		((label) @typst.label)
		((ref) @typst.link_ref)
		((term) @typst.term)
	]]);

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TSTree:root(), buffer, from, to) do
		local capture_name = scanned_queries.captures[capture_id];
		local r_start, c_start, r_end, c_end = capture_node:range();

		if not capture_name:match("^typst%.") then
			goto continue
		end

		local capture_text = vim.treesitter.get_node_text(capture_node, buffer);

		if not capture_text:match("\n$") then
			capture_text = capture_text .. "\n";
		end

		local lines = {};

		for line in capture_text:gmatch("(.-)\n") do
			table.insert(lines, line);
		end

		pcall(
			typst[capture_name:gsub("^typst%.", "")],

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

	    ::continue::
	end

	return typst.content, typst.sorted;
end

return typst;
