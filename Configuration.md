# 🔩 Configuration

Configuration options for `markview.nvim`.

>[!TIP]
> You can reset the configuration with the following snippet.
> ```lua
> local spec = require("markview.spec");
> spec.config = vim.deepcopy(spec.default);
> ```

## 🧩 Options

- [🧩 Experimental]()
- [🧩 HTML]()
- [🧩 LaTeX]()
- [🧩 Markdown]()
- [🧩 Markdown inline]()
- [🧩 Preview]()
- [🧩 Typst]()
- [🧩 YAML]()

The configuration table has the following structure,

```lua from: ../lua/markview/types/markview.lua class: markview.config
---@class markview.config
---
---@field experimental? markview.config.experimental
---@field html? markview.config.html
---@field latex? markview.config.latex
---@field markdown? markview.config.markdown
---@field markdown_inline? markview.config.markdown_inline
---@field preview? markview.config.preview
---@field renderers? table<string, function>
---@field typst? markview.config.typst
---@field yaml? markview.config.yaml
```

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

    yaml = {
        enable = nil,

        properties = {},
    },
}
```

