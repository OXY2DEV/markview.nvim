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

## 🧩 Structure

> You can find the complete specification in [definitions/markview.lua]().

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

