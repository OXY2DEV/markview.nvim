--- Markdown parser for `markview.nvim`
local markdown = {};

local spec = require("markview.spec");
local utils = require("markview.utils");

local inline = require("markview.parsers.markdown_inline");

--- Queried contents
---@type table[]
markdown.content = {};

--- Queried contents, but sorted
markdown.sorted = {}

--- Cached values.
markdown.cache = {
	table_ends = {}
}

--- `table.insert()` with extra steps.
---@param data any
markdown.insert = function (data)
	table.insert(markdown.content, data);

	if not markdown.sorted[data.class] then
		markdown.sorted[data.class] = {};
	end

	table.insert(markdown.sorted[data.class], vim.tbl_extend("force", data, {
		id = #markdown.content
	}));
end


--- ATX heading parser.
---@param buffer integer
---@param TSNode table
---@param text string[]
---@param range node.range
markdown.atx_heading = function (buffer, TSNode, text, range)
	---+${lua}

	local marker = TSNode:named_child(0);

	if text[1]:match("^%s+") then
		--- BUG, `markdown` parser includes spaces before #.
		--- So  we should modify the range do that it starts at #.
		range.col_start = range.col_start + text[1]:match("^%s+"):len();
	end

	---@type __markdown.atx
	markdown.insert({
		class = "markdown_atx_heading",

		marker = vim.treesitter.get_node_text(marker, buffer):gsub("%s", ""),
		text = text,

		range = range
	});
	---_
end

--- Setext heading parser.
---@param buffer integer
---@param TSNode table
---@param text string[]
---@param range node.range
markdown.setext_heading = function (buffer, TSNode, text, range)
	---+${lua}

	local marker = TSNode:named_child(1);

	markdown.insert({
		class = "markdown_setext_heading",

		marker = vim.treesitter.get_node_text(marker, buffer),
		text = text,

		range = range
	});
	---_
end

--- Block quote parser
---@param buffer integer
---@param TSNode table
---@param lines string[]
---@param range __block_quotes.range
markdown.block_quote = function (buffer, TSNode, lines, range)
	---+${lua}

	local text = vim.api.nvim_buf_get_lines(buffer, range.row_start, range.row_end, false);

	if lines[1]:match("^[^%>]+") then
		range.col_start = range.col_start + lines[1]:match("^[^%>]+"):len();
	end

	for l, line in ipairs(text) do
		--- We want to get text after the start column.
		text[l] = line:sub(range.col_start + 1);
	end

	local call_start, call_end, callout = text[1]:find("^%>%s?%[%!(.-)%]");
	local title_start, title_end, title = text[1]:find("^%>%s?%[%!.-%]%s(.+)$");

	if callout then
		range.callout_start = range.col_start + call_start;
		range.callout_end = range.col_start + call_end;
	end

	if title then
		range.title_start = range.col_start + title_start;
		range.title_end = range.col_start + title_end;
	end

	---@type __markdown.block_quotes
	markdown.insert({
		class = "markdown_block_quote",
		__nested = TSNode:parent() ~= nil,

		callout = callout,
		title = title,
		text = text,

		range = range
	});
	---_
end

markdown.checkbox = function (_, _, text, range)
	---+${lua}

	---@type __markdown.checkboxes
	markdown.insert({
		class = "markdown_checkbox",
		state = text[1]:match("^%[(.)%]"),

		text = text,
		range = range
	});
	---_
end

--- Code block parser
---@param range __code_blocks.range
markdown.code_block = function (buffer, TSNode, _, range)
	---+${lua}

	--- Parser is unreliable.
	--- Use buffer lines.
	---@type string[]
	local text = vim.api.nvim_buf_get_lines(buffer, range.row_start, range.row_end, false);

	--- Fix range when leading whitespace(s)
	--- are present.
	if text[1]:sub(range.col_start + 1):match("^%s+") then
		range.col_start = range.col_start + text[1]:sub(range.col_start + 1):match("^%s+"):len();
	end

	--- Modify the text so that only the text
	--- inside the node's range is visible.
	for l, line in ipairs(text) do
		text[l] = line:sub(range.col_start + 1);
	end

	local language, info_string;
	local info_node = TSNode:named_child(1);

	if info_node and info_node:type() == "info_string" then
		--- Info string found
		local lang_node = info_node:named_child(0);

		if lang_node then
			language = vim.treesitter.get_node_text(lang_node, buffer);
			range.language = { lang_node:range() };
		end

		info_string = vim.treesitter.get_node_text(info_node, buffer);
		range.info_string = { info_node:range() };
	end

	local start_delim = TSNode:child(0);
	local end_delim   = TSNode:child(TSNode:child_count() - 1);

	---@type __markdown.code_blocks
	markdown.insert({
		class = "markdown_code_block",

		language = language,
		info_string = info_string,
		delimiters = {
			start_delim and vim.treesitter.get_node_text(start_delim, buffer):gsub("^%s*", "") or "",
			end_delim and vim.treesitter.get_node_text(end_delim, buffer):gsub("^%s*", "") or "",
		},

		text = text,
		range = range
	});
	---_
end

--- Horizontal rule parser.
---@param text string[]
---@param range node.range
markdown.hr = function (_, _, text, range)
	---+${lua}

	---@type __markdown.horizontal_rules
	markdown.insert({
		class = "markdown_hr",

		text = text,
		range = range
	});
	---_
end

--- Reference link definition parser.
---@param buffer integer
---@param TSNode table
---@param text string[]
---@param range __reference_definitions.range
markdown.link_ref = function (buffer, TSNode, text, range)
	---+${lua}

	--- [link]: destination
	---   0   1   2
	--- These 3 nodes always exist.

	local n_label = TSNode:child(0);
	local n_desc  = TSNode:child(2);

	---@type string, string
	local label, desc;

	if n_label then
		label = vim.treesitter.get_node_text(n_label, buffer):gsub("^%[", ""):gsub("%]$", "");
		range.label = { n_label:range() };
	end

	if n_desc then
		desc = vim.treesitter.get_node_text(n_desc, buffer);
		range.description = { n_desc:range() };
	end

	---@type __markdown.reference_definitions
	markdown.insert({
		class = "markdown_link_ref_definition",

		label = label,
		description = desc,

		text = text,
		range = range
	});

	if label and desc then
		inline.cache.link_ref[label] = desc;
	end
	---_
end

--- List item parser.
---@param buffer integer
---@param range node.range
markdown.list_item = function (buffer, TSNode, _, range)
	---+${lua}

	---@type string[]
	local text = vim.api.nvim_buf_get_lines(buffer, range.row_start, range.row_end, false);

	local tolerance_limit = spec.get({ "experimental", "list_empty_line_tolerance" }) or 3; ---@diagnostic disable-line
	local marker, before, indent, checkbox;

	if text[1]:match("^[%>%s]*([%-%+%*])%s?") then
		marker = text[1]:match("^[%>%s]*([%-%+%*])%s?");
		checkbox = text[1]:match("^[%>%s]*[%-%+%*]%s+%[(.)%]")
	elseif text[1]:match("^[%>%s]*(%d+[%.%)])%s?") then
		marker = text[1]:match("^[%>%s]*(%d+[%.%)])%s?");
		checkbox = text[1]:match("^[%>%s]*%d+[%.%)]%s+%[(.)%]");
	end

	if not marker then
		return;
	end

	before = text[1]:match("^[%s%>]*%>") or "";

	if before:match("%>$") then
		local tmp = text[1]:gsub(
			"^" .. utils.escape_string(before),
			""
		);

		if tmp:match("^%s") then
			before = before .. " ";
			tmp = tmp:gsub("^%s", "");
		end

		indent = tmp:match("^%s*");
	else
		indent = text[1]:match("^%s*");
	end

	range.col_start = before:len();

	local list_tolerance, nested_tolerance = 0, 0;
	local nested_indent = 0;
	local skip = false;

	local candidates = {};

	for l, line in ipairs(text) do
		---+${lua}

		if list_tolerance >= tolerance_limit then
			break;
		end

		line = line:sub(range.col_start);

		if l == 1 then
			table.insert(candidates, (l - 1));
		elseif
			line:match("^(%s*)[%-%+%*]%s")
		then
			nested_indent = line:match("^(%s*)[%-%+%*]%s"):len();
			nested_tolerance = 0;

			skip = true;
		elseif
			line:match("^(%s*)%d+[%.%)]%s")
		then
			nested_indent = line:match("^(%s*)%d+[%.%)]%s"):len();
			nested_tolerance = 0;

			skip = true;
		elseif skip == true then
			local line_indent = line:match("^%s*"):len();

			if list_tolerance >= tolerance_limit then
				skip = false;
				nested_indent = 0;

				table.insert(candidates, (l - 1));
			elseif line == "" then
				nested_tolerance = nested_tolerance + 1;
			elseif line_indent <= nested_indent then
				skip = false;
				nested_indent = 0;

				table.insert(candidates, (l - 1));
			else
				nested_tolerance = 0;
			end
		else
			if list_tolerance >= tolerance_limit then
				break;
			elseif line == "" then
				list_tolerance = list_tolerance + 1;
			else
				table.insert(candidates, (l - 1));
			end
		end
		---_
	end

	local node = TSNode;
	local block = false;

	while node do
		if node:type() == "block_quote" then
			block = true;
			break;
		end

		node = node:parent();
	end

	---@type __markdown.list_items
	markdown.insert({
		class = "markdown_list_item",
		__block = block,

		candidates = candidates,
		marker = marker:gsub("%s", ""),
		checkbox = checkbox,
		indent = #(indent or ""),

		text = text,
		range = range
	});
	---_
end

--- Minus metadata parser.
---@param text string[]
---@param range node.range
markdown.metadata_minus = function (_, _, text, range)
	---+${lua}

	---@type __markdown.metadata_minus
	table.insert(markdown.content, {
		class = "markdown_metadata_minus",

		text = text,
		range = range
	});
	---_
end

--- Plus metadata parser.
---@param text string[]
---@param range node.range
markdown.metadata_plus = function (_, _, text, range)
	---+${lua}

	---@type __markdown.metadata_plus
	table.insert(markdown.content, {
		class = "markdown_metadata_plus",

		text = text,
		range = range
	});
	---_
end

markdown.section = function (buffer, TSNode, text, range)
	---+${lua}

	local heading = TSNode:child(0);
	local heading_text = vim.treesitter.get_node_text(heading, buffer);

	---@type __markdown.sections
	table.insert(markdown.content, {
		class = "markdown_section",
		level = heading_text:match("^%s*(#+)"):len(),

		text = text,
		range = range
	});
	---_
end

--- Checks if a table is overlapping with another table.
---
--- NOTE: It is assumed that the file is being parser from the
--- top.
---
---@param row_start integer
---@return boolean
---@return boolean
local function overlap (row_start)
	---+${lua}

	local top_border, border_overlap = true, false;

	for _, item in ipairs(markdown.sorted.markdown_table or {}) do
		if item.range.row_end == row_start then
			markdown.content[item.id].bottom_border = false;
			top_border = false;
			break;
		elseif item.range.row_end == row_start - 1 then
			markdown.content[item.id].border_overlap = true;
			top_border = false;
			break;
		end
	end

	return top_border, border_overlap;
	---_
end

--- Table parser.
---@param text string[]
---@param range node.range
markdown.table = function (_, _, text, range)
	---+${lua}

	local header, separator, rows = {}, {}, {};
	local aligns = {};

	if text[1] and text[1]:match("^%s+") then
		range.col_start = range.col_start + text[1]:match("^%s+"):len();
	end

	local function line_processor (line)
		local _o = {};
		local y = 0;

		line = line:gsub("\\|", "  ");

		for sep, col in line:gmatch("(|)([^|]+)") do
			table.insert(_o, {
				class = "separator",

				text = sep,

				col_start = y,
				col_end = y + #sep,
			});

			y = y + #sep;
			col = col:gsub("MKVescapedPIPE", "\\|")

			table.insert(_o, {
				class = "column",

				text = col,

				col_start = y,
				col_end = y + #col,
			})

			y = y + #col;
		end

		if line:match("|$") then
			table.insert(_o, {
				class = "separator",

				text = "|",

				col_start = y,
				col_end = y + 1,
			});
		else
			table.insert(_o, {
				class = "missing_seperator",

				text = "|",

				col_start = y,
				col_end = y,
			});
		end

		return _o;
	end

	for l, line in ipairs(text) do
		local row_text = line:gsub("\\|", "MKVescapedPIPE");

		if l == 1 then
			header = line_processor(row_text);
		elseif l == 2 then
			separator = line_processor(row_text);

			for _, col in ipairs(separator) do
				col = col.text;

				if not col:match("^[%s%-%:]+$") then
					goto continue;
				end

				if col:match("^%s*:") and col:match(":%s*$") then
					table.insert(aligns, "center");
				elseif col:match("^%s*:") then
					table.insert(aligns, "left");
				elseif col:match(":%s*$") then
					table.insert(aligns, "right");
				else
					table.insert(aligns, "default");
				end

			    ::continue::
			end
		else
			table.insert(rows, line_processor(row_text))
		end
	end

	local top_border, border_overlap = overlap(range.row_start);

	---@type __markdown.tables
	markdown.insert({
		class = "markdown_table",

		top_border = top_border,
		bottom_border = true,
		border_overlap = border_overlap,

		alignments = aligns,

		header = header,
		separator = separator,
		rows = rows,

		text = text,
		range = range
	});
	table.insert(markdown.cache.table_ends, range.row_end);
	---_
end

--- Markdown parser.
---@param buffer integer
---@param TSTree table
---@param from integer?
---@param to integer?
---@return table[]
---@return table
markdown.parse = function (buffer, TSTree, from, to)
	---+${lua}

	-- Clear the previous contents
	markdown.sorted = {}
	markdown.content = {};

	markdown.cache.table_ends = {};
	inline.cache = {
		checkbox = {},
		link_ref = {}
	};

	local scanned_queries = vim.treesitter.query.parse("markdown", [[
		((section
			(atx_heading)) @markdown.section)

		((atx_heading) @markdown.atx_heading)

		((block_quote) @markdown.block_quote)

		([
			(task_list_marker_unchecked)
			(task_list_marker_checked)
			] @markdown.checkbox)

		((fenced_code_block) @markdown.code_block)

		((thematic_break) @markdown.hr)

		((list_item) @markdown.list_item)

		((minus_metadata) @markdown.metadata_minus)

		((setext_heading) @markdown.setext_heading)

		((plus_metadata) @markdown.metadata_plus)

		((pipe_table) @markdown.table)

		((link_reference_definition) @markdown.link_ref)
	]]);

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TSTree:root(), buffer, from, to) do
		local capture_name = scanned_queries.captures[capture_id];

		if not capture_name:match("^markdown%.") then
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
			markdown[capture_name:gsub("^markdown%.", "")],

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

	return markdown.content, markdown.sorted;
	---_
end

return markdown;
