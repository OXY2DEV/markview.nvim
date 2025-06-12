# 🔩 Configuration

Configuration can be done by calling `require("markview").setup()` with the config table.

>[!TIP]
> You can always reset to the default configuration using this,
>
> ```lua
> local spec = require("markview.spec");
> spec.config = spec.default;
> ```

## Table of Contents

- [Structure](#-structure)
- [Inline elements](#-inline-elements)

------

Also read,

- [Experimental options](https://github.com/OXY2DEV/markview.nvim/wiki/Experimental)
- [Preview options](https://github.com/OXY2DEV/markview.nvim/wiki/Preview)

- [Markdown](https://github.com/OXY2DEV/markview.nvim/wiki/Markdown)
- [Markdown inline](https://github.com/OXY2DEV/markview.nvim/wiki/Markdown-inline)
- [LaTeX](https://github.com/OXY2DEV/markview.nvim/wiki/LaTeX)
- [Typst](https://github.com/OXY2DEV/markview.nvim/wiki/Typst)
- [YAML](https://github.com/OXY2DEV/markview.nvim/wiki/YAML)

## 🧩 Structure

> You can find the complete specification in [definitions/markview.lua](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/definitions/markview.lua).

The configuration table has the following structure,

>[!NOTE]
> Due to the sheer size of the actual configuration table, only the top 2 levels are shown here!

```lua
---@type markview.config
{
    experimental = {
        date_formats = {},
        date_time_formats = {},

        file_open_command = nil,

        list_empty_line_tolerance = nil

        prefer_nvim = nil,
        read_chunk_size = nil,

        linewise_ignore_org_indent = false,
    },
    preview = {
        enable = nil,
        map_gx = nil,

        callbacks = {},

        filetypes = {},
        ignore_buftypes = {},
        ignore_previews = {},

        debounce = nil,
        icon_provider = nil,
        max_buf_lines = 100,

        modes = {},
        hybrid_modes = {},
        linewise_hybrid_mode = nil,

        draw_range = {},
        edit_range = {},

        splitview_winopts = {},
    },

    markdown = {
        enable = nil,

        block_quoutes = {},
        code_blocks = {},
        headings = {},
        horizontal_rules = {},
        list_items = {},
        tables = {},

        metadata_plus = {},
        metadata_minus = {},

        reference_definitions = {},
    },
    markdown_inline = {
        enable = nil,

        block_references = {},
        checkboxes = {},
        emails = {},
        footnotes = {},
        hyperlinks = {},
        images = {},
        inline_codes = {},
        uri_autolinks = {},

        embed_files = {},
        highlights = {},
        internal_links = {},

        entities = {},
        emoji_shorthands = {},

        escapes = {},
    },

    html = {
        enable = nil,

        container_elements = {},
        headings = {},
        void_elements = {},
    },
    latex = {
        enable = nil,

        blocks = {},
        inlines = {},

        commands = {},
        escapes = {},
        parenthesis = {},

        fonts = {},
        subscripts = {},
        superscripts = {},
        symbols = {},
        texts = {},
    },
    yaml = {
        enable = nil,

        properties = {},
    },

    typst = {
        enable = nil,

        code_blocks = {},
        code_spans = {},

        escapes = {},
        symbols = {},

        headings = {},
        labels = {},
        list_items = {},

        math_blocks = {},
        math_spans = {},

        raw_blocks = {},
        raw_spans = {},

        reference_links = {},
        terms = {},
        url_links = {},

        subscripts = {},
        superscripts = {},
    },
}
```

## 💡 Inline elements

Almost all the inline elements are configured the same way,

```lua
---@type markview.config.__inline
{
	enable = nil,

    corner_left = nil,
    corner_left_hl = nil,

    padding_left = nil,
    padding_left_hl = nil,

    icon = nil,
    icon_hl = nil,

    hl = nil,

    padding_right = nil,
    padding_right_hl = nil,

    corner_right = nil,
    corner_right_hl = nil,


    block_hl = nil,
    file_hl = nil,
}
```

### enable

>[!IMPORTANT]
> This option is only available if it's in `markview.<language>.<option>`!

- type: `boolean`

Enables preview of this element.

### corner_left

- type: `string`

Text used as left corner(added before [padding_left](#padding_left)).

### corner_left_hl

- type: `string`

Highlight group for [corner_left](#corner_left).

### padding_left

- type: `string`

Text used as left padding(added before [icon](#icon)).

### padding_left_hl

- type: `string`

Highlight group for [padding_left](#padding_left).

### icon

- type: `string`

Text used as icon(added before the text).

### icon_hl

- type: `string`

Highlight group for [icon](#icon).

### padding_right

- type: `string`

Text used as right padding(added after the text).

### padding_right_hl

- type: `string`

Highlight group for [padding_right](#padding_right).

### corner_right

- type: `string`

Text used as right corner(added after [padding_right](#padding_right)).

### corner_right_hl

- type: `string`

Highlight group for [corner_right](#corner_right).

------

>[!NOTE]
> The options are only for `markview.config.markdown.block_references`!

### block_hl

- type: `string`

Highlight group for the block name.

### file_hl

- type: `string`

Highlight group for the file name.

