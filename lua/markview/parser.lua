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
	]]);

	for capture_id, capture_node, metadata, query in scanned_queies:iter_captures(TStree:root()) do
		local capture_name = scanned_queies.captures[capture_id];
		local capture_text = vim.treesitter.get_node_text(capture_node, 0);
		local row_start, col_start, row_end, col_end = capture_node:range();

		if capture_name == "header" then
			table.insert(renderer.views[buffer], {
				type = "header",
				capture_text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		elseif capture_name == "code" then
			table.insert(renderer.views[buffer], {
				type = "code_block",
				language = vim.treesitter.get_node_text(capture_node:named_child(1), 0),

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
		end
	end
end

parser.md_inline = function (buffer, TStree)
	local scanned_queies = vim.treesitter.query.parse("markdown_inline", [[
		((shortcut_link) @callout)
	]]);

	for capture_id, capture_node, metadata, query in scanned_queies:iter_captures(TStree:root()) do
		local capture_name = scanned_queies.captures[capture_id];
		local capture_text = vim.treesitter.get_node_text(capture_node, 0);
		local row_start, col_start, row_end, col_end = capture_node:range();

		if capture_name == "callout" then
			for _, extmark in ipairs(renderer.views[buffer]) do
				if extmark.type == "block_quote" and extmark.row_start == row_start then
					extmark.callout = capture_text;
				end
			end
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
