<h1 align="center">☄️ Markview.nvim</h1>

<p align="center">
    A hackable <b>Markdown</b>, <b>HTML</b>, <b>LaTeX</b>, <b>Typst</b> & <b>YAML</b> previewer for Neovim.
</p>

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/repo/markdown-catppuccin_mocha.png">

<div align="center">
    <a href="https://github.com/OXY2DEV/markview.nvim/wiki/Home">📚 Wiki</a> | <a href="#-extra-modules">🧩 Extras</a> | <a href="#-presets">📦 Presets</a>
</div>

## 📖 Table of contents

- [✨ Features](#-features)
- [📚 Requirements](#-requirements)
- [📐 Installation](#-installation)
- [🧭 Configuration](#-configuration)

- [🎇 Commands](#-commands)
- [📞 Autocmds](#-autocmds)
- [🎨 Highlight groups](#-highlight-groups)

- [🎁 Extra modules](#-extra-modules)

## ✨ Features

Core features,

+ Supports HTML, LaTeX, Markdown, Typst & YAML.
+ Highly customisable! Everything is done via the *configuration table* to ensure maximum customisability.
+ Hybrid editing mode! Allows editing & *previewing* files at the same time.
+ Split view! Allows previewing files on a separate window that updates in real-time!
+ Partial *text wrap* support(only for markdown at the moment).
+ Dynamic config that allows **any** option to be a function.
+ Dynamic `highlight groups` that automatically updates with the colorscheme.

<details>
    <summary>Expand to see complete feature list</summary><!--+-->

HTML features,

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/repo/html-tokyonight_night.png">

+ Allows customising how various container & void elements are shown.
+ Supports *heading* elements out of the box.
+ Supports the following container elements out of the box,
    + `<b></b>`
    + `<code></code>`
    + `<em></em>`
    + `<i></i>`
    + `<mark></mark>`
    + `<strong></strong>`
    + `<sub></sub>`
    + `<sup></sup>`
    + `<u></u>`

+ Supports the following void elements out of the box,
    + `<hr>`
    + `<br>`

LaTeX features,

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/repo/latex-cyberdream.png">

+ Supports the following items,
    + Math blocks(typically `$$...$$`) & inline math(typically `$...$`).
    + LaTeX commands.
    + Escaped characters.
    + Math fonts
    + Subscript.
    + Superscript.
    + Math symbols.
    + `\text{}`.

+ Supports commonly used math commands out of the box,
    + `\frac{}`
    + `\sin{}`
    + `\cos{}`
    + `\tan{}`
    + `\sinh{}`
    + `\cosh{}`
    + `\tanh{}`
    + `\csc{}`
    + `\sec{}`
    + `\cot{}`
    + `\csch{}`
    + `\sech{}`
    + `\coth{}`
    + `\arcsin{}`
    + `\arccos{}`
    + `\arctan{}`
    + `\arg{}`
    + `\deg{}`
    + `\drt{}`
    + `\dim{}`
    + `\exp{}`
    + `\gcd{}`
    + `\hom{}`
    + `\inf{}`
    + `\ker{}`
    + `\lg{}`
    + `\lim{}`
    + `\liminf{}`
    + `\limsup{}`
    + `\ln{}`
    + `\log{}`
    + `\min{}`
    + `\max{}`
    + `\Pr{}`
    + `\sup{}`
    + `\sqrt{}`
    + `\lvert{}`
    + `\lVert{}`
    + `\boxed{}`

+ Supports the following fonts(requires any *modern* Unicode font),
    + `default`(Default math font).
    + `\mathbb{}`
    + `\mathbf{}`
    + `\mathbffrak{}`
    + `\mathbfit{}`
    + `\nathbfscr{}`
    + `\mathcal{}`
    + `\mathfrak{}`
    + `\mathsf{}`
    + `\mathsfbf{}`
    + `\mathsfbfit{}`
    + `\mathsfit{}`
    + `\mathtt{}`

+ Supports Unicode based *subscript* & *superscript* texts.
+ Supports **2056** different math symbol definitions.

Markdown features,

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/repo/markdown-catppuccin_mocha.png">

+ Supports the following items,
    + Block quotes(with support for `callouts` & titles).
    + Fenced code blocks.
    + Headings(setext & atx).
    + Horizontal rules.
    + List items(`+`, `-`, `*`, `n.` & `n)`).
    + Minus & plus metadata.
    + Reference link definitions.
    + Tables.

+ `wrap` option support for the following items,
    + Block quotes.
    + Headings(when `org_indent` is used).
    + List items(when `add_padding` is true).

+ Org-mode like indentation for headings.

Markdown inline features,

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/repo/markdown_inline-nightfly.png">

+ Supports the following items,
    + Checkboxes(supports *minimal-style* checkboxes).
    + Email links.
    + Entities.
    + Escaped characters.
    + Footnotes.
    + Hyperlinks.
    + Images.
    + Inline codes/Code spans.
    + URI autolinks.

+ Obsidian/PKM extended item support,
    + Block reference links.
    + Embed file links.
    + Internal links(supports *aliases*).

+ Wide variety of HTML entity names & codes support.
    + Supported named entities: **786**.
    + Supported entity codes: **853**.

+ Github emoji shorthands support. Supports **1920** shorthands.

+ Custom configuration based on link patterns.

Typst features,

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/repo/typst-kanagawa_wave.png">

+ Supports the following items,
    + Code blocks.
    + Code spans.
    + Escaped characters.
    + Headings.
    + Labels.
    + List items(`-`, `+` & `n.`).
    + Math blocks.
    + Math spans.
    + Raw blocks.
    + Raw spans.
    + Reference links.
    + Subscripts.
    + Superscripts.
    + Symbols.
    + Terms.
    + URL links.

+ Supports a variety of typst symbols,
    + Symbol entries: **932**
    + Symbol shorthands: **40**

+ Supports Unicode based *subscript* & *superscript* texts.

YAML features,

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/repo/yaml-material_palenight.png">

- Custom property icons.
- Custom property scope decorations.
- Custom icons(/decorations) based on property type & value(e.g. `booleans`).

- Supports the following properties out of the box,
    + tags.
    + aliases.
    + cssclasses.
    + publish.
    + permalink.
    + description.
    + images.
    + cover.

---

Hybrid mode features,


| Normal hybrid mode | Linewise hybrid mode |
|--------------------|----------------------|
| ![hybrid_mode](https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/hybrid_mode.png) | ![linewise_hybrid_mode](https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/linewise_hybrid_mode.png) |


+ *Node-based* edit range.
  Clears the current nodes range of lines. Useful when editing lists, block quotes, code blocks, tables etc.

+ *Range-based* edit range.
  Clears the selected number of lines above & below the cursor.

+ Supports multiple cursors to.

Internal Icon provider features,

+ **708** different filetype configuration.
+ Dynamic highlight groups for matching the colorscheme.

Tracing features,

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/repo/traceback.png">

+ You can use `:Markview traceShow` to see what the plugin has been doing(including how long some of them took).
- You can also use `:Markview traceExport` to export these logs.

<!--_-->
</details>

## 📚 Requirements

System,

- **Neovim:** 0.10.3

>[!NOTE]
> It is recommended to use `nowrap`(though there is wrap support in the plugin) & `expandtab`.

---

Colorscheme,

- Any *tree-sitter* based colorscheme is recommended.

External icon providers,

>[!NOTE]
> You need to change the config to use the desired icon provider.
> 
> ```lua
> {
>     preview = {
>         icon_provider = "internal", -- "mini" or "devicons"
>     }
> }
> ```

- [mini.icons](https://github.com/echasnovski/mini.icons)
- [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)

Parsers,

>[!TIP]
> You can use `nvim-treesitter` to easily install parsers. You can install all the parsers with the following command,
> 
> ```vim
> :TSInstall markdown markdown_inline html latex typst yaml
> ```

>[!IMPORTANT]
> On windows, you might need `tree-sitter` CLI for the $LaTeX$ parser.

- `markdown`
- `markdown_inline`
- `html`(optional)
- `latex`(optional)
- `typst`(optional)
- `yaml`(optional)

Fonts,

- Any *modern* Unicode font is required for math symbols.
- *Nerd fonts* are recommended.

>[!TIP]
> It is recommended to run `:checkhealth markview` after installing the plugin to check if any potential issues exist.

## 📐 Installation

### 🧩 Vim-plug

Add this to your plugin list.

```vim
Plug "OXY2DEV/markview.nvim"
```

### 💤 Lazy.nvim

>[!WARNING]
> Do *not* lazy load this plugin as it is already lazy-loaded.
>
> Lazy-loading will cause **more time** for the previews to load when starting Neovim.

The plugin should be loaded *after* your colorscheme to ensure the correct highlight groups are used.

```lua
-- For `plugins/markview.lua` users.
return {
    "OXY2DEV/markview.nvim",
    lazy = false
};
```

```lua
-- For `plugins.lua` users.
{
    "OXY2DEV/markview.nvim",
    lazy = false
},
```

### 🦠 Mini.deps

```lua
local MiniDeps = require("mini.deps");

MiniDeps.add({
    source = "OXY2DEV/markview.nvim"
});
```

### 🌒 Rocks.nvim

>[!WARNING]
> `luarocks package` may sometimes be a bit behind `main`.

```vim
:Rocks install markview.nvim
```

### 📥 GitHub release

Tagged releases can be found in the [release page](https://github.com/OXY2DEV/markview.nvim/releases).

>[!NOTE]
> `Github releases` may sometimes be slightly behind `main`.

### 🚨 Development version

You can use the [dev](https://github.com/OXY2DEV/markview.nvim/tree/dev) branch to use test features.

>[!WARNING]
> Development releases can contain *breaking changes* and **experimental changes**.
> Use at your own risk!

```lua
return {
    "OXY2DEV/markview.nvim",
    branch = "dev",
    lazy = false
};
```

## 🪲 Known bugs

- `code span`s don't get recognized when on the line after a `code block`(if the line after the `code span` is empty).
  This is most likely due to some bug in either the `markdown` or the `markdown_inline` parser.

## 🧭 Configuration

Check the [wiki](https://github.com/OXY2DEV/markview.nvim/wiki) for the entire configuration table. A simplified version is given below.

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

Additional command(s),

- `MarkOpen`, Opens the link under cursor, falls back to **vim.ui.open()**.

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

## 🌟 Presets

>[!IMPORTANT]
> Presets are looking for contributors!
>
> If you have any custom configuration that you would like to have as a preset you can open a `pull request` for that.

Check the [wiki page](https://github.com/OXY2DEV/markview.nvim/wiki) for more information.

### 📚 Usage

```lua
local presets = require("markview.presets");

require("markview").setup({
    markdown = {
        headings = presets.headings.slanted
    }
});
```

Currently available presets are,

### headings

Accessed using `require("markview.presets").headings`.

- `glow`
  Like the headings in the `Glow` CLI app.

- `glow_center`
  Centered version of `glow`.

- `slanted`
  Heading level + slanted tail.

- `arrowed`
  Heading level + arrowed tail.

- `simple`
  Headings similar to headings in some books.

- `marker`
  Simple marker for heading level.

### horizontal_rules

Accessed using `require("markview.presets").horizontal_rules`.

- `thin`
  Simple line.

- `thick`
  Slightly thicker line.

- `double`
  Double lines.

- `dahsed`
  Dashed line.

- `dotted`
  Dotted line.

- `solid`
  Very thick line.

- `arrowed`
  Arrowed line.

### tables

Accessed using `require("markview.presets").tables`.

- `none`
  Border-less table(kinda like the ones used in some help files).

- `single`
  Single border table.

- `double`
  Double border table.

- `rounded`
  Single border with rounded edges(default).

- `solid`
  Solid border table.

## 🎁 Extra modules

`markview.nvim` comes with a few *extra* things for added functionality. Currently available modules are,

- [checkboxes.lua](https://github.com/OXY2DEV/markview.nvim/blob/main/lua/markview/extras/checkboxes.lua)
  Checkbox toggle, state change & more! Supports visual mode too with checkbox state caching!
  [Wiki section](https://github.com/OXY2DEV/markview.nvim/wiki/Extra-modules#-checkboxes)

- [editor.lua](https://github.com/OXY2DEV/markview.nvim/blob/main/lua/markview/extras/editor.lua)
  A simple `code block` creator & editor with support for nested elements!
  [Wiki section](https://github.com/OXY2DEV/markview.nvim/wiki/Extra-modules#-editor)

- [headings.lua](https://github.com/OXY2DEV/markview.nvim/blob/main/lua/markview/extras/headings.lua)
  Simple heading level changer with support for `setext` headings.
  [Wiki section](https://github.com/OXY2DEV/markview.nvim/wiki/Extra-modules#-heading)

Example usage,

```lua
-- Load the checkboxes module.
require("markview.extras.checkboxes").setup();
```

Go over a line with a checkbox and run,

```vim
:Checkbox interactive
```
Now use `h`, `j`, `k`, `l` to change the checkbox state.

## ✅ Contributing to the projects

If you have time and want to make this project better, consider helping me fix any of these issues,

- [ ] Add support for more filetypes in the internal icon provider.
- [ ] Optimization of `require("markview.renderers.markdown").output()`.
- [ ] Optimization of the table renderer.
- [ ] Stricter logic to reduce preview redraws.
- [ ] Make `splitview` update as little content as possible.
- [ ] Make the help files/wiki more beginner friendly.

