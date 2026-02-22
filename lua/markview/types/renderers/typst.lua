---@meta

------------------------------------------------------------------------------

--- Configuration for Typst.
---@class markview.config.typst
---
---@field enable boolean Enable **Typst** rendering.
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
---@field enable boolean Enable rendering of code blocks.
---
---@field hl? string Highlight group.
---@field min_width integer Minimum width of code blocks.
---@field pad_amount integer Number of paddings added around the text.
---@field pad_char? string Character to use for padding.
---@field sign? string Sign for the code block.
---@field sign_hl? string Highlight group for the sign.
---@field style
---| "simple" Only highlights the lines inside this block. This will be used if a `wrap` is enabled or if `tab` is used in the text.
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
---@field enable boolean Enable rendering of code spans.
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

---@class markview.config.typst.escapes
---
---@field enable boolean Enable rendering of escaped characters.

------------------------------------------------------------------------------

--- Configuration for Typst headings.
---@class markview.config.typst.headings
---
---@field enable boolean Enable rendering of Headings.
---
---@field shift_width integer Amount of spaces to shift per heading level.
---@field [string] headings.typst Heading level configuration(name format: "heading_%d", %d = heading level).


--- Configuration options for each typst heading level.
---@class headings.typst
---
---@field hl? string Highlight group.
---@field icon? string
---@field icon_hl? string
---@field sign? string
---@field sign_hl? string
---@field style "simple" | "icon"

------------------------------------------------------------------------------

--- Configuration for typst labels.
---@class markview.config.typst.labels
---
---@field enable boolean Enable rendering of labels.
---
---@field default markview.config.typst.labels.opts Default configuration for labels.
---@field [string] markview.config.typst.labels.opts Configuration for labels whose text matches `string`.


--- Configuration for each label type.
---@alias markview.config.typst.labels.opts markview.config.__inline

------------------------------------------------------------------------------

--- Configuration for list items.
---@class markview.config.typst.list_items
---
---@field enable boolean Enable rendering of list items.
---
---@field indent_size integer | fun(buffer: integer, item: markview.parsed.typst.list_items): integer Indentation size for list items.
---@field shift_width integer | fun(buffer: integer, item: markview.parsed.typst.list_items): integer Preview indentation size for list items.
---
---@field marker_dot markview.config.typst.list_items.typst Configuration for `n.` list items.
---@field marker_minus markview.config.typst.list_items.typst Configuration for `-` list items.
---@field marker_plus markview.config.typst.list_items.typst Configuration for `+` list items.


---@class markview.config.typst.list_items.typst
---
---@field enable? boolean Enable rendering of this list item type.
---
---@field add_padding boolean
---@field hl? string Highlight group.
---@field text string

------------------------------------------------------------------------------

--- Configuration for math blocks.
---@class markview.config.typst.math_blocks
---
---@field enable boolean Enable rendering of math blocks.
---
---@field hl? string Highlight group.
---@field pad_amount integer Number of `pad_char` to add before the lines.
---@field pad_char string Text used as padding.
---@field text string
---@field text_hl? string

------------------------------------------------------------------------------

-- Configuration for inline maths.
---@alias markview.config.typst.math_spans markview.config.__inline

------------------------------------------------------------------------------

---@class markview.config.typst.raw_blocks
---
---@field enable boolean Enable rendering of raw blocks.
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

-- Configuration for raw spans.
---@alias markview.config.typst.raw_spans markview.config.__inline

------------------------------------------------------------------------------

--- Configuration for reference links.
---@class markview.config.typst.reference_links
---
---@field enable boolean Enable rendering of reference links.
---
---@field default markview.config.typst.reference_links.opts Default configuration for reference links.
---@field [string] markview.config.typst.reference_links.opts Configuration for reference links whose label matches `string`.


--- Configuration for a specific reference link type.
---@alias markview.config.typst.reference_links.opts markview.config.__inline

------------------------------------------------------------------------------

--- Configuration for subscript text.
---@class markview.config.typst.subscripts
---
---@field enable boolean Enable rendering of subscript text.
---@field fake_preview? boolean Use Unicode characters to mimic subscript text.
---
---@field hl? string | string[] Highlight group. Use a list to change nested subscript text color.
---@field marker_left? string
---@field marker_right? string

------------------------------------------------------------------------------

--- Configuration for superscript text.
---@class markview.config.typst.superscripts
---
---@field enable boolean Enable rendering of superscript text.
---@field fake_preview? boolean Use Unicode characters to mimic superscript text.
---
---@field hl? string | string[] Highlight group. Use a list to change nested subscript text color.
---@field marker_left? string
---@field marker_right? string

------------------------------------------------------------------------------

--- Configuration for symbols in typst.
---@class markview.config.typst.symbols
---
---@field enable boolean Enable rendering of math symbols.
---@field hl? string Highlight group.

------------------------------------------------------------------------------

--- Configuration for math fonts in typst.
---@class markview.config.typst.fonts
---
---@field enable boolean Enable rendering of math fonts.
---@field hl? string Highlight group.

------------------------------------------------------------------------------

--- Configuration for terms.
---@class markview.config.typst.terms
---
---@field enable boolean Enable rendering of terms.
---
---@field default markview.config.typst.terms.opts Default configuration for terms.
---@field [string] markview.config.typst.terms.opts Configuration for terms whose label matches `string`.


--- Configuration for a specific term type.
---@class markview.config.typst.terms.opts
---
---@field text string
---@field hl? string Highlight group.

------------------------------------------------------------------------------

--- Configuration for URL links.
---@class markview.config.typst.url_links
---
---@field enable boolean Enable rendering of URL links.
---
---@field default markview.config.typst.url_links.opts Default configuration for URL links.
---@field [string] markview.config.typst.url_links.opts Configuration for URL links whose label matches `string`.


--- Configuration for a specific URL type.
---@alias markview.config.typst.url_links.opts markview.config.__inline

