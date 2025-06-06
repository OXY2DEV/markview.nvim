---@meta

------------------------------------------------------------------------------

---@class markview.parsed.typst.code_block
---
---@field class "typst_code_block"
---
---@field text string[]
---@field range markview.parsed.range

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

