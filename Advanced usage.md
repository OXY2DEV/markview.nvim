# 🔥 Advanced usage

## 📂 Header folding

1. Create a new file `~/.config/nvim/queries/markdown/folds.scm`.

2. Add these lines to that file,

```query
; Folds a section of the document
; that starts with a heading.
((section
    (atx_heading)) @fold
    (#trim! @fold))

; (#trim!) is used to prevent empty
; lines at the end of the section
; from being folded.
```

3. To enable folding using tree-sitter **only for markdown**, you can use `ftplugin/`.
   You can do either of these 2 things.

> If you don't need anything fancy, you can add this to `~/.config/nvim/ftplugin/markdown.lua`,

```lua
--- Removes the ••• part.
vim.o.fillchars = "fold: ";

vim.o.foldmethod = "expr";
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()";

--- Disables fold text.
vim.o.foldtext = "";
```

> If you prefer using a custom `foldtext` then you can use this instead.

```lua
---@type integer Current buffer.
local buffer = vim.api.nvim_get_current_buf();

local got_spec, spec = pcall(require, "markview.spec");
local got_util, utils = pcall(require, "markview.utils");

if got_spec == false then
    --- Markview most likely not loaded.
    --- no point in going forward.
    return;
elseif got_util == false then
    --- Same as above.
    return;
end

--- Fold text creator.
---@return string
_G.heading_foldtext = function ()
    --- Start & end of the current fold.
    --- Note: These are 1-indexed!
    ---@type integer, integer
    local from, to = vim.v.foldstart, vim.v.foldend;

    --- Starting line
    ---@type string
    local line = vim.api.nvim_buf_get_lines(0, from - 1, from, false)[1];

    if line:match("^[%s%>]*%#+") == nil then
        --- Fold didn't start on a heading.
        return vim.fn.foldtext();
    end

    --- Heading configuration table.
    ---@type markdown.headings?
    local main_config = spec.get({ "markdown", "headings" }, { fallback = nil });

    if not main_config then
        --- Headings are disabled.
        return vim.fn.foldtext();
    end

    --- Indentation, markers & the content of a heading.
    ---@type string, string, string
    local indent, marker, content = line:match("^([%s%>]*)(%#+)(.*)$");
    --- Heading level.
    ---@type integer
    local level = marker:len();

    ---@type headings.atx
    local config = spec.get({ "heading_" .. level }, {
        source = main_config,
        fallback = nil,

        --- This part isn't needed unless the user
        --- does something with these parameters.
        eval_args = {
            buffer,
            {
                class = "markdown_atx_heading",
                marker = marker,

                text = { marker .. content },
                range = {
                    row_start = from - 1,
                    row_end = from,

                    col_start = #indent,
                    col_end = #line
                }
            }
        }
    });

    --- Amount of spaces to add per heading level.
    ---@type integer
    local shift_width = spec.get({ "shift_width" }, { source = main_config, fallback = 0 });

    if not config then
        --- Config not found.
        return vim.fn.foldtext();
    elseif config.style == "simple" then
        return {
            { marker .. content, utils.set_hl(config.hl) },

            {
                string.format(" 󰘖 %d", to - from),
                utils.set_hl(string.format("Palette%dFg", 7 - level))
            }
        };
    elseif config.style == "label" then
        --- We won't implement alignment for the sake
        --- of keeping things simple.

        local shift = string.rep(" ", level * #shift_width);

        return {
            { shift, utils.set_hl(config.hl) },
            { config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
            { config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
            { config.icon or "", utils.set_hl(config.padding_left_hl or config.hl) },
            { content:gsub("^%s", ""), utils.set_hl(config.hl) },
            { config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
            { config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) },

            {
                string.format(" 󰘖 %d", to - from),
                utils.set_hl(string.format("Palette%dFg", 7 - level))
            }
        };
    elseif config.style == "icon" then
        local shift = string.rep(" ", level * shift_width);

        return {
            { shift, utils.set_hl(config.hl) },
            { config.icon or "", utils.set_hl(config.padding_left_hl or config.hl) },
            { content:gsub("^%s", ""), utils.set_hl(config.hl) },

            {
                string.format(" 󰘖 %d", to - from),
                utils.set_hl(string.format("Palette%dFg", 7 - level))
            }
        };
    end
end

vim.o.fillchars = "fold: ";

vim.o.foldmethod = "expr";
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()";

vim.o.foldtext = "v:lua.heading_foldtext()"
```

## 🎨 Single highlight group for all links

> This has been taken from [#265](https://github.com/OXY2DEV/markview.nvim/issues/265)

Copy this to your plugin's `config` option.

```lua
---@param group string New highlight group.
---@return { [string]: { hl: string } } New configuration.
local function generic_hl(group)
    return {
        ["github%.com/[%a%d%-%_%.]+%/?$"] = {
            hl = group
        },
        ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/?$"] = {
            hl = group
        },
        ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/tree/[%a%d%-%_%.]+%/?$"] = {
            hl = group
        },
        ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/commits/[%a%d%-%_%.]+%/?$"] = {
            hl = group
        },
        ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/releases$"] = {
            hl = group
        },
        ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/tags$"] = {
            hl = group
        },
        ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/issues$"] = {
            hl = group
        },
        ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/pulls$"] = {
            hl = group
        },
        ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/wiki$"] = {
            hl = group
        }
    };
end

require("markview").setup({
    markdown = {
       reference_definitions = generic_hl("MarkviewPalette4Fg")
    },
    markdown_inline = {
        hyperlinks = generic_hl("MarkviewHyperlink"),
        uri_autolinks = generic_hl("MarkviewEmail"),
    },

    typst = {
        url_links = generic_hl("MarkviewEmail")
    }
});
```

## 📐 Reducing indentation level of list items

> This has been taken from [#283](https://github.com/OXY2DEV/markview.nvim/issues/283)

>[!TIP]
> This works the same way for `Typst` too!

Copy this to your plugin's `config` option.

```lua
require("markview").setup({
    markdown = {
        list_items = {
            shift_width = function (buffer, item)
                --- Reduces the `indent` by 1 level.
                ---
                ---         indent                      1
                --- ------------------------- = 1 ÷ --------- = new_indent
                --- indent * (1 / new_indent)       new_indent
                ---
                local parent_indnet = math.max(1, item.indent - vim.bo[buffer].shiftwidth);

                return (item.indent) * (1 / (parent_indnet * 2));
            end,
            marker_minus = {
                add_padding = function (_, item)
                    return item.indent > 1;
                end
            }
        }
    }
});
```

## ✨ No nerd font

> This has been taken from [#350](https://github.com/OXY2DEV/markview.nvim/issues/350)

Copy this to your `config` option,

```lua
local presets = require("markview.presets");
require("markview").setup(presets.no_nerd_fonts);
```

## 🔳 Toggling table borders

> This has been taken from [#371](https://github.com/OXY2DEV/markview.nvim/issues/371)

Copy this to your `config` option,

>[!TIP]
> You can use `bb` to toggle the border. Or set the **buffer-local** variable `noborder` to disable borders.

```lua
local default = require("markview.spec").default.markdown.tables;
local no_border = require("markview.presets").tables.none;

require("markview").setup({
    markdown = {
        tables = function (buffer)
            if buffer and vim.b[buffer].noborder == true then
                -- We merge the tables to avoid issues due to
                -- options missing in the presets.
                return vim.tbl_deep_extend("force", default, no_border);
            else
                return default;
            end
        end
    }
});

-- Use `bb` to toggle table border.
vim.api.nvim_set_keymap("n", "bb", "", {
    desc = "Switch table [b]order",
    callback = function ()
        if vim.b.noborder == true then
            vim.b.noborder = false;
        else
            vim.b.noborder = true;
        end

        require("markview").commands.Render();
    end
});
```

## ⏱️ Heading numbers

In recent versions(`>=v25.11.0`), you are able to use `%d` in [icon](https://github.com/OXY2DEV/markview.nvim/wiki/Markdown#atx_icon) to show `heading level`.

![demo](https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/advanced-heading_levels.png)

Example `config`,

```lua
require("markview").setup({
    markdown = {
        headings = {
            heading_1 = { icon_hl = "@markup.link", icon = "[%d] "},
            heading_2 = { icon_hl = "@markup.link", icon = "[%d.%d] "},
            heading_3 = { icon_hl = "@markup.link", icon = "[%d.%d.%d] "}
        }
    }
});
```

------

Also available in vimdoc, `:h markview.nvim-advanced`

