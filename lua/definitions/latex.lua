---@meta

--- LaTeX related stuff
local M = {};

-- [ Markview | LaTeX ] -------------------------------------------------------------------

--- Configuration for LaTeX.
---@class config.latex
---
---@field enable boolean
---
---@field blocks? latex.blocks | fun(): latex.blocks
---@field commands? latex.commands | fun(): latex.commands
---@field escapes? latex.escapes | fun(): latex.escapes
---@field fonts? latex.fonts | fun(): latex.fonts
---@field inlines? latex.inlines | fun(): latex.inlines
---@field parenthesis? latex.parenthesis | fun(): latex.parenthesis
---@field subscripts? latex.subscripts | fun(): latex.subscripts
---@field superscripts? latex.superscripts | fun(): latex.superscripts
---@field symbols? latex.symbols | fun(): latex.symbols
---@field texts? latex.texts | fun(): latex.texts
M.latex = {
	enable = true,

	commands = {},
	texts = {},
	symbols = {},
	subscripts = {},
	superscripts = {},
	parenthesis = {},
	escapes = {},
	inlines = {},
	blocks = {},
	fonts = {}
};

-- [ Markview | LaTeX • Static ] ----------------------------------------------------------

--- Static configuration for LaTeX.
---@class config.latex_static
---
---@field enable boolean
---
--- LaTeX blocks configuration(typically made with `$$...$$`).
---@field blocks? latex.blocks
--- LaTeX commands configuration(e.g. `\frac{x}{y}`).
---@field commands? latex.commands
--- LaTeX escaped characters configuration.
---@field escapes? latex.escapes
--- LaTeX fonts configuration(e.g. `\mathtt{}`).
---@field fonts? latex.fonts
--- Inline LaTeX configuration(typically made with `$...$`).
---@field inlines? latex.inlines
--- Configuration for hiding `{}`.
---@field parenthesis? latex.parenthesis
--- LaTeX subscript configuration(`_{}`, `_x`).
---@field subscripts? latex.subscripts
--- LaTeX superscript configuration(`^{}`, `^x`).
---@field superscripts? latex.superscripts
--- TeX math symbols configuration(e.g. `\alpha`).
---@field symbols? latex.symbols
--- Text block configuration(`\text{}`).
---@field texts? latex.texts
M.latex = {
	enable = true,

	commands = {},
	texts = {},
	symbols = {},
	subscripts = {},
	superscripts = {},
	parenthesis = {},
	escapes = {},
	inlines = {},
	blocks = {},
	fonts = {}
};

-- [ LaTeX | LaTeX blocks ] ---------------------------------------------------------------

--- Configuration table for latex math blocks.
---@class latex.blocks
---
---@field enable boolean
---
---@field hl? string | fun(buffer: integer, item: __latex.blocks): string?
---@field pad_amount integer | fun(buffer: integer, item: __latex.blocks): integer
---@field pad_char string | fun(buffer: integer, item: __latex.blocks): string
---
---@field text string | fun(buffer: integer, item: __latex.blocks): string
---@field text_hl? string | fun(buffer: integer, item: __latex.blocks): string?
M.latex_blocks = {
	enable = true,

	hl = "MarkviewCode",
	pad_char = " ",
	pad_amount = 3,

	text = "Math"
};

-- [ LaTeX | LaTeX blocks • Static ] ------------------------------------------------------

--- Configuration table for latex math blocks.
---@class latex.blocks_static
---
---@field enable boolean Enables rendering of LaTeX blocks.
---
---@field hl? string Primary highlight group for the LaTeX block.
---@field pad_amount integer Number of `pad_char` to add before & after the text.
---@field pad_char string Character to use for padding.
---
---@field text string Text to show on the top left.
---@field text_hl? string Highlight group for the `text`.

-- [ LaTeX | LaTeX blocks > Parameters ] --------------------------------------------------

---@class __latex.blocks
---
---@field class "latex_block"
---@field marker string
---
---@field text string[]
---@field range node.range
M.__latex_blocks = {
	class = "latex_block",
	marker = "$$",

	closed = true,

	text = { "$$1 + 2 = 3$$" },
	range = {
		row_start = 0,
		row_end = 0,
		col_start = 0,
		col_end = 13
	}
};

-- [ LaTeX | LaTeX commands ] -------------------------------------------------------------

--- Configuration for LaTeX commands.
---@class latex.commands
---
---@field enable boolean
---@field [string] commands.opts | fun(buffer: integer, item: __latex.commands): commands.opts
M.latex_commands = {
	enable = true,
	sin = {
		condition = function (item)
			return #item.args == 2;
		end,
		on_command = function ()
			return { conceal = "" };
		end
	}
};

-- [ LaTeX | LaTeX commands • Static ] ----------------------------------------------------

--- Static configuration for LaTeX commands.
---@class latex.commands_static
---
---@field enable boolean Enables latex command preview.
---@field [string] commands.opts Configuration table for {string}.

-- [ LaTeX | LaTeX commands > Type definition ] --------------------------------------------

---@class commands.opts
---
---@field condition? fun(item: __latex.commands): boolean Condition used to determine if a command is valid.
---
---@field command_offset? fun(range: integer[]): integer[] Modifies the command's range(`{ row_start, col_start, row_end, col_end }`).
---@field on_command? config.extmark | fun(tag: table): config.extmark Extmark configuration to use on the command.
---@field on_args? commands.arg_opts[]? Configuration table for each argument.
M.latex_commands_opts = {
	on_command = function ()
		return { conceal = "" };
	end,
	command_offset = nil,
	on_args = {}
};

---@class commands.arg_opts
---
---@field after_offset? fun(range: integer[]): integer[] Modifies the range of the argument(only for `on_after`).
---@field before_offset? fun(range: integer[]): integer[] Modifies the range of the argument(only for `on_before`).
---@field condition? fun(item: table): boolean Can be used to change when the command preview is shown.
---@field content_offset? fun(range: integer[]): table Modifies the argument's range(only for `on_content`).
---@field on_after? config.extmark | fun(tag: table): config.extmark Extmark configuration to use at the end of the argument.
---@field on_before? config.extmark | fun(tag: table): config.extmark Extmark configuration to use at the start of the argument.
---@field on_content? config.extmark | fun(tag: table): config.extmark Extmark configuration to use on the argument.
M.latex_commands_arg_opts = {
	on_after = { virt_text = { { ")", "Comment" } }, virt_text_pos = "overlay" },
	on_before = { virt_text = { { ")", "Comment" } }, virt_text_pos = "overlay" }
};

-- [ LaTeX | LaTeX commands > Parameters ] ------------------------------------------------

--- LaTeX commands(must have at least 1 argument).
---@class __latex.commands
---
---@field class "latex_command"
---
---@field command { name: string, range: integer[] } Command name(without `\`) and it's range.
---@field args { text: string, range: integer[] }[] List of arguments(inside `{...}`) with their text & range.
---
---@field text string[]
---@field range node.range
M.__latex_commands = {
	class = "latex_command",

	command = {
		name = "frac",
		range = { 0, 0, 0, 5 }
	},
	args = {
		{
			text = "{1}",
			range = { 0, 5, 0, 8 }
		},
		{
			text = "{2}",
			range = { 0, 8, 0, 11 }
		}
	},
	text = { "\\frac{1}{2}" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 11
	}
};

-- [ LaTeX | LaTeX escapes ] --------------------------------------------------------------

--- Configuration table for latex escaped characters.
---@class latex.escapes
---
---@field enable boolean Enables escaped character preview.
---@field hl? string | fun(item: __latex.escapes): string? Highlight group for the escaped character.
M.latex_escapes = {
	enable = true,
	hl = "Operator"
};

-- [ LaTeX | LaTeX escapes • Static ] -----------------------------------------------------

--- Static configuration table for latex escaped characters.
---@class latex.escapes_static
---
---@field enable boolean Enables escaped character preview.
---@field hl? string | fun(item: __latex.escapes): string? Highlight group for the escaped character.

-- [ LaTeX | LaTeX escapes > Parameters ] -------------------------------------------------

--- Escaped characters.
---@class __latex.escapes
---
---@field class "latex_escaped"
---
---@field text string[]
---@field range node.range
M.__latex_escapes = {
	class = "latex_escaped",

	text = { "\\|" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 2
	}
};

-- [ LaTeX | LaTeX fonts ] ----------------------------------------------------------------

--- Configuration table for latex math fonts.
---@class latex.fonts
---
---@field enable boolean
---
---@field default fonts.opts | fun(buffer: integer, item: __latex.fonts): fonts.opts
---@field [string] fonts.opts | fun(buffer: integer, item: __latex.fonts): fonts.opts
M.latex_fonts = {
	enable = true,
	default = { hl = "Special" }
};

-- [ LaTeX | LaTeX fonts • Static ] -------------------------------------------------------

--- Static configuration table for latex math fonts.
---@class latex.fonts_static
---
---@field enable boolean
---
---@field default fonts.opts Default configuration for fonts
---@field [string] fonts.opts Configuration for `\string{}` font.

--- Configuration for a specific fonts.
---@class fonts.opts
---
---@field enable? boolean Whether to enable this font.
---@field hl? string | fun(buffer: integer, item: __latex.fonts): string? Highlight group for this font.
M.fonts_opts = {
	enable = true,
	hl = "Special"
};

-- [ LaTeX | LaTeX fonts > Parameters ] ----------------------------------------------------

--- Math fonts
---@class __latex.fonts
---
---@field class "latex_font"
---
---@field name string Font name.
---
---@field text string[]
---@field range node.range
M.__latex_fonts = {
	class = "latex_font",

	name = "mathtt",

	text = { "\\mathtt{abcd}" },
	range = {
		font = { 0, 0, 0, 7 },
		row_start = 0,
		row_end = 0,
		col_start = 0,
		col_end = 13
	}
};

-- [ LaTeX | Inline LaTeX ] ---------------------------------------------------------------

--- Configuration table for inline latex math.
---@class latex.inlines
---
---@field enable boolean Enables preview of inline latex maths.
---
---@field corner_left? string | fun(buffer: integer, item: __latex.inlines): string? Left corner.
---@field corner_left_hl? string | fun(buffer: integer, item: __latex.inlines): string? Highlight group for left corner.
---@field corner_right? string | fun(buffer: integer, item: __latex.inlines): string? Right corner.
---@field corner_right_hl? string | fun(buffer: integer, item: __latex.inlines): string? Highlight group for right corner.
---@field hl? string | fun(buffer: integer, item: __latex.inlines): string? Base Highlight group.
---@field padding_left? string | fun(buffer: integer, item: __latex.inlines): string? Left padding.
---@field padding_left_hl? string | fun(buffer: integer, item: __latex.inlines): string? Highlight group for left padding.
---@field padding_right? string | fun(buffer: integer, item: __latex.inlines): string? Right padding.
---@field padding_right_hl? string | fun(buffer: integer, item: __latex.inlines): string? Highlight group for right padding.
M.latex_inlines = {
	enable = true,

	corner_left = " ",
	corner_right = " ",

	hl = "MarkviewInlineCode"
};

-- [ LaTeX | Inline LaTeX • Static ] ------------------------------------------------------

--- Configuration table for inline latex math.
---@class latex.inlines_static
---
---@field enable boolean Enables preview of inline latex maths.
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

-- [ LaTeX | Inline LaTeX > Parameters ] --------------------------------------------------

--- Inline LaTeX(typically made using `$...$`).
---@class __latex.inlines
---
---@field class "latex_inlines"
---@field marker string
---
---@field closed boolean Is there a closing `$`?
---@field text string[]
---@field range node.range
M.__latex_inlines = {
	class = "latex_inlines",
	marker = "$",
	closed = true,

	text = { "$1 + 1 = 2$" },
	range = {
		row_start = 0,
		col_start = 0,

		row_end = 0,
		col_end = 11
	}
};

-- [ LaTeX | Parenthesis ] ----------------------------------------------------------------

--- Configuration table for {}.
---@alias latex.parenthesis { enable: boolean }

-- [ LaTeX | Parenthesis > Parameters ] ----------------------------------------------------------------

--- {} in LaTeX.
---@class __latex.parenthesis
---
---@field class "latex_parenthesis"
---@field text string[]
---@field range node.range
M.__latex_parenthesis = {
	class = "latex_parenthesis",
	text = { "{1+2}" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 5
	}
};

-- [ LaTeX | Subscripts ] ----------------------------------------------------------------

--- Configuration for subscripts.
---@class latex.subscripts
---
---@field enable boolean Enables preview of subscript text.
---@field hl? string | string[] Highlight group for the subscript text. Can be a list to use different hl for nested subscripts.
M.latex_subscripts = {
	enable = true,
	hl = "MarkviewSubscript"
};

-- [ LaTeX | Subscripts > Parameters ] -----------------------------------------------------

--- Subscript text(e.g. _h, _{hi}, _{+} etc.).
---@class __latex.subscripts
---
---@field class "latex_subscript"
---
---@field parenthesis boolean Is the text within `{...}`?
---@field level integer Level of the subscript text. Used for handling nested subscript text.
---@field preview boolean Can the text be previewed?
---
---@field text string[]
---@field range node.range
M.__latex_subscripts = {
	class = "latex_subscript",
	parenthesis = true,
	preview = true,
	level = 1,

	text = { "_{hi}" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 5
	}
};

-- [ LaTeX | Superscripts ] ---------------------------------------------------------------

--- Configuration for superscripts.
---@class latex.superscripts
---
---@field enable boolean Enables preview of superscript text.
---@field hl? string | string[] Highlight group for the superscript text. Can be a list to use different hl for nested superscripts.
M.latex_subscripts = {
	enable = true,
	hl = "MarkviewSuperscript"
};

-- [ LaTeX | Superscripts > Parameters ] --------------------------------------------------

--- Superscript text(e.g. ^h, ^{hi}, ^{+} etc.).
---@class __latex.superscripts
---
---@field class "latex_superscript"
---
---@field parenthesis boolean Is the text within `{...}`?
---@field level integer Level of the superscript text. Used for handling nested superscript text.
---@field preview boolean Can the text be previewed?
---
---@field text string[]
---@field range node.range
M.__latex_superscripts = {
	class = "latex_superscript",
	parenthesis = true,
	preview = true,
	level = 1,

	text = { "^{hi}" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 5
	}
};

-- [ LaTeX | Symbols ] --------------------------------------------------------------------

--- Configuration table for TeX math symbols.
---@class latex.symbols
---
---@field enable boolean
---@field hl? string | fun(buffer: integer, item: __latex.symbols): string?
M.latex_symbols = {
	enable = true,
	hl = "MarkviewSuperscript"
};

-- [ LaTeX | Symbols • Static ] -----------------------------------------------------------

--- Configuration table for TeX math symbols.
---@class latex.symbols_static
---
---@field enable boolean Enables preview of latex math symbols.
---@field hl? string Highlight group for the symbols.

-- [ LaTeX | Symbols > Parameters ] -------------------------------------------------------

--- Math symbols in LaTeX(e.g. \Alpha).
---@class __latex.symbols
---
---@field class "latex_symbols"
---@field name string Symbol name(without the `\`).
---@field style "superscripts" | "subscripts" | nil Text styles to apply(if possible).
---
---@field text string[]
---@field range node.range
M.__latex_symbols = {
	class = "latex_symbols",
	name = "pi",
	style = nil,

	text = { "\\pi" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 3
	}
};

-- [ LaTeX | Texts ] ----------------------------------------------------------------------

--- Configuration table for text.
---@alias latex.texts { enable: boolean }

-- [ LaTeX | Texts > Parameters ] ---------------------------------------------------------

--- `\text{}` nodes.
---@class __latex.text
---
---@field class "latex_text"
---@field text string[]
---@field range node.range
M.__latex_word = {
	class = "latex_text",
	text = { "word" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 5,
		col_end = 9
	}
};


-- [ LaTeX | Misc ] -----------------------------------------------------------------------

--- Groups of characters(without any spaces between them).
--- Used for applying fonts & text styles.
---@class __latex.word
---
---@field class "latex_word"
---
---@field text string[]
---@field range node.range
M.__latex_word = {
	class = "latex_word",
	text = { "word" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 5,
		col_end = 9
	}
};

return M;
