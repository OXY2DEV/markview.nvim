---@meta

--- Markdown related stuff.
local M = {};

-- [ Markview | Markdown ] ----------------------------------------------------------------

--- Configuration for markdown.
---@class config.markdown
---
---@field enable boolean
---
---@field block_quotes markdown.block_quotes | fun(): markdown.block_quotes
---@field code_blocks markdown.code_blocks | fun(): __markdown.code_blocks
---@field headings markdown.headings | fun(): markdown.headings
---@field horizontal_rules markdown.horizontal_rules | fun(): markdown.horizontal_rules
---@field list_items markdown.list_items | fun(): markdown.list_items
---@field metadata_minus markdown.metadata_minus | fun(): markdown.metadata_minus
---@field metadata_plus markdown.metadata_plus | fun(): markdown.metadata_plus
---@field reference_definitions markdown.reference_definitions | fun(): markdown.reference_definitions
---@field tables markdown.tables | fun(): markdown.tables
M.markdown = {
	enable = true,

	metadata_minus = {},
	horizontal_rules = {},
	headings = {},
	code_blocks = {},
	block_quotes = {},
	list_items = {},
	metadata_plus = {},
	reference_definitions = {},
	tables = {}
};

-- [ Markview | Markdown • Static ] -------------------------------------------------------

--- Static configuration for markdown.
---@class config.markdown_static
---
---@field enable boolean
---
---@field block_quotes markdown.block_quotes Block quote configuration.
---@field code_blocks markdown.code_blocks Fenced code block configuration.
---@field headings markdown.headings Heading configuration.
---@field horizontal_rules markdown.horizontal_rules Horizontal rules configuration.
---@field list_items markdown.list_items List items configuration.
---@field metadata_minus markdown.metadata_minus YAML metadata configuration.
---@field metadata_plus markdown.metadata_plus TOML metadata configuration.
---@field reference_definitions markdown.reference_definitions Reference link definition configuration.
---@field tables markdown.tables Table configuration.

-- [ Markdown | Block quotes ] ------------------------------------------------------------

--- Configuration for block quotes.
---@class markdown.block_quotes
---
---@field enable boolean
---
---@field wrap? boolean | fun(buffer: integer, item: __markdown.block_quotes): boolean?
---
---@field default block_quotes.opts | fun(buffer: integer, item: __markdown.block_quotes): boolean?
---@field [string] block_quotes.opts | fun(buffer: integer, item: __markdown.block_quotes): boolean?
M.markdown_block_quotes = {
	enable = true,
	default = { border = "", hl = "MarkviewBlockQuoteDefault" },

	["EXAMPLE"] = { border = { "|", "^", "•" } }
};

-- [ Markdown | Block quotes • Static ] ---------------------------------------------------

--- Static configuration for block quotes.
---@class markdown.block_quotes_static
---
---@field enable boolean
---
---@field wrap? boolean Enables basic wrap support.
---
---@field default block_quotes.opts Default block quote configuration.
---@field [string] block_quotes.opts Configuration for >[!{string}] callout.

-- [ Markdown | Block quotes > Type definition ] ------------------------------------------

--- Configuration options for various types of block quotes.
---@class block_quotes.opts
---
---@field border string | string[] | fun(buffer: integer, item: __markdown.block_quotes): (string | string[])
---@field border_hl? (string | string[]) | fun(buffer: integer, item: __markdown.block_quotes): (string | string[])?
---@field hl? string | fun(buffer: integer, item: __markdown.block_quotes): string?
---@field icon? string | fun(buffer: integer, item: __markdown.block_quotes): string?
---@field icon_hl? string | fun(buffer: integer, item: __markdown.block_quotes): string?
---@field preview? string | fun(buffer: integer, item: __markdown.block_quotes): string?
---@field preview_hl? string | fun(buffer: integer, item: __markdown.block_quotes): string?
---@field title? boolean | fun(buffer: integer, item: __markdown.block_quotes): string?
M.block_quotes_opts = {
	border = "|",
	hl = "MarkviewBlockQuoteDefault",
	icon = "π",
	preview = "π Some text"
};

-- [ Markdown | Block quotes > Type definition • Static ] ---------------------------------

--- Static configuration options for various types of block quotes.
---@class block_quotes.opts
---
---@field border string | string[] Text for the border.
---@field border_hl? string | string[] Highlight group for the border.
---@field hl? string Base highlight group for the block quote.
---@field icon? string Icon to show before the block quote title.
---@field icon_hl? string Highlight group for the icon.
---@field preview? string Callout/Alert preview string(shown where >[!{string}] was).
---@field preview_hl? string Highlight group for the preview.
---@field title? boolean Whether the block quote can have a title or not.
M.block_quotes_opts = {
	border = "|",
	hl = "MarkviewBlockQuoteDefault",
	icon = "π",
	preview = "π Some text"
};

-- [ Markdown | Block quotes > Parameters ] -----------------------------------------------

---@class __markdown.block_quotes
---
---@field class "markdown_block_quote"
---
---@field callout string? Callout text(text inside `[!...]`).
---@field title string? Title of the callout.
---
---@field text string[]
---@field range __block_quotes.range
---
---@field __nested boolean Is the node nested?
M.__markdown_block_quotes = {
	class = "markdown_block_quote",
	callout = "TIP",
	title = "Title",

	text = {
		">[!TIP] Title",
		"> Something."
	},
	range = {
		row_start = 0,
		row_end = 2,

		col_start = 0,
		col_end = 0,

		callout_start = 3,
		callout_end = 6,

		title_start = 8,
		title_end = 13
	}
};

---@class __block_quotes.range
---
---@field row_start integer
---@field row_end integer
---@field col_start integer
---@field col_end integer
---
---@field callout_start? integer Start column of callout text(after `[!`).
---@field callout_end? integer End column of callout text(before `]`).
---@field title_start? integer Start column of the title.
---@field title_end? integer End column of the title.
M.__block_quotes_range = {
	row_start = 0,
	row_end = 2,

	col_start = 0,
	col_end = 0,

	callout_start = 3,
	callout_end = 6,

	title_start = 8,
	title_end = 13
};

-- [ Markdown | Code blocks ] -------------------------------------------------------------

--- Configuration for code blocks.
---@class markdown.code_blocks
---
---@field enable boolean
---
---@field border_hl? string | fun(buffer: integer, item: __markdown.code_blocks): string?
---@field info_hl? string | fun(buffer: integer, item: __markdown.code_blocks): string?
---@field label_direction? "left" | "right" | fun(buffer: integer, item: __markdown.code_blocks): ("left" | "right")
---@field label_hl? string | fun(buffer: integer, item: __markdown.code_blocks): string?
---@field min_width? integer | fun(buffer: integer, item: __markdown.code_blocks): integer
---@field pad_amount? integer | fun(buffer: integer, item: __markdown.code_blocks): integer
---@field pad_char? string | fun(buffer: integer, item: __markdown.code_blocks): string?
---@field sign? boolean | fun(buffer: integer, item: __markdown.code_blocks): boolean
---@field sign_hl? string | fun(buffer: integer, item: __markdown.code_blocks): string?
---@field style "simple" | "block" | fun(buffer: integer, item: __markdown.code_blocks): ("simple" | "block")
---
---@field default code_blocks.opts | fun(buffer: integer, item: __markdown.code_blocks): code_blocks.opts
---@field [string] code_blocks.opts | fun(buffer: integer, item: __markdown.code_blocks): code_blocks.opts
M.markdown_code_blocks = {
	style = "simple",
	hl = "MarkviewCode"
} or {
	style = "block",
	label_direction = "right",
	min_width = 60,
	pad_amount = 3,
	pad_char = " "
};

-- [ Markdown | Code blocks • Static ] ----------------------------------------------------

--- Static configuration for code blocks.
---@class markdown.code_blocks_static
---
---@field enable boolean
---
---@field border_hl? string Highlight group for the top & bottom border.
---@field info_hl? string Highlight group for the info string.
---@field label_direction? "left" | "right" Changes where the label is shown.
---@field label_hl? string Highlight group for the label.
---@field min_width? integer Minimum width of the code block.
---@field pad_amount? integer Left & right padding size.
---@field pad_char? string Character to use for the padding.
---@field sign? boolean Whether to show signs for the code blocks.
---@field sign_hl? string Highlight group for the signs.
---@field style "simple" | "block" Preview style for code blocks.
---
---@field default code_blocks.opts_static Default line configuration for the code block.
---@field [string] code_blocks.opts_static Line configuration for the code block whose `language` matches `string`

-- [ Markdown | Code blocks > Type definitions ] ------------------------------------------

--- Configuration for highlighting a line inside a code block.
---@class code_blocks.opts
---
---@field block_hl string | fun(buffer: integer, line: string): string?
---@field pad_hl string | fun(buffer: integer, line: string): string?

--- Static configuration for highlighting a line inside a code block.
---@class code_blocks.opts_static
---
---@field block_hl string? Highlight group for the background of the line.
---@field pad_hl string? Highlight group for the padding of the line.

-- [ Markdown | Code blocks > Parameters ] ------------------------------------------------

---@class __markdown.code_blocks
---
---@field class "markdown_code_block"
---
---@field delimiters [ string, string ] Code block delimiters.
---@field language string? Language string(typically after ```).
---@field info_string string? Extra information regarding the code block.
---
---@field text string[]
---@field range __code_blocks.range
M.__markdown_code_blocks = {
	class = "markdown_code_block",

	language = "lua",
	info_string = "lua Info string",

	text = {
		"``` lua Info string",
		'vim.print("Hello, Neovim!");',
		"```"
	},

	range = {
		row_start = 0,
		row_end = 3,

		col_start = 0,
		col_end = 0,

		language = { 0, 4, 0, 7 },
		info_string = { 0, 4, 0, 15 }
	}
};

---@class __code_blocks.range
---
---@field row_start integer
---@field row_end integer
---@field col_start integer
---@field col_end integer
---
---@field language? integer[] Range of the language string.
---@field info_string? integer[] Range of info string.
M.__code_blocks_range = {
	row_start = 0,
	row_end = 3,

	col_start = 0,
	col_end = 0,

	language = { 0, 4, 0, 7 },
	info_string = { 0, 4, 0, 15 }
};

-- [ Markdown | Headings ] ----------------------------------------------------------------

---@class markdown.headings
---
---@field enable boolean Enables preview of headings.
---
---@field heading_1 headings.atx | fun(buffer: integer, item: __markdown.atx): headings.atx
---@field heading_2 headings.atx | fun(buffer: integer, item: __markdown.atx): headings.atx
---@field heading_3 headings.atx | fun(buffer: integer, item: __markdown.atx): headings.atx
---@field heading_4 headings.atx | fun(buffer: integer, item: __markdown.atx): headings.atx
---@field heading_5 headings.atx | fun(buffer: integer, item: __markdown.atx): headings.atx
---@field heading_6 headings.atx | fun(buffer: integer, item: __markdown.atx): headings.atx
---
---@field setext_1 headings.setext | fun(buffer: integer, item: __markdown.setext): headings.setext
---@field setext_2 headings.setext | fun(buffer: integer, item: __markdown.setext): headings.setext
---
---@field shift_width integer Amount of spaces to add before the heading(per level).
---
---@field org_indent? boolean Whether to enable org-mode like section indentation.
---@field org_shift_width? integer Shift width for org indents.
---@field org_shift_char? string Shift char for org indent.
---@field org_indent_wrap? boolean Whether to enable wrap support. May have severe performance issues!
M.markdown_headings = {
	enable = true,
	shift_width = 1,

	heading_1 = {},
	heading_2 = {},
	heading_3 = {},
	heading_4 = {},
	heading_5 = {},
	heading_6 = {}
};

-- [ Markdown | Headings > Type definitions ] ---------------------------------------------

---@class headings.atx
---
---@field align? "left" | "center" | "right" Label alignment.
---@field corner_left? string Left corner.
---@field corner_left_hl? string Highlight group for left corner.
---@field corner_right? string Right corner.
---@field corner_right_hl? string Highlight group for right corner.
---@field hl? string Base Highlight group.
---@field icon? string Icon.
---@field icon_hl? string Highlight group for icon.
---@field padding_left? string Left padding.
---@field padding_left_hl? string Highlight group for left padding.
---@field padding_right? string Right padding.
---@field padding_right_hl? string Highlight group for right padding.
---@field sign? string Text to show on the sign column.
---@field sign_hl? string Highlight group for the sign.
---@field style "simple" | "label" | "icon" Preview style.
M.headings_atx = {
	style = "simple",
	hl = "MarkviewHeading1"
} or {
	style = "label",
	align = "center",

	padding_left = " ",
	padding_right = " ",

	hl = "MarkviewHeading1"
} or {
	style = "icon",

	icon = "~",
	hl = "MarkviewHeading1"
};

---@class headings.setext
---
---@field border string Text to use for the preview border.
---@field border_hl? string Highlight group for the border.
---@field hl? string Base highlight group.
---@field icon? string Text to use for the icon.
---@field icon_hl? string Highlight group for the icon.
---@field sign? string Text to show in the sign column.
---@field sign_hl? string Highlight group for the sign.
---@field style "simple" | "decorated" Preview style.
M.headings_setext = {
	style = "simple",
	hl = "MarkviewHeading1"
} or {
	style = "decorated",
	border = "—",
	hl = "MarkviewHeading1"
};

-- [ Markdown | Headings > Parameters ] ---------------------------------------------------

---@class __markdown.atx
---
---@field class "markdown_atx_heading"
---
---@field marker "#" | "##" | "###" | "####" | "#####" | "######" Heading marker.
---
---@field text string[]
---@field range node.range
M.__markdown_atx = {
	class = "markdown_atx_heading",
	marker = "#",

	text = { "# Heading 1" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 11
	}
};

---@class __markdown.setext
---
---@field class "markdown_setext_heading"
---
---@field marker "---" | "===" Heading marker.
---
---@field text string[]
---@field range node.range
M.__markdown_setext = {
	class = "markdown_setext_heading",
	marker = "---",
	text = {
		"Heading",
		"---"
	},
	range = {
		row_start = 0,
		row_end = 2,

		col_start = 0,
		col_end = 3
	}
};

-- [ Markdown | Horizontal rules ] --------------------------------------------------------

--- Configuration for horizontal rules.
---@class markdown.horizontal_rules
---
---@field enable boolean Enables preview of horizontal rules.
---
---@field parts ( horizontal_rules.text | horizontal_rules.repeating )[] Parts for the horizontal rules.
M.markdown_horizontal_rules = {
	enable = true,
	parts = {};
};

-- [ Markdown | Horizontal rules > Type definitions ] -------------------------------------

---@class horizontal_rules.text
---
---@field type "text" Part name.
---
---@field hl? string Highlight group for this part.
---@field text string Text to show.
M.hr_text = {
	type = "text",

	hl = "MarkviewPalette9",
	text = " π "
};

---@class horizontal_rules.repeating
---
---@field type "repeating" Part name.
---
---@field direction "left" | "right" Direction from which the highlight groups are applied from.
---
---@field repeat_amount integer | fun(buffer: integer, item: __markdown.horizontal_rules): integer How many times to repeat the text.
---@field repeat_hl? boolean | fun(buffer: integer, item: __markdown.horizontal_rules): boolean Whether to repeat the highlight groups.
---@field repeat_text? boolean | fun(buffer: integer, item: __markdown.horizontal_rules): boolean Whether to repeat the text.
---
---@field text string | string[] Text to repeat.
---@field hl? string | string[] Highlight group for the text.
M.hr_repeating = {
	type = "repeating",

	repeat_amount = math.floor(vim.o.columns / 2),
	repeat_hl = false,
	repeat_text = true,

	text = "-",
	hl = { "MarkviewPalette0", "MarkviewPalette1", "MarkviewPalette2", "MarkviewPalette3" }
};

-- [ Markdown | Horizontal rules > Parameters ] -------------------------------------------

---@class __markdown.horizontal_rules
---
---@field class "markdown_hr"
---@field text string[]
---@field range node.range
M.__markdown_hr = {
	class = "markdown_hr",
	text = { "---" },
	range = {
		row_start = 0,
		row_end = 1,

		col_start = 0,
		col_end = 0
	}
};

-- [ Markdown | List items ] --------------------------------------------------------------

--- Configuration for list items.
---@class markdown.list_items
---
---@field enable boolean
---
---@field indent_size integer | fun(buffer: integer, item: __markdown.list_items): integer Indentation size for list items.
---@field shift_width integer | fun(buffer: integer, item: __markdown.list_items): integer Virtual indentation size for previewed list items.
---
---@field marker_dot list_items.ordered Configuration for `n.` list items.
---@field marker_minus list_items.unordered Configuration for `-` list items.
---@field marker_parenthesis list_items.ordered Configuration for `n)` list items.
---@field marker_plus list_items.unordered Configuration for `+` list items.
---@field marker_star list_items.unordered Configuration for `*` list items.
---
---@field wrap? boolean Enables wrap support.
M.markdown_list_items = {
	enable = true,
	marker_plus = {},
	marker_star = {},
	marker_minus = {},
	marker_dot = {},
	marker_parenthesis = {}
};

-- [ Markdown | List items • Static ] -----------------------------------------------------

--- Configuration for list items.
---@class markdown.list_items_static
---
---@field enable boolean
---
---@field indent_size integer Indentation size for list items.
---@field shift_width integer Virtual indentation size for previewed list items.
---
---@field marker_dot list_items.ordered Configuration for `n.` list items.
---@field marker_minus list_items.unordered Configuration for `-` list items.
---@field marker_parenthesis list_items.ordered Configuration for `n)` list items.
---@field marker_plus list_items.unordered Configuration for `+` list items.
---@field marker_star list_items.unordered Configuration for `*` list items.
---
---@field wrap? boolean Enables wrap support.
M.markdown_list_items = {
	enable = true,
	marker_plus = {},
	marker_star = {},
	marker_minus = {},
	marker_dot = {},
	marker_parenthesis = {}
};

-- [ Markdown | List items > Type definitions ] -------------------------------------------

---@class list_items.unordered
---
---@field add_padding boolean
---@field conceal_on_checkboxes? boolean
---@field enable? boolean
---@field hl? string
---@field text string
M.list_items_unordered = {
	enable = true,
	hl = "MarkviewListItemPlus",
	text = "•",
	add_padding = true,
	conceal_on_checkboxes = true
};

---@class list_items.ordered
---
---@field add_padding boolean
---@field conceal_on_checkboxes? boolean
---@field enable? boolean
M.list_items_ordered = {
	enable = true,
	add_padding = true,
	conceal_on_checkboxes = true
};

-- [ Markdown | List items > Parameters ] -------------------------------------------------

---@class __markdown.list_items
---
---@field class "markdown_list_item"
---@field candidates integer[] List of line numbers(0-indexed) from `range.row_start` that should be indented.
---@field marker "-" | "+" | "*" | string List marker text.
---@field checkbox? string Checkbox state(if there is a checkbox).
---@field indent integer Spaces before the list marker.
---@field text string[]
---@field range node.range
---
---@field __block boolean Indicates whether the list item is the children of a block quote.
M.__markdown_list_items = {
	class = "markdown_list_item",
	marker = "-",
	checkbox = nil,
	candidates = { 0 },

	text = { "- List item" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 11
	}
};

-- [ Markdown | Metadata minus ] ----------------------------------------------------------

--- Configuration for YAML metadata.
---@class markdown.metadata_minus
---
---@field enable boolean
---
---@field border_bottom? string | fun(buffer: integer, item: __markdown.metadata_minus): string?
---@field border_bottom_hl? string | fun(buffer: integer, item: __markdown.metadata_minus): string?
---@field border_hl? string | fun(buffer: integer, item: __markdown.metadata_minus): string?
---@field border_top? string | fun(buffer: integer, item: __markdown.metadata_minus): string?
---@field border_top_hl? string | fun(buffer: integer, item: __markdown.metadata_minus): string?
---
---@field hl? string | fun(buffer: integer, item: __markdown.metadata_minus): string?
M.markdown_metadata_minus = {
	enable = true,
	hl = "MarkviewCode"
};

-- [ Markdown | Metadata minus • Static ] -------------------------------------------------

--- Static configuration for YAML metadata.
---@class markdown.metadata_minus_static
---
---@field enable boolean
---
---@field border_bottom? string Bottom border.
---@field border_bottom_hl? string Highlight group for the bottom border.
---@field border_hl? string Primary highlight group for the borders.
---@field border_top? string Top border.
---@field border_top_hl? string Highlight group for the top border.
---
---@field hl? string Background highlight group.

-- [ Markdown | Metadata minus > Parameters ] ---------------------------------------------

---@class __markdown.metadata_minus
---
---@field class "markdown_metadata_minus"
---@field text string[]
---@field range node.range
M.__markdown_metadata_minus = {
	class = "markdown_metadata_minus",

	text = {
		"---",
		"author: OXY2DEV",
		"---"
	},
	range = {
		row_start = 0,
		row_end = 2,

		col_start = 0,
		col_end = 3
	}
};

-- [ Markdown | Metadata plus ] -----------------------------------------------------------

--- Configuration for TOML metadata.
---@class markdown.metadata_plus
---
---@field enable boolean
---
---@field border_bottom? string | fun(buffer: integer, item: __markdown.metadata_plus): string?
---@field border_bottom_hl? string | fun(buffer: integer, item: __markdown.metadata_plus): string?
---@field border_hl? string | fun(buffer: integer, item: __markdown.metadata_plus): string?
---@field border_top? string | fun(buffer: integer, item: __markdown.metadata_plus): string?
---@field border_top_hl? string | fun(buffer: integer, item: __markdown.metadata_plus): string?
---
---@field hl? string | fun(buffer: integer, item: __markdown.metadata_plus): string?
M.markdown_metadata_plus = {
	enable = true,
	hl = "MarkviewCode"
};

-- [ Markdown | Metadata plus • Static ] --------------------------------------------------

--- Static configuration for TOML metadata.
---@class markdown.metadata_plus_static
---
---@field enable boolean
---
---@field border_bottom? string Bottom border.
---@field border_bottom_hl? string Highlight group for the bottom border.
---@field border_hl? string Primary highlight group for the borders.
---@field border_top? string Top border.
---@field border_top_hl? string Highlight group for the top border.
---
---@field hl? string Background highlight group.

-- [ Markdown | Metadata plus > Parameters ] ----------------------------------------------

---@class __markdown.metadata_plus
---
---@field class "markdown_metadata_plus"
---@field text string[]
---@field range node.range
M.__markdown_metadata_plus = {
	class = "markdown_metadata_plus",

	text = {
		"---",
		"author: OXY2DEV",
		"---"
	},
	range = {
		row_start = 0,
		row_end = 2,

		col_start = 0,
		col_end = 3
	}
};

-- [ Markdown | Reference definitions ] ---------------------------------------------------

--- Configuration for reference definitions.
---@class markdown.reference_definitions
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for reference definitions.
---@field [string] config.inline_generic Configuration for reference definitions whose description matches `string`.
M.markdown_ref_def = {
	enable = true,
	default = { hl = "Title" },
	["^mkv"] = {
		hl = "Special"
	}
};

-- [ Markdown | Reference definitions > Parameters ] --------------------------------------

---@class __markdown.reference_definitions
---
---@field class "markdown_link_ref_definition"
---
---@field label? string Visible part of the reference link definition.
---@field description? string Description of the reference link.
---
---@field text string[]
---@field range __reference_definitions.range
M.__markdown_reference_definitions = {
	class = "markdown_link_ref_definition",
	label = "nvim",
	description = "https://www.neovim.org",

	text = {
		"[nvim]:",
		"https://www.neovim.org"
	},
	range = {
		row_start = 0,
		row_end = 1,

		col_start = 0,
		col_end = 21,

		label = { 0, 0, 0, 7 },
		description = { 1, 0, 1, 21 }
	}
};

---@class __reference_definitions.range
---
---@field row_start integer
---@field row_end integer
---@field col_start integer
---@field col_end integer
---
---@field label integer[] Range of the label node(result of `TSNode:range()`).
---@field description? integer[] Range of the description node. Same as `label`.
M.__reference_definitions_range = {
	row_start = 0,
	row_end = 1,

	col_start = 0,
	col_end = 21,

	label = { 0, 0, 0, 7 },
	description = { 1, 0, 1, 21 }
};

-- [ Markdown | Tables ] ------------------------------------------------------------------

--- Configuration for tables.
---@class markdown.tables
---
---@field enable boolean
---@field strict boolean When `true`, leading & trailing whitespaces are not considered part of the cell.
---
---@field block_decorator boolean
---@field use_virt_lines boolean
---
---@field hl tables.parts | fun(buffer: integer, item: __markdown.tables): tables.parts
---@field parts tables.parts | fun(buffer: integer, item: __markdown.tables): tables.parts
M.markdown_tables = {
	parts = {},
	enable = true,
	hl = {},
	block_decorator = true,
	use_virt_lines = true
};

-- [ Markdown | Tables • Static ] ---------------------------------------------------------

--- Static configuration for tables.
---@class markdown.tables_static
---
---@field enable boolean
---@field strict boolean When `true`, leading & trailing whitespaces are not considered part of the cell.
---
---@field block_decorator boolean Whether to draw top & bottom border.
---@field use_virt_lines boolean Whether to use virtual lines for the borders.
---
---@field hl tables.parts Highlight groups for the parts.
---@field parts tables.parts Parts for the table.

-- [ Markdown | Tables > Type definitions ] -----------------------------------------------

--- Parts that make the previewed table.
---@class tables.parts
---
---@field align_center [ string, string ]
---@field align_left string
---@field align_right string
---@field top string[]
---@field header string[]
---@field separator string[]
---@field row string[]
---@field bottom string[]
---@field overlap string[]
M.tables_parts = {
	align_center = { "" },
	row = { "", "", "" },
	top = { "", "", "", "" },
	bottom = { "", "", "", "" },
	header = { "", "", "" },
	overlap = { "", "", "", "" },
	separator = { "", "", "" },
	align_left = "",
	align_right = ""
};

-- [ Markdown | Tables > Parameters ] -----------------------------------------------------

---@class __markdown.tables
---
---@field class "markdown_table"
---@field has_alignment_markers boolean Are there any alignment markers(e.g. `:-`, `-:`, `:-:`)?
---
---@field top_border boolean Can we draw the top border?
---@field bottom_border boolean Can we draw the bottom border?
---@field border_overlap boolean Is the table's borders overlapping another table?
---
---@field alignments ( "left" | "center" | "right" | "default" )[] Text alignments.
---@field header __tables.cell[]
---@field separator __tables.cell[]
---@field rows __tables.cell[][]
---
---@field text string[]
---@field range node.range
M.__markdown_tables = {
	class = "markdown_table",

	top_border = true,
	bottom_border = true,
	border_overlap = false,

	alignments = { "default", "default", "default" },
	header = {
		{
			class = "separator",
			text = "|",
			col_start = 0,
			col_end = 1
		},
		{
			class = "column",
			text = " Col 1 ",
			col_start = 2,
			col_end = 9
		},
		{
			class = "separator",
			text = "|",
			col_start = 10,
			col_end = 11
		},
		{
			class = "column",
			text = " Col 2 ",
			col_start = 12,
			col_end = 19
		},
		{
			class = "separator",
			text = "|",
			col_start = 20,
			col_end = 21
		}
	},
	separator = {
		{
			class = "separator",
			text = "|",
			col_start = 0,
			col_end = 1
		},
		{
			class = "column",
			text = " ----- ",
			col_start = 2,
			col_end = 9
		},
		{
			class = "separator",
			text = "|",
			col_start = 10,
			col_end = 11
		},
		{
			class = "column",
			text = " ----- ",
			col_start = 12,
			col_end = 19
		},
		{
			class = "separator",
			text = "|",
			col_start = 20,
			col_end = 21
		}
	},
	rows = {
		{
			{
				class = "separator",
				text = "|",
				col_start = 0,
				col_end = 1
			},
			{
				class = "column",
				text = " Cell 1 ",
				col_start = 2,
				col_end = 10
			},
			{
				class = "separator",
				text = "|",
				col_start = 11,
				col_end = 12
			},
			{
				class = "column",
				text = " Cell 2 ",
				col_start = 13,
				col_end = 21
			},
			{
				class = "separator",
				text = "|",
				col_start = 22,
				col_end = 23
			}
		}
	},

	text = {
		"| Col 1 | Col 2 |",
		"| ----- | ----- |",
		"| Cell 1 | Cell 2 |"
	}
};

---@class __tables.cell
---
---@field class "separator" | "column" | "missing_separator"
---
---@field text string
---
---@field col_start integer
---@field col_end integer
M.__tables_cell = {
	class = "separator",
	text = "|",
	col_start = 0,
	col_end = 1
};

-- [ Markdown | Misc ] --------------------------------------------------------------------

---@class __markdown.checkboxes
---
---@field class "markdown_checkbox"
---@field state string State of the checkbox(text inside `[]`).
---@field text string[],
---@field range node.range
M.__markdown_checkboxes = {
	class = "markdown_checkbox",
	state = " ",
	text = { "[ ]" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 2,
		col_end = 5
	}
};

---@class __markdown.sections
---
---@field class "markdown_section"
---@field level integer
---@field text string[]
---@field range node.range
M.__markdown_sections = {
	class = "markdown_section",

	text = {
		"# header",
		"",
		"Some text"
	},
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 9
	}
};

return M;
