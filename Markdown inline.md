# Markdown inline option

>[!TIP]
> You can find the type definition in [definition/markdown_inline.lua]().

Options that change how inline markdown is shown. The default value can be found [here]().

```lua
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

- type: [markview.config.markdown_inline.block_refs]()
  [default]()

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

- type: [markview.config.__inline_generic]()
  [default]()

Default configuration for block references. See [how inline elements are configured]().

<h3 id="block_refs_string">\[string\]</h3>

- type: [markview.config.__inline_generic]()
  [default]()

Configuration for block references whose text matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for block references is `[[<text>]]` when `text` contains `#^`.

## checkboxes

- type: [markview.config.markdown_inline.checkboxes]()
  [default]()

Changes how checkboxes are shown.

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

### checked

- type: [markview.config.markdown_inline.checkboxes.opts]()
  [default]()

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

- type: [markview.config.markdown_inline.checkboxes.opts]()
  [default]()

Configuration for unchecked checkboxes. Same structure as [checked](#checked).

### \[string\]

- type: [markview.config.markdown_inline.checkboxes.opts]()
  [default]()

Configuration for `[string]` checkboxes. Same structure as [checked](#checked).

## emails

- type: [markview.config.markdown_inline.emails]()
  [default]()

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

- type: [markview.config.__inline_generic]()
  [default]()

Default configuration for emails. See [how inline elements are configured]().

<h3 id="emails_string">\[string\]</h3>

- type: [markview.config.__inline_generic]()
  [default]()

Configuration for emails whose label matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for emails is `<<label>>`.

## embed_files

- type: [markview.config.markdown_inline.embed_files]()
  [default]()

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

- type: [markview.config.__inline_generic]()
  [default]()

Default configuration for embed file links. See [how inline elements are configured]().

<h3 id="embed_files_string">\[string\]</h3>

- type: [markview.config.__inline_generic]()
  [default]()

Configuration for embed file links whose text matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for emails is `![[<text>]]`.

## entities

- type: [markview.config.markdown_inline.entities]
  [default]()

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

- type: [markview.config.markdown_inline.emojis]
  [default]()

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

- type: [markview.config.markdown_inline.escapes]
  [default]()

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

- type: [markview.config.markdown_inline.footnotes]()
  [default]()

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

- type: [markview.config.__inline_generic]()
  [default]()

Default configuration for footnote links. See [how inline elements are configured]().

<h3 id="footnotes_string">\[string\]</h3>

- type: [markview.config.__inline_generic]()
  [default]()

Configuration for footnote links whose label matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for footnotes is `[^<label>]`.

## highlights

- type: [markview.config.markdown_inline.highlights]()
  [default]()

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

<h3 id="footnotes_default">default</h3>

- type: [markview.config.__inline_generic]()
  [default]()

Default configuration for highlighted text. See [how inline elements are configured]().

<h3 id="footnotes_string">\[string\]</h3>

- type: [markview.config.__inline_generic]()
  [default]()

Configuration for highlighted text whose content matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for footnotes is `==<content>==`.

## hyperlinks

- type: [markview.config.markdown_inline.hyperlinks]()
  [default]()

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

- type: [markview.config.__inline_generic]()
  [default]()

Default configuration for hyperlinks. See [how inline elements are configured]().

<h3 id="hyperlinks_string">\[string\]</h3>

- type: [markview.config.__inline_generic]()
  [default]()

Configuration for hyperlinks whose destination matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for hyperlinks is `[<label>](<destination>)`/`[<label>][<destination>]`.

## images

- type: [markview.config.markdown_inline.images]()
  [default]()

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

- type: [markview.config.__inline_generic]()
  [default]()

Default configuration for images. See [how inline elements are configured]().

<h3 id="images_string">\[string\]</h3>

- type: [markview.config.__inline_generic]()
  [default]()

Configuration for images whose destination matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for images is `![<label>](<destination>)`/`![<label>][<destination>]`.

## inline_codes

- type: [markview.config.__inline_generic]()
  [default]()

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

- type: [markview.config.markdown_inline.internal_links]()
  [default]()

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

- type: [markview.config.__inline_generic]()
  [default]()

Default configuration for internal links. See [how inline elements are configured]().

<h3 id="internal_links_string">\[string\]</h3>

- type: [markview.config.__inline_generic]()
  [default]()

Configuration for internal links whose content matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for internal links is `[[<content>]]`.

## uri_autolinks

- type: [markview.config.markdown_inline.hyperlinks]()
  [default]()

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

- type: [markview.config.__inline_generic]()
  [default]()

Default configuration for URI autolinks. See [how inline elements are configured]().

<h3 id="uri_autolinks_string">\[string\]</h3>

- type: [markview.config.__inline_generic]()
  [default]()

Configuration for URI autolinks whose link matches `string`. See [how inline elements are configured]().

>[!NOTE]
> The structure for URI autolinks is `<<link>>`.

