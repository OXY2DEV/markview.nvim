# 📑 Typst options

Changes how typst items are shown in preview.

```lua
--- Configuration for Typst.
---@class config.typst
---
---@field enable boolean
---
---@field code_blocks typst.code_blocks
---@field code_spans typst.code_spans
---@field escapes typst.escapes
---@field headings typst.headings
---@field labels typst.labels
---@field list_items typst.list_items
---@field math_blocks typst.math_blocks
---@field math_spans typst.math_spans
---@field raw_blocks typst.raw_blocks
---@field raw_spans typst.raw_spans
---@field reference_links typst.reference_links
---@field subscripts typst.subscripts
---@field superscripts typst.subscripts
---@field symbols typst.symbols
---@field terms typst.terms
---@field url_links typst.url_links
typst = {
    enable = true,

    terms = {},
    superscript = {},
    math_spans = {},
    math_blocks = {},
    raw_spans = {},
    raw_blocks = {},
    headings = {},
    symbols = {},
    list_items = {},
    escapes = {},
    codes = {},
    labels = {},
    url_links = {},
    subscripts = {},
    reference_links = {}
};
```

## code_blocks

- Type: `typst.code_blocks`
- Dynamic: **true**

Configuration for blocks of code.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for code blocks.
---@class typst.code_blocks
---
---@field enable boolean
---
---@field hl? string
---@field min_width integer Minimum width of code blocks.
---@field pad_amount integer Number of paddings added around the text.
---@field pad_char? string Character to use for padding.
---@field sign? boolean Whether to add signs.
---@field sign_hl? string Highlight group for signs.
---@field style "simple" | "block"
---@field text string Text to show on top.
---@field text_direction "left" | "right"
---@field text_hl? string
code_blocks = {
    enable = true,

    style = "block",
    text_direction = "right",
    min_width = 60,
    pad_char = " ",
    pad_amount = 3,

    text = "󰣖 Code",

    hl = "MarkviewCode",
    text_hl = "MarkviewIcon5"
};
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Typst | Code blocks > Parameters ] ---------------------------------------------------

---@class __typst.code_block
---@field class "typst_code_block"
---@field text string[]
---@field range node.range
M.__typst_codes = {
    class = "typst_code_block",

    text = {
        "#{",
        "    let a = [from]",
        "}"
    },
    range = {
        row_start = 0,
        row_end = 2,

        col_start = 0,
        col_end = 1
    }
};
```
<!--_-->
</details>

## code_spans

- Type: `typst.code_spans`
- Dynamic: **true**

Configuration for spans of code.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for code spans.
---@class typst.code_spans
---
---@field enable boolean
---
---@field corner_left? string Left corner.
---@field corner_left_hl? string Highlight group for left corner.
---@field corner_right? string Right corner.
---@field corner_right_hl? string Highlight group for right corner.
---@field hl? string Base Highlight group.
---@field padding_left? string Left padding.
---@field padding_left_hl? string Highlight group for left padding.
---@field padding_right? string Right padding.
---@field padding_right_hl? string Highlight group for right padding.
code_spans = {
    enable = true,

    padding_left = " ",
    padding_right = " ",

    hl = "MarkviewCode"
};
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Typst | Code spans > Parameters ] ----------------------------------------------------

---@class __typst.code_spans
---@field class "typst_code_span"
---@field text string[]
---@field range node.range
M.__typst_codes = {
    class = "typst_code_span",

    text = { "#{ let a = 1 }" },
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

## escapes

- Type: `typst.escapes`
- Dynamic: **false**

Configuration for escaped characters.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
---@class typst.escapes
---
---@field enable boolean
escapes = { enable = true };
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Typst | Escapes > Parameters ] -------------------------------------------------------

---@class __typst.escapes
---
---@field class "typst_escaped"
---@field text string[]
---@field range node.range
M.__typst_escapes = {
    class = "typst_escaped",

    text = { "\\|" },
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

## headings

- Type: `typst.headings`
- Dynamic: **true**

Configuration for headings.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for Typst headings.
---@class typst.headings
---
---@field enable boolean
---
---@field shift_width integer Amount of spaces to shift per heading level.
---
---@field [string] headings.typst Heading level configuration(name format: "heading_%d", %d = heading level).
headings = {
    enable = true,
    shift_width = 1,

    heading_1 = {
        style = "icon",
        sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",

        icon = "󰼏  ", hl = "MarkviewHeading1",
    },
    heading_2 = {
        style = "icon",
        sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",

        icon = "󰎨  ", hl = "MarkviewHeading2",
    },
    heading_3 = {
        style = "icon",

        icon = "󰼑  ", hl = "MarkviewHeading3",
    },
    heading_4 = {
        style = "icon",

        icon = "󰎲  ", hl = "MarkviewHeading4",
    },
    heading_5 = {
        style = "icon",

        icon = "󰼓  ", hl = "MarkviewHeading5",
    },
    heading_6 = {
        style = "icon",

        icon = "󰎴  ", hl = "MarkviewHeading6",
    }
};
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
--- Heading level configuration.
---@class headings.typst
---
---@field style "simple" | "icon"
---@field hl? string
---@field icon? string
---@field icon_hl? string
---@field sign? string
---@field sign_hl? string
M.headings_typst = {
    style = "simple",
    hl = "MarkviewHeading1"
} or {
    style = "icon",

    icon = "~",
    hl = "MarkviewHeading1"
};

-- [ Typst | Headings > Parameters ] ------------------------------------------------------

---@class __typst.headings
---
---@field class "typst_heading"
---
---@field level integer Heading level.
---
---@field text string[]
---@field range node.range
M.__typst_headings = {
    class = "typst_heading",
    level = 1,

    text = { "= Heading 1" },
    range = {
        row_start = 0,
        row_end = 0,

        col_start = 0,
        col_end = 10
    }
};
```
<!--_-->
</details>

## labels

- Type: `typst.labels`
- Dynamic: **true**

Configuration for labels.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for typst labels.
---@class typst.labels
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for labels.
---@field [string] config.inline_generic Configuration for labels whose text matches `string`.
labels = {
    enable = true,

    default = {
        hl = "MarkviewInlineCode",
        padding_left = " ",
        icon = " ",
        padding_right = " "
    },
};
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Typst | Labels > Parameters ] --------------------------------------------------------

---@class __typst.labels
---
---@field class "typst_labels"
---
---@field text string[]
---@field range node.range
M.__typst_labels = {
    class = "typst_labels",

    text = { "<label>" },
    range = {
        row_start = 0,
        row_end = 0,

        col_start = 0,
        col_end = 7
    }
};
```
<!--_-->
</details>

## list_items

- Type: `typst.list_items`
- Dynamic: **true**

Configuration for various types of list items.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for list items.
---@class typst.list_items
---
---@field enable boolean
---
---@field indent_size integer Indentation size for list items.
---@field shift_width integer Preview indentation size for list items.
---
---@field marker_dot list_items.ordered Configuration for `n.` list items.
---@field marker_minus list_items.typst Configuration for `-` list items.
---@field marker_plus list_items.typst Configuration for `+` list items.
list_items = {
    enable = true,

    indent_size = 2,
    shift_width = 4,

    marker_minus = {
        add_padding = true,

        text = "",
        hl = "MarkviewListItemMinus"
    },

    marker_plus = {
        add_padding = true,

        text = "%d)",
        hl = "MarkviewListItemPlus"
    },

    marker_dot = {
        add_padding = true,
    }
},
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Typst | List items > Type definitions ] ----------------------------------------------

---@class list_items.typst
---
---@field enable? boolean
---
---@field add_padding boolean
---@field hl? string
---@field text string
M.list_items_unordered = {
    enable = true,
    hl = "MarkviewListItemPlus",
    text = "•",
    add_padding = true,
    conceal_on_checkboxes = true
};

-- [ Typst | List items > Parameters ] ----------------------------------------------------

---@class __typst.list_items
---
---@field class "typst_list_item"
---@field indent integer
---@field marker "+" | "-" | string
---@field number? integer Number to show on the list item when previewing.
---@field text string[]
---@field range node.range
M.__typst_list_items = {
    class = "typst_list_item",
    indent = 0,
    marker = "-",

    text = { "- List item" },
    range = {
        row_start = 0,
        row_end = 0,

        col_start = 0,
        col_end = 11
    }
};
```
<!--_-->
</details>

<!--
                           Work in progress! :START:
-->

## math_blocks

- Type: `typst.math_blocks`
- Dynamic: **true**

Configuration for math blocks.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for math blocks.
---@class typst.math_blocks
---
---@field enable boolean
---
---@field hl? string
---@field pad_amount integer Number of `pad_char` to add before the lines.
---@field pad_char string Text used as padding.
---@field text string
---@field text_hl? string
math_blocks = {
    enable = true,
    hl = "MarkviewCode",
    text = " 󰪚 Math ",
    text_hl = "MarkviewCodeInfo",

    pad_amount = 3,
    pad_char = " "
};
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
```
<!--_-->
</details>

## math_spans

- Type: `typst.math_spans`
- Dynamic: **true**

Configuration for math spans.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
---@alias typst.math_spans config.inline_generic
math_spans = {
    enable = true,

    padding_left = " ",
    padding_right = " ",

    hl = "MarkviewInlineCode"
};
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
```
<!--_-->
</details>

<!--
                            Work in progress! :END:
-->

## raw_blocks

- Type: `typst.raw_blocks`
- Dynamic: **true**

Configuration for raw blocks.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
---@class typst.raw_blocks
---
---@field enable boolean
---
---@field hl? string Base highlight group for code blocks.
---@field label_direction? "left" | "right" Changes where the label is shown.
---@field label_hl? string Highlight group for the label
---@field min_width? integer Minimum width of the code block.
---@field pad_amount? integer Left & right padding size.
---@field pad_char? string Character to use for the padding.
---@field sign? boolean Whether to show signs for the code blocks.
---@field sign_hl? string Highlight group for the signs.
---@field style "simple" | "block" Preview style for code blocks.
raw_blocks = {
    enable = true,

    style = "block",
    icons = "internal",
    label_direction = "right",

    min_width = 60,
    pad_amount = 3,
    pad_char = " ",

    hl = "MarkviewCode"
};
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Typst | Raw blocks > Parameters ] ----------------------------------------------------

---@class __typst.raw_blocks
---
---@field class "typst_raw_block"
---@field language? string
---@field text string[]
---@field range node.range
M.__typst_raw_blocks = {
	class = "typst_raw_block",
	language = "lua",

	text = {
		"```lua",
		'vim.print("Hello, Neovim")',
		"```"
	},
	range = {
		row_start = 0,
		row_end = 2,

		col_start = 0,
		col_end = 3
	}
};
```
<!--_-->
</details>

## raw_spans

- Type: `typst.raw_spans`
- Dynamic: **true**

Configuration for raw spans.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
---@alias typst.raw_spans config.inline_generic
raw_spans = {
    enable = true,

    padding_left = " ",
    padding_right = " ",

    hl = "MarkviewInlineCode"
},
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Typst | Raw spans > Parameters ] -----------------------------------------------------

---@class __typst.raw_spans
---
---@field class "typst_raw_span"
---
---@field text string[]
---@field range node.range
M.__typst_raw_spans = {
	class = "typst_raw_span",

	text = { "`hi`" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 4
	}
};
```
<!--_-->
</details>

## reference_links

- Type: `typst.reference_links`
- Dynamic: **true**

Configuration for reference links.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
---@class typst.reference_links
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for reference links.
---@field [string] config.inline_generic Configuration for reference links whose label matches `string`.
reference_links = {
    enable = true,

    default = {
        icon = " ",
        hl = "MarkviewHyperlink"
    }
};
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Typst | Reference links > Parameters ] -----------------------------------------------

---@class __typst.reference_links
---
---@field class "typst_link_ref"
---
---@field label string
---
---@field text string[]
---@field range inline_link.range
M.__typst_link_ref = {
	class = "typst_link_ref",
	label = "label",

	text = { "@label" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 6,

		label = { 0, 1, 0, 6 }
	}
};
```
<!--_-->
</details>

## subscripts

- Type: `typst.subscripts`
- Dynamic: **true**

Configuration for subscript texts.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for subscript text.
---@class typst.subscripts
---
---@field enable boolean
---
---@field hl? string | string[]
---@field marker_left? string
---@field marker_right? string
subscripts = {
    enable = true,
    hl = "MarkviewSubscript"
};
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Typst | Subscripts > Parameters ] ----------------------------------------------------

---@class __typst.subscripts
---
---@field class "typst_subscript"
---@field parenthesis boolean Whether the text is surrounded by parenthesis.
---@field level integer Subscript level.
---@field text string[]
---@field range node.range
M.__typst_subscripts = {
	class = "typst_subscript",
	parenthesis = true,
	preview = true,
	level = 1,

	text = { "_{12}" },
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

## superscripts

- Type: `typst.superscripts`
- Dynamic: **true**

Configuration for superscript texts.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for superscript text.
---@class typst.superscripts
---
---@field enable boolean
---
---@field hl? string | string[]
---@field marker_left? string
---@field marker_right? string
superscripts = {
    enable = true,
    hl = "MarkviewSuperscript"
};
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Typst | Superscripts > Parameters ] --------------------------------------------------

---@class __typst.superscripts
---
---@field class "typst_superscript"
---@field parenthesis boolean Whether the text is surrounded by parenthesis.
---@field level integer Superscript level.
---@field text string[]
---@field range node.range
M.__typst_superscripts = {
	class = "typst_superscript",
	parenthesis = true,
	preview = true,
	level = 1,

	text = { "^{12}" },
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

## symbols

- Type: `typst.symbols`
- Dynamic: **true**

Configuration for typst symbols.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for symbols in typst.
---@class typst.symbols
---
---@field enable boolean
---@field hl? string
symbols = {
    enable = true,
    hl = "Special"
};
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Typst | Symbols > Parameters ] -------------------------------------------------------

---@class __typst.symbols
---
---@field class "typst_symbol"
---@field name string
---@field text string[]
---@field range node.range
M.__typst_symbols = {
	class = "typst_symbol",
	name = "alpha",

	text = { "alpha" },
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

## terms

- Type: `typst.terms`
- Dynamic: **true**

Configuration for terms.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
---@class typst.terms
---
---@field enable boolean
---
---@field default term.opts Default configuration for terms.
---@field [string] term.opts Configuration for terms whose label matches `string`.
terms = {
    enable = true,

    default = {
        text = " ",
        hl = "MarkviewPalette6Fg"
    },
}
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
-- [ Typst | Terms > Type definitions ] ---------------------------------------------------

---@class term.opts
---
---@field text string
---@field hl? string
M.term_opts = {
	text = "π",
	hl = "Comment"
};

-- [ Typst | Terms > Parameters ] ---------------------------------------------------------

---@class __typst.terms
---
---@field class "typst_term"
---
---@field label string
---
---@field text string[]
---@field range inline_link.range
M.__typst_terms = {
	class = "typst_term",
	label = "Term",

	text = { "/ Term" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 6,

		label = { 0, 2, 0, 6 }
	}
};
```
<!--_-->
</details>

## url_links

- Type: `typst.url_links`
- Dynamic: **true**

Configuration for URLs.

<details>
    <summary>Expand to see default configuration</summary><!--+-->

```lua
--- Configuration for URL links.
---@class typst.url_links
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for URL links.
---@field [string] config.inline_generic Configuration for URL links whose label matches `string`.
url_links = {
    enable = true,
    __emoji_link_compatibility = true,

    default = {
        icon = " ",
        hl = "MarkviewEmail"
    },
};
```
<!--_-->
</details>

<details>
    <summary>Expand to see type definition & advanced usage</summary><!--+-->

```lua
--- Configuration for URL links.
---@class typst.url_links
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for URL links.
---@field [string] config.inline_generic Configuration for URL links whose label matches `string`.
url_links = {
    enable = true,
    __emoji_link_compatibility = true,

    default = {
        icon = " ",
        hl = "MarkviewEmail"
    },
};
```
<!--_-->
</details>

