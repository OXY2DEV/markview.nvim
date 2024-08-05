# 📒 Tables

```lua
tables = {
    enable = true,
    use_virt_lines = false,

    text = {},
    hl = {}
}
```

## 🔩 Configuration options

- enable, `boolean` or nil

  Used for toggling rendering of tables.

- use_virt_lines, `boolean` or nil

  When `true` the top and bottom border of the table are made using virtual lines.

  Useful if you don't like adding spaces between tables. Disabled by default.

- text, `table`

  A list of **parts** to create the table.

- hl, `table` or nil

  A list of highlight groups to color `text`.

## 📐 Table parts

Both `text` & `hl` have the following structure.

```lua
{
--    Main parts    Seperators
    "╭", "─", "╮",      "┬",
    "├", "│", "┤",      "┼",
    "╰", "─", "╯",      "┴",

--    Alignment indicators
--   Left   right     center
    "╼",     "╾",    "╴", "╶"
}
```

Here's an example table,

| Col 1    |   Col 2   |    Col 3 |
|:---------|:---------:|---------:|
| 1        |     2     |        3 |
| 4        |     4     |        6 |



