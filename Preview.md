<!--markdoc
    {
        "generic": {
            "filename": "../doc/markview.nvim-preview.txt",
            "force_write": true,
            "header": {
                "desc": "🧩 Preview options for `markview.nvim`",
                "tag": "markview.nvim-preview"
            }
        },
        "markdown": {
            "heading_ratio": [ 26, 54 ],
            "list_items": {
                "marker_minus": "◆",
                "marker_plus": "◇"
            },
            "tags": {
                "date_formats": [ "markview.nvim-preview.date_formats" ],
                "date_time_formats": [ "markview.nvim-preview.date_time_formats" ],
                "prefer_nvim": [ "markview.nvim-preview.prefer_nvim" ],
                "file_open_command": [ "markview.nvim-preview.file_open_command" ],
                "list_empty_line_tolerance": [ "markview.nvim-preview.list_empty_line_tolerance" ],
                "read_chunk_size": [ "markview.nvim-preview.read_chunk_size" ],
                "linewise_ignore_org_indent": [ "markview.nvim-preview.linewise_ignore_org_indent" ]
            }
        }
    }
-->
<!--markdoc_ignore_start-->
# 🧩 Preview options
<!--markdoc_ignore_end-->

```lua from: ../lua/markview/types/preview.lua class: markview.config.preview
--- Preview options.
---@class markview.config.preview
---
---@field enable? boolean Enables *preview* when attaching to new buffers.
---@field enable_hybrid_mode? boolean Enables `hybrid mode` when attaching to new buffers.
---
---@field map_gx? boolean Re-maps `gx` to custom URL opener.
---
---@field callbacks? markview.config.preview.callbacks Callback functions.
---
--- Icon provider.
---@field icon_provider?
---| "" Disable icons.
---| "internal" Internal icon provider.
---| "devicons" `nvim-web-devicons` as icon provider.
---| "mini" `mini.icons` as icon provider.
---
---@field debounce? integer Debounce delay for updating previews.
---@field filetypes? string[] Buffer filetypes where the plugin should attach.
---@field ignore_buftypes? string[] Buftypes that should be ignored(e.g. nofile).
---@field raw_previews? markview.config.preview.raw Options that will show up as raw in hybrid mode.
---
---@field condition? fun(buffer: integer): boolean Condition to check if a buffer should be attached or not.
---
---@field modes? string[] Vim-modes where previews will be shown.
---@field hybrid_modes? string[] Vim-modes where `hybrid mode` is enabled. Options that should/shouldn't be previewed in `hybrid_modes`.
---
---@field linewise_hybrid_mode? boolean Clear lines around the cursor in `hybrid mode`, instead of nodes.
---@field max_buf_lines? integer Maximum number of lines a buffer can have before switching to partial rendering.
---
---@field draw_range? [ integer, integer ] Lines above & below the cursor to show preview.
---@field edit_range? [ integer, integer ] Lines above & below the cursor to not preview in `hybrid mode`.
---
---@field splitview_winopts? table Window options for the `splitview` window. See `:h nvim.open_win()`.
```

## enable

```lua
enable = true
```

Enable preview when attaching to buffers.

## enable_hybrid_mode

```lua
enable_hybrid_mode = true
```

Enable `hybrid mode` when attaching to buffers.

## map_gx

```lua
map_gx = true
```

Remaps `gx` to,

1. Allow going to headings with Github-style section links(e.g. [🧩 Preview options](#-preview-options))

