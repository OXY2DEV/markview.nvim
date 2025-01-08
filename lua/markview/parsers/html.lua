--- HTML parser for `markview.nvim`.
local html = {};

--- Queried contents
---@type table[]
html.content = {};

--- Queried contents, but sorted
---@type { [string]: table }
html.sorted = {}

--- Wrapper for `table.insert()`.
---@param data table
html.insert = function (data)
	---+${func}
	table.insert(html.content, data);

	if not html.sorted[data.class] then
		html.sorted[data.class] = {};
	end

	table.insert(html.sorted[data.class], data);
	---_
end

--- Heading element parser
---@param buffer integer
---@param TSNode table
---@param text string[]
---@param range node.range
html.heading = function (buffer, TSNode, text, range)
	---+${func}

	---@type table The opening tag.
	local tag = vim.treesitter.get_node_text(TSNode:named_child(0):named_child(0), buffer);

	---@type __html.headings
	html.insert({
		class = "html_heading",
		level = tonumber(tag:match("^h(%d)$")),

		text = text,
		range = range
	});
	---_
end

--- Container element parser
---@param buffer integer
---@param TSNode table
---@param text string[]
---@param range node.range
html.element = function (buffer, TSNode, text, range)
	---+${func}
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

	if not opening_tag then
		--- Broken elements should be skipped.
		return;
	end

	---@type __html.container_elements
	html.insert({
		class = "html_container_element",
		name = string.lower(vim.treesitter.get_node_text(opening_tag:child(1), buffer) or ""),

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
	---_
end

--- Void element parser
---@param buffer integer
---@param TSNode table
---@param text string[]
---@param range node.range
html.element_void = function (buffer, TSNode, text, range)
	---+${func}
	local tag = TSNode:child(0);

	---@type __html.void_elements
	html.insert({
		class = "html_void_element",
		name = string.lower(vim.treesitter.get_node_text(tag:child(1), buffer) or ""),

		text = text,
		range = range
	});
	---_
end

--- HTML parser
---@param buffer integer
---@param TSTree table
---@param from integer?
---@param to integer?
---@return table[]
---@return table
html.parse = function (buffer, TSTree, from, to)
	---+${func}
	-- Clear the previous contents
	html.sorted = {};
	html.content = {};

	local scanned_queries = vim.treesitter.query.parse("html", [[
		(((element
			(start_tag
				(
					((tag_name) @heading.name)
					(#match? @heading.name "^[hH][0-6]$")
				) @heading.start)
			(end_tag
				(
					(tag_name) @heading.end
				)))
			) @html.heading)

		((element 
			.
			(start_tag)
			.) @html.element_void)

		(((element
			(start_tag ((tag_name) @element.start))
			(end_tag ((tag_name) @element.end)))
			) @html.element)
	]]);

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TSTree:root(), buffer, from, to) do
		local capture_name = scanned_queries.captures[capture_id];

		if not capture_name:match("^html%.") then
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

		if success == false then
			require("markview.health").notify("trace", {
				level = 4,
				message = error
			});
		end

	    ::continue::
	end

	return html.content, html.sorted;
	---_
end

return html;
