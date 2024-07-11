# Tables

![tables](./wiki_img/tables.jpg)

## Configuration options

The `tables` option comes with these sub-options.

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

> enable
> `boolean or nil`

When set to `false`, tables are not rendered.

> use_virt_lines
> `boolean or nil`

When set to `true`, the top and bottom borders are created using `virt_lines` instead of `virt_text`.

> text
> `string[]`

List of 12 items to make the table.

> hl
> `string[] or nil`

Highlight groups for `text`.

## Gallery

Wow, so empty 😐

