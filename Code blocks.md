# 💻 Code blocks

```lua
code_blocks = {
    enable = true,
    style = "simple",

    hl = "CursorLine"
}
```

## 🔩 Configuration options

- enable, `boolean` or nil

  Controls rendering of code blocks.

- style, `string`

  Name of the rendering style.

- hl, `string` or nil

  Highlight group for the code blocks.

## 🚀 Styles

Code blocks can be rendered in 3 styles,

+ simple
+ minimal
+ language

### 🎨 Simple

```lua
code_blocks = {
    style = "simple",
    hl = "CursorLine"
}
```

Adds a simple background color to the code block.

### 🎨 Minimal

```lua
code_blocks = {
    style = "minimal",
    position = nil,
    min_width = 70,
    
    pad_amount = 3,
    pad_char = " ",

    hl = "CursorLine"
}
```

Adds a border surrounding the code block. It adds the following options,

- position, `string` or nil

  `virt_text_pos` for the top and bottom borders.

- min_width, `number` or nil

  Minimum width of the code block. Default is 60.

  Paddings are not counted.

- pad_amount, `number` or nil

  Number of times to repeat `pad_char` before & after the text. Default is 3.

- pad_char, `string` or nil

  Text to use as the padding.

### 🎨 Language

```lua
code_blocks = {
    style = "minimal",
    icons = true,
    position = nil,
    min_width = 70,
    
    pad_amount = 3,
    pad_char = " ",

    language_direction = "left",
    language_names = {},

    hl = "CursorLine",

    sign = true,
    sign_hl = nil
}
```

Like `minimal` but also shows the language name. Other than supporting all the options of `minimal` it adds,

- icons, `boolean` or nil

  Allows disabling icons.

- language_direction, `string` or nil

  Changes the position of the language name. Default is **left**. Possible values are,

  - left
  - right

- language_names, `table` or nil

  A list of { pattern, name } tuples for changing the string that is shown.

- sign, `boolean` or nil

  Used for toggling the language icon sign.

- sign_hl, `string` or nil

  Highlight group for the sign. If nil the highlight group provided by `nvim-web-devicon` is used.

