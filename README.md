# 📝 markview.nvim

<p style="text-align: center;">Yet another markdown previewer for neovim</p>

>[!WARNING]
> This plugin is still in it's **alpha phase** so breaking changes **WILL** occur frequently.

## 🌟 Features

>[!NOTE]
> This plugin is *purely* for aesthetics purposes. If you want something simpler you can check out `markdown.nvim` & `headlines.nvim`.

- Fancy icons, text colors & background colors for `headers`
- Fully customisable `callouts` & `block quotes` plus custom `callout` support
- `Hyperlink` & `image link` concealing with custom icons & colors
- Fully customisable `table` previews
- Custom `code blocks` with language previews(with icons)
- Custom `list` markers and optional paddings(uses `shiftwidth`) to make them look like the browser previews
- Fully customisable `horizontal rules` that support multiple segments
- Custom `checkboxes`

## 🔌 Requirements

- `markdown` and `markdown_inline` treesitter parsers, for queries
- Neovim version >= 0.10.0, for `inline virtual text`
- Nerd font, for `numeric box symbols`
- `nvim-web-devicons`, for code block language preview

## 🔧 Installation

### 💤 Lazy.nvim

```lua
-- For plugin.lua users
{
    "OXY2DEV/markview.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- Used by the code bloxks
    },

    config = function ()
        require("markview").setup();
    end
}

-- For plugins/markview.lua users
return {
    "OXY2DEV/markview.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- Used by the code bloxks
    },

    config = function ()
        require("markview").setup();
    end
}
```

### 🦠 mini.deps

```lua
require("mini.deps").add({
    source = "OXY2DEV/markview.nvim",
    depends = {
        "nvim-tree/nvim-web-devicons", -- Used by the code bloxks
    }
})
```

## ⌨️ Setup

Use the `setup()` function to set the various options.

```lua
require("markview").setup({
    header = {},

    code_block = {},
    inline_code = {},

    block_quote = {},

    horizontal_rule = {},

    hyperlink = {},
    image = {},

    table = {},

    list_item = {},
    checkbox = {}
})
```

All the options have `individual configuration tables`. As such, they are explained in their own sections.


## 📝 customisation

>[!IMPORTANT]
> The main focus of the plugin is **aesthetics** and as such the configuration table can look quite **big** & **complicated**.
>
> It is recommended that you store the configuration tables in `variables` and use them for the `setup()` function.
>
> Here's a simple example,
>
> ```lua
> local header_conf = {}; -- configuration for the markdown headers
> 
> require("markview").setup({
>   header = header_conf
> });
> ```


### 🔖 Header

Configuration table for the `markdown headers`.

It is a list containing tables that have the following options.

```lua
{
    style = "padded_icon",

    line_hl = "markview_h1",

    -- This uses nerd font symbol by default and is therefore not shown here
    sign = "", sign_hl = "rainbow1",

    -- This uses nerd font symbol by default and is therefore not shown here
    icon = "", icon_hl = "markview_h1_icon",
    icon_width = 1
}
```

The index of a table in the list is used to determine what is used for a specific header. So, for the `6th header` the 6th item in the list is used.

If the list has **less than 6** items then the internal `tbl_clamp()` function is used to find the last table.

Here's what all of the options do.

- `style`, Changes how the headers are shown
- `line_hl`, Sets the highlight group for coloring the line itself
- `sign`, Optional symbol for the sign column 
- `sign_hl`, Sets the highlight group for the `sign`
- `icon`, The icon used for the header
- `icon_hl`, The highlight group for the icon

>[!NOTE]
> Some of these options are only available for specific `style`.

The available `styles` and what they do are given below,

- simple

  Adds a background color to the line. Optionally supports signs.
  
  It supports the following options,
  
  - `sign` & `sign_hl`

    For showing a sign for the header in the `sign_column` and coloring the sign.

  - `line_hl`

    For changing the background color of the header.

- icon

  Adds simple icon for the headers. The icon should be `2 characters` wide.
  
  Along with all the options mentioned in the previous style this one supports these options.

  - `icon` & `icon_hl`

    For adding icons before the `header` text and coloring the icon.

  - `pad_char` & `pad_hl`
 
    Allows changing the `character` used for the padding and it's `color`.
    Paddings are used to hide the `#` and correctly align the icons.

- padded_icon

  Like `icon` but adds padding to the icon and allows more control over how they are shown.
  
  Along with all the options mentioned in the previous styles this one supports the following option.

  - `icon_width`
  
    Changes where the icon is positioned. By default, the `icon's` character width is used. But can be changed to something else if you need.

    >[!TIP]
    > If you are using the `padded_icon` style then you can use the `icon_width` property to change how many spaces are added before the icon.
    >
    > The number of spaces added before the icon is calculated with the following equation.
    >
    > ```txt
    > position_x = position_of_the_header + header_level - icon_width;
    > ```

### 💻 Code block

Configuration table for `code blocks` in markdown.

```lua
{
    style = "language",
    block_hl = "code_block",

    pad_char = " ",
    language_hl = "Bold",
}
```

Here's what all of them do
- `style`, Changes how code blocks are shown
- `block_hl`, Used to change the background of the block
- `pad_char`, Character used as padding
- `language_hl`, Highlight group for the code blocks language

>[!NOTE]
> Some of these options are only available for specific `style`.

The available `styles` and what they do are given below

- simple
    
  Only adds the background and hides the top & bottom texts

  This style has the following options available,

  - `block_hl`

- padded

  Adds padding on the left side of the code.

  Along with the options from the previous style it also supports,

  - `pad_char`

- language

  Shows the language's file icon and name(the one in the code block) and adds padding.

  Along with the options from the previous style it also supports,

  - `language_hl`

### Inline code block

Configuration table for the `inline codes` in markdown.




