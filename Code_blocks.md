# Code blocks

![code_blocks](./wiki_img/code_blocks.jpg)

You can customise how `code blocks` are shown.

## Configuration

The configuration table for `code blocks` is given below.

```lua
code_blocks = {
    enable = true,
    style = "language",

    hl = nil,

    language_direction = "right",
    language_names = {},
    name_hl = nil,

    min_width = 70,
    pad_amount = 2,
    pad_char = " ",

    position = "overlay",

    sign = true,
    sign_hl = nil
}
```

### enable

A boolean, enables/disables custom `code blocks`.

### style

A string, name of the style to use.

Currently available styles are,

- simple, Adds a background color to the code blocks.
- minimal, Adds padding to the code block and better background.
- language, Shows language name, signs and better code block highlighting.

### hl

Only available in the `language` style.

A string value, highlight group for the background.

### language_direction

Only available in the `language` style.

A string value, changes the position where the language name & icons are shown.

Available values are,

- left
- right(default)

### language_names

Only available in the `language` style.

A list of `tuples` where the first value is the string to match and the second value is the string to display.

You can use this for languages like `C++` & `python` where the language name is different than what is written in the code blocks.

### name_hl

Only available in the `language` style.

Highlight group for `language_names`, when nil the color of the icon is used.

### min_width

Only available in the `minimal` & `language` style.

A number value used as the `minimum width` for the code blocks. The paddings are not counted in this.

If the size of the code block is larger than the largest line's length is used.

### pad_amount

Only available in the `minimal` & `language` style.

The number of times `pad_char` will be repeated for the paddings.

### pad_char

Only available in the `minimal` & `language` style.

The string that will be used by the code block's padding. It will be repeated by the value of `pad_amount

### position

Only available in the `minimal` & `language` style.

A string value, can be used to change how the `top` & `bottom` borders are positioned. When nil, `inline` will be used.

### sign

Only available in the `language` style.

A boolean value to enable/disable the signs.

### sign_hl

Only available in the `language` style.

Highlight group for the sign.

