---@meta

-- [ Markview | Typst ] -------------------------------------------------------------------

--- Configuration for Typst.
---@class config.typst
---
---@field enable boolean
---
---@field code_blocks markview.config.typst.code_blocks Configuration for block of typst code.
---@field code_spans markview.config.typst.code_spans Configuration for inline typst code.
---@field escapes markview.config.typst.escapes Configuration for escaped characters.
---@field headings markview.config.typst.headings Configuration for headings.
---@field labels markview.config.typst.labels Configuration for labels.
---@field list_items markview.config.typst.list_items Configuration for list items
---@field math_blocks markview.config.typst.math_blocks Configuration for blocks of math code.
---@field math_spans markview.config.typst.math_spans Configuration for inline math code.
---@field raw_blocks typst.raw_blocks Configuration for raw blocks.
---@field raw_spans typst.raw_spans Configuration for raw spans.
---@field reference_links typst.reference_links Configuration for reference links.
---@field subscripts typst.subscripts Configuration for subscript texts.
---@field superscripts typst.subscripts Configuration for superscript texts.
---@field symbols typst.symbols Configuration for typst symbols.
---@field terms typst.terms Configuration for terms.
---@field url_links typst.url_links Configuration for URL links.

------------------------------------------------------------------------------

--- Configuration for code blocks.
---@class markview.config.typst.code_blocks
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

---@class __typst.code_block
---@field class "typst_code_block"
---@field text string[]
---@field range node.range

------------------------------------------------------------------------------

--- Configuration for code spans.
---@class markview.config.typst.code_spans
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

---@class __typst.code_spans
---@field class "typst_code_span"
---@field text string[]
---@field range node.range

------------------------------------------------------------------------------

---@alias markview.config.typst.escapes { enable: boolean }

---@class __typst.escapes
---
---@field class "typst_escaped"
---@field text string[]
---@field range node.range

------------------------------------------------------------------------------

--- Configuration for Typst headings.
---@class markview.config.typst.headings
---
---@field enable boolean
---
---@field shift_width integer Amount of spaces to shift per heading level.
---@field [string] headings.typst Heading level configuration(name format: "heading_%d", %d = heading level).

--- Heading level configuration.
---@class headings.typst
---
---@field hl? string
---@field icon? string
---@field icon_hl? string
---@field sign? string
---@field sign_hl? string
---@field style "simple" | "icon"

---@class __typst.headings
---
---@field class "typst_heading"
---
---@field level integer Heading level.
---
---@field text string[]
---@field range node.range

------------------------------------------------------------------------------

--- Configuration for typst labels.
---@class markview.config.typst.labels
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for labels.
---@field [string] config.inline_generic Configuration for labels whose text matches `string`.

---@class __typst.labels
---
---@field class "typst_labels"
---
---@field text string[]
---@field range node.range

------------------------------------------------------------------------------

--- Configuration for list items.
---@class markview.config.typst.list_items
---
---@field enable boolean
---
---@field indent_size integer Indentation size for list items.
---@field shift_width integer Preview indentation size for list items.
---
---@field marker_dot list_items.ordered Configuration for `n.` list items.
---@field marker_minus markview.config.typst.list_items.typst Configuration for `-` list items.
---@field marker_plus markview.config.typst.list_items.typst Configuration for `+` list items.

---@class markview.config.typst.list_items.typst
---
---@field enable? boolean
---
---@field add_padding boolean
---@field hl? string
---@field text string

---@class __typst.list_items
---
---@field class "typst_list_item"
---@field indent integer
---@field marker "+" | "-" | string
---@field number? integer Number to show on the list item when previewing.
---@field text string[]
---@field range node.range

------------------------------------------------------------------------------

--- Configuration for math blocks.
---@class markview.config.typst.math_blocks
---
---@field enable boolean
---
---@field hl? string
---@field pad_amount integer Number of `pad_char` to add before the lines.
---@field pad_char string Text used as padding.
---@field text string
---@field text_hl? string

------------------------------------------------------------------------------

---@alias markview.config.typst.math_spans config.inline_generic

---@class __typst.maths
---
---@field class "typst_math"
---
---@field inline boolean Should we render it inline?
---@field closed boolean Is the node closed(ends with `$$`)?
---
---@field text string[]
---@field range node.range

------------------------------------------------------------------------------

---@class typst.raw_blocks
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

---@class __typst.raw_blocks
---
---@field class "typst_raw_block"
---@field language? string
---@field text string[]
---@field range node.range

------------------------------------------------------------------------------

---@alias typst.raw_spans config.inline_generic

---@class __typst.raw_spans
---
---@field class "typst_raw_span"
---
---@field text string[]
---@field range node.range

------------------------------------------------------------------------------

---@class typst.reference_links
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for reference links.
---@field [string] config.inline_generic Configuration for reference links whose label matches `string`.

---@class __typst.reference_links
---
---@field class "typst_link_ref"
---
---@field label string
---
---@field text string[]
---@field range inline_link.range

------------------------------------------------------------------------------

--- Configuration for subscript text.
---@class typst.subscripts
---
---@field enable boolean
---@field fake_preview? boolean When `true`, fake subscript characters.
---
---@field hl? string | string[]
---@field marker_left? string
---@field marker_right? string

---@class __typst.subscripts
---
---@field class "typst_subscript"
---@field parenthesis boolean Whether the text is surrounded by parenthesis.
---@field level integer Subscript level.
---@field text string[]
---@field range node.range

------------------------------------------------------------------------------

--- Configuration for superscript text.
---@class typst.superscripts
---
---@field enable boolean
---@field fake_preview? boolean When `true`, fake superscript characters.
---
---@field hl? string | string[]
---@field marker_left? string
---@field marker_right? string

---@class __typst.superscripts
---
---@field class "typst_superscript"
---@field parenthesis boolean Whether the text is surrounded by parenthesis.
---@field level integer Superscript level.
---@field text string[]
---@field range node.range

------------------------------------------------------------------------------

--- Configuration for symbols in typst.
---@class typst.symbols
---
---@field enable boolean
---@field hl? string

---@class __typst.symbols
---
---@field class "typst_symbol"
---@field name string
---@field text string[]
---@field range node.range

---@class typst.fonts
---
---@field enable boolean
---@field hl? string

------------------------------------------------------------------------------

---@class typst.terms
---
---@field enable boolean
---
---@field default term.opts Default configuration for terms.
---@field [string] term.opts Configuration for terms whose label matches `string`.

---@class term.opts
---
---@field text string
---@field hl? string

---@class __typst.terms
---
---@field class "typst_term"
---
---@field label string
---
---@field text string[]
---@field range inline_link.range

------------------------------------------------------------------------------

--- Configuration for URL links.
---@class typst.url_links
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for URL links.
---@field [string] config.inline_generic Configuration for URL links whose label matches `string`.

-- [ Typst | URL links > Parameters ] -----------------------------------------------------

---@class __typst.url_links
---
---@field class "typst_link_url"
---@field label string
---@field text string[]
---@field range inline_link.range

-- [ Typst | Misc ] -----------------------------------------------------------------------

---@class __typst.emphasis
---
---@field class "typst_emphasis"
---@field text string[]
---@field range node.range

---@class __typst.strong
---
---@field class "typst_strong"
---@field text string[]
---@field range node.range

---@class __typst.text
---
---@field class "typst_text"
---@field text string[]
---@field range node.range
