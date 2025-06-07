# Markdown inline option

>[!TIP]
> You can find the type definition in [definition/renderers/markdown_inline.lua](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/markdown_inline.lua).

Options that change how inline markdown is shown. The default value can be found [here](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L945-L1461).

```lua
---@type markview.config.markdown_inline
markdown_inline = {
    enable = true,

    block_references = {
        enable = true,

        default = {
            icon = "󰿨 ",

            hl = "MarkviewPalette6Fg",
            file_hl = "MarkviewPalette0Fg",
        },
    },

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

    embed_files = {
        enable = true,

        default = {
            icon = "󰠮 ",
            hl = "MarkviewPalette7Fg"
        }
    },

    entities = {
        enable = true,
        hl = "Special"
    },

    emoji_shorthands = {
        enable = true
    },

    escapes = {
        enable = true
    },

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

    highlights = {
        enable = true,

        default = {
            padding_left = " ",
            padding_right = " ",

            hl = "MarkviewPalette3"
        }
    },

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

            icon = " ",
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

    inline_codes = {
        enable = true,
        hl = "MarkviewInlineCode",

        padding_left = " ",
        padding_right = " "
    },

    internal_links = {
        enable = true,

        default = {
            icon = " ",
            hl = "MarkviewPalette7Fg",
        },
    },

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

            icon = " ",
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
},
```

## enable

- type: `boolean`
  default: `true`

Shows inline markdown in previews.

## block_references

- type: [markview.config.markdown_inline.block_refs](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/markdown_inline.lua#L25-L31)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L948-L957)

Changes how block references are shown.

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

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

<h3 id="block_refs_default">default</h3>

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L951-L956)

Default configuration for block references. See [how inline elements are configured]().

<h3 id="block_refs_string">\[string\]</h3>

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)

Configuration for block references whose text matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for block references is `[[<text>]]` when `text` contains `#^`.

## checkboxes

- type: [markview.config.markdown_inline.checkboxes](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/markdown_inline.lua#L35-L49)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L959-L986)

Changes how checkboxes are shown.

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

### checked

- type: [markview.config.markdown_inline.checkboxes.opts](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/markdown_inline.lua#L45-L49)

```lua
checked = {
    text = "󰗠",
    hl = "MarkviewCheckboxChecked",

    scope_hl = "MarkviewCheckboxChecked"
},
```

<h4 id="checkbox_text">text</h4>

- type: `string`

Text to show as the checkbox in the preview.

<h4 id="checkbox_hl">hl</h4>

- type: `string`

Highlight group for [text](#checkbox_text).

<h4 id="checkbox_scope_hl">scope_hl</h4>

- type: `string`

Highlight group used on the list item text.

### unchecked

- type: [markview.config.markdown_inline.checkboxes.opts](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/markdown_inline.lua#L45-L49)

Configuration for unchecked checkboxes. Same structure as [checked](#checked).

### \[string\]

- type: [markview.config.markdown_inline.checkboxes.opts](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/markdown_inline.lua#L45-L49)

Configuration for `[string]` checkboxes. Same structure as [checked](#checked).

## emails

- type: [markview.config.markdown_inline.emails](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/markdown_inline.lua#L53-L59)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L988-L1023)

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

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

<h3 id="emails_default">default</h3>

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L991-L994)

Default configuration for emails. See [how inline elements are configured]().

<h3 id="emails_string">\[string\]</h3>

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)

Configuration for emails whose label matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for emails is `<<label>>`.

## embed_files

- type: [markview.config.markdown_inline.embed_files](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/markdown_inline.lua#L63-L69)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1025-L1032)

Changes how embed file links(from `Obsidian`) are shown.

```lua
embed_files = {
    enable = true,

    default = {
        icon = "󰠮 ",
        hl = "MarkviewPalette7Fg"
    }
},
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

<h3 id="embed_files_default">default</h3>

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1028-L1031)

Default configuration for embed file links. See [how inline elements are configured]().

<h3 id="embed_files_string">\[string\]</h3>

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)

Configuration for embed file links whose text matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for emails is `![[<text>]]`.

## entities

- type: [markview.config.markdown_inline.entities](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/markdown_inline.lua#L81-L86)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1034-L1037)

Changes how HTML entities are shown.

```lua
entities = {
    enable = true,
    hl = "Special"
},
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

<h3 id="entities_hl">hl</h3>

- type: `string`
  default: `"Special"`

Highlight group for the entities.

## emoji_shorthands

- type: [markview.config.markdown_inline.emojis](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/markdown_inline.lua#L73-L77)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1039-L1041)

Changes how Github-styled emoji shorthands are shown.

```lua
emoji_shorthands = {
    enable = true,
},
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

## escapes

- type: [markview.config.markdown_inline.escapes](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/markdown_inline.lua#L90-L91)

Changes how escaped characters are shown.

```lua
escapes = {
    enable = true,
},
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

## footnotes

- type: [markview.config.markdown_inline.footnotes](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/markdown_inline.lua#L95-L101)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1047-L1061)

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

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

<h3 id="footnotes_default">default</h3>

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1050-L1053)

Default configuration for footnote links. See [how inline elements are configured]().

<h3 id="footnotes_string">\[string\]</h3>

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)

Configuration for footnote links whose label matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for footnotes is `[^<label>]`.

## highlights

- type: [markview.config.markdown_inline.highlights](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/markdown_inline.lua#L105-L111)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1063-L1072)

Changes how highlighted text(from `Obsidian`) are shown.

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

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

<h3 id="highlights_default">default</h3>

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1066-L1071)

Default configuration for highlighted text. See [how inline elements are configured]().

<h3 id="highlights_string">\[string\]</h3>

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)

Configuration for highlighted text whose content matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for footnotes is `==<content>==`.

## hyperlinks

- type: [markview.config.markdown_inline.hyperlinks](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/markdown_inline.lua#L115-L121)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1074-L1250)

Changes how hyperlinks are shown.

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

        icon = " ",
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

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

<h3 id="hyperlinks_default">default</h3>

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1077-L1080)

Default configuration for hyperlinks. See [how inline elements are configured]().

<h3 id="hyperlinks_string">\[string\]</h3>

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)

Configuration for hyperlinks whose destination matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for hyperlinks is `[<label>](<destination>)`/`[<label>][<destination>]`.

## images

- type: [markview.config.markdown_inline.images](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/markdown_inline.lua#L125-L131)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1252-L1265)

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

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

<h3 id="images_default">default</h3>

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1255-L1258)

Default configuration for images. See [how inline elements are configured]().

<h3 id="images_string">\[string\]</h3>

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)

Configuration for images whose destination matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for images is `![<label>](<destination>)`/`![<label>][<destination>]`.

## inline_codes

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1267-L1273)

Changes how inline codes are shown.

```lua
inline_codes = {
    enable = true,
    hl = "MarkviewInlineCode",

    padding_left = " ",
    padding_right = " "
},
```

See [how inline elements are configured]().

## internal_links

- type: [markview.config.markdown_inline.internal_links](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/markdown_inline.lua#L140-L146)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1275-L1282)

Changes how internal links(from `Obsidian`) are shown.

```lua
internal_links = {
    enable = true,

    default = {
        icon = " ",
        hl = "MarkviewPalette7Fg",
    },
},
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

<h3 id="internal_links_default">default</h3>

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1278-L1281)

Default configuration for internal links. See [how inline elements are configured]().

<h3 id="internal_links_string">\[string\]</h3>

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)

Configuration for internal links whose content matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for internal links is `[[<content>]]`.

## uri_autolinks

- type: [markview.config.markdown_inline.uri_autolinks](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/markdown_inline.lua#L150-L156)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1284-L1461)

Changes how uri autolinks are shown.

```lua
uri_autolinks = {
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

        icon = " ",
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

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

<h3 id="uri_autolinks_default">default</h3>

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1287-L1290)

Default configuration for URI autolinks. See [how inline elements are configured]().

<h3 id="uri_autolinks_string">\[string\]</h3>

- type: [markview.config.__inline](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/markview.lua#L70-L94)

Configuration for URI autolinks whose link matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for URI autolinks is `<<link>>`.

