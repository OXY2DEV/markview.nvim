# Inline codes

![Inline codes](https://github.com/OXY2DEV/markview.nvim/blob/images/Wiki/inline_codes.jpg)

```lua
inline_codes = {
    enable = true,

    --- Primary highlight group. Used by other
    --- options that end with "_hl" when their
    --- values are nil.
    ---@type string
    hl = "MarkviewHeading3",

    --- Left corner, Added before the left padding.
    ---@type string?
    corner_left = nil,

    --- Left padding, Added before the text.
    ---@type string?
    padding_left = nil,

    --- Right padding, Added after the text.
    ---@type string?
    padding_right = nil,

    --- Right corner, Added after the right padding.
    ---@type string?
    corner_right = nil,

    ---@type string?
    corner_left_hl = nil,
    ---@type string?
    padding_left_hl = nil,

    ---@type string?
    padding_right_hl = nil,
    ---@type string?
    corner_right_hl = nil,
}
```

