<!--markdoc
    {
        "generic": {
            "filename": "doc/markview.nvim.txt",
            "force_write": true,
            "header": {
                "desc": "☄️ A hackable `Markdown`, `LaTeX`, `Typst` etc. previewer.",
                "tag": "markview.nvim"
            }
        },
        "markdown": {
            "link_url_modifiers": [
                [ "^#%-extra%-modules", "|markview.nvim-extras|" ],
                [ "^#%-presets", "|markview.nvim-presets|" ]
            ],
            "list_items": {
                "marker_minus": "◆",
                "marker_plus": "◇"
            },
            "tags": {
                "Features$": [ "markview.nvim-feature" ],
                "Configuration$": [ "markview.nvim-config" ],
                "Commands$": [ "markview.nvim-commands" ],
                "Autocmds$": [ "markview.nvim-autocmds" ],
                "Highlight groups$": [ "markview.nvim-hl", "markview.nvim-highlights" ],
                "Presets$": [ "markview.nvim-presets" ],
                "Extra modules$": [ "markview.nvim-extras" ],
                "Contributing to the projects$": [ "markview.nvim-contribute" ]
            }
        }
    }
-->
<!--markdoc_ignore_start-->

<h1 align="center">☄️ Markview.nvim</h1>

<p align="center">
   A hackable <b>Markdown</b>, <b>HTML</b>, <b>LaTeX</b>, <b>Typst</b> & <b>YAML</b> previewer for Neovim.
</p>
<!--markdoc_ignore_end-->

<div align="center">
    <img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/repo/markdown-catppuccin_mocha.png">
</div>

<div align="center">
    <a href="https://github.com/OXY2DEV/markview.nvim/wiki/Home">📚 Wiki</a> | <a href="#-extra-modules">🧩 Extras</a> | <a href="#-presets">📦 Presets</a>
</div>

## ✨ Features

Core features,

+ Preview `Markdown`, <code>HTML</code>, $LaTeX$, `Typst` & `YAML` within Neovim.
+ *Hybrid* editing mode! Allowing *editing* & *previewing* at the same time.
+ *Splitview*! Allows editing & previewing *side-by-side*.
+ `Wrap` support(markdown only, at the moment)! Allows using text wrapping while not losing *most* rendering features!
+ Highly customisable! You can change almost anything using the config!
+ Dynamic `highlight groups` that automatically updates with the colorscheme!
+ `Callout`, `checkbox` completions for `blink.cmp` & `nvim-cmp`.

<!--markdoc_ignore_start-->
## 📚 Table of contents

- [📚 Requirements](#-requirements)
- [📐 Installation](#-installation)
- [🎇 Commands](#-commands)

Also see,

- [📚 Wiki]()
- [🧭 Usage]()
- [🧩 Extras]()
- [📦 Presets]()

### 📜 Complete feature-list

<details>
    <summary>Expand to see complete feature list</summary>
<!--markdoc_ignore_end-->

#### HTML,

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/repo/html-tokyonight_night.png">

+ Customizable previews for `container` & `void` elements.
+ Supports the following container elements out of the box,
    + `<a></a>`
    + `<b></b>`
    + `<code></code>`
    + `<em></em>`
    + `<i></i>`
    + `<kbd></kbd>`
    + `<mark></mark>`
    + `<pre></pre>`
    + `<s></s>`, `<strike></strike>`, `<del></del>`
    + `<strong></strong>`
    + `<sub></sub>`
    + `<sup></sup>`
    + `<u></u>`

+ Supports the following void elements out of the box,
    + `<hr>`
    + `<br>`

#### LaTeX,

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/repo/latex-cyberdream.png">

+ Supports basic LaTeX syntax,
    + Math blocks(typically `$$...$$`) & inline math(typically `$...$`).
    + Escaped characters.
    + Math fonts
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

+ Supports the following math fonts(requires any *modern* Unicode font),
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

#### Markdown,

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/repo/markdown-catppuccin_mocha.png">

+ Supports basic markdown(Github-flavored) syntax,
    + Block quotes(with support for `callouts` & titles).
    + Fenced code blocks.
    + Headings(`setext` & `atx`).
    + Horizontal rules.
    + List items(`+`, `-`, `*`, `n.` & `n)`).
    + Minus & plus metadata.
    + Reference link definitions.
    + Tables.
    + Checkboxes(supports *minimal-style* checkboxes).
    + Email links.
    + Entity references.
    + Escaped characters.
    + Footnotes.
    + Hyperlinks.
    + Images.
    + Inline codes/Code spans.
    + Autolinks

+ `Wrap` support for,
    + Block quotes & Callouts.
    + Sections(when `markdown.headings.org_indent` is used).
    + List items(when `markdown.list_items.<item>.add_padding` is true).
    + `tables`(limited due to technical limitations).

+ `Org-mode` like indentation for headings.

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/repo/markdown_inline-nightfly.png">

+ Obsidian/PKM extended syntax support,
    + Block reference links.
    + Embed file links.
    + Internal links(supports *aliases*).

+ Wide variety of HTML entity names & codes support.
    + Supported named entities: **786**.
    + Supported entity codes

+ Github emoji shorthands support. Supports **1920** shorthands.
+ Custom configuration based on link patterns.

#### Typst,

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

#### YAML,

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/repo/yaml-material_palenight.png">

+ Custom property icons.
+ Custom property scope decorations.
+ Custom icons(/decorations) based on property type & value(e.g. `booleans`).

+ Supports the following properties out of the box,
    + tags.
    + aliases.
    + cssclasses.
    + publish.
    + permalink.
    + description.
    + images.
    + cover.

---

#### Hybrid mode


| Normal hybrid mode | Linewise hybrid mode |
|--------------------|----------------------|
| ![hybrid_mode](https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/hybrid_mode.png) | ![linewise_hybrid_mode](https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/linewise_hybrid_mode.png) |


+ *Node-based* edit range(default).
  Clears a range of lines covered by the (named)`TSNode` under the cursor. Useful when editing lists, block quotes, code blocks, tables etc.

+ *Range-based* edit range.
  Clears the selected number of lines above & below the cursor.

+ Supports multi-window setups.

#### Splitview

+ View previews in a separate window.
+ Scroll sync between raw file & preview window.

#### Others

Internal Icon provider features,

+ **708** different filetype configuration.
+ Dynamic highlight groups for matching the colorscheme.

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/repo/traceback.png">

+ You can use `:Markview traceShow` to see what the plugin has been doing(including how long some of them took).
+ You can also use `:Markview traceExport` to export these logs.
<!--markdoc_ignore_start-->
</details>
<!--markdoc_ignore_end-->

## 📚 Requirements

System,

- **Neovim:** >= 0.10.3

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

- [mini.icons](https://github.com/nvim-mini/mini.icons)
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
> Do *not* lazy load this plugin as it is already lazy-loaded. Lazy-loading may cause **more time** for the previews to load when starting Neovim!

The plugin should be loaded *after* your colorscheme to ensure the correct highlight groups are used.

```lua
-- For `plugins/markview.lua` users.
return {
    "OXY2DEV/markview.nvim",
    lazy = false,

    -- Completion for `blink.cmp`
    -- dependencies = { "saghen/blink.cmp" },
};
```

```lua
-- For `plugins.lua` users.
{
    "OXY2DEV/markview.nvim",
    lazy = false,

    -- Completion for `blink.cmp`
    -- dependencies = { "saghen/blink.cmp" },
},
```

### 🦠 Mini.deps

```lua
local MiniDeps = require("mini.deps");

MiniDeps.add({
    source = "OXY2DEV/markview.nvim",

    -- Completion for `blink.cmp`
    -- depends = { "saghen/blink.cmp" },
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

## 🪲 Known bugs

- `code span`s don't get recognized when on the line after a `code block`(if the line after the `code span` is empty).
  This is most likely due to some bug in either the `markdown` or the `markdown_inline` parser.

- Incorrect wrapping when setting `wrap` using `modeline`.
  This is due to `textoff` being 0(instead of the size of the `statuscolumn`) when entering a buffer.

## 🧭 Usage

You can find more recipes [here]().

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
| `toggle`         | **buffer**, integer | Toggles preview for **buffer**.          |
| `enable`         | **buffer**, integer | Enables preview for **buffer**.          |
| `disable`        | **buffer**, integer | Disables preview for **buffer**.         |
| `splitToggle`    | none                | Toggles *splitview*.                     |


<!--markdoc_ignore_start-->
<details>
    <summary>Advanced commands are given below</summary><!-- --+ -->
<!--markdoc_ignore_end-->
Sub-commands related to auto-registering new buffers for previews and/or manually attaching/detaching buffers,

| Sub-command      | Arguments           | Description                              |
|------------------|---------------------|------------------------------------------|
| `attach`         | **buffer**, integer | Attaches to **buffer**.                  |
| `detach`         | **buffer**, integer | Detaches from **buffer**.                |
| `Start`          | none                | Allows attaching to new buffers.         |
| `Stop`           | none                | Prevents attaching to new buffers.       |

Sub-commands related to controlling **hybrid_mode**,

| Sub-command      | Arguments           | Description                              |
|------------------|---------------------|------------------------------------------|
| `HybridEnable`   | none                | Enables hybrid mode.                     |
| `HybridDisable`  | none                | Disables hybrid mode.                    |
| `HybridToggle`   | none                | Toggles hybrid mode.                     |
| `hybridEnable`   | **buffer**, integer | Enables hybrid mode for **buffer**.      |
| `hybridDisable`  | **buffer**, integer | Disables hybrid mode for **buffer**.     |
| `hybridToggle`   | **buffer**, integer | Toggles hybrid mode for **buffer**.      |
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
| `render`         | **buffer**, integer | Renders preview for **buffer**.          |
| `clear`          | **buffer**, integer | Clears preview for **buffer**.           |
| `Render`         | none                | Updates preview of all *active* buffers. |
| `Clear`          | none                | Clears preview of all **active** buffer. |

Sub-commands for `bug report`,

| Sub-command      | Arguments           | Description                              |
|------------------|---------------------|------------------------------------------|
| `traceExport`    | none                | Exports trace logs to `trace.txt`.       |
| `traceShow`      | none                | Shows trace logs in a window.            |

<!--markdoc_ignore_start-->
</details>

<!--markdoc_ignore_end-->
>[!TIP]
> **buffer** defaults to the current buffer. So, you can run commands on the current buffer without providing the buffer.
> ```vim
> :Markview toggle "Toggles preview of the current buffer.
> ```

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

