# Block quotes

![Block quotes](https://github.com/OXY2DEV/markview.nvim/blob/images/Wiki/block_quotes.jpg)

```lua
block_quotes = {
    enable = true,

    --- Default configuration for block quotes.
    default = {
        --- Text to use as border for the block
        --- quote.
        --- Can also be a list if you want multiple
        --- border types!
        ---@type string | string[]
        border = "▋",

        --- Highlight group for "border" option. Can also
        --- be a list to create gradients.
        ---@type (string | string[])?
        hl = "MarkviewBlockQuoteDefault"
    },

    --- Configuration for custom block quotes
    callouts = {
        {
            --- String between "[!" & "]"
            ---@type string
            match_string = "ABSTRACT",

            --- Primary highlight group. Used by other options
            --- that end with "_hl" when their values are nil.
            ---@type string?
            hl = "MarkviewBlockQuoteNote",

            --- Text to show in the preview.
            ---@type string
            preview = "󱉫 Abstract",

            --- Highlight group for the preview text.
            ---@type string?
            preview_hl = nil,

            --- When true, adds the ability to add a title
            --- to the block quote.
            ---@type boolean
            title = true,

            --- Icon to show before the title.
            ---@type string?
            icon = "󱉫 ",

            ---@type string | string
            border = "▋",

            ---@type (string | string[])?
            border_hl = nil
        },
    }
}
```

