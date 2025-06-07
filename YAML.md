# YAML options

>[!TIP]
> You can find the type definitions in [definitions/renderers/yaml.lua](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/yaml.lua).

Options that change how YAML blocks are shown are part of this. See default values in [here](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/markview/spec.lua#L2276-L2376).

```lua
---@type markview.config.yaml
yaml = {
    enable = true,

    properties = {
        enable = true,

        data_types = {
            ["text"] = {
                text = "󰗊 ", hl = "MarkviewIcon4"
            },
            ["list"] = {
                text = "󰝖 ", hl = "MarkviewIcon5"
            },
            ["number"] = {
                text = " ", hl = "MarkviewIcon6"
            },
            ["checkbox"] = {
                ---@diagnostic disable
                text = function (_, item)
                    return item.value == "true" and "󰄲 " or "󰄱 "
                end,
                ---@diagnostic enable
                hl = "MarkviewIcon6"
            },
            ["date"] = {
                text = "󰃭 ", hl = "MarkviewIcon2"
            },
            ["date_&_time"] = {
                text = "󰥔 ", hl = "MarkviewIcon3"
            }
        },

        default = {
            use_types = true,

            border_top = nil,
            border_middle = nil,
            border_bottom = nil,

            border_hl = nil,
        },

        ["^tags$"] = {
            use_types = false,

            text = "󰓹 ",
            hl = "MarkviewIcon0"
        },
        ["^aliases$"] = {
            match_string = "^aliases$",
            use_types = false,

            text = "󱞫 ",
            hl = "MarkviewIcon2"
        },
        ["^cssclasses$"] = {
            match_string = "^cssclasses$",
            use_types = false,

            text = " ",
            hl = "MarkviewIcon3"
        },


        ["^publish$"] = {
            match_string = "^publish$",
            use_types = false,

            text = "󰅧 ",
            hl = "MarkviewIcon5"
        },
        ["^permalink$"] = {
            match_string = "^permalink$",
            use_types = false,

            text = " ",
            hl = "MarkviewIcon2"
        },
        ["^description$"] = {
            match_string = "^description$",
            use_types = false,

            text = "󰋼 ",
            hl = "MarkviewIcon0"
        },
        ["^image$"] = {
            match_string = "^image$",
            use_types = false,

            text = "󰋫 ",
            hl = "MarkviewIcon4"
        },
        ["^cover$"] = {
            match_string = "^cover$",
            use_types = false,

            text = "󰹉 ",
            hl = "MarkviewIcon2"
        }
}
}
```

## enable

- type: `boolean`
  default: `true`

Allows previewing YAML.

## properties

- type: [markview.config.yaml.properties](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/yaml.lua#L12-L39)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/markview/spec.lua#L2279-L2375)

Changes how YAML properties are shown.

```lua
---@type markview.config.yaml.properties
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
    }
},
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

### data_types

- type: `{ [string]: markview.config.yaml.properties.opts }`
  [default](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/markview/spec.lua#L2282-L2306)

Configuration for various data types.

#### text

- type: [markview.config.yaml.properties.opts](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/yaml.lua#L23-L39)

Configuration for YAML properties whose value is a text.

```lua
---@type markview.config.yaml.properties.opts
["text"] = {
    text = "󰗊 ",
    hl = "MarkviewIcon4"
},
```

<h5 id="opt_text">text</h5>

- type: `string | fun(bufnr: integer, item: markview.parsed.yaml.properties): string`

Text shown before the property name(like an icon).

##### hl

- type: `string | fun(bufnr: integer, item: markview.parsed.yaml.properties): string`

Highlight group for [text](#opt_text).

#### list

- type: [markview.config.yaml.properties.opts](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/yaml.lua#L23-L39)

Configuration for YAML properties whose value is a list. Same as [text](#text).

#### number

- type: [markview.config.yaml.properties.opts](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/yaml.lua#L23-L39)

Configuration for YAML properties whose value is a number. Same as [text](#text).

#### checkbox

- type: [markview.config.yaml.properties.opts](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/yaml.lua#L23-L39)

Configuration for YAML properties whose value is a boolean. Same as [text](#text).

#### date

- type: [markview.config.yaml.properties.opts](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/yaml.lua#L23-L39)

Also see,

- [date_patterns](), for patterns used to detect date from strings.

Configuration for YAML properties whose value is a date. Same as [text](#text).

#### date_&_time

- type: [markview.config.yaml.properties.opts](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/yaml.lua#L23-L39)

Also see,

- [date_patterns](), for patterns used to detect date & time from strings.

Configuration for YAML properties whose value is a date & time. Same as [text](#text).

### default

- type: [markview.config.yaml.properties.opts](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/yaml.lua#L23-L39)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/markview/spec.lua#L2308-L2316)

Default configuration for YAML properties.

#### use_types

- type: `boolean`
  default: `true`

Whether to use the data types configuration. See [data_types](#data_types).

<h5 id="default_text">text</h5>

- type: `string | fun(bufnr: integer, item: markview.parsed.yaml.properties): string`

Text shown before the property name(like an icon).

##### hl

- type: `string | fun(bufnr: integer, item: markview.parsed.yaml.properties): string`

Highlight group for [text](#default_text).

### \[string\]

- type: [markview.config.yaml.properties.opts](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/yaml.lua#L23-L39)

Configuration for YAML properties that match `string`. Same as [default](#default).

