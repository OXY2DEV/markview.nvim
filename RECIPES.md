# 🍰 Recipes

Markview is a highly customisable plugin and allows customisation of everything.

These are some simple examples.

>[!NOTE]
> It is recommended that you view this with a `nerd font`.

>[!Important]
> It is recommended to view this file inside `Neovim`.

## 🔖 Better headings

You can customise the headings like `statusline` component via the `label` style.

This allows adding corners, paddings & icons to them.

Let's start with something simple. Run the following code.

>[!Tip]
> Select the code block using visual mode and run the `:lua` command.

```lua
require("markview").setup({
    headings = {
        enable = true,
        shift_width = 0,

        heading_1 = {
            style = "label",

            padding_left = " ",
            padding_right = " ",

            hl = "MarkviewHeading1"
        }
    }
});

-- This is to prevent needing to manually refresh the view.
vim.cmd("Markview enableAll");
```

Now, Let's do a bit more customisation.

```lua
require("markview").setup({
    headings = {
        enable = true,
        shift_width = 0,

        heading_1 = {
            style = "label",

            padding_left = " ",
            padding_right = " ",

            corner_right = "",
            corner_right_hl = "Heading1Corner",

            hl = "Heading1"
        }
    }
});

vim.cmd("Markview enableAll");
```

Looks messy right? Let's fix that.

We first create a new highlight group to make it look less crappy.

```lua
require("markview").setup({
    highlight_group = {
        {
            group_name = "Heading1",
            value = { fg = "#1e1e2e", bg = "#a6e3a1" }
        },
        {
            group_name = "Heading1Corner",
            value = { fg = "#a6e3a1" }
        },
    }
});
```

Now, we modify the previous code block a bit.

```lua
require("markview").setup({
    highlight_groups = {
        {
            group_name = "Heading1",
            value = { fg = "#1e1e2e", bg = "#a6e3a1" }
        },
        {
            group_name = "Heading1Corner",
            value = { fg = "#a6e3a1" }
        },
    },
    headings = {
        enable = true,
        shift_width = 0,

        heading_1 = {
            style = "label",

            padding_left = " ",
            padding_right = " ",

            corner_right = "",
            corner_right_hl = "Heading1Corner",

            hl = "Heading1"
        }
    }
});

vim.cmd("Markview enableAll");
```

If you want to apply this to the all the headings then `markview` comes a preset for that.

```lua
local heading_presets = require("markview.presets").headings;
local hl_presets = require("markview.presets").highlight_groups;

require("markview").setup({
    highlight_groups = hl_presets.h_decorated,
    headings = heading_presets.decorated
});
```



