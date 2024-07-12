# Plugin setup

## Table of contents

- [Table of contents](#table-of-contents)
- [Requirements](#requirements)
- [Structure](#structure)
  - [Plugin options]()
  - [Render options]()

## Minimum requirements

- Neovim 0.10
- nvim-treesitter
- `markdown` & `markdown_inline` treesitter parsers.
- A nerd font

## Setup function

>[!NOTE]
> Calling the `setup()` is completely **optional**. The plugin will *automatically* start when a markdown file is open.

>[!WARNING]
> The `setup()` function is subject to **breaking changes**. Options may be changed, removed or completely reworked for various reasons.

The setup function has the following options..

```lua
{
    highlight_groups = {},

    buf_ignore = { "nofile" },
    modes = { "n", "no" },

    options = {
        on_enable = {},
        on_disable = {}
    },

    block_quotes = {},
    checkboxes = {},
    code_blocks = {},
    headings = {},
    horizontal_rules = {},
    inline_codes = {},
    links = {},
    list_items = {},
    tables = {}
}
```

### Plugin options

> highlight_groups
> `{ group_name: string, value: table | function }[] or { output: function }`

A list of tables containing various highlight groups to set. Highlight groups are automatically set again when the `colorscheme` is changed.

Each item in the list has the following structure.

```lua
{
    group_name = "red",
    value = { bg = "#453244", fg = "#f38ba8" },

    output = function ()
    end
},
```

>[!IMPORTANT]
> Highlight groups defined with this plugin will have `Markview_` added before their names.
>
> This is to prevent accidentally overwriting any of the default highlight groups.

---

> group_name
> `string`

Name of the highlight group.

>[!NOTE]
> When using highlight groups inside the plugin  you can omit the `Markview_` prefix.

> value
> `function or table`

The value to use for the highlight group. When the value is a `function`, the return value of the function is used.

> output
> `function`

A function to return a list of `highlight_groups` items. Useful for making gradients or using conditions when creating highlight groups.

---

> buf_ignore
> `string[] or nil`

A list of `buftypes` to ignore. By default only `nofile` buffers are ignored.

> modes
> `string[]`

A list of modes where the plugin will be used.

Here's a brief list of the normally used modes,

1. n for normal mode
2. v for visual mode
3. V for visual line mode
4. ^V for visual block mode
5. i for insert mode
6. r for replace mode

By default, the plugin is only enabled when entering **normal mode** & **normal-operation mode**.

> options
> `table or nil`

A table with 2 sub-options `on_enable` & `on_disable`. Each of them has the following options.

```lua
options = {
    on_enable = {
        conceallevel = 2,
        concealcursor = "n"
    },
    on_disable = {
        conceallevel = 0,
        concealcursor = ""
    },
}
```

> conceallevel
> `number or nil`

The level of `conceallevel`. Check the help pages for all the possible values.

> concealcursor
> `string or nil`

The value of `concealcursor`. Check the help pages for all the possible values.

---

### Render options

The remaining properties are used for controlling what gets rendered & how they get rendered.

They are all explained in their own **wiki page**.

- [Block quotes](https://github.com/OXY2DEV/markview.nvim/wiki/Block_quotes)
- [Checkboxes](https://github.com/OXY2DEV/markview.nvim/wiki/Checkboxes)
- [Code blocks](https://github.com/OXY2DEV/markview.nvim/wiki/Code_blocks)
- [Headings](https://github.com/OXY2DEV/markview.nvim/wiki/Headings)
- [Horizontal rules](https://github.com/OXY2DEV/markview.nvim/wiki/Hrs)
- [Links](https://github.com/OXY2DEV/markview.nvim/wiki/Links_and_inline_codes)
- [List items](https://github.com/OXY2DEV/markview.nvim/wiki/List_items)
- [Tables](https://github.com/OXY2DEV/markview.nvim/wiki/Tables)


