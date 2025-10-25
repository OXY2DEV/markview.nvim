# 🎇 Integrations

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

