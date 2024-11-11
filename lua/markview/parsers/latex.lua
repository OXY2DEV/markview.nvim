--- HTML parser for `markview.nvim`
local latex = {};

local utils = require("markview.utils")

local function bulk_gsub (text, gsubs)
	local _o = text or "";

	for _, g in ipairs(gsubs) do
		g = utils.escape_string(g);
		_o = _o:gsub(g, "");
	end

	return _o;
end

local function within_text_mode(TSNode)
	while TSNode do
		if TSNode:type() == "text_mode" then
			return true;
		end

		TSNode = TSNode:parent();
	end

	return false;
end

--- Queried contents
---@type table[]
latex.content = {};

--- Queried contents, but sorted
latex.sorted = {}

latex.insert = function (data)
	table.insert(latex.content, data);

	if not latex.sorted[data.class] then
		latex.sorted[data.class] = {};
	end

	table.insert(latex.sorted[data.class], data);
end

---@type markview.parsers.function
latex.parenthasis = function (buffer, TSNode, text, range)
	local line = vim.api.nvim_buf_get_lines(buffer, range.row_start, range.row_start + 1, false)[1];
	local before = line:sub(0, range.col_start);

	if within_text_mode(TSNode) then return; end

	if before:match("%^$") or before:match("%_$") then
		return;
	elseif before:match("%\\(%a+)$") or before:match("%}%s*$") then
		return;
	end

	latex.insert({
		class = "latex_bracket",

		text = text,

		range = range
	})
end

---@type markview.parsers.function
latex.escaped = function (_, TSNode, text, range)
	if within_text_mode(TSNode) then return; end

	latex.insert({
		class = "latex_escaped",

		text = text,

		range = range
	})
end

---@type markview.parsers.function
latex.symbol = function (_, TSNode, text, range)
	local node = TSNode;
	local style;

	while node do
		if node:type() == "text_mode" then
			return;
		elseif vim.list_contains({ "subscript", "superscript" }, node:type()) then
			style = node:type() .. "s";
			break;
		end

		node = node:parent();
	end

	latex.insert({
		class = "latex_symbol",
		name = text[1]:sub(2),
		style = style,

		text = text,

		range = range
	})
end

---@type markview.parsers.function
latex.command = function (buffer, TSNode, text, range)
	local args = {};
	local nodes = TSNode:field("arg");
	local command = text[1]:match("^\\([^%{%s]+)");

	if within_text_mode(TSNode) then return; end

	for _, arg in ipairs(nodes) do
		table.insert(args, {
			text = vim.treesitter.get_node_text(arg, buffer),
			range = { arg:range() }
		});
	end

	latex.insert({
		class = "latex_command",

		text = text,
		command = command,
		args = args,

		range = range
	})
end

---@type markview.parsers.function
latex.block = function (buffer, _, text, range)
	local from, to = vim.api.nvim_buf_get_lines(buffer, range.row_start, range.row_start + 1, false)[1]:sub(0, range.col_start), vim.api.nvim_buf_get_lines(buffer, range.row_end, range.row_end + 1, true)[1]:sub(0, range.col_end);
	local inline, closed = false, true;

	if
		not from:match("^(%s*)$") or not to:match("^(%s*)%$%$$")
	then
		inline = true;
	elseif
		not text[1]:match("%$%$$")
	then
		inline = true;
	end

	if not text[#text]:match("%$%$$") then
		closed = false;
	end

	latex.insert({
		class = "latex_block",
		inline = inline,
		closed = closed,

		text = text,

		range = range
	})
end

---@type markview.parsers.function
latex.inline = function (_, _, text, range)
	local closed = true;

	if not text[#text]:match("%$$") then
		closed = false;
	end

	latex.insert({
		class = "latex_inline",
		closed = closed,

		text = text,

		range = range
	})
end

---@type markview.parsers.function
latex.superscript = function (_, TSNode, text, range)
	local node = TSNode;
	local level, preview = 0, true;

	local supported_symbols = {
		"\\alpha",
		"\\beta",
		"\\gamma",
		"\\delta",
		"\\epsilon",
		"\\theta",
		"\\iota",
		"\\Phi",
		"\\varphi",
		"\\chi"
	}

	for _, line in ipairs(text) do
		if bulk_gsub(line, supported_symbols):match("%\\") then
			preview = false;
			break;
		end
	end

	while node do
		if node:type() == "text_mode" then
			return;
		elseif node:type() == "superscript" then
			level = level + 1;
		end

		node = node:parent();
	end

	latex.insert({
		class = "latex_superscript",
		parenthasis = text[1]:match("^%^%{") ~= nil,

		preview = preview,
		level = level,

		text = text,

		range = range
	})
end

---@type markview.parsers.function
latex.subscript = function (_, TSNode, text, range)
	local node = TSNode;
	local level, preview = 0, true;

	local supported_symbols = {
		"\\beta",
		"\\gamma",
		"\\rho",
		"\\epsilon",
		"\\chi"
	}

	for _, line in ipairs(text) do
		if bulk_gsub(line, supported_symbols):match("%\\") then
			preview = false;
			break;
		end
	end

	while node do
		if node:type() == "text_mode" then
			return;
		elseif node:type() == "subscript" then
			level = level + 1;
		end

		node = node:parent();
	end

	latex.insert({
		class = "latex_subscript",
		parenthasis = text[1]:match("^%_%{") ~= nil,

		preview = preview,
		level = level,

		text = text,

		range = range
	})
end

---@type markview.parsers.function
latex.text = function (buffer, TSNode, text, range)
	latex.insert({
		class = "latex_text",

		text = text,

		range = range
	})
end

---@type markview.parsers.function
latex.font = function (buffer, TSNode, text, range)
	local cmd = TSNode:field("command")[1];
	if within_text_mode(TSNode) then return; end

	if not cmd then
		return;
	end

	_, range.font_start, _, range.font_end = cmd:range();

	latex.insert({
		class = "latex_font",
		name = vim.treesitter.get_node_text(cmd, buffer):gsub("\\", ""),

		text = text,

		range = range
	})
end

---@type markview.parsers.function
latex.word = function (_, TSNode, text, range)
	if within_text_mode(TSNode) then return; end

	latex.insert({
		class = "latex_word",
		text = text,
		range = range
	})
end

latex.parse = function (buffer, TSTree, from, to)
	-- Clear the previous contents
	latex.sorted = {};
	latex.content = {};

	local scanned_queries = vim.treesitter.query.parse("latex", [[
		((curly_group) @latex.parenthasis)

		([(operator) (word)] @latex.word
			(#match? @latex.word "^[^\\\\]+$"))

		((generic_command
			.
			command: (
				((command_name) @escaped.name)
				(#match? @escaped.name "^\\\\.$")
			)
			.
			) @latex.escaped)

		((generic_command
			.
			command: (
				((command_name) @symbol.name)
				(#match? @symbol.name "^\\\\[a-zA-Z]+$")
			)
			.
			) @latex.symbol)

		((generic_command
			.
			command: (command_name)
			(curly_group)+
			) @latex.command)

		((generic_command
			.
			command: (
				(command_name) @font.cmd
				(#match? @font.cmd "^\\\\math")
			)
			arg: (curly_group)
			.
			) @latex.font)

		((displayed_equation) @latex.block)

		((inline_formula) @latex.inline)

		((text_mode) @latex.text)

		((superscript) @latex.superscript)

		((subscript) @latex.subscript)
	]]);

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TSTree:root(), buffer, from, to) do
		local capture_name = scanned_queries.captures[capture_id];
		local r_start, c_start, r_end, c_end = capture_node:range();

		if not capture_name:match("^latex%.") then
			goto continue
		end

		local capture_text = vim.treesitter.get_node_text(capture_node, buffer);

		if not capture_text:match("\n$") then
			capture_text = capture_text .. "\n";
		end

		local lines = {};

		for line in capture_text:gmatch("(.-)\n") do
			table.insert(lines, line);
		end

		pcall(
			latex[capture_name:gsub("^latex%.", "")],

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

		::continue::
	end

	return latex.content, latex.sorted;
end

return latex;
