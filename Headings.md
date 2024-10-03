# Headings

![Headings](https://github.com/OXY2DEV/markview.nvim/blob/images/Wiki/headings.jpg)

```lua
headings = {
    enable = true,

    --- Amount of character to shift per heading level
    ---@type integer
    shift_width = 1,

    heading_1 = {
        style = "simple",

        --- Background highlight group.
        ---@type string
        hl = "MarkviewHeading1"
    },
    heading_2 = {
        style = "icon",

        --- Primary highlight group. Used by other
        --- options that end with "_hl" when their
        --- values are nil.
        ---@type string
        hl = "MarkviewHeading2",

        --- Character used to shift/indent the heading
        ---@type string
        shift_char = " ",

        --- Highlight group for the "shift_char"
        ---@type string?
        shift_hl = "MarkviewHeading2Sign",

        --- Text to show on the signcolumn
        ---@type string?
        sign = "󰌕 ",

        --- Highlight group for the sign
        ---@type string?
        sign_hl = "MarkviewHeading2Sign",

        --- Icon to show before the heading text
        ---@type string?
        icon = "󰼏  ",

        --- Highlight group for the Icon
        ---@type string?
        icon_hl = "MarkviewHeading2"
    },
    heading_3 = {
        style = "label",

        --- Alignment of the heading.
        ---@type "left" | "center" | "right"
        align = "center",

        --- Primary highlight group. Used by other
        --- options that end with "_hl" when their
        --- values are nil.
        ---@type string
        hl = "MarkviewHeading3",

        --- Left corner, Added before the left padding
        ---@type string?
        corner_left = "",

        --- Left padding, Added before the icon
        ---@type string?
        padding_left = " ",

        --- Right padding, Added after the heading text
        ---@type string?
        padding_right = " ",

        --- Right corner, Added after the right padding
        ---@type string?
        corner_right = "",

        ---@type string?
        corner_left_hl = "MarkviewHeading3Sign",
        ---@type string?
        padding_left_hl = nil,

        ---@type string?
        padding_right_hl = nil,
        ---@type string?
        corner_right_hl = "MarkviewHeading3Sign",

        --- Text to show on the signcolumn.
        ---@type string?
        sign = "󰌕 ",

        --- Highlight group for the sign.
        ---@type string?
        sign_hl = "MarkviewHeading3Sign",

        --- Icon to show before the heading text.
        ---@type string?
        icon = "",

        --- Highlight group for the Icon.
        ---@type string?
        icon_hl = "MarkviewHeading3"
    },
    heading_4 = {},
    heading_5 = {},
    heading_6 = {},

    setext_1 = {
        style = "simple",

        --- Background highlight group.
        ---@type string
        hl = "MarkviewHeading1"
    },
    setext_2 = {
        style = "decorated",

        --- Text to show on the signcolumn.
        ---@type string?
        sign = "󰌕 ",

        --- Highlight group for the sign.
        ---@type string?
        sign_hl = "MarkviewHeading2Sign",

        --- Icon to show before the heading text.
        ---@type string?
        icon = "  ",

        --- Highlight group for the Icon.
        ---@type string?
        icon_hl = "MarkviewHeading2",

        --- Bottom border for the heading.
        ---@type string?
        border = "▂",

        --- Highlight group for the bottom border.
        ---@type string?
        border_hl = "MarkviewHeading2"
    }
}
```

