---@meta

------------------------------------------------------------------------------

--- Configuration for Typst.
---@class markview.config.typst
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
---@field raw_blocks markview.config.typst.raw_blocks Configuration for raw blocks.
---@field raw_spans markview.config.typst.raw_spans Configuration for raw spans.
---@field reference_links markview.config.typst.reference_links Configuration for reference links.
---@field subscripts markview.config.typst.subscripts Configuration for subscript texts.
---@field superscripts markview.config.typst.subscripts Configuration for superscript texts.
---@field symbols markview.config.typst.symbols Configuration for typst symbols.
---@field terms markview.config.typst.terms Configuration for terms.
---@field url_links markview.config.typst.url_links Configuration for URL links.

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

------------------------------------------------------------------------------

---@alias markview.config.typst.escapes { enable: boolean }

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

------------------------------------------------------------------------------

--- Configuration for typst labels.
---@class markview.config.typst.labels
---
---@field enable boolean
---
---@field default markview.config.__inline Default configuration for labels.
---@field [string] markview.config.__inline Configuration for labels whose text matches `string`.

------------------------------------------------------------------------------

--- Configuration for list items.
---@class markview.config.typst.list_items
---
---@field enable boolean
---
---@field indent_size integer | fun(buffer: integer, item: markview.parsed.typst.list_items): integer Indentation size for list items.
---@field shift_width integer | fun(buffer: integer, item: markview.parsed.typst.list_items): integer Preview indentation size for list items.
---
---@field marker_dot markview.config.typst.list_items.typst Configuration for `n.` list items.
---@field marker_minus markview.config.typst.list_items.typst Configuration for `-` list items.
---@field marker_plus markview.config.typst.list_items.typst Configuration for `+` list items.


---@class markview.config.typst.list_items.typst
---
---@field enable? boolean
---
---@field add_padding boolean
---@field hl? string
---@field text string

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

---@alias markview.config.typst.math_spans markview.config.__inline

------------------------------------------------------------------------------

---@class markview.config.typst.raw_blocks
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
---@field default markview.config.typst.raw_blocks.opts Default line configuration for the raw block.
---@field [string] markview.config.typst.raw_blocks.opts Line configuration for the raw block whose `language` matches `string`


--- Configuration for highlighting a line inside a raw block.
---@class markview.config.typst.raw_blocks.opts
---
---@field block_hl string | fun(buffer: integer, line: string): string? Highlight group for the background of the line.
---@field pad_hl string | fun(buffer: integer, line: string): string? Highlight group for the padding of the line.

------------------------------------------------------------------------------

---@alias markview.config.typst.raw_spans markview.config.__inline

------------------------------------------------------------------------------

---@class markview.config.typst.reference_links
---
---@field enable boolean
---
---@field default markview.config.__inline Default configuration for reference links.
---@field [string] markview.config.__inline Configuration for reference links whose label matches `string`.

------------------------------------------------------------------------------

--- Configuration for subscript text.
---@class markview.config.typst.subscripts
---
---@field enable boolean
---@field fake_preview? boolean When `true`, fake subscript characters.
---
---@field hl? string | string[]
---@field marker_left? string
---@field marker_right? string

------------------------------------------------------------------------------

--- Configuration for superscript text.
---@class markview.config.typst.superscripts
---
---@field enable boolean
---@field fake_preview? boolean When `true`, fake superscript characters.
---
---@field hl? string | string[]
---@field marker_left? string
---@field marker_right? string

------------------------------------------------------------------------------

--- Configuration for symbols in typst.
---@class markview.config.typst.symbols
---
---@field enable boolean
---@field hl? string

------------------------------------------------------------------------------

---@class markview.config.typst.fonts
---
---@field enable boolean
---@field hl? string

------------------------------------------------------------------------------

---@class markview.config.typst.terms
---
---@field enable boolean
---
---@field default markview.config.typst.terms.opts Default configuration for terms.
---@field [string] markview.config.typst.terms.opts Configuration for terms whose label matches `string`.


---@class markview.config.typst.terms.opts
---
---@field text string
---@field hl? string

------------------------------------------------------------------------------

--- Configuration for URL links.
---@class markview.config.typst.url_links
---
---@field enable boolean
---
---@field default markview.config.__inline Default configuration for URL links.
---@field [string] markview.config.__inline Configuration for URL links whose label matches `string`.

