local yaml = {};

--- Queried contents
---@type table[]
yaml.content = {};

--- Queried contents, but sorted
yaml.sorted = {}

yaml.insert = function (data)
	table.insert(yaml.content, data);

	if not yaml.sorted[data.class] then
		yaml.sorted[data.class] = {};
	end

	table.insert(yaml.sorted[data.class], data);
end

yaml.property = function (buffer, TSNode, text, range)
	local key, value = TSNode:field("key")[1], TSNode:field("value")[1];

	local key_text = key and vim.treesitter.get_node_text(key, buffer) or nil;
	local value_text = value and vim.treesitter.get_node_text(value, buffer) or nil;

	local value_type = "unknown";

	if key_text == "date" then
		value_type = "date";
	elseif key_text == "time" then
		value_type = "time";
	elseif key_text == "tags" then
		value_type = "tags";
	elseif key_text == "aliases" then
		value_type = "aliases";
	elseif key_text == "cssclasses" then
		value_type = "cssclasses";
	elseif tonumber(value_text) then
		value_type = "number";
	elseif value_text == "true" or value_text == "false" then
		value_type = "checkbox";
	elseif
		value and value:child(0) and value:child(0):child(0) and
		value:child(0):child(0):type() == "block_sequence_item"
	then
		value_type = "list";
	elseif type(value_text) == "string" then
		value_type = "string";
	elseif not value_text then
		value_type = "nil";
	end

	if not #text == (range.row_end - range.row_start) then
		range.row_end = range.row_start + #text;
	end

	yaml.insert({
		class = "yaml_property",
		type = value_type,

		text = text,

		range = range
	});
end

yaml.parse = function (buffer, TSTree, from, to)
	-- Clear the previous contents
	yaml.sorted = {};
	yaml.content = {};

	local scanned_queries = vim.treesitter.query.parse("yaml", [[
		((block_mapping_pair) @yaml.property)
	]]);

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TSTree:root(), buffer, from, to) do
		local capture_name = scanned_queries.captures[capture_id];
		local r_start, c_start, r_end, c_end = capture_node:range();

		if not capture_name:match("^yaml%.") then
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

		yaml[capture_name:gsub("^yaml%.", "")](buffer, capture_node, lines, {
			row_start = r_start,
			col_start = c_start,

			row_end = r_end,
			col_end = c_end
		});

	    ::continue::
	end

	return yaml.content, yaml.sorted;
end

return yaml;
