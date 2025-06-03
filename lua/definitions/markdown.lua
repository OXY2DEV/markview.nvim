---@meta

--- Configuration for markdown.
---@class markview.config.markdown
---
---@field enable boolean
---
---@field block_quotes markview.config.markdown.block_quotes Block quote configuration.
---@field code_blocks markview.config.markdown.code_blocks Fenced code block configuration.
---@field headings markdown.headings Heading configuration.
---@field horizontal_rules markdown.horizontal_rules Horizontal rules configuration.
---@field list_items markdown.list_items List items configuration.
---@field metadata_minus markdown.metadata_minus YAML metadata configuration.
---@field metadata_plus markdown.metadata_plus TOML metadata configuration.
---@field reference_definitions markdown.reference_definitions Reference link definition configuration.
---@field tables markdown.tables Table configuration.

------------------------------------------------------------------------------

--- Configuration for block quotes.
---@class markview.config.markdown.block_quotes
---
---@field enable boolean
---@field wrap? boolean Enables text wrap support.
---
---@field default markview.config.markdown.block_quotes.opts
---@field [string] markview.config.markdown.block_quotes.opts


--- Static configuration options for various types of block quotes.
---@class markview.config.markdown.block_quotes.opts
---
---@field border string | string[] Text for the border.
---@field border_hl? string | string[] Highlight group for the border.
---@field hl? string Base highlight group for the block quote.
---@field icon? string Icon to show before the block quote title.
---@field icon_hl? string Highlight group for the icon.
---@field preview? string Callout/Alert preview string(shown where >[!{string}] was).
---@field preview_hl? string Highlight group for the preview.
---@field title? boolean Whether the block quote can have a title or not.

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

------------------------------------------------------------------------------

--- Configuration for code blocks.
---@class markview.config.markdown.code_blocks
---
---@field enable boolean
---
---@field border_hl? string
---@field info_hl? string
---@field label_direction? "left" | "right"
---@field label_hl? string
---@field min_width? integer
---@field pad_amount? integer
---@field pad_char? string
---@field sign? boolean
---@field sign_hl? string
---@field style "simple" | "block"
---
---@field default markview.config.markdown.code_blocks.opts
---@field [string] markview.config.markdown.code_blocks.opts

--- Configuration for highlighting a line inside a code block.
---@class markview.config.markdown.code_blocks.opts
---
---@field block_hl string | fun(buffer: integer, line: string): string? Highlight group for the background of the line.
---@field pad_hl string | fun(buffer: integer, line: string): string? Highlight group for the padding of the line.


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

---@class __code_blocks.range
---
---@field row_start integer
---@field row_end integer
---@field col_start integer
---@field col_end integer
---
---@field language? integer[] Range of the language string.
---@field info_string? integer[] Range of info string.

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

-- [ Markdown | Headings > Parameters ] ---------------------------------------------------

---@class __markdown.atx
---
---@field class "markdown_atx_heading"
---
---@field marker "#" | "##" | "###" | "####" | "#####" | "######" Heading marker.
---
---@field text string[]
---@field range node.range

---@class __markdown.setext
---
---@field class "markdown_setext_heading"
---
---@field marker "---" | "===" Heading marker.
---
---@field text string[]
---@field range node.range

-- [ Markdown | Horizontal rules ] --------------------------------------------------------

--- Configuration for horizontal rules.
---@class markdown.horizontal_rules
---
---@field enable boolean Enables preview of horizontal rules.
---
---@field parts ( horizontal_rules.text | horizontal_rules.repeating )[] Parts for the horizontal rules.

-- [ Markdown | Horizontal rules > Type definitions ] -------------------------------------

---@class horizontal_rules.text
---
---@field type "text" Part name.
---
---@field hl? string Highlight group for this part.
---@field text string Text to show.

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

-- [ Markdown | Horizontal rules > Parameters ] -------------------------------------------

---@class __markdown.horizontal_rules
---
---@field class "markdown_hr"
---@field text string[]
---@field range node.range

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

-- [ Markdown | List items > Type definitions ] -------------------------------------------

---@class list_items.unordered
---
---@field add_padding boolean
---@field conceal_on_checkboxes? boolean
---@field enable? boolean
---@field hl? string
---@field text string

---@class list_items.ordered
---
---@field add_padding boolean
---@field conceal_on_checkboxes? boolean
---@field enable? boolean

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

-- [ Markdown | Reference definitions ] ---------------------------------------------------

--- Configuration for reference definitions.
---@class markdown.reference_definitions
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for reference definitions.
---@field [string] config.inline_generic Configuration for reference definitions whose description matches `string`.

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

---@class __reference_definitions.range
---
---@field row_start integer
---@field row_end integer
---@field col_start integer
---@field col_end integer
---
---@field label integer[] Range of the label node(result of `TSNode:range()`).
---@field description? integer[] Range of the description node. Same as `label`.

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

---@class __tables.cell
---
---@field class "separator" | "column" | "missing_separator"
---
---@field text string
---
---@field col_start integer
---@field col_end integer

-- [ Markdown | Misc ] --------------------------------------------------------------------

---@class __markdown.checkboxes
---
---@field class "markdown_checkbox"
---@field state string State of the checkbox(text inside `[]`).
---@field text string[],
---@field range node.range

---@class __markdown.sections
---
---@field class "markdown_section"
---@field level integer
---@field text string[]
---@field range node.range

