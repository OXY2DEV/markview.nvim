local typst = {};

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
---@param range markview.parsed.range
typst.code = function (buffer, TSNode, text, range)
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
		typst.insert({
			class = "typst_code_span",

			text = text,
			range = range
		});
	else
		local uses_tab = false;

		for _, line in ipairs(text) do
			if string.match(line, "\t") then
				uses_tab = true;
				break;
			end
		end

		typst.insert({
			class = "typst_code_block",

			uses_tab = uses_tab,

			text = text,
			range = range
		});
	end
end

--- Typst emphasized text parser.
---@param TSNode table
---@param text string[]
---@param range markview.parsed.range
typst.emphasis = function (_, TSNode, text, range)
	local _n = TSNode:parent();

	while _n do
		if vim.list_contains({ "raw_span", "raw_blck", "code", "field" }, _n:type()) then
			return;
		end

		_n = _n:parent();
	end

	typst.insert({
		class = "typst_emphasis",

		text = text,
		range = range
	});
end

--- Typst escaped character parser.
---@param TSNode table
---@param text string[]
---@param range markview.parsed.range
typst.escaped = function (_, TSNode, text, range)
	local node = TSNode:parent();

	while node do
		if node:type() == "code" then
			return;
		end

		node = node:parent();
	end

	typst.insert({
		class = "typst_escaped",

		text = text,
		range = range
	});
end

--- Typst heading parser.
---@param text string[]
---@param range markview.parsed.range
typst.heading = function (_, _, text, range)
	local level = text[1]:match("^(%=+)"):len();

	typst.insert({
		class = "typst_heading",
		level = level,

		text = text,
		range = range
	});
end

--- Typst label parser.
---@param text string[]
---@param range markview.parsed.range
typst.label = function (_, _, text, range)
	typst.insert({
		class = "typst_label",

		text = text,
		range = range
	});
end

--- Typst list item parser.
---@param buffer integer
---@param TSNode table
---@param text string[]
---@param range markview.parsed.range
typst.list_item = function (buffer, TSNode, text, range)
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

	typst.insert({
		class = "typst_list_item",
		indent = line:match("(%s*)$"):len(),
		marker = marker,
		number = number,

		text = text,
		range = range
	});
end

--- Typst list item parser.
---@param buffer integer
---@param text string[]
---@param range markview.parsed.range
typst.math = function (buffer, _, text, range)
	local from, to = vim.api.nvim_buf_get_lines(buffer, range.row_start, range.row_start + 1, false)[1]:sub(0, range.col_start), vim.api.nvim_buf_get_lines(buffer, range.row_end, range.row_end + 1, true)[1]:sub(0, range.col_end);
	local inline = false;

	if from:match("^(%s*)$") == nil then
		inline = true;
	elseif to:match("^(%s*)%$$") == nil then
		inline = true;
	elseif text[1]:match("%$$") == nil then
		inline = true;
	end

	typst.insert({
		class = inline == true and "typst_math_span" or "typst_math_block",

		text = text,
		range = range
	});
end

--- Typst url links parser.
---@param text string[]
---@param range markview.parsed.typst.url_links.range
typst.link_url = function (_, _, text, range)
	range.label = { range.row_start, range.col_start, range.row_end, range.col_end }

	typst.insert({
		class = "typst_link_url",
		label = text[1],

		text = text,
		range = range
	});
end

--- Typst reference link parser.
---@param text string[]
---@param range markview.parsed.typst.reference_links.range
typst.link_ref = function (_, _, text, range)
	range.label = { range.row_start, range.col_start + 1, range.row_end, range.col_end };

	typst.insert({
		class = "typst_link_ref",
		label = text[1]:gsub("^%@", ""),

		text = text,
		range = range
	});
end

--- Typst code block parser.
---@param buffer integer
---@param TSNode table
---@param text string[]
---@param range markview.parsed.range
typst.raw_block = function (buffer, TSNode, text, range)
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

	typst.insert({
		class = "typst_raw_block",
		language = language,

		text = text,
		range = range
	});
end

--- Typst inline code parser.
---@param text string[]
---@param range markview.parsed.range
typst.raw_span = function (_, _, text, range)
	typst.insert({
		class = "typst_raw_span",

		text = text,
		range = range
	});
end

--- Typst strong text parser.
---@param TSNode table
---@param text string[]
---@param range markview.parsed.range
typst.strong = function (_, TSNode, text, range)
	local _n = TSNode:parent();

	while _n do
		if vim.list_contains({ "raw_span", "raw_blck", "code", "field" }, _n:type()) then
			return;
		end

		_n = _n:parent();
	end

	typst.insert({
		class = "typst_strong",

		text = text,
		range = range
	});
end

--- Typst subscript parser.
---@param TSNode table
---@param text string[]
---@param range markview.parsed.range
typst.subscript = function (_, TSNode, text, range)
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

	typst.insert({
		class = "typst_subscript",
		parenthesis = par,

		level = lvl,

		text = text,
		range = range
	});
end


--- Typst superscript parser.
---@param TSNode table
---@param text string[]
---@param range markview.parsed.range
typst.superscript = function (_, TSNode, text, range)
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

	typst.insert({
		class = "typst_superscript",
		parenthesis = par,

		preview = pre,
		level = lvl,

		text = text,
		range = range
	});
end

--- Typst symbol parser.
---@param TSNode table
---@param text string[]
---@param range markview.parsed.range
typst.symbol = function (_, TSNode, text, range)
	for _, line in ipairs(text) do
		if not line:match("^[%a%.]+$") then
			return;
		end
	end

	local _n = TSNode:parent();

	while _n do
		if vim.list_contains({ "raw_span", "raw_blck", "code", "field" }, _n:type()) then
			return;
		end

		_n = _n:parent();
	end

	typst.insert({
		class = "typst_symbol",
		name = text[1],

		text = text,
		range = range
	});
end

--- Typst code block parser.
---@param buffer integer
---@param TSNode table
---@param text string[]
---@param range markview.parsed.typst.terms.range
typst.term = function (buffer, TSNode, text, range)
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

	typst.insert({
		class = "typst_term",
		label = vim.treesitter.get_node_text(
			TSNode:field("term")[1],
			buffer
		),

		text = text,
		range = range
	});
end

--- Typst regular text parser.
---@param text string[]
---@param range markview.parsed.range
typst.text = function (_, _, text, range)
	typst.insert({
		class = "typst_text",

		text = text,
		range = range
	});
end

--- Typst single word symbol parser.
---@param TSNode table
---@param text string[]
---@param range markview.parsed.range
typst.idet = function (_, TSNode, text, range)
	local symbols = require("markview.symbols");
	if not symbols.typst_entries[text[1]] then return; end

	local _n = TSNode:parent();

	while _n do
		if vim.list_contains({ "raw_span", "raw_blck", "code", "field" }, _n:type()) then
			return;
		end

		_n = _n:parent();
	end

	typst.insert({
		class = "typst_symbol",
		name = text[1],

		text = text,
		range = range
	});
end

--- Parser for typst.
---@param buffer integer
---@param TSTree table
---@param from integer?
---@param to integer?
---@return markview.parsed.typst[]
---@return markview.parsed.typst_sorted
typst.parse = function (buffer, TSTree, from, to)
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

		local success, err = pcall(
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
			require("markview.health").print({
				kind = "ERR",

				from = "parsers/typst.lua",
				fn = "parse()",

				message = {
					{ tostring(err), "DiagnosticError" }
				}
			});
		end

	    ::continue::
	end

	return typst.content, typst.sorted;
end

return typst;
