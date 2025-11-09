--- HTML parser for `markview.nvim`.
local html = {};

---@param buffer integer
---@param TSNode TSNode
html.link_attribute = function (buffer, TSNode, _, _)
	local element = TSNode:parent();
	local value = TSNode:named_child(1);

	if not element or not value then
		return;
	elseif value:type() == "quoted_attribute_value" then
		local range = { element:range() };
		local inner = value:named_child(0);

		if not inner then
			return;
		end

		require("markview.links").new(
			buffer,
			vim.treesitter.get_node_text(inner, buffer, {}),
			{
				row_start = range[1],
				row_end = range[3],

				col_start = range[2],
				col_end = range[4],
			}
		);
	elseif value:type() == "attribute_value" then
		local range = { element:range() };

		require("markview.links").new(
			buffer,
			vim.treesitter.get_node_text(value, buffer, {}),
			{
				row_start = range[1],
				row_end = range[3],

				col_start = range[2],
				col_end = range[4],
			}
		);
	end
end

--- HTML parser
---@param buffer integer
---@param TSTree table
---@param from integer?
---@param to integer?
html.parse = function (buffer, TSTree, from, to)
	local scanned_queries = vim.treesitter.query.parse("html", [[
		; FEAT(gx): Link attributes.
		(attribute
			(attribute_name) @is_id
			(#any-of? @is_id "id" "name")) @html.link_attribute
	]]);

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TSTree:root(), buffer, from, to) do
		local capture_name = scanned_queries.captures[capture_id];

		if not capture_name:match("^html%.") then
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
		local success, err = pcall(
			html[capture_name:gsub("^html%.", "")],

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
				from = "parsers/links/html.lua",
				fn = "parse()",

				message = {
					{ tostring(err), "DiagnosticError" }
				}
			});
		end

	    ::continue::
	end
end

return html;
