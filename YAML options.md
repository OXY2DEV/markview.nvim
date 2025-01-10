# 🧩 YAML options

Changes how YAML metadata is shown in preview.

```lua
--- Configuration for YAML.
---@class config.yaml
---
---@field enable boolean
---@field properties yaml.properties
M.yaml = {
	enable = true,
	properties = {}
};
```

## properties

- Type: `yaml.properties`
- Dynamic: **true**

Configuration for YAML properties.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for YAML properties.
---@class yaml.properties
---
---@field enable boolean
---
---@field data_types { [string]: properties.opts } Configuration for various data types.
---
---@field default properties.opts Default configuration for properties.
---@field [string] properties.opts Configuration for properties whose name matches `string`.
properties = {
    enable = true,

    data_types = {
        ["text"] = {
            text = " 󰗊 ", hl = "MarkviewIcon4"
        },
        ["list"] = {
            text = " 󰝖 ", hl = "MarkviewIcon5"
        },
        ["number"] = {
            text = "  ", hl = "MarkviewIcon6"
        },
        ["checkbox"] = {
            ---@diagnostic disable
            text = function (_, item)
                return item.value == "true" and " 󰄲 " or " 󰄱 "
            end,
            ---@diagnostic enable
            hl = "MarkviewIcon6"
        },
        ["date"] = {
            text = " 󰃭 ", hl = "MarkviewIcon2"
        },
        ["date_&_time"] = {
            text = " 󰥔 ", hl = "MarkviewIcon3"
        }
    },

    default = {
        use_types = true,

        border_top = " │ ",
        border_middle = " │ ",
        border_bottom = " ╰╸",

        border_hl = "MarkviewComment"
    },

    ["^tags$"] = {
        match_string = "^tags$",
        use_types = false,

        text = " 󰓹 ",
        hl = nil
    },
    ["^aliases$"] = {
        match_string = "^aliases$",
        use_types = false,

        text = " 󱞫 ",
        hl = nil
    },
    ["^cssclasses$"] = {
        match_string = "^cssclasses$",
        use_types = false,

        text = "  ",
        hl = nil
    },


    ["^publish$"] = {
        match_string = "^publish$",
        use_types = false,

        text = "  ",
        hl = nil
    },
    ["^permalink$"] = {
        match_string = "^permalink$",
        use_types = false,

        text = "  ",
        hl = nil
    },
    ["^description$"] = {
        match_string = "^description$",
        use_types = false,

        text = " 󰋼 ",
        hl = nil
    },
    ["^image$"] = {
        match_string = "^image$",
        use_types = false,

        text = " 󰋫 ",
        hl = nil
    },
    ["^cover$"] = {
        match_string = "^cover$",
        use_types = false,

        text = " 󰹉 ",
        hl = nil
    };
}
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
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
```
<!--_-->
</details>

