# ✅ Checkboxes

```lua
Checkboxes = {
    enable = true,

    checked = {
        text = "✔", hl = "TabLineSel"
    },
    unchecked = {},
    pending = {}
}
```

## 🔩 Configuration options

- enable, `boolean` or nil

  Used for toggling the rendering of Checkboxes.

- checked, `table`

  Configuration table for checked Checkboxes.

- unchecked, `table`

  Configuration table for unchecked Checkboxes.

- pending, `table`

  Configuration table for pending(uses `[-]`) Checkboxes.

## 📦 Checkbox configuration

- text, `string`

  Text to show as the checkbox.

- hl, `string` or nil

  Highlight group for `text`.

