<!--markdoc
    {
        "generic": {
            "filename": "../doc/markview.nvim-integrations.txt",
            "force_write": true,
            "header": {
                "desc": "🎇 Integrations for `markview.nvim`",
                "tag": "markview.nvim-integrations"
            }
        },
        "markdown": {
            "heading_ratio": [ 26, 54 ],
            "list_items": {
                "marker_minus": "◆",
                "marker_plus": "◇"
            },
            "tags": {
                "blink.cmp": [ "markview.nvim-integrations.blink-cmp" ],
                "nvim$": [ "markview.nvim-integrations.gx" ],
                "nvim-cmp": [ "markview.nvim-integrations.nvim-cmp" ]
            }
        }
    }
-->
<!--markdoc_ignore_start-->
# 🎇 Integrations
<!--markdoc_ignore_end-->

`markview.nvim` provides integrations with the following plugins. You find these in [markview/integrations.lua]().

## 📦 blink.cmp

Completion for Checkbox states & Callouts are provided.

You can disable this by running the following *before* loading `markview`.

```lua
vim.g.markview_blink_loaded = true;
```

## 📦 nvim

Modified `gx` mapping that can,

- Go to heading based on Github-flavored/Gitlab-flavored links(e.g. `#-integrations` for `🎇 Integrations`).
- Open files inside Neovim using some command(e.g. `:tabnew`). Requires [experimental.use_nvim]() to `true`.

## 📦 nvim-cmp

Completion for Checkbox states & Callouts are provided.

You can disable this by running the following *before* loading `markview`.

```lua
vim.g.markview_cmp_loaded = true;
```

## 📦 Diagnostics

You can use `markview.nvim` to *prettify* the LSP hover window.

You can see an example [here](https://gist.github.com/OXY2DEV/645c90df32095a8a397735d0be646452).

