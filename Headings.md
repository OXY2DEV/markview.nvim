# Headings

This plugin provides custom headings whuch can be configured through this option.

![h_1](./wiki_img/heading_1.jpg)
![h_2](./wiki_img/heading_2.jpg)
![h_3](./wiki_img/heading_3.jpg)
![h_4](./wiki_img/heading_4.jpg)
![h_5](./wiki_img/heading_5.jpg)
![h_6](./wiki_img/heading_6.jpg)
![h_7](./wiki_img/heading_7.jpg)

>[!IMPORTANT]
> Do not use `italics`, `bold` texts or `inline codes` in your headings.
>
> The plugin will render the text with the symbols as they are not yet supported.

## Configuration

Configuration for the `heading` is separated into 2 parts, `global` & `level specific`.

### Global configuration

Global configuration options are used to change how all the headings behave.

```lua
heading = {
    enable = true,
    shift_width = 4,

    heading_1 = {},
    heading_2 = {},
    heading_3 = {},
    heading_4 = {},
    heading_5 = {},
    heading_6 = {}
}
```

#### enable

A boolean value, used to enable or disable custom headings.

#### shift_width

A number value, the number of times `shift_char` will be repeated.

When nil, `vim.o.shiftwidth` is used.

#### headings

Configuration table for various `level specific` options.

### Level specific configuration

Each heading level has the following configuration table. They can be used to customise individual headings.

```lua
heading_1 = {
    style = "label",

    hl = "rainbow1",

    corner_left = "", corner_left_hl = nil,
    corner_right = "", corner_right_hl = nil,

    padding_left = "", padding_left_hl = nil,
    padding_right = "", padding_right_hl = nil,

    icon = "", icon_hl = nil,
    text = "", text_hl = nil,

    sign = nil, sign_hl = nil
}
```

#### style

A string value, the style of the heading. Currently supported values are.

- simple, Simple line highlighting
- label, Custom labels that can be configured like statusline components.
- icon, Icons for the heading text

>[!IMPORTANT]
> The properties given below will behave differently based on the used `style`.

##### Style: simple

The `simple` style only adds a simple background to the line.

```lua
heading_1 = {
    style = "simple",

    hl = "rainbow1"
}
```

###### hl

Highlight group used to Highlight the line itself.

##### Style: label

The `label` style makes the headings look like lables(like in `glow`). They are customised similar to `statusline-items`.

```lua
heading_2 = {
    style = "icon",
    position = "inline",

    hl = nil,
    line_hl = "Markview_orange",

    shift_char = " ", shift_hl = nil,

    corner_left = nil, corner_left_hl = nil,
    corner_right = nil, corner_right_hl = nil,

    padding_left = " ", padding_left_hl = nil,
    padding_right = " ", padding_right_hl = nil,

    icon = "2. " icon_hl = "rainbow2",
    text = nil, text_hl = "rainbow2",

    sign = "> ", sign_hl = "rainbow2"
}
```

###### position

`virt_text_pos` for the label. See `:h nvim_buf_set_extmark()` for the possible values.

###### hl

The default highlight group to be used in the various highlight group properties(the ones with `_hl` in their name).

###### shift_char

The character to indicate heading level. It is repeated by `heading_level * shift_width`.

###### shift_hl

The highlight group for `shift_char`. When nil the value of `hl` is used.

###### corner_left

The left corner of the label.

###### corner_left_hl

Highlight group for the left corner. When nil the value of `hl` is used.

###### corner_right

The right corner of the label.

###### corner_right_hl

Highlight group for the right corner. When nil the value of `hl` is used.

###### padding_left

The left padding of the label. Added after the `left_corner`.

###### padding_left_hl

Highlight group for the left padding. When nil the value of `hl` is used.

###### padding_right

The right padding of the label. Added before the `right_corner`.

###### padding_right_hl

Highlight group for the right padding. When nil the value of `hl` is used.

###### icon

A custom icon for the heading. It is added after the left padding.

There won't be any spaces added between the icon & the heading's text. So, you should add the spaces to the icon itself.

###### icon_hl

Highlight group for the icon. When nil the value of `hl` is used.

###### text

A custom text for the label. This will replace the heading's title.

###### text_hl

Highlight group for the headings text. When nil the value of `hl` is used.

###### sign

A custom sign for the heading.

###### sign_hl

Highlight group for the sign. When nil the value of `hl` is used.

##### Style: icon

The `icon` style supports simple icon, line_hl and signs.

```lua
heading_3 = {
    style = "icon",
    position = "inline",

    hl = "rainbow3",

    shift_char = " ", shift_hl = nil,

    icon = "3. ", icon_hl = nil,
    text = nil, text_hl = nil,

    sign = "» ", sign_hl = nil,
}
```

> The options are already explained in `label` and `simple`.



