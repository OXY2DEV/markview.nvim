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

--- YAML property.
---@param buffer integer
---@param TSNode table
---@param text string[]
---@param range markview.parsed.range
yaml.property = function (buffer, TSNode, text, range)
	local key, value = TSNode:field("key")[1], TSNode:field("value")[1];

	local key_text = key and vim.treesitter.get_node_text(key, buffer) or nil;
	local value_text = value and vim.treesitter.get_node_text(value, buffer) or nil;

	--- Checks if {str} matches any of the
	--- date patterns.
	---@param str string?
	---@return boolean
	local function is_date (str)
		if type(str) ~= "string" then
			return false;
		end

		local spec = require("markview.spec");
		local formats = spec.get({ "experimental", "date_formats" }, { fallback = {} });

		for _, format in ipairs(formats) do
			if string.match(str, format) then
				return true;
			end
		end

		return false;
	end

	--- Checks if {str} matches any of the
	--- date & time patterns.
	---@param str string?
	---@return boolean
	local function is_date_time (str)
		if type(str) ~= "string" then
			return false;
		end

		local spec = require("markview.spec");
		local formats = spec.get({ "experimental", "date_time_formats" }, { fallback = {} });

		for _, format in ipairs(formats) do
			if string.match(str, format) then
				return true;
			end
		end

		return false;
	end

	--- Checks if this node contains
	--- a list.
	local function is_list()
		if type(value) ~= "table" then
			return false;
		elseif value:child(0) == nil then
			--- `value:` has no node.
			return false;
		elseif value:child(0):child(0) == nil then
			return false;
		elseif value:child(0):child(0):type() ~= "block_sequence" then
			return false;
		end

		return true;
	end

	local value_type = "unknown";

	if is_date_time(value_text) == true then
		value_type = "date_&_time";
	elseif is_date(value_text) == true then
		value_type = "date";
	elseif is_list() == true then
		value_type = "list";
	elseif tonumber(value_text) ~= nil then
		value_type = "number";
	elseif value_text == "true" or value_text == "false" then
		value_type = "checkbox";
	elseif type(value_text) == "string" then
		value_type = "text";
	elseif value_type == nil then
		value_type = "nil";
	end

	if range.col_end == 0 then
		range.row_end = range.row_start + #text - 1;
	end

	yaml.insert({
		class = "yaml_property",
		type = value_type,

		key = key_text,
		value = value_text,

		text = text,
		range = range
	});
end

--- YAML parser.
---@param buffer integer
---@param TSTree table
---@param from integer?
---@param to integer?
---@return markview.parsed.yaml[]
---@return markview.parsed.yaml_sorted
yaml.parse = function (buffer, TSTree, from, to)
	-- Clear the previous contents
	yaml.sorted = {};
	yaml.content = {};

	local scanned_queries = vim.treesitter.query.parse("yaml", [[
		((block_mapping_pair) @yaml.property)
	]]);

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TSTree:root(), buffer, from, to) do
		local capture_name = scanned_queries.captures[capture_id];

		if not capture_name:match("^yaml%.") then
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
			yaml[capture_name:gsub("^yaml%.", "")],

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

				from = "parsers/yaml.lua",
				fn = "parse()",

				message = {
					{ tostring(err), "DiagnosticError" }
				}
			});
		end

	    ::continue::
	end

	return yaml.content, yaml.sorted;
end

return yaml;
