---@meta

------------------------------------------------------------------------------

---@class markview.parsed.markdown.block_quotes
---
---@field class "markdown_block_quote"
---
---@field callout string? Callout text(text inside `[!...]`).
---@field title string? Title of the callout.
---
---@field text string[]
---@field range markview.parsed.markdown.block_quotes.range
---
---@field __nested boolean Is the node nested?


---@class markview.parsed.markdown.block_quotes.range
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

---@class markview.parsed.markdown.code_blocks
---
---@field class "markdown_code_block"
---
---@field delimiters [ string, string ] Code block delimiters(```).
---@field language string? Language string(typically after ```).
---@field info_string string? Extra information(typically after the language).
---
---@field text string[]
---@field range markview.parsed.markdown.code_blocks.range


---@class markview.parsed.markdown.code_blocks.range
---
---@field start_delim integer[] Range of the **start** delimiter.
---@field end_delim? integer[] Range of the **end** delimiter.
---
---@field row_start integer
---@field row_end integer
---@field col_start integer
---@field col_end integer
---
---@field language? integer[] Range of the language string.
---@field info_string? integer[] Range of info string.

------------------------------------------------------------------------------

---@class markview.parsed.markdown.atx
---
---@field class "markdown_atx_heading"
---@field levels integer[] Heading depth level.
---
---@field marker "#" | "##" | "###" | "####" | "#####" | "######" Heading marker.
---
---@field text string[]
---@field range markview.parsed.range


---@class markview.parsed.markdown.setext
---
---@field class "markdown_setext_heading"
---
---@field marker "---" | "===" Heading marker.
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.markdown.hr
---
---@field class "markdown_hr"
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.markdown.list_items
---
---@field class "markdown_list_item"
---@field __nested boolean Is the node nested?
---
---@field candidates integer[] List of line numbers(0-indexed) from start that should be indented.
---
---@field marker "-" | "+" | "*" | string List marker text.
---@field checkbox? string Checkbox state(if there is a checkbox).
---
---@field indent integer Number of spaces before the list marker.
---
---@field text string[]
---@field range markview.parsed.range
---
---
---@field __block boolean Indicates whether the list item is the children of a block quote.

------------------------------------------------------------------------------

---@class markview.parsed.markdown.metadata_minus
---
---@field class "markdown_metadata_minus"
---
---@field text string[]
---@field range markview.parsed.range


---@class markview.parsed.markdown.metadata_plus
---
---@field class "markdown_metadata_plus"
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.markdown.reference_definitions
---
---@field class "markdown_link_ref_definition"
---
---@field label? string Visible part of the reference link definition.
---@field description? string Description of the reference link.
---
---@field text string[]
---@field range markview.parsed.markdown.reference_definitions.range


---@class markview.parsed.markdown.reference_definitions.range
---
---@field row_start integer
---@field row_end integer
---@field col_start integer
---@field col_end integer
---
---@field label integer[] Range of the label node(result of `TSNode:range()`).
---@field description? integer[] Range of the description node. Same as `label`.

------------------------------------------------------------------------------

---@class markview.parsed.markdown.tables
---
---@field class "markdown_table"
---@field has_alignment_markers boolean Are there any alignment markers(e.g. `:-`, `-:`, `:-:`)?
---
---@field top_border boolean Can we draw the top border?
---@field bottom_border boolean Can we draw the bottom border?
---@field border_overlap boolean Is the table's borders overlapping another table?
---
---@field alignments markview.parsed.markdown.tables.align[] Text alignments.
---
---@field header markview.parsed.markdown.tables.cell[]
---@field separator markview.parsed.markdown.tables.cell[]
---@field rows markview.parsed.markdown.tables.cell[][]
---
---@field text string[]
---@field range markview.parsed.range


---@alias markview.parsed.markdown.tables.align
---| "default"
---| "left"
---| "center"
---| "right"


---@class markview.parsed.markdown.tables.cell
---
---@field class
---| "separator"
---| "column"
---| "missing_separator"
---
---@field text string
---
---@field col_start integer
---@field col_end integer

------------------------------------------------------------------------------

--- Used for handling `[x]` & `[ ]` checkboxes.
---@class markview.parsed.markdown.checkboxes
---
---@field class "markdown_checkbox"
---@field state "x" | " " State of the checkbox(text inside `[]`).
---
---@field text string[],
---@field range markview.parsed.range


--- Used for Org-indent.
---@class markview.parsed.markdown.sections
---
---@field class "markdown_section"
---@field level integer
---
---@field text string[]
---@field range markview.parsed.markdown.sections.range


---@class markview.parsed.markdown.sections.range
---
---@field row_start integer
---@field row_end integer
---@field col_start integer
---@field col_end integer
---
---@field org_end integer Line where `Org indent` should end.

