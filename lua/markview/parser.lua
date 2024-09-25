local parser = {};
local lang = require("markview.languages")

local ts_available, treesitter_parsers = pcall(require, "nvim-treesitter.parsers");

--- Checks if a parser is available or not
---@param parser_name string
---@return boolean
local function parser_installed(parser_name)
	return (ts_available and treesitter_parsers.has_parser(parser_name)) or pcall(vim.treesitter.query.get, parser_name, "highlights")
end

---@type markview.configuration | {}
parser.cached_conf = {};
parser.avoid_ranges = {};

parser.escape_string = function (input)
	input = input:gsub("%%", "%%%");

	input = input:gsub("%(", "%%(");
	input = input:gsub("%)", "%%)");

	input = input:gsub("%.", "%%.");
	input = input:gsub("%+", "%%+");
	input = input:gsub("%-", "%%-");
	input = input:gsub("%*", "%%*");
	input = input:gsub("%?", "%%?");
	input = input:gsub("%^", "%%^");
	input = input:gsub("%$", "%%$");

	input = input:gsub("%[", "%%[");
	input = input:gsub("%]", "%%]");

	return input;
end

parser.get_md_len = function (text)
	local final_string = text;
	local len = vim.fn.strdisplaywidth(text);

	for str_a, internal, str_b in final_string:gmatch("([*]+)([^*]+)([*]+)") do
		local valid_signs = math.max(vim.fn.strdisplaywidth(str_a), vim.fn.strdisplaywidth(str_b));

		for s = 1, valid_signs do
			local a = str_a:sub(s, s);
			local b = str_b:reverse():sub(s, s);

			if a == b then
				len = len - 2;

				final_string = final_string:gsub(a .. parser.escape_string(internal) .. b, internal);
			end
		end
	end

	for str_a, internal, str_b in final_string:gmatch("([_]+)([^_]+)([_]+)") do
		local valid_signs = math.max(vim.fn.strdisplaywidth(str_a), vim.fn.strdisplaywidth(str_b));

		for s = 1, valid_signs do
			local a = str_a:sub(s, s);
			local b = str_b:reverse():sub(s, s);

			if a == b then
				len = len - 2;

				final_string = final_string:gsub(a .. parser.escape_string(internal) .. b, internal);
			end
		end
	end

	for inline_code in final_string:gmatch("`([^`]+)`") do
		len = len - 2;

		local _r = inline_code:gsub("[%[%]%(%)%*%_]", "X")
		final_string = final_string:gsub("`" .. parser.escape_string(inline_code) .. "`", _r);
	end

	--- Image links: ![link](address)
	for link, address in final_string:gmatch("%!%[(.-)%]%((.-)%)") do
		len = len - vim.fn.strdisplaywidth("![]()" .. address);

		final_string = final_string:gsub("%!%[" .. link .. "%]%(" .. address .. "%)", link);
	end

	--- Image links: ![link][address]
	for link, address in final_string:gmatch("%!%[(.-)%]%[(.-)%]") do
		len = len - vim.fn.strdisplaywidth("![]");

		final_string = final_string:gsub("%!%[" .. link .. "%]%[" .. address .. "%]", link .. "|" .. address .. "|");
	end

	--- Links: [link](address)
	for link, address in final_string:gmatch("%[(.-)%]%((.-)%)") do
		len = len - vim.fn.strdisplaywidth("[]()" .. address);

		final_string = final_string:gsub("%[" .. link .. "%]%(" .. address .. "%)", link);
	end

	--- Links: [link][address]
	for link, address in final_string:gmatch("%[(.-)%]%[(.-)%]") do
		len = len - vim.fn.strdisplaywidth("[][]" .. address);

		final_string = final_string:gsub("%[" .. link .. "%]%[" .. address .. "%]", link);
	end

	for pattern in final_string:gmatch("%[([^%]]+)%]") do
		len = len - 2;
		final_string = final_string:gsub( "[" .. pattern .. "]", pattern);
	end

	return len, final_string;
end

parser.filter_lines = function (buffer, from, to)
	local captured_lines = vim.api.nvim_buf_get_lines(buffer, from, to, false);
	local filtered_lines = {};
	local indexes = {};
	local spaces = {};
	local align_spaces = {};
	local start_pos = {};

	local withinCodeBlock, insideDescription;
	local parent_marker;

	local tolarence = 3;
	local found = 0;

	local code_block_indent = 0;
	local desc_indent = 0;

	local start = 0;

	for l, line in ipairs(captured_lines) do
		if l == 1 then
			if line:match(">%s-([+%-*])") then
				local sp = vim.fn.strchars(line:match(">(%s-)[+%-*]"));
				local before = sp % 2 ~= 0 and line:match("(.*>%s)") or line:match("(.*>)");

				start = #before;
				line = line:gsub(before, "");
				table.insert(start_pos, start)
			elseif line:match(">%s-(%d+)[)%.]") then
				local sp = vim.fn.strchars(line:match(">(%s-)%d+[)%.]"));
				local before = sp % 2 ~= 0 and line:match("(.*>%s)") or line:match("(.*>)");

				start = #before;
				line = line:gsub(before, "");
				table.insert(start_pos, start)
			end
		elseif l ~=	1 then
			if line:match(">%s-([+%-*])") then
				break;
			elseif line:match(">%s-(%d+)[)%.]") then
				break;
			end
		else
			line = line:sub(start, #line);
			table.insert(start_pos, start);
		end

		if l ~= 1 then
			if withinCodeBlock ~= true and line:match("^%s*([+%-*])") then
				break;
			elseif withinCodeBlock ~= true and line:match("^%s*(%d+[%.%)])") then
				break;
			end
		end

		if found >= tolarence then
			break;
		end

		local spaces_before = vim.fn.strchars(line:match("^(%s*)"));

		if line:match("^%s*([+%-*])") then
			parent_marker = line:match("^%s*([+%-*])");
		elseif line:match("^%s*(%d+[%.%)])") then
			parent_marker = line:match("^%s*(%d+[%.%)])");
		end

		if line:match("(```)") and withinCodeBlock ~= true then
			withinCodeBlock = true;
			code_block_indent = spaces_before;
		elseif line:match("(```)") and withinCodeBlock == true then
			withinCodeBlock = false;
		elseif withinCodeBlock == true then
			spaces_before = spaces_before > code_block_indent and
				spaces_before - code_block_indent - 2 or
				spaces_before
			;

			goto withinElement;
		end

		if withinCodeBlock ~= true and line:match("^%s*[+%-*](%s+%[.-%])") then
			insideDescription = true;
			desc_indent = vim.fn.strchars(line:match("^%s*[+%-*](%s+%[.-%])"));
		elseif withinCodeBlock ~= true and insideDescription == true and spaces_before < desc_indent then
			insideDescription = false;
		end

		if not line:match("^%s*([+%-*])") and not line:match("^%s*(%d+[%.%)])") and parent_marker then
			spaces_before = math.max(0, spaces_before - vim.fn.strchars((parent_marker or "") .. " "));

			if line:match("(```)") then
				code_block_indent = spaces_before;
			elseif insideDescription == true then
				align_spaces[l] = 2;
				spaces_before = math.max(-10, spaces_before - desc_indent - 2);
			end
		end

		::withinElement::

		table.insert(filtered_lines, line);
		table.insert(indexes, l);
		table.insert(spaces, spaces_before);

		if line == "" then
			found = found + 1;
		end
	end

	return filtered_lines, indexes, spaces, align_spaces, start_pos;
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

parser.has_parent = function (node, matches, limit)
	local iteration = 0;

	while node:parent() do
		if limit and iteration > limit then
			return;
		end

		if vim.list_contains(matches, node:type()) then
			return node:type();
		end

		iteration = iteration + 1;
		node = node:parent();
	end
end

parser.parsed_content = {};

--- Function to parse the markdown document
---
---@param buffer number
---@param TStree any
parser.md = function (buffer, TStree, from, to)
	--- "__inside_code_block" is still experimental
	---@diagnostic disable
	if not parser.cached_conf or
	   parser.cached_conf.__inside_code_block ~= true
	then
	---@diagnostic enable
		local root = TStree:root();
		local root_r_start, _, root_r_end, _ = root:range();
		local buf_lines = vim.api.nvim_buf_line_count(buffer);

		if root_r_start ~= 0 or root_r_end ~= buf_lines then
			return;
		end
	end

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
			});
		elseif capture_name == "heading" then
			local parent = capture_node:parent();

			local heading_txt = capture_node:next_sibling();
			local title = heading_txt ~= nil and vim.treesitter.get_node_text(heading_txt, buffer) or nil;

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "heading",

				level = vim.fn.strchars(capture_text),

				line = vim.treesitter.get_node_text(parent, buffer),
				marker = capture_text,
				title = title,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "code" then
			local line_lens = {};
			local lines = {};
			local highest_len = 0;

			local block_start = vim.api.nvim_buf_get_lines(buffer, row_start, row_start + 1, false)[1];

			local language_string, additional_info = "", nil;

			if block_start:match("%s*```{{?([^}]*)}}?") then
				language_string = block_start:match("%s*```{{?([^}]*)}}?");
				additional_info = block_start:match("%s*```{{?[^}]*}}?%s*(.*)$");
			elseif block_start:match("%s*```(%S*)$") then
				language_string = block_start:match("%s*```(%S*)$");
			elseif block_start:match("%s*```(%S*)%s*") then
				language_string = block_start:match("%s*```(%S*)%s");
				additional_info = block_start:match("%s*```%S*%s+(.*)$");
			end

			for i = 1,(row_end - row_start) - 2 do
				local this_code = vim.api.nvim_buf_get_lines(buffer, row_start + i, row_start + i + 1, false)[1];
				local len = vim.fn.strdisplaywidth(this_code) or 0;

				if vim.list_contains(parser.cached_conf.filetypes or {}, string.lower(lang.get_name(language_string))) then
					len = parser.get_md_len(this_code)
				end

				if len > highest_len then
					highest_len = len;
				end

				table.insert(lines, this_code)
				table.insert(line_lens, len);
			end

			-- So that we don't accidentally parse the wrong range
			-- Note: We won't parse only the inside of the code block
			table.insert(parser.avoid_ranges, { row_start + 1, row_end - 1 });

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "code_block",
				language = language_string,

				info_string = vim.fn.strcharpart(block_start, col_start),
				block_info = additional_info,

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
				table.insert(quote_lines, txt);

				if txt ~= nil then
					if vim.fn.strchars(txt) > largest_len then
						largest_len = vim.fn.strchars(txt);
					end

					txt = txt:match("^(>%s*)(.*)$");
					table.insert(quote_markers, txt);
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

			local line_positions = {};
			local col_widths = {};

			for row in capture_node:iter_children() do
				if row:type() == "block_continuation" then
					goto ignore;
				end

				local tmp = {};
				local row_text = vim.treesitter.get_node_text(row, buffer)
				local r_row_start, r_col_start, r_row_end, r_col_end = row:range();

				local line = vim.api.nvim_buf_get_lines(buffer, r_row_start, r_row_start + 1, false)[1];

				--- Separator gets counted from the start of the line
				--- So, we will instead count the number of spaces at the start
				table.insert(line_positions, {
					row_start = r_row_start,
					col_start = r_col_start == 0 and vim.fn.strdisplaywidth(row_text:match("^(%s*)")) or r_col_start,
					row_end = r_row_end,
					col_end = r_col_end
				})
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

							-- TODO: This needs rework
							if line:match("|([^|]+)|") then
								local col_content = line:match("|([^|]+)|");
								line = vim.fn.strcharpart(line, vim.fn.strchars("|" .. col_content));

								table.insert(col_widths, vim.fn.strdisplaywidth(col_content));
							elseif line:match("|([^|]+)$") then
								local col_content = line:match("|([^|]+)$");
								line = vim.fn.strcharpart(line, vim.fn.strchars("|" .. col_content));

								table.insert(col_widths, vim.fn.strdisplaywidth(col_content));
							end
						end
					end

					table.insert(table_structure, "separator");
				elseif row:type() == "pipe_table_row" then
					table.insert(table_structure, "content");
				else
					table.insert(table_structure, "unknown");
				end

				local t_col = nil;

				for col in vim.treesitter.get_node_text(row, buffer):gmatch("|([^|\n]*)") do
					if col:match("\\$") then
						t_col =  col .. "|";
					elseif col ~= "" then
						table.insert(tmp, "|")
						table.insert(tmp, (t_col or "") .. col)

						t_col = nil;
					end
				end

				table.insert(tmp, "|");
				table.insert(rows, tmp);

				::ignore::
			end

			local s_start, s_end;

			-- This is a workaround for hybrid-mode
			--
			-- When ,`use_virt_lines` is true the table will take the
			-- line above it and the line below it.
			--
			-- So we must adjust the ranges to match the render.
			--
			-- Don't worry, the renderer will use the __r ones in that
			-- case
			if parser.cached_conf and parser.cached_conf.tables and parser.cached_conf.tables.block_decorator ~= false and parser.cached_conf.tables.use_virt_lines == false then
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

				col_widths = col_widths,
				content_alignments = alignments,
				content_positions = line_positions,

				__r_start = s_start,
				__r_end = s_end,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end,
			})
		elseif capture_name == "list_item" then
			local is_checkbox = function (text)
				if not text then
					return false;
				elseif not parser.cached_conf or not parser.cached_conf.checkboxes or not parser.cached_conf.checkboxes.custom then
					return false;
				end

				text = text:gsub("[%[%]]", "");

				for _, state in ipairs(parser.cached_conf.checkboxes.custom) do
					---@diagnostic disable-next-line
					if state.match == text then
						return true;
					elseif state.match_string == text then
						return true;
					end
				end

				if text == " " or text == "X" or text == "x" then
					return true;
				else
					return false;
				end
			end

			local marker = capture_node:named_child(0);
			local marker_text = vim.treesitter.get_node_text(marker, buffer);

			local symbol = marker_text:gsub("%s", "");

			-- Escape special characters
			symbol = symbol:gsub("%)", "%%)")

			local list_lines, lines, spaces, align_spaces, starts = parser.filter_lines(buffer, row_start, row_end);
			local spaces_before_marker = list_lines[1]:match("^(%s*)" .. symbol .. "%s*");

			local checkbox = list_lines[1]:match(parser.escape_string(marker_text) .. "%s*(%[.%])");
			local c_end, _ = parser.get_list_end_range(buffer, row_start, row_end, symbol)

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "list_item",
				marker_symbol = vim.treesitter.get_node_text(marker, buffer),
				is_checkbox = is_checkbox(checkbox),

				list_candidates = lines,
				list_lines = list_lines,

				starts = starts,
				spaces = spaces,
				align_spaces = align_spaces,
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
	--- "__inside_code_block" is still experimental
	---@diagnostic disable
	if not parser.cached_conf or
	   parser.cached_conf.__inside_code_block ~= true
	then
	---@diagnostic enable
		local root = TStree:root();
		local root_r_start, _, root_r_end, _ = root:range();

		for _, range in ipairs(parser.avoid_ranges) do
			if root_r_start >= range[1] and root_r_end <= range[2] then
				return;
			end
		end
	end

	local scanned_queies = vim.treesitter.query.parse("markdown_inline", [[
		((shortcut_link) @callout)

		([
			(inline_link)
			(full_reference_link)
		] @hyperlink)
			
		((email_autolink) @email)
		((image) @image)

		((code_span) @code)

		((entity_reference) @entity)

		((backslash_escape) @escaped)
	]]);

	-- The last 2 _ represent the metadata & query
	for capture_id, capture_node, _, _ in scanned_queies:iter_captures(TStree:root(), buffer, from, to) do
		local capture_name = scanned_queies.captures[capture_id];
		local capture_text = vim.treesitter.get_node_text(capture_node, buffer);
		local row_start, col_start, row_end, col_end = capture_node:range();

		if capture_name == "callout" then
			local line = vim.api.nvim_buf_get_lines(buffer, row_start, row_start + 1, false)[1];
			local before, after = line:sub(1, col_start), line:sub(col_end + 1);

			if capture_text:match("%[(.)%]") then
				for _, extmark in ipairs(parser.parsed_content) do
					if extmark.type == "list_item" and extmark.row_start == row_start then
						local marker = capture_text:match("%[(.)%]");
						marker = parser.escape_string(marker)

						local start_line = extmark.list_lines[1] or "";
						local list_start = extmark.starts[1] or 0;
						local atStart = start_line:match("[+%-*]%s+%[(" .. marker .. ")%]%s+");

						local chk_start, _ = start_line:find("%[(" .. marker .. ")%]");

						if not atStart or not chk_start or (list_start + chk_start) - 1 ~= col_start then
							goto invalid;
						end

						table.insert(parser.parsed_content, {
							node = capture_node,
							type = "checkbox",
							state = capture_text:match("%[(.)%]"),

							row_start = row_start,
							row_end = row_end,

							col_start = col_start,
							col_end = col_end
						});

						break;
					end

					::invalid::
				end
			elseif capture_text:match("%[%^(.+)%]") then
				table.insert(parser.parsed_content, {
					node = capture_node,
					type = "link_footnote",
					text = capture_text:match("%[(.+)%]"),

					row_start = row_start,
					row_end = row_end,

					col_start = col_start,
					col_end = col_end
				});
			elseif before:match("%[$") and after:match("^%]") then
				capture_text = capture_text:gsub("^%[", ""):gsub("%]$", "")
				local alias;

				if capture_text:match("^.-|(.+)$") then
					alias = capture_text:match("^.-|(.+)$");
				end

				table.insert(parser.parsed_content, {
					node = capture_node,
					type = "link_internal",

					text = capture_text,
					alias = alias,

					row_start = row_start,
					row_end = row_end,

					col_start = col_start,
					col_end = col_end,
				});
			elseif before:match("%>$") then
				local title = string.match(line or "", "%b[]%s*(.*)$")
				for _, extmark in ipairs(parser.parsed_content) do
					if extmark.type == "block_quote"
						and extmark.row_start == row_start
						and extmark.col_start == col_start - 1
					then
						extmark.callout = string.match(capture_text, "%[!([^%]]+)%]");
						extmark.title = title;

						extmark.line_width = vim.fn.strchars(line);

						break;
					end
				end
			end
		elseif capture_name == "hyperlink" then
			local link_text = "";
			local link_address;

			if capture_node:named_child(0) and capture_node:named_child(0):type() == "link_text" then
				link_text = vim.treesitter.get_node_text(capture_node:named_child(0), buffer);
			end

			if capture_node:named_child(1) and (capture_node:named_child(1):type() == "link_destination" or capture_node:named_child(1):type() == "link_label") then
				link_address = vim.treesitter.get_node_text(capture_node:named_child(1), buffer);
			end

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "link_hyperlink",

				text = link_text,
				address = link_address,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end,
			})
		elseif capture_name == "email" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "link_email",

				text = capture_text:gsub("^([<])", ""):gsub("([>])$", ""),

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end,
			})
		elseif capture_name == "link_image" then
			local desc = capture_node:named_child(0);
			local sibl = capture_node:named_child(1);

			local link_text = vim.treesitter.get_node_text(desc, buffer);
			local link_address = ""

			if sibl then
				link_address = vim.treesitter.get_node_text(sibl, buffer);
			end

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
		elseif capture_name == "entity" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "html_entity",

				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		elseif capture_name == "escaped" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "escaped",

				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			})
		end
	end
end

parser.html = function (buffer, TStree, from, to)
	--- "__inside_code_block" is still experimental
	---@diagnostic disable
	if not parser.cached_conf or
	   parser.cached_conf.__inside_code_block ~= true
	then
	---@diagnostic enable
		local root = TStree:root();
		local root_r_start, _, root_r_end, _ = root:range();

		for _, range in ipairs(parser.avoid_ranges) do
			if root_r_start >= range[1] and root_r_end <= range[2] then
				return;
			end
		end
	end

	local scanned_queies = vim.treesitter.query.parse("html", [[
		((element) @elem)
	]]);

	for capture_id, capture_node, _, _ in scanned_queies:iter_captures(TStree:root(), buffer, from, to) do
		local capture_name = scanned_queies.captures[capture_id];
		local capture_text = vim.treesitter.get_node_text(capture_node, buffer);
		local row_start, col_start, row_end, col_end = capture_node:range();

		if capture_name == "elem" then
			local node_childs = capture_node:named_child_count();

			local start_tag = capture_node:named_child(0);
			local end_tag = capture_node:named_child(node_childs - 1);

			if start_tag:type() == "start_tag" and end_tag:type() == "end_tag" and row_start == row_end then
				local _, ts_col_start, _, ts_col_end = start_tag:range();
				local _, te_col_start, _, te_col_end = end_tag:range();

				table.insert(parser.parsed_content, {
					node = capture_node,
					type = "html_inline",

					tag = vim.treesitter.get_node_text(start_tag, buffer):gsub("[</>]", ""),
					text = capture_text,

					start_tag_col_start = ts_col_start,
					start_tag_col_end = ts_col_end,

					end_tag_col_start = te_col_start,
					end_tag_col_end = te_col_end,

					row_start = row_start,
					row_end = row_end,

					col_start = col_start,
					col_end = col_end
				})
			end
		end
	end
end

parser.latex = function (buffer, TStree, from, to)
	if not parser_installed("latex") then
		return;
	end

	local scanned_queies = vim.treesitter.query.parse("latex", [[
		((curly_group) @bracket)

		;; Various fonts
		((generic_command
			.
			command: ((command_name) @c (#eq? @c "\\mathbf"))
			arg: (curly_group)
			.
			) @mathbf)

		((generic_command . command: ((command_name) @c (#eq? @c "\\mathbfit")) arg: (curly_group) .) @font_mathbfit)
		((generic_command . command: ((command_name) @c (#eq? @c "\\mathcal")) arg: (curly_group) .) @font_mathcal)
		((generic_command . command: ((command_name) @c (#eq? @c "\\mathfrak")) arg: (curly_group) .) @font_mathfrak)
		((generic_command . command: ((command_name) @c (#eq? @c "\\mathbb")) arg: (curly_group) .) @font_mathbb)
		((generic_command . command: ((command_name) @c (#eq? @c "\\mathsfbf")) arg: (curly_group) .) @font_mathsfbf)
		((generic_command . command: ((command_name) @c (#eq? @c "\\mathsfit")) arg: (curly_group) .) @font_mathsfit)
		((generic_command . command: ((command_name) @c (#eq? @c "\\mathsfbfit")) arg: (curly_group) .) @font_mathsfbfit)
		((generic_command . command: ((command_name) @c (#eq? @c "\\mathtt")) arg: (curly_group) .) @font_mathtt)


		((generic_command
			.
			command: (command_name)
			.
			) @symbol)

		((generic_command
			.
			command: (command_name)
			(curly_group)+
			) @operator_block)

		((superscript) @superscript)
		((subscript) @subscript)

		((inline_formula) @inline)
		((displayed_equation) @block)
	]]);

	for capture_id, capture_node, _, _ in scanned_queies:iter_captures(TStree:root(), buffer, from, to) do
		local capture_name = scanned_queies.captures[capture_id];
		local capture_text = vim.treesitter.get_node_text(capture_node, buffer);
		local row_start, col_start, row_end, col_end = capture_node:range();

		if capture_name == "inline" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "latex_inline",

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "block" then
			--- row_end is increased by 1 so that this works similar to
			--- "fenced_code_block"
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "latex_block",

				row_start = row_start,
				row_end = row_end + 1,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "bracket" then
			local text = vim.api.nvim_buf_get_lines(buffer, row_start, row_start + 1, false)[1];
			text = string.sub(text, 1, col_start);

			local has_operator = false;

			if text:match("%^$") and capture_text:match("^%{(.+)%}$") then
				-- Superscript
				goto invalidBracket;
			elseif text:match("%_$") and capture_text:match("^%{(.+)%}$") then
				-- Subscript
				goto invalidBracket;
			elseif text:match("\\(%a-)$") and vim.fn.strchars(capture_text) > 3 then
				has_operator = true;
			elseif text:match("%}$") and vim.fn.strchars(capture_text) > 3 then
				has_operator = true;
			end

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "latex_bracket",

				inside = parser.has_parent(capture_node, { "subscript", "superscript" }),
				has_operator = has_operator,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});

			::invalidBracket::
		elseif capture_name:match("^font%_(.-)") then
			capture_name = capture_name:gsub("^font%_", "");

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "latex_font",
				font = capture_name,

				text = capture_text:match("%\\" .. capture_name .. "%{(.+)%}$"),

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "operator_block" then
			local operator = capture_node:named_child(0);
			local operator_name = vim.treesitter.get_node_text(operator, buffer):gsub("^\\", "");

			local args = {};

			for n = 1, capture_node:named_child_count() - 1, 1 do
				local arg = capture_node:named_child(n);
				local r_start, c_start, r_end, c_end = arg:range();

				table.insert(args, {
					node = arg,
					text = vim.treesitter.get_node_text(arg, buffer),

					inside = parser.has_parent(capture_node, { "subscript", "superscript" }),
					row_start = r_start,
					row_end = r_end,

					col_start = c_start,
					col_end = c_end
				})
			end

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "latex_operator",

				name = operator_name,
				text = capture_text,
				args = args,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "symbol" then
			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "latex_symbol",

				inside = parser.has_parent(capture_node, { "subscript", "superscript" }),
				text = capture_text:match("%\\(.-)%{?$"),

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "superscript" then
			local text = vim.api.nvim_buf_get_lines(buffer, row_start, row_start + 1, false)[1];
			text = string.sub(text, 1, col_start);

			local special_syntax = false;

			if text:match("\\sum%_%{(.-)%}$") then
				special_syntax = true;
			elseif text:match("\\prod%_%{(.-)%}$") then
				special_syntax = true;
			elseif text:match("\\int%_%{(.-)%}$") then
				special_syntax = true;
			elseif text:match("\\oint%_%{(.-)%}$") then
				special_syntax = true;
			end

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "latex_superscript",

				special_syntax = special_syntax,
				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
		elseif capture_name == "subscript" then
			local text = vim.api.nvim_buf_get_lines(buffer, row_start, row_start + 1, false)[1];
			text = string.sub(text, 1, col_start);

			local special_syntax = false;

			if text:match("\\lim$") then
				special_syntax = true;
			elseif text:match("\\sum$") then
				special_syntax = true;
			elseif text:match("\\prod$") then
				special_syntax = true;
			elseif text:match("\\int$") then
				special_syntax = true;
			elseif text:match("\\oint$") then
				special_syntax = true;
			end

			table.insert(parser.parsed_content, {
				node = capture_node,
				type = "latex_subscript",

				special_syntax = special_syntax,
				text = capture_text,

				row_start = row_start,
				row_end = row_end,

				col_start = col_start,
				col_end = col_end
			});
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

	root_parser:for_each_tree(function (TStree, language_tree)
		local tree_language = language_tree:lang();

		if tree_language == "markdown" then
			parser.md(buffer, TStree)
		elseif tree_language == "markdown_inline" then
			parser.md_inline(buffer, TStree);
		elseif tree_language == "html" then
			parser.html(buffer, TStree);
		elseif tree_language == "latex" then
			parser.latex(buffer, TStree);
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

	if config_table then
		parser.cached_conf = config_table;
	end

	-- Clear the previous contents
	parser.parsed_content = {};

	root_parser:for_each_tree(function (TStree, language_tree)
		local tree_language = language_tree:lang();

		if tree_language == "markdown" then
			parser.md(buffer, TStree, from, to);
		elseif tree_language == "markdown_inline" then
			parser.md_inline(buffer, TStree, from, to);
		elseif tree_language == "html" then
			parser.html(buffer, TStree, from, to);
		elseif tree_language == "latex" then
			parser.latex(buffer, TStree, from, to);
		end
	end)

	return parser.parsed_content;
end

return parser;
