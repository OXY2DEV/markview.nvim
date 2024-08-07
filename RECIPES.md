# 🍰 Recipes

Markview is a highly customisable plugin and allows customisation of everything.

These are some simple examples.

>[!NOTE]
> It is recommended that you view this with a `nerd font`.

>[!Important]
> It is recommended to view this file inside `Neovim`.

## 🔖 Better headings

You can customise the headings like `statusline` component via the `label` style.

![better_headings](https://github.com/OXY2DEV/markview.nvim/blob/images/Recipes/better_headings.jpg)

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

Just add this to your config table.

>[!CAUTION]
> The colors are meant to only be added once so running it now will not add the highlight groups.

```lua
local heading_presets = require("markview.presets").headings;
local hl_presets = require("markview.presets").highlight_groups;

require("markview").setup({
    highlight_groups = hl_presets.h_decorated,
    headings = heading_presets.decorated_labels
});
```

## 📏 Centered horizontal rules

By default, the icon in the middle of the `horizontal rules` aren't centered.

This is due to not being able to check the correct `textoff` value.

But if you manually set it up you can center it.

Let's start by creating a repeating part.

```lua
require("markview").setup({
    horizontal_rules = {
        parts = {
            {
                type = "repeating",
                text = "─",

                repeat_amount = function ()
                    local w = vim.api.nvim_win_get_width(0);
                    local l = vim.api.nvim_buf_line_count(0);

                    l = vim.fn.strchars(tostring(l)) + 4;

                    return math.floor((w - (l + 3)) / 2); 
                end
            }
        }
    }
});
```

Here's a HR to see what it does.

---

Now, let's explain what this does.

`w` is the current windows width and `l` is the amount of lines in the current buffer.

Now, we can turn `l` into a string and count how many character it has(using `vim.fn.strchars()`). This is the number of columns the line number will take in the statuscolumn.

In my case, I have a signcolumn(this takes 2 columns) a foldcolumn(this takes 1 column) and a separator which also takes a character. So we add 2 + 1 + 1 = 4 to the value of `l`. This is how wide my statuscolumn is.

Now, since I want `  `(3 characters) I also add 3 to `l` in the final result.

This is going to be the left side of the horizontal rule.

Now, we copy it but this time replace `math.floor` with `math.ceil` to handle when we have an odd number of free columns.

Finally we make the center part.

```lua
{
    type = "text",
    text = "  "
}
```

By combining them we get this,

```lua
require("markview").setup({
    horizontal_rules = {
        parts = {
            {
                type = "repeating",
                text = "─",

                repeat_amount = function ()
                    local w = vim.api.nvim_win_get_width(0);
                    local l = vim.api.nvim_buf_line_count(0);

                    l = vim.fn.strchars(tostring(l)) + 4;

                    return math.floor((w - (l + 3)) / 2); 
                end
            },
            {
                type = "text",
                text = "  "
            },
            {
                type = "repeating",
                text = "─",

                repeat_amount = function ()
                    local w = vim.api.nvim_win_get_width(0);
                    local l = vim.api.nvim_buf_line_count(0);

                    l = vim.fn.strchars(tostring(l)) + 4;

                    return math.ceil((w - (l + 3)) / 2); 
                end
            },
        }
    }
});
```

Now, use the default `highlight groups` and you are done.

>[!Tip]
> `direction` can be used to apply highlights to a specific side of the text.

```lua
require("markview").setup({
    horizontal_rules = {
        parts = {
            {
                type = "repeating",
                text = "─",

                direction = "left",
                hl = {
                    "Gradient1", "Gradient2",
                    "Gradient3", "Gradient4",
                    "Gradient5", "Gradient6",
                    "Gradient7", "Gradient8",
                    "Gradient9", "Gradient10"
                },

                repeat_amount = function ()
                    local w = vim.api.nvim_win_get_width(0);
                    local l = vim.api.nvim_buf_line_count(0);

                    l = vim.fn.strchars(tostring(l)) + 4;

                    return math.floor((w - (l + 3)) / 2); 
                end
            },
            {
                type = "text",
                text = "  "
            },
            {
                type = "repeating",
                text = "─",

                direction = "right",
                hl = {
                    "Gradient1", "Gradient2",
                    "Gradient3", "Gradient4",
                    "Gradient5", "Gradient6",
                    "Gradient7", "Gradient8",
                    "Gradient9", "Gradient10"
                },

                repeat_amount = function ()
                    local w = vim.api.nvim_win_get_width(0);
                    local l = vim.api.nvim_buf_line_count(0);

                    l = vim.fn.strchars(tostring(l)) + 4;

                    return math.ceil((w - (l + 3)) / 2); 
                end
            },
        }
    }
});
```

