--- HTML parser for `markview.nvim`
local latex = {};
local utils = require("markview.utils")

--- `string.gsub()` with support for multiple patterns.
---@param text string
---@param gsubs string[]
---@return string
local function bulk_gsub (text, gsubs)
	local _o = text or "";

	for _, g in ipairs(gsubs) do
		_o = _o:gsub(vim.pesc(g), "");
	end

	return _o;
end

--- Checks if the given node is inside of `\text{}`.
---@param TSNode table
---@return boolean
local function within_text_mode(TSNode)
	while TSNode do
		if TSNode:type() == "text_mode" then
			return true;
		end

		TSNode = TSNode:parent();
	end

	return false;
end

--- Queried content.
---@type table[]
latex.content = {};

--- Sorted queried content.
---@type { [string]: table[] }
latex.sorted = {};

--- Custom `table.insert()` function.
---@param data any
latex.insert = function (data)
	table.insert(latex.content, data);

	if not latex.sorted[data.class] then
		latex.sorted[data.class] = {};
	end

	table.insert(latex.sorted[data.class], data);
end

--- LaTeX block parser.
---@param buffer integer
---@param text string[]
---@param range markview.parsed.range
latex.block = function (buffer, TSNode, text, range)
	local parent = TSNode:parent();

	while parent do
		if vim.list_contains({ "displayed_equation", "inline_formula" }, parent:type()) then
			break;
		end

		parent = parent:parent();
	end

	local from = vim.api.nvim_buf_get_lines(buffer, range.row_start, range.row_start + 1, false)[1]:sub(0, range.col_start);
	local to   = vim.api.nvim_buf_get_lines(buffer, range.row_end, range.row_end + 1, true)[1]:sub(range.col_end + 1);
	local inline = false;

	if text[1]:match("^%\\%[") then
		if from:len() > 1 and from:match("[^%s]") then
			-- Non-whitespace character before \[.
			inline = true;
		elseif text[1]:match("^%\\%[.+") then
			-- Text after \[.
			inline = true;
		elseif to:len() > 1 and to:match("[^%s]") then
			-- Non-whitespace character after \].
			inline = true;
		elseif text[#text]:match("[^%s]+%\\%]$") then
			-- Text before \].
			inline = true;
		end
	elseif text[1]:match("%$%$") then
		if from:len() > 1 and from:match("[^%s]") then
			-- Non-whitespace before $$.
			inline = true;
		elseif text[1]:match("^%$%$.+") then
			-- Text after starting $$.
			inline = true;
		elseif to:len() > 1 and to:match("[^%s]") then
			-- Non-whitespace character after closing $$.
			inline = true;
		elseif text[#text]:match("[^%s]+%$%$$") then
			-- Text before closing $$.
			inline = true;
		end
	else
		return;
	end

	if parent and inline then
		return;
	end

	---@class __latex.blocks
	latex.insert({
		class = inline == true and "latex_inline" or "latex_block",
		marker = "$$",

		text = text,
		range = range
	});
end

--- LaTeX command parser.
---@param buffer integer
---@param TSNode table
---@param text string[]
---@param range markview.parsed.range
latex.command = function (buffer, TSNode, text, range)
	local args = {};
	local nodes = TSNode:field("arg");

	local command_node = TSNode:field("command")[1];
	local command_name = vim.treesitter.get_node_text(command_node, buffer);

	if within_text_mode(TSNode) then
		return;
	elseif
		command_name:len() == 2 or
		command_name:match("^\\math")
	then
		return;
	end

	for _, arg in ipairs(nodes) do
		table.insert(args, {
			text = vim.treesitter.get_node_text(arg, buffer),
			range = { arg:range() }
		});
	end

	latex.insert({
		class = "latex_command",

		command = {
			name = (command_name or ""):sub(2),
			range = command_node and { command_node:range() }
		},
		args = args,

		text = text,
		range = range
	});
end

--- LaTeX escaped character parser.
---@param TSNode table
---@param text string[]
---@param range markview.parsed.range
latex.escaped = function (_, TSNode, text, range)
	if within_text_mode(TSNode) then
		return;
	end

	latex.insert({
		class = "latex_escaped",

		text = text,
		range = range
	});
end

--- LaTeX font parser.
---@param TSNode table
---@param text string[]
---@param range markview.parsed.latex.fonts.range
latex.font = function (buffer, TSNode, text, range)
	if within_text_mode(TSNode) then
		return;
	end

	local cmd = TSNode:field("command")[1];

	if cmd == nil then
		return;
	end

	range.font = { cmd:range() };

	---@class __latex.fonts
	latex.insert({
		class = "latex_font",
		name = vim.treesitter.get_node_text(cmd, buffer):gsub("\\", ""),

		text = text,
		range = range
	});
end

--- Inline LaTeX parser.
---@param text string[]
---@param range markview.parsed.range
latex.inline = function (buffer, TSNode, text, range)
	local parent = TSNode:parent();

	while parent do
		if vim.list_contains({ "displayed_equation", "inline_formula" }, parent:type()) then
			break;
		end

		parent = parent:parent();
	end

	local from = vim.api.nvim_buf_get_lines(buffer, range.row_start, range.row_start + 1, false)[1]:sub(0, range.col_start);
	local to   = vim.api.nvim_buf_get_lines(buffer, range.row_end, range.row_end + 1, true)[1]:sub(range.col_end + 1);
	local inline = false;

	local marker;

	if text[1]:match("^%\\%(") then
		marker = "\\(";

		if from:len() > 1 and from:match("[^%s]") then
			-- Non-whitespace character before \(.
			inline = true;
		elseif text[1]:match("^%\\%(.+") then
			-- Text after \(.
			inline = true;
		elseif to:len() > 1 and to:match("[^%s]") then
			-- Non-whitespace character after \).
			inline = true;
		elseif text[#text]:match("[^%s]+%\\%)$") then
			-- Text before \).
			inline = true;
		end
	elseif text[1]:match("^%$") then
		marker = "$";

		if from:len() > 1 and from:match("[^%s]") then
			-- Non-whitespace before $$.
			inline = true;
		elseif text[1]:match("^%$.+") then
			-- Text after starting $$.
			inline = true;
		elseif to:len() > 1 and to:match("[^%s]") then
			-- Non-whitespace character after closing $$.
			inline = true;
		elseif text[#text]:match("[^%s]+%$$") then
			-- Text before closing $$.
			inline = true;
		end
	else
		return;
	end

	if parent and inline then
		return;
	end

	latex.insert({
		class = inline == true and "latex_inline" or "latex_block",
		marker = marker,

		text = text,
		range = range
	});
end

--- {} parser.
---@param buffer integer
---@param text string[]
---@param range markview.parsed.range
latex.parenthesis = function (buffer, TSNode, text, range)
	if within_text_mode(TSNode) then
		return;
	end

	local line = vim.api.nvim_buf_get_lines(buffer, range.row_start, range.row_start + 1, false)[1];
	local before = line:sub(0, range.col_start);

	if before:match("%^$") or before:match("%_$") then
		return;
	elseif before:match("%\\(%a+)$") or before:match("%}%s*$") then
		return;
	end

	latex.insert({
		class = "latex_parenthesis",

		text = text,
		range = range
	});
end

--- Subscript parser.
---@param TSNode table
---@param text string[]
---@param range markview.parsed.range
latex.subscript = function (_, TSNode, text, range)
	local node = TSNode;
	local level, preview = 0, true;

	local supported_symbols = {
		"\\beta",
		"\\gamma",
		"\\rho",
		"\\phi",
		"\\chi",

		-- See OZU2DEV/markview#379
		"\\epsilon",
		"\\omicron",
		"\\alpha",
		"\\eta",
		"\\nu",
		"\\rho",
		"\\upsilon",
		"\\sigma",
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
		parenthesis = text[1]:match("^%_%{") ~= nil,

		preview = preview,
		level = level,

		text = text,
		range = range
	});
end

--- Superscript parser.
---@param TSNode table
---@param text string[]
---@param range markview.parsed.range
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
		"\\chi",

		-- See OZU2DEV/markview#379
		"\\omicron",
		"\\eta",
		"\\nu",
		"\\rho",
		"\\upsilon",
		"\\sigma",
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
		parenthesis = text[1]:match("^%^%{") ~= nil,

		preview = preview,
		level = level,

		text = text,
		range = range
	});
end

--- Symbol parser.
---@param TSNode table
---@param text string[]
---@param range markview.parsed.range
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
	});
end

--- Text mode parser.
---@param text string[]
---@param range markview.parsed.range
latex.text = function (_, _, text, range)
	latex.insert({
		class = "latex_text",

		text = text,
		range = range
	});
end

--- Word parser.
---@param TSNode table
---@param text string[]
---@param range markview.parsed.range
latex.word = function (_, TSNode, text, range)
	if within_text_mode(TSNode) then
		return;
	end

	latex.insert({
		class = "latex_word",
		text = text,
		range = range
	});
end

--- LaTeX parser function.
---@param buffer integer
---@param TSTree table
---@param from integer?
---@param to integer?
---@return table[]
---@return table
latex.parse = function (buffer, TSTree, from, to)
	--- Clear the previous contents
	latex.sorted = {};
	latex.content = {};

	local scanned_queries = vim.treesitter.query.parse("latex", [[
		((curly_group) @latex.parenthesis)

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
		---@type string
		local capture_name = scanned_queries.captures[capture_id];

		--- Capture groups used internally.
		--- Do not parse them.
		if not capture_name:match("^latex%.") then
			goto continue
		end

		---@type string?
		local capture_text = vim.treesitter.get_node_text(capture_node, buffer);
		local r_start, c_start, r_end, c_end = capture_node:range();

		if capture_text == nil then
			goto continue;
		end

		--- If a node doesn't end with \n, Add it.
		if not capture_text:match("\n$") then
			capture_text = capture_text .. "\n";
		end

		--- Turn the texts into list of lines.
		---@type string[]
		local lines = {};

		for line in capture_text:gmatch("(.-)\n") do
			table.insert(lines, line);
		end

		---@type boolean, string
		local success, error = pcall(
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

		if success == false then
			require("markview.health").notify("trace", {
				level = 4,
				message = error
			});
		end

		::continue::
	end

	return latex.content, latex.sorted;
end

return latex;
