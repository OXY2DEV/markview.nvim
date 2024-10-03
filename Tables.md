# Tables

![Tables](https://github.com/OXY2DEV/markview.nvim/blob/images/Wiki/tables.jpg)

```lua
tables = {
    enable = true,

    --- Parts for the table border.
    ---@type { [string]: string[] }
    text = {
        top       = { "╭", "─", "╮", "┬" },
        header    = { "│", "│", "│" },
        separator = { "├", "┼", "┤", "─" },
        row       = { "│", "│", "│" },
        bottom    = { "╰", "─", "╯", "┴" },

        align_left = "╼",
        align_right = "╾",
        align_center = { "╴", "╶",}
    },

    --- Highlight groups for the "parts".
    ---@type { [string]: string[] }
    hls = {
        top       = { "TableHeader", "TableHeader", "TableHeader", "TableHeader" },
        header    = { "TableHeader", "TableHeader", "TableHeader" },
        separator = { "TableHeader", "TableHeader", "TableHeader", "TableHeader" },
        row       = { "TableBorder", "TableBorder", "TableBorder" },
        bottom    = { "TableBorder", "TableBorder", "TableBorder", "TableBorder" },

        align_left = "TableAlignLeft",
        align_right = "TableAlignRight",
        align_center = { "TableAlignCenter", "TableAlignCenter",}
    },

    --- Minimum width of a table cell
    ---@type integer?
    col_min_width = 5,

    --- When true, top & bottom borders aren't drawn
    ---@type boolean
    block_decorator = true,

    --- When true, top & bottom borders are made with
    --- virtual lines instead of virtual text.
    ---@type boolean
    use_virt_lines = true
}
```

