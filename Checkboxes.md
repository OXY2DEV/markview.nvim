# ✅ Checkboxes

```lua
Checkboxes = {
    enable = true,

    checked = {
        text = "✔", hl = "TabLineSel"
    },
    unchecked = {},
    pending = {},

    custom = {
        {
            match = "~",
            text = "◕",
            hl = "CheckboxProgress"
        }
    }
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

- custom, `table`

  List of configuration for custom checkboxes.

## 📦 Checkbox configuration

- text, `string`

  Text to show as the checkbox.

- hl, `string` or nil

  Highlight group for `text`.

## 📦 Custom checkbox configuration

- match, `string`

  The text inside `[]`(must be a single character) to match.

- text, `string`

  Text to show as the checkbox.

- hl, `string` or nil

  Highlight group for `text`.

