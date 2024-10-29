local typst = {};
local utils = require("markview.utils");

typst.content = {};

typst.markup = function (buffer, TStree, from, to)
	--- "__inside_code_block" is still experimental
	---@diagnostic disable
	if not parser.cached_conf or
	   typst.config.__inside_code_block ~= true
	then
	---@diagnostic enable
		for _, tbl in ipairs(parser.parsed_content) do
			if not tbl.type == "code_block" then
				goto skip;
			end

			local root = TStree:root();
			local root_r_start, _, _, _ = root:range();

			if root_r_start >= tbl.row_start and root_r_start <= tbl.row_end then
				return;
			end

			::skip::
		end
	end

	local scanned_queries = vim.treesitter.query.parse("typst", [[
		((heading) @typst.heading)
		((escape) @typst.escaped)
		((item) @typst.list_item)

		((code) @typst.code)
		((math) @typst.math)

		((url) @typst.link)

		((strong) @typst.strong)
		((emph) @typst.emphasis)
		((raw_span) @typst.raw)

		((label) @typst.label)
		((ref) @typst.reference)
		((term) @typst.term)
	]]);

	local labels = {};

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TStree:root(), buffer, from, to) do
		local capture_name = scanned_queries.captures[capture_id];
		local capture_text = vim.treesitter.get_node_text(capture_node, buffer);
		local row_start, col_start, row_end, col_end = capture_node:range();

		if capture_name == "typst.heading" then
			local level = capture_text:match("^(%=+)"):len();

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_heading",

				level = level,
				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "typst.escaped" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_escaped",

				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "typst.list_item" then
			local lines = vim.api.nvim_buf_get_lines(buffer, row_start, row_end + 1, false);
			local lnums = parser.typst_list_processor(lines, col_start);

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_list_item",
				marker = lines[1]:match("^%s*([%-%+])") or lines[1]:match("^%s*(%d+)%."),

				text = lines,
				lnums = lnums,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "typst.raw" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_raw",

				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "typst.math" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_math",

				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "typst.strong" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_strong",

				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "typst.emphasis" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_emphasis",

				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "typst.label" then
			labels[capture_text:gsub("[%<%>]", "")] = {
				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			};

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_label",

				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "typst.reference" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_ref",

				label = labels[capture_text:gsub("^@", "")],
				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "typst.term" then
			local name = capture_node:field("term")[1];

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_term",

				term = vim.treesitter.get_node_text(name, buffer),
				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		end
	end
end

typst.math = function (buffer, TStree, from, to)
	--- "__inside_code_block" is still experimental
	---@diagnostic disable
	if not parser.cached_conf or
	   parser.cached_conf.__inside_code_block ~= true
	then
	---@diagnostic enable
		for _, tbl in ipairs(parser.parsed_content) do
			if not tbl.type == "code_block" then
				goto skip;
			end

			local root = TStree:root();
			local root_r_start, _, _, _ = root:range();

			if root_r_start >= tbl.row_start and root_r_start <= tbl.row_end then
				return;
			end

			::skip::
		end
	end

	local scanned_queries = vim.treesitter.query.parse("typst", [[
		((heading) @typst.heading)
		((escape) @typst.escaped)
		((item) @typst.list_item)

		((code) @typst.code)
		((math) @typst.math)

		((url) @typst.link)

		((strong) @typst.strong)
		((emph) @typst.emphasis)
		((raw_span) @typst.raw)

		((label) @typst.label)
		((ref) @typst.reference)
		((term) @typst.term)
	]]);

	local labels = {};

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TStree:root(), buffer, from, to) do
		local capture_name = scanned_queries.captures[capture_id];
		local capture_text = vim.treesitter.get_node_text(capture_node, buffer);
		local row_start, col_start, row_end, col_end = capture_node:range();

		if capture_name == "typst.heading" then
			local level = capture_text:match("^(%=+)"):len();

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_heading",

				level = level,
				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "typst.escaped" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_escaped",

				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "typst.list_item" then
			local lines = vim.api.nvim_buf_get_lines(buffer, row_start, row_end + 1, false);
			local lnums = parser.typst_list_processor(lines, col_start);

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_list_item",
				marker = lines[1]:match("^%s*([%-%+])") or lines[1]:match("^%s*(%d+)%."),

				text = lines,
				lnums = lnums,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "typst.raw" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_raw",

				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "typst.math" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_math",

				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "typst.strong" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_strong",

				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "typst.emphasis" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_emphasis",

				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "typst.label" then
			labels[capture_text:gsub("[%<%>]", "")] = {
				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			};

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_label",

				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "typst.reference" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_ref",

				label = labels[capture_text:gsub("^@", "")],
				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "typst.term" then
			local name = capture_node:field("term")[1];

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "typst_term",

				term = vim.treesitter.get_node_text(name, buffer),
				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		end
	end
end

typst.parse = function (buffer, config, TStree, from, to)
	typst.content = {};
	typst.config = config;

	if not utils.parser_installed("typst") then
		return;
	end

	typst.markup(buffer, TStree, from, to);
end

return typst;
