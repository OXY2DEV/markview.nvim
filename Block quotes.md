# 🚨 Block quotes

```lua
block_quotes = {
    enable = true,

    default = {
         border = "▋",
    },
    callouts = nil
}
```

## 🔩 Configuration option

- enable, `boolean` or nil

  For disabling rendering of block quotes.

- default, `table`

  Default Configuration for block quotes. It has the following options,

  - border, used to hide `>`.
  - border_hl, highlight group for border.

- callouts, `table` or nil

  A list containing configuration table for callouts/alerts.

## 🧰 Callout/Alert configuration

```lua
{
    match_string = "",

    callout_preview = "",
    callout_preview_hl = nil,

    custom_title = false,
    custom_icon = nil,

    border = "▋",
    border_hl = nil
}
```

- match_string, `string` or `table`

  String to use as the match pattern.

- callout_preview, `string`

  Text to show on the first line.

- callout_preview_hl, `string` or nil

  highlight group for **callout_preview**. Also applies to custom titles.

- custom_title, `boolean` or nil

  Allows showing the title of a callout instead of the preview string.

- custom_icon, `string` or nil

  Icon to add before **custom_title**.

- border, `string`

  String to use as the callout's border.

- border_hl, `string` or nil

  Highlight group for **border**.

