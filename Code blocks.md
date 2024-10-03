# Code blocks

![Code blocks](https://github.com/OXY2DEV/markview.nvim/blob/images/Wiki/code_blocks.jpg)

```lua
code_blocks = {
    enable = true,

    --- Icon provider for the block icons & signs.
    ---
    --- Possible values are,
    ---   • "devicons", Uses `nvim-web-devicons`.
    ---   • "mini", Uses `mini.icons`.
    ---   • "internal", Uses the internal icon provider.
    ---   • "", Disables icons
    ---
    ---@type "devicons" | "mini" | "internal" | ""
    icons = "internal",

    --- Render style for the code block.
    ---
    --- Possible values are,
    ---   • "simple", Simple line highlighting.
    ---   • "minimal", Box surrounding the code block.
    ---   • "language", Signs, icons & much more.
    ---
    ---@type "simple" | "minimal" | "language"
    style = "language",

    --- Primary highlight group.
    --- Used by other options that end with "_hl" when
    --- their values are nil.
    ---@type string
    hl = "MarkviewCode",

    --- Highlight group for the info string
    ---@type string
    info_hl = "MarkviewCodeInfo",

    --- Minimum width of a code block.
    ---@type integer
    min_width = 40,

    --- Left & right padding amount
    ---@type integer
    pad_amount = 3,

    --- Character to use as whitespace
    ---@type string?
    pad_char = " ",

    --- Table containing various code block language names
    --- and the text to show.
    --- e.g. { cpp = "C++" }
    ---@type { [string]: string }
    language_names = nil,

    --- Direction of the language preview
    ---@type "left" | "right"
    language_direction = "right",

    --- Enables signs
    ---@type boolean
    sign = true,

    --- Highlight group for the sign
    ---@type string?
    sign_hl = nil
}
```

## Style: simple

```lua
code_blocks = {
    style = "simple",
    hl = "MarkviewCode"
}
```

## Style: minimal

```lua
code_blocks = {
    style = "minimal",

    min_width = 60,
    pad_char = " ",
    pad_amount = 3,

    hl = "MarkviewCode"
}
```

## Style: language

```lua
code_blocks = {
    style = "language",

    language_direction = "right",
    min_width = 60,
    pad_char = " ",
    pad_amount = 3,

    language_names = {
        ["txt"] = "Text"
    },

    hl = "MarkviewCode",
    info_hl = "MarkviewCodeInfo",

    sign = true,
    sign_hl = nil
}
```

