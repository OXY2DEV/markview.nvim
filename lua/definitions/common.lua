---@meta

--- Commonly used stuff.
local M = {};

-- [ Nvim | Highlight groups ] ------------------------------------------------------------

--- Highlight group for Neovim.
---@class config.hl
---
---@field fg? string | integer
---@field bg? string | integer
---@field sp? string | integer
---@field blend? integer
---@field bold? boolean
---@field standout? boolean
---@field underline? boolean
---@field undercurl? boolean
---@field underdouble? boolean
---@field underdotted? boolean
---@field underdashed? boolean
---@field strikethrough? boolean
---@field italic? boolean
---@field reverse? boolean
---@field nocombine? boolean
---@field link? string
---@field default? boolean
---@field ctermfg? string | integer
---@field ctermbg? string | integer
---@field cterm? table
---@field force? boolean
M.hl = {
	fg = "#1e1e2e",
	bg = "#cdd6f4"
};

-- [ Nvim | Extmarks ] --------------------------------------------------------------------

---@class config.extmark
---
---@field id? integer
---@field end_row? integer
---@field end_col? integer
---@field hl_group? string
---@field hl_eol? boolean
---@field virt_text? [ string, string? ][]
---@field virt_text_pos? "inline" | "right_align" | "overlay" | "eol"
---@field virt_text_win_col? integer
---@field virt_text_hide? boolean
---@field virt_text_repeat_linebreak? boolean
---@field hl_mode? "replace" | "combine" | "blend"
---@field virt_lines? [ string, string? ][][]
---@field virt_lines_above? boolean
---@field ephemeral? boolean
---@field right_gravity? boolean
---@field end_right_gravity? boolean
---@field undo_restore? boolean
---@field invalidate? boolean
---@field priority? integer
---@field strict? boolean
---@field sign_text? string
---@field sign_hl_group? string
---@field number_hl_group? string
---@field line_hl_group? string
---@field cursorline_hl_group? string
---@field conceal? string
---@field spell? boolean
---@field ui_watched? boolean
---@field url? string
---@field scoped? boolean
M.extmark = {
	spell = false,
	end_col = 10,
	virt_text = {
		{ "Hi", "Special" }
	}
};

-- [ Markview | Generic inline element ] --------------------------------------------------

--- Generic configuration for inline markdown items.
--- Note: {item} will be different based on the node this is being used by.
---@class config.inline_generic
---
---@field corner_left? string | fun(buffer: integer, item: table): string?
---@field corner_left_hl? string | fun(buffer: integer, item: table): string?
---@field corner_right? string | fun(buffer: integer, item: table): string?
---@field corner_right_hl? string | fun(buffer: integer, item: table): string?
---@field hl? string | fun(buffer: integer, item: table): string?
---@field icon? string | fun(buffer: integer, item: table): string?
---@field icon_hl? string | fun(buffer: integer, item: table): string?
---@field padding_left? string | fun(buffer: integer, item: table): string?
---@field padding_left_hl? string | fun(buffer: integer, item: table): string?
---@field padding_right? string | fun(buffer: integer, item: table): string?
---@field padding_right_hl? string | fun(buffer: integer, item: table): string?
---
---@field file_hl? string | fun(buffer: integer, item: table): string?
---@field block_hl? string | fun(buffer: integer, item: table): string?
M.inline_generic = {
	corner_left = "<",
	padding_left = " ",
	icon = "π ",
	padding_right = " ",
	corner_right = ">",

	hl = "MarkviewCode"
};

-- [ Markview | Generic inline element • Static ] -----------------------------------------

--- Static configuration for inline elements.
---@class config.inline_generic_static
---
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
---
---@field file_hl? string Highlight group for block reference file name.
---@field block_hl? string Highlight group for block reference block ID.

--- Ranges of a tree-sitter node.
---@class node.range
---
---@field row_start integer
---@field row_end integer
---
---@field col_start integer
---@field col_end integer
---
---@field font? integer[]
M.range = {
	col_end = 1,
	row_end = 1,
	col_start = 0,
	row_start = 0
};

-- [ HTML | Tag properties ] --------------------------------------------------------------

--- Table containing an HTML tag's yaml_property
---@class tag.properties
---
---@field text string
---@field range integer[]
M.tag_properties = {
	text = "<p>hi</p>",
	range = { 0, 0, 0, 9 }
};

-- [ Inline | Link range ] ----------------------------------------------------------------

--- Common structure for various link's range.
---@class inline_link.range
---
---@field row_start integer
---@field row_end integer
---@field col_start integer
---@field col_end integer
---
---@field label? integer[] Visible part of the link.
---@field description? integer[] The address/definition/destination of the link.
---
---@field alias? integer[] Internal link/Embed file link's alias.
---@field file? integer[] Block reference links file name.
---@field block? integer[] Block reference links block name(including `#^`).
M.inline_link_range = {
	col_end = 1,
	row_end = 1,
	col_start = 0,
	row_start = 0
};

--- [ Markview | Internal ] ---------------------------------------------------------------

M.states = {
	enable = true,

	buffer_states = {
		[10] = {
			enable = true,
			hybrid_mode = true
		}
	},
	attached_buffers = { 10 },

	splitview_buffer = 50,
	splitview_source = nil,
	splitview_window = nil
};

--- Table containing completion candidates for `:Markview`.
---@class mkv.cmd_completion
---
---@field default fun(str: string): string[] | nil Default completion.
---@field [string] fun(args: any[], cmd: string): string[] | nil Completion for the {string} sub-command.
M.cmd_completion = {
	default = function (str)
		vim.print(str);
		return { "enable", "disable" };
	end,

	enable = function (args, cmd)
		vim.print(cmd);
		return #args >= 2 and { "1", "2" } or nil;
	end
};


---@class config.renderer


 ------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------

--- Cached data. Used for applying text styles & fonts.
--- Also used for filtering nodes.
---@class __latex.cache
---
---@field font_regions { name: string, row_start: integer, row_end: integer, col_start: integer, col_end: integer }
---@field style_regions { superscripts: node.range[], subscripts: node.range[] }
M.__latex_cache = {
	font_regions = {
		{
			name = "mathtt",
			row_start = 0,
			row_end = 0,

			col_start = 0,
			col_end = 5
		}
	},
	style_regions = {
		subscripts = {
			{
				row_start = 1,
				row_end = 1,

				col_start = 0,
				col_end = 6
			}
		},
		superscripts = {}
	}
};
return M;
