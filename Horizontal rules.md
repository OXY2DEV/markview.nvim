# Horizontal rules

![hrs](./wiki_img/hrs.jpg)

## Configuration options

The `horizontal_rules` option has these sub-options.

```lua
horizontal_rules = {
    enable = true,

    position = "inline",
    parts = {}
}
```

### Normal configuration options

> enable
> `boolean or nil`

When set to `false`, horizontal rules aren't rendered.

> parts
> `table[] or nil`

Statusline-like parts for rendering the horizontal rule.

### Parts configuration options

Each part has the following sub-options

> type
> `string`

The name of the part type. Available part types are explained in the next section.

> text
> `string`

The text to use for the part.

> repeat_amount
> `function or number`
>
> Only for the `repeating` type part.

The number of times to repeat `text`. When the value is a **function** the returned value is used.

> hl
> `string[] or string`

Highlight group(s) for `text`. When the value is a list it is used as a **gradient**.

How the values are applied is affected by `direction`.

> direction
> `string or nil`

The direction from which highlight groups are applied. It has the following possible values.

- left,
  The highlight group is applied from the left side of the list and it's applied from the start of the repeated text.

- right,
  The highlight group is applied from the right side of the list and it's applied from the end of the repeated text.


```lua
hl = { "c_1", "c_2", "c_3" },

direction = "left"
-- ─────
-- ││└┴┴─ c_3
-- │└─── c_2
-- └─── c_1

direction = "right",
-- ─────
-- ││└┴┴─ c_1
-- │└─── c_2
-- └─── c_3
```

## Horizontal rule parts

Parts are used to make the horizontal rules. Currently available parts are.

- text,
  Adds the text provided with the highlight group.

- repeating,
  Repeats the provided string the specified number of time. Can also be used to make gradients.

### Part: text

Shows the provided text in the horizontal rule.

```lua
horizontal_rules = {
    parts = {
        {
            type = "text",

            text = " □ ",
            hl = "rainbow6"
        }
    }
}
```

### Part: repeating

Repeats the provided text.

```lua
horizontal_rules = {
    parts = {
        {
            type = "repeating",

            text = "─",
            repeat_amount = function ()
                return vim.o.columns;
            end,

            hl = "rainbow6",
            direction = "left"
        }
    }
}
```

## Gallery

Wow, so empty 😐

