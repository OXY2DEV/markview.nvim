local parser = {};
-- local renderer = require("markview/renderer");

parser.fiter_lines = function (buffer, from, to)
	local captured_lines = vim.api.nvim_buf_get_lines(buffer, from, to, false);
	local filtered_lines = {};
	local indexes = {};
	local spaces = {};

	local withinCodeBlock;
	local parent_marker;

	local tolarence = 3;
	local found = 0;

	for l, line in ipairs(captured_lines) do
		if l ~= 1 then
			if withinCodeBlock ~= true and line:match("^%s*([+%-*])") then
				break;
			elseif withinCodeBlock ~= true and line:match("^%s*(%d+%.)") then
				break;
			end
		end

		if found >= tolarence then
			break;
		end

		local spaces_before = vim.fn.strchars(line:match("^(%s*)"));

		if line:match("(```)") and withinCodeBlock ~= true then
			withinCodeBlock = true;
			goto withinElement;
		elseif line:match("(```)") and withinCodeBlock == true then
			withinCodeBlock = false;
			goto withinElement;
		elseif withinCodeBlock == true then
			goto withinElement;
		end

		if line:match("^%s*([+%-*])") then
			parent_marker = line:match("^%s*([+%-*])");
		elseif line:match("^%s*(%d+%.)") then
			parent_marker = line:match("^%s*(%d+%.)");
		end

		if not line:match("^%s*([+%-*])") and not line:match("^%s*(%d+%.)") and parent_marker then
			spaces_before = math.max(0, spaces_before - vim.fn.strchars((parent_marker or "") .. " "));
		end

		::withinElement::

		table.insert(filtered_lines, line);
		table.insert(indexes, l);
		table.insert(spaces, spaces_before)

		if line == "" then
			found = found + 1;
		end
	end

	return filtered_lines, indexes, spaces;
end

parser.get_list_end_range = function (buffer, from, to, marker)
	local captured_lines = vim.api.nvim_buf_get_lines(buffer, from, to, false);

	local width = 0;
	local height = from - 1;

	local tolarence = 3;
	local found = 0;


	for l, line in ipairs(captured_lines) do
		if l ~= 1 and line:match(marker) then
			break;
		end

		if found >= tolarence then
			break;
		end

		width = vim.fn.strchars(line);

		if line == "" then
			found = found + 1;
		end

		height = height + 1;
	end

	return width, height == from - 1 and from or height;
end

parser.parsed_content = {};

--- Function to parse the markdown document
---
---@param buffer number
---@param TStree any
parser.md = function (buffer, TStree, from, to)
	local scanned_queies = vim.treesitter.query.parse("markdown", [[
		((setext_heading) @setext_heading)

		(atx_heading [
			(atx_h1_marker)
			(atx_h2_marker)
			(atx_h3_marker)
			(atx_h4_marker)
			(atx_h5_marker)
			(atx_h6_marker)
		] @heading)

		((fenced_code_block) @code)

		((block_quote) @block_quote)

		((thematic_break) @horizontal_rule)

		((pipe_table) @table)

		((task_list_marker_unchecked) @checkbox_off)
		((task_list_marker_checked) @checkbox_on)

		((list_item) @list_item)
	]]);

	-- The last 2 _ represent the metadata & query
	for capture_id, capture_node, _, _ in scanned_queies:iter_captures(TStree:root(), buffer, from, to) do
		local capture_name = scanned_queies.captures[capture_id];
		local capture_text = vim.treesitter.get_node_text(capture_node, buffer);
		local row_start, col_start, row_end, col_end = capture_node:range();

		if capture_name == "setext_heading" then
			local title = capture_node:named_child(0);
			local t_start, _, t_end, _ = title:range();

			local underline = vim.treesitter.get_node_text(capture_node:named_child(1), buffer);

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "heading_s",

				marker = underline,
				title = vim.api.nvim_buf_get_lines(buffer, t_start, t_end, false),

				level = capture_text:match("=") and 1 or 2,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		elseif capture_name == "heading" then
			local heading_txt = capture_node:next_sibling();
			local title = heading_txt ~= nil and vim.treesitter.get_node_text(heading_txt, buffer) or "";
			local h_txt_r_start, h_txt_c_start, h_txt_r_end, h_txt_c_end;

			if heading_txt ~= nil then
				h_txt_r_start, h_txt_c_start, h_txt_r_end, h_txt_c_end = heading_txt:range();
			end

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "heading",

				level = vim.fn.strchars(capture_text),

				marker = capture_text,
				title = title,
				title_pos = { h_txt_r_start, h_txt_c_start, h_txt_r_end, h_txt_c_end },

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		elseif capture_name == "code" then
			local line_lens = {};
			local lines = {};
			local highest_len = 0;

			local block_start = vim.api.nvim_buf_get_lines(buffer, row_start, row_start + 1, false)[1];

			for i = 1,(row_end - row_start) - 2 do
				local this_code = vim.api.nvim_buf_get_lines(buffer, row_start + i, row_start + i + 1, false)[1];
				local len = vim.fn.strchars(this_code) or 0;

				if len > highest_len then
					highest_len = len;
				end

				table.insert(lines, this_code)
				table.insert(line_lens, len);
			end

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "code_block",
				language = block_start:match("%s*```(%S*)$") or "",

				line_lengths = line_lens,
				largest_line = highest_len,
				lines = lines,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		elseif capture_name == "block_quote" then
			local quote_markers = {};
			local quote_lines = {};

			local largest_len = 0;

			-- NOTE: row index is 0-based
			for number = 0, (row_end - row_start) - 1 do
				local txt = vim.api.nvim_buf_get_lines(buffer, row_start + number, row_start + number + 1, false)[1];

				if txt ~= nil then
					if vim.fn.strchars(txt) > largest_len then
						largest_len = vim.fn.strchars(txt);
					end

					txt = txt:match("^(>%s*)(.*)$");
					table.insert(quote_lines, txt);
				end
			end

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "block_quote",
				markers = quote_markers,
				lines = quote_lines,

				row_start = row_start,
				row_end = row_end,
				-- Use hacks on renderer.lua instead
				-- The node ends on the next line after the block quote
				-- We will not count it

				col_start = col_start,
				col_end = largest_len
			})
		elseif capture_name == "horizontal_rule" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "horizontal_rule",
				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		elseif capture_name == "table" then
			local rows = {};
			local table_structure = {};
			local alignments = {};

			for row in capture_node:iter_children() do
				local tmp = {};

				if row:type() == "pipe_table_header" then
					table.insert(table_structure, "header");
				elseif row:type() == "pipe_table_delimiter_row" then
					for col in row:iter_children() do
						local txt = vim.treesitter.get_node_text(col, buffer);

						if txt ~= "|" then
							local char_s = txt:sub(0, 1);
							local char_e = txt:sub(#txt, -1)

							if txt:match(":") == nil then
								table.insert(alignments, "left");
							elseif char_s == ":" and char_e == ":" then
								table.insert(alignments, "center");
							elseif char_s == ":" then
								table.insert(alignments, "left");
							elseif char_e == ":" then
								table.insert(alignments, "right");
							end
						end
					end

					table.insert(table_structure, "seperator");
				elseif row:type() == "pipe_table_row" then
					table.insert(table_structure, "content");
				else
					table.insert(table_structure, "unknown");
				end

				for col in vim.treesitter.get_node_text(row, buffer):gmatch("%s*|([^|\n]*)") do
					if col ~= "" then
						table.insert(tmp, "|")
						table.insert(tmp, col)
					end
				end

				table.insert(tmp, "|")

				table.insert(rows, tmp)
			end

			local s_start, s_end;

			-- This is a woraround to make both table renders to work
			if parser.cached_conf and parser.cached_conf.tables and parser.cached_conf.tables.use_virt_lines == false then
				s_start = row_start;
				s_end = row_end;

				row_start = row_start - 1;
				row_end = row_end + 1;
			end

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "table",

				row_type = table_structure;
				rows = rows,

				content_alignments = alignments,

				__r_start = s_start,
				__r_end = s_end,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end,
			})
		elseif capture_name == "list_item" then
			local marker = capture_node:named_child(0);
			local marker_text = vim.treesitter.get_node_text(marker, buffer);
			local symbol = marker_text:gsub("%s", "");

			local list_lines, lines, spaces = parser.fiter_lines(buffer, row_start, row_end);
			local spaces_before_marker = list_lines[1]:match("^(%s*)" .. symbol .. "%s*");

			local c_end, _ = parser.get_list_end_range(buffer, row_start, row_end, symbol)

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "list_item",
				marker_symbol = vim.treesitter.get_node_text(marker, buffer),

				list_candidates = lines,
				list_lines = list_lines,

				spaces = spaces,
				conceal_spaces = vim.fn.strchars(spaces_before_marker),

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = c_end
			})
		elseif capture_name == "checkbox_off" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "checkbox",
				state = "incomplete",

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		elseif capture_name == "checkbox_on" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "checkbox",
				state = "complete",

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		end
	end
end

--- Function to parse inline_markdown
---
---@param buffer number
---@param TStree any
parser.md_inline = function (buffer, TStree, from, to)
	local scanned_queies = vim.treesitter.query.parse("markdown_inline", [[
		((shortcut_link) @callout)

		([
			(image)
			(inline_link)
			(email_autolink)
			] @link)

		((code_span) @code)
	]]);

	-- The last 2 _ represent the metadata & query
	for capture_id, capture_node, _, _ in scanned_queies:iter_captures(TStree:root(), buffer, from, to) do
		local capture_name = scanned_queies.captures[capture_id];
		local capture_text = vim.treesitter.get_node_text(capture_node, buffer);
		local row_start, col_start, row_end, col_end = capture_node:range();

		if capture_name == "callout" then
			local line = vim.api.nvim_buf_get_lines(buffer, row_start, row_start + 1, false);
			local title = string.match(line ~= nil and line[1] or "", "%b[]%s*(.*)$")

			if capture_text == "[-]" then
				table.insert(parser.parsed_content, {
					node = capture_node,
					type = "checkbox",
					state = "pending",

					row_start = row_start,
					row_end = row_end,

					col_start = col_start,
					col_end = col_end
				})
			else
				for _, extmark in ipairs(parser.parsed_content) do
					if extmark.type == "block_quote" and extmark.row_start == row_start then

						extmark.callout = string.match(capture_text, "%[!([^%]]+)%]");
						extmark.title = title;

						extmark.line_width = vim.fn.strchars(line[1])
					end
				end
			end
		elseif capture_name == "link" then
			local link_type = capture_node:type();
			local link_text = string.match(capture_text, "%[(.-)%]");
			local link_address = string.match(capture_text, "%((.-)%)")

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "link",
				link_type = link_type,

				text = link_text,
				address = link_address,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end,
			})
		elseif capture_name == "image" then
			local link_text = string.match(capture_text, "%[(.-)%]");
			local link_address = string.match(capture_text, "%((.-)%)")

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "image",

				text = link_text,
				address = link_address,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		elseif capture_name == "code" then
			table.insert(parser.parsed_content, {
				node = capture_node,
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

--- Initializes the parsers on the specified buffer
--- Parsed data is stored as a "view" in renderer.lua
---
---@param buffer number
parser.init = function (buffer, config_table)
	local root_parser = vim.treesitter.get_parser(buffer);
	root_parser:parse(true);

	if config_table then
		parser.cached_conf = config_table;
	end

	-- Clear the previous contents
	parser.parsed_content = {};
	local main_tree_parsed = false;

	root_parser:for_each_tree(function (TStree, language_tree)
		local tree_language = language_tree:lang();

		if tree_language == "markdown" then
			parser.md(buffer, TStree)
		elseif tree_language == "markdown_inline" then
			parser.md_inline(buffer, TStree);
		end
	end)

	return parser.parsed_content;
end

parser.parse_range = function (buffer, config_table, from, to)
	if not from or not to then
		return {};
	end

	local root_parser = vim.treesitter.get_parser(buffer);
	root_parser:parse(true);

	-- Clear the previous contents
	parser.parsed_content = {};
	local main_tree_parsed = false;

	root_parser:for_each_tree(function (TStree, language_tree)
		local tree_language = language_tree:lang();

		if tree_language == "markdown" then
			parser.md(buffer, TStree, from, to)
		elseif tree_language == "markdown_inline" then
			parser.md_inline(buffer, TStree, from, to);
		end
	end)

	return parser.parsed_content;
end

return parser;
