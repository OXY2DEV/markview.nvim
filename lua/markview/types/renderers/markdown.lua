---@meta

--- Configuration for markdown.
---@class markview.config.markdown
---
---@field enable boolean Enable **markdown** rendering.
---
---@field block_quotes markview.config.markdown.block_quotes Block quote configuration.
---@field code_blocks markview.config.markdown.code_blocks Fenced code block configuration.
---@field headings markview.config.markdown.headings Heading configuration.
---@field horizontal_rules markview.config.markdown.hr Horizontal rules configuration.
---@field list_items markview.config.markdown.list_items List items configuration.
---@field metadata_minus markview.config.markdown.metadata YAML metadata configuration.
---@field metadata_plus markview.config.markdown.metadata TOML metadata configuration.
---@field reference_definitions markview.config.markdown.ref_def Reference link definition configuration.
---@field tables markview.config.markdown.tables Table configuration.

------------------------------------------------------------------------------

--- Configuration for block quotes.
---@class markview.config.markdown.block_quotes
---
---@field enable boolean Enable rendering of block quotes.
---@field wrap? boolean Enables text wrap support.
---
---@field default markview.config.markdown.block_quotes.opts Default configuration.
---@field [string] markview.config.markdown.block_quotes.opts Configuration for `>[!string]` callout. Name is **case-insensitive**.


--- Static configuration options for various types of block quotes.
---@class markview.config.markdown.block_quotes.opts
---
---@field border? string | string[] Text for the border. Use an array to apply different border *per line*.
---@field border_hl? string | string[] Highlight group for the border. Use an array to apply different highlights *per line*.
---
---@field hl? string Base highlight group for the block quote.
---
---@field icon? string Icon to show before the block quote title.
---@field icon_hl? string Highlight group for the icon.
---
---@field preview? string Callout/Alert preview string(shown where `>[!string]` was).
---@field preview_hl? string Highlight group for the preview.
---
---@field title? boolean Should this callout allow titles(`>[!string] <Title>`)? Disabled by default.

------------------------------------------------------------------------------

--- Configuration for code blocks.
---@class markview.config.markdown.code_blocks
---
---@field enable boolean Enable rendering of code blocks.
---
---@field border_hl? string Highlight group for borders.
---@field info_hl? string Highlight group for the info string.
---
---@field label_direction? "left" | "right" Position of the language & icon.
---@field label_hl? string Highlight group for the label.
---
---@field min_width? integer Minimum width of the code block.
---@field pad_amount? integer Number of `pad_char`s to add on the left & right side of the code block.
---@field pad_char? string Character used as padding.
---
---@field sign? boolean Enables signs for the code block?
---@field sign_hl? string Highlight group for the sign.
---
---@field style
---| "simple" Only highlights the line. Enabled when `wrap` is enabled.
---| "block" Creates a block around the code block. Disabled when `wrap` is enabled.
---
---@field default markview.config.markdown.code_blocks.opts
---@field [string] markview.config.markdown.code_blocks.opts

--[[ Configuration for highlighting `lines` inside a code block. ]]
---@class markview.config.markdown.code_blocks.opts
---
---@field block_hl
---| string Highlight group for the background of the line.
---| fun(buffer: integer, line: string): string? Takes `line` & the `buffer` containing it and returns a highlight group for the line.
---@field pad_hl
---| string Highlight group for the padding of the line.
---| fun(buffer: integer, line: string): string? Takes `line` & the `buffer` containing it and returns a highlight group for the padding..

------------------------------------------------------------------------------

--- Configuration for ATX & Setext headings.
---@class markview.config.markdown.headings
---
---@field enable boolean Enable rendering of headings.
---
---@field heading_1 markview.config.markdown.headings.atx
---@field heading_2 markview.config.markdown.headings.atx
---@field heading_3 markview.config.markdown.headings.atx
---@field heading_4 markview.config.markdown.headings.atx
---@field heading_5 markview.config.markdown.headings.atx
---@field heading_6 markview.config.markdown.headings.atx
---
---@field setext_1 markview.config.markdown.headings.setext
---@field setext_2 markview.config.markdown.headings.setext
---
---@field shift_width integer Amount of spaces to add before the text for teach heading level.
---
---@field org_indent? boolean Enables `Org mode` like section indentation. Disabled by default.
---@field org_shift_width? integer Amount of `org_shift_char` to add per heading level.
---@field org_shift_char? string Character used for indenting/shifting the sections.
---
---@field org_indent_wrap? boolean Enable wrap support for sections. Enabled by default


---@alias markview.config.markdown.headings.atx
---| markview.config.markdown.headings.atx.simple
---| markview.config.markdown.headings.atx.label
---| markview.config.markdown.headings.atx.icon


---@class markview.config.markdown.headings.atx.simple
---
---@field style "simple" Heading style.
---@field hl? string Base Highlight group.


---@class markview.config.markdown.headings.atx.label
---
---@field style "label" Heading style.
---@field align? "left" | "center" | "right" Label alignment.
---
---@field corner_left? string Text for left corner.
---@field corner_left_hl? string Highlight group for left corner.
---
---@field corner_right? string Text for right corner.
---@field corner_right_hl? string Highlight group for right corner.
---
---@field hl? string Base Highlight group. Used by other `*_hl` options as default value.
---
---@field icon? string Text to use for the icon(use `%d` to add heading number).
---@field icon_hl? string Highlight group for icon.
---
---@field padding_left? string Text for left padding.
---@field padding_left_hl? string Highlight group for left padding.
---
---@field padding_right? string Text for right padding.
---@field padding_right_hl? string Highlight group for right padding.
---
---@field sign? string Text to show on the sign column.
---@field sign_hl? string Highlight group for the sign.


---@class markview.config.markdown.headings.atx.icon
---
---@field style "icon" Heading style.
---@field hl? string Base Highlight group. Used by other `*_hl` options as default value.
---
---@field icon? string Text to use for the icon(use `%d` to add heading number).
---@field icon_hl? string Highlight group for icon.
---
---@field sign? string Text to show on the sign column.
---@field sign_hl? string Highlight group for the sign.


---@alias markview.config.markdown.headings.setext
---| markview.config.markdown.headings.setext.simple
---| markview.config.markdown.headings.setext.decorated


---@class markview.config.markdown.headings.setext.simple
---
---@field style "simple" Preview style.
---@field hl? string Base highlight group.
---
---@field sign? string Text to show in the sign column.
---@field sign_hl? string Highlight group for the sign.


---@class markview.config.markdown.headings.setext.decorated
---
---@field style "decorated" Preview style.
---
---@field border string Text to use for the preview border.
---@field border_hl? string Highlight group for the border.
---
---@field hl? string Base highlight group.
---
---@field icon? string Text to use for the icon.
---@field icon_hl? string Highlight group for the icon.
---
---@field sign? string Text to show in the sign column.
---@field sign_hl? string Highlight group for the sign.

------------------------------------------------------------------------------

--- Configuration for horizontal rules.
---@class markview.config.markdown.hr
---
---@field enable boolean Enable preview of horizontal rules.
---@field parts markview.config.markdown.hr.part[] Parts for the horizontal rules.


---@alias markview.config.markdown.hr.part
---| markview.config.markdown.hr.text
---| markview.config.markdown.hr.repeating


---@class markview.config.markdown.hr.text
---
---@field type "text" Part name.
---
---@field hl? string Highlight group for this part.
---@field text string Text to show.


---@class markview.config.markdown.hr.repeating
---
---@field type "repeating" Part name.
---
---@field direction "left" | "right" Direction from which the highlight groups are applied from.
---
---@field repeat_amount integer | fun(buffer: integer, item: markview.parsed.markdown.hr): integer How many times to repeat the text.
---@field repeat_hl? boolean Whether to repeat the highlight groups.
---@field repeat_text? boolean Whether to repeat the text.
---
---@field text string | string[] Text to repeat.
---@field hl? string | string[] Highlight group for the text.

------------------------------------------------------------------------------

--- Configuration for list items.
---@class markview.config.markdown.list_items
---
---@field enable boolean
---
---@field indent_size integer | fun(buffer: integer, item: markview.parsed.markdown.list_items): integer Indentation size for list items.
---@field shift_width integer | fun(buffer: integer, item: markview.parsed.markdown.list_items): integer Virtual indentation size for previewed list items.
---
---@field marker_dot markview.config.markdown.list_items.ordered Configuration for `n.` list items.
---@field marker_minus markview.config.markdown.list_items.unordered Configuration for `-` list items.
---@field marker_parenthesis markview.config.markdown.list_items.ordered Configuration for `n)` list items.
---@field marker_plus markview.config.markdown.list_items.unordered Configuration for `+` list items.
---@field marker_star markview.config.markdown.list_items.unordered Configuration for `*` list items.
---
---@field wrap? boolean Enables wrap support.


---@class markview.config.markdown.list_items.unordered
---
---@field add_padding boolean
---@field conceal_on_checkboxes? boolean
---@field enable? boolean
---@field hl? string
---@field text string


---@class markview.config.markdown.list_items.ordered
---
---@field add_padding boolean
---@field conceal_on_checkboxes? boolean
---@field enable? boolean

------------------------------------------------------------------------------

--- Configuration for YAML/TOML metadata.
---@class markview.config.markdown.metadata
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

------------------------------------------------------------------------------

--- Configuration for reference definitions.
---@class markview.config.markdown.ref_def
---
---@field enable boolean
---
---@field default markview.config.__inline Default configuration for reference definitions.
---@field [string] markview.config.__inline Configuration for reference definitions whose description matches `string`.

------------------------------------------------------------------------------

--- Configuration for tables.
---@class markview.config.markdown.tables
---
---@field enable boolean
---@field strict boolean When `true`, leading & trailing whitespaces are not considered part of the cell.
---
---@field block_decorator boolean Whether to draw top & bottom border.
---@field use_virt_lines boolean Whether to use virtual lines for the borders.
---
---@field hl markview.config.markdown.tables.parts Highlight groups for the parts.
---@field parts markview.config.markdown.tables.parts Parts for the table.


--- Parts that make the previewed table.
---@class markview.config.markdown.tables.parts
---
---@field align_center [ string, string ]
---@field align_left string
---@field align_right string
---
---@field top string[]
---@field header string[]
---@field separator string[]
---@field row string[]
---@field bottom string[]
---
---@field overlap string[]

