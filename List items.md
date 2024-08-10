# 🧾 List items

```lua
list_items = {
    enable = true,
    shift_width = 4,
    indent_size = 2,

    marker_minus = {},
    marker_plus = {},
    marker_star = {},
    marker_dot = {}
}
```

## 🔩 Configuration options

- enable, `boolean` or nil

  Used for toggling list item rendering.

- shift_width, `number`

  Number of spaces to add per indent level of the list item.

- indent_size, `number`

  Indentation size of list items.

- marker_plus, `table`

  Configuration table for list items made with `+`.

- marker_minus, `table`

  Configuration table for list items made with `-`.

- marker_star, `table`

  Configuration table for list items made with `*`.

- marker_dot, `table`

  Configuration table for numbered list.

## 🚀 List item configuration

Each list type has the following options.

- add_padding, `boolean` or nil

  Enables adding padding before lost items.

  >[!NOTE]
  > List items are indented by 2 spaces(not 4).

- text, `string`

  Text to use as the marker when rendered. Not supported by **marker_dot**.

- hl, `string` or nil

  Highlight group for `text`.

