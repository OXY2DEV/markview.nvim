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

+ Supports previewing <code>HTML</code>, $LaTeX$, `Markdown`, `Typst` & `YAML`.
+ Highly customisable! Everything is done via the *configuration table* to ensure maximum customisability.
+ Hybrid editing mode! Allows editing & *previewing* files at the same time.
+ Split view! Allows previewing files on a separate window that updates in real-time!
+ Previews are compatible with `'wrap'`(only for `markdown` at the moment).
+ Dynamic config that allows **any** option to be a function.
+ Dynamic `highlight groups` that automatically updates with the colorscheme.

### 📜 Complete feature-list

<details>
    <summary>Expand to see complete feature list</summary><!--+-->

#### HTML features,

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/repo/html-tokyonight_night.png">

+ Allows customising how various container & void elements are shown.
+ Supports *heading* elements out of the box.
+ Supports the following container elements out of the box,
    + `<a></a>`
    + `<b></b>`
    + `<code></code>`
    + `<em></em>`
    + `<i></i>`
    + `<mark></mark>`
    + `<strong></strong>`
    + `<pre></pre>`
    + `<sub></sub>`
    + `<sup></sup>`
    + `<u></u>`

+ Supports the following void elements out of the box,
    + `<hr>`
    + `<br>`

#### LaTeX features,

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

#### Markdown features,

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

#### Markdown inline features,

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

#### Typst features,

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

#### YAML features,

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

#### Hybrid mode features,


| Normal hybrid mode | Linewise hybrid mode |
|--------------------|----------------------|
| ![hybrid_mode](https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/hybrid_mode.png) | ![linewise_hybrid_mode](https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/linewise_hybrid_mode.png) |


+ *Node-based* edit range.
  Clears a range of lines covered by the (named)`TSNode` under the cursor. Useful when editing lists, block quotes, code blocks, tables etc.

+ *Range-based* edit range.
  Clears the selected number of lines above & below the cursor.

+ Works even when a `buffer` is being viewed by multiple `window`s.

Internal Icon provider features,

+ **708** different filetype configuration.
+ Dynamic highlight groups for matching the colorscheme.

#### Tracing features,

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
Plug 'OXY2DEV/markview.nvim'
```

### 💤 Lazy.nvim

>[!WARNING]
> Do *not* lazy load this plugin as it is already lazy-loaded. Lazy-loading may cause **more time** for the previews to load when starting Neovim!

The plugin should be loaded *after* your colorscheme to ensure the correct highlight groups are used.

```lua
-- For `plugins/markview.lua` users.
return {
    "OXY2DEV/markview.nvim",
    lazy = false,

    -- For blink.cmp's completion
    -- source
    -- dependencies = {
    --     "saghen/blink.cmp"
    -- },
};
```

```lua
-- For `plugins.lua` users.
{
    "OXY2DEV/markview.nvim",
    lazy = false,

    -- For blink.cmp's completion
    -- source
    -- dependencies = {
    --     "saghen/blink.cmp"
    -- },
},
```

### 🦠 Mini.deps

```lua
local MiniDeps = require("mini.deps");

MiniDeps.add({
    source = "OXY2DEV/markview.nvim",

    -- For blink.cmp's completion
    -- source
    -- depends = {
    --     "saghen/blink.cmp"
    -- },
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

- Incorrect wrapping when setting `wrap` using `modeline`.
  This is due to `textoff` being 0(instead of the size of the `statuscolumn`) when entering a buffer.

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
        prefer_nvim = true,
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

| Sub-command      | Arguments           | Description                              |
|------------------|---------------------|------------------------------------------|
| `Toggle`         | none                | Toggles preview *globally*.              |
| `Enable`         | none                | Enables preview *globally*.              |
| `Disable`        | none                | Disables preview *globally*.             |
| ———————————————— | ——————————————————— | ———————————————————————————————————————— |
| `toggle`         | **buffer**, integer | Toggles preview for **buffer**.          |
| `enable`         | **buffer**, integer | Enables preview for **buffer**.          |
| `disable`        | **buffer**, integer | Disables preview for **buffer**.         |
| ———————————————— | ——————————————————— | ———————————————————————————————————————— |
| `splitToggle`    | none                | Toggles *splitview*.                     |


<details>
    <summary>Advanced commands are given below</summary><!-- --+ -->

Sub-commands related to auto-registering new buffers for previews and/or manually attaching/detaching buffers,

| Sub-command      | Arguments           | Description                              |
|------------------|---------------------|------------------------------------------|
| `Start`          | none                | Allows attaching to new buffers.         |
| `Stop`           | none                | Prevents attaching to new buffers.       |
| ———————————————— | ——————————————————— | ———————————————————————————————————————— |
| `attach`         | **buffer**, integer | Attaches to **buffer**.                  |
| `detach`         | **buffer**, integer | Detaches from **buffer**.                |

Sub-commands related to controlling **hybrid_mode**,

| Sub-command      | Arguments           | Description                              |
|------------------|---------------------|------------------------------------------|
| `HybridEnable`   | none                | Enables hybrid mode.                     |
| `HybridDisable`  | none                | Disables hybrid mode.                    |
| `HybridToggle`   | none                | Toggles hybrid mode.                     |
| ———————————————— | ——————————————————— | ———————————————————————————————————————— |
| `hybridEnable`   | **buffer**, integer | Enables hybrid mode for **buffer**.      |
| `hybridDisable`  | **buffer**, integer | Disables hybrid mode for **buffer**.     |
| `hybridToggle`   | **buffer**, integer | Toggles hybrid mode for **buffer**.      |
| ———————————————— | ——————————————————— | ———————————————————————————————————————— |
| `linewiseEnable` | none                | Enables linewise hybrid mode.            |
| `linewiseDisable`| none                | Disables linewise hybrid mode.           |
| `linewiseToggle` | none                | Toggles linewise hybrid mode.            |

Sub-commands for working with `splitview`,

| Sub-command      | Arguments           | Description                              |
|------------------|---------------------|------------------------------------------|
| `splitOpen`      | **buffer**, integer | Opens *splitview* for **buffer**.        |
| `splitClose`     | none                | Closes any open *splitview*.             |
| `splitRedraw`    | none                | Updates *splitview* contents.            |

Sub-commands for manual `preview` updates,

| Sub-command      | Arguments           | Description                              |
|------------------|---------------------|------------------------------------------|
| `Render`         | none                | Updates preview of all *active* buffers. |
| `Clear`          | none                | Clears preview of all **active** buffer. |
| ———————————————— | ——————————————————— | ———————————————————————————————————————— |
| `render`         | **buffer**, integer | Renders preview for **buffer**.          |
| `clear`          | **buffer**, integer | Clears preview for **buffer**.           |

Sub-commands for `bug report`,

| Sub-command      | Arguments           | Description                              |
|------------------|---------------------|------------------------------------------|
| `traceExport`    | none                | Exports trace logs to `trace.txt`.       |
| `traceShow`      | none                | Shows trace logs in a window.            |

</details>

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

You can find more details on highlight groups [here](https://github.com/OXY2DEV/markview.nvim/wiki/Home#-highlight-groups). The following highlight groups are created by the plugin,

>[!NOTE]
> The value of these groups are updated when changing the colorscheme!

- `MarkviewPalette0`, has a background & foreground.
- `MarkviewPalette0Fg`, only the foreground
- `MarkviewPalette0Bg`, only the background.
- `MarkviewPalette0Sign`, background of the sign column(`LineNr`) & foreground.

- `MarkviewPalette1`
- `MarkviewPalette1Fg`
- `MarkviewPalette1Bg`
- `MarkviewPalette1Sign`

- `MarkviewPalette2`
- `MarkviewPalette2Fg`
- `MarkviewPalette2Bg`
- `MarkviewPalette2Sign`

- `MarkviewPalette3`
- `MarkviewPalette3Fg`
- `MarkviewPalette3Bg`
- `MarkviewPalette3Sign`

- `MarkviewPalette4`
- `MarkviewPalette4Fg`
- `MarkviewPalette4Bg`
- `MarkviewPalette4Sign`

- `MarkviewPalette5`
- `MarkviewPalette5Fg`
- `MarkviewPalette5Bg`
- `MarkviewPalette5Sign`

- `MarkviewPalette6`
- `MarkviewPalette6Fg`
- `MarkviewPalette6Bg`
- `MarkviewPalette6Sign`

- `MarkviewCode`.
- `MarkviewCodeInfo`.
- `MarkviewCodeFg`.
- `MarkviewInlineCode`.

>[!NOTE]
> These groups are meant to create a gradient!

- `MarkviewGradient0`
- `MarkviewGradient1`
- `MarkviewGradient2`
- `MarkviewGradient3`
- `MarkviewGradient4`
- `MarkviewGradient5`
- `MarkviewGradient6`
- `MarkviewGradient7`
- `MarkviewGradient8`
- `MarkviewGradient9`

------

- `MarkviewBlockQuoteDefault`, links to `MarkviewPalette0Fg`.
- `MarkviewBlockQuoteError`, links to `MarkviewPalette1Fg`.
- `MarkviewBlockQuoteNote`, links to `MarkviewPalette5Fg`.
- `MarkviewBlockQuoteOk`, links to `MarkviewPalette4Fg`.
- `MarkviewBlockQuoteSpecial`, links to `MarkviewPalette3Fg`.
- `MarkviewBlockQuoteWarn`, links to `MarkviewPalette2Fg`.

- `MarkviewCheckboxCancelled`, links to `MarkviewPalette0Fg`.
- `MarkviewCheckboxChecked`, links to `MarkviewPalette4Fg`.
- `MarkviewCheckboxPending`, links to `MarkviewPalette2Fg`.
- `MarkviewCheckboxProgress`, links to `MarkviewPalette6Fg`.
- `MarkviewCheckboxUnchecked`, links to `MarkviewPalette1Fg`.
- `MarkviewCheckboxStriked`, links to `MarkviewPalette0Fg`[^1].

- `MarkviewIcon0`, links to `MarkviewPalette0Fg`[^2].
- `MarkviewIcon1`, links to `MarkviewPalette1Fg`[^2].
- `MarkviewIcon2`, links to `MarkviewPalette2Fg`[^2].
- `MarkviewIcon3`, links to `MarkviewPalette3Fg`[^2].
- `MarkviewIcon4`, links to `MarkviewPalette4Fg`[^2].
- `MarkviewIcon5`, links to `MarkviewPalette5Fg`[^2].
- `MarkviewIcon6`, links to `MarkviewPalette6Fg`[^2].

- `MarkviewHeading1`, links to `MarkviewPalette1`.
- `MarkviewHeading2`, links to `MarkviewPalette2`.
- `MarkviewHeading3`, links to `MarkviewPalette3`.
- `MarkviewHeading4`, links to `MarkviewPalette4`.
- `MarkviewHeading5`, links to `MarkviewPalette5`.
- `MarkviewHeading6`, links to `MarkviewPalette6`.

- `MarkviewHeading1Sign`, links to `MarkviewPalette1Sign`.
- `MarkviewHeading2Sign`, links to `MarkviewPalette2Sign`.
- `MarkviewHeading3Sign`, links to `MarkviewPalette3Sign`.
- `MarkviewHeading4Sign`, links to `MarkviewPalette4Sign`.
- `MarkviewHeading5Sign`, links to `MarkviewPalette5Sign`.
- `MarkviewHeading6Sign`, links to `MarkviewPalette6Sign`.

- `MarkviewHyperlink`, links to `@markup.link.label.markdown_inline`.
- `MarkviewImage`, links to `@markup.link.label.markdown_inline`.
- `MarkviewEmail`, links to `@markup.link.url.markdown_inline`.

- `MarkviewSubscript`, links to `MarkviewPalette3Fg`.
- `MarkviewSuperscript`, links to `MarkviewPalette6Fg`.

- `MarkviewListItemMinus`, links to `MarkviewPalette2Fg`.
- `MarkviewListItemPlus`, links to `MarkviewPalette4Fg`.
- `MarkviewListItemStar`, links to `MarkviewPalette6Fg`.

- `MarkviewTableHeader`, links to `@markup.heading.markdown`.
- `MarkviewTableBorder`, links to `MarkviewPalette5Fg`.
- `MarkviewTableAlignLeft`, links to `@markup.heading.markdown`.
- `MarkviewTableAlignCenter`, links to `@markup.heading.markdown`.
- `MarkviewTableAlignRight`, links to `@markup.heading.markdown`.

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

- `dashed`
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
- [X] Make `splitview` update as little content as possible.
- [X] Make the help files/wiki more beginner friendly.

------

[^1]: The value of the linked group is used **literally**. So, manually changing the link group wouldn't work for this.
[^2]: The value of `MarkviewCode` is used for the background. So, changing either of the linked group wouldn't affect these.

