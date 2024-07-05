# Block quotes

![block_quotes](./wiki_img/block_quotes.jpg)

This plugin provides custom `block quotes` and `callouts`/`alerts` that can be configured using the `block_quotes` option.

## Configuration

The configuration table for `block quotes` is given below.

```lua
block_quotes = {
    enable = true,
    default = {},

    callouts = {}
}
```

### enable

A boolean value to enable/disable custom `block quotes`.

### default

The default configuration for the block quotes.

```lua
default = {
    border = "▋",
    hl = "rainbow3"
}
```
#### border

A string or a list value.

When string it is used as the border for the block quote. When a list is provided as the value the border will be selected based on the lines index(counted from the start of the block quote). If an index doesn't have a value then the last non-nil value is used.

#### hl

A string or a list value.

Highlight group for `border`. It's behavior is similar to `border`.

### callouts

List of callouts and their configuration tables.

```lua
callouts = {
    {
        match_string = "SUCCESS",
        aliases = { "CHECK", "DONE" },

        border = "▋",
        border_hl = "rainbow4",

        callout_preview = "✓ Success",
        callout_preview_hl = "rainbow4",

        custom_title = true,
        custom_icon = "✓ "
    }
}
```

#### match_string

A string value that will be matched with the text inside of `![]` in a block quote.

It is not case-sensitive.

#### aliases

Additional strings to match that will also use that callout.

It is also not case-sensitive.

#### border

A string(or a list of strings) that will be used as the border for the block quote.

When it is a list then the lines index is used for the border.

#### border_hl

A string(or a list of strings) that will be the highlight group for the border.

When the value is a string it's behavior is similar to `border`.

#### callout_preview

The string to show for the callout/alert. It is added after the border.

#### callout_preview_hl

The highlight group for the `callout_preview`.

#### custom_title

A boolean. When true, if some text is found on the first line of the callout/alert it will replace the text that is shown on that line.

It uses the `callout_preview_hl` highlight group.

#### custom_icon

The icon to show for the custom callout/alert. It is added between the `border` and the `custom_title`.

It uses the `callout_preview_hl` highlight group.


