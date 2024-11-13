local inline = {};

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
inline.inline_link = function (buffer, TSNode, text, range)
	local link_desc;
	local link_label;

	if TSNode:named_child(0) then
		link_desc = vim.treesitter.get_node_text(TSNode:named_child(0), buffer):gsub("[%[%]%(%)]", "");
		_, range.desc_start, _, range.desc_end = TSNode:named_child(0):range();
	end

	if TSNode:named_child(1) then
		link_label = vim.treesitter.get_node_text(TSNode:named_child(1), buffer):gsub("[%[%]]", "");
		_, range.label_start, _, range.label_end = TSNode:named_child(1):range();
	end

	inline.insert({
		class = "inline_link_hyperlink",
		node = TSNode,

		text = text[1]:sub(range.col_start, range.col_end),
		description = link_desc,
		label = link_label,

		range = range
	});
end

---@type markview.parsers.function
inline.reference_link = function (buffer, TSNode, text, range)
	local link_desc = vim.treesitter.get_node_text(TSNode:named_child(0), buffer):gsub("[%[%]]", "");
	local link_label;

	if TSNode:named_child(1) then
		link_label = vim.treesitter.get_node_text(TSNode:named_child(1), buffer):gsub("[%[%]]", "");
		_, range.label_start, _, range.label_end = TSNode:named_child(1):range();
	end

	_, range.desc_start, _, range.desc_end = TSNode:named_child(0):range();

	inline.insert({
		class = "inline_link_hyperlink",
		node = TSNode,

		text = text[1]:sub(range.col_start, range.col_end),
		description = link_desc,
		label = link_label and inline.cache.link_ref[link_label:gsub("[%[%]]", "")] or nil,

		range = range
	});
end

inline.embed_file = function (_, _, text, range)
	local class = "inline_link_embed_file";
	local tmp, label;

	if text[1]:match("%#%^(.+)%]%]$") then
		class = "inline_link_block_ref";
		tmp, label = text[1]:match("^(.*)%#%^(.+)%]%]$");

		range.label_start = range.col_start + #tmp + 2;
		range.label_end = range.col_end - 2;
	end

	inline.insert({
		class = class,
		-- node = TSNode,

		text = text[1]:sub(3, #text[1] - 2),
		label = label,

		range = range
	});
end

---@type markview.parsers.function
inline.shortcut_link = function (buffer, TSNode, text, range)
	local before = text[1]:sub(0, range.col_start) or "";
	local inner = text[1]:sub(range.col_start + 1, range.col_end);
	local after = text[1]:sub(range.col_end + 1, #text[1]);

	if before:match("^[%s%>]*$") and before:match("%>%s?$") and inner:match("^%[!") then
		return;
	elseif (before:match("^[%s%>]*[%-%+%*]%s$") or before:match("^[%s%>]*%d+[%.%)]%s$")) then
		return;
	elseif before:match("%!%[$") and after:match("^%]") then
		return;
	elseif before:match("%[$") and after:match("^%]") then
		text[1] = "[[" .. text[1] .. "]]";
		range.col_start = range.col_start - 1;
		range.col_end = range.col_end + 1;

		inline.internal_link(buffer, TSNode, text, range)
		return;
	end

	inline.insert({
		class = "inline_link_shortcut",
		node = TSNode,

		text = text[1]:sub(range.col_start, range.col_end),

		range = range
	})
end

---@type markview.parsers.function
inline.uri_autolink = function (_, TSNode, text, range)
	range.label_start = range.col_start + 1;
	range.label_end = range.col_end - 1;

	inline.insert({
		class = "inline_link_uri_autolink",
		node = TSNode,

		text = text[1]:sub(range.col_start, range.col_end),
		label = text[1]:sub(range.col_start + 1, range.col_end - 1),

		range = range
	})
end

---@type markview.parsers.function
inline.email = function (_, TSNode, text, range)
	range.label_start = range.col_start + 1;
	range.label_end = range.col_end - 1;

	inline.insert({
		class = "inline_link_email",
		node = TSNode,

		text = text[1]:sub(range.col_start, range.col_end),
		label = text[1]:sub(range.col_start + 2, range.col_end - 1),

		range = range
	})
end

---@type markview.parsers.function
inline.image = function (buffer, TSNode, text, range)
	text[1] = text[1]:sub(range.col_start + 1, range.col_end);

	if text[1]:match("^%!%[%[") and text[1]:match("%]%]$") then
		inline.embed_file(buffer, TSNode, text, range);
		return;
	end

	local link_desc;
	local link_label;

	if TSNode:named_child(0) then
		link_desc = vim.treesitter.get_node_text(TSNode:named_child(0), buffer):gsub("[%[%]%(%)]", "");
		_, range.desc_start, _, range.desc_end = TSNode:named_child(0):range();
	end

	if TSNode:named_child(1) then
		link_label = vim.treesitter.get_node_text(TSNode:named_child(1), buffer):gsub("[%[%]]", "");
		_, range.label_start, _, range.label_end = TSNode:named_child(1):range();
	end

	inline.insert({
		class = "inline_link_image",
		node = TSNode,

		text = text[1],
		description = link_desc,
		label = link_label,

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

		text = text[1]:gsub("[^%a%d]", ""),

		range = range
	})
end

---@type markview.parsers.function
inline.escaped = function (_, TSNode, text, range)
	inline.insert({
		class = "inline_escaped",
		node = TSNode,

		text = text[1]:sub(range.col_start + 1, range.col_end - 1),

		range = range
	})
end

inline.internal_link = function (_, TSNode, text, range)
	local alias;
	text = text[1]:gsub("[%[%]]", "");

	if text:match("%|([^%|]+)$") then
		range.alias_start, range.alias_end, alias = text:find("%|([^%|]+)$");

		range.alias_start = range.alias_start + range.col_start + 2;
		range.alias_end = range.alias_end + range.col_start + 2;
	end

	inline.insert({
		class = "inline_link_internal",
		node = TSNode,

		text = text,
		alias = alias,

		range = range
	});
end

inline.parse = function (buffer, TSTree, from, to)
	inline.sorted = {};
	inline.content = {};

	local pre_queries = vim.treesitter.query.parse("markdown_inline", [[
		(
			(shortcut_link) @markdown_inline.checkbox
			(#match? @markdown_inline.checkbox "^\\[.\\]$")) ; Fix the match pattern to match literal [ & ]
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

		([
			(inline_link)
			(collapsed_reference_link)] @markdown_inline.inline_link)

		((full_reference_link
			(link_text)
			(link_label)) @markdown_inline.reference_link)

		((shortcut_link) @markdown_inline.shortcut_link)

		((uri_autolink) @markdown_inline.uri_autolink)

		((code_span) @markdown_inline.code_span)

		([
			(entity_reference)
			(numeric_character_reference)] @markdown_inline.entity)

		((backslash_escape) @markdown_inline.escaped)
	]]);

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TSTree:root(), buffer, from, to) do
		local capture_name = scanned_queries.captures[capture_id];

		if not capture_name:match("^markdown_inline") then
			goto continue;
		end

		local r_start, c_start, r_end, c_end = capture_node:range();

		local capture_text;

		capture_text = vim.api.nvim_buf_get_lines(buffer, r_start, r_start == r_end and r_end + 1 or r_end, false);

		pcall(
			inline[capture_name:gsub("^markdown_inline%.", "")],
			buffer,
			capture_node,
			capture_text,

			{
				row_start = r_start,
				col_start = c_start,

				row_end = r_end,
				col_end = c_end
			}
		);

	    ::continue::
	end

	return inline.content, inline.sorted;
end

return inline;
