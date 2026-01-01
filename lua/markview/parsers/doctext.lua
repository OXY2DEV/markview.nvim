--- HTML parser for `markview.nvim`.
local doctext = {};

--- Queried contents
---@type table[]
doctext.content = {};

--- Queried contents, but sorted
---@type { [string]: table }
doctext.sorted = {}

--- Wrapper for `table.insert()`.
---@param data table
doctext.insert = function (data)
	table.insert(doctext.content, data);

	if not doctext.sorted[data.class] then
		doctext.sorted[data.class] = {};
	end

	table.insert(doctext.sorted[data.class], data);
end

--- Tasks.
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.doctext.task.range
doctext.task = function (buffer, TSNode, text, range)
	local kind = TSNode:field("type")[1];

	for child in TSNode:iter_children() do
		if child:type() == ":" then
			_, _, range.label_row_end, range.label_col_end = child:range();
		end
	end

	if not kind then
		return;
	end

	range.kind = { kind:range(); };

	doctext.insert({
		class = "doctext_task",
		kind = vim.treesitter.get_node_text(kind, buffer, {}),

		text = text,
		range = range,
	});
end

--- Issue.
---@param text string[]
---@param range markview.parsed.range
doctext.issue = function (_, _, text, range)
	doctext.insert({
		class = "doctext_issue",

		text = text,
		range = range,
	});
end

--- Issue.
---@param text string[]
---@param range markview.parsed.range
doctext.mention = function (_, _, text, range)
	doctext.insert({
		class = "doctext_mention",

		text = text,
		range = range,
	});
end

--- HTML parser
---@param buffer integer
---@param TSTree table
---@param from integer?
---@param to integer?
---@return markview.parsed.doctext[]
---@return markview.parsed.doctext_sorted
doctext.parse = function (buffer, TSTree, from, to)
	-- Clear the previous contents
	doctext.sorted = {};
	doctext.content = {};

	local scanned_queries = vim.treesitter.query.parse("doctext", [[
		(task) @doctext.task

		(task_scope
			(_) @doctext.scope)

		(code_block) @doctext.code_block

		(double_quote) @doctext.double_quote
		(issue_reference) @doctext.issue
		(mention) @doctext.mention
		(url) @doctext.url
		(autolink) @doctext.autolink
		(taglink) @doctext.taglink

		(comment) @doctext.comment
	]]);

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TSTree:root(), buffer, from, to) do
		local capture_name = scanned_queries.captures[capture_id];

		if not capture_name:match("^doctext%.") then
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
			doctext[capture_name:gsub("^doctext%.", "")],

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

				from = "parsers/doctext.lua",
				fn = "parse()",

				message = {
					{ tostring(error), "DiagnosticError" }
				}
			});
		end

	    ::continue::
	end

	return doctext.content, doctext.sorted;
end

return doctext;

