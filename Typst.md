<!--markdoc
    {
        "generic": {
            "filename": "../doc/markview.nvim-typst.txt",
            "force_write": true,
            "header": {
                "desc": "🧩 Typst options for `markview.nvim`",
                "tag": "markview.nvim-typst"
            }
        },
        "markdown": {
            "heading_ratio": [ 26, 54 ],
            "list_items": {
                "marker_minus": "◆",
                "marker_plus": "◇"
            },
            "tags": {
                "code_blocks": [ "markview.nvim-typst.code_blocks" ],
                "code_spans": [ "markview.nvim-typst.code_spans" ],
                "escapes": [ "markview.nvim-typst.escapes" ],
                "headings": [ "markview.nvim-typst.headings" ],
                "labels": [ "markview.nvim-typst.labels" ],
                "list_items": [ "markview.nvim-typst.list_items" ],
                "math_blocks": [ "markview.nvim-typst.math_blocks" ],
                "math_spans": [ "markview.nvim-typst.math_spans" ],
                "raw_blocks": [ "markview.nvim-typst.raw_blocks" ],
                "raw_spans": [ "markview.nvim-typst.raw_spans" ],
                "reference_links": [ "markview.nvim-typst.reference_links" ],
                "subscripts": [ "markview.nvim-typst.subscripts" ],
                "superscripts": [ "markview.nvim-typst.superscripts" ],
                "symbols": [ "markview.nvim-typst.symbols" ],
                "terms": [ "markview.nvim-typst.terms" ],
                "url_links": [ "markview.nvim-typst.url_links" ]
            }
        }
    }
-->
<!--markdoc_ignore_start-->
# 🧩 Typst
<!--markdoc_ignore_end-->

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst
--- Configuration for Typst.
---@class markview.config.typst
---
---@field enable boolean Enable **Typst** rendering.
---
---@field code_blocks markview.config.typst.code_blocks Configuration for block of typst code.
---@field code_spans markview.config.typst.code_spans Configuration for inline typst code.
---@field escapes markview.config.typst.escapes Configuration for escaped characters.
---@field headings markview.config.typst.headings Configuration for headings.
---@field labels markview.config.typst.labels Configuration for labels.
---@field list_items markview.config.typst.list_items Configuration for list items
---@field math_blocks markview.config.typst.math_blocks Configuration for blocks of math code.
---@field math_spans markview.config.typst.math_spans Configuration for inline math code.
---@field raw_blocks markview.config.typst.raw_blocks Configuration for raw blocks.
---@field raw_spans markview.config.typst.raw_spans Configuration for raw spans.
---@field reference_links markview.config.typst.reference_links Configuration for reference links.
---@field subscripts markview.config.typst.subscripts Configuration for subscript texts.
---@field superscripts markview.config.typst.subscripts Configuration for superscript texts.
---@field symbols markview.config.typst.symbols Configuration for typst symbols.
---@field terms markview.config.typst.terms Configuration for terms.
---@field url_links markview.config.typst.url_links Configuration for URL links.
```

## enable

```lua
enable = true
```

## code_blocks

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.code_blocks
--- Configuration for code blocks.
---@class markview.config.typst.code_blocks
---
---@field enable boolean Enable rendering of code blocks.
---
---@field hl? string Highlight group.
---@field min_width integer Minimum width of code blocks.
---@field pad_amount integer Number of paddings added around the text.
---@field pad_char? string Character to use for padding.
---@field sign? string Sign for the code block.
---@field sign_hl? string Highlight group for the sign.
---@field style
---| "simple" Only highlights the lines inside this block.
---| "block" Creates a box around the code block.
---@field text string Text to use as the label.
---@field text_direction
---| "left" Shows label on the top-left side of the block
---| "right" Shows label on the top-right side of the block
---@field text_hl? string Highlight group for the label
```

Changes how code blocks are shown.

```lua
code_blocks = {
    enable = true,

    hl = "MarkviewCode",

    min_width = 60,
    pad_amount = 3,
    pad_char = " ",

    style = "block",

    text = "󰣖 Code",
    text_direction = "right",
    text_hl = "MarkviewIcon5"
},
```

## code_spans

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.code_spans
--- Configuration for code spans.
---@class markview.config.typst.code_spans
---
---@field enable boolean Enable rendering of code spans.
---
---@field corner_left? string Left corner.
---@field corner_left_hl? string Highlight group for left corner.
---@field corner_right? string Right corner.
---@field corner_right_hl? string Highlight group for right corner.
---@field hl? string Base Highlight group.
---@field padding_left? string Left padding.
---@field padding_left_hl? string Highlight group for left padding.
---@field padding_right? string Right padding.
---@field padding_right_hl? string Highlight group for right padding.
```

Changes how code spans are shown.

```lua
code_spans = {
    enable = true,

    padding_left = " ",
    padding_right = " ",

    hl = "MarkviewCode"
},
```

## escapes

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.escapes
---@class markview.config.typst.escapes
---
---@field enable boolean Enable rendering of escaped characters.
```

Changes how escaped characters are shown.

```lua
escapes = {
    enable = true
},
```

## headings

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.headings
--- Configuration for Typst headings.
---@class markview.config.typst.headings
---
---@field enable boolean Enable rendering of Headings.
---
---@field shift_width integer Amount of spaces to shift per heading level.
---@field [string] headings.typst Heading level configuration(name format: "heading_%d", %d = heading level).
```

Changes how headings are shown.

```lua
headings = {
    enable = true,
    shift_width = 1,

    heading_1 = {
        style = "icon",
        sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",

        icon = "󰼏  ", hl = "MarkviewHeading1",
    },
    heading_2 = {
        style = "icon",
        sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",

        icon = "󰎨  ", hl = "MarkviewHeading2",
    },
    heading_3 = {
        style = "icon",

        icon = "󰼑  ", hl = "MarkviewHeading3",
    },
    heading_4 = {
        style = "icon",

        icon = "󰎲  ", hl = "MarkviewHeading4",
    },
    heading_5 = {
        style = "icon",

        icon = "󰼓  ", hl = "MarkviewHeading5",
    },
    heading_6 = {
        style = "icon",

        icon = "󰎴  ", hl = "MarkviewHeading6",
    }
},
```

Each heading has the following options.

```lua from: ../lua/markview/types/renderers/typst.lua class: headings.typst
--- Configuration options for each typst heading level.
---@class headings.typst
---
---@field hl? string Highlight group.
---@field icon? string
---@field icon_hl? string
---@field sign? string
---@field sign_hl? string
---@field style "simple" | "icon"
```

## labels

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.labels
--- Configuration for typst labels.
---@class markview.config.typst.labels
---
---@field enable boolean Enable rendering of labels.
---
---@field default markview.config.typst.labels.opts Default configuration for labels.
---@field [string] markview.config.typst.labels.opts Configuration for labels whose text matches `string`.
```

Changes how labels are shown.

```lua
labels = {
    enable = true,

    default = {
        hl = "MarkviewInlineCode",
        padding_left = " ",
        icon = " ",
        padding_right = " "
    }
},
```

## list_items

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.list_items
--- Configuration for list items.
---@class markview.config.typst.list_items
---
---@field enable boolean Enable rendering of list items.
---
---@field indent_size integer | fun(buffer: integer, item: markview.parsed.typst.list_items): integer Indentation size for list items.
---@field shift_width integer | fun(buffer: integer, item: markview.parsed.typst.list_items): integer Preview indentation size for list items.
---
---@field marker_dot markview.config.typst.list_items.typst Configuration for `n.` list items.
---@field marker_minus markview.config.typst.list_items.typst Configuration for `-` list items.
---@field marker_plus markview.config.typst.list_items.typst Configuration for `+` list items.
```

Changes how list items are shown.

```lua
list_items = {
    enable = true,

    indent_size = function (buffer)
        if type(buffer) ~= "number" then
            return vim.bo.shiftwidth or 4;
        end

        --- Use 'shiftwidth' value.
        return vim.bo[buffer].shiftwidth or 4;
    end,
    shift_width = 4,

    marker_minus = {
        add_padding = true,

        text = "●",
        hl = "MarkviewListItemMinus"
    },

    marker_plus = {
        add_padding = true,

        text = "%d)",
        hl = "MarkviewListItemPlus"
    },

    marker_dot = {
        add_padding = true,

        text = "%d.",
        hl = "MarkviewListItemStar"
    }
},
```

Each list type has the following options.

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.list_items.typst
---@class markview.config.typst.list_items.typst
---
---@field enable? boolean Enable rendering of this list item type.
---
---@field add_padding boolean
---@field hl? string Highlight group.
---@field text string
```

## math_blocks

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.math_blocks
--- Configuration for math blocks.
---@class markview.config.typst.math_blocks
---
---@field enable boolean Enable rendering of math blocks.
---
---@field hl? string Highlight group.
---@field pad_amount integer Number of `pad_char` to add before the lines.
---@field pad_char string Text used as padding.
---@field text string
---@field text_hl? string
```

Changes how math blocks are shown.

```lua
math_blocks = {
    enable = true,

    text = " 󰪚 Math ",
    pad_amount = 3,
    pad_char = " ",

    hl = "MarkviewCode",
    text_hl = "MarkviewCodeInfo"
},
```

## math_spans

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.math_spans
---@alias markview.config.typst.math_spans markview.config.__inline
```

Changes how math spans are shown.

```lua
math_spans = {
    enable = true,

    padding_left = " ",
    padding_right = " ",

    hl = "MarkviewInlineCode"
},
```

## raw_blocks

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.raw_blocks
---@class markview.config.typst.raw_blocks
---
---@field enable boolean Enable rendering of raw blocks.
---
---@field border_hl? string Highlight group for top & bottom border of raw blocks.
---@field label_direction? "left" | "right" Changes where the label is shown.
---@field label_hl? string Highlight group for the label
---@field min_width? integer Minimum width of the code block.
---@field pad_amount? integer Left & right padding size.
---@field pad_char? string Character to use for the padding.
---@field sign? boolean Whether to show signs for the code blocks.
---@field sign_hl? string Highlight group for the signs.
---@field style "simple" | "block" Preview style for code blocks.
---
---@field default markview.config.typst.raw_blocks.opts Default line configuration for the raw block.
---@field [string] markview.config.typst.raw_blocks.opts Line configuration for the raw block whose `language` matches `string`
```

Changes how raw blocks are shown.

```lua
raw_blocks = {
    enable = true,

    style = "block",
    label_direction = "right",

    sign = true,

    min_width = 60,
    pad_amount = 3,
    pad_char = " ",

    border_hl = "MarkviewCode",

    default = {
        block_hl = "MarkviewCode",
        pad_hl = "MarkviewCode"
    },

    ["diff"] = {
        block_hl = function (_, line)
            if line:match("^%+") then
                return "MarkviewPalette4";
            elseif line:match("^%-") then
                return "MarkviewPalette1";
            else
                return "MarkviewCode";
            end
        end,
        pad_hl = "MarkviewCode"
    }
},
```

You can also add line specific styles for different languages. Such as this one for diff files.

```lua
    ["diff"] = {
        block_hl = function (_, line)
            if line:match("^%+") then
                return "MarkviewPalette4";
            elseif line:match("^%-") then
                return "MarkviewPalette1";
            else
                return "MarkviewCode";
            end
        end,
        pad_hl = "MarkviewCode"
    },
```

## raw_spans

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.raw_spans
---@alias markview.config.typst.raw_spans markview.config.__inline
```

Changes how raw spans are shown.

```lua
raw_spans = {
    enable = true,

    padding_left = " ",
    padding_right = " ",

    hl = "MarkviewInlineCode"
},
```

## reference_links

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.reference_links
--- Configuration for reference links.
---@class markview.config.typst.reference_links
---
---@field enable boolean Enable rendering of reference links.
---
---@field default markview.config.typst.reference_links.opts Default configuration for reference links.
---@field [string] markview.config.typst.reference_links.opts Configuration for reference links whose label matches `string`.
```

Changes how reference links are shown.

```lua
reference_links = {
    enable = true,

    default = {
        icon = " ",
        hl = "MarkviewHyperlink"
    },
},
```

Each link type has the following options.

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.reference_links.opts
--- Configuration for a specific reference link type.
---@alias markview.config.typst.reference_links.opts markview.config.__inline
```

## subscripts

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.subscripts
--- Configuration for subscript text.
---@class markview.config.typst.subscripts
---
---@field enable boolean Enable rendering of subscript text.
---@field fake_preview? boolean Use Unicode characters to mimic subscript text.
---
---@field hl? string | string[] Highlight group. Use a list to change nested subscript text color.
---@field marker_left? string
---@field marker_right? string
```

Changes how subscripts are shown.

```lua
subscripts = {
    enable = true,

    hl = "MarkviewSubscript"
},
```

## superscripts

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.superscripts
--- Configuration for superscript text.
---@class markview.config.typst.superscripts
---
---@field enable boolean Enable rendering of superscript text.
---@field fake_preview? boolean Use Unicode characters to mimic superscript text.
---
---@field hl? string | string[] Highlight group. Use a list to change nested subscript text color.
---@field marker_left? string
---@field marker_right? string
```

Changes how superscripts are shown.

```lua
superscripts = {
    enable = true,

    hl = "MarkviewSuperscript"
},
```

## symbols

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.symbols
--- Configuration for symbols in typst.
---@class markview.config.typst.symbols
---
---@field enable boolean Enable rendering of math symbols.
---@field hl? string Highlight group.
```

Changes how math symbols are shown.

```lua
symbols = {
    enable = true,

    hl = "Special"
},
```

## terms

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.terms
--- Configuration for terms.
---@class markview.config.typst.terms
---
---@field enable boolean Enable rendering of terms.
---
---@field default markview.config.typst.terms.opts Default configuration for terms.
---@field [string] markview.config.typst.terms.opts Configuration for terms whose label matches `string`.
```

Changes how terms are shown.

```lua
terms = {
    enable = true,

    default = {
        text = " ",
        hl = "MarkviewPalette6Fg"
    },
},
```

Each term type has the following options.

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.terms.opts
--- Configuration for a specific term type.
---@class markview.config.typst.terms.opts
---
---@field text string
---@field hl? string Highlight group.
```

## url_links

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.url_links
--- Configuration for URL links.
---@class markview.config.typst.url_links
---
---@field enable boolean Enable rendering of URL links.
---
---@field default markview.config.typst.url_links.opts Default configuration for URL links.
---@field [string] markview.config.typst.url_links.opts Configuration for URL links whose label matches `string`.
```

Changes how url links are shown.

```lua
url_links = {
    enable = true,

    default = {
        icon = " ",
        hl = "MarkviewEmail"
    },

    ["github%.com/[%a%d%-%_%.]+%/?$"] = {
        --- github.com/<user>

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },
    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/?$"] = {
        --- github.com/<user>/<repo>

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },
    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/tree/[%a%d%-%_%.]+%/?$"] = {
        --- github.com/<user>/<repo>/tree/<branch>

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },
    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/commits/[%a%d%-%_%.]+%/?$"] = {
        --- github.com/<user>/<repo>/commits/<branch>

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },

    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/releases$"] = {
        --- github.com/<user>/<repo>/releases

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },
    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/tags$"] = {
        --- github.com/<user>/<repo>/tags

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },
    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/issues$"] = {
        --- github.com/<user>/<repo>/issues

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },
    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/pulls$"] = {
        --- github.com/<user>/<repo>/pulls

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },

    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/wiki$"] = {
        --- github.com/<user>/<repo>/wiki

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },

    ["developer%.mozilla%.org"] = {
        priority = -9999,

        icon = "󰖟 ",
        hl = "MarkviewPalette5Fg"
    },

    ["w3schools%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette4Fg"
    },

    ["stackoverflow%.com"] = {
        priority = -9999,

        icon = "󰓌 ",
        hl = "MarkviewPalette2Fg"
    },

    ["reddit%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette2Fg"
    },

    ["github%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette6Fg"
    },

    ["gitlab%.com"] = {
        priority = -9999,

        icon = "󰮠 ",
        hl = "MarkviewPalette2Fg"
    },

    ["dev%.to"] = {
        priority = -9999,

        icon = "󱁴 ",
        hl = "MarkviewPalette0Fg"
    },

    ["codepen%.io"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette6Fg"
    },

    ["replit%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette2Fg"
    },

    ["jsfiddle%.net"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette5Fg"
    },

    ["npmjs%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },

    ["pypi%.org"] = {
        priority = -9999,

        icon = "󰆦 ",
        hl = "MarkviewPalette0Fg"
    },

    ["mvnrepository%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette1Fg"
    },

    ["medium%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette6Fg"
    },

    ["linkedin%.com"] = {
        priority = -9999,

        icon = "󰌻 ",
        hl = "MarkviewPalette5Fg"
    },

    ["news%.ycombinator%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette2Fg"
    },
}
```

Each url links type has the following options.

```lua from: ../lua/markview/types/renderers/typst.lua class: markview.config.typst.url_links.opts
--- Configuration for a specific URL type.
---@alias markview.config.typst.url_links.opts markview.config.__inline
```

