# 🔗 Links

```lua
links = {
    enable = true,

    hyperlinks = {},
    images = {},
    emails = {}
}
```

## 🔩 Configuration options

- enable, `boolean` or nil

  Used for toggling the rendering of links.

- hyperlinks, `table`

  Configuration table for normal links.

- images, `table`

  Configuration table for image links.

- emails, `table`

  Configuration table for email links.

## 🧭 Link configuration

- hl, `string` or nil

  Default highlight group for the links.

- corner_left, `string` or nil

  Text used as the left corner of the links.

- corner_left_hl, `string` or nil

  Highlight group for `corner_left`.

- padding_left, `string` or nil

  Text used as the left padding of the links.

- padding_left_hl, `string` or nil

  Highlight group for `padding_left`.

- padding_right, `string` or nil

  Text used as the right padding of the links.

- padding_right_hl, `string` or nil

  Highlight group for `padding_right`.

- corner_right, `string` or nil

  Text used as the right corner of the links.

- corner_right_hl, `string` or nil

  Highlight group for `corner_right`.

- custom, `table` or nil

  **Only for hyperlinks**, A list of configuration tables allowing customization of how the link is shown based on a match pattern.

## 🚀 Custom hyperlinks

```lua
custom = {
    {
        match = "^https://",
        icon = "✔ "
    }
}
```

Custom config for *hyperlinks* captured by `match`.

Supports all the previously mentioned options.


