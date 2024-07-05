# Plugin setup

## Table of contents

- [Table of contents](#table-of-contents)
- [Requirements](#requirements)
- [Structure](#structure)
  - [highlight_groups](#highlight_groups)
  - [buf_ignore](#buf_ignore)
  - [modes](#modes)
  - [restore_conceallevel](#restore_conceallevel)
  - [restore_concealcursor](#restore_concealcursor)
  - [Others](#others)

## Requirements

- Neovim 0.10
- nvim-treesitter
- `markdown` & `markdown_inline` treesitter parsers.
- A nerd font

## Setup function

>[!NOTE]
> Calling the `setup()` is completely **optional**. The plugin will *automatically* start when a markdown file is open.

>[!WARNING]
> The `setup()` function is subject to **breaking changes**. Options may be changed, removed or completely reworked for various reasons.

The setup function takes the following table as it's parameter.

```lua
{
    highlight_groups = {},

    buf_ignore = { "nofile" },
    modes = { "n" },

    restore_conceallevel = true,
    restore_concealcursor = false,

    headings = {},
    code_blocks = {},
    block_quotes = {},
    horizontal_rules = {},
    hyperlinks = {},
    images = {},
    inline_codes = {},
    list_items = {},
    checkboxes = {},
    tables = {}
}
```

### highlight_groups

A list of tables containing various highlight groups to set. Highlight groups are automatically set again when the `colorscheme` is changed.

Highlight groups are defined using tables with the `group_name` & `value` properties.

```lua
{
    group_name = "red",
    value = { bg = "#453244", fg = "#f38ba8" }
}
```

>[!IMPORTANT]
> Highlight groups defined with this plugin will have `Markview_` added before their names.
>
> This is to prevent accidentally overwriting any of the default highlight groups.

When using these groups in the plugin you can omit the `Markview_` prefix if you want.

### buf_ignore

A list of `buftypes` to ignore. By default only `nofile` buffers are ignored.

### modes

A list of modes where the plugin will be used.

Here's a brief list of the normally used modes,

1. n for normal mode
2. v for visual mode
3. V for visual line mode
4. ^V for visual block mode
5. i for insert mode
6. r for replace mode

By default, the plugin is only enabled when entering **normal mode**.

### restore_conceallevel

When true, the conceallevel is set back to the value of `vim.o.conceallevel` when hiding the preview.
When false, it is set to 0 instead.

The default is true.

### restore_concealcursor

Same as `restore_conceallevel`, but for concealcursor.

The default is false.

---

### Others

The rest of the properties are are explained in detail in their own wiki pages.

Here is a list containing all of the relevant wiki pages.

- [Headings](./Headings.md)
- [Horizontal rules](./Hrs.md)
- [Hyperlinks & Image links](./Links.md)
- [Block quotes](./Block_quotes.md)
- [Code blocks](./Code_blocks.md)



