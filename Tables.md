# Tables

![tables](./wiki_img/tables.jpg)

This plugin uses custom `tables` which can be configured using the `tables` option.

```lua
tables = {
    enable = true,
    use_virt_lines = false,

    text = {
        "╭", "─", "╮", "┬",
        "├", "│", "┤", "┼",
        "╰", "─", "╯", "┴",

        -- These are used to indicate text alignment
        -- The last 2 are used for "center" alignment
        "╼", "╾", "╴", "╶"
    },

    hl = {
        "rainbow1", "rainbow1", "rainbow1", "rainbow1",
        "rainbow1", "rainbow1", "rainbow1", "rainbow1",
        "rainbow1", "rainbow1", "rainbow1", "rainbow1",

        "rainbow1", "rainbow1", "rainbow1", "rainbow1"
    }
}
```

## enable

Enables/Disables custom tables.

## use_virt_lines

When true, the top and bottom borders are created using `virt_lines` instead of `virt_text`.

## text

Parts to create the table.

## hl

Highlight groups for various parts.




