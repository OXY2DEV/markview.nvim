# 📦 HTML options

>[!TIP]
> You can find the type definitions in [definitions/renderers/html.lua](https://github.com/OXY2DEV/markview.nvim/blob/main/lua/definitions/renderers/html.lua).

Options that change how inline HTML is shown in preview are part of this. Default values can be found [here](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/markview/spec.lua#L1462-L1580).

```lua
---@type markview.config.html
html = {
    enable = true,

    container_elements = {
        enable = true,

        ["^a$"] = {
            on_opening_tag = { conceal = "", virt_text_pos = "inline", virt_text = { { "", "MarkviewHyperlink" } } },
            on_node = { hl_group = "MarkviewHyperlink" },
            on_closing_tag = { conceal = "" },
        },
        ["^b$"] = {
            on_opening_tag = { conceal = "" },
            on_node = { hl_group = "Bold" },
            on_closing_tag = { conceal = "" },
        },
        ["^code$"] = {
            on_opening_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { " ", "MarkviewInlineCode" } } },
            on_node = { hl_group = "MarkviewInlineCode" },
            on_closing_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { " ", "MarkviewInlineCode" } } },
        },
        ["^em$"] = {
            on_opening_tag = { conceal = "" },
            on_node = { hl_group = "@text.emphasis" },
            on_closing_tag = { conceal = "" },
        },
        ["^i$"] = {
            on_opening_tag = { conceal = "" },
            on_node = { hl_group = "Italic" },
            on_closing_tag = { conceal = "" },
        },
        ["^mark$"] = {
            on_opening_tag = { conceal = "" },
            on_node = { hl_group = "MarkviewPalette1" },
            on_closing_tag = { conceal = "" },
        },
        ["^pre$"] = {
            on_opening_tag = { conceal = "" },
            on_node = { hl_group = "Special" },
            on_closing_tag = { conceal = "" },
        },
        ["^strong$"] = {
            on_opening_tag = { conceal = "" },
            on_node = { hl_group = "@text.strong" },
            on_closing_tag = { conceal = "" },
        },
        ["^sub$"] = {
            on_opening_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "↓[", "MarkviewSubscript" } } },
            on_node = { hl_group = "MarkviewSubscript" },
            on_closing_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "]", "MarkviewSubscript" } } },
        },
        ["^sup$"] = {
            on_opening_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "↑[", "MarkviewSuperscript" } } },
            on_node = { hl_group = "MarkviewSuperscript" },
            on_closing_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "]", "MarkviewSuperscript" } } },
        },
        ["^u$"] = {
            on_opening_tag = { conceal = "" },
            on_node = { hl_group = "Underlined" },
            on_closing_tag = { conceal = "" },
        },
    },

    headings = {
        enable = true,

        heading_1 = {
            hl_group = "MarkviewPalette1Bg"
        },
        heading_2 = {
            hl_group = "MarkviewPalette2Bg"
        },
        heading_3 = {
            hl_group = "MarkviewPalette3Bg"
        },
        heading_4 = {
            hl_group = "MarkviewPalette4Bg"
        },
        heading_5 = {
            hl_group = "MarkviewPalette5Bg"
        },
        heading_6 = {
            hl_group = "MarkviewPalette6Bg"
        },
    },

    void_elements = {
        enable = true,

        ["^hr$"] = {
            on_node = {
                conceal = "",

                virt_text_pos = "inline",
                virt_text = {
                    { "─", "MarkviewGradient2" },
                    { "─", "MarkviewGradient3" },
                    { "─", "MarkviewGradient4" },
                    { "─", "MarkviewGradient5" },
                    { " ◉ ", "MarkviewGradient9" },
                    { "─", "MarkviewGradient5" },
                    { "─", "MarkviewGradient4" },
                    { "─", "MarkviewGradient3" },
                    { "─", "MarkviewGradient2" },
                }
            }
        },
        ["^br$"] = {
            on_node = {
                conceal = "",

                virt_text_pos = "inline",
                virt_text = {
                    { "󱞦", "Comment" },
                }
            }
        },
    }
},
```

## enable

- type: `boolean`
  default: `true`

Enables preview of inline HTML.

## container_elements

- type: [markview.config.html.container_elements](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/html.lua#L19-L33)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/markview/spec.lua#L1523)

Changes how container elements are shown in previews.

```lua
---@type markview.config.html.container_elements
container_elements = {
    enable = true,

    ["^a$"] = {
        on_opening_tag = { conceal = "", virt_text_pos = "inline", virt_text = { { "", "MarkviewHyperlink" } } },
        on_node = { hl_group = "MarkviewHyperlink" },
        on_closing_tag = { conceal = "" },
    },
    ["^b$"] = {
        on_opening_tag = { conceal = "" },
        on_node = { hl_group = "Bold" },
        on_closing_tag = { conceal = "" },
    },
    ["^code$"] = {
        on_opening_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { " ", "MarkviewInlineCode" } } },
        on_node = { hl_group = "MarkviewInlineCode" },
        on_closing_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { " ", "MarkviewInlineCode" } } },
    },
    ["^em$"] = {
        on_opening_tag = { conceal = "" },
        on_node = { hl_group = "@text.emphasis" },
        on_closing_tag = { conceal = "" },
    },
    ["^i$"] = {
        on_opening_tag = { conceal = "" },
        on_node = { hl_group = "Italic" },
        on_closing_tag = { conceal = "" },
    },
    ["^mark$"] = {
        on_opening_tag = { conceal = "" },
        on_node = { hl_group = "MarkviewPalette1" },
        on_closing_tag = { conceal = "" },
    },
    ["^pre$"] = {
        on_opening_tag = { conceal = "" },
        on_node = { hl_group = "Special" },
        on_closing_tag = { conceal = "" },
    },
    ["^strong$"] = {
        on_opening_tag = { conceal = "" },
        on_node = { hl_group = "@text.strong" },
        on_closing_tag = { conceal = "" },
    },
    ["^sub$"] = {
        on_opening_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "↓[", "MarkviewSubscript" } } },
        on_node = { hl_group = "MarkviewSubscript" },
        on_closing_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "]", "MarkviewSubscript" } } },
    },
    ["^sup$"] = {
        on_opening_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "↑[", "MarkviewSuperscript" } } },
        on_node = { hl_group = "MarkviewSuperscript" },
        on_closing_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "]", "MarkviewSuperscript" } } },
    },
    ["^u$"] = {
        on_opening_tag = { conceal = "" },
        on_node = { hl_group = "Underlined" },
        on_closing_tag = { conceal = "" },
    },
},
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

<h3 id="container_string">\[string\]</h3>

- type: [markview.config.html.container_elements.opts](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/html.lua#L25-L33)

Changes how `<string></string>` will be shown in previews.

```lua
---@type markview.config.html.container_elements.opts
["^a$"] = {
    closing_tag_offset = nil,
    node_offset = nil,
    opening_tag_offset = nil,

    on_opening_tag = {
        conceal = "",
        virt_text_pos = "inline",
        virt_text = { { "", "MarkviewHyperlink" } }
    },
    on_node = { hl_group = "MarkviewHyperlink" },
    on_closing_tag = { conceal = "" },
},
```

#### closing_tag_offset

- type: `fun(range: integer[]): integer[]`

See also,

- [markview.parsed.range](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L60-L66)

Modifies the range of the closing tag.

#### node_offset

- type: `fun(range: integer[]): integer[]`

See also,

- [markview.parsed.range](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L60-L66)

Modifies the range of the entire node/element.

#### opening_tag_offset

- type: `fun(range: integer[]): integer[]`

See also,

- [markview.parsed.range](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L60-L66)

Modifies the range of the opening tag.

#### on_opening_tag

- type: `table`

Configuration for the extmark placed on the opening tag. The range is affected by [opening_tag_offset](#opening_tag_offset).

#### on_node

- type: `table`

Configuration for the extmark placed on the element. The range is affected by [node_offset](#node_offset).

#### on_closing_tag

- type: `table`

Configuration for the extmark placed on the closing tag. The range is affected by [closing_tag_offset](#closing_tag_offset).

## headings

- type: [markview.config.html.headings](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/html.lua#L37-al41)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/markview/spec.lua#L1525-L1547)

Changes how headings are shown in previews.

```lua
---@type markview.config.html.headings
headings = {
    enable = true,

    heading_1 = {
        hl_group = "MarkviewPalette1Bg"
    },
    heading_2 = {
        hl_group = "MarkviewPalette2Bg"
    },
    heading_3 = {
        hl_group = "MarkviewPalette3Bg"
    },
    heading_4 = {
        hl_group = "MarkviewPalette4Bg"
    },
    heading_5 = {
        hl_group = "MarkviewPalette5Bg"
    },
    heading_6 = {
        hl_group = "MarkviewPalette6Bg"
    },
},
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

#### heading_1

- type: `table`

Configuration for the extmark placed on the element.

#### heading_2

- type: `table`

Configuration for the extmark placed on the element.

#### heading_3

- type: `table`

Configuration for the extmark placed on the element.

#### heading_4

- type: `table`

Configuration for the extmark placed on the element.

#### heading_5

- type: `table`

Configuration for the extmark placed on the element.

#### heading_6

- type: `table`

Configuration for the extmark placed on the element.

## void_elements

- type: [markview.config.html.void_elements](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/html.lua#L45-L55)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/markview/spec.lua#L1548-1579)

Changes how void elements are shown in previews.

```lua
---@type markview.config.void_elements
void_elements = {
    enable = true,

    ["^hr$"] = {
        on_node = {
            conceal = "",

            virt_text_pos = "inline",
            virt_text = {
                { "─", "MarkviewGradient2" },
                { "─", "MarkviewGradient3" },
                { "─", "MarkviewGradient4" },
                { "─", "MarkviewGradient5" },
                { " ◉ ", "MarkviewGradient9" },
                { "─", "MarkviewGradient5" },
                { "─", "MarkviewGradient4" },
                { "─", "MarkviewGradient3" },
                { "─", "MarkviewGradient2" },
            }
        }
    },
    ["^br$"] = {
        on_node = {
            conceal = "",

            virt_text_pos = "inline",
            virt_text = {
                { "󱞦", "Comment" },
            }
        }
    },
}
```

<h3 id="void_string">\[string\]</h3>

- type: [markview.config.html.void_elements.opts](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/html.lua#L51-L55)

Changes how `<string/>` will be shown in previews.

<h4 id="void_node">node_offset</h4>

- type: `fun(range: integer[]): integer[]`

See also,

- [markview.parsed.range](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L60-L66)

Modifies the range of the tag.

#### on_node

- type: `table`

Configuration for the extmark placed on the node/element. The range is affected by [node_offset](#void_node).

