# Migrating to latest version

Here's the major changes in version `v25`.

## Hybrid mode

Automatically setting up hybrid mode callbacks.
Hybrid mode can now be set up without changing the callback(s).

```lua
--- Before
{
    modes = { "n", "v", "c", "nc" },
    hybrid_modes = { "n" },
    callbacks = {
        on_enable = function (_, win)
            vim.wo[win].conceallevel = 2;
            vim.wo[win].concealcursor = "vc";
        end
    }
}

--- Now
{
    --- "modes" is used for demonstration
    --- purposes. In most cases you wouldn't
    --- need to change this.
    modes = { "n", "v", "c", "nc" },
    hybrid_modes = { "n" }
}
```

## Block quotes

Custom block quote option name changes,
- `callout_preview` → `preview`.
- `callout_preview_hl` → `preview_hl`.
- `custom_title` → `title`.
- `custom_icon` → `icon`.

```lua
--- Before
block_quotes = {
    callouts = {
        {
            callout_preview = "text",
            callout_preview_hl = nil,

            custom_title = true,
            custom_icon = "󰏘"
        }
    }
}

--- Now
block_quotes = {
    callouts = {
        {
            preview = "text",
            preview_hl = nil,

            title = true,
            icon = "󰏘"
        }
    }
}
```

## Checkboxes

`pending` checkbox state has been moved to `custom` states.

```lua
checkboxes = {
    --- Before
    pending = {
        icon = "◯",
        hl = "CheckboxPending"
    },

    --- Now
    custom = {
        {
            match_string = "-",
            icon = "◯",
            hl = "CheckboxPending"
        }
    }
}
```

Custom checkbox option name changes.
  - `match` → `match_string`.

```lua
--- Before
checkboxes = {
    custom = {
        {
            match = "o"
        }
    }
}

--- Now
checkboxes = {
    custom = {
        {
            match_string = "o"
        }
    }
}
```

## Code blocks

`minimal` style has been deprecated.

>[!NOTE]
> `language` style has been renamed to `block`.

```lua
--- Before
code_blocks = {
    style = "minimal"
}

--- Now
code_blocks = {
    style = "block"
}
```

## Headings

`github` heading style renamed to "decorated".

```lua
--- Before
setext_1 = {
    style = "github"
}

--- Now
setext_1 = {
    style = "decorated"
}
```

## LaTeX

Old `brackets` style has been **deprecated**.

```lua
--- Before
latex = {
    brackets = {
        opening = {},
        closing = {},

        scope = {}
    }
}

--- Now
latex = {
    brackets = {
        hl = "@puntuation.brackets"
    }
}
```

## Links

Custom links option name change.
  - `match` → `match_string`.

```lua
--- Before
links = {
    hyperlinks = {
        custom = {
            match = "stackoverflow%.com"
        }
    }
}

--- Now
links = {
    hyperlinks = {
        custom = {
            match_string = "stackoverflow%.com"
        }
    }
}
```

## List items

`n)` style lists now have their own option.

```lua
--- Now
list_items = {
    marker_parenthesis = {
        add_padding = true
    }
}
```

## Tables

Table configuration structure has been changed.

>[!Note]
> The `parts` option has been renamed to `text`.
> The `hl` option has been renamed to `hls`.

```lua
--- Now
tables = {
    text = {
        top       = { "╭", "─", "╮", "┬" },
        header    = { "│", "│", "│" },
        separator = { "├", "┼", "┤", "─" },
        row       = { "│", "│", "│" },
        bottom    = { "╰", "─", "╯", "┴" },

        overlap   = { "├", "┼", "┤", "─" },

        align_left = "╼",
        align_right = "╾",
        align_center = { "╴", "╶",}
    }
}
```

