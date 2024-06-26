local parser = {};
local renderer = require("markview/renderer");

parser.md = function (buffer, TStree)
	local scanned_queies = vim.treesitter.query.parse("markdown", [[
		(atx_heading [
			(atx_h1_marker)
			(atx_h2_marker)
			(atx_h3_marker)
			(atx_h4_marker)
			(atx_h5_marker)
			(atx_h6_marker)
		] @header)

		((fenced_code_block) @code)

		((block_quote) @block_quote)

		((thematic_break) @horizontal_rule)

		((pipe_table) @table)

		(list_item [
			(list_marker_minus)
			(list_marker_plus)
			(list_marker_star)
		] @list_item)

		((task_list_marker_unchecked) @checkbox_off)
		((task_list_marker_checked) @checkbox_on)
	]]);

	for capture_id, capture_node, metadata, query in scanned_queies:iter_captures(TStree:root()) do
		local capture_name = scanned_queies.captures[capture_id];
		local capture_text = vim.treesitter.get_node_text(capture_node, buffer);
		local row_start, col_start, row_end, col_end = capture_node:range();

		if capture_name == "header" then
			table.insert(renderer.views[buffer], {
				type = "header",
				level = vim.fn.strchars(capture_text),

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		elseif capture_name == "code" then
			table.insert(renderer.views[buffer], {
				type = "code_block",
				language = vim.treesitter.get_node_text(capture_node:named_child(1), buffer),

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		elseif capture_name == "block_quote" then
			table.insert(renderer.views[buffer], {
				type = "block_quote",

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		elseif capture_name == "horizontal_rule" then
			table.insert(renderer.views[buffer], {
				type = "horizontal_rule",

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		elseif capture_name == "table" then
			local cells = {};
			local table_structure = {};

			for row in capture_node:iter_children() do
				local tmp = {};

				if row:type() == "pipe_table_header" then
					table.insert(table_structure, "header");
				elseif row:type() == "pipe_table_delimiter_row" then
					table.insert(table_structure, "seperator");
				elseif row:type() == "pipe_table_row" then
					table.insert(table_structure, "content");
				else
					table.insert(table_structure, "unknown");
				end

				for column in row:iter_children() do
					if column:type() == "pipe_table_cell" then
						table.insert(tmp, " " .. vim.treesitter.get_node_text(column, buffer))
					else
						table.insert(tmp, vim.treesitter.get_node_text(column, buffer))
					end
				end

				table.insert(cells, tmp)
			end

			table.insert(renderer.views[buffer], {
				type = "table",

				table_structure = table_structure;
				cells = cells,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		elseif capture_name == "list_item" then
			table.insert(renderer.views[buffer], {
				type = "list_item",
				marker = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		elseif capture_name == "checkbox_off" then
			table.insert(renderer.views[buffer], {
				type = "checkbox",
				checked = false,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		elseif capture_name == "checkbox_on" then
			table.insert(renderer.views[buffer], {
				type = "checkbox",
				checked = true,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		end
	end
end

parser.md_inline = function (buffer, TStree)
	local scanned_queies = vim.treesitter.query.parse("markdown_inline", [[
		((shortcut_link) @callout)

		((inline_link) @link)

		((image) @image)

		((code_span) @code)
	]]);

	for capture_id, capture_node, metadata, query in scanned_queies:iter_captures(TStree:root()) do
		local capture_name = scanned_queies.captures[capture_id];
		local capture_text = vim.treesitter.get_node_text(capture_node, buffer);
		local row_start, col_start, row_end, col_end = capture_node:range();

		if capture_name == "callout" then
			for _, extmark in ipairs(renderer.views[buffer]) do
				if extmark.type == "block_quote" and extmark.row_start == row_start then
					extmark.callout = capture_text;
				end
			end
		elseif capture_name == "link" then
			local link_text = string.match(capture_text, "%[(.-)%]");
			local link_address = string.match(capture_text, "%((.-)%)")

			table.insert(renderer.views[buffer], {
				type = "hyperlink",

				link_text = link_text,
				link_address = link_address,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
			-- vim.print(string.match(capture_text, "%((.-)%)"))
		elseif capture_name == "image" then
			local link_text = string.match(capture_text, "%[(.-)%]");
			local link_address = string.match(capture_text, "%((.-)%)")

			table.insert(renderer.views[buffer], {
				type = "image",

				link_text = link_text,
				link_address = link_address,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
			-- vim.print(string.match(capture_text, "%((.-)%)"))
		elseif capture_name == "code" then
			table.insert(renderer.views[buffer], {
				type = "inline_code",

				text = string.gsub(capture_text, "`", ""),

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		end
	end
end

parser.init = function (buffer)
	local root_parser = vim.treesitter.get_parser(buffer);
	root_parser:parse(true);

	renderer.views[buffer] = {};

	root_parser:for_each_tree(function (TStree, language_tree)
		local tree_language = language_tree:lang();

		if tree_language == "markdown" then
			parser.md(buffer, TStree)
		elseif tree_language == "markdown_inline" then
			parser.md_inline(buffer, TStree);
		else
			-- vim.print(tree_language);
		end
		-- Hi
	end)
end

return parser;
