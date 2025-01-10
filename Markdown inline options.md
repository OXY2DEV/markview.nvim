# 📝 markdown inline preview options

Changes how inline markdown items are shown in preview.

```lua
---@class config.markdown_inline
---
---@field enable boolean
---
---@field block_references inline.block_references
---@field checkboxes inline.checkboxes
---@field emails inline.emails
---@field embed_files inline.embed_files
---@field entities inline.entities
---@field escapes inline.escapes
---@field footnotes inline.footnotes
---@field highlights inline.highlights
---@field hyperlinks inline.hyperlinks
---@field images inline.images
---@field inline_codes inline.inline_codes
---@field internal_links inline.internal_links
---@field uri_autolinks inline.uri_autolinks
M.markdown_inline = {
    enable = true,

    footnotes = {},
    checkboxes = {},
    inline_codes = {},
    uri_autolinks = {},
    internal_links = {},
    hyperlinks = {},
    embed_files = {},
    entities = {},
    emails = {},
    block_references = {},
    escapes = {},
    images = {},
    highlights = {}
};
```

>[!NOTE]
> Almost every element in inline markdown have the same customisation options.
> As such these options are given below.

<details>
    <summary>Generic options for inline markdown</summary><!--+-->

```lua
--- Generic configuration for inline markdown items.
--- Note: {item} will be different based on the node this is being used by.
---@class config.inline_generic
---
---@field corner_left? string | fun(buffer: integer, item: table): string? Left corner.
---@field corner_left_hl? string | fun(buffer: integer, item: table): string? Highlight group for left corner.
---@field corner_right? string | fun(buffer: integer, item: table): string? Right corner.
---@field corner_right_hl? string | fun(buffer: integer, item: table): string? Highlight group for right corner.
---@field hl? string | fun(buffer: integer, item: table): string? Base Highlight group.
---@field icon? string | fun(buffer: integer, item: table): string? Icon.
---@field icon_hl? string | fun(buffer: integer, item: table): string? Highlight group for icon.
---@field padding_left? string | fun(buffer: integer, item: table): string? Left padding.
---@field padding_left_hl? string | fun(buffer: integer, item: table): string? Highlight group for left padding.
---@field padding_right? string | fun(buffer: integer, item: table): string? Right padding.
---@field padding_right_hl? string | fun(buffer: integer, item: table): string? Highlight group for right padding.
---
---@field file_hl? string | fun(buffer: integer, item: table): string? Highlight group for block reference file name.
---@field block_hl? string | fun(buffer: integer, item: table): string? Highlight group for block reference block ID.
M.inline_generic = {
    corner_left = "<",
    padding_left = " ",
    icon = "π ",
    padding_right = " ",
    corner_right = ">",

    hl = "MarkviewCode"
};
```
<!--_-->
</details>

## block_references

- Type: `inline.block_references`
- Dynamic: **false**

Configuration for block reference links(from `Obsidian`).

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for block reference links.
---@class inline.block_references
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for block reference links.
---@field [string] config.inline_generic Configuration for block references whose label matches with the key's pattern.
block_references = {
    enable = true,

    default = {
        icon = "󰿨 ",
        hl = "Comment"
    }
};
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ HTML | Block references > Parameters ] -----------------------------------------------

---@class __inline.block_references
---
---@field class "inline_link_block_ref"
---
---@field file? string File name.
---@field block string Block ID.
---
---@field label string
---
---@field text string[]
---@field range inline_link.range
M.__inline_block_references = {
    class = "inline_link_block_ref",

    file = "Some_file.md",
    block = "Block",
    label = "Some_file.md#^Block",

    text = { "![[Some_file.md#^Block]]" },
    range = {
        row_start = 0,
        row_end = 0,

        col_start = 0,
        col_end = 25,

        label = { 0, 3, 0, 23 },
        file = { 0, 3, 0, 12 },
        block = { 0, 14, 0, 23 }
    }
};
```
<!--_-->
</details>

## checkboxes

- Type: `inlines.checkboxes`
- Dynamic: **false**

Configuration for checkboxes.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for checkboxes.
---@class inline.checkboxes
---
---@field enable boolean
---
---@field checked checkboxes.opts Configuration for [x] & [X].
---@field unchecked checkboxes.opts Configuration for [ ].
---
---@field [string] checkboxes.opts
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
}
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
---@class checkboxes.opts
---
---@field text string
---@field hl? string
---@field scope_hl? string Highlight group for the list item.
M.checkboxes_opts = {
    text = "∆",
    hl = "MarkviewCheckboxChecked"
};

-- [ HTML | Checkboxes > Parameters ] -----------------------------------------------------

---@class __inline.checkboxes
---
---@field class "inline_checkbox"
---@field state string Checkbox state(text inside `[]`).
---
---@field text string[]
---@field range? node.range Range of the checkbox. `nil` when rendering list items.
M.__inline_checkboxes = {
    class = "inline_checkbox",
    state = "-",

    text = { "[-]" },
    range = {
        row_start = 0,
        row_end = 0,

        col_start = 2,
        col_end = 5
    }
};
```
<!--_-->
</details>

## emails

- Type: `inline.emails`
- Dynamic: **true**

Configuration for block reference links.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for block reference links.
---@class inline.emails
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for block reference links.
---@field [string] config.inline_generic Configuration for block references whose label matches with the key's pattern.
emails = {
    enable = true,

    default = {
        icon = "󰿨 ",
        hl = "Comment"
    }
};
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Inline | Emails > Parameters ] -------------------------------------------------------

---@class __inline.emails
---
---@field class "inline_link_email"
---@field label string
---@field text string[]
---@field range inline_link.range
M.__inline_link_emails = {
    class = "inline_link_email",
    label = "example@mail.com",

    text = { "<example@mail.com>" },
    range = {
        row_start = 0,
        row_end = 0,

        col_start = 0,
        col_end = 17,

        label = { 0, 1, 0, 16 }
    }
};
```
<!--_-->
</details>

## embed_files

- Type: `inline.embed_files`
- Dynamic: **true**

Configuration for embed file links(from `Obsidian`).

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for obsidian's embed files.
---@class inline.embed_files
---
---@field enable boolean
---@field default config.inline_generic
---@field [string] config.inline_generic
embed_files = {
    enable = true,

    default = {
        icon = "󰠮 ",
        hl = "Palette2Fg"
    }
};
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Inline | Embed files > Parameters ] --------------------------------------------------

---@class __inline.embed_files
---
---@field class "inline_link_embed_file"
---
---@field label string Text inside `[[...]]`.
---
---@field text string[]
---@field range node.range
M.__inline_link_embed_files = {
    class = "inline_link_embed_file",
    label = "v25",

    text = { "![[v25]]" },
    range = {
        row_start = 0,
        row_end = 0,

        col_start = 0,
        col_end = 8
    }
};
```
<!--_-->
</details>

## entities

- Type: `inline.entities`
- Dynamic: **true**

Configuration for entity references.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for HTML entities.
---@class inline.entities
---
---@field enable boolean
---@field hl? string
entities = {
    enable = true,
    hl = "Special"
};
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Inline | Entities > Parameters ] ------------------------------------------------------------------

---@class __inline.entities
---
---@field class "inline_entity"
---
---@field name string Entity name(text after "\")
---
---@field text string[]
---@field range node.range
M.__inline_entities = {
    class = "inline_entity",
    name = "Int",
    text = { "&Int;" },
    range = {
        row_start = 0,
        row_end = 0,

        col_start = 0,
        col_end = 5
    }
};
```
<!--_-->
</details>

## escapes

- Type: `inline.escapes`
- Dynamic: **true**

Configuration for escaped characters.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for escaped characters.
---@class inline.escapes 
---
---@field enable boolean
escapes = {
    enable = true
},
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Inline | Escapes > Parameters ] ------------------------------------------------------

---@class __inline.escaped
---
---@field class "inline_escaped"
---
---@field text string[]
---@field range node.range
M.__inline_escaped = {
    class = "inline_escaped",

    text = { "\\'" },
    range = {
        row_start = 0,
        row_end = 0,

        col_start = 0,
        col_end = 2
    }
};
```
<!--_-->
</details>

## footnotes

- Type: `inline.footnotes`
- Dynamic: **true**

Configuration for footnotes.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for footnotes.
---@class inline.footnotes
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for footnotes.
---@field [string] config.inline_generic Configuration for footnotes whose label matches `string`.
footnotes = {
    enable = true,

    default = {
        icon = "󰯓 ",
        hl = "MarkviewHyperlink"
    },
    ["^%d+$"] = {
        icon = "󰯓 ",
        hl = "MarkviewPalette4Fg"
    }
}
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Inline | Footnotes > Parameters ] ----------------------------------------------------

---@class __inline.footnotes
---
---@field class "inline_footnotes"
---@field label string
---@field text string[]
---@field range inline_link.range
M.__inline_footnotes = {
    class = "inline_footnotes",
    label = "1",

    text = { "[^1]" },
    range = {
        label = { 0, 2, 0, 3 },

        row_start = 0,
        row_end = 0,

        col_start = 0,
        col_end = 4
    }
};
```
<!--_-->
</details>

## highlights

- Type: `inline.highlights`
- Dynamic: **true**

Configuration for PKM-like highlights(`==highlights==`).

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for highlighted texts.
---@class inline.highlights
---
---@field enable boolean
---@field default config.inline_generic
---@field [string] config.inline_generic
highlights = {
    enable = true,

    default = {
        padding_left = " ",
        padding_right = " ",

        hl = "MarkviewPalette3"
    },
}
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Inline | Highlights > Parameters ] ---------------------------------------------------

---@class __inline.highlights
---
---@field class "inline_highlight"
---@field text string[]
---@field range node.range
M.__inline_highlights = {
    class = "inline_highlight",

    text = { "==Highlight==" },
    range = {
        row_start = 0,
        row_end = 0,

        col_start = 0,
        col_end = 13
    }
};
```
<!--_-->
</details>

## hyperlinks

- Type: `inline.hyperlinks`
- Dynamic: **true**

Configuration for hyperlinks.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for hyperlinks.
---@class inline.hyperlinks
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for hyperlinks.
---@field [string] config.inline_generic Configuration for links whose description matches `string`.
hyperlinks = {
    enable = true,

    default = {
        icon = "󰌷 ",
        hl = "MarkviewHyperlink",
    },

    ["stackoverflow%.com"] = { icon = " " },
    ["stackexchange%.com"] = { icon = " " },

    ["neovim%.org"] = { icon = " " },

    ["dev%.to"] = { icon = " " },
    ["github%.com"] = { icon = " " },
    ["reddit%.com"] = { icon = " " },
    ["freecodecamp%.org"] = { icon = " " },

    ["https://(.+)$"] = { icon = "󰞉 " },
    ["http://(.+)$"] = { icon = "󰕑 " },
    ["[%.]md$"] = { icon = " " }
};
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Inline | Hyperlinks > Parameters ] ----------------------------------------------------

---@class __inline.hyperlinks
---
---@field class "inline_link_hyperlink"
---
---@field label? string
---@field description? string
---
---@field text string[]
---@field range inline_link.range
M.__inline_images = {
    class = "inline_link_hyperlink",

    label = "link",
    description = "test.svg",

    text = { "[link](example.md)" },
    range = {
        row_start = 0,
        row_end = 0,

        col_start = 0,
        col_end = 18,

        label = { 0, 1, 0, 5 },
        description = { 0, 7, 0, 16 }
    }
};
```
<!--_-->
</details>

## images

- Type: `inline.images`
- Dynamic: **true**

Configuration for image links.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for image links.
---@class inline.images
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for image links
---@field [string] config.inline_generic Configuration image links whose description matches `string`.
images = {
    enable = true,

    default = {
        icon = "󰥶 ",
        hl = "MarkviewImage",
    },

    ["%.svg$"] = { icon = "󰜡 " }
}
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Inline | Images > Parameters ] -------------------------------------------------------

---@class __inline.images
---
---@field class "inline_link_image"
---@field label? string
---@field description? string
---@field text string[]
---@field range inline_link.range
M.__inline_images = {
    class = "inline_link_image",
    label = "image",
    description = "test.svg",

    text = { "![image](test.svg)" },
    range = {
        row_start = 0,
        row_end = 0,

        col_start = 0,
        col_end = 18,

        label = { 0, 2, 0, 7 },
        description = { 0, 9, 0, 17 }
    }
};
```
<!--_-->
</details>

## inline_codes

- Type: `inline.inline_codes`
- Dynamic: **true**.

Configuration for inline codes.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Inline | Inline codes > Parameters ] -------------------------------------------------

---@class __inline.inline_codes
---
---@field class "inline_code_span"
---@field text string[]
---@field range node.range
M.__inline_inline_codes = {
    class = "inline_code_span",
    text = { "`inline code`" },
    range = {
        row_start = 0,
        row_end = 0,

        col_start = 0,
        col_end = 13
    }
};
```
<!--_-->
</details>

## internal_links

- Type: `inline.internal_links`
- Dynamic: **true**.

Configuration for internal links(from `Obsidian`).

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for obsidian's internal links.
---@class inline.internal_links
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for internal links.
---@field [string] config.inline_generic Configuration for internal links whose label match `string`.
internal_links = {
    enable = true,

    default = {
        icon = "󰌷 ",
        hl = "Hyperlink",
    }
};
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Inline | Internal links > Parameters ] ------------------------------------------------------------

---@class __inline.internal_links
---
---@field class "inline_link_internal"
---
---@field alias? string
---@field label string Text inside `[[...]]`.
---
---@field text string[]
---@field range inline_link.range
M.__inline_internal_links = {
    class = "inline_link_internal",

    alias = "Alias",
    label = "v25|Alias",

    text = { "[[v25|alias]]" },
    range = {
        alias = { 0, 6, 0, 11 },
        label = { 0, 2, 0, 11 },

        row_start = 0,
        row_end = 0,

        col_start = 0,
        col_end = 13
    }
};
```
<!--_-->
</details>

## uri_autolinks

- Type: `inline.uri_autolinks`
- Dynamic: **true**.

Configuration for URI autolinks(`<https://example.com>`).

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for uri autolinks.
---@class inline.uri_autolinks
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for URI autolinks.
---@field [string] config.inline_generic Configuration for URI autolinks whose label match `string`.
uri_autolinks = {
    enable = true,

    default = {
        icon = " ",
        hl = "MarkviewEmail"
    }
}
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Inline | URI autolinks > Parameters ] ------------------------------------------------

---@class __inline.uri_autolinks
---
---@field class "inline_link_uri_autolinks"
---
---@field label string
---
---@field text string[]
---@field range inline_link.range
M.__inline_uri_autolinks = {
    class = "inline_link_uri_autolinks",
    label = "https://example.com",

    text = { "<https://example.com>" },
    range = {
        row_start = 0,
        row_end = 0,

        col_start = 0,
        col_end = 21,

        label = { 0, 1, 0, 20 }
    }
};
```
<!--_-->
</details>

