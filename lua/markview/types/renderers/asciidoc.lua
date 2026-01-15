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

---@class markview.config.asciidoc
---
---@field document_attributes markview.config.asciidoc.document_attributes
---@field document_titles markview.config.asciidoc.document_titles
---@field section_titles markview.config.asciidoc.section_titles

