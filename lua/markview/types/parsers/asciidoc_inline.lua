---@meta


---@class markview.parsed.asciidoc_inline.bolds
---
---@field class "asciidoc_inline_bold"
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


---@alias markview.parsed.asciidoc_inline
---| markview.parsed.asciidoc_inline.bolds
---| markview.parsed.asciidoc_inline.italics
---| markview.parsed.asciidoc_inline.monospaces


---@class markview.parsed.asciidoc_inline_sorted
---
---@field bolds markview.parsed.asciidoc_inline.bolds
---@field italics markview.parsed.asciidoc_inline.italics
---@field monospaces markview.parsed.asciidoc_inline.monospaces

