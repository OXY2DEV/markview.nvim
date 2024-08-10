# 🔩 Configuration options

Markview comes with a ton of configuration options.

```lua
{
    -- Buftypes to ignore
    buf_ignore = { "nofile" },

    -- Modes where preview is enabled
    modes = { "n", "no" },

    -- Modes where hybrid mode is enabled
    hybrid_modes = {},

    -- Functions to run on specific events
    callbacks = {
        on_enable = function(buf, win)
            -- Stuff to do when plugin is enabled
        end,
        on_disable = function(buf, win)
            -- Stuff to do when plugin is disabled
        end,

        on_mode_change = function(buf, win, mode)
            -- Stuff to do when mode changes(while
            -- the plugin is enabled)
        end
    },

    -- Highlight groups for the plugin
    highlight_groups = {},

    -- Render configs
    -- They are explained in their own
    -- pages
    block_quotes = {},
    checkboxes = {},
    code_blocks = {},
    headings = {},
    horizontal_rules = {},
    html = {},
    inline_codes = {},
    links = {},
    list_items = {},
    tables = {}
}
```

## 📞 Callbacks

Callbacks are functions that are called on specific events. They are mostly used for setting options.

The `on_enable` & `on_disable` functions receive the `buffer ID` & `window ID`.

The `on_mode_change` function receives the `buffer ID`, `window ID` & the `mode`.

## 🎨 Highlight groups

Highlight groups can be made to use with the plugin. All Highlight groups made with this option will have `Markview` added to their name.

>[!Tip]
> Markview comes with a bunch of color related functions to make this as easy as possible.

The `highlight_groups` table can have values of either 2 types.

> Type 1: Normal Highlight group.

```lua
{
  group_name = "",
  value = {},

  -- Also possible
  value = function()
  end
}
```

This is directly used in `nvim_set_hl()`. The `value` can also be a **function** in which case the result is used.

> Type 2: Groups of highlight groups

```lua
output = function()
end
```

This is used when you have the same method to make multiple highlight groups(e.g. background hl, sign hl etc.). This also reduces needing to write the same code multiple times.

The output is a **list** containing tables that have the structure of `type 1`(a `group_name` & a `value`).

### ⭐ Colors.lua: A helper for dynamic colors

Markview comes with a file named `colors.lua` that has helpful methods to work with colors.

You can load it like this,

```lua
local colors = require("markview.colors");
```

It comes with the following functions,

#### colors.clamp

The missing `math.clamp()` function.

```lua
colors.clamp(value, min, max);
```

#### colors.lerp

Linear interpolation function. Used for creating gradients & mixing colors 

```lua
-- Position is a float value between 0 & 1
--
-- You can think of it as % of the way from
-- the start value
colors.lerp(start, stop, position);
```

#### colors.name_to_hex

Takes the color name(e.g. Red) returns the hexadecimal value.

```lua
-- Result: #FF0000
colors.name_to_hex("Red");
```

#### colors.name_to_rgb

Like `name_to_hex` but returns a table containing the r, g, b values.

```lua
-- Result: { r = 255, g = 0, b = 0 }
colors.name_to_rgb("Red");
```

#### colors.num_to_hex

Turns number values returned by `nvim_get_hl()` into hexadecimal value.

A `#` is added before the output value.

```lua
-- Result: #01B207
colors.num_to_hex(111111);
```

#### colors.num_to_rgb

Like `num_to_hex` but returns a table containing r, g, b values.

```lua
-- Result: {
--    r = 7,
--    g = 32,
--    b = 27
-- }
colors.num_to_rgb(111111);
```

#### colors.hex_to_rgb

Takes a hexadecimal string value and returns a table with the r, g, b values.

```lua
-- Result: {
--    r = 46,
--    g = 30,
--    b = 30
-- }
colors.hex_to_rgb("#1e1e2e");

-- Result: {
--    r = 46,
--    g = 30,
--    b = 30
-- }
colors.hex_to_rgb("1e1e2e");

```

#### colors.rgb_to_hex

Takes a table containing r, g, b values and returns the hexadecimal value of a color.

```lua
-- Result: #0A0A0A
color.rgb_to_hex({ r = 10, g = 10, b = 10 });
```

#### colors.get_hl_value

A wrapper for `nvim_get_hl()`. When getting the value of `bg`, `fg` & `sp` of a highlight group a table with r, g, b values are returned.

Anything else works like `nvim_get_hl()[key]`.

```lua
--- Parameters:
--- - Namespace ID
--- - Group name
--- - Value to get
---
--- Result: #1E1E2E
colors.get_hl_value(0, "Normal", "bg");
```

#### colors.create_gradient

Creates a list of highlight groups for a gradient between 2 colors.

The input colors can be **numbers**, **strings** or **tables**.

Returns a list of tables containing a `group_name` & a `value`.

The `group_name` will be the **prefix** + step number.

```lua
--- Parameters:
--- - Prefix: string to add before the group names
--- - Start: Starting color of the gradient
--- - Stop: Stopping color of the gradient
--- - Steps: Total number of steps in the gradient
--- - Mode: The parameter to apply gradient to
---   Possible values are,
---   - bg
---   - fg
---   - both
colors.create_gradient("Grad", "1e1e2e", {
    r = 255, g = 200, b = 255
}, 10, "fg")
```

#### colors.mix

Mixes 2 colors and returns the hexadecimal value of the final color.

The input colors can be **numbers**, **strings** or **tables**.

The percentages are floats between 0 & 1.

```lua
--- Parameters:
--- - Color 1: First color
--- - Color 2: Second color
--- - Percentage 1: % of color 1 to mix
--- - Percentage 2: % of color 2 to mix
---
--- Result: #424454
colors.mix("#1e1e2e", {
    r = 205,
    g = 214,
    b = 244
}, 0.5, 0.25)
```

#### colors.get_brightness

Gets the `luminosity` value of a color.

The input color can be a **number**, **string** or **table**.

Result is a number between 0 & 1.

```lua
-- Result: 0.12217725490196
colors.get_brightness("#1e1e2e")
```

#### colors.get

Gets the first non nil value from a list of values.

```lua
--- Result: 1
colors.get({ nil, nil, 1, 2 });
```

#### colors.bg

Tries to get the current background color.

Used for transparent colorschemes.

```lua
colors.bg();
```

