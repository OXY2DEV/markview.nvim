local typst = {};
local utils = require("markview.utils");

typst.cache = {
	list_item_number = 0
};

--- Queried contents
---@type table[]
typst.content = {};

--- Queried contents, but sorted
typst.sorted = {}

typst.insert = function (data)
	table.insert(typst.content, data);

	if not typst.sorted[data.class] then
		typst.sorted[data.class] = {};
	end

	table.insert(typst.sorted[data.class], data);
end

--- Typst code parser.
---@param TSNode table
---@param text string[]
---@param range node.range
typst.code = function (buffer, TSNode, text, range)
	---+${func}
	local node = TSNode:parent();

	while node do
		if node:type() == "code" then
			--- If the node is inside another
			--- code node, skip it.
			return;
		end

		node = node:parent();
	end

	local from = vim.api.nvim_buf_get_lines(buffer, range.row_start, range.row_start + 1, false)[1]:sub(0, range.col_start);
	local to   = vim.api.nvim_buf_get_lines(buffer, range.row_end, range.row_end + 1, false)[1]:sub(range.col_end + 1);
	local inline = false;

	if from:match("^(.+)$") or to:match("^(.+)") then
		inline = true;
	end

	if inline == true then
		---@type __typst.code_spans
		typst.insert({
			class = "typst_code_span",

			text = text,
			range = range
		});
	else
		---@type __typst.code_block
		typst.insert({
			class = "typst_code_block",

			text = text,
			range = range
		});
	end
	---_
end

--- Typst emphasized text parser.
---@param TSNode table
---@param text string[]
---@param range node.range
typst.emphasis = function (_, TSNode, text, range)
	---+${lua}

	local _n = TSNode:parent();

	while _n do
		if vim.list_contains({ "raw_span", "raw_blck", "code", "field" }, _n:type()) then
			return;
		end

		_n = _n:parent();
	end

	---@type __typst.emphasis
	typst.insert({
		class = "typst_emphasis",

		text = text,
		range = range
	});
	---_
end

--- Typst escaped character parser.
---@param TSNode table
---@param text string[]
---@param range node.range
typst.escaped = function (_, TSNode, text, range)
	---+${func}

	local node = TSNode:parent();

	while node do
		if node:type() == "code" then
			return;
		end

		node = node:parent();
	end

	---@type __typst.escapes
	typst.insert({
		class = "typst_escaped",

		text = text,
		range = range
	});
	---_
end

--- Typst heading parser.
---@param text string[]
---@param range node.range
typst.heading = function (_, _, text, range)
	---+${func}

	local level = text[1]:match("^(%=+)"):len();

	---@type __typst.headings
	typst.insert({
		class = "typst_heading",
		level = level,

		text = text,
		range = range
	});
	---_
end

--- Typst label parser.
---@param text string[]
---@param range node.range
typst.label = function (_, _, text, range)
	---+${lua}

	---@type __typst.labels
	typst.insert({
		class = "typst_label",

		text = text,
		range = range
	});
	---_
end

--- Typst list item parser.
---@param buffer integer
---@param TSNode table
---@param text string[]
---@param range node.range
typst.list_item = function (buffer, TSNode, text, range)
	---+${func}
	local line = vim.api.nvim_buf_get_lines(buffer, range.row_start, range.row_start + 1, false)[1]:sub(0, range.col_start);
	local marker = text[1]:match("^([%-%+])") or text[1]:match("^(%d+%.)");
	local number;

	if marker == "+" then
		local prev_item = TSNode:prev_sibling();
		local item_text = prev_item and vim.treesitter.get_node_text(prev_item, buffer) or "";

		if
			not prev_item or
			(
				prev_item:type() == "item" and
				item_text:match("^(%+)")
			)
		then
			typst.cache.list_item_number = typst.cache.list_item_number + 1;
		else
			typst.cache.list_item_number = 1;
		end

		number = typst.cache.list_item_number;
	end

	local row_end = range.row_start - 1;

	for l, ln in ipairs(text) do
		if l ~= 1 and ( ln:match("^%s*([%+%-])") or ln:match("^%s*(%d)%.") ) then
			break
		end

		row_end = row_end + 1;
	end

	range.row_end = row_end;

	---@type __typst.list_items
	typst.insert({
		class = "typst_list_item",
		indent = line:match("(%s*)$"):len(),
		marker = marker,
		number = number,

		text = text,
		range = range
	});
	---_
end

--- Typst list item parser.
---@param buffer integer
---@param text string[]
---@param range node.range
typst.math = function (buffer, _, text, range)
	---+${func}

	local from, to = vim.api.nvim_buf_get_lines(buffer, range.row_start, range.row_start + 1, false)[1]:sub(0, range.col_start), vim.api.nvim_buf_get_lines(buffer, range.row_end, range.row_end + 1, true)[1]:sub(0, range.col_end);
	local inline = false;

	if from:match("^(%s*)$") == nil then
		inline = true;
	elseif to:match("^(%s*)%$$") == nil then
		inline = true;
	elseif text[1]:match("%$$") == nil then
		inline = true;
	end

	---@type __typst.maths
	typst.insert({
		class = inline == true and "typst_math_span" or "typst_math_block",

		text = text,
		range = range
	});
	---_
end

--- Typst url links parser.
---@param text string[]
---@param range inline_link.range
typst.link_url = function (_, _, text, range)
	---+${lua}

	range.label = { range.row_start, range.col_start, range.row_end, range.col_end }

	---@type __typst.url_links
	typst.insert({
		class = "typst_link_url",
		label = text[1],

		text = text,
		range = range
	});
	---_
end

--- Typst reference link parser.
---@param text string[]
---@param range inline_link.range
typst.link_ref = function (_, _, text, range)
	---+${lua}

	range.label = { range.row_start, range.col_start + 1, range.row_end, range.col_end };

	---@type __typst.reference_links
	typst.insert({
		class = "typst_link_ref",
		label = text[1]:gsub("^%@", ""),

		text = text,
		range = range
	});
	---_
end

--- Typst code block parser.
---@param buffer integer
---@param TSNode table
---@param text string[]
---@param range node.range
typst.raw_block = function (buffer, TSNode, text, range)
	---+${func}

	local lang_node = TSNode:field("lang")[1];
	local language;

	if lang_node then
		language = vim.treesitter.get_node_text(lang_node, buffer);
	end

	for l, line in ipairs(text) do
		if l == 1 then goto continue; end
		text[l] = line:sub(range.col_start + 1);
	    ::continue::
	end

	---@type __typst.raw_blocks
	typst.insert({
		class = "typst_raw_block",
		language = language,

		text = text,
		range = range
	});
	---_
end

--- Typst inline code parser.
---@param text string[]
---@param range node.range
typst.raw_span = function (_, _, text, range)
	---+${lua}

	---@type __typst.raw_spans
	typst.insert({
		class = "typst_raw_span",

		text = text,
		range = range
	});
	---_
end

--- Typst strong text parser.
---@param TSNode table
---@param text string[]
---@param range node.range
typst.strong = function (_, TSNode, text, range)
	---+${lua}

	local _n = TSNode:parent();

	while _n do
		if vim.list_contains({ "raw_span", "raw_blck", "code", "field" }, _n:type()) then
			return;
		end

		_n = _n:parent();
	end

	---@type __typst.strong
	typst.insert({
		class = "typst_strong",

		text = text,
		range = range
	});
	---_
end

--- Typst subscript parser.
---@param TSNode table
---@param text string[]
---@param range node.range
typst.subscript = function (_, TSNode, text, range)
	---+${func}
	local par = TSNode:type() == "group";
	local lvl = 0;

	local _n = TSNode;

	while _n do
		if _n:field("sub")[1] then
			lvl = lvl + 1;
		end

		_n = _n:parent();
	end

	range.col_start = range.col_start - 1;

	---@type __typst.subscripts
	typst.insert({
		class = "typst_subscript",
		parenthesis = par,

		level = lvl,

		text = text,
		range = range
	});
	---_
end


--- Typst superscript parser.
---@param TSNode table
---@param text string[]
---@param range node.range
typst.superscript = function (_, TSNode, text, range)
	---+${func}
	local par = TSNode:type() == "group";
	local lvl = 0;
	local pre = true;

	local _n = TSNode;

	while _n do
		if _n:field("sup")[1] then
			lvl = lvl + 1;
		end

		_n = _n:parent();
	end

	range.col_start = range.col_start - 1;

	---@type __typst.superscripts
	typst.insert({
		class = "typst_superscript",
		parenthesis = par,

		preview = pre,
		level = lvl,

		text = text,
		range = range
	});
	---_
end

--- Typst symbol parser.
---@param TSNode table
---@param text string[]
---@param range node.range
typst.symbol = function (_, TSNode, text, range)
	---+${func}
	for _, line in ipairs(text) do
		if not line:match("^[%a%.]+$") then
			return;
		end
	end

	local _n = TSNode:parent();
	local style;

	while _n do
		if vim.list_contains({ "raw_span", "raw_blck", "code", "field" }, _n:type()) then
			return;
		elseif vim.list_contains({ "sub", "sup" }, _n:type()) then
		end

		_n = _n:parent();
	end

	typst.insert({
		class = "typst_symbol",
		name = text[1],

		text = text,
		range = range
	});
	---_
end

--- Typst code block parser.
---@param buffer integer
---@param TSNode table
---@param text string[]
---@param range inline_link.range
typst.term = function (buffer, TSNode, text, range)
	---+${lua}

	if TSNode:field("term")[1] == nil then
		return;
	end

	for l, line in ipairs(text) do
		if l == 1 then
			goto continue;
		end

		text[l] = line:sub(range.col_start + 1);
	    ::continue::
	end

	range.label = { TSNode:field("term")[1]:range() };

	---@type __typst.terms
	typst.insert({
		class = "typst_term",
		label = vim.treesitter.get_node_text(
			TSNode:field("term")[1],
			buffer
		),

		text = text,
		range = range
	});
	---_
end

--- Typst regular text parser.
---@param text string[]
---@param range node.range
typst.text = function (_, _, text, range)
	---+${lua}

	---@type __typst.text
	typst.insert({
		class = "typst_text",

		text = text,
		range = range
	});
	---_
end

--- Typst single word symbol parser.
---@param TSNode table
---@param text string[]
---@param range node.range
typst.idet = function (_, TSNode, text, range)
	---+${funx}
	local symbols = require("markview.symbols");
	if not symbols.typst_entries[text[1]] then return; end

	local _n = TSNode:parent();

	while _n do
		if vim.list_contains({ "raw_span", "raw_blck", "code", "field" }, _n:type()) then
			return;
		end

		_n = _n:parent();
	end

	---@type __typst.symbols
	typst.insert({
		class = "typst_symbol",
		name = text[1],

		text = text,
		range = range
	});
	---_
end

--- Parser for typst.
---@param buffer integer
---@param TSTree table
---@param from integer?
---@param to integer?
---@return table[]
---@return table
typst.parse = function (buffer, TSTree, from, to)
	---+${lua}

	typst.cache = {
		list_item_number = 0
	};

	-- Clear the previous contents
	typst.sorted = {};
	typst.content = {};

	local scanned_queries = vim.treesitter.query.parse("typst", [[
		((attach
			sub: (_) @typst.subscript))

		((attach
			sup: (_) @typst.superscript))

		((field) @typst.symbol)

		([
			(number)
			(symbol)
			(letter)
			] @typst.text)

		((ident) @typst.idet)

		((heading) @typst.heading)
		((escape) @typst.escaped)
		((item) @typst.list_item)

		((code) @typst.code)
		((math) @typst.math)

		((url) @typst.link_url)

		((strong) @typst.strong)
		((emph) @typst.emphasis)
		((raw_span) @typst.raw_span)
		((raw_blck) @typst.raw_block)

		((label) @typst.label)
		((ref) @typst.link_ref)
		((term) @typst.term)
	]]);

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TSTree:root(), buffer, from, to) do
		local capture_name = scanned_queries.captures[capture_id];

		if not capture_name:match("^typst%.") then
			goto continue
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

		local success, error = pcall(
			typst[capture_name:gsub("^typst%.", "")],

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

	return typst.content, typst.sorted;
	---_
end

return typst;
