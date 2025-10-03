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
---@param range markview.parsed.range
markdown.atx_heading = function (buffer, TSNode, text, range)
	local marker = TSNode:named_child(0);

	if text[1]:match("^%s+") then
		--- BUG, `markdown` parser includes spaces before #.
		--- So  we should modify the range do that it starts at #.
		range.col_start = range.col_start + text[1]:match("^%s+"):len();
	end

	---|fS "chunk: Calculate heading depth"

	---@type integer[] Heading depth levels(like 1.1.2).
	local levels = {};

	---@type TSNode?
	local parent_section = TSNode:parent():parent();
	---@type TSNode?
	local current_section = TSNode:parent();

	--[[
		NOTE(@OXY2DEV): Heading level retriever.

		Each `atx_heading` creates a `section` in the document.
		By checking the depth of a `section` & it's sibling `section`s
		we cab determine the level of a heading.

		Level format: 1.1.1.1
		They are calculated like so,

		```md
		# 1
		## 1.1
		### 1.1.1

		# 2
		# 2.1
		```

		For each level of depth, we iterate over the children of the
		**parent** section and count how many `section2`s we have passed.

		We keep doing this recursively until we reach the top of the `TSTree`.
		As we are traversing the tree in reverse(bottom to top) we add the level
		to the start of the `levels` list.

		TODO(@OXY2DEV): Check if we can optimize this further.
	]]
	while parent_section and current_section do
		---@type integer Number of sections passed.
		local passed = 1;

		for direct_child in parent_section:iter_children() do
			if direct_child:equal(current_section) then
				table.insert(levels, 1, passed);
				break;
			elseif direct_child:type() == "section" then
				passed = passed + 1;
			end
		end

		parent_section = parent_section:parent();
		current_section = current_section:parent();
	end

	---|fE

	---@type string The `#` before the heading.
	local markers = vim.treesitter.get_node_text(marker, buffer):gsub("%s", "");

	--[[
		In case the heading has no parent add 0 until all levels have
		a value.

		For example,

		```md
		##  Heading 2

		### heading 3
		```
	]]
	while #levels < #markers do
		table.insert(levels, 1, 0);
	end

	markdown.insert({
		class = "markdown_atx_heading",
		levels = levels,

		marker = markers,
		text = text,

		range = range
	});
end

--- Setext heading parser.
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.range
markdown.setext_heading = function (buffer, TSNode, text, range)
	local marker = TSNode:named_child(1);

	if not marker then
		return;
	end

	markdown.insert({
		class = "markdown_setext_heading",

		marker = vim.treesitter.get_node_text(marker, buffer),
		text = text,

		range = range
	});

	local row_end = range.row_start;
	local sibling = TSNode:next_sibling();

	while sibling do
		if vim.list_contains({ "setext_heading", "atx_heading" }, sibling:type()) then
			break;
		end

		_, _, row_end, _ = sibling:range();
		sibling = sibling:next_sibling();
	end

	local marker_text = vim.treesitter.get_node_text(marker, buffer, {});

	if range.row_start ~= row_end then
		table.insert(markdown.content, {
			class = "markdown_section",
			level = string.match(marker_text, "=") and 1 or 2,

			text = text,
			range = {
				row_start = range.row_start + 2,
				row_end = row_end,
				org_end = row_end,

				col_start = range.col_start,
				col_end = 0
			}
		});
	end
end

---@param buffer integer
---@param TSNode table
---@param lines string[]
---@param range markview.parsed.markdown.block_quotes.range
markdown.block_quote = function (buffer, TSNode, lines, range)
	local text = vim.api.nvim_buf_get_lines(buffer, range.row_start, range.row_end, false);

	if lines[1]:match("^[^%>]+") then
		range.col_start = range.col_start + lines[1]:match("^[^%>]+"):len();
	end

	for l, line in ipairs(text) do
		-- We want to get text after the start column.
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

	local nested = false;
	local parent = TSNode:parent();

	while parent do
		if parent:type() == "block_quote" then
			nested = true;
			break;
		end

		parent = parent:parent();
	end

	markdown.insert({
		class = "markdown_block_quote",
		__nested = nested,

		callout = callout,
		title = title,
		text = text,

		range = range
	});
end

---@param text string[]
---@param range markview.parsed.markdown.block_quotes.range
markdown.checkbox = function (_, _, text, range)
	markdown.insert({
		class = "markdown_checkbox",
		state = text[1]:match("^%[(.)%]"),

		text = text,
		range = range
	});
end

---@param buffer integer
---@param TSNode table
---@param range markview.parsed.markdown.code_blocks.range
markdown.code_block = function (buffer, TSNode, _, range)
	-- Parser is unreliable.
	-- Use buffer lines instead.
	---@type string[]
	local text = vim.api.nvim_buf_get_lines(buffer, range.row_start, range.row_end, false);

	-- Fix range when leading whitespace(s)
	-- are present.
	if text[1]:sub(range.col_start + 1):match("^%s+") then
		range.col_start = range.col_start + text[1]:sub(range.col_start + 1):match("^%s+"):len();
	end

	-- Modify the text so that only the text
	-- inside the node's range is visible.
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

		info_string = string.gsub(
			vim.treesitter.get_node_text(info_node, buffer),
			"^^%s+",
			""
		);
		range.info_string = { info_node:range() };
	end

	---@type TSNode, TSNode?
	local start_delim, end_delim;

	for child in TSNode:iter_children() do
		if child:type() == "fenced_code_block_delimiter" then
			if not start_delim then
				start_delim = child;
				range.start_delim = { child:range() };
			else
				end_delim = child;
				range.end_delim = { child:range() };
				break;
			end
		end
	end

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
end

---@param buffer integer
---@param range markview.parsed.markdown.indented_code_blocks.range
markdown.indented_code_block = function (buffer, _, _, range)
	-- Use buffer lines instead.
	---@type string[]
	local text = vim.api.nvim_buf_get_lines(buffer, range.row_start, range.row_end, false);

	-- Modify the text so that only the text
	-- inside the node's range is visible.
	for l, line in ipairs(text) do
		text[l] = line:sub(range.col_start + 1);
	end

	while #text > 1 and string.match(text[#text], "^[%>%s]*$") do
		table.remove(text);
		range.row_end = range.row_end - 1;
	end

	range.space_end = range.col_start + #string.match(text[1], "^%s*");

	markdown.insert({
		class = "markdown_indented_code_block",

		text = text,
		range = range
	});
end

--- Horizontal rule parser.
---@param text string[]
---@param range markview.parsed.range
markdown.hr = function (_, _, text, range)
	markdown.insert({
		class = "markdown_hr",

		text = text,
		range = range
	});
end

--- Reference link definition parser.
---@param buffer integer
---@param TSNode table
---@param text string[]
---@param range markview.parsed.markdown.reference_definitions.range
markdown.link_ref = function (buffer, TSNode, text, range)
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

	markdown.insert({
		class = "markdown_link_ref_definition",

		label = label,
		description = desc,

		text = text,
		range = range
	});
end

--- List item parser.
---@param buffer integer
---@param TSNode table
---@param range markview.parsed.range
markdown.list_item = function (buffer, TSNode, _, range)
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
			"^" .. vim.pesc(before),
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
				table.insert(candidates, (l - 1));
			else
				list_tolerance = 0;
				table.insert(candidates, (l - 1));
			end
		end
	end

	--[[
		If the last line has no **non-whitespace character**,
		we will remove the empty line candidates from the end of the `TSNode` range.

		NOTE: This is done to prevent indenting empty lines at the end of a list.

		See #399 for more details.
	]]
	if string.match(text[#text], "^%s*$") then
		for c = #candidates, 1, -1 do
			local item = candidates[c] + 1;
			local line = text[item];

			if string.match(line, "%S") then
				break;
			end

			-- vim.print(item)
			table.remove(candidates);
		end
	end

	local parent = TSNode:parent();
	local nested = false;

	while parent do
		if parent:type() == "list_item" then
			nested = true;
			break;
		end

		parent = parent:parent();
	end

	markdown.insert({
		class = "markdown_list_item",
		__nested = nested,

		candidates = candidates,
		marker = marker:gsub("%s", ""),
		checkbox = checkbox,
		indent = #(indent or ""),

		text = text,
		range = range
	});
end

--- Minus metadata parser.
---@param text string[]
---@param range markview.parsed.range
markdown.metadata_minus = function (_, _, text, range)
	table.insert(markdown.content, {
		class = "markdown_metadata_minus",

		text = text,
		range = range
	});
end

--- Plus metadata parser.
---@param text string[]
---@param range markview.parsed.range
markdown.metadata_plus = function (_, _, text, range)
	table.insert(markdown.content, {
		class = "markdown_metadata_plus",

		text = text,
		range = range
	});
end

---@param buffer integer
---@param TSNode table
---@param text string[]
---@param range markview.parsed.markdown.sections.range
markdown.section = function (buffer, TSNode, text, range)
	local heading = TSNode:child(0);
	local heading_text = vim.treesitter.get_node_text(heading, buffer);

	---@type TSNode?
	local next_sibling = heading:next_sibling();
	local org_end = range.row_end;

	while next_sibling do
		if vim.list_contains({ "section", "setext_heading" }, next_sibling:type()) then
			org_end = -1 + next_sibling:range();
			break;
		end

		_, _, org_end, _ = next_sibling:range();
		next_sibling = next_sibling:next_sibling();
	end

	range.org_end = org_end;

	table.insert(markdown.content, {
		class = "markdown_section",
		level = heading_text:match("^%s*(#+)"):len(),

		text = text,
		range = range
	});
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

--- LPeg-based parser for markdown table rows.
---@param line string
---@return table[]
local function lpeg_processor(line)
	---|fS

	line = line:gsub("^%s*", "");
	line = line:gsub("\\|", "  ");

	local pipe = vim.lpeg.C("|");
	local cont = vim.lpeg.C(vim.re.compile("[^|]+"))

	local init_cell = vim.lpeg.P(pipe^-1 * cont * pipe)
	local end_cell = vim.lpeg.P(cont * pipe^-1)

	local ROW = vim.lpeg.Ct( init_cell * end_cell ^ 0 );

	local RESULT = ROW:match(line);
	local _o = {};
	local y = 0;

	for _, j in ipairs(RESULT or {}) do
		---|fS

		if j == "|" then
			table.insert(_o, {
				class = "separator",

				text = j,

				col_start = y,
				col_end = y + #j,
			});
		else
			table.insert(_o, {
				class = "column",

				text = j,

				col_start = y,
				col_end = y + #j,
			});
		end

		y = y + #j;

		---|fE
	end

	if #_o > 0 then
		---|fS
		if _o[1].class ~= "separator" then
			table.insert(_o, 1, {
				class = "missing_seperator",

				text = "|",

				col_start = 0,
				col_end = 0,
			});
		end

		if _o[#_o].class ~= "separator" then
			table.insert(_o, {
				class = "missing_seperator",

				text = "|",

				col_start = y,
				col_end = y,
			});
		end
		---|fE
	end

	return _o;

	---|fE
end

--- Lua_patterns-based parser for markdown table rows.
---@param line string
---@return table[]
local function lagecy_processor(line)
	---|fS

	local _o = {};
	local y = 0;

	line = line:gsub("^%s*", "");
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

	---|fE
end

--- Table parser.
---@param text string[]
---@param range markview.parsed.range
markdown.table = function (_, _, text, range)
	local header, separator, rows = {}, {}, {};
	local has_alignment_markers = false;
	local aligns = {};

	if text[1] and text[1]:match("^%s+") then
		range.col_start = range.col_start + text[1]:match("^%s+"):len();
	end

	--- Line processor.
	local function line_processor (line)
		if vim.lpeg then
			local succes, res = pcall(lpeg_processor, line);

			if succes == false then
				return lagecy_processor(line);
			else
				return res;
			end
		else
			return lagecy_processor(line);
		end
	end

	for l, line in ipairs(text) do
		local row_text = line;

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
					has_alignment_markers = true;
					table.insert(aligns, "center");
				elseif col:match("^%s*:") then
					has_alignment_markers = true;
					table.insert(aligns, "left");
				elseif col:match(":%s*$") then
					has_alignment_markers = true;
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

		top_border = top_border,
		bottom_border = true,
		border_overlap = border_overlap,

		alignments = aligns,
		has_alignment_markers = has_alignment_markers,

		header = header,
		separator = separator,
		rows = rows,

		text = text,
		range = range
	});
	table.insert(markdown.cache.table_ends, range.row_end);
end

--- Markdown parser.
---@param buffer integer
---@param TSTree table
---@param from integer?
---@param to integer?
---@return table[]
---@return table
markdown.parse = function (buffer, TSTree, from, to)
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
		((indented_code_block) @markdown.indented_code_block)

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
end

return markdown;
