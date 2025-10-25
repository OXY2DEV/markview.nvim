<!--markdoc
    {
        "generic": {
            "filename": "../doc/markview.nvim-markdown_inline.txt",
            "force_write": true,
            "header": {
                "desc": "🧩 Markdown inline options for `markview.nvim`",
                "tag": "markview.nvim-experimental"
            }
        },
        "markdown": {
            "heading_ratio": [ 26, 54 ],
            "list_items": {
                "marker_minus": "◆",
                "marker_plus": "◇"
            },
            "tags": {
                "enable": [ "markview.nvim-markdown_inline.enable" ],
                "block_references": [ "markview.nvim-markdown_inline.block_references" ],
                "checkboxes": [ "markview.nvim-markdown_inline.checkboxes" ],
                "emails": [ "markview.nvim-markdown_inline.emails" ],
                "embed_files": [ "markview.nvim-markdown_inline.embed_files" ],
                "emoji_shorthands": [ "markview.nvim-markdown_inline.emoji_shorthands" ],
                "entities": [ "markview.nvim-markdown_inline.entities" ],
                "escapes": [ "markview.nvim-markdown_inline.escapes" ],
                "footnotes": [ "markview.nvim-markdown_inline.footnotes" ],
                "highlights": [ "markview.nvim-markdown_inline.highlights" ],
                "hyperlinks": [ "markview.nvim-markdown_inline.hyperlinks" ],
                "images": [ "markview.nvim-markdown_inline.images" ],
                "inline_codes": [ "markview.nvim-markdown_inline.inline_codes" ],
                "internal_links": [ "markview.nvim-markdown_inline.internal_links" ],
                "uri_autolinks": [ "markview.nvim-markdown_inline.uri_autolinks" ]
            }
        }
    }
-->
<!--markdoc_ignore_start-->
# 🧩 Markdown inline
<!--markdoc_ignore_end-->

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline
--- Configuration for inline markdown.
---@class markview.config.markdown_inline
---
---@field enable boolean Enable **inline markdown** rendering.
---
---@field block_references markview.config.markdown_inline.block_refs Block reference link configuration.
---@field checkboxes markview.config.markdown_inline.checkboxes Checkbox configuration.
---@field emails markview.config.markdown_inline.emails Email link configuration.
---@field embed_files markview.config.markdown_inline.embed_files Embed file link configuration.
---@field emoji_shorthands markview.config.markdown_inline.emojis Github styled emoji shorthands.
---@field entities markview.config.markdown_inline.entities HTML entities configuration.
---@field escapes markview.config.markdown_inline.escapes Escaped characters configuration.
---@field footnotes markview.config.markdown_inline.footnotes Footnotes configuration.
---@field highlights markview.config.markdown_inline.highlights Highlighted text configuration.
---@field hyperlinks markview.config.markdown_inline.hyperlinks Hyperlink configuration.
---@field images markview.config.markdown_inline.images Image link configuration.
---@field inline_codes markview.config.markdown_inline.inline_codes Inline code/code span configuration.
---@field internal_links markview.config.markdown_inline.internal_links Internal link configuration.
---@field uri_autolinks markview.config.markdown_inline.uri_autolinks URI autolink configuration.
```

## enable

Enables preview of inline elements in markdown.

## block_references

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.block_refs
--- Configuration for block reference links.
---@class markview.config.markdown_inline.block_refs
---
---@field enable boolean Enable rendering of block references.
---
---@field default markview.config.__inline Default configuration for block reference links.
---@field [string] markview.config.__inline Configuration for block references whose label matches with the key's pattern.
```

Changes how block references look.

```lua
block_references = {
    enable = true,

    default = {
        icon = "󰿨 ",

        hl = "MarkviewPalette6Fg",
        file_hl = "MarkviewPalette0Fg",
    },
},
```

## checkboxes

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.checkboxes
--- Configuration for checkboxes.
---@class markview.config.markdown_inline.checkboxes
---
---@field enable boolean Enable rendering of checkboxes.
---
---@field checked markview.config.markdown_inline.checkboxes.opts Configuration for `[x]` & `[X]`.
---@field unchecked markview.config.markdown_inline.checkboxes.opts Configuration for `[ ]`.
---
---@field [string] markview.config.markdown_inline.checkboxes.opts Configuration for `[string]` checkbox.
```

Changes how checkboxes look.

```lua
checkboxes = {
    enable = true,

    checked = { text = "󰗠", hl = "MarkviewCheckboxChecked", scope_hl = "MarkviewCheckboxChecked" },
    unchecked = { text = "󰄰", hl = "MarkviewCheckboxUnchecked", scope_hl = "MarkviewCheckboxUnchecked" },

    ["/"] = { text = "󱎖", hl = "MarkviewCheckboxPending" },
    [">"] = { text = "", hl = "MarkviewCheckboxCancelled" },
    ["<"] = { text = "󰃖", hl = "MarkviewCheckboxCancelled" },
    ["-"] = { text = "󰍶", hl = "MarkviewCheckboxCancelled", scope_hl = "MarkviewCheckboxStriked" },

    ["?"] = { text = "󰋗", hl = "MarkviewCheckboxPending" },
    ["!"] = { text = "󰀦", hl = "MarkviewCheckboxUnchecked" },
    ["*"] = { text = "󰓎", hl = "MarkviewCheckboxPending" },
    ['"'] = { text = "󰸥", hl = "MarkviewCheckboxCancelled" },
    ["l"] = { text = "󰆋", hl = "MarkviewCheckboxProgress" },
    ["b"] = { text = "󰃀", hl = "MarkviewCheckboxProgress" },
    ["i"] = { text = "󰰄", hl = "MarkviewCheckboxChecked" },
    ["S"] = { text = "", hl = "MarkviewCheckboxChecked" },
    ["I"] = { text = "󰛨", hl = "MarkviewCheckboxPending" },
    ["p"] = { text = "", hl = "MarkviewCheckboxChecked" },
    ["c"] = { text = "", hl = "MarkviewCheckboxUnchecked" },
    ["f"] = { text = "󱠇", hl = "MarkviewCheckboxUnchecked" },
    ["k"] = { text = "", hl = "MarkviewCheckboxPending" },
    ["w"] = { text = "", hl = "MarkviewCheckboxProgress" },
    ["u"] = { text = "󰔵", hl = "MarkviewCheckboxChecked" },
    ["d"] = { text = "󰔳", hl = "MarkviewCheckboxUnchecked" },
},
```

Each checkbox has the following options.

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.checkboxes.opts
---@class markview.config.markdown_inline.checkboxes.opts
---
---@field text string Text used to replace `[]` part.
---@field hl? string Highlight group for `text`.
---@field scope_hl? string Highlight group for the list item.
```

## inline_codes

Each checkbox has the following options.

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.inline_codes
--- Configuration for inline codes.
---@alias markview.config.markdown_inline.inline_codes markview.config.__inline
```

Changes how inline codes are shown.

```lua
inline_codes = {
    enable = true,
    hl = "MarkviewInlineCode",

    padding_left = " ",
    padding_right = " "
},
```

## emails

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.emails
--- Configuration for emails.
---@class markview.config.markdown_inline.emails
---
---@field enable boolean Enable rendering of Emails.
---
---@field default markview.config.markdown_inline.emails.opts Default configuration for emails
---@field [string] markview.config.markdown_inline.emails.opts Configuration for emails whose label(address) matches `string`.
```

Changes how emails are shown.

```lua
emails = {
    enable = true,

    default = {
        icon = " ",
        hl = "MarkviewEmail"
    },

    ["%@gmail%.com$"] = {
        --- user@gmail.com

        icon = "󰊫 ",
        hl = "MarkviewPalette0Fg"
    },

    ["%@outlook%.com$"] = {
        --- user@outlook.com

        icon = "󰴢 ",
        hl = "MarkviewPalette5Fg"
    },

    ["%@yahoo%.com$"] = {
        --- user@yahoo.com

        icon = " ",
        hl = "MarkviewPalette6Fg"
    },

    ["%@icloud%.com$"] = {
        --- user@icloud.com

        icon = "󰀸 ",
        hl = "MarkviewPalette6Fg"
    }
},
```

Each emails have these options.

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.emails.opts
---@alias markview.config.markdown_inline.emails.opts markview.config.__inline
```

## embed_files

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.embed_files
--- Configuration for obsidian's embed files.
---@class markview.config.markdown_inline.embed_files
---
---@field enable boolean Enable rendering of Embed files.
---
---@field default markview.config.markdown_inline.embed_files.opts Default configuration for embed file links.
---@field [string] markview.config.markdown_inline.embed_files.opts Configuration for embed file links whose label matches `string`.
```

Changes how embed file links are shown.

```lua
embed_files = {
    enable = true,

    default = {
        icon = "󰠮 ",
        hl = "MarkviewPalette7Fg"
    }
},
```

Each embed file types have these options.

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.embed_files.opts
---@alias markview.config.markdown_inline.embed_files.opts markview.config.__inline
```

## emoji_shorthands

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.emojis
--- Configuration for Github-styled emoji shorthands.
---@class markview.config.markdown_inline.emojis
---
---@field enable boolean Enable rendering of emoji shorthands.
---@field hl? string Highlight group for the emoji.
```

Changes how [github emojis]() are shown.

```lua
emoji_shorthands = {
    enable = true
},
```

## entities

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.entities
--- Configuration for HTML entities.
---@class markview.config.markdown_inline.entities
---
---@field enable boolean Enable rendering of HTML entities.
---@field hl? string Highlight group for the symbol.
```

Changes how entities are shown.

```lua
entities = {
    enable = true,
    hl = "Special"
},
```

## escapes

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.escapes
--- Configuration for escaped characters.
---@class markview.config.markdown_inline.escapes
---
---@field enable boolean Enable rendering of escaped characters.
```

Changes how escaped characters are shown.

```lua
escapes = {
    enable = true
},
```

## footnotes

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.footnotes
--- Configuration for footnotes.
---@class markview.config.markdown_inline.footnotes
---
---@field enable boolean Enable rendering of footnotes.
---
---@field default markview.config.markdown_inline.footnotes.opts Default configuration for footnotes.
---@field [string] markview.config.markdown_inline.footnotes.opts Configuration for footnotes whose label matches `string`.
```

Changes how footnotes are shown.

```lua
footnotes = {
    enable = true,

    default = {
        icon = "󰯓 ",
        hl = "MarkviewHyperlink"
    },

    ["^%d+$"] = {
        --- Numbered footnotes.

        icon = "󰯓 ",
        hl = "MarkviewPalette4Fg"
    }
},
```

Each footnote type has the following options.

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.footnotes.opts
---@alias markview.config.markdown_inline.footnotes.opts markview.config.__inline
```

## highlights

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.highlights
--- Configuration for Obsidian-style highlighted texts.
---@class markview.config.markdown_inline.highlights
---
---@field enable boolean Enable rendering of highlighted text.
---
---@field default markview.config.markdown_inline.highlights.opts Default configuration for highlighted text.
---@field [string] markview.config.markdown_inline.highlights.opts Configuration for highlighted text that matches `string`.
```

Changes how highlights are shown.

```lua
highlights = {
    enable = true,

    default = {
        padding_left = " ",
        padding_right = " ",

        hl = "MarkviewPalette3"
    }
},
```

Each highlights type has the following options.

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.highlights.opts
---@alias markview.config.markdown_inline.highlights.opts markview.config.__inline
```

## hyperlinks

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.hyperlinks
--- Configuration for hyperlinks.
---@class markview.config.markdown_inline.hyperlinks
---
---@field enable boolean Enable rendering of hyperlink.
---
---@field default markview.config.markdown_inline.hyperlinks.opts Default configuration for hyperlinks.
---@field [string] markview.config.markdown_inline.hyperlinks.opts Configuration for links whose description matches `string`.
```

Changes how footnotes are shown.

```lua
hyperlinks = {
    enable = true,

    default = {
        icon = "󰌷 ",
        hl = "MarkviewHyperlink",
    },

    ["github%.com/[%a%d%-%_%.]+%/?$"] = {
        --- github.com/<user>

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },
    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/?$"] = {
        --- github.com/<user>/<repo>

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },
    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/tree/[%a%d%-%_%.]+%/?$"] = {
        --- github.com/<user>/<repo>/tree/<branch>

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },
    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/commits/[%a%d%-%_%.]+%/?$"] = {
        --- github.com/<user>/<repo>/commits/<branch>

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },

    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/releases$"] = {
        --- github.com/<user>/<repo>/releases

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },
    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/tags$"] = {
        --- github.com/<user>/<repo>/tags

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },
    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/issues$"] = {
        --- github.com/<user>/<repo>/issues

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },
    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/pulls$"] = {
        --- github.com/<user>/<repo>/pulls

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },

    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/wiki$"] = {
        --- github.com/<user>/<repo>/wiki

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },

    ["developer%.mozilla%.org"] = {
        priority = -9999,

        icon = "󰖟 ",
        hl = "MarkviewPalette5Fg"
    },

    ["w3schools%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette4Fg"
    },

    ["stackoverflow%.com"] = {
        priority = -9999,

        icon = "󰓌 ",
        hl = "MarkviewPalette2Fg"
    },

    ["reddit%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette2Fg"
    },

    ["github%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette6Fg"
    },

    ["gitlab%.com"] = {
        priority = -9999,

        icon = "󰮠 ",
        hl = "MarkviewPalette2Fg"
    },

    ["dev%.to"] = {
        priority = -9999,

        icon = "󱁴 ",
        hl = "MarkviewPalette0Fg"
    },

    ["codepen%.io"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette6Fg"
    },

    ["replit%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette2Fg"
    },

    ["jsfiddle%.net"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette5Fg"
    },

    ["npmjs%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },

    ["pypi%.org"] = {
        priority = -9999,

        icon = "󰆦 ",
        hl = "MarkviewPalette0Fg"
    },

    ["mvnrepository%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette1Fg"
    },

    ["medium%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette6Fg"
    },

    ["linkedin%.com"] = {
        priority = -9999,

        icon = "󰌻 ",
        hl = "MarkviewPalette5Fg"
    },

    ["news%.ycombinator%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette2Fg"
    },
},
```

Each hyperlinks type has the following options.

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.hyperlinks.opts
---@alias markview.config.markdown_inline.hyperlinks.opts markview.config.__inline
```

## images

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.images
--- Configuration for image links.
---@class markview.config.markdown_inline.images
---
---@field enable boolean Enable rendering of image links
---
---@field default markview.config.markdown_inline.images.opts Default configuration for image links
---@field [string] markview.config.markdown_inline.images.opts Configuration image links whose description matches `string`.
```

Changes how images are shown.

```lua
images = {
    enable = true,

    default = {
        icon = "󰥶 ",
        hl = "MarkviewImage",
    },

    ["%.svg$"] = { icon = "󰜡 " },
    ["%.png$"] = { icon = "󰸭 " },
    ["%.jpg$"] = { icon = "󰈥 " },
    ["%.gif$"] = { icon = "󰵸 " },
    ["%.pdf$"] = { icon = " " }
},
```

Each highlights type has the following options.

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.images.opts
---@alias markview.config.markdown_inline.images.opts markview.config.__inline
```

## internal_links

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.internal_links
--- Configuration for obsidian's internal links.
---@class markview.config.markdown_inline.internal_links
---
---@field enable boolean Enable rendering of internal links.
---
---@field default markview.config.markdown_inline.internal_links.opts Default configuration for internal links.
---@field [string] markview.config.markdown_inline.internal_links.opts Configuration for internal links whose label match `string`.
```

Changes how internal links are shown.

```lua
internal_links = {
    enable = true,

    default = {
        icon = " ",
        hl = "MarkviewPalette7Fg",
    },
},
```

Each internal link type has the following options.

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.internal_links.opts
---@alias markview.config.markdown_inline.internal_links.opts markview.config.__inline
```

## uri_autolinks

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.uri_autolinks
--- Configuration for URI autolinks.
---@class markview.config.markdown_inline.uri_autolinks
---
---@field enable boolean Enable rendering of URI autolinks.
---
---@field default markview.config.markdown_inline.uri_autolinks.opts Default configuration for URI autolinks.
---@field [string] markview.config.markdown_inline.uri_autolinks.opts Configuration for URI autolinks whose label match `string`.
```

Changes how uri autolinks look.

```lua
uri_autolinks = {
    enable = true,

    default = {
        icon = " ",
        hl = "MarkviewEmail"
    },

    ["github%.com/[%a%d%-%_%.]+%/?$"] = {
        --- github.com/<user>

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },
    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/?$"] = {
        --- github.com/<user>/<repo>

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },
    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/tree/[%a%d%-%_%.]+%/?$"] = {
        --- github.com/<user>/<repo>/tree/<branch>

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },
    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/commits/[%a%d%-%_%.]+%/?$"] = {
        --- github.com/<user>/<repo>/commits/<branch>

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },

    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/releases$"] = {
        --- github.com/<user>/<repo>/releases

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },
    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/tags$"] = {
        --- github.com/<user>/<repo>/tags

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },
    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/issues$"] = {
        --- github.com/<user>/<repo>/issues

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },
    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/pulls$"] = {
        --- github.com/<user>/<repo>/pulls

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },

    ["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/wiki$"] = {
        --- github.com/<user>/<repo>/wiki

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },

    ["developer%.mozilla%.org"] = {
        priority = -9999,

        icon = "󰖟 ",
        hl = "MarkviewPalette5Fg"
    },

    ["w3schools%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette4Fg"
    },

    ["stackoverflow%.com"] = {
        priority = -9999,

        icon = "󰓌 ",
        hl = "MarkviewPalette2Fg"
    },

    ["reddit%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette2Fg"
    },

    ["github%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette6Fg"
    },

    ["gitlab%.com"] = {
        priority = -9999,

        icon = "󰮠 ",
        hl = "MarkviewPalette2Fg"
    },

    ["dev%.to"] = {
        priority = -9999,

        icon = "󱁴 ",
        hl = "MarkviewPalette0Fg"
    },

    ["codepen%.io"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette6Fg"
    },

    ["replit%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette2Fg"
    },

    ["jsfiddle%.net"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette5Fg"
    },

    ["npmjs%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette0Fg"
    },

    ["pypi%.org"] = {
        priority = -9999,

        icon = "󰆦 ",
        hl = "MarkviewPalette0Fg"
    },

    ["mvnrepository%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette1Fg"
    },

    ["medium%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette6Fg"
    },

    ["linkedin%.com"] = {
        priority = -9999,

        icon = "󰌻 ",
        hl = "MarkviewPalette5Fg"
    },

    ["news%.ycombinator%.com"] = {
        priority = -9999,

        icon = " ",
        hl = "MarkviewPalette2Fg"
    },
},
```

Each uri autolinks type has the following options.

```lua from: ../lua/markview/types/renderers/markdown_inline.lua class: markview.config.markdown_inline.uri_autolinks.opts
---@alias markview.config.markdown_inline.uri_autolinks.opts markview.config.__inline
```

