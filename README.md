# 📜 Markview.nvim

An experimental `markdown` previewer for Neovim.

<p align="center">
    <a href="https://github.com/OXY2DEV/markview.nvim/wiki" style="font-size: 2rem;">Wiki page</a>
</p>

![hybrid_mode_showcase](https://github.com/OXY2DEV/markview.nvim/blob/images/Main/hybrid_mode_showcase.gif)
![screenshot](https://github.com/OXY2DEV/markview.nvim/blob/images/Main/plugin_showcase_landscape.jpg)
![screenshot_small](https://github.com/OXY2DEV/markview.nvim/blob/images/Main/plugin_showcase_mobile.jpg)

## ✨ Features

Markview.nvim comes with a ton of features such as,

- Close to `full render` of markdown documents. Currently supported items are,
  * Block quotes(includes `callouts`/`alerts`
  * Chekboxes(checked, unchecked & pending state)
  * Headings(atx_headings & setext_headings)
  * Horizontal rules
  * Html support(only for simple tags, e.g. `<u>Underline</u>`)
  * Html entites(both `&<name>;` and `&<name>` support)
  * Inline codes
  * Links(hyprlinks, images & email support)
  * List item(ordered & unordered)
  * Tables
- Fully customisable setup! You can customise everything to your needs!
- A `hybrid mode` that allows rendering in real-time! It will even unconceal nodes under the cursor.
- Dynamic `highlight groups` that allows support for almost any colorscheme!
- Can be loaded on other filetypes too!

And a lot more to come!

## 📦 Requirements

- Neovim version: `0.10.0` or above.
- Tree-sitter parsers,
  * markdown
  * markdown_inline
  * html
- Nerd font.

Optional:
- A tree-sitter supported colorscheme.

## 🚀 Installation

Markview can be installed via your favourite `package manager`.

### 💤 Lazy.nvim

>[!CAUTION]
> It is not recommended to lazy-load this plugin as it does that by default.

For `lazy.lua` users.

```lua
{
    "OXY2DEV/markview.nvim",
    lazy = false,      -- Recommended
    -- ft = "markdown" -- If you decide to lazy-load anyway

    dependencies = {
        -- You will not need this if you installed the
        -- parsers manually
        -- Or if the parsers are in your $RUNTIMEPATH
        "nvim-treesitter/nvim-treesitter",

        "nvim-tree/nvim-web-devicons"
    }
}
```

For `plugins/markview.lua` users.

```lua
return {
    "OXY2DEV/markview.nvim",
    lazy = false,      -- Recommended
    -- ft = "markdown" -- If you decide to lazy-load anyway

    dependencies = {
        -- You will not need this if you installed the
        -- parsers manually
        -- Or if the parsers are in your $RUNTIMEPATH
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
        -- You may not need this if you don't lazy load
        -- Or if the parsers are in your $RUNTIMEPATH
        "nvim-treesitter/nvim-treesitter",

        "nvim-tree/nvim-web-devicons"
    }
})
```

### 🌒 Rocks.nvim

You can install the plugin by running the following command.

```vim
:Rocks install markview.nvim
```

### 👾 Github releases

You can also download one of the [releases](https://github.com/OXY2DEV/markview.nvim/releases/tag/v1.0.0).

### 🛸 Testing

If you don't mind a slightly `unstable` version of the plugin then you can use the [dev branch](https://github.com/OXY2DEV/markview.nvim/tree/dev).

## 🌇 Commands

Markview comes with a single command.

```vim
:Markview
```

It has the following `sub-commands`,

- toggleAll, Toggles the plugin. Will set all **attached buffers** state to the plugin state.
- enableAll, Enables the plugin in all **attached buffers**. Will refresh the decorations if the plugin is already enabled.
- disableAll, Disables the plugin in all **attached buffers**. Will try to remove any remaining decorations if the plugin is already disabled.
- toggle {buffer}, Toggles the state of buffer.
- enable {buffer}, Enables/Refreshes the plugin on a specific buffer.
- disable {buffer}, Disables the plugin & clears decorations on a specific buffer.


## 🧭 Configuration

You can use the `setup()` function to change how the plugin looks.

```lua
local markview = require("markview");
local presets = require("markview.presets");

markview.setup({
    headings = presets.headings.glow_labels
});

vim.cmd("Markview enableAll");
```

This can also be used at runtime. So, you can hot-swap the config anytime you want!

Go ahead try running it.

---

You can configure the plugin in 2 ways,

### 📂 Presets

Presets are an easy way to change the looks of some part of the plugin.

Currently there are presets for the following items,

- Headings
- Tables

You can find more on presets on the [wiki page]().

### 🎨 Manual

The plugin was created with the sole purpose of being **customisable**.

So, you can change everything to fit your needs.

A simple example is given below,

```lua
require("markview").setup({
    headings = {
        enable = true,

        heading_1 = {
            style = "label",

            padding_left = " ",
            padding_right = " ",

            hl = "MarkviewHeading1"
        }
    }
});
```

You can check the [wiki](https://github.com/OXY2DEV/markview.nvim/wiki) to learn more about configuration.

You can also check the [starter guide]() for some simple examples.

## 🌃 highlight groups

To make configuration easier `markview.nvim` comes with the following highlight groups.

### 📦 Block quote

Block quotes have the following highlight group by default,

- MarkviewBlockQuoteDefault, also used by `Quote`.

Various callouts/alerts use the following highlight groups,

- MarkviewBlockQuoteOk, used by `Tip`, `Success`.
- MarkviewBlockQuoteWarn, used by `Question`, `Custom`, `Warning`.
- MarkviewBlockQuoteError, used by `Caution`, `Bug`, `Danger`, `Failure`.
- MarkviewBlockQuoteNote, used by `Note`, `Todo`, `Abstract`.
- MarkviewBlockQuoteSpecial, used `Important`, `Example`.

### 🎯 Checkboxes

Checkboxes use these highlight groups,

- MarkviewCheckboxChecked, from `DiagnosticOk`.
- MarkviewCheckboxUnhecked, from `DiagnosticError`.
- MarkviewCheckboxPending, from `DiagnosticWarn`.

### 💻 Code blocks & inline codes

Code blocks use the following highlight group,

- MarkviewCode

Inline codes use the following highlight group,

- MarkviewInlineCode

### 🔖 Headings

Headings are highlighted with the following groups,

- MarkviewHeading1, from `DiagnosticVirtualTextOk`
- MarkviewHeading2, from `DiagnosticVirtualTextHint`
- MarkviewHeading3, from `DiagnosticVirtualTextInfo`
- MarkviewHeading4, from `Special`
- MarkviewHeading5, from `DiagnosticVirtualTextWarn`
- MarkviewHeading6, from `DiagnosticVirtualTextError`

Signs are highlighted with the following groups,

- MarkviewHeading1Sign, from `DiagnosticOk`
- MarkviewHeading2Sign, from `DiagnosticHint`
- MarkviewHeading3Sign, from `DiagnosticInfo`
- MarkviewHeading4Sign, from `Special`
- MarkviewHeading5Sign, from `DiagnosticWarn`
- MarkviewHeading6Sign, from `DiagnosticError`

### 📏 Horizontal rules

Horizontal rules use the following highlight groups for the gradient.

- MarkviewGradient1, from `Normal`.
- MarkviewGradient2
- MarkviewGradient3
- MarkviewGradient4
- MarkviewGradient5
- MarkviewGradient6
- MarkviewGradient7
- MarkviewGradient8
- MarkviewGradient9
- MarkviewGradient10, from `Cursor`.

### 🔗 Links

Links use the following highlight groups,

- MarkviewHyperlink, from `markdownLinkText`.
- MarkviewImageLink, from `markdownLinkText`.
- MarkviewEmail, from `@markup.link.url.markdown_inline`.

### 📝 List items

List items use the following highlight groups,

- MarkviewListItemMinus, from `DiagnosticWarn`.
- MarkviewListItemPlus, from `DiagnosticOk`.
- MarkviewListItemStar, from `@comment.note`.

### 📐 Tables

Tables use the following highlight group for the border,

- MarkviewTableBorder, from `Title`.

For the column alignment markers these highlight groups are used,

- MarkviewTableAlignLeft, from `Title`.
- MarkviewTableAlignRight, from `Title`.
- MarkviewTableAlignCenter, from `Title`.

## ⭐ Plugin showcase

![showcase_1](https://github.com/OXY2DEV/markview.nvim/blob/images/Submitted/sc_scottmckendry.png)

<sub>Taken by <a href="https://github.com/scottmckendry">@scottmckendry</a></sub>


<!--
    vim:nospell:
-->
