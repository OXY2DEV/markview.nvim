---@meta

------------------------------------------------------------------------------

---@class markview.parsed.asciidoc.document_attributes
---
---@field class "asciidoc_document_attribute"
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.asciidoc.document_titles
---
---@field class "asciidoc_document_title"
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@alias markview.parsed.asciidoc
---| markview.parsed.asciidoc.document_attributes
---| markview.parsed.asciidoc.document_titles

------------------------------------------------------------------------------

---@class markview.parsed.asciidoc_sorted
---
---@field document_attributes markview.parsed.asciidoc.document_attributes[]
---@field document_titles markview.parsed.asciidoc.document_titles[]

