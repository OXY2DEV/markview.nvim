# Block quotes

![block_quotes](./wiki_img/block_quotes.jpg)

## Configuration options

The `block_quotes` option comes with these sub-options.

```lua
block_quotes = {
    enable = true,

    default = {
        border = "",
        border_hl = "Comment"
    },
    callouts = {
        {
            match_string = "CUSTOM",
            aliases = nil,

            callout_preview = "🦠 Custom",
            callout_preview_hl = nil,

            custom_title = true,
            custom_icon = "🦠 ",

            border = { "▉", "▊", "▋", "▌" },
            border_hl = "@comment.warning"
        }
    }
}
```

## Global options

The `block_quotes` option has the following sub-options for controlling all kinds of block quotes.

> enable
> `boolean or nil`

When set to `false`, block_quotes are not rendered.

> default
> `table`

The **default style** to use for block quotes.

## Sub-options

### Sub-options for normal block quotes

> border
> `string or string[]`

A string/list of strings to use as the border for the block quotes.

> border_hl
> `string or string[]`

The name of the highlight group to use for `border`. This can also be a list of strings.

### Sub-options for callouts/alerts

> match_string
> `string`

The string to match for the calllout/alert. It is case-insensitive.

For example, if you have a callout set like this.

```lua
callouts = {
    {
        match_string = "NOTE",
        -- Other options
    }
}
```

You can match callouts that look like this.

```markdown
These are valid callouts. They will be matched.

    >[!NOTE]

    >[!Note]

This however is not valid. This won't be matched.

    > NOTE
```

> aliases
> `string[] or nil`

Optional list of strings to match.

> callout_preview
> `string`

The text to show for the callout/alert. It is added after the border.

> callout_preview_hl
> `string or nil`

Highlight group name for `callout_preview`.

> custom_title
> `boolean or nil`

When set to **true**, Any text after `![]` will be used as the preview.

> custom_icon
> `string or nil`

The icon to use when a `custom_title` is available.

> border
> `string or string[]`

A string/list of strings to use as the border for the callout.

> border_hl
> `string or string[]`

The name of the highlight group to use for `border`. This can also be a list of strings.

## Examples

### Gradient borders

First create a bunch of highlight groups from a gradient.

```lua
highlight_groups = {
    {
        group_name = "gr_1",
        value = {
            fg = "#000000"
        }
    },
    {
        group_name = "gr_2",
        value = {
            fg = "#053333"
        }
    },
    {
        group_name = "gr_3",
        value = {
            fg = "#0a6666"
        }
    },
    {
        group_name = "gr_4",
        value = {
            fg = "#0f9999"
        }
    },
    {
        group_name = "gr_5",
        value = {
            fg = "#14cccc"
        }
    },
    {
        group_name = "gr_6",
        value = {
            fg = "#19ffff"
        }
    },
}
```

Now we make a new `callout`.

```lua
block_quotes = {
    -- Other options
    callouts = {
        {
            match_string = "CUSTOM",
            callout_preview = "Custom",

            border = "▋",
            border_hl = {
                "gr_1", "gr_2", "gr_3",
                "gr_4", "gr_5", "gr_6"
            }
        }
    }
}
```

### Custom titles

You can make specific callouts support a custom titles too.

```lua
block_quotes = {
    -- Other options
    callouts = {
        {
            match_string = "TITLE",
            callout_preview = "Title",

            custom_title = true,
            custom_icon = "▚▚ "
        }
    }
}
```

## Gallery

Wow, so empty 😐

