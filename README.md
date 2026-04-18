# markview.nvim

A hackable Markdown, HTML, LaTeX, Typst & YAML **live previewer** for Neovim — renders directly in the editor without external browsers.

Forked from [OXY2DEV/markview.nvim](https://github.com/OXY2DEV/markview.nvim) with bug fixes.

## Features

- **In-editor rendering** — preview renders as virtual text inside Neovim
- **Hybrid mode** — edit and preview simultaneously in the same buffer
- **Splitview** — side-by-side editing and preview in separate windows
- **Wrap support** — text wrapping without losing rendering features
- **Multi-format support**:
  - Markdown (GitHub-flavored, Obsidian/PKM extended)
  - HTML
  - LaTeX (math blocks, symbols, 2000+ definitions)
  - Typst
  - YAML
  - AsciiDoc
- **Dynamic highlights** — automatically adapts to your colorscheme
- **Tree-sitter powered** — fast and accurate parsing

## Preview

| Hybrid Mode | Splitview |
|-------------|-----------|
| ![hybrid](https://github.com/OXY2DEV/markview.nvim/blob/images/v27/markview.nvim-hybrid_mode.png) | ![split](https://github.com/OXY2DEV/markview.nvim/blob/images/v27/markview.nvim-splitview.png) |

## Requirements

- **Neovim** >= 0.10.3
- **nvim-treesitter** with parsers: `markdown`, `markdown_inline`, `html`, `latex`, `typst`, `yaml`
- A tree-sitter based colorscheme (recommended)
- Nerd Fonts (recommended for icons)

## Installation

### Lazy.nvim

```lua
{
    "bumaociyuan/markview.nvim",
    lazy = false,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        -- Optional: for blink.cmp completion
        -- "saghen/blink.cmp",
    },
    opts = {
        preview = {
            hybrid_modes = { "n" },  -- enable hybrid mode in normal mode
        },
    },
}
```

Install parsers:

```vim
:TSInstall markdown markdown_inline html latex typst yaml
```

## Configuration

```lua
require("markview").setup({
    preview = {
        hybrid_modes = { "n", "v" },  -- modes where preview is shown
    },
    code_blocks = {
        style = "language",
    },
    headings = {
        shift_width = 0,
        heading_1 = { style = "icon", sign = "󰌕 " },
        heading_2 = { style = "icon", sign = "󰀘 " },
        heading_3 = { style = "icon", sign = "󰆦 " },
    },
    checkboxes = {
        enable = true,
        checked = { text = "☑" },
        unchecked = { text = "☐" },
    },
    tables = {
        enable = true,
    },
})
```

## Commands

| Command | Description |
|---------|-------------|
| `:Markview toggle` | Toggle preview globally |
| `:Markview enable` | Enable preview globally |
| `:Markview disable` | Disable preview globally |
| `:Markview splitToggle` | Toggle splitview |
| `:Markview HybridToggle` | Toggle hybrid mode |
| `:Markview traceShow` | Show debug logs |

## Bug Fixes

This fork includes fixes for:

- **#488**: Fixed "attempt to index a nil value" crash when `get_parser()` returns nil (parser.lua)

## License

Same as upstream — see [LICENSE](LICENSE).
