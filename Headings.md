# 🔖 Headings

```lua
headings = {
    enable = true,
    shift_width = 1,

    heading_1 = {
        style = "simple",

        shift_char = " ",
        hl = "DiagnosticOk"
    },
    heading_2 = {},
    heading_3 = {},
    heading_4 = {},
    heading_5 = {},
    heading_6 = {},

    setext_1 = {},
    setext_2 = {}
}
```

## 🔩 Configuration options

- enable, `boolean` or nil

  Used for toggling the rendering of headings.

- shift_width, `number` or nil

  Number of `shift_char` to add per level.

- heading_<1-6>

  Configuration table for various atx heading levels.

- setext_<1-2>

  Configuration table for various setext heading levels.

## ⭐ Heading configuration

Used to style `atx headings`.

- style, `string`

  Name of the rendering style. Possible values are,

  - simple
  - label
  - icon

- hl, `string` or nil

  Default highlight group for the heading.

### 🎨 Simple

```lua
heading_1 = {
    style = "simple",
    hl = "DiagnosticOk"
}
```

Adds a simple background to the heading.

### 🎨 Label

```lua
heading_1 = {
    style = "label",
    shift_char = "",
    shift_hl = nil,

    sign = nil,
    sign_hl = nil,

    hl = "DiagnosticOk",

    corner_left = nil,
    corner_left_hl = nil,

    padding_left = " ",
    padding_left_hl = nil,

    icon = "",
    icon_hl = nil,

    padding_right = " ",
    padding_right_hl = nil,

    corner_right = nil,
    corner_right_hl = nil
}
```

Makes headings look like labels. It adds the following options,

- shift_char, `string` or nil

  Text to use for shifting the heading.

- shift_hl, `string` or nil

  Highlight group for the `shift_char`.

- sign, `string` or nil

  Text to use as the sign for the heading.

- sign_hl, `string` or nil

  Highlight group for `sign`.

- hl, `string` or nil

  Default highlight group for the heading.

- corner_left, `string` or nil

  Text used as the left corner of the label.

- corner_left_hl, `string` or nil

  Highlight group for `corner_left`.

- padding_left, `string` or nil

  Text used as the left padding of the label.

- padding_left_hl, `string` or nil

  Highlight group for `padding_left`.

- icon, `string` or nil

  Text used as the icon for the heading.

- icon_hl, `string` or nil

  Highlight group for `icon`.

- padding_right, `string` or nil

  Text used as the right padding of the label.

- padding_right_hl, `string` or nil

  Highlight group for `padding_right`.

- corner_right, `string` or nil

  Text used as the right corner of the label.

- corner_right_hl, `string` or nil

  Highlight group for `corner_right`.

### 🎨 Icon

```lua
heading_1 = {
    style = "icon",
    shift_char = "",
    shift_hl = nil,

    sign = nil,
    sign_hl = nil,

    hl = "DiagnosticOk"
}
```

Adds icons to the headings. It has the following options,

- shift_char, `string` or nil

  Text to use for shifting the heading.

- shift_hl, `string` or nil

  Highlight group for the `shift_char`.

- sign, `string` or nil

  Text to use as the sign for the heading.

- sign_hl, `string` or nil

  Highlight group for `sign`.

- hl, `string` or nil

  Highlight group for the line containing the heading.

## ⭐ Setext heading configuration

Used to style `setext headings`.

- style, `string`

  Name of the rendering style. Possible values are,

  - simple
  - github

- hl, `string` or nil

  Default highlight group for the heading.

### 🎨 Simple

```lua
setext_1 = {
    style = "simple",
    hl = "DiagnosticOk"
}
```

Adds a simple background to the heading.

### 🎨 Github

```lua
setext_1 = {
    style = "github",

    icon = "🔗",
    hl = "DiagnosticOk"
}
```

Adds an icon to the heading. It adds the following options,

- icon, `string` or nil

  Text to use as the icon.

