# Getting started with markview

This is meant to be a simple guide for installing & configuring `markview.nvim`.

## Step 0: Minimum requirements

First check your version with `nvim -v` it should be show something like this.

```bash
NVIM v0.10.0
Build type: Release
LuaJIT 2.1.0-beta3
Run "nvim -V1 -v" for more info
```

It should be `0.10.0` or higher.

Secondly, You need a `nerd font` installed. If you don't have one just download one from [their website](https://www.nerdfonts.com/font-downloads) or [their Github repo](https://github.com/ryanoasis/nerd-fonts).

## Step 1: Installation

To start using the plugin you will need to install it using your favourite package manager.

If you are using `lazy.nvim` you will have a table similar to this.

```lua
{
    "OXY2DEV/markview.nvim",

    -- The plugin automatically runs itself when a
    -- markdown file is opened. You need to use this to
    -- tell lazy to load the plugin when the filetype is
    -- markdown
    ft = "markdown",

    dependencies = {
        -- You may not need this if you don't lazy load
        -- Or if the parsers are in your $RUNTIMEPATH
        "nvim-treesitter/nvim-treesitter",

        "nvim-tree/nvim-web-devicons"
    },
}
```

For `lua/markview.lua` users this will look like this.

```lua
return {
    "OXY2DEV/markview.nvim",

    -- The plugin automatically runs itself when a
    -- markdown file is opened. You need to use this to
    -- tell lazy to load the plugin when the filetype is
    -- markdown
    ft = "markdown",

    dependencies = {
        -- You may not need this if you don't lazy load
        -- Or if the parsers are in your $RUNTIMEPATH
        "nvim-treesitter/nvim-treesitter",

        "nvim-tree/nvim-web-devicons"
    },
}
```

For any of the other plugin managers the install process is quite similar.

## Step 3: Configuring markview

`Markview.nvim` focuses on customisation and as such is designed to be as customisable as possible.

#### Step 3.0: Changing plugin behavior

You can change which buffers will be skipped by the plugin by using the `buf_ignore` option.

By default, it avoids buffers with the `nofile` buftype(e.g. buffers showing LSP related informations) but you can chnage this behavior with this option.

```lua
-- Do not set it to nil as then the default value
-- will be ussd
buf_ignore = {}
```

You can also specify the modes where the previews are shown with the `modes` option.

```lua
-- Sets up preview for normal & visual mode
-- NOTE: There are multiple types of visual modes
modes = { "n", "v" }
```

#### Step 3.5: Changing highlight groups

You can also change the various highlight groups from within the plugin itself using the `highlight_groups` option.

>[!NOTE]
> Highlight groups set via this option will have `Markview_` added before the group name.

```lua
highlight_groups = {
    {
        group_name = "col_1",
        value = { fg = "red" }
    }
}
```

This will replace the color of `Markview_col_1` highlight group.

>[!DANGER]
> This will also unset the other default highlight groups.

To add new highlight groups to the default highlight groups, you will need a setup like this.

```lua
config = function ()
    local markview = require("markview");
    local def_hls = markview.configuration.highlight_groups;

    markview.setup({
        highlight_groups = vim.list_extend(def_hls, {
            {
                group_name = "new_1",
                value = { fg = "green" }
            }
        })
    });
end
```

This method can also be used to only **replace** specific highlight groups.


#### Step 3.75: Tweaking various parts of the setup

Now, go and read the wiki to learn about how to configure how things are shown.

## Step 4: Commands

`Markview` comes with a single command `:Markview`.

This command has `sub-commands` & `arguments`.

```vim
Markview toggle 1
```

When called without any sub-commands it will toggle the plugin. This is useful when you only want to focus on writing.

