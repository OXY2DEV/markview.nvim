# ✨ markview.nvim

https://github.com/user-attachments/assets/ae3d2912-65d4-4dd7-a8bb-614c4406c4e3
<!-- It is not possible to use GitHub links for videos, so we have to manually upload this -->

A highly-customisable & feature rich markdown previewer inside Neovim.

<p align="center">
    <a href="https://github.com/OXY2DEV/markview.nvim/wiki">📖 Wiki page</a>
</p>

<p align="center">
    <img alt="Headings" src="https://github.com/OXY2DEV/markview.nvim/blob/images/Dev/Headings.jpg" width="75%">
&nbsp; &nbsp;
&nbsp; &nbsp;
    <img alt="Inline" src="https://github.com/OXY2DEV/markview.nvim/blob/images/Dev/Inline.jpg" width="75%">
    <img alt="Block" src="https://github.com/OXY2DEV/markview.nvim/blob/images/Dev/Blocks.jpg" width="75%">
&nbsp; &nbsp;
&nbsp; &nbsp;
    <img alt="Tables" src="https://github.com/OXY2DEV/markview.nvim/blob/images/Dev/Tables.jpg" width="75%">
    <img alt="LaTeX" src="https://github.com/OXY2DEV/markview.nvim/blob/images/Dev/LaTeX.jpg" width="75%">
&nbsp; &nbsp;
&nbsp; &nbsp;
</p>

## 🪷 Features

Markdown renderer,

- Block quote support with custom `callouts/alertd`. Supports **callout titles** too.
- Checkbox with custom `states`.
- Code blocks. Also supports **info strings** added before the code blocks.
- Footnotes.
- Headings(both atx & setext).
- Horizontal rules.
- Inline codes.
- Links(hyperlinks, image links & email).
- List items(`+`, `-`, `*`, `n.` & `n)`)
- Tables. Supports content alignment, pre-defined column widths and rendering other markdown & html syntaxes inside of table cells.

HTML renderer,

- HTML elements(only inline ones). Also supports defining styles for custom tags.
- HTML entities. Supports 242 entities(as of last edit).

LaTeX renderer,

- Inline LaTeX support.
- LaTeX block supoort.
- LaTeX symbols support. supports 1000+ symbol names.
- Font commamd support. Currently supports: `\mathbfit`, `\mathcal`, `\mathfrak`, `\mathbb`, `\mathsfbf`, `\mathsfit`, `\mathsfbfit`, `\mathtt`.
- Subscripts & superscripts

Others,

- Hybrid mode, for previewing & editing.
- Split view, for showing preview in a split.
- Presets, for easy customisation.
- Tree-sitter injections, supports overwrites too!

Extras,

- Heading level cycler.
- Checkbox toggler & cycler.

## 📦 Requirements

- Neovim version `>=0.10.0`.
- Tree-sitter parsers: `markdown`, `markdown_inline`, `html`.
- Nerd font.

Optional,

- Tree-sitter parsers: `latex`.
- `nvim-tree/nvim-web-deviconso`.
- Any modern unicode font.
- A tree-sitter supported colorscheme.

## 🧭 Installation

`markview.nvim` can be installed via your favourite plugin manager!

>[!NOTE]
> If you have manually installed the parsers then you don't need `nvim-treesitter`. Just make sure the parsers are loaded before this plugin.

### 💤 Lazy.nvim

>[!CAUTION]
> It is not recommended to **lazy load** this plugin.

```lua
{
    "OXY2DEV/markview.nvim",
    lazy = false,      -- Recommended
    -- ft = "markdown" -- If you decide to lazy-load anyway

    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    }
}
```

### 🦠 Mini.deps

```lua
local MiniDeps = require("mini.deps");

MiniDeps.add({
    source = "OXY2DEV/markview.nvim",

    depends = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    }
});
```

### 🌒 Rocks.nvim

>[!NOTE]
> `Luarocks` may receive updates a bit later as the release is done after fixing any potential bug(s).

```vim
:Rocks install markview.nvim
```

### 👾 GitHub releases

>[!NOTE]
> Releases may be slow to update as they are done after fixing potential bug(s).

[Current version: v25.0.0]()

### 🌃 Dev branch

>[!WARNING]
> `dev` branch may remain out-dated for an indefinite period of time. It is NOT meant for general use.

New features are usually done on the [dev branch]() first.

So, If you are curious about them, try this branch out!

## 💡 Configuration options

The configuration table is too large to fit here.

Go check the [wiki page]() or see `:h markview.nvim-configuration`.

Here's all the main options,
```lua
{
    -- Buffer types to ignore
    buf_ignore = { "nofile" },
    -- Delay, in miliseconds
    -- to wait before a redraw occurs(after an event is triggered)
    debounce = 50,
    -- Filetypes where the plugin is enabled
    filetypes = { "markdown", "quarto", "rmd" },
    -- Highlight groups to use
    -- "dynamic" | "light" | "dark"
    highlight_groups = "dynamic",
    -- Modes where hybrid mode is enabled
    hybrid_modes = nil,
    -- Tree-sitter query injections
    injections = {},
    -- Initial plugin state,
    -- true = show preview
    -- falss = don't show preview
    initial_state = true,
    -- Max file size that is rendered entirely
    max_file_length = 1000,
    -- Modes where preview is shown
    modes = { "n", "no", "c" },
    -- Lines from the cursor to draw when the
    -- file is too big
    render_distance = 100,
    -- Window configuration for split view
    split_conf = {},

    -- Rendering related configuration
    block_quotes = {},
    callbacks = {},
    checkboxes = {},
    code_blocks = {},
    escaped = {},
    footnotes = {},
    headings = {},
    horizontal_rules = {},
    html = {},
    inline_codes = {},
    latex = {},
    links = {},
    list_items = {},
    tables = {}
}
```

## 👀 Commands

`markview.nvim` has a single command `:Markview`.

> When used without any `subcommands`, it toggles the plugin.

Available subcommands,

- toggleAll
- enableAll
- disableAll
- toggle {n}
- enable {n}
- disable {n}
- hybridToggle
- hybridEnable
- hybridDisable
- splitToggle {n}
- splitEnable {n}
- splitDisable {n}

>[!NOTE]
> Subcommands that end with `{n}` can also take a buffer id. If a buffer id isn't provided then the current buffer's id is used.
> Completion for buffer id is also provided by the plugin.

## 🎨 Highlight groups

<p align="center">
    <img alt="Light" src="https://github.com/OXY2DEV/markview.nvim/blob/images/Dev/light.gif" width="75%">
&nbsp; &nbsp;
&nbsp; &nbsp;
    <img alt="Dark" src="https://github.com/OXY2DEV/markview.nvim/blob/images/Dev/dark.gif" width="75%">
</p>

Highlight groups defined by the plugin are given below.

+ Block quotes
  - `MarkviewBlockQuoteWarn`
  - `MarkviewBlockQuoteSpecial`
  - `MarkviewBlockQuoteNote`
  - `MarkviewBlockQuoteDefault`
  - `MarkviewBlockQuoteOk`
  - `MarkviewBlockQuoteError`

+ Checkboxes
  - `MarkviewCheckboxCancelled`
  - `MarkviewCheckboxChecked`
  - `MarkviewCheckboxPending`
  - `MarkviewCheckboxProgress`
  - `MarkviewCheckboxUnchecked`

+ Code blocks & Inline codes
  - `MarkviewInlineCode`
  - `MarkviewCodeInfo`
  - `MarkviewCode`

+ Headings
  - `MarkviewHeading1Sign`
  - `MarkviewHeading1`
  - `MarkviewHeading2Sign`
  - `MarkviewHeading2`
  - `MarkviewHeading3Sign`
  - `MarkviewHeading3`
  - `MarkviewHeading4Sign`
  - `MarkviewHeading4`
  - `MarkviewHeading5Sign`
  - `MarkviewHeading5`
  - `MarkviewHeading6Sign`
  - `MarkviewHeading6`

+ Horizontal rules
  - `MarkviewGradient1`
  - `MarkviewGradient2`
  - `MarkviewGradient3`
  - `MarkviewGradient4`
  - `MarkviewGradient5`
  - `MarkviewGradient6`
  - `MarkviewGradient7`
  - `MarkviewGradient8`
  - `MarkviewGradient9`
  - `MarkviewGradient10`

+ LaTeX
  - `MarkviewLatexSubscript`
  - `MarkviewLatexSuperscript`

+ List items
  - `MarkviewListItemStar`
  - `MarkviewListItemPlus`
  - `MarkviewListItemMinus`

+ Links
  - `MarkviewEmail`
  - `MarkviewImageLink`
  - `MarkviewHyperlink`

+ Tables
  - `MarkviewTableHeader`
  - `MarkviewTableBorder`
  - `MarkviewTableAlignCenter`
  - `MarkviewTableAlignLeft`
  - `MarkviewTableAlignRight`

## 📚 Wiki

Don't forget to check out the [wiki](https://github.com/OXY2DEV/markview.nvim/wiki)!

### 🌟 Usage example: Hybrid mode

Hybrid mode can be used by just modifying the `hybrid_modes` option.

```lua
require("markview").setup({
    hybrid_modes = { "n" }
});
```

<!--
    vim:nospell:
-->
