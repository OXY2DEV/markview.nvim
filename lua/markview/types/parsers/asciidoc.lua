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

---@class markview.parsed.asciidoc.images
---
---@field class "asciidoc_image"
---@field destination string Source of the image.
---
---@field text string[]
---@field range markview.parsed.asciidoc.images.range


---@class markview.parsed.asciidoc.images.range
---
---@field row_start integer
---@field col_start integer
---
---@field row_end integer
---@field col_end integer
---
---@field destination integer[] Range of the image destination(output of `{ TSNode:range() }`.

------------------------------------------------------------------------------

---@class markview.parsed.asciidoc.keycodes
---
---@field class "asciidoc_keycode"
---@field destination string Source of the keycode.
---
---@field text string[]
---@field range markview.parsed.asciidoc.keycodes.range


---@class markview.parsed.asciidoc.keycodes.range
---
---@field row_start integer
---@field col_start integer
---
---@field row_end integer
---@field col_end integer
---
---@field destination integer[] Range of the keycode destination(output of `{ TSNode:range() }`.

------------------------------------------------------------------------------

---@class markview.parsed.asciidoc.list_items
---
---@field class "asciidoc_list_item"
---@field checkbox? string
---@field marker string List item marker.
---@field n integer Item index.
---
---@field text string[]
---@field range markview.parsed.asciidoc.list_items.range


---@class markview.parsed.asciidoc.list_items.range
---
---@field row_start integer
---@field col_start integer
---
---@field row_end integer
---@field col_end integer
---
---@field marker_end integer End column for the list item marker(e.g. `*` or `.`).
---
---@field checkbox_start? integer Start column for the checkbox(e.g. `[*]` or `[ ]`).
---@field checkbox_end? integer End column for the checkbox(e.g. `[*]` or `[ ]`).

------------------------------------------------------------------------------

---@class markview.parsed.asciidoc.section_titles
---
---@field class "asciidoc_section_title"
---@field marker string The `=` part of the title.
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.asciidoc.tocs
---
---@field class "asciidoc_toc"
---@field title? string
---@field max_depth? integer
---@field entries markview.parser.asciidoc.data.toc_entry[]
---
---@field text string[]
---@field range markview.parsed.asciidoc.tocs.range


---@class markview.parsed.asciidoc.tocs.range
---
---@field row_start integer
---@field col_start integer
---
---@field row_end integer
---@field col_end integer
---
---@field position? markview.parsed.range

------------------------------------------------------------------------------

---@alias markview.parsed.asciidoc
---| markview.parsed.asciidoc.document_attributes
---| markview.parsed.asciidoc.document_titles
---| markview.parsed.asciidoc.list_items
---| markview.parsed.asciidoc.section_titles
---| markview.parsed.asciidoc.tocs

------------------------------------------------------------------------------

---@class markview.parsed.asciidoc_sorted
---
---@field document_attributes markview.parsed.asciidoc.document_attributes[]
---@field document_titles markview.parsed.asciidoc.document_titles[]
---@field list_items markview.parsed.asciidoc.list_items[]
---@field section_titles markview.parsed.asciidoc.section_titles[]
---@field tocs markview.parsed.asciidoc.tocs[]

------------------------------------------------------------------------------

---@class markview.parser.asciidoc.data
---
---@field document_title? string
---@field toc_title? string
---@field toc_max_depth? integer
---@field toc_entries? markview.parser.asciidoc.data.toc_entry[]
---@field toc_pos? markview.parsed.range


---@class markview.parser.asciidoc.data.toc_entry
---
---@field depth integer
---
---@field text string
---@field range markview.parsed.range

