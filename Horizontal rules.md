# 📏 Horizontal rules

```lua
horizontal_rules = {
    enable = true,

    parts = {
        {
            type = "repeating",

            repeat_amount = 10,
            text = "-",
            hl = "Special"
        }
    }
}
```

## 🔩 Configuration options

- enable, `boolean` or nil

  Used for toggling rendering of horizontal rules.

- parts, `table`

  Lists of parts to create the horizontal rules.

## 🧩 Parts

There are 2 types of parts currently available.

### 🍩 Repeating

```lua
{
    type = "repeating",

    repeat_amount = 10,
    text = "-",
    hl = "Special",
    direction = "left"
}
```

Repeats a text a specific number of times. It has the following options,

- type, `string` or nil

  Type of the part.

- repeat_amount, `number` or `function` or nil

  The number of times to repeat. If the value is a function then  the returned value is used.

- text, `string`

  The text to repeat.

- hl, `string` or `table` or nil

  The highlight group for the output text. If the value is a list then it is applied like a gradient.

- direction, `string`

  The direction from where `hl` is applied. Possible values are,

  - left
  - right

### 🍩 Text

```lua
{
    type = "text",

    text = " • ",
    hl = "Special"
}
```

Shows some text in the horizontal rule. It has the following options,

- type, `string` or nil

  Type of the part.

- text, `string`

  The text to repeat.

- hl, `string` or nil

  The highlight group for the **text**.

