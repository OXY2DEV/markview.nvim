# Hyperlinks

This plugin provides custom hyperlinks that can be customised with the `hyperlinks` option.

## Configuration

The configuration table for `hyperlinks` is given below.

```lua
hyperlinks = {
    enable = true,

    hl = "rainbow1",

    corner_left = "", corner_left_hl = nil,
    corner_right = "", corner_right_hl = nil,

    padding_left = "", padding_left_hl = nil,
    padding_right = "", padding_right_hl = nil,

    icon = "", icon_hl = nil,
    text = "", text_hl = nil,
}
```

#### hl

The default value all the `highlight` properties(properties whose name ends with `hl`).

#### corner_left

The left corner for the hyperlinks.

#### corner_left_hl

Highlight group for the left corner. When nil the value of `hl` is used.

#### corner_right

The right corner for the hyperlinks.

#### corner_right_hl

Highlight group for the right corner. When nil the value of `hl` is used.

#### padding_left

The left padding for the hyperlinks. Added after the `left_corner`.

#### padding_left_hl

Highlight group for the left padding. When nil the value of `hl` is used.

#### padding_right

The right padding for the hyperlinks. Added before the `right_corner`.

#### padding_right_hl

Highlight group for the right padding. When nil the value of `hl` is used.

#### icon

A custom icon for the hyperlinks. It is added after the padding.

There won't be any spaces added between the icon & the link text. So, you should add the spaces to the icon itself.

#### icon_hl

Highlight group for the icon. When nil the value of `hl` is used.

#### text

A custom text for the hyperlinks. This will replace the hyperlink's text.

#### text_hl

Highlight group for the hyperlink's text. When nil the value of `hl` is used.

# Images

This plugin provides custom image links that can be customised with the `images` option.

## Configuration

The configuration table for image links is given below.

```lua
images = {
    enable = true,

    hl = "rainbow1",

    corner_left = "", corner_left_hl = nil,
    corner_right = "", corner_right_hl = nil,

    padding_left = "", padding_left_hl = nil,
    padding_right = "", padding_right_hl = nil,

    icon = "", icon_hl = nil,
    text = "", text_hl = nil,
}
```

#### hl

The default value all the `highlight` properties(properties whose name ends with `hl`).

#### corner_left

The left corner for the image links.

#### corner_left_hl

Highlight group for the left corner. When nil the value of `hl` is used.

#### corner_right

The right corner for the image links.

#### corner_right_hl

Highlight group for the right corner. When nil the value of `hl` is used.

#### padding_left

The left padding for the image links. Added after the `left_corner`.

#### padding_left_hl

Highlight group for the left padding. When nil the value of `hl` is used.

#### padding_right

The right padding for the image links. Added before the `right_corner`.

#### padding_right_hl

Highlight group for the right padding. When nil the value of `hl` is used.

#### icon

A custom icon for the image links. It is added after the padding.

There won't be any spaces added between the icon & the link text. So, you should add the spaces to the icon itself.

#### icon_hl

Highlight group for the icon. When nil the value of `hl` is used.

#### text

A custom text for the image links. This will replace the hyperlink's text.

#### text_hl

Highlight group for the hyperlink's text. When nil the value of `hl` is used.

