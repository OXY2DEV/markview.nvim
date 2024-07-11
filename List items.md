# Lists

![list_items](./wiki_img/list_items.jpg)

## Configuration options

The `list_items` option comes with these sub-options.

```lua
list_items = {
    enable = true,
    shift_width = 4,

    marker_plus = {},
    marker_minus = {},
    marler_star = {},

    marker_dot = {}
}
```

### Global options

These options affect all types of list items.

> enable
> `boolean or nil`

When set to `false`, list items are not rendered.

> shift_width
> `number or nil`

The number of spaces to add per level of the list item.

### List specific options

> marker_plus
> `table or nil`

Configuration table for list items that use `+`.

> marker_minus
> `table or nil`

Configuration table for list items that use `-`.

> marker_star
> `table or nil`

Configuration table for list items that use `*`.

> marker_dot
> `table or nil`

Configuration table for numbered list items.

### List item configuration options

Each of the list types have the following options.

```lua
marker_plus = {
    add_padding = true,
    
    text = "•",
    hl = "rainbow5"
}
```

> add_padding
> `boolean or nil`

When true, adds padding based on the item level & `shift_width`.

> text
> `string or nil`

Text to use as the marker for the list item.

> hl
> `string or nil`

Highlight group for `text`.

## Gallery

Wow, so empty 😐


