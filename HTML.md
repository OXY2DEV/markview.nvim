# HTML

![HTML](https://github.com/OXY2DEV/markview.nvim/blob/images/Wiki/html.jpg)

```lua
html = {
    enable = true,

    --- Tag renderer for tags that have an
    --- opening & closing tag.
    tags = {
        enable = true,

        --- Default configuration
        default = {
            --- When true, the tag is concealed.
            ---@type boolean
            conceal = false,

            --- Highlight group for the text inside
            --- of the tag
            ---@type string?
            hl = nil
        },

        --- Configuration for specific tag(s).
        --- The key is the tag and the value is the
        --- used configuration.
        configs = {
            b = { conceal = true, hl = "Bold" },
            u = { conceal = true, hl = "Underlined" },
        }
    },

    --- HTML entity configuration
    entities = {
        enable = true,

        --- Highlight group for the rendered entity.
        ---@type string?
        hl = nil
    }
}
```

