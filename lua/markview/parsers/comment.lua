--- HTML parser for `markview.nvim`.
local comment = {};

--- Queried contents
---@type table[]
comment.content = {};

--- Queried contents, but sorted
---@type { [string]: table }
comment.sorted = {}

--- Wrapper for `table.insert()`.
---@param data table
comment.insert = function (data)
	table.insert(comment.content, data);

	if not comment.sorted[data.class] then
		comment.sorted[data.class] = {};
	end

	table.insert(comment.sorted[data.class], data);
end

--- Tasks.
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.comment.tasks.range
comment.task = function (buffer, TSNode, text, range)
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

	comment.insert({
		class = "comment_task",
		kind = vim.treesitter.get_node_text(kind, buffer, {}),

		text = text,
		range = range,
	});
end

--- Tasks(legacy parser).
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.comment.tasks.range
comment.tag = function (buffer, TSNode, text, range)
	local kind;

	for child in TSNode:iter_children() do
		if child:type() == "name" then
			kind = child;
			range.kind = { child:range() };

			range.label_row_end = range.row_start;
			range.label_col_end = range.kind[4] + 1; -- `:` is part of the label!
		elseif child:type() == "user" then
			local user_range = { child:range() };

			range.label_row_end = range.row_start;
			range.label_col_end = user_range[4] + 2; -- `:` is part of the label!

			-- Add special syntax support for scope text.
			comment.tag_scope(buffer, child, { vim.treesitter.get_node_text(child, buffer, {}) }, user_range);
		end
	end

	if not kind then
		return;
	end

	comment.insert({
		class = "comment_task",
		kind = vim.treesitter.get_node_text(kind, buffer, {}),

		text = text,
		range = range,
	});
end

--- Tasks scope parser(legacy parser).
---@param buffer integer
---@param _ TSNode
---@param text string[]
---@param root_range markview.parsed.comment.tasks.range
comment.tag_scope = function (buffer, _, text, root_range)
	local lpeg = vim.lpeg;

	local function as_wspace   (m) return { kind = "space", value = m }; end
	local function as_comma    (m) return { kind = "comma", value = m }; end

	local function as_issue   (m) return { kind = "issue", value = m }; end
	local function as_mention (m) return { kind = "mention", value = m }; end
	local function as_word    (m) return { kind = "word", value = m }; end

	local space = lpeg.C( lpeg.S(" \t\n\r") ) / as_wspace;
	local comma = lpeg.C( lpeg.P(",") ) / as_comma;

	local walnum = lpeg.R("az", "AZ", "09");
	local non_wspacse = 1 - ( space + comma );
	local word = lpeg.C( walnum * (non_wspacse^0) ) / as_word;

	local mention = lpeg.C( lpeg.P("@") * (non_wspacse^1) ) / as_mention;

	local num_issue = lpeg.C( lpeg.P("#") * ( lpeg.R("09") ^ 1 ) ) / as_issue;

	local invalid_cahrs = space + lpeg.P("#");
	local issue_name = lpeg.R("az", "AZ", "09") * (1 - invalid_cahrs)^0;
	local desc_issue = lpeg.C( issue_name * lpeg.P("#") * ( lpeg.R("09") ^ 1 ) ) / as_issue;

	local token = space + comma + desc_issue + num_issue + mention + word;
	local scope = lpeg.Ct(token^0);

	local col_start = root_range[2];

	for _, item in ipairs(lpeg.match(scope, text[1] or "")) do
		if item.kind == "word" then
			comment.task_scope(buffer, nil, { item.value }, {
				row_start = root_range[1],
				col_start = col_start,

				row_end = root_range[3],
				col_end = col_start + #item.value,
			});
		elseif item.kind == "issue" then
			comment.issue(buffer, nil, { item.value }, {
				row_start = root_range[1],
				col_start = col_start,

				row_end = root_range[3],
				col_end = col_start + #item.value,
			});
		elseif item.kind == "mention" then
			comment.mention(buffer, nil, { item.value }, {
				row_start = root_range[1],
				col_start = col_start,

				row_end = root_range[3],
				col_end = col_start + #item.value,
			});
		end

		col_start = col_start + #item.value;
	end
end

--- Issue.
---@param text string[]
---@param range markview.parsed.range
comment.task_scope = function (_, _, text, range)
	comment.insert({
		class = "comment_task_scope",

		text = text,
		range = range,
	});
end

--- Issue.
---@param text string[]
---@param range markview.parsed.range
comment.inline_code = function (_, _, text, range)
	comment.insert({
		class = "comment_inline_code",

		text = text,
		range = range,
	});
end

-- Issue.
---@param buffer integer
---@param TSNode TSNode
---@param text string[]
---@param range markview.parsed.comment.code_blocks.range
comment.code_block = function (buffer, TSNode, text, range)
	local uses_tab = false;

	local lang = TSNode:field("language")[1];
	local language;

	if lang then
		language = vim.treesitter.get_node_text(lang, buffer, {});
		range.language = { lang:range() };
	end

	for _, line in ipairs(text) do
		if string.match(line, "\t") then
			uses_tab = true;
			break;
		end
	end

	---@type TSNode, TSNode?
	local start_delim, end_delim;

	for child in TSNode:iter_children() do
		if child:type() == "start_delimiter" then
			start_delim = child;
			local delim = vim.treesitter.get_node_text(child, buffer, {});

			range.start_delim = { child:range() };
			range.start_delim[2] = range.start_delim[2] + #string.match(delim, "^%s*");
		elseif child:type() == "end_delimiter" then
			end_delim = child;
			local delim = vim.treesitter.get_node_text(child, buffer, {});

			range.end_delim = { child:range() };
			range.end_delim[2] = range.end_delim[2] + #string.match(delim, "^%s*");
		end
	end

	comment.insert({
		class = "comment_code_block",
		uses_tab = uses_tab,

		language = language,
		info_string = nil,
		delimiters = {
			start_delim and vim.treesitter.get_node_text(start_delim, buffer) or "",
			end_delim and vim.treesitter.get_node_text(end_delim, buffer) or "",
		},

		text = text,
		range = range,
	});
end

--- Issue.
---@param text string[]
---@param range markview.parsed.range
comment.issue = function (_, _, text, range)
	comment.insert({
		class = "comment_issue",

		text = text,
		range = range,
	});
end

--- Issue.
---@param text string[]
---@param range markview.parsed.range
comment.mention = function (_, _, text, range)
	comment.insert({
		class = "comment_mention",

		text = text,
		range = range,
	});
end

--- Issue.
---@param text string[]
---@param range markview.parsed.range
comment.url = function (_, _, text, range)
	comment.insert({
		class = "comment_url",
		destination = text[1] or "",

		text = text,
		range = range,
	});
end

--- Issue.
---@param text string[]
---@param range markview.parsed.range
comment.autolink = function (_, _, text, range)
	comment.insert({
		class = "comment_autolink",
		destination = string.gsub(text[1] or "", "^%<", ""):gsub("%>$", ""),

		text = text,
		range = range,
	});
end

--- Issue.
---@param text string[]
---@param range markview.parsed.range
comment.taglink = function (_, _, text, range)
	comment.insert({
		class = "comment_taglink",

		text = text,
		range = range,
	});
end

--- Comment parser
---@param buffer integer
---@param TSTree table
---@param from integer?
---@param to integer?
---@return markview.parsed.comment[]
---@return markview.parsed.comment_sorted
comment.parse = function (buffer, TSTree, from, to)
	-- Clear the previous contents
	comment.sorted = {};
	comment.content = {};

	local scanned_queries;

	if pcall(vim.treesitter.query.parse, "comment", "(source) @test") then
		scanned_queries = vim.treesitter.query.parse("comment", [[
			(tag) @comment.tag ; Task.
			(uri) @comment.url
		]]);
	else
		scanned_queries = vim.treesitter.query.parse("comment", [[
			(task) @comment.task

			(task_scope
				(word) @comment.task_scope)

			(code) @comment.inline_code
			(code_block) @comment.code_block

			(issue_reference) @comment.issue
			(mention) @comment.mention
			(url) @comment.url
			(autolink) @comment.autolink
			(taglink) @comment.taglink
		]]);
	end

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TSTree:root(), buffer, from, to) do
		local capture_name = scanned_queries.captures[capture_id];

		if not capture_name:match("^comment%.") then
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
			comment[capture_name:gsub("^comment%.", "")],

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

				from = "parsers/comment.lua",
				fn = "parse()",

				message = {
					{ tostring(error), "DiagnosticError" }
				}
			});
		end

	    ::continue::
	end

	return comment.content, comment.sorted;
end

return comment;

