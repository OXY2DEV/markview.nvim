---@meta

------------------------------------------------------------------------------

---@class markview.parsed.typst.code_block
---
---@field class "typst_code_block"
---
---@field text string[]
---@field range markview.parsed.range
---
---@field uses_tab boolean Does the lock contain any `tab`s inside it?

------------------------------------------------------------------------------

---@class markview.parsed.typst.code_spans
---@field class "typst_code_span"
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.typst.escapes
---
---@field class "typst_escaped"
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.typst.headings
---
---@field class "typst_heading"
---
---@field level integer Heading level.
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.typst.labels
---
---@field class "typst_labels"
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.typst.list_items
---
---@field class "typst_list_item"
---
---@field indent integer
---@field marker "+" | "-" | string
---@field number? integer Number to show on the list item when previewing.
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.typst.maths
---
---@field class "typst_math_block" | "typst_math_span"
---
---@field inline boolean Should we render it inline?
---@field closed boolean Is the node closed(ends with `$$`)?
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.typst.raw_blocks
---
---@field class "typst_raw_block"
---@field language? string
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.typst.raw_spans
---
---@field class "typst_raw_span"
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.typst.reference_links
---
---@field class "typst_link_ref"
---@field label string
---
---@field text string[]
---@field range markview.parsed.typst.reference_links.range


---@class markview.parsed.typst.reference_links.range
---
---@field row_start integer
---@field col_start integer
---@field row_end integer
---@field col_end integer
---
---@field label integer[] Text after `@`.

------------------------------------------------------------------------------

---@class markview.parsed.typst.subscripts
---
---@field class "typst_subscript"
---
---@field parenthesis boolean Whether the text is surrounded by parenthesis.
---@field level integer Subscript level.
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.typst.superscripts
---
---@field class "typst_superscript"
---
---@field parenthesis boolean Whether the text is surrounded by parenthesis.
---@field level integer Superscript level.
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.typst.symbols
---
---@field class "typst_symbol"
---@field name string
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.typst.terms
---
---@field class "typst_term"
---@field label string
---
---@field text string[]
---@field range markview.parsed.typst.terms.range


---@class markview.parsed.typst.terms.range
---
---@field row_start integer
---@field col_start integer
---@field row_end integer
---@field col_end integer
---
---@field label integer[] Text after `@`.

------------------------------------------------------------------------------

---@class markview.parsed.typst.url_links
---
---@field class "typst_link_url"
---@field label string
---
---@field text string[]
---@field range markview.parsed.typst.url_links.range


---@class markview.parsed.typst.url_links.range
---
---@field row_start integer
---@field col_start integer
---@field row_end integer
---@field col_end integer
---
---@field label integer[] Text after `@`.

------------------------------------------------------------------------------
---@class markview.parsed.typst.emphasis
---
---@field class "typst_emphasis"
---@field text string[]
---
---@field range markview.parsed.range

---@class markview.parsed.typst.strong
---
---@field class "typst_strong"
---@field text string[]
---
---@field range markview.parsed.range

---@class markview.parsed.typst.text
---
---@field class "typst_text"
---@field text string[]
---
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@alias markview.parsed.typst
---| markview.parsed.typst.code_block
---| markview.parsed.typst.code_spans
---| markview.parsed.typst.emphasis
---| markview.parsed.typst.escapes
---| markview.parsed.typst.headings
---| markview.parsed.typst.labels
---| markview.parsed.typst.list_items
---| markview.parsed.typst.maths
---| markview.parsed.typst.raw_blocks
---| markview.parsed.typst.raw_spans
---| markview.parsed.typst.reference_links
---| markview.parsed.typst.strong
---| markview.parsed.typst.subscripts
---| markview.parsed.typst.superscripts
---| markview.parsed.typst.symbols
---| markview.parsed.typst.terms
---| markview.parsed.typst.text
---| markview.parsed.typst.url_links

---@class markview.parsed.typst_sorted
---
---@field typst_code_block markview.parsed.typst.code_block[]
---@field typst_code_span markview.parsed.typst.code_spans[]
---@field typst_escaped markview.parsed.typst.escapes[]
---@field typst_heading markview.parsed.typst.headings[]
---@field typst_labels markview.parsed.typst.labels[]
---@field typst_list_item markview.parsed.typst.list_items[]
---@field typst_math_block markview.parsed.typst.maths[]
---@field typst_math_span markview.parsed.typst.maths[]
---@field typst_raw_block markview.parsed.typst.raw_blocks[]
---@field typst_raw_span markview.parsed.typst.raw_spans[]
---@field typst_link_ref markview.parsed.typst.reference_links[]
---@field typst_subscript markview.parsed.typst.subscripts[]
---@field typst_superscript markview.parsed.typst.superscripts[]
---@field typst_symbol markview.parsed.typst.symbols[]
---@field typst_term markview.parsed.typst.terms[]
---@field typst_link_url markview.parsed.typst.url_links[]
---@field typst_emphasis markview.parsed.typst.emphasis[]
---@field typst_strong markview.parsed.typst.strong[]
---@field typst_text markview.parsed.typst.text[]
