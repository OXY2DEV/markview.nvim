--- HTML parser for `markview.nvim`
local html = {};

--- Queried contents
---@type table[]
html.content = {};

--- Queried contents, but sorted
html.sorted = {}

html.insert = function (data)
	table.insert(html.content, data);

	if not html.sorted[data.class] then
		html.sorted[data.class] = {};
	end

	table.insert(html.sorted[data.class], data);
end

html.heading = function (buffer, TSNode, text, range)
	local tag = vim.treesitter.get_node_text(TSNode:named_child(0):named_child(0), buffer);

	html.insert({
		class = "html_heading",
		level = tonumber(tag:match("^h(%d)$")),

		text = text,

		range = range
	})
end

---@type markview.parsers.function
html.element = function (buffer, TSNode, text, range)
	local opening_tag, closing_tag;

	for child in TSNode:iter_children() do
		if child:type() == "start_tag" then
			if
				vim.treesitter.get_node_text(child, buffer):match("^%<h%d%>$")
			then
				return;
			end

			opening_tag = child;
		elseif child:type() == "end_tag" then
			closing_tag = child;
		end
	end

	if not opening_tag then return; end

	html.insert({
		class = "html_container_element",
		name = vim.treesitter.get_node_text(opening_tag:child(1), buffer),

		opening_tag = {
			text = vim.treesitter.get_node_text(opening_tag, buffer),
			range = { opening_tag:range() }
		},
		closing_tag = closing_tag and {
			text = vim.treesitter.get_node_text(closing_tag, buffer),
			range = { closing_tag:range() }
		} or nil,

		text = text,

		range = range
	});
end

html.element_void = function (buffer, TSNode, text, range)
	local opening_tag = TSNode:child(0);

	html.insert({
		class = "html_void_element",
		name = vim.treesitter.get_node_text(opening_tag:child(1), buffer),

		text = text,
		range = range
	});
end

html.parse = function (buffer, TSTree, from, to)
	-- Clear the previous contents
	html.sorted = {};
	html.content = {};

	local scanned_queries = vim.treesitter.query.parse("html", [[
		(((element
			(start_tag
				(
					((tag_name) @heading.name)
					(#match? @heading.name "^h[0-6]$")
				) @heading.start)
			(end_tag
				(
					(tag_name) @heading.end
				)))
			(#eq? @heading.start @heading.end)
			) @html.heading)

		((element 
			.
			(start_tag)
			.) @html.element_void)

		(((element
			(start_tag ((tag_name) @element.start))
			(end_tag ((tag_name) @element.end)))
			(#eq? @element.start @element.end)) @html.element)
	]]);

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TSTree:root(), buffer, from, to) do
		local capture_name = scanned_queries.captures[capture_id];
		local r_start, c_start, r_end, c_end = capture_node:range();

		if not capture_name:match("^html%.") then
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
			html[capture_name:gsub("^html%.", "")],

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

	return html.content, html.sorted;
end

return html;
