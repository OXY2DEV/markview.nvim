# Checkboxes

![Checkboxes](https://github.com/OXY2DEV/markview.nvim/blob/images/Wiki/checkboxes.jpg)

```lua
checkboxes = {
    enable = true,

    checked = {
        --- Text to show
        ---@type string
        text = "✔",

        --- Highlight group for "text"
        ---@type string?
        hl = "MarkviewCheckboxChecked",

        --- Highlight group to add to the body
        --- of the list item.
        ---@type string?
        scope_hl = nil
    },

    unchecked = {
        text = "✘", hl = "MarkviewCheckboxUnchecked",
        scope_hl = nil
    },

    --- Custom checkboxes configuration
    custom = {
        {
            --- Text inside []
            ---@type string
            match_string = "-",

            ---@type string
            text = "◯",

            ---@type string?
            hl = "MarkviewCheckboxPending",

            ---@type string?
            scope_hl = nil
        }
    }
}
```

