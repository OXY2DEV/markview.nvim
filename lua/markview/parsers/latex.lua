--- HTML parser for `markview.nvim`
local latex = {};

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
	local conceal = false;

	if text[1]:match("^%{(%d*)%}$") or text[1]:match("^%{[%d%a]%}$") then
		conceal = true;
	end

	latex.insert({
		class = "latex_bracket",
		conceal = conceal,

		text = text,

		range = range
	})
end

---@type markview.parsers.function
latex.escaped = function (buffer, TSNode, text, range)
	latex.insert({
		class = "latex_escaped",

		text = text,

		range = range
	})
end

---@type markview.parsers.function
latex.symbol = function (buffer, TSNode, text, range)
	latex.insert({
		class = "latex_symbol",

		text = text,

		range = range
	})
end

---@type markview.parsers.function
latex.command = function (buffer, TSNode, text, range)
	local args = {};
	local nodes = TSNode:field("arg");
	local command = text[1]:match("^\\([^%{%s]+)");

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
latex.block = function (buffer, TSNode, text, range)
	latex.insert({
		class = "latex_block",

		text = text,

		range = range
	})
end

---@type markview.parsers.function
latex.inline = function (buffer, TSNode, text, range)
	latex.insert({
		class = "latex_inline",

		text = text,

		range = range
	})
end

---@type markview.parsers.function
latex.superscript = function (buffer, TSNode, text, range)
	latex.insert({
		class = "latex_superscript",

		text = text,

		range = range
	})
end

---@type markview.parsers.function
latex.subscript = function (buffer, TSNode, text, range)
	latex.insert({
		class = "latex_subscript",

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

	latex.insert({
		class = "latex_font",
		font = vim.treesitter.get_node_text(cmd, buffer):gsub("\\", ""),

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

		((generic_command
			.
			command: (
				((command_name) @escaped.name)
				(#match? @escaped.name "^\\.$")
			)
			.
			) @latex.escaped)

		((generic_command
			.
			command: (command_name)
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
				(#match? @font.cmd "^\\math")
			)
			arg: (curly_group)
			.
			) @latex.font)

		((displayed_equation) @latex.block)

		((inline_formula) @latex.inline)

		((text_mode) @latex.text)

		((superscript) @superscript)

		((subscript) @subscript)
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

		latex[capture_name:gsub("^latex%.", "")](buffer, capture_node, lines, {
			row_start = r_start,
			col_start = c_start,

			row_end = r_end,
			col_end = c_end
		});

	    ::continue::
	end

	return latex.content, latex.sorted;
end

return latex;
