# Presets

Presets are `configuration tables` that you can use to quickly customise various parts of the plugin.

They can be used by requiring the presets file and using the values in the `setup()` function.

Example usage,

```lua
local presets = require("markview.presets");

require("markview").setup({
    headings = presets.headings.glow
});
```

## Table of contents

- [Heading presets](#_heading_presets)
- [Table presets](#_table_presets)

## Heading presets

The plugin provides quite a few presets for headings such as,

### glow

![glow_preview](./wiki_img/presets/h_glow.jpg)

Adds `Glow-like` headings to the previewer.

### glow_labels

![glow_labels_preview](./wiki_img/presets/h_glow_labels.jpg)

Unlike **glow** this one will also add decorations to all heading levels.

### decorated_labels

![decorated_labels_preview](./wiki_img/presets/h_decorated_labels.jpg)

Adds decorations to the headings.

### simple

![simple_preview](./wiki_img/presets/h_simple.jpg)

Adds simple background color to the headings.

### simple_no_marker

![simple_no_marker_preview](./wiki_img/presets/h_simple_no_marker_preview.jpg)

Like **simple** but removes the leading `#` of headings.

## Table presets

There are a few presets for various borders of tables such as,

### border_none

![border_none_preview](./wiki_img/presets/t_border_none.jpg)

Replaces table borders with `whitespaces`.

### border_headers

![border_headers_preview](./wiki_img/presets/t_border_headers.jpg)

Only adds border to the `table_headers`

### border_single

![border_single_preview](./wiki_img/presets/t_border_single.jpg)

Like the `border="single"` of floating windows. Doesn't use rounded corners.

### border_single_corners

![border_single_corners_preview](./wiki_img/presets/t_border_single_corners.jpg)

Makes the border corners thicker to stand out more.

### border_double

![border_double_preview](./wiki_img/presets/t_border_double.jpg)

Like the `border="double"` of floating windows.

