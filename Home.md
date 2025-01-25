<h1 align="center">☄️ markview.nvim</h1>

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/repo/markdown-catppuccin_mocha.png">

A hackable **markdown**, <b>HTML</b>, $LaTeX$, `Typst` & *YAML* previewer for Neovim.

>[!NOTE]
> This wiki assumes you have basic understanding of `LuaCATS` annotations.
> If you don't, check out [this section](https://luals.github.io/wiki/annotations/#documenting-types).

## ⚠️ Important

Make sure you read this to understand how the type definitions in the wiki are written.

<!--+-->

```lua
--   ┌ Main option name
-- [ Markdown | Block quotes ] --------------------------------------------------------------
--              └ Sub option name

--- This is the type used in the configuration table.
---@class markdown.block_quotes
---
---@field enable boolean A normal option.
---
--- A dynamic option that can have a function as value. It receives these parameters,
---   buffer: Buffer number
---   item: the item that will is being rendered.
--- It returns a `string`.
---@field default block_quotes.opts | fun(buf: integer, item: __markdown.block_quotes): block_quotes.opts

-- [ Markdown | Block quotes • Static ] -----------------------------------------------------
--                             ╾────╴ This is the resulting configuration
--                                    table that will be used by the plugin

--                              ╾────╴ Static configuration clasess end with `static`
---@class markdown.block_quotes.static
---
---@field enable boolean Option description.
---@field default block_quotes.opts Another option description.

--                                               Type definition for any
--                             ╾───────────────╴ options that are inside `block_quotes`.
-- [ Markdown | Block quotes > Type definitions ] -------------------------------------------

---@class block_quotes.opts
---
---@field border string | fun(buffer: integer, item: __markdown.block_quotes): string
---@field border_hl string? | fun(buffer: integer, item: __markdown.block_quotes): string?

--                             ╾────────╴ Definitions for the parameters.
-- [ Markdown | Block quotes > Parameters ] -------------------------------------------------

---@class __markdown.block_quotes
---
---@field class "markdown_block_quote"
---
---@field text string[]
---@field range nrde.range
```

<!--_-->

## 📚 Wiki files

- [🔄 Migration guide](https://github.com/OXY2DEV/markview.nvim/wiki/Migration-guide)
- [💻 Developer docs](https://github.com/OXY2DEV/markview.nvim/wiki/Developer-documentation)
- [🌟 Custom renderers](https://github.com/OXY2DEV/markview.nvim/wiki/Custom-renderers)

- [🔭 Preview options](https://github.com/OXY2DEV/markview.nvim/wiki/Preview-options)
- [🚨 Experimental options](https://github.com/OXY2DEV/markview.nvim/wiki/Experimental-options)

- [🧾 Markdown options](https://github.com/OXY2DEV/markview.nvim/wiki/Markdown-options)
- [🌐 HTML options](https://github.com/OXY2DEV/markview.nvim/wiki/HTML-options)
- [🔖 Inline markdown options](https://github.com/OXY2DEV/markview.nvim/wiki/Markdown-inline-options)
- [🔢 LaTeX options](https://github.com/OXY2DEV/markview.nvim/wiki/LaTeX-options)
- [📑 Typst options](https://github.com/OXY2DEV/markview.nvim/wiki/Typst-options)
- [🔩 YAML options](https://github.com/OXY2DEV/markview.nvim/wiki/YAML-options)

- [🧩 Presets](https://github.com/OXY2DEV/markview.nvim/wiki/Presets)
- [🎁 Extra modules](https://github.com/OXY2DEV/markview.nvim/wiki/Extra-modules)
- [💻 Advanced usage](https://github.com/OXY2DEV/markview.nvim/wiki/Advanced-usage)

## 🧭 Configuration

<details>
    <summary>Click for config jump-scare</summary><!-- --+ -->

```lua
--- Configuration table for `markview.nvim`.
---@class mkv.config
---
---@field experimental config.experimental | fun(): config.experimental
---@field highlight_groups { [string]: config.hl } | fun(): { [string]: config.hl }
---@field html config.html | fun(): config.html
---@field latex config.latex | fun(): config.latex
---@field markdown config.markdown | fun(): config.markdown
---@field markdown_inline config.markdown_inline | fun(): config.markdown_inline
---@field preview config.preview | fun(): config.preview
---@field renderers config.renderer[] | fun(): config.renderer[]
---@field typst config.typst | fun(): config.typst
---@field yaml config.yaml | fun(): config.yaml
mkv.config = {
    experimental = {
        date_formats = {},
        date_time_formats = {},

        text_filetypes = {},
        read_chunk_size = 1000,
        link_open_alerts = false,
        file_open_command = "tabnew",

        list_empty_line_tolerance = 3
    },
    highlight_groups = {},
    preview = {
        enable = true,
        filetypes = { "md", "rmd", "quarto" },
        ignore_buftypes = { "nofile" },
        ignore_previews = {},

        modes = { "n", "no", "c" },
        hybrid_modes = {},
        debounce = 50,
        draw_range = { vim.o.lines, vim.o.lines },
        edit_range = { 1, 0 },

        callbacks = {},

        splitview_winopts = { split = "left" }
    },
    renderers = {},

    html = {
        enable = true,

        container_elements = {},
        headings = {},
        void_elements = {},
    },
    latex = {
        enable = true,

        blocks = {},
        commands = {},
        escapes = {},
        fonts = {},
        inlines = {},
        parenthesis = {},
        subscripts = {},
        superscripts = {},
        symbols = {},
        texts = {}
    },
    markdown = {
        enable = true,

        block_quotes = {},
        code_blocks = {},
        headings = {},
        horizontal_rules = {},
        list_items = {},
        metadata_plus = {},
        metadata_minus = {},
        tables = {}
    },
    markdown_inline = {
        enable = true,

        block_references = {},
        checkboxes = {},
        emails = {},
        embed_files = {},
        entities = {},
        escapes = {},
        footnotes = {},
        highlights = {},
        hyperlinks = {},
        images = {},
        inline_codes = {},
        internal_links = {},
        uri_autolinks = {}
    },
    typst = {
        enable = true,

        codes = {},
        escapes = {},
        headings = {},
        labels = {},
        list_items = {},
        math_blocks = {},
        math_spans = {},
        raw_blocks = {},
        raw_spans = {},
        reference_links = {},
        subscripts = {},
        superscript = {},
        symbols = {},
        terms = {},
        url_links = {}
    },
    yaml = {
        enable = true,

        properties = {}
    }
}
```
<!-- --_ -->
</details>

## 🎇 Commands

This plugin follows the *sub-commands* approach for creating commands. There is only a single `:Markview` command.

It comes with the following sub-commands,

>[!NOTE]
> When no sub-command name is provided(or an invalid sub-command is used) `:Markview` will run `:Markview Toggle`.


| Sub-command  | Arguments           | Description                              |
|--------------|---------------------|------------------------------------------|
| `Start`      | none                | Allows attaching to new buffers.         |
| `Stop`       | none                | Prevents attaching to new buffers.       |
| ———————————— | ——————————————————— | ———————————————————————————————————————— |
| `attach`     | **buffer**, integer | Attaches to **buffer**.                  |
| `detach`     | **buffer**, integer | Detaches from **buffer**.                |
| ———————————— | ——————————————————— | ———————————————————————————————————————— |
| `Enable`     | none                | Enables preview *globally*.              |
| `Disable`    | none                | Disables preview *globally*.             |
| `Toggle`     | none                | Toggles preview *globally*.              |
| ———————————— | ——————————————————— | ———————————————————————————————————————— |
| `enable`     | **buffer**, integer | Enables preview for **buffer**.          |
| `disable`    | **buffer**, integer | Disables preview for **buffer**.         |
| `toggle`     | **buffer**, integer | Toggles preview for **buffer**.          |
| ———————————— | ——————————————————— | ———————————————————————————————————————— |
| `splitOpen`  | **buffer**, integer | Opens *splitview* for **buffer**.        |
| `splitClose` | none                | Closes any open *splitview*.             |
| `splitToggle`| none                | Toggles *splitview*.                     |
| `splitRedraw`| none                | Updates *splitview* contents.            |
| ———————————— | ——————————————————— | ———————————————————————————————————————— |
| `Render`     | none                | Updates preview of all *active* buffers. |
| `Clear`      | none                | Clears preview of all **active** buffer. |
| ———————————— | ——————————————————— | ———————————————————————————————————————— |
| `render`     | **buffer**, integer | Renders preview for **buffer**.          |
| `clear`      | **buffer**, integer | Clears preview for **buffer**.           |
| ———————————— | ——————————————————— | ———————————————————————————————————————— |
| `toggleAll`  | none                | **Deprecated** version of `Toggle`.      |
| `enableAll`  | none                | **Deprecated** version of `Enable`.      |
| `disableAll` | none                | **Deprecated** version of `Disable`.     |
| ———————————— | ——————————————————— | ———————————————————————————————————————— |
| `traceExport`| none                | Exports trace logs to `trace.txt`.       |
| `traceShow`  | none                | Shows trace logs in a window.            |

>[!TIP]
> **buffer** defaults to the current buffer. So, you can run commands on the current buffer without providing the buffer.
> ```vim
> :Markview toggle "Toggles preview of the current buffer.
> ```

## 📞 Autocmds

`markview.nvim` emits various *autocmd events* during different parts of the rendering allowing users to extend the plugin's functionality.

```lua
vim.api.nvim_create_autocmd("User", {
    pattern = "MarkviewAttach",
    callback = function (event)
        --- This will have all the data you need.
        local data = event.data;

        vim.print(data);
    end
})
```

>[!NOTE]
> Autocmds are executed **after** callbacks!

Currently emitted autocmds are,

- **MarkviewAttach**
  Called when attaching to a buffer.

  Arguments,

  + `buffer`, integer
    The buffer that's being attached to.

  + `windows`, integer[]
    List of windows attached to `buffer`.

- **MarkviewDetach**
  Called when detaching from a buffer.

  Arguments,

  + `buffer`, integer
    The buffer that's being detached from.

  + `windows`, integer[]
    List of windows attached to `buffer`.

- **MarkviewDisable**
  Called when disabling previews in a buffer.

  Arguments,

  + `buffer`, integer
    The buffer whose the preview was disabled.

  + `windows`, integer[]
    List of windows attached to `buffer`.

- **MarkviewEnable**
  Called when enabling previews in a buffer.

  Arguments,

  + `buffer`, integer
    The buffer whose the preview was enabled.

  + `windows`, integer[]
    List of windows attached to `buffer`.

- **MarkviewSplitviewClose**
  Called when the splitview window is closed. Called *before* splitview is closed.

  Arguments,

  + `source`, integer
    The buffer whose contents are being shown.

  + `preview_buffer`, integer
    The buffer that's showing the preview.

  + `preview_window`, integer
    The window where the `preview_buffer` is being shown.

- **MarkviewSplitviewOpen**
  Called when the splitview window is opened.

  Arguments,

  + `source`, integer
    The buffer whose contents are being shown.

  + `preview_buffer`, integer
    The buffer that's showing the preview.

  + `preview_window`, integer
    The window where the `preview_buffer` is being shown.

## 🎨 Highlight groups

`markview.nvim` creates a number of *primary highlight groups* that are used by most of the decorations.

>[!IMPORTANT]
> These groups are all **generated** during runtime and as such their colors may look different.

If you want to create your own *dynamic* highlight groups or modify existing ones, see the [custom highlight groups](placeholder) section.


| Highlight group      | Generated from                           | Default                     |
|----------------------|------------------------------------------|-----------------------------|
| MarkviewPalette0     | Normal(bg) + Comment(fg)                 | fg: `#9399b2` bg: `#35374a` |
| MarkviewPalette0Fg   | Comment(fg)                              | fg: `#9399b2`               |
| MarkviewPalette0Bg   | Normal(bg) + Comment(fg)                 | bg: `#35374a`               |
| MarkviewPalette0Sign | Normal(bg) + Comment(fg), LineNr(bg)     | fg: `#9399b2`               |
| ———————————————————— | ———————————————————————————————————————— | ——————————————————————————— |
| MarkviewPalette1     | Normal(bg) + markdownH1(fg)              | fg: `#f38ba8` bg: `#4d3649` |
| MarkviewPalette1Fg   | markdownH1(fg)                           | fg: `#f38ba8`               |
| MarkviewPalette1Bg   | Normal(bg) + markdownH1(fg)              | bg: `#4d3649`               |
| MarkviewPalette1Sign | Normal(bg) + markdownH1(fg), LineNr(bg)  | fg: `#f38ba8`               |
| ———————————————————— | ———————————————————————————————————————— | ——————————————————————————— |
| MarkviewPalette2     | Normal(bg) + markdownH2(fg)              | fg: `#f9b387` bg: `#4d3d43` |
| MarkviewPalette2Fg   | markdownH2(fg)                           | fg: `#f9b387`               |
| MarkviewPalette2Bg   | Normal(bg) + markdownH2(fg)              | bg: `#4d3d43`               |
| MarkviewPalette2Sign | Normal(bg) + markdownH2(fg), LineNr(bg)  | fg: `#f9b387`               |
| ———————————————————— | ———————————————————————————————————————— | ——————————————————————————— |
| MarkviewPalette3     | Normal(bg) + markdownH3(fg)              | fg: `#f9e2af` bg: `#4c474b` |
| MarkviewPalette3Fg   | markdownH3(fg)                           | fg: `#f9e2af`               |
| MarkviewPalette3Bg   | Normal(bg) + markdownH3(fg)              | bg: `#4c474b`               |
| MarkviewPalette3Sign | Normal(bg) + markdownH3(fg), LineNr(bg)  | fg: `#f9e2af`               |
| ———————————————————— | ———————————————————————————————————————— | ——————————————————————————— |
| MarkviewPalette4     | Normal(bg) + markdownH4(fg)              | fg: `#a6e3a1` bg: `#3c4948` |
| MarkviewPalette4Fg   | markdownH4(fg)                           | fg: `#a6e3a1`               |
| MarkviewPalette4Bg   | Normal(bg) + markdownH4(fg)              | bg: `#3c4948`               |
| MarkviewPalette4Sign | Normal(bg) + markdownH4(fg), LineNr(bg)  | fg: `#a6e3a1`               |
| ———————————————————— | ———————————————————————————————————————— | ——————————————————————————— |
| MarkviewPalette5     | Normal(bg) + markdownH5(fg)              | fg: `#74c7ec` bg: `#314358` |
| MarkviewPalette5Fg   | markdownH5(fg)                           | fg: `#74c7ec`               |
| MarkviewPalette5Bg   | Normal(bg) + markdownH5(fg)              | bg: `#314358`               |
| MarkviewPalette5Sign | Normal(bg) + markdownH5(fg), LineNr(bg)  | fg: `#74c7ec`               |
| ———————————————————— | ———————————————————————————————————————— | ——————————————————————————— |
| MarkviewPalette6     | Normal(bg) + markdownH6(fg)              | fg: `#b4befe` bg: `#3c405b` |
| MarkviewPalette6Fg   | markdownH6(fg)                           | fg: `#b4befe`               |
| MarkviewPalette6Bg   | Normal(bg) + markdownH6(fg)              | bg: `#3c405b`               |
| MarkviewPalette6Sign | Normal(bg) + markdownH6(fg), LineNr(bg)  | fg: `#b4befe`               |
| ———————————————————— | ———————————————————————————————————————— | ——————————————————————————— |
| MarkviewPalette7     | Normal(bg) + @conditional(fg)            | fg: `#cba6f7` bg: `#403b5a` |
| MarkviewPalette7Fg   | @conditional(fg)                         | fg: `#cba6f7`               |
| MarkviewPalette7Bg   | Normal(bg) + @conditional(fg)            | bg: `#403b5a`               |
| MarkviewPalette7Sign | Normal(bg) + @conditional(fg), LineNr(bg)| fg: `#cba6f7`               |


> The source highlight group's values are turned into `Lab` color-space and then mixed to reduce unwanted results.

These groups are then used as links by other groups responsible for various preview elements,

>[!NOTE]
> These groups exist for the sake of *backwards compatibility* and *ease of use*.
>
> You will see something like `fg: Normal`, it means the *fg* of Normal was used as the *fg* of that group.


| Highlight group           | value                                      |
|---------------------------|--------------------------------------------|
| MarkviewBlockQuoteDefault | link: `MarkviewPalette0Fg`                 |
| MarkviewBlockQuoteError   | link: `MarkviewPalette1Fg`                 |
| MarkviewBlockQuoteNote    | link: `MarkviewPalette5Fg`                 |
| MarkviewBlockQuoteOk      | link: `MarkviewPalette4Fg`                 |
| MarkviewBlockQuoteSpecial | link: `MarkviewPalette3Fg`                 |
| MarkviewBlockQuoteWarn    | link: `MarkviewPalette2Fg`                 |
| ————————————————————————— | —————————————————————————————————————————— |
| MarkviewCheckboxCancelled | link: `MarkviewPalette0Fg`                 |
| MarkviewCheckboxChecked   | link: `MarkviewPalette4Fg`                 |
| MarkviewCheckboxPending   | link: `MarkviewPalette2Fg`                 |
| MarkviewCheckboxProgress  | link: `MarkviewPalette6Fg`                 |
| MarkviewCheckboxUncheked  | link: `MarkviewPalette1Fg`                 |
| MarkviewCheckboxStriked   | link\*: `MarkviewPalette0Fg`               |
| ————————————————————————— | —————————————————————————————————————————— |
| MarkviewCode              | bg\*\*: `normal` ± 5%(L)                   |
| MarkviewCodeInfo          | bg\*\*: `normal` ± 5%(L), fg: `comment`    |
| MarkviewCodeFg            | fg\*\*: `normal` ± 5%(L)                   |
| MarkviewInlineCode        | fg\*\*: `normal` ± 10%(L)                  |
| ————————————————————————— | —————————————————————————————————————————— |
| MarkviewIcon0             | link\*\*\*: `MarkviewPalette0Fg`           |
| MarkviewIcon1             | link\*\*\*: `MarkviewPalette1Fg`           |
| MarkviewIcon2             | link\*\*\*: `MarkviewPalette5Fg`           |
| MarkviewIcon3             | link\*\*\*: `MarkviewPalette4Fg`           |
| MarkviewIcon4             | link\*\*\*: `MarkviewPalette3Fg`           |
| MarkviewIcon5             | link\*\*\*: `MarkviewPalette2Fg`           |
| ————————————————————————— | —————————————————————————————————————————— |
| MarkviewGradient0         | fg: `Normal`                               |
| MarkviewGradient1         | fg\*\*\*\*: `lerp(Normal, Title, 1/9)`     |
| MarkviewGradient2         | fg\*\*\*\*: `lerp(Normal, Title, 2/9)`     |
| MarkviewGradient3         | fg\*\*\*\*: `lerp(Normal, Title, 3/9)`     |
| MarkviewGradient4         | fg\*\*\*\*: `lerp(Normal, Title, 4/9)`     |
| MarkviewGradient5         | fg\*\*\*\*: `lerp(Normal, Title, 5/9)`     |
| MarkviewGradient6         | fg\*\*\*\*: `lerp(Normal, Title, 6/9)`     |
| MarkviewGradient7         | fg\*\*\*\*: `lerp(Normal, Title, 7/9)`     |
| MarkviewGradient8         | fg\*\*\*\*: `lerp(Normal, Title, 8/9)`     |
| MarkviewGradient9         | fg: `Title`                                |
| ————————————————————————— | —————————————————————————————————————————— |
| MarkviewHeading1          | link: `MarkviewPalette1`                   |
| MarkviewHeading2          | link: `MarkviewPalette2`                   |
| MarkviewHeading3          | link: `MarkviewPalette3`                   |
| MarkviewHeading4          | link: `MarkviewPalette4`                   |
| MarkviewHeading5          | link: `MarkviewPalette5`                   |
| MarkviewHeading6          | link: `MarkviewPalette6`                   |
| ————————————————————————— | —————————————————————————————————————————— |
| MarkviewEmail             | link: `@markup.link.url.markdown_inline`   |
| MarkviewHyperlink         | link: `@markup.link.label.markdown_inline` |
| MarkviewImage             | link: `@markup.link.label.markdown_inline` |
| ————————————————————————— | —————————————————————————————————————————— |
| MarkviewSubscript         | link: `MarkviewPalette3Fg`                 |
| MarkviewSuperscript       | link: `MarkviewPalette6Fg`                 |
| ————————————————————————— | —————————————————————————————————————————— |
| MarkviewListItemMinus     | link: `MarkviewPalette2Fg`                 |
| MarkviewListItemPlus      | link: `MarkviewPalette4Fg`                 |
| MarkviewListItemStar      | link: `MarkviewPalette6Fg`                 |
| ————————————————————————— | —————————————————————————————————————————— |
| MarkviewTableHeader       | link: `@markup.heading.markdown`           |
| MarkviewTableBorder       | link: `MarkviewPalette5Fg`                 |
| MarkviewTableAlignCenter  | link: `MarkviewPalette5Fg`                 |
| MarkviewTableAlignLeft    | link: `MarkviewPalette5Fg`                 |
| MarkviewTableAlignRight   | link: `MarkviewPalette5Fg`                 |


> \* = Only the foreground color is used. Strikeout is added.
> 
> \*\* = The color is converted to HSL and it's luminosity(L) is increased/decreased by the specified amount.
> 
> \*\*\* = The background color of `MarkviewCode` is added to the groups.
> 
> \*\*\*\* = Linearly interpolated value between 2 highlight groups `fg`.

------

Also available in vimdoc, `:h markview.nvim`.

