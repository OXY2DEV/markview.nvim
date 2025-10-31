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
                "^enable$": [ "markview.nvim-preview.enable" ],
                "enable_hybrid_mode": [ "markview.nvim-preview.enable_hybrid_mode" ],
                "map_gx": [ "markview.nvim-preview.map_gx" ],
                "callbacks": [ "markview.nvim-preview.callbacks" ],
                "icon_provider": [ "markview.nvim-preview.icon_provider" ],
                "debounce": [ "markview.nvim-preview.debounce" ],
                "filetypes": [ "markview.nvim-preview.filetypes" ],
                "ignore_buftypes": [ "markview.nvim-preview.ignore_buftypes" ],
                "raw_previews": [ "markview.nvim-preview.raw_previews" ],
                "condition": [ "markview.nvim-preview.condition" ],
                "^modes": [ "markview.nvim-preview.modes" ],
                "hybrid_modes": [ "markview.nvim-preview.hybrid_modes" ],
                "linewise_hybrid_mode": [ "markview.nvim-preview.linewise_hybrid_mode" ],
                "max_buf_lines": [ "markview.nvim-preview.max_buf_lines" ],
                "draw_range": [ "markview.nvim-preview.draw_range" ],
                "edit_range": [ "markview.nvim-preview.edit_range" ],
                "splitview_winopts": [ "markview.nvim-preview.splitview_winopts" ]
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

- Allow going to headings(fragment links) with Github-style section links(e.g. [🧩 Preview options](#-preview-options))
    + Allow going to headings in other files when [experimental.prefer_nvim](./Experimental.md#prefer_nvim) is set to `true`.
- Allow opening **text files** within Neovim when [experimental.prefer_nvim](./Experimental.md#prefer_nvim) is set to `true` using [experimental.file_open_command](./Experimental.md#file_open_command).
- Trigger `vim.ui.open()` for other file types(default behavior of `gx`).
- Allow opening links such as Hyperlinks, images, Embed files etc. by being on the Node(instead of needing to be on the URL).

## callbacks

```lua from: ../lua/markview/types/preview.lua class: markview.config.preview.callbacks
--- Callback functions for specific events.
---@class markview.config.preview.callbacks
---
---@field on_attach? fun(buf: integer, wins: integer[]): nil Called when attaching to a buffers.
---@field on_detach? fun(buf: integer, wins: integer[]): nil Called when detaching from a buffer.
---
---@field on_disable? fun(buf: integer, wins: integer[]): nil Called when disabling preview of a buffer. Also called when using `splitOpen`.
---@field on_enable? fun(buf: integer, wins: integer[]): nil Called when enabling preview of a buffer. Also called when using `splitClose`.
---
---@field on_hybrid_disable? fun(buf: integer, wins: integer[]): nil Called when disabling hybrid mode in a buffer.
---@field on_hybrid_enable? fun(buf: integer, wins: integer[]): nil Called when enabling hybrid mode in a buffer.
---
---@field on_mode_change? fun(buf: integer, wins: integer[], mode: string): nil Called when changing VIM-modes(only on active buffers).
---
---@field on_splitview_close? fun(source: integer, preview_buf: integer, preview_win: integer): nil Called before closing splitview.
---@field on_splitview_open? fun(source: integer, preview_buf: integer, preview_win: integer): nil Called when opening splitview.
```

Runs various callbacks on specific *events*.

## icon_provider

```lua
---@field icon_provider?
---| "" Disable icons.
---| "internal" Internal icon provider.
---| "devicons" `nvim-web-devicons` as icon provider.
---| "mini" `mini.icons` as icon provider.
```

Set the icon provider for the code block labels.

## debounce

```lua
debounce = 150
```

Delay(in milliseconds) between refreshing the preview.

>[!NOTE]
> In some cases(e.g. switching between 2 modes(e.g. `n`, `c`) that have preview enabled) the refresh is **skipped**.
> You can manually trigger a refresh with `:Markview render`(current buffer only) and `:Markview Render`(all attached buffers).

## filetypes

```lua
filetypes = { "markdown", "quarto", "rmd", "typst" },
```

Filetypes where `markview` will try to attach. Also see [preview.ignore_buftypes](#ignore_buftypes).

>[!IMPORTANT]
> If the buftype matches any of the buftype in [preview.ignore_buftypes](#ignore_buftypes) it will be **ignored**.
> By default, `nofile` buffers are skipped.

## ignore_buftypes

```lua
ignore_buftypes = { "nofile" },
```

Buffer types to ignore. Useful to disable previews in LSP hover window/Completion window.


## raw_previews

```lua from: ../lua/markview/types/preview.lua class: markview.config.preview.raw
--- Elements that should be shown as raw when hovering
--- in `hybrid mode`.
---@class markview.config.preview.raw
---
---@field html? markview.config.preview.raw.html[]
---@field latex? markview.config.preview.raw.latex[]
---@field markdown? markview.config.preview.raw.markdown[]
---@field markdown_inline? markview.config.preview.raw.markdown_inline[]
---@field typst? markview.config.preview.raw.typst[]
---@field yaml? markview.config.preview.raw.yaml[]
```

Changes what gets shown as raw text in `hybrid mode`. [hybrid_modes](#hybrid_modes) must be set for this to work.

It is a map of language names & a list of inclusion/exclusion rules.

You would use something like this to only show everything other then `block quotes` & `tables` as raw text.

```lua
raw_previews = {
    markdown = { "!block_quotes", "!tables" }
}
```

## condition

A function that returns a **boolean** indicating if a buffer should be attached to.

>[!NOTE]
> This is run after [filetypes](#filetypes) & [ignore_buftypes](#ignore_buftypes) is checked.

Useful if you need sophisticated logic for buffer attaching.

## modes

```lua
modes = { "n", "no", "c" },
```

Modes where previews will be shown.

## hybrid_modes

```lua
hybrid_modes = {},
```

Modes where `hybrid mode` will be shown.

>[!IMPORTANT]
> The mode must also be preset in [modes](#modes) for this to take effect!

## linewise_hybrid_mode

```lua
linewise_hybrid_mode = false,
```

Enables `linewise` hybrid mode. [edit_range](#edit_range) is used to control the number of lines to clear around each cursor.

## max_buf_lines

```lua
max_buf_lines = 1000,
```

Maximum number of lines a buffer can have for it to be rendered completely.

>[!NOTE]
> This causes a lot of the redrawing to be skipped and giving a better performance.
> However, if the buffer is very long(or has very complex syntax tree) it can cause lag when opening the buffer.

If the line count is larger than this value, the buffer will be *partially* drawn. [draw_range](#draw_range) is used to control the number of lines drawn around each cursor.

## draw_range

```lua
draw_range = { 1 * vim.o.lines, 1 * vim.o.lines },
```

Number of lines drawn above & below each cursor.

>[!IMPORTANT]
> For a node to be drawn, it only needs to be partially inside this range.
> So, sometimes it may feel like more lines are being drawn than the specified amount.

## edit_range

```lua
edit_range = { 0, 0 },
```

Number of lines above & below each cursor that are considered being *edited*. Only useful in [hybrid_modes](#hybrid_modes).

>[!IMPORTANT]
> When [linewise_hybrid_mode](#linewise_hybrid_mode) is `false`, a Node only needs to *partially* be within the range for it to be considered being *edited*.
> So, things such as List items, Block quotes etc. may clear more lines than the specified amount.

>[!NOTE]
> `{ 0, 0 }` means only the current line is being edited. `{ 1, 1 }` means 1 line around each cursor(total 3 lines) are being edited.
> You can use different values for lines above & below the cursor.

## splitview_winopts

```lua
splitview_winopts = {
    split = "right"
},
```

Window options for the `splitview` window. Passed directly to `nvim_open_win()`.

