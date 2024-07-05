# Checkboxes

![checkboxes](./wiki_img/checkboxes.jpg)

This plugin uses custom `checkboxes` which can be configured with the `checkboxes` option.

```lua
checkboxes = {
    enable = true,

    checked = {},
    unchecked = {}
}
```

## enable

Enable/Disable custom checkboxes.

## checked, unchecked

Configuration option for both states.

```lua
checked = {
    text = "✔", hl = "@markup.list.checked"
}
```

### text

Text to show the checkbox.

### hl

Highlight group for the checkbox.


