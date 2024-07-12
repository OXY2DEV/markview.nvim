# Inline codes

## Configuration options

The `inline_codes` option comes with these sub-options.

```lua
inline_codes = {
    enable = true,

    hl = nil,

    corner_left = "", corner_left_hl = nil,
    padding_left = "", padding_left_hl = nil,

    icon = "", icon_hl = nil,

    padding_right = "", padding_right_hl = nil,
    corner_right = "", corner_right_hl = nil
}
```

How the following sub-options are applied is given below.

```txt
█▒ Link ▒█
││└──┬─┘│└─ corner_right
││   │  └── padding_right
││   └───── text [Not an option]
│└───────── padding_left
└────────── corner_left

```

> corner_left
> `string or nil`

The string to use as the left corner of **inline codes**.

> corner_left_hl*
> `string or nil`

Name of the highlight group to use for `corner_left`.

> padding_left
> `string or nil`

The string to use as the left padding of **inline codes**.

> padding_left_hl*
> `string or nil`

Name of the highlight group to use for `padding_left`.


> icon
> `string or nil`

The string to use as the icon for the link.

> icon_hl*
> `string or nil`

Name of the highlight group to use for `icon`.


> padding_right
> `string or nil`

The string to use as the right padding of **inline codes**.

> padding_right_hl*
> `string or nil`

Name of the highlight group to use for `padding_right`.

> corner_right
> `string or nil`

The string to use as the right corner of **links**.

> corner_right_hl*
> `string or nil`

Name of the highlight group to use for `corner_right`.

## Gallery

Wow, so empty 😐
