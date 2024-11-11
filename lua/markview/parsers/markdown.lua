--- Markdown parser for `markview.nvim`
local markdown = {};

local spec = require("markview.spec");
local utils = require("markview.utils");

local inline = require("markview.parsers.markdown_inline");

---@class markview.parsers.range
---
---@field row_start integer
---@field col_start integer
---@field col_end integer
---@field row_end integer

---@alias markview.parsers.function fun(buffer: integer, TSNode: table, text: string[], range: markview.parsers.range): nil

--- Queried contents
---@type table[]
markdown.content = {};

--- Queried contents, but sorted
markdown.sorted = {}

markdown.cache = {
	table_ends = {}
}

markdown.insert = function (data)
	table.insert(markdown.content, data);

	if not markdown.sorted[data.class] then
		markdown.sorted[data.class] = {};
	end

	table.insert(markdown.sorted[data.class], vim.tbl_extend("force", data, {
		id = #markdown.content
	}));
end


--- ATX heading parser
---@type markview.parsers.function
markdown.atx_heading = function (buffer, TSNode, text, range)
	local marker = TSNode:named_child(0);

	markdown.insert({
		class = "markdown_atx_heading",
		node = TSNode,

		marker = vim.treesitter.get_node_text(marker, buffer):gsub("%s", ""),
		text = text,

		range = range
	})
end

--- Setext heading parser
---@type markview.parsers.function
markdown.setext_heading = function (buffer, TSNode, text, range)
	local marker = TSNode:named_child(1);

	markdown.insert({
		class = "markdown_setext_heading",
		node = TSNode,

		marker = vim.treesitter.get_node_text(marker, buffer),
		text = text,

		range = range
	})
end

---@type markview.parsers.function
markdown.block_quote = function (_, TSNode, text, range)
	local call_start, call_end, callout = text[1]:find("^%>%s?%[%!(.-)%]");
	local title_start, title_end, title = text[1]:find("^%>%s?%[%!.-%](.+)$");

	if callout then
		range.callout_start = range.col_start + call_start;
		range.callout_end = range.col_start + call_end;
	end

	if title then
		range.title_start = range.col_start + title_start;
		range.title_end = range.col_start + title_end;
	end

	markdown.insert({
		class = "markdown_block_quote",
		node = TSNode,

		callout = callout,
		title = title,
		text = text,

		range = range
	})
end

---@type markview.parsers.function
markdown.code_block = function (_, TSNode, text, range)
	local tmp, before = text[1], nil;
	local language, info;

	before = #tmp:match("^[%`%~][%`%~][%`%~]%s*");
	tmp = tmp:gsub("^[%`%~][%`%~][%`%~]%s*", "");

	if tmp:match("^(%S+)") then
		language = tmp:match("^(%S+)");
		range.lang_start = before;
		range.lang_end = range.lang_start + #tmp:match("^(%S+)");
		tmp = tmp:gsub("^(%S*)", "");
	end

	if tmp:match("^%s(.+)$") then
		info = tmp:match("^%s(.+)$");
		range.info_start = range.lang_end + 1;
		range.info_end = range.info_start + #info;
	end

	markdown.insert({
		class = "markdown_code_block",
		node = TSNode,

		language = language,
		info_string = info,
		text = text,

		range = range
	})
end

---@type markview.parsers.function
markdown.checkbox = function (_, TSNode, text, range)
	markdown.insert({
		class = "markdown_checkbox",
		node = TSNode,

		text = text[1]:sub(range.col_start + 2, range.col_end - 1),

		range = range
	})
end

---@type markview.parsers.function
markdown.link_ref = function (buffer, TSNode, text, range)
	local label = text[1]:match("^%[(.-)%]%:");
	local desc = text[1]:match("^%[.-%]%:%s*(.+)$");

	if not desc and text[2] then
		desc = text[2];
	end

	markdown.insert({
		class = "inline_link_ref",
		node = TSNode,

		text = text[1]:sub(range.col_start, range.col_end),
		label = label,
		description = desc,

		range = range
	});

	inline.cache.link_ref[label] = #markdown.content;
end

---@type markview.parsers.function
markdown.list_item = function (buffer, TSNode, text, range)
	local marker, before, indent, checkbox;

	if text[1]:match("^[%>%s]*([%-%+%*])%s") then
		marker = text[1]:match("^[%>%s]*([%-%+%*])%s");
		checkbox = text[1]:match("^[%>%s]*[%-%+%*]%s+%[(.)%]")
	elseif text[1]:match("^[%>%s]*(%d+[%.%)])%s") then
		marker = text[1]:match("^[%>%s]*(%d+[%.%)])%s");
		checkbox = text[1]:match("^[%>%s]*%d+[%.%)]%s+%[(.)%]");
	end

	before, indent = text[1]:match("^(.-)(%>?%s*)" .. utils.escape_string(marker));

	if indent:match("^%>%s") then
		indent = indent:sub(3);
		before = before .. "> ";
	end

	range.col_start = before:len();

	local tolerance = spec.get({ "experimental", "list_empty_line_tolerance" }) or 3; ---@diagnostic disable-line

	local candidates = {};
	local inside_code = false;

	for l, line in ipairs(text) do
		--- Logic for detecting when lists should
		--- end
		if line ~= "" and #line < range.col_start then
			break;
		elseif tolerance == 0 then
			break;
		end

		--- On the first line don't do checks
		if l == 1 then
			table.insert(candidates, 0);
			goto continue
		end

		line = line:sub(range.col_start);

		if line:match("^%s*([%-%+%*])%s") then
			break;
		elseif line:match("^%s*(%d+)[%.%)]%s") then
			break;
		end

		--- If inside of a code block then
		--- don't do checks
		if inside_code == false and line:match("^%s*```") then
			table.insert(candidates, l - 1);
			inside_code = true;
			goto continue
		elseif inside_code == true and line:match("^%s*```$") then
			table.insert(candidates, l - 1);
			inside_code = false;
			goto continue
		elseif inside_code == true then
			table.insert(candidates, l - 1);
			goto continue
		end

		if line == "" then
			tolerance = tolerance - 1;
		elseif line:match("^%s*[%-%+%*]%s") then
			break;
		elseif line:match("^%s*%d[%.%)]%s") then
			break;
		end

		table.insert(candidates, l - 1);
		::continue::
	end

	markdown.insert({
		class = "markdown_list_item",
		node = TSNode,

		text = text,
		candidates = candidates,
		marker = marker:gsub("%s", ""),
		checkbox = checkbox,
		indent = #(indent or ""),

		range = range
	})
end

---@type markview.parsers.function
markdown.hr = function (_, TSNode, text, range)
	markdown.insert({
		class = "markdown_hr",
		node = TSNode,

		text = text,
		range = range
	})
end

local function overlap (row_start)
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
end

---@type markview.parsers.function
markdown.table = function (_, TSNode, text, range)
	local header, separator, rows = {}, {}, {};
	local aligns = {};

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

	markdown.insert({
		class = "markdown_table",
		node = TSNode,

		top_border = top_border,
		bottom_border = true,
		border_overlap = border_overlap,

		text = text,
		alignments = aligns,

		header = header,
		separator = separator,
		rows = rows,

		range = range
	});
	table.insert(markdown.cache.table_ends, range.row_end);
end

---@type markview.parsers.function
markdown.metadata_minus = function (_, TSNode, text, range)
	table.insert(markdown.content, {
		class = "markdown_metadata_minus",
		node = TSNode,

		text = text,
		range = range
	})
end

---@type markview.parsers.function
markdown.metadata_plus = function (_, TSNode, text, range)
	table.insert(markdown.content, {
		class = "markdown_metadata_plus",
		node = TSNode,

		text = text,
		range = range
	})
end

markdown.parse = function (buffer, TSTree, from, to)
	-- Clear the previous contents
	markdown.sorted = {}
	markdown.content = {};

	markdown.cache.table_ends = {};
	inline.cache.checkbox = {};
	inline.cache.link_ref = {};

	local scanned_queries = vim.treesitter.query.parse("markdown", [[
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
		local r_start, c_start, r_end, c_end = capture_node:range();

		local capture_text = vim.api.nvim_buf_get_lines(buffer, r_start, r_start == r_end and r_end + 1 or r_end, false);

		if capture_name ~= "markdown.list_item" and capture_name ~= "markdown.checkbox" then
			local spaces = capture_text[1]:sub(c_start + 1):match("^(%s*)");
			c_start = c_start + #spaces;

			for l, line in ipairs(capture_text) do
				capture_text[l] = line:sub(c_start + 1)
			end
		end

		pcall(
			markdown[capture_name:gsub("^markdown%.", "")],

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
	end

	return markdown.content, markdown.sorted;
end

return markdown;
