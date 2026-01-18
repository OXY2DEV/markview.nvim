---@meta


---@class markview.parsed.asciidoc_inline.bolds
---
---@field class "asciidoc_inline_bold"
---@field delimiters [ string?, string? ] Delimiters
---
---@field text string[]
---@field range markview.parsed.range


---@class markview.parsed.asciidoc_inline.highlights
---
---@field class "asciidoc_inline_highlight"
---@field delimiters [ string?, string? ] Delimiters
---
---@field text string[]
---@field range markview.parsed.range


---@class markview.parsed.asciidoc_inline.italics
---
---@field class "asciidoc_inline_italic"
---@field delimiters [ string?, string? ] Delimiters
---
---@field text string[]
---@field range markview.parsed.range


---@class markview.parsed.asciidoc_inline.monospaces
---
---@field class "asciidoc_inline_monospace"
---@field delimiters [ string?, string? ] Delimiters
---
---@field text string[]
---@field range markview.parsed.range


---@class markview.parsed.asciidoc_inline.labeled_uris
---
---@field class "asciidoc_inline_labeled_uri"
---@field kind? string URI type(e.g. `mailto`). Only if the node is a **macro**.
---@field destination string URL the node is pointing to.
---
---@field text string[]
---@field range markview.parsed.asciidoc_inline.labeled_uris.range


---@class markview.parsed.asciidoc_inline.labeled_uris.range
---
---@field row_start integer
---@field col_start integer
---
---@field row_end integer
---@field col_end integer
---
---@field label_col_start? integer Start column of the **label** of an URI(e.g. `foo` in `https://example.com[foo]` or `https://example.com[foo,bar]`).
---@field label_col_end? integer End column of the **label** of an URI.


---@class markview.parsed.asciidoc_inline.uris
---
---@field class "asciidoc_inline_uri"
---@field delimiters [ string?, string? ] Delimiters
---@field destination string URL the node is pointing to.
---
---@field text string[]
---@field range markview.parsed.range


---@alias markview.parsed.asciidoc_inline
---| markview.parsed.asciidoc_inline.bolds
---| markview.parsed.asciidoc_inline.highlights
---| markview.parsed.asciidoc_inline.italics
---| markview.parsed.asciidoc_inline.monospaces
---| markview.parsed.asciidoc_inline.labeled_uris
---| markview.parsed.asciidoc_inline.uris


---@class markview.parsed.asciidoc_inline_sorted
---
---@field bolds markview.parsed.asciidoc_inline.bolds
---@field italics markview.parsed.asciidoc_inline.italics
---@field monospaces markview.parsed.asciidoc_inline.monospaces
---@field highlights markview.parsed.asciidoc_inline.highlights
---@field labeled_uris markview.parsed.asciidoc_inline.labeled_uris
---@field uris markview.parsed.asciidoc_inline.uris

