# 🌐 Html

```lua
html = {
    enable = true,

    tags = {},
    entities = {}
}
```

## 🔩 Configuration options

- enable, `boolean` or nil

  Toggles the rendering of html tags & entities.

- tags, `table`

  Configuration table for html tags.

- entities, `table`

  Configuration table for html entities.

## 🧰 Tags

```lua
tags = {
    enable = true,

    default = {},
    configs = {}
}
```

It has the following options,

- enable, `boolean` or nil

  Toggles the rendering of html tags.

- default, `table`

  Default Configuration for tags.

- configs, `table`

  A list of configuration tables for various types of tags.

### 🔖 Tag configuration

```lua
{
    default = { conceal = false, hl = nil },
    configs = {
        b = { conceal = true, hl = "Bold" }
    }
}
```

Configuration table for various tags. It has the following options,

- conceal, `boolean` or nil

  Toggles the concealing of tags.

- hl, `string` or nil

  Highlight group for the text inside the tag.

## 👾 Entities

```lua
entities = {
    enable = true
}
```

It has the following options,

- enable, `boolean` or nil

  Used for toggling rendering of html entities.

