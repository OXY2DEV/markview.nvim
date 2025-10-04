--[[ Markdown link reference parser for `markview.nvim` ]]
local markdown = {};

--[[
`Heading` to `section_link` for *Github flavored markdown*(`GFM`).

Steps:
	1. Remove `emoji`s.
	2. Replace ` ` with `-`.
	3. Remove *punctuations* except `-` & `_`.

Source: [GFM spec](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#section-links)
]]
---@param buffer integer
---@param heading string
local function gfm_link (buffer, heading)
	---|fS

	local chars = vim.fn.split(
		string.gsub(heading, "^%s+", ""):gsub("%s+$", ""),
		"\\zs"
	);
	local for_github = ""; -- string.lower(heading);

	for _, char in ipairs(chars) do
		local cp = vim.fn.char2nr(char);

		if (cp > 0x1F60 and cp <= 0x1F64F) then
			goto continue;
		elseif (cp >= 0x1F680 and cp <= 0x1F6FF) then
			goto continue;
		elseif (cp >= 0x2600 and cp <= 0x26FF) then
			goto continue;
		elseif (cp >= 0x2700 and cp <= 0x27BF) then
			goto continue;
		end

		for_github = for_github .. string.lower(char);
		::continue::
	end

	for_github = string.gsub(for_github, " ", "-");
	for_github = string.gsub(for_github, "%p", function (str)
		if str == "-" or str == "_" then
			return str;
		end

		return "";
	end);

	local num = 1;
	local links = require("markview.links");

	if links.get(buffer, for_github) then
		for_github = for_github .. "-" .. num;

		while links.get(buffer, for_github) do
			num = num + 1;
			for_github = for_github:gsub("%d+$", tostring(num));
		end
	end

	return for_github;

	---|fE
end

---@param buffer integer
---@param _ table
---@param text string[]
---@param range markview.parsed.range
markdown.atx_heading = function (buffer, _, text, range)
	---|fS

	if text[1]:match("^%s+") then
		--[[
			NOTE: `markdown` parser includes spaces before #.
			So  we should modify the range do that it starts at #.
		]]
		range.col_start = range.col_start + text[1]:match("^%s+"):len();
	end

	local _text = string.gsub(text[1], "^[%s%>]*#+%s*", "");
	local id = gfm_link(buffer, _text);

	require("markview.links").new(
		buffer,
		id,
		{ range }
	);

	---|fE
end

---@param buffer integer
---@param _ TSNode
---@param text string[]
---@param range markview.parsed.range
markdown.setext_heading = function (buffer, _, text, range)
	---|fS

	table.remove(text);

	local _text = table.concat(text);
	local id = gfm_link(buffer, _text);

	require("markview.links").new(
		buffer,
		id,
		{ range }
	);

	---|fE
end

--- Markdown parser.
---@param buffer integer
---@param TSTree table
---@param from integer?
---@param to integer?
markdown.parse = function (buffer, TSTree, from, to)
	---|fS

	local scanned_queries = vim.treesitter.query.parse("markdown", [[
		((atx_heading) @markdown.atx_heading)

		((setext_heading) @markdown.setext_heading)
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

	---|fE
end

return markdown;
