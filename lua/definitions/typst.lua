---@meta

local M = {};

-- [ Markview | Typst ] -------------------------------------------------------------------

--- Configuration for Typst.
---@class config.typst
---
---@field enable boolean
---
---@field code_blocks typst.code_blocks | fun(): typst.code_blocks
---@field code_spans typst.code_spans | fun(): typst.code_spans
---@field escapes typst.escapes | fun(): typst.escapes
---@field headings typst.headings | fun(): typst.headings
---@field labels typst.labels | fun(): typst.labels
---@field list_items typst.list_items | fun(): typst.list_items
---@field math_blocks typst.math_blocks | fun(): typst.math_blocks
---@field math_spans typst.math_spans | fun(): typst.math_spans
---@field raw_blocks typst.raw_blocks | fun(): typst.raw_blocks
---@field raw_spans typst.raw_spans | fun(): typst.raw_spans
---@field reference_links typst.reference_links | fun(): typst.reference_links
---@field subscripts typst.subscripts | fun(): typst.subscripts
---@field superscripts typst.subscripts | fun(): typst.superscripts
---@field symbols typst.symbols | fun(): typst.symbols
---@field terms typst.terms | fun(): typst.terms
---@field url_links typst.url_links | fun(): typst.url_links
M.typst = {
	enable = true,

	code_blocks = {},
	code_spans = {},
	escapes = {},
	headings = {},
	labels = {},
	list_items = {},
	math_spans = {},
	math_blocks = {},
	raw_spans = {},
	raw_blocks = {},
	reference_links = {},
	subscripts = {},
	superscript = {},
	symbols = {},
	terms = {},
	url_links = {},
};

-- [ Markview | Typst • Static ] ----------------------------------------------------------

--- Static configuration for Typst.
---@class config.typst_static
---
---@field enable boolean
---
---@field code_blocks typst.code_blocks Configuration for block of typst code.
---@field code_spans typst.code_spans Configuration for inline typst code.
---@field escapes typst.escapes Configuration for escaped characters.
---@field headings typst.headings Configuration for headings.
---@field labels typst.labels Configuration for labels.
---@field list_items typst.list_items Configuration for list items
---@field math_blocks typst.math_blocks Configuration for blocks of math code.
---@field math_spans typst.math_spans Configuration for inline math code.
---@field raw_blocks typst.raw_blocks Configuration for raw blocks.
---@field raw_spans typst.raw_spans Configuration for raw spans.
---@field reference_links typst.reference_links Configuration for reference links.
---@field subscripts typst.subscripts Configuration for subscript texts.
---@field superscripts typst.subscripts Configuration for superscript texts.
---@field symbols typst.symbols Configuration for typst symbols.
---@field terms typst.terms Configuration for terms.
---@field url_links typst.url_links Configuration for URL links.

-- [ Typst | Code blocks ] ----------------------------------------------------------------

--- Configuration for code blocks.
---@class typst.code_blocks
---
---@field enable boolean
---
---@field hl? string | fun(buffer: integer, item: __typst.code_block): string?
---@field min_width integer | fun(buffer: integer, item: __typst.code_block): integer
---@field pad_amount integer | fun(buffer: integer, item: __typst.code_block): integer
---@field pad_char? string | fun(buffer: integer, item: __typst.code_block): string?
---@field sign? string | fun(buffer: integer, item: __typst.code_block): string
---@field sign_hl? string | fun(buffer: integer, item: __typst.code_block): string?
---@field style ( "simple" | "block" ) | fun(buffer: integer, item: __typst.code_block): ( "simple" | "block" )
---@field text string | fun(buffer: integer, item: __typst.code_block): string
---@field text_direction ( "left" | "right" ) | fun(buffer: integer, item: __typst.code_block): ( "left" | "right" )
---@field text_hl? string | fun(buffer: integer, item: __typst.code_block): string?
M.typst_codes_block = {
	style = "block",
	text_direction = "right",
	pad_amount = 3,
	pad_char = " ",
	min_width = 60,
	hl = "MarkviewCode"
} or {
	style = "simple",
	hl = "MarkviewCode"
};

-- [ Typst | Code blocks • Static ] -------------------------------------------------------

--- Static configuration for code blocks.
---@class typst.code_blocks_static
---
---@field enable boolean
---
---@field hl? string
---@field min_width integer Minimum width of code blocks.
---@field pad_amount integer Number of paddings added around the text.
---@field pad_char? string Character to use for padding.
---@field sign? string Sign for the code block.
---@field sign_hl? string Highlight group for the sign.
---@field style
---| "simple" Only highlights the lines inside this block.
---| "block" Creates a box around the code block.
---@field text string Text to use as the label.
---@field text_direction
---| "left" Shows label on the top-left side of the block
---| "right" Shows label on the top-right side of the block
---@field text_hl? string Highlight group for the label

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

-- [ Typst | Code spans ] ----------------------------------------------------------------

--- Configuration for code spans.
---@class typst.code_spans
---
---@field enable boolean
---
---@field corner_left? string | fun(buffer: integer, item: __typst.code_spans): string?
---@field corner_left_hl? string | fun(buffer: integer, item: __typst.code_spans): string?
---@field corner_right? string | fun(buffer: integer, item: __typst.code_spans): string?
---@field corner_right_hl? string | fun(buffer: integer, item: __typst.code_spans): string?
---@field hl? string | fun(buffer: integer, item: __typst.code_spans): string?
---@field padding_left? string | fun(buffer: integer, item: __typst.code_spans): string?
---@field padding_left_hl? string | fun(buffer: integer, item: __typst.code_spans): string?
---@field padding_right? string | fun(buffer: integer, item: __typst.code_spans): string?
---@field padding_right_hl? string | fun(buffer: integer, item: __typst.code_spans): string?
M.typst_codes_inline = {
	enable = true,

	padding_left = " ",
	corner_left = " ",
	hl = "MarkviewCode"
};

-- [ Typst | Code spans • Static ] -------------------------------------------------------

--- Static configuration for code spans.
---@class typst.code_spans_static
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

-- [ Typst | Escapes ] ---------------------------------------------------------------------

---@alias typst.escapes { enable: boolean }

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

-- [ Typst | Headings ] -------------------------------------------------------------------

--- Configuration for Typst headings.
---@class typst.headings
---
---@field enable boolean
---
---@field shift_width integer Amount of spaces to shift per heading level.
---
---@field [string] headings.typst Heading level configuration(name format: "heading_%d", %d = heading level).
M.typst_headings = {
	enable = true,
	shift_width = 1,

	heading_1 = { style = "simple", hl = "MarkviewPalette1" }
};

-- [ Typst | Headings > Type definitions ] ------------------------------------------------

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

-- [ Typst | Labels ] ---------------------------------------------------------------------

--- Configuration for typst labels.
---@class typst.labels
---
---@field enable boolean
---
---@field default config.inline_generic | fun(buffer: integer, item: __typst.labels): config.inline_generic
---@field [string] config.inline_generic | fun(buffer: integer, item: __typst.labels): config.inline_generic
M.typst_labels = {
	enable = true,
	default = { hl = "MarkviewInlineCode" },
	["^nv"] = {
		hl = "MarkviewPalette1"
	}
};

-- [ Typst | Labels • Static ] ------------------------------------------------------------

--- Static configuration for typst labels.
---@class typst.labels
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for labels.
---@field [string] config.inline_generic Configuration for labels whose text matches `string`.

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


-- [ Typst | List items ] -----------------------------------------------------------------

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
M.typst_list_items = {
	enable = true,
	marker_plus = {},
	marker_minus = {},
	marker_dot = {},
};

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

-- [ Typst | Math blocks ] -----------------------------------------------------------------

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
M.typst_math_blocks = {
	enable = true,
	hl = "MarkviewInlineCode"
};

-- [ Typst | Math blocks > Parameters ] ---------------------------------------------------

---@class __typst.maths
---
---@field class "typst_math"
---
---@field inline boolean Should we render it inline?
---@field closed boolean Is the node closed(ends with `$$`)?
---
---@field text string[]
---@field range node.range
M.__typst_maths = {
	class = "typst_math",
	inline = true,
	closed = true,

	text = { "$ 1 + 2 $" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 9
	}
};

-- [ Typst | Math spans ] -----------------------------------------------------------------

---@alias typst.math_spans config.inline_generic
M.typst_math_spans = {
	enable = true,
	hl = "MarkviewInlineCode"
};

-- [ Typst | Math spans > Parameters ] ----------------------------------------------------

---@class __typst.maths
---
---@field class "typst_math"
---
---@field inline boolean Should we render it inline?
---@field closed boolean Is the node closed(ends with `$$`)?
---
---@field text string[]
---@field range node.range
M.__typst_maths = {
	class = "typst_math",
	inline = true,
	closed = true,

	text = { "$ 1 + 2 $" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 9
	}
};

-- [ Typst | Raw blocks ] -----------------------------------------------------------------

---@class typst.raw_blocks
---
---@field enable boolean
---
---@field border_hl? string | fun(buffer: integer, item: __typst.raw_blocks): string?
---@field label_direction? ( "left" | "right" ) | fun(buffer: integer, item: __typst.raw_blocks): ( "left" | "right" )
---@field label_hl? string | fun(buffer: integer, item: __typst.raw_blocks): string?
---@field min_width integer | fun(buffer: integer, item: __typst.raw_blocks): integer
---@field pad_amount? integer | fun(buffer: integer, item: __typst.raw_blocks): integer
---@field pad_char? string | fun(buffer: integer, item: __typst.raw_blocks): string?
---@field sign? boolean | fun(buffer: integer, item: __typst.raw_blocks): boolean?
---@field sign_hl? string | fun(buffer: integer, item: __typst.raw_blocks): string?
---@field style ( "simple" | "block" ) | fun(buffer: integer, item: __typst.raw_blocks): ( "simple" | "block" )
---
---@field default raw_blocks.opts | fun(buffer: integer, item: __typst.raw_blocks): raw_blocks.opts
---@field [string] raw_blocks.opts | fun(buffer: integer, item: __typst.raw_blocks): raw_blocks.opts
M.typst_raw_blocks = {
	enable = true,
	hl = "MarkviewInlineCode"
};

-- [ Typst | Raw blocks • Static ] --------------------------------------------------------

---@class typst.raw_blocks_static
---
---@field enable boolean
---
---@field border_hl? string Highlight group for top & bottom border of raw blocks.
---@field label_direction? "left" | "right" Changes where the label is shown.
---@field label_hl? string Highlight group for the label
---@field min_width? integer Minimum width of the code block.
---@field pad_amount? integer Left & right padding size.
---@field pad_char? string Character to use for the padding.
---@field sign? boolean Whether to show signs for the code blocks.
---@field sign_hl? string Highlight group for the signs.
---@field style "simple" | "block" Preview style for code blocks.
---
---@field default raw_blocks.opts_static Default line configuration for the raw block.
---@field [string] raw_blocks.opts_static Line configuration for the raw block whose `language` matches `string`

-- [ Typst | Raw blocks > Type definitions ] -----------------------------------------------

--- Configuration for highlighting a line inside a raw block.
---@class raw_blocks.opts
---
---@field block_hl string | fun(buffer: integer, line: string): string?
---@field pad_hl string | fun(buffer: integer, line: string): string?

--- Static configuration for highlighting a line inside a raw block.
---@class raw_blocks.opts_static
---
---@field block_hl string? Highlight group for the background of the line.
---@field pad_hl string? Highlight group for the padding of the line.

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

-- [ Typst | Raw spans ] ------------------------------------------------------------------

---@alias typst.raw_spans config.inline_generic
M.typst_raw_spans = {
	enable = true,
	hl = "MarkviewInlineCode"
};

-- [ Typst | Raw spans • Static ] ---------------------------------------------------------

---@alias typst.raw_spans_static config.inline_generic_static

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

-- [ Typst | Reference links ] -----------------------------------------------------------

---@class typst.reference_links
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for reference links.
---@field [string] config.inline_generic Configuration for reference links whose label matches `string`.
M.typst_link_ref = {
	enable = true,
	default = { hl = "MarkviewHyperlink" },
	["neovim.org"] = {
		match_string = "",
		hl = "MarkviewPalette1"
	}
};

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

-- [ Typst | Subscripts ] ------------------------------------------------------------------

--- Configuration for subscript text.
---@class typst.subscripts
---
---@field enable boolean
---
---@field hl? string | string[]
---@field marker_left? string
---@field marker_right? string
M.typst_subscripts = {
	enable = true,
	hl = "MarkviewSubscript"
};

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

-- [ Typst | Superscripts ] ---------------------------------------------------------------

--- Configuration for superscript text.
---@class typst.superscripts
---
---@field enable boolean
---
---@field hl? string | string[]
---@field marker_left? string
---@field marker_right? string
M.typst_superscripts = {
	enable = true,
	hl = "MarkviewSuperscript"
};

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

-- [ Typst | Symbols ] --------------------------------------------------------------------

--- Configuration for symbols in typst.
---@class typst.symbols
---
---@field enable boolean
---@field hl? string
M.typst_symbols = {
	enable = true,
	hl = "Special"
};

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


---@class typst.fonts
---
---@field enable boolean
---@field hl? string
M.typst_fonts = {
	enable = true,
	hl = "Special"
};

-- [ Typst | Terms ] --------------------------------------------------------------------

---@class typst.terms
---
---@field enable boolean
---
---@field default term.opts Default configuration for terms.
---@field [string] term.opts Configuration for terms whose label matches `string`.
M.typst_term = {
	enable = true,
	default = {},
};

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

-- [ Typst | URL links ] ------------------------------------------------------------------

--- Configuration for URL links.
---@class typst.url_links
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for URL links.
---@field [string] config.inline_generic Configuration for URL links whose label matches `string`.
M.typst_link_ref = {
	enable = true,
	default = { hl = "MarkviewHyperlink" },
	["neovim.org"] = {
		hl = "MarkviewPalette1"
	}
};

-- [ Typst | URL links > Parameters ] -----------------------------------------------------

---@class __typst.url_links
---
---@field class "typst_link_url"
---@field label string
---@field text string[]
---@field range inline_link.range
M.__typst_url_links = {
	class = "typst_link_url",
	label = "https://example.com",

	text = { "https://example.com" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 19,

		label = { 0, 0, 0, 19 }
	}
};

-- [ Typst | Misc ] -----------------------------------------------------------------------

---@class __typst.emphasis
---
---@field class "typst_emphasis"
---@field text string[]
---@field range node.range
M.__typst_emphasis = {
	class = "typst_emphasis",
	text = { "_emphasis_" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 9
	}
};

---@class __typst.strong
---
---@field class "typst_strong"
---@field text string[]
---@field range node.range
M.__typst_strong = {
	class = "typst_strong",

	text = { "*strong*" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 7
	}
};

---@class __typst.text
---
---@field class "typst_text"
---@field text string[]
---@field range node.range
M.__typst_text = {
	class = "typst_text",

	text = { "1" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 1
	}
};

return M;
