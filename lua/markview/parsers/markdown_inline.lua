local inline = {};

--- Cached user config
---@type markview.configuration?
inline.config = nil;

--- Queried contents
---@type table[]
inline.content = {};

--- Queried contents, but sorted
inline.sorted = {}

inline.insert = function (data)
	table.insert(inline.content, data);

	if not inline.sorted[data.class] then
		inline.sorted[data.class] = {};
	end

	table.insert(inline.sorted[data.class], data);
end

--- Cached stuff
inline.cache = {
	checkbox = {},
	link_ref = {}
}

---@type markview.parsers.function
inline.checkbox = function (_, TSNode, text, range)
	local before = text[1]:sub(0, range.col_start);
	local inner = text[1]:sub(range.col_start + 1, range.col_end - 1);

	if not (before:match("^[%s%>]*[%-%+%*]%s$") or before:match("^[%s%>]*%d+[%.%)]%s$")) then
		return;
	end

	inline.insert({
		class = "inline_checkbox",
		node = TSNode,

		text = inner:gsub("[%[%]]", ""),

		range = range
	});

	inline.cache.checkbox[range.row_start] = #inline.content;
end

---@type markview.parsers.function
inline.link_ref = function (buffer, TSNode, text, range)
	local label = vim.treesitter.get_node_text(TSNode:named_child(0), buffer):gsub("[%[%]]", "");
	local desc = vim.treesitter.get_node_text(TSNode:named_child(1), buffer);

	inline.insert({
		class = "inline_link_ref",
		node = TSNode,

		text = text[1]:sub(range.col_start, range.col_end),
		label = label,
		description = desc,

		range = range
	});

	inline.cache.link_ref[label] = #inline.content;
end

---@type markview.parsers.function
inline.inline_link = function (buffer, TSNode, text, range)
	local link_text = vim.treesitter.get_node_text(TSNode:named_child(0), buffer):gsub("[%[%]]", "");
	local link_dest = vim.treesitter.get_node_text(TSNode:named_child(1), buffer);

	inline.insert({
		class = "inline_link_hyperlink",
		node = TSNode,

		text = text[1]:sub(range.col_start, range.col_end),
		description = link_text,
		destination = link_dest,

		range = range
	});
end

---@type markview.parsers.function
inline.reference_link = function (buffer, TSNode, text, range)
	local link_text = vim.treesitter.get_node_text(TSNode:named_child(0), buffer):gsub("[%[%]]", "");
	local link_dest = vim.treesitter.get_node_text(TSNode:named_child(1), buffer);

	inline.insert({
		class = "inline_link_ref_link",
		node = TSNode,

		text = text[1]:sub(range.col_start, range.col_end),
		description = link_text,
		label = inline.cache.link_ref[link_dest:gsub("[%[%]]", "")],

		range = range
	});
end

---@type markview.parsers.function
inline.shortcut_link = function (_, TSNode, text, range)
	local before = text[1]:sub(0, range.col_start);
	local inner = text[1]:sub(range.col_start + 1, range.col_end);

	if before:match("^[%s%>]*$") and before:match("%>%s?$") and inner:match("^%[!") then
		return;
	elseif (before:match("^[%s%>]*[%-%+%*]%s$") or before:match("^[%s%>]*%d+[%.%)]%s$")) then
		return;
	end

	inline.insert({
		class = "inline_link_shortcut_link",
		node = TSNode,

		text = text[1]:sub(range.col_start, range.col_end),

		range = range
	})
end

---@type markview.parsers.function
inline.uri_autolink = function (_, TSNode, text, range)
	inline.insert({
		class = "inline_link_uri_autolink",
		node = TSNode,

		text = text[1]:sub(range.col_start, range.col_end),
		destination = text[1]:sub(range.col_start + 1, range.col_end - 1),

		range = range
	})
end

---@type markview.parsers.function
inline.email = function (_, TSNode, text, range)
	inline.insert({
		class = "inline_link_uri_email",
		node = TSNode,

		text = text[1]:sub(range.col_start, range.col_end),
		destination = text[1]:sub(range.col_start + 1, range.col_end - 1),

		range = range
	})
end

---@type markview.parsers.function
inline.image = function (_, TSNode, text, range)
	local link_text = vim.treesitter.get_node_text(TSNode:named_child(0), buffer):gsub("[%[%]]", "");
	local link_dest = vim.treesitter.get_node_text(TSNode:named_child(1), buffer);

	inline.insert({
		class = "inline_link_image",
		node = TSNode,

		text = text[1]:sub(range.col_start, range.col_end),
		description = link_text,
		label = link_dest:gsub("[%[%]]", ""),

		range = range
	})
end

---@type markview.parsers.function
inline.code_span = function (_, TSNode, text, range)
	inline.insert({
		class = "inline_code_span",
		node = TSNode,

		text = text[1]:sub(range.col_start + 1, range.col_end - 1),

		range = range
	})
end

---@type markview.parsers.function
inline.entity = function (_, TSNode, text, range)
	inline.insert({
		class = "inline_entity",
		node = TSNode,

		text = text[1]:sub(range.col_start + 1, range.col_end - 1),

		range = range
	})
end

---@type markview.parsers.function
inline.escaped = function (_, TSNode, text, range)
	inline.insert({
		class = "inline_entity",
		node = TSNode,

		text = text[1]:sub(range.col_start + 1, range.col_end - 1),

		range = range
	})
end

inline.parse = function (buffer, config, TSTree, from, to)
	inline.sorted = {};
	inline.content = {};
	inline.config = config;

	inline.cache.checkbox = {};
	inline.cache.link_ref = {};

	local pre_queries = vim.treesitter.query.parse("markdown_inline", [[
		(
			(shortcut_link) @markdown_inline.checkbox
			(#match? @markdown_inline.checkbox "^...$")) ; Fix the match pattern to match literal [ & ]

		((link_reference_definition
			(link_label)
			(link_destination)) @markdown_inline.link_ref)
	]]);

	for capture_id, capture_node, _, _ in pre_queries:iter_captures(TSTree:root(), buffer, from, to) do
		local capture_name = pre_queries.captures[capture_id];
		local r_start, c_start, r_end, c_end = capture_node:range();

		local capture_text = vim.api.nvim_buf_get_lines(buffer, r_start, r_start == r_end and r_end + 1 or r_end, false);

		inline[capture_name:gsub("^markdown_inline%.", "")](buffer, capture_node, capture_text, {
			row_start = r_start,
			col_start = c_start,

			row_end = r_end,
			col_end = c_end
		});
	end

	local scanned_queries = vim.treesitter.query.parse("markdown_inline", [[
		((email_autolink) @markdown_inline.email)

		((image) @markdown_inline.image)

		((inline_link
			(link_text)
			(link_destination)) @markdown_inline.inline_link)

		((full_reference_link
			(link_text)
			(link_label)) @markdown_inline.reference_link)

		((shortcut_link) @markdown_inline.shortcut_link)

		((uri_autolink) @markdown_inline.uri_autolink)

		((code_span) @markdown_inline.code_span)

		((entity_reference) @markdown_inline.entity)

		((backslash_escape) @markdown_inline.escaped)
	]]);

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TSTree:root(), buffer, from, to) do
		local capture_name = scanned_queries.captures[capture_id];
		local r_start, c_start, r_end, c_end = capture_node:range();

		local capture_text;

		capture_text = vim.api.nvim_buf_get_lines(buffer, r_start, r_start == r_end and r_end + 1 or r_end, false);

		inline[capture_name:gsub("^markdown_inline%.", "")](buffer, capture_node, capture_text, {
			row_start = r_start,
			col_start = c_start,

			row_end = r_end,
			col_end = c_end
		});
	end

	return inline.content, inline.sorted;
end

return inline;
