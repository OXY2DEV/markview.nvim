---@meta

local M = {};

-- [ Markview | Inline ] ------------------------------------------------------------------

--- Configuration for inline markdown.
---@class config.markdown_inline
---
---@field enable boolean
---
---@field block_references inline.block_references | fun(): inline.block_references
---@field checkboxes inline.checkboxes | fun(): inline.checkboxes
---@field emails inline.emails | fun(): inline.emails
---@field embed_files inline.embed_files | fun(): inline.embed_files
---@field emoji_shorthands inline.emojis | fun(): inline.emojis
---@field entities inline.entities | fun(): inline.entities
---@field escapes inline.escapes | fun(): inline.escapes
---@field footnotes inline.footnotes | fun(): inline.footnotes
---@field highlights inline.highlights | fun(): inline.highlights
---@field hyperlinks inline.hyperlinks | fun(): inline.hyperlinks
---@field images inline.images | fun(): inline.images
---@field inline_codes inline.inline_codes | fun(): inline.inline_codes
---@field internal_links inline.internal_links | fun(): inline.internal_links
---@field uri_autolinks inline.uri_autolinks | fun(): inline.uri_autolinks
M.markdown_inline = {
	enable = true,

	block_references = {},
	checkboxes = {},
	emails = {},
	embed_files = {},
	emoji_shorthands = {},
	entities = {},
	escapes = {},
	footnotes = {},
	highlights = {},
	hyperlinks = {},
	images = {},
	inline_codes = {},
	internal_links = {},
	uri_autolinks = {},
};

-- [ Markview | Inline • Static ] ---------------------------------------------------------

--- Static configuration for inline markdown.
---@class config.markdown_inline_static
---
---@field enable boolean
---
---@field block_references inline.block_references Block reference link configuration.
---@field checkboxes inline.checkboxes Checkbox configuration.
---@field inline_codes inline.inline_codes Inline code/code span configuration.
---@field emails inline.emails Email link configuration.
---@field embed_files inline.embed_files Embed file link configuration.
---@field emoji_shorthands inline.emojis Github styled emoji shorthands.
---@field entities inline.entities HTML entities configuration.
---@field escapes inline.escapes Escaped characters configuration.
---@field footnotes inline.footnotes Footnotes configuration.
---@field highlights inline.highlights Highlighted text configuration.
---@field hyperlinks inline.hyperlinks Hyperlink configuration.
---@field images inline.images Image link configuration.
---@field internal_links inline.internal_links Internal link configuration.
---@field uri_autolinks inline.uri_autolinks URI autolink configuration.

-- [ Inline | Block references ] ----------------------------------------------------------

--- Configuration for block reference links.
---@class inline.block_references
---
---@field enable boolean
---
---@field default config.inline_generic | fun(buffer: integer, item: __inline.block_references): config.inline_generic
---@field [string] config.inline_generic | fun(buffer: integer, item: __inline.block_references): config.inline_generic
M.inline_block_ref = {
	enable = true,
	default = {},
	["^obs"] = {
		hl = "Special"
	}
};

-- [ Inline | Block references • Static ] -------------------------------------------------

--- Static configuration for block reference links.
---@class inline.block_references
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for block reference links.
---@field [string] config.inline_generic Configuration for block references whose label matches with the key's pattern.

-- [ Inline | Block references > Parameters ] ---------------------------------------------

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


-- [ Inline | Checkboxes ] ----------------------------------------------------------------

--- Configuration for checkboxes.
---@class inline.checkboxes
---
---@field enable boolean
---
---@field checked checkboxes.opts Configuration for [x] & [X].
---@field unchecked checkboxes.opts Configuration for [ ].
---
---@field [string] checkboxes.opts
M.inline_checkboxes = {
	enable = true,
	checked = {},
	unchecked = {},
	["-"] = {}
}

---@class checkboxes.opts
---
---@field text string
---@field hl? string
---@field scope_hl? string Highlight group for the list item.
M.checkboxes_opts = {
	text = "∆",
	hl = "MarkviewCheckboxChecked"
};

-- [ Inline | Checkboxes > Parameters ] ---------------------------------------------------

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

-- [ Inline | Emails ] --------------------------------------------------------------------

--- Configuration for emails.
---@class inline.emails
---
---@field enable boolean
---
---@field default config.inline_generic | fun(buffer: integer, item: __inline.emails): config.inline_generic
---@field [string] config.inline_generic | fun(buffer: integer, item: __inline.emails): config.inline_generic
M.inline_emails = {
	enable = true,
	default = {},
	["teams"] = {
		hl = "Special"
	}
};

-- [ Inline | Emails • Static ] -----------------------------------------------------------

--- Static configuration for emails.
---@class inline.emails
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for emails
---@field [string] config.inline_generic Configuration for emails whose label(address) matches `string`.

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

-- [ Inline | Embed files ] ---------------------------------------------------------------

--- Configuration for obsidian's embed files.
---@class inline.embed_files
---
---@field enable boolean
---
---@field default config.inline_generic | fun(buffer: integer, item: __inline.embed_files): inline.embed_files
---@field [string] config.inline_generic | fun(buffer: integer, item: __inline.embed_files): inline.embed_files
M.inline_embed_files = {
	enable = true,
	default = {},
	["img$"] = {
		hl = "Special"
	}
};

-- [ Inline | Embed files • Static ] ------------------------------------------------------

--- Static configuration for obsidian's embed files.
---@class inline.embed_files
---
---@field enable boolean
---
---@field default config.inline_generic_static Default configuration for embed file links.
---@field [string] config.inline_generic_static Configuration for embed file links whose label matches `string`.

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

-- [ Inline | Emojis ] ------------------------------------------------------------------

--- Configuration for emoji shorthands.
---@class inline.emojis
---
---@field enable boolean
---
---@field hl? string | fun(buffer: integer, item: __inline.entities): inline.emojis
M.inline_emojis = {
	enable = true,
	hl = "Comment"
};

-- [ Inline | Emojis • Static ] ---------------------------------------------------------

--- Static configuration for emoji shorthands.
---@class inline.emojis_static
---
---@field enable boolean
---
---@field hl? string Highlight group for the emoji.

-- [ Inline | Emojis > Parameters ] --------------------------------------------------------

---@class __inline.emojis
---
---@field class "inline_emoji"
---
---@field name string Emoji name(without `:`).
---
---@field text string[]
---@field range node.range
M.__inline_emojis = {
	class = "inline_emoji",
	name = "label",
	text = { ":label:" },
	range = {
		row_start = 0,
		row_end = 0,

		col_start = 0,
		col_end = 7
	}
};

-- [ Inline | Entities ] ------------------------------------------------------------------

--- Configuration for HTML entities.
---@class inline.entities
---
---@field enable boolean
---
---@field hl? string | fun(buffer: integer, item: __inline.entities): inline.entities
M.inline_entities = {
	enable = true,
	hl = "Comment"
};

-- [ Inline | Entities • Static ] ---------------------------------------------------------

--- Static configuration for HTML entities.
---@class inline.entities_static
---
---@field enable boolean
---
---@field hl? string Highlight group for the symbol.

-- [ Inline | Entities > Parameters ] ------------------------------------------------------

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

-- [ Inline | Escapes ] -------------------------------------------------------------------

--- Configuration for escaped characters.
---@alias inline.escapes { enable: boolean }

-- [ Inline | Escapes > Parameters ] ------------------------------------------------------

---@class __inline.escapes
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

-- [ Inline | Footnotes ] -----------------------------------------------------------------

--- Configuration for footnotes.
---@class inline.footnotes
---
---@field enable boolean
---
---@field default config.inline_generic | fun(buffer: integer, item: __inline.footnotes): inline.footnotes
---@field [string] config.inline_generic | fun(buffer: integer, item: __inline.footnotes): inline.footnotes
M.inline_footnotes = {
	enable = true,

	default = {},

	["^from"] = {
		match_string = "^from",
		hl = "Special"
	}
};

-- [ Inline | Footnotes • Static ] --------------------------------------------------------

--- Static configuration for footnotes.
---@class inline.footnotes_static
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for footnotes.
---@field [string] config.inline_generic Configuration for footnotes whose label matches `string`.

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

-- [ Inline | Highlights ] ----------------------------------------------------------------

--- Configuration for highlighted texts.
---@class inline.highlights
---
---@field enable boolean
---
---@field default config.inline_generic | fun(buffer: integer, item: __inline.highlights): inline.highlights
---@field [string] config.inline_generic | fun(buffer: integer, item: __inline.highlights): inline.highlights
M.inline_highlights = {
	enable = true,

	default = {},

	["^!"] = {
		hl = "Special"
	}
};

-- [ Inline | Highlights • Static ] -------------------------------------------------------

--- Static configuration for highlighted texts.
---@class inline.highlights
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for highlighted text.
---@field [string] config.inline_generic Configuration for highlighted text that matches `string`.

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

-- [ Inline | Hyperlinks ] ----------------------------------------------------------------

--- Configuration for hyperlinks.
---@class inline.hyperlinks
---
---@field enable boolean
---
---@field default config.inline_generic | fun(buffer: integer, item: __inline.hyperlinks): inline.hyperlinks
---@field [string] config.inline_generic | fun(buffer: integer, item: __inline.hyperlinks): inline.hyperlinks
M.inline_hyperlinks = {
	enable = true,
	default = {},
	["^neovim%.org"] = {
		hl = "Special"
	}
};

-- [ Inline | Hyperlinks • Static ] -------------------------------------------------------

--- Static configuration for hyperlinks.
---@class inline.hyperlinks_static
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for hyperlinks.
---@field [string] config.inline_generic Configuration for links whose description matches `string`.

-- [ Inline | Hyperlinks > Parameters ] ---------------------------------------------------

---@class __inline.hyperlinks
---
---@field class "inline_link_hyperlink"
---
---@field label? string
---@field description? string
---
---@field text string[]
---@field range inline_link.range
M.__inline_hyperlinks = {
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

-- [ Inline | Images ] --------------------------------------------------------------------

--- Configuration for image links.
---@class inline.images
---
---@field enable boolean
---
---@field default config.inline_generic | fun(vuffer: integer, item: __inline.images): inline.images
---@field [string] config.inline_generic | fun(vuffer: integer, item: __inline.images): inline.images
M.inline_images = {
	enable = true,
	default = {},
	["svg$"] = {
		hl = "Special"
	}
};

-- [ Inline | Images • Static ] -----------------------------------------------------------

--- Static configuration for image links.
---@class inline.images_static
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for image links
---@field [string] config.inline_generic Configuration image links whose description matches `string`.

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


-- [ Inline | Inline codes ] --------------------------------------------------------------

--- Configuration for inline codes.
---@alias inline.inline_codes config.inline_generic

-- [ Inline | Inline codes • Static ] -----------------------------------------------------

--- Static configuration for inline codes.
---@alias inline.inline_codes_static config.inline_generic_static

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

-- [ Inline | Internal links ] ------------------------------------------------------------

--- Configuration for obsidian's internal links.
---@class inline.internal_links
---
---@field enable boolean
---
---@field default config.inline_generic | fun(buffer: integer, item: __inline.internal_links): config.inline_generic
---@field [string] config.inline_generic | fun(buffer: integer, item: __inline.internal_links): config.inline_generic
M.inline_internal_links = {
	enable = true,
	default = {},
	["^vault"] = {
		match_string = "^vault",
		hl = "Special"
	}
};

-- [ Inline | Internal links • Static ] ---------------------------------------------------

--- Configuration for obsidian's internal links.
---@class inline.internal_links_static
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for internal links.
---@field [string] config.inline_generic Configuration for internal links whose label match `string`.

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

-- [ Inline | URI autolinks ] ------------------------------------------------------------

--- Configuration for uri autolinks.
---@class inline.uri_autolinks
---
---@field enable boolean
---
---@field default config.inline_generic | fun(buffer: integer, item: __inline.uri_autolinks): config.inline_generic
---@field [string] config.inline_generic | fun(buffer: integer, item: __inline.uri_autolinks): config.inline_generic
M.inline_uri_autolinks = {
	enable = true,
	default = {},
	["^https"] = {
		match_string = "^https",
		hl = "Special"
	}
};

-- [ Inline | URI autolinks • Static ] ---------------------------------------------------

--- Static configuration for uri autolinks.
---@class inline.uri_autolinks_static
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for URI autolinks.
---@field [string] config.inline_generic Configuration for URI autolinks whose label match `string`.

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

return M;
