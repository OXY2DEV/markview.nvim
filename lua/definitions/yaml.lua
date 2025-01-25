---@meta

local M = {};

 ------------------------------------------------------------------------------------------

--- Configuration for YAML.
---@class config.yaml
---
---@field enable boolean
---@field properties yaml.properties
M.yaml = {
	enable = true,
	properties = {}
};

-- [ YAML | Properties ] ------------------------------------------------------------------

--- Configuration for YAML properties.
---@class yaml.properties
---
---@field enable boolean
---
---@field data_types { [string]: properties.opts } Configuration for various data types.
---
---@field default properties.opts Default configuration for properties.
---@field [string] properties.opts Configuration for properties whose name matches `string`.
M.yaml_properties = {
	enable = true,
	default = {},
	data_types = {},
};

-- [ YAML | Properties > Types ] ----------------------------------------------------------

---@class properties.opts
---
---@field border_bottom? string Scope guide border bottom.
---@field border_bottom_hl? string
---@field border_hl? string
---@field border_middle? string Scope guide border middle.
---@field border_middle_hl? string
---@field border_top? string Scope guide border top.
---@field border_top_hl? string
---
---@field hl? string
---@field text? string
---
---@field use_types? boolean When `true`, the configuration table merges with the value's data type configuration.
M.properties_opts = {
	use_types = true,

	text = "π",
	hl = "Title"
};

-- [ YAML | Properties > Parameters ] -----------------------------------------------------

---@class __yaml.properties
---
---@field class "yaml_property"
---@field type "date" | "date_&_time" | "number" | "text" | "list" | "checkbox" | "nil" | "unknown"
---@field key string
---@field value string
---@field text string[]
---@field range node.range
M.__yaml_properties = {
	class = "yaml_property",
	type = "checkbox",

	key = "key",
	value = "value",

	text = { "key: value" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 10
	}
};

return M;
