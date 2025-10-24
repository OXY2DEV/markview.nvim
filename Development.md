<!--markdoc
    {
        "generic": {
            "filename": "../doc/markview.nvim-dev.txt",
            "force_write": true,
            "header": {
                "desc": "💻 Development with `markview`",
                "tag": "markview.nvim-dev.txt"
            }
        },
        "markdown": {
            "list_items": {
                "marker_minus": "◆",
                "marker_plus": "◇"
            }
        }
    }
-->
<!--markdoc_ignore_start-->
# 💻 Development
<!--markdoc_ignore_end-->

## ✨ Using `markview.nvim` as a previewer

You can use `markview` to render markdown & other filetypes in your plugins.

### 🧭 High-level API

This is the recommended way to use `markview` within external plugins.

You can use this if you,

+ Don't want to manually set up `concealcursor`, `conceallevel` etc.
+ Would like to render with your own configuration.
+ Have rendering *on demand*(like `fzf-lua`).

```lua
if package.loaded["markview"] then
    local render = require("markview").strict_render;
    -- `buffer` is where you want to render in.
    render:render(buffer);
end
```

>[!IMPORTANT]
> The `buffer` **must** be cleared using the API function before calling `:render()` again.

You can clear a buffer like so,

```lua
if package.loaded["markview"] then
    local render = require("markview").strict_render;
    render:clear(buffer);
end
```

#### 💡 Using custom states

If you don't need stuff like `hybrid mode` in your preview you can disable them like so,

```lua
local render = require("markview").strict_render;
render:render(buffer, {
    hybrid_mode = false
});
```

Each buffer has the following states,

```lua from: ../lua/markview/types/markview.lua class: markview.state.buf
---@class markview.state.buf
---
---@field enable boolean Is the `preview` enabled?
---@field hybrid_mode boolean Is `hybrid_mode` enabled?
```

#### 💡 Using custom configuration

If you want the preview looking a certain way you can do so with this,

```lua
local render = require("markview").strict_render;
render:render(buffer, nil, {
    markdown = {
        heading = { enable = false }
    },
    -- ...
});
```

Configuration table is the same as `setup()`.

### 🧭 Low-level API

>[!NOTE]
> This will not set `concealcursor`, `conceallevel` etc., you will need to set them yourself!

To use it add the following code to your plugin,

```lua
if package.loaded["markview"] then
    -- `buffer` is where you want to render in.
    require("markview").render(buffer);
end
```

To clear previews use,

```lua
if package.loaded["markview"] then
    -- `buffer` is where you want to render in.
    require("markview").clear(buffer);
end
```

## ✨ Using `markview.nvim` as a parser

You can use `markview` to parse files.

This is useful if you have extended syntax or simply don't want to build a parser yourself.

```lua
local parser = require("markview.parser");
local data, sorted = parser.init(buffer);

vim.print(data);
```

`data` is a map between the language & a list of parsed nodes.

```lua from: ../lua/markview/types/parsers.lua class: markview.parsed
---@class markview.parsed
---
---@field html? markview.parsed.html[]
---@field latex? markview.parsed.latex[]
---@field markdown? markview.parsed.markdown[]
---@field markdown_inline? markview.parsed.markdown_inline[]
---@field typst? markview.parsed.typst[]
---@field yaml? markview.parsed.yaml[]
```

`sorted` is a map between the language & another map between node names & a list of parsed nodes.

```lua from: ../lua/markview/types/parsers.lua class: markview.parsed_sorted
---@class markview.parsed_sorted
---
---@field html? markview.parsed.html_sorted
---@field latex? markview.parsed.latex_sorted
---@field markdown? markview.parsed.markdown_sorted
---@field markdown_inline? markview.parsed.markdown_inline_sorted
---@field typst? markview.parsed.typst_sorted
---@field yaml? markview.parsed.yaml_sorted
```

