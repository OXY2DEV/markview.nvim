# Markdown options

>[!TIP]
> You can find the type definition in [definitions/markdown.lua]().

Options that change how different elements are shown in the preview. You can find the default value [here]().

```lua
---@type markview.config.markdown
markdown = {
    enable = true,

    block_quotes = {
        enable = true,
        wrap = true,

        default = {
            border = "▋",
            hl = "MarkviewBlockQuoteDefault"
        },

        ["ABSTRACT"] = {
            preview = "󱉫 Abstract",
            hl = "MarkviewBlockQuoteNote",

            title = true,
            icon = "󱉫",
        },
        ["SUMMARY"] = {
            hl = "MarkviewBlockQuoteNote",
            preview = "󱉫 Summary",

            title = true,
            icon = "󱉫",
        },
        ["TLDR"] = {
            hl = "MarkviewBlockQuoteNote",
            preview = "󱉫 Tldr",

            title = true,
            icon = "󱉫",
        },
        ["TODO"] = {
            hl = "MarkviewBlockQuoteNote",
            preview = " Todo",

            title = true,
            icon = "",
        },
        ["INFO"] = {
            hl = "MarkviewBlockQuoteNote",
            preview = " Info",

            custom_title = true,
            icon = "",
        },
        ["SUCCESS"] = {
            hl = "MarkviewBlockQuoteOk",
            preview = "󰗠 Success",

            title = true,
            icon = "󰗠",
        },
        ["CHECK"] = {
            hl = "MarkviewBlockQuoteOk",
            preview = "󰗠 Check",

            title = true,
            icon = "󰗠",
        },
        ["DONE"] = {
            hl = "MarkviewBlockQuoteOk",
            preview = "󰗠 Done",

            title = true,
            icon = "󰗠",
        },
        ["QUESTION"] = {
            hl = "MarkviewBlockQuoteWarn",
            preview = "󰋗 Question",

            title = true,
            icon = "󰋗",
        },
        ["HELP"] = {
            hl = "MarkviewBlockQuoteWarn",
            preview = "󰋗 Help",

            title = true,
            icon = "󰋗",
        },
        ["FAQ"] = {
            hl = "MarkviewBlockQuoteWarn",
            preview = "󰋗 Faq",

            title = true,
            icon = "󰋗",
        },
        ["FAILURE"] = {
            hl = "MarkviewBlockQuoteError",
            preview = "󰅙 Failure",

            title = true,
            icon = "󰅙",
        },
        ["FAIL"] = {
            hl = "MarkviewBlockQuoteError",
            preview = "󰅙 Fail",

            title = true,
            icon = "󰅙",
        },
        ["MISSING"] = {
            hl = "MarkviewBlockQuoteError",
            preview = "󰅙 Missing",

            title = true,
            icon = "󰅙",
        },
        ["DANGER"] = {
            hl = "MarkviewBlockQuoteError",
            preview = " Danger",

            title = true,
            icon = "",
        },
        ["ERROR"] = {
            hl = "MarkviewBlockQuoteError",
            preview = " Error",

            title = true,
            icon = "",
        },
        ["BUG"] = {
            hl = "MarkviewBlockQuoteError",
            preview = " Bug",

            title = true,
            icon = "",
        },
        ["EXAMPLE"] = {
            hl = "MarkviewBlockQuoteSpecial",
            preview = "󱖫 Example",

            title = true,
            icon = "󱖫",
        },
        ["QUOTE"] = {
            hl = "MarkviewBlockQuoteDefault",
            preview = " Quote",

            title = true,
            icon = "",
        },
        ["CITE"] = {
            hl = "MarkviewBlockQuoteDefault",
            preview = " Cite",

            title = true,
            icon = "",
        },
        ["HINT"] = {
            hl = "MarkviewBlockQuoteOk",
            preview = " Hint",

            title = true,
            icon = "",
        },
        ["ATTENTION"] = {
            hl = "MarkviewBlockQuoteWarn",
            preview = " Attention",

            title = true,
            icon = "",
        },

        ["NOTE"] = {
            hl = "MarkviewBlockQuoteNote",
            preview = "󰋽 Note",
        },
        ["TIP"] = {
            hl = "MarkviewBlockQuoteOk",
            preview = " Tip",
        },
        ["IMPORTANT"] = {
            hl = "MarkviewBlockQuoteSpecial",
            preview = " Important",
        },
        ["WARNING"] = {
            hl = "MarkviewBlockQuoteWarn",
            preview = " Warning",
        },
        ["CAUTION"] = {
            hl = "MarkviewBlockQuoteError",
            preview = "󰳦 Caution",
        }
    },

    code_blocks = {
        enable = true,

        style = "block",

        label_direction = "right",

        border_hl = "MarkviewCode",
        info_hl = "MarkviewCodeInfo",

        min_width = 60,
        pad_amount = 2,
        pad_char = " ",

        sign = true,

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

    headings = {
        enable = true,

        shift_width = 1,

        org_indent = false,
        org_indent_wrap = true,
        org_shift_char = " ",
        org_shift_width = 1,

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
        },

        setext_1 = {
            style = "decorated",

            sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",
            icon = "  ", hl = "MarkviewHeading1",
            border = "▂"
        },
        setext_2 = {
            style = "decorated",

            sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",
            icon = "  ", hl = "MarkviewHeading2",
            border = "▁"
        }
    },

    horizontal_rules = {
        enable = true,

        parts = {
            {
                type = "repeating",
                direction = "left",

                repeat_amount = function (buffer)
                    local utils = require("markview.utils");
                    local window = utils.buf_getwin(buffer)

                    local width = vim.api.nvim_win_get_width(window)
                    local textoff = vim.fn.getwininfo(window)[1].textoff;

                    return math.floor((width - textoff - 3) / 2);
                end,

                text = "─",

                hl = {
                    "MarkviewGradient1", "MarkviewGradient1",
                    "MarkviewGradient2", "MarkviewGradient2",
                    "MarkviewGradient3", "MarkviewGradient3",
                    "MarkviewGradient4", "MarkviewGradient4",
                    "MarkviewGradient5", "MarkviewGradient5",
                    "MarkviewGradient6", "MarkviewGradient6",
                    "MarkviewGradient7", "MarkviewGradient7",
                    "MarkviewGradient8", "MarkviewGradient8",
                    "MarkviewGradient9", "MarkviewGradient9"
                }
            },
            {
                type = "text",

                text = "  ",
                hl = "MarkviewIcon3Fg"
            },
            {
                type = "repeating",
                direction = "right",

                repeat_amount = function (buffer) --[[@as function]]
                    local utils = require("markview.utils");
                    local window = utils.buf_getwin(buffer)

                    local width = vim.api.nvim_win_get_width(window)
                    local textoff = vim.fn.getwininfo(window)[1].textoff;

                    return math.ceil((width - textoff - 3) / 2);
                end,

                text = "─",
                hl = {
                    "MarkviewGradient1", "MarkviewGradient1",
                    "MarkviewGradient2", "MarkviewGradient2",
                    "MarkviewGradient3", "MarkviewGradient3",
                    "MarkviewGradient4", "MarkviewGradient4",
                    "MarkviewGradient5", "MarkviewGradient5",
                    "MarkviewGradient6", "MarkviewGradient6",
                    "MarkviewGradient7", "MarkviewGradient7",
                    "MarkviewGradient8", "MarkviewGradient8",
                    "MarkviewGradient9", "MarkviewGradient9"
                }
            }
        }
    },

    list_items = {
        enable = true,
        wrap = true,

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
            conceal_on_checkboxes = true,

            text = "●",
            hl = "MarkviewListItemMinus"
        },

        marker_plus = {
            add_padding = true,
            conceal_on_checkboxes = true,

            text = "◈",
            hl = "MarkviewListItemPlus"
        },

        marker_star = {
            add_padding = true,
            conceal_on_checkboxes = true,

            text = "◇",
            hl = "MarkviewListItemStar"
        },

        marker_dot = {
            add_padding = true,
            conceal_on_checkboxes = true
        },

        marker_parenthesis = {
            add_padding = true,
            conceal_on_checkboxes = true
        }
    },

    metadata_minus = {
        enable = true,

        hl = "MarkviewCode",
        border_hl = "MarkviewCodeFg",

        border_top = "▄",
        border_bottom = "▀"
    },

    metadata_plus = {
        enable = true,

        hl = "MarkviewCode",
        border_hl = "MarkviewCodeFg",

        border_top = "▄",
        border_bottom = "▀"
    },

    reference_definitions = {
        enable = true,

        default = {
            icon = " ",
            hl = "MarkviewPalette4Fg"
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

            icon = " ",
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
    },

    tables = {
        enable = true,
        strict = false,

        col_min_width = 10,
        block_decorator = true,
        use_virt_lines = false,

        parts = {
            top = { "╭", "─", "╮", "┬" },
            header = { "│", "│", "│" },
            separator = { "├", "─", "┤", "┼" },
            row = { "│", "│", "│" },
            bottom = { "╰", "─", "╯", "┴" },

            overlap = { "┝", "━", "┥", "┿" },

            align_left = "╼",
            align_right = "╾",
            align_center = { "╴", "╶" }
        },

        hl = {
            top = { "TableHeader", "TableHeader", "TableHeader", "TableHeader" },
            header = { "TableHeader", "TableHeader", "TableHeader" },
            separator = { "TableHeader", "TableHeader", "TableHeader", "TableHeader" },
            row = { "TableBorder", "TableBorder", "TableBorder" },
            bottom = { "TableBorder", "TableBorder", "TableBorder", "TableBorder" },

            overlap = { "TableBorder", "TableBorder", "TableBorder", "TableBorder" },

            align_left = "TableAlignLeft",
            align_right = "TableAlignRight",
            align_center = { "TableAlignCenter", "TableAlignCenter" }
        }
    },
},
```

## enable

- type: `boolean`
  default: `true`

Enables previewing of markdown.

## block_quotes

- type: [markview.config.markdown.block_quotes]()
  [default]()

Changes how block quotes look. Each key in the table(other then `enable`, `wrap` & `default`) represents a new callout type.

When matching a callout to it's configuration the key is matched **case insensitively**, meaning `["NOTE"] = {}` in the config will match `>[!NOTE]`, `>[!Note]`, `>[!NoTe]` & any other variations of this text.

```lua
block_quotes = {
    enable = true,
    wrap = true,

    default = {
        border = "▋",
        hl = "MarkviewBlockQuoteDefault"
    },

    ["ABSTRACT"] = {
        preview = "󱉫 Abstract",
        hl = "MarkviewBlockQuoteNote",

        title = true,
        icon = "󱉫",
    },
    ["SUMMARY"] = {
        hl = "MarkviewBlockQuoteNote",
        preview = "󱉫 Summary",

        title = true,
        icon = "󱉫",
    },
    ["TLDR"] = {
        hl = "MarkviewBlockQuoteNote",
        preview = "󱉫 Tldr",

        title = true,
        icon = "󱉫",
    },
    ["TODO"] = {
        hl = "MarkviewBlockQuoteNote",
        preview = " Todo",

        title = true,
        icon = "",
    },
    ["INFO"] = {
        hl = "MarkviewBlockQuoteNote",
        preview = " Info",

        custom_title = true,
        icon = "",
    },
    ["SUCCESS"] = {
        hl = "MarkviewBlockQuoteOk",
        preview = "󰗠 Success",

        title = true,
        icon = "󰗠",
    },
    ["CHECK"] = {
        hl = "MarkviewBlockQuoteOk",
        preview = "󰗠 Check",

        title = true,
        icon = "󰗠",
    },
    ["DONE"] = {
        hl = "MarkviewBlockQuoteOk",
        preview = "󰗠 Done",

        title = true,
        icon = "󰗠",
    },
    ["QUESTION"] = {
        hl = "MarkviewBlockQuoteWarn",
        preview = "󰋗 Question",

        title = true,
        icon = "󰋗",
    },
    ["HELP"] = {
        hl = "MarkviewBlockQuoteWarn",
        preview = "󰋗 Help",

        title = true,
        icon = "󰋗",
    },
    ["FAQ"] = {
        hl = "MarkviewBlockQuoteWarn",
        preview = "󰋗 Faq",

        title = true,
        icon = "󰋗",
    },
    ["FAILURE"] = {
        hl = "MarkviewBlockQuoteError",
        preview = "󰅙 Failure",

        title = true,
        icon = "󰅙",
    },
    ["FAIL"] = {
        hl = "MarkviewBlockQuoteError",
        preview = "󰅙 Fail",

        title = true,
        icon = "󰅙",
    },
    ["MISSING"] = {
        hl = "MarkviewBlockQuoteError",
        preview = "󰅙 Missing",

        title = true,
        icon = "󰅙",
    },
    ["DANGER"] = {
        hl = "MarkviewBlockQuoteError",
        preview = " Danger",

        title = true,
        icon = "",
    },
    ["ERROR"] = {
        hl = "MarkviewBlockQuoteError",
        preview = " Error",

        title = true,
        icon = "",
    },
    ["BUG"] = {
        hl = "MarkviewBlockQuoteError",
        preview = " Bug",

        title = true,
        icon = "",
    },
    ["EXAMPLE"] = {
        hl = "MarkviewBlockQuoteSpecial",
        preview = "󱖫 Example",

        title = true,
        icon = "󱖫",
    },
    ["QUOTE"] = {
        hl = "MarkviewBlockQuoteDefault",
        preview = " Quote",

        title = true,
        icon = "",
    },
    ["CITE"] = {
        hl = "MarkviewBlockQuoteDefault",
        preview = " Cite",

        title = true,
        icon = "",
    },
    ["HINT"] = {
        hl = "MarkviewBlockQuoteOk",
        preview = " Hint",

        title = true,
        icon = "",
    },
    ["ATTENTION"] = {
        hl = "MarkviewBlockQuoteWarn",
        preview = " Attention",

        title = true,
        icon = "",
    },

    ["NOTE"] = {
        hl = "MarkviewBlockQuoteNote",
        preview = "󰋽 Note",
    },
    ["TIP"] = {
        hl = "MarkviewBlockQuoteOk",
        preview = " Tip",
    },
    ["IMPORTANT"] = {
        hl = "MarkviewBlockQuoteSpecial",
        preview = " Important",
    },
    ["WARNING"] = {
        hl = "MarkviewBlockQuoteWarn",
        preview = " Warning",
    },
    ["CAUTION"] = {
        hl = "MarkviewBlockQuoteError",
        preview = "󰳦 Caution",
    }
}
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

### wrap

- type: `boolean`
  default: `true`

Enables `wrap` support, which causes block quote's border to appear where the text gets wrapped.

|  `wrap = true` | `wrap = false`  |
|----------------|-----------------|
| ![wrap_true]() | ![wrap_false]() |

>[!CAUTION]
> Detecting where to show the border is done manually, sometimes it may be incorrect(e.g. after resizing the Terminal).

### default

- type: [markview.config.markdown.block_quotes.opts]()
  [default]()

Configuration for regular block quotes.

```lua
default = {
    border = nil,
    hl = nil
}
```

#### border

- type: `string`
  default: `"▋"`

Text used for the border.

#### hl

- type: `string`
  default: `"MarkviewBlockQuoteDefault"`

Highlight group for the [border](#-border).

### \[string\]

- type: [markview.config.markdown.block_quotes.opts]()
  [default]()

Configuration for `>[!string]` callout.

```lua
["TEST"] = {
    border = nil,
    border_hl = nil,

    hl = nil,

    icon = nil,
    icon_hl = nil,

    preview = nil,
    preview_hl = nil,

    title = true,
},
```

<h4 id="border_callout"></h4>

- type: `string`

Text used for the border.

#### border_hl

- type: `string`

Highlight group for the [border](#border_callout).

#### hl

- type: `string`

Highlight group for this callout. [border_hl](#border_hl), [icon_hl](#icon_hl) & [preview_hl](#preview_hl) use this value when they are unset.

#### icon

- type: `string`

Text used as an icon.

>[!NOTE]
> This only works if [title](#title) is set to `true`.

#### icon_hl

- type: `string`

Highlight group for [icon](#icon).

#### preview

- type: `string`

Text shown instead of `>[!...]`.

#### preview_hl

- type: `string`

Highlight group for [icon](#preview).

#### title

- type: `boolean`

Enables Obsidian-style titles in callouts.

>[!NOTE]
> Titles have the following structure `>[!<callout>] <title>`

## code_blocks

- type: [markview.config.markdown.code_blocks]()
  [default]()

Changes how fenced code blocks look.

```lua
code_blocks = {
    enable = true,

    border_hl = "MarkviewCode",
    info_hl = "MarkviewCodeInfo",

    label_direction = "right",
    label_hl = nil,

    min_width = 60,
    pad_amount = 2,
    pad_char = " ",

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
    },

    style = "block",
    sign = true,
},
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

### border_hl

- type: `string`
  default: `"MarkviewCode"`

Highlight group used for the top & bottom part of the code block.

### info_hl

- type: `string`
  default: `"MarkviewCodeInfo"`

Highlight group used for the info string.

### label_direction

- type: `"left" | "right"`
  default: `"left"`

Which side the language name & icon should be shown on.

### label_hl

- type: `string`

Highlight group used for the language name & icon.

>[!TIP]
> This can be used to overwrite the highlight group set by the [icon_provider]()!

### min_width

- type: `integer`
  default: `60`

Minimum width of code blocks.

### pad_amount

- type: `integer`
  default: `2`

Width of the left & right border/padding.

### pad_char

- type: `string`
  default: `" "`

Character used for the borders/paddings.

### default

- type: [markview.config.markdown.code_blocks.opts]()
  [default]()

Default configuration for highlighting a line of the code block.

```lua
default = {
    block_hl = "MarkviewCode",
    pad_hl = "MarkviewCode"
},
```

#### block_hl

- type: `string`
  default: `"MarkviewCode"`

Highlight group for the text of a line.

#### pad_hl

- type: `string`
  default: `"MarkviewCode"`

Highlight group for the padding around the line.

### \[string\]

- type: [markview.config.markdown.code_blocks.opts]()

Configuration for code blocks whose language is `string`.

```lua
["string"] = {
    block_hl = nil,
    pad_hl = nil
},
```

>[!TIP]
> You can use this for making stuff like `diff` prettier!

#### block_hl

- type: `string | fun(bufnr: integer, line: string): string`

Highlight group for the text of a line.

#### pad_hl

- type: `string | fun(bufnr: integer, line: string): string`

Highlight group for the padding around the line.

### style

- type: `"simple" | "block"`
  default: `"MarkviewCode"`

Highlight group used for the top & bottom part of the code block.

