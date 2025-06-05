# Typst options

>[!TIP]
> You can find type definitions in [definitions/typst.lua]().

Options that affect how typst is shown in previews are part of this. You can find the default values [here]().

```lua
typst = {
    enable = true,

    code_blocks = {
        enable = true,

        style = "block",
        text_direction = "right",

        min_width = 60,
        pad_amount = 3,
        pad_char = " ",

        text = "󰣖 Code",

        hl = "MarkviewCode",
        text_hl = "MarkviewIcon5"
    },

    code_spans = {
        enable = true,

        padding_left = " ",
        padding_right = " ",

        hl = "MarkviewCode"
    },

    escapes = {
        enable = true
    },

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

    labels = {
        enable = true,

        default = {
            hl = "MarkviewInlineCode",
            padding_left = " ",
            icon = " ",
            padding_right = " "
        }
    },

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
        }
    },

    math_blocks = {
        enable = true,

        text = " 󰪚 Math ",
        pad_amount = 3,
        pad_char = " ",

        hl = "MarkviewCode",
        text_hl = "MarkviewCodeInfo"
    },

    math_spans = {
        enable = true,

        padding_left = " ",
        padding_right = " ",

        hl = "MarkviewInlineCode"
    },

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

    raw_spans = {
        enable = true,

        padding_left = " ",
        padding_right = " ",

        hl = "MarkviewInlineCode"
    },

    reference_links = {
        enable = true,

        default = {
            icon = " ",
            hl = "MarkviewHyperlink"
        },
    },

    subscripts = {
        enable = true,

        hl = "MarkviewSubscript"
    },

    superscripts = {
        enable = true,

        hl = "MarkviewSuperscript"
    },

    symbols = {
        enable = true,

        hl = "Special"
    },

    terms = {
        enable = true,

        default = {
            text = " ",
            hl = "MarkviewPalette6Fg"
        },
    },

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
    }
},
```

## enable

- type: `boolean`
  default: `true`

Allows viewing typst in preview.

## code_blocks

- type: [markview.config.typst.code_blocks]()
  [default]()

Changes how code blocks look.

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

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

### hl

- type: `string`
  default: `"MarkviewCode"`

Highlight group used for the background.

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

<h3 id="code_block_sign">sign<h3>

- type: `string`

Text to show in the signcolumn.

### sign_hl

- type: `string`

Highlight group used for the [sign](#code_block_sign).

### style

- type: `"simple" | "block"`
  default: `"block"`

Changes how code blocks are shown. Supported values are,

+ `"simple"`
  Entire line is highlighted. Useful when `wrap` is enabled.

+ `"block"`
  A block is created around the code block and paddings are added before & after each line.

<h3 id="code_block_text">text</h3>

- type: `string`
  default: `"󰣖 Code"`

Text to show on the top-left/top-right side of the code block.

### text_direction

- type: `"left" | "right"`
  default: `"right"`

Changes which side [text](#code_block_text) should be shown on.

### text_hl

- type: `string`

Highlight group used for [text](#code_block_text).

## code_spans

- type: [markview.config.typst.code_spans]()
  [default]()

Changes how code spans look. See [how inline elements are configured]().

## escapes

- type: `{ enable: boolean }`
  default: `{ enable = true }`

Allows showing the escaped characters in previews.

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

## headings

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

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

### shift_width

- type: `integer`
  default: `1`

Number of spaces to add before the heading per level.

### heading_\[n\]

- type: [markview.config.typst.headings.opts]()

Configuration for level `n` headings.

#### hl

- type: `string`

Highlight group for the heading.

<h4 id="headings_icon">icon</h4>

>[!NOTE]
> This has no effect if [style](#headings_style) is set to `simple`.

- type: `string`

Text to add as icon before the heading text.

#### icon_hl

>[!NOTE]
> This has no effect if [style](#headings_style) is set to `simple`.

- type: `string`

Highlight group for [icon](#headings_icon).

<h4 id="headings_sign">sign</h4>

>[!NOTE]
> This has no effect if [style](#headings_style) is set to `simple`.

- type: `string`

Text to show in the signcolumn.

#### sign_hl

>[!NOTE]
> This has no effect if [style](#headings_style) is set to `simple`.

- type: `string`

Highlight group for [sign](#headings_sign).

<h4 id="heading_style">style</h4>

- type: `"simple" | "icon"`

Heading preview style. Possible values are,

+ `"simple"`,
  Only Highlight the line.

+ `"icon"`,
  Icons & signs with highlight.

## labels

- type: [markview.config.typst.labels]()
  [default]()

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

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

<h3 id="labels_default">default</h3>

- type: [markview.config.__inline_generic]()
  [default]()

Default configuration for labels. See [how inline elements are configured]().

<h3 id="labels_string">\[string\]</h3>

- type: [markview.config.__inline_generic]()
  [default]()

Configuration for labels whose text matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for labels is `<<text>>`.

## list_items

- type: [markview.config.markdown.list_items]()
  [default]()

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
    }
},
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

### indent_size

- type: `integer | fun(bufnr: integer): integer`

Indentation size in list items.

>[!IMPORTANT]
> Using tabs for indentation can cause incorrect indent to show up!

### shift_size

- type: `integer | fun(bufnr: integer): integer`
  default: `4`

Number of spaces to add per indent level of a list item.

### marker_dot

- type: [markview.config.markdown.list_items.ordered]()
  [default]()

Configuration for `N.` list items.

```lua
marker_parenthesis = {
    enable = true,

    add_padding = true,
    conceal_on_checkboxes = true
}
```

#### enable

- type: `boolean`
  default: `true`

Self-explanatory.

#### add_padding

- type: `boolean`
  default: `true`

Enables indentation in preview for this type of list items.

### marker_minus

- type: [markview.config.markdown.list_items.unordered]()
  [default]()

Configuration for `-` list items.

```lua
marker_minus = {
    enable = true,

    add_padding = true,
    conceal_on_checkboxes = true,

    text = "●",
    hl = "MarkviewListItemMinus"
}
```

#### enable

- type: `boolean`
  default: `true`

Self-explanatory.

#### add_padding

- type: `boolean`
  default: `true`

Enables indentation in preview for this type of list items.

<h4 id="list_text">text</h4>

- type: `string`
  default: `"●"`

Text used as the marker in preview.

#### hl

- type: `string`
  default: `"MarkviewListItemMinus"`

Highlight group for [text](#list_text).

### marker_plus

- type: [markview.config.markdown.list_items.unordered]()
  [default]()

Configuration for `+` list items. Same as [marker_minus](#marker_minus).

## math_blocks

- type: [markview.config.typst.math_blocks]()
  [default]()

Changes how math block are shown.

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

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

### hl

- type: `string`
  default: `"MarkviewCode"`

Highlight group used for the background.

### pad_amount

- type: `integer`
  default: `2`

Width of the left & right border/padding.

### pad_char

- type: `string`
  default: `" "`

Character used for the borders/paddings.

<h3 id="math_block_text">text<h3>

- type: `string`

Text to show in the signcolumn.

### text_hl

- type: `string`

Highlight group used for the [text](#math_block_text).

## math_spans

- type: [markview.config.__inline_generic]()
  [default]()

Changes how inline maths are shown. See [how inline elements are configured]().

## raw_blocks

- type: [markview.config.typst.raw_blocks]()
  [default]()

See also,

- [icon_provider](), for disabling icons.

Changes how raw blocks look.

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
  default: `"right"`

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
  default: `"block"`

Changes how code blocks are shown. Supported values are,

+ `"simple"`
  Entire line is highlighted. Useful when `wrap` is enabled.

+ `"block"`
  A block is created around the code block and paddings are added before & after each line.

### sign

- type: `boolean`
  default: `true`

Enables language icon in the signcolumn.

## reference_links

- type: [markview.config.types.link_ref]()
  [default]()

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

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

### default

- type: [markview.config.__inline_generic]()
  [default]()

Default configuration. See [how inline elements are configured]().

### \[string\]

- type: [markview.config.__inline_generic]()
  [default]()

Configuration for reference links whose destination matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for reference links is `@<destination>`.

## subscripts

- type: [markview.config.typst.subscripts]()
  [default]()

Configuration for subscript texts.

```lua
subscripts = {
    enable = true,

    hl = "MarkviewSubscript",
    marker_left = nil,
    marker_right = nil,
},
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

### hl

- type: `string`
  default: `"MarkviewSubscript"`

Highlight group.

### marker_left

- type: `string`

Marker to show before subscript text.

>[!NOTE]
> This only shows up if the text can't be shown as subscripted text.

### marker_right

- type: `string`

Marker to show after subscript text.

>[!NOTE]
> This only shows up if the text can't be shown as subscripted text.

## superscripts

- type: [markview.config.typst.superscripts]()
  [default]()

Configuration for superscript texts. Same as [subscripts](#subscripts).

```lua
superscripts = {
    enable = true,

    hl = "MarkviewSuperscript",
    marker_left = nil,
    marker_right = nil,
},
```

## symbols

- type: [markview.config.typst.symbols]()
  [default]()

Configuration for symbols.

```lua
superscripts = {
    enable = true,

    hl = "Special",
    marker_left = nil,
    marker_right = nil,
},
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

### hl

- type: `string`
  default: `"Special"`

Highlight group.

## reference_links

- type: [markview.config.types.link_ref]()
  [default]()

Changes how reference links are shown.

```lua
terms = {
    enable = true,

    default = {
        text = " ",
        hl = "MarkviewPalette6Fg"
    },
},
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

### default

- type: [markview.config.__inline_generic]()
  [default]()

Default configuration. See [how inline elements are configured]().

### \[string\]

- type: [markview.config.__inline_generic]()
  [default]()

Configuration for terms whose label matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for terms is `/ <label>: @<destination>`.

## url_links

- type: [markview.config.typst.url_links]()
  [default]()

Changes how uri autolinks are shown.

```lua
url_links = {
    enable = true,

    default = {
        icon = "󰌷 ",
        hl = "MarkviewHyperlink",
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
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

<h3 id="url_links_default">default</h3>

- type: [markview.config.__inline_generic]()
  [default]()

Default configuration for URI autolinks. See [how inline elements are configured]().

<h3 id="url_links_string">\[string\]</h3>

- type: [markview.config.__inline_generic]()
  [default]()

Configuration for URL links whose text matches `string`. See [how inline elements are configured]().

