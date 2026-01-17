---@meta

------------------------------------------------------------------------------

---@class markview.config.asciidoc.document_attributes
---
---@field enable boolean

------------------------------------------------------------------------------

---@class markview.config.asciidoc.document_titles
---
---@field enable boolean
---
---@field sign? string
---@field sign_hl? string
---
---@field icon? string
---@field icon_hl? string
---
---@field hl? string

------------------------------------------------------------------------------

--- Configuration for list items.
---@class markview.config.asciidoc.list_items
---
---@field enable boolean
---@field shift_width integer | fun(buffer: integer, item: markview.parsed.markdown.list_items): integer Virtual indentation size for previewed list items.
---
---@field marker_dot markview.config.asciidoc.list_items.opts Configuration for `.` list items.
---@field marker_minus markview.config.asciidoc.list_items.opts Configuration for `-` list items.
---@field marker_star markview.config.asciidoc.list_items.opts Configuration for `*` list items.
---
---@field wrap? boolean Enables wrap support.


---@class markview.config.asciidoc.list_items.opts
---
---@field add_padding boolean
---@field conceal_on_checkboxes? boolean
---@field enable? boolean
---@field hl? string
---
---[[ Text used to replace the list item marker. ]]
---@field text?
---| string
---| fun(buffer: integer, item: markview.parsed.asciidoc.list_items): string

------------------------------------------------------------------------------

---@class markview.config.asciidoc.section_titles
---
---@field enable boolean
---@field shift_width integer
---
---@field title_1 markview.config.asciidoc.section_titles.opts
---@field title_2 markview.config.asciidoc.section_titles.opts
---@field title_3 markview.config.asciidoc.section_titles.opts
---@field title_4 markview.config.asciidoc.section_titles.opts
---@field title_5 markview.config.asciidoc.section_titles.opts


---@class markview.config.asciidoc.section_titles.opts
---
---@field icon? string
---@field icon_hl? string
---
---@field sign? string
---@field sign_hl? string
---
---@field hl? string

------------------------------------------------------------------------------

---@class markview.config.asciidoc.tocs
---
---@field enable boolean
---@field shift_width integer
---
---@field icon? string Icon for the TOC title.
---@field icon_hl? string Highlight group for `icon`.
---
---@field sign? string Sign for the TOC title.
---@field sign_hl? string Highlight group for `sign`.
---
---@field hl? string
---
---@field depth_1 markview.config.asciidoc.tocs.opts
---@field depth_2 markview.config.asciidoc.tocs.opts
---@field depth_3 markview.config.asciidoc.tocs.opts
---@field depth_4 markview.config.asciidoc.tocs.opts
---@field depth_5 markview.config.asciidoc.tocs.opts


---@class markview.config.asciidoc.tocs.opts
---
---@field shift_char? string
---@field hl? string
---
---@field icon? string Icon for the TOC title.
---@field icon_hl? string Highlight group for `icon`.

------------------------------------------------------------------------------

---@class markview.config.asciidoc
---
---@field document_attributes markview.config.asciidoc.document_attributes
---@field document_titles markview.config.asciidoc.document_titles
---@field list_items markview.config.asciidoc.list_items
---@field section_titles markview.config.asciidoc.section_titles
---@field tocs markview.config.asciidoc.tocs

