# 💻 Preview options

Options that change how previews are shown.

```lua
---@class config.preview
---
---@field enable boolean Enables preview when attaching to new buffers.
---@field enable_hybrid_mode? boolean Enables `hybrid mode` when attaching to new buffers.
---
---@field callbacks preview.callbacks Callback functions.
---@field icon_provider "internal" | "devicons" | "mini" Icon provider.
---
---@field hybrid_modes string[] VIM-modes where `hybrid mode` is enabled.
---@field ignore_previews preview.ignore Options that should/shouldn't be previewed in `hybrid_modes`.
---@field linewise_hybrid_mode? boolean Clear lines around the cursor in `hybrid mode`, instead of nodes?
---@field modes string[] VIM-modes where previews will be shown.
---
---@field debounce integer Debounce delay for updating previews.
---@field filetypes string[] Buffer filetypes where the plugin should attach.
---@field ignore_buftypes string[] Buftypes that should be ignored(e.g. nofile).
---@field max_buf_lines integer Maximum number of lines a buffer can have before switching to partial rendering.
---
---@field edit_range [ integer, integer ] Lines before & after the cursor that shouldn't be rendered in `hybrid mode`.
---@field draw_range [ integer, integer ] Lines before & after the cursor that should be rendering preview.
---
---@field splitview_winopts table Window options for the `splitview` window.
M.preview = {
    enable = true,

    callbacks = {},
    icon_provider = "internal",

    hybrid_modes = {},
    modes = { "n" },

    debounce = 50,
    filetypes = { "md" },
    ignore_buftypes = {},
    ignore_previews = {},

    draw_range = { 10, 10 },
    edit_range = { 0, 0 },

    splitview_winopts = {},
};
```

------

### enable

- Type: `boolean`
- Dynamic: **true**
- Default: true

Enables previews. Can be set to `false` in case you want to use keymaps to toggle previews.

---

### callbacks

- Type: `table`
  Options,

  + on_attach
  + on_detach

  + on_disable
  + on_enable

  + on_mode_change

  + splitview_close
  + splitview_open

- Dynamic: **false**

Functions to execute when specific tasks are done by the plugin.

>[!NOTE]
> Callbacks are executed **before** [autocmds]().

```lua
---@class preview.callbacks
---
---@field on_attach? fun(buf: integer, wins: integer[]): nil Called when attaching to a buffer.
---@field on_detach? fun(buf: integer, wins: integer[]): nil Called when detaching from a buffer.
---
---@field on_disable? fun(buf: integer, wins: integer[]): nil Called when disabling preview of a buffer.
---@field on_enable? fun(buf: integer, wins: integer[]): nil Called when enabling preview of a buffer.
---
---@field on_mode_change? fun(buf: integer, wins: integer[], mode: string): nil Called when changing VIM-modes(only on active buffers).
---
---@field on_splitview_close? fun(source: integer, preview_buf: integer, preview_win: integer): nil Called before closing splitview.
---@field on_splitview_open? fun(source: integer, preview_buf: integer, preview_win: integer): nil Called when opening splitview.
M.preview_callbacks = {
    on_attach = function (_, wins)
        vim.print(wins);
    end
};
```

A short description of what each parameter represents,

- **buf**
  Buffer where the callback is being run on.

- **wins**
  List of windows that contain `buf`.

- **mode**
  VIM mode short-hand(e.g. "n", "i").

- **source**
  Buffer whose content is being shown in splitview.

- **preview_buf**
  Buffer that contains the preview in splitview.

- **preview_win**
  Window that is showing splitview.

### icon_provider

- Type: `"devicons | "internal" | "mini"`
- Dynamic: **true**
- Default: "internal"

>[!NOTE]
> You will need to install the external icon providers to use them!

Changes the icon provider used for drawing icons. Currently supported providers are,

```lua
---@type "internal" | "devicons" | "mini"
icon_provider = "internal",
```

Here's a simple comparison,

| Feature        | `devicons` | `mini`  | `internal` |
|----------------|------------|---------|------------|
| Icon supoort   | many       | many    | limited    |
| Dynamic colors | no         | partial | yes        |
| External       | yes        | yes     | no         |

### hybrid_modes

- Type: `string[]`
- Dynamic: **true**(not recommended)
- Default: {}

List of VIM-modes where `hybrid mode` is enable. These modes must be present in the `modes` to take effect!

> Hybrid mode is used to preview & edit files at the same time.
> When enabled, text within a specified range around the cursor will not show the preview.

### ignore_previews

- Type `preview.ignore`
- Dynamic: **true**(not recommended)

```lua
---@class preview.ignore
---
---@field html string[]
---@field latex string[]
---@field markdown string[]
---@field markdown_inline string[]
---@field typst string[]
---@field yaml string[]
M.preview_ignore = {
    --- Disables `hybrid mode` for everything other
    --- markdown.
    html = {},
    latex = {},
    markdown_inline = {},
    typst = {},
    yaml = {},

    --- `Hybrid mode` only affects nodes that aren't
    --- a block quote or a code block.
    markdown = { "!block_quotes", "!code_blocks" }
};
```

Controls which nodes don't get affected by `hybrid mode`.

> Nodes that are affected by `hybrid mode` will show the raw version of them(instead of the preview) when the cursor is inside them.

Each language can have a list of `option names`.

<details>
    <summary>Expand to see currently available option names.</summary> <!--+-->

- `html`,
  + **container**
  + **headings**
  + **void_elements**

- `latex`,
  + **blocks latex**
  + **commands**
  + **escapes**
  + **fonts**
  + **inlines**
  + **parenthesis**
  + **subscripts**
  + **superscripts**
  + **symbols**
  + **texts**

- `markdown`,
  + **block_quotes**
  + **code_blocks**
  + **headings**
  + **horizontal_rules**
  + **list_items**
  + **metadata_minus**
  + **metadata_plus**
  + **tables**

- `markdown_inline`
  + **checkboxes inline**
  + **block_references**
  + **inline_codes**
  + **emails**
  + **embed_files**
  + **entities**
  + **escapes**
  + **footnotes**
  + **highlights**
  + **hyperlinks**
  + **images**
  + **internal_links**
  + **uri_autolinks**

- `typst`
  + **code_blocks**
  + **code_spans**
  + **escapes**
  + **headings**
  + **raw_blocks**
  + **raw_spans**
  + **labels**
  + **list_items**
  + **math_blocks**
  + **math_spans**
  + **url_links**
  + **reference_links**
  + **subscripts**
  + **superscripts**
  + **symbols**
  + **terms**

- `yaml`
  + **properties**
<!--_-->
</details>

>[!TIP]
> You can add a `!` before the option name to make it affect everything other than the given option name.
>
> ```lua
> -- Affects everything other than "block quotes".
> markdown = { "!block_quotes" }
> ```

### modes

- Type: `string[]`
- Dynamic: **true**(not recommended)
- Default: { "n", "no", "c" }

List of VIM-modes where previews are shown.

### debounce

- Type: `integer`
- Dynamic: **true**(not recommended)
- Default: 50

Debounce delay(in `milliseconds`) for rendering. Affects how frequently the preview is updated.

### filetypes

- Type: `string[]`
- Dynamic: **true**(not recommended)
- Default: { "markdown", "rmd", "quarto", "typst" }

List of buffer filetypes to enable this plugin in. This will cause the plugin to attach to new buffers who have any of these filetypes.

### ignore_buftypes

- Type: `string[]`
- Dynamic: **true**(not recommended)
- Default: { "nofile" }

List of buffer types to ignore when attaching to new buffers. Checked after the filetype.

### max_buf_lines

- Type: `integer`
- Dynamic: **true**(not recommended)
- Default: 1000

Maximum number of lines a buffer can have before the plugin switches to *partial-rendering*.

>[!NOTE]
> When *partial-rendering* is used, only part of the buffer will have preview. This may be distracting when moving long distances in the buffer.

### edit_range

- Type: `[ integer, integer ]`
- Dynamic: **true**
- Default: { 0, 0 }

Number of lines *above* & *below* the cursor that will be affected by `hybrid mode`.

This changes 2 behaviors,

1. When `linewise_hybrid_mode = true`, this changes the lines that will not be rendered.
2. When `linewise_hybrid_mode` isn't being used, this affects which nodes aren't rendered.

### draw_range

- Type: `[ integer, integer ]`
- Dynamic: **true**
- Default: { vim.o.columns, vim.o.columns }

Number of lines *above* & *below* the cursor to render.

### splitview_winopts

- Type: `table`
- Dynamic: **true**(not recommended)
- Default: { split = "right" }

Window options(see `:h vim.api.nvim_open_win()`) for the splitview window.

---

Also available in vimdoc, `:h markview.nvim-preview`.

