--- Markdown parser for `markview.nvim`
local markdown = {};
local utils = require("markview.utils");

---@class markview.parsers.range
---
---@field row_start integer
---@field col_start integer
---@field col_end integer
---@field row_end integer

---@alias markview.parsers.function fun(buffer: integer, TSNode: table, text: string[], range: markview.parsers.range): nil

--- Cached user config
---@type markview.configuration?
markdown.config = nil;

--- Queried contents
---@type table[]
markdown.content = {};

--- Queried contents, but sorted
markdown.sorted = {}

markdown.insert = function (data)
	table.insert(markdown.content, data);

	if not markdown.sorted[data.class] then
		markdown.sorted[data.class] = {};
	end

	table.insert(markdown.sorted[data.class], data);
end


--- ATX heading parser
---@type markview.parsers.function
markdown.atx_heading = function (buffer, TSNode, text, range)
	local marker = TSNode:named_child(0);

	markdown.insert({
		class = "markdown_atx_heading",
		node = TSNode,

		marker = vim.treesitter.get_node_text(marker, buffer),
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
	local callout = text[1]:match("^[%s%>]*%[%!(.-)%]");
	local title = text[1]:match("^[%s%>]*%[%!.-%](.+)$");

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
markdown.code_block = function (buffer, TSNode, text, range)
	local child = TSNode:named_child(1);
	local language, info;

	if child:type() == "info_string" then
		language = vim.treesitter.get_node_text(child, buffer);
		info = text[1]:match("```%S+%s(.-)$")
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

		text = text,

		range = range
	})
end

---@type markview.parsers.function
markdown.list_item = function (buffer, TSNode, text, range)
	local marker = vim.treesitter.get_node_text(TSNode:named_child(0), buffer);
	local tolarence = markdown.config.__list_item_tolarence or 3; ---@diagnostic disable-line

	local candidates = {};
	local indent;
	local inside_code = false;

	for l, line in ipairs(text) do
		--- Logic for detecting when lists should
		--- end
		if line ~= "" and #line < range.col_start then
			break;
		elseif tolarence == 0 then
			break;
		end

		--- On the first line don't do checks
		if l == 1 then
			table.insert(candidates, 0);

			indent = line:match("^.-(%s*)" .. utils.escape_string(marker)):len();
			goto continue
		end

		line = vim.fn.strcharpart(line, range.col_start + 2, vim.fn.strchars(line));

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
			tolarence = tolarence - 1;
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
		indent = indent,

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

---@type markview.parsers.function
markdown.table = function (buffer, TSNode, text, range)
	local header, seperator, rows = {}, {}, {};
	local max_cols = 0;

	local function line_processor (line)
		local _o = {};
		local carry;

		local y = 0;

		for sep, col in line:gmatch("(|)([^|\\|]+)") do
			table.insert(_o, {
				class = "seperator",

				text = sep,

				col_start = range.col_start + y,
				col_end = range.col_start + (y + #sep),
			});

			y = y + #sep;
			col = col:gsub("MKVescapedPIPE", "\\|")

			table.insert(_o, {
				class = "seperator",

				text = col,

				col_start = range.col_start + y,
				col_end = range.col_start + (y + #col),
			})

			y = y + #col;
		end

		if line:match("|$") then
			table.insert(_o, {
				class = "seperator",

				text = "|",

				col_start = range.col_start + y,
				col_end = range.col_start + (y + 1),
			});
		else
			table.insert(_o, {
				class = "missing_seperator",

				text = "|",

				col_start = range.col_start + y,
				col_end = range.col_start + (y + 1),
			});
		end

		return _o;
	end

	for l, line in ipairs(text) do
		line = line:sub(range.col_start);
		text[l] = line;

		local row_text = line:sub(range.col_start, #line):gsub("\\|", "MKVescapedPIPE");

		if l == 1 then
			header = line_processor(row_text);
		elseif l == 2 then
			seperator = line_processor(row_text);
		else
			table.insert(rows, line_processor(row_text))
		end
	end

	markdown.insert({
		class = "markdown_table",
		node = TSNode,

		text = text,

		header = header,
		seperator = seperator,
		rows = rows,

		range = range
	})
end

---@type markview.parsers.function
markdown.metadata = function (_, TSNode, text, range)
	table.insert(markdown.content, {
		class = "markdown_metadata",
		node = TSNode,

		text = text,
		range = range
	})
end

markdown.parse = function (buffer, config, TSTree, from, to)
	-- Clear the previous contents
	markdown.sorted = {}
	markdown.content = {};
	markdown.config = config;

	local scanned_queries = vim.treesitter.query.parse("markdown", [[
		((atx_heading [
			(atx_h1_marker)
			(atx_h2_marker)
			(atx_h3_marker)
			(atx_h4_marker)
			(atx_h5_marker)
			(atx_h6_marker)
			]) @markdown.atx_heading)

		((block_quote) @markdown.block_quote)

		([
			(task_list_marker_unchecked)
			(task_list_marker_checked)
			] @markview.checkbox)

		((fenced_code_block) @markdown.code_block)

		((thematic_break) @markdown.hr)

		((list_item) @markdown.list_item)

		((minus_metadata) @markdown.metadata)

		((setext_heading) @markdown.setext_heading)

		((pipe_table) @markdown.table)
	]]);

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TSTree:root(), buffer, from, to) do
		local capture_name = scanned_queries.captures[capture_id];
		local r_start, c_start, r_end, c_end = capture_node:range();

		local capture_text = vim.api.nvim_buf_get_lines(buffer, r_start, r_start == r_end and r_end + 1 or r_end, false);

		markdown[capture_name:gsub("^markdown%.", "")](buffer, capture_node, capture_text, {
			row_start = r_start,
			col_start = c_start,

			row_end = r_end,
			col_end = c_end
		});
	end

	return markdown.content, markdown.sorted;
end

return markdown;
