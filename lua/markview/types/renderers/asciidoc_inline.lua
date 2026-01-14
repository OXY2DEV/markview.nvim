---@meta


---@class markview.config.asciidoc_inline.bolds
---
---@field enable boolean

------------------------------------------------------------------------------

--- Configuration for Obsidian-style highlighted texts.
---@class markview.config.asciidoc_inline.highlights
---
---@field enable boolean Enable rendering of highlighted text.
---
---@field default markview.config.asciidoc_inline.highlights.opts Default configuration for highlighted text.
---@field [string] markview.config.asciidoc_inline.highlights.opts Configuration for highlighted text that matches `string`.


--[[ Options for a specific footnote type. ]]
---@alias markview.config.asciidoc_inline.highlights.opts markview.config.__inline


---@class markview.config.asciidoc_inline.italics
---
---@field enable boolean


---@alias markview.config.asciidoc_inline.monospaces markview.config.__inline


---@class markview.config.asciidoc_inline
---
---@field bolds markview.config.asciidoc_inline.bolds
---@field highlights markview.config.asciidoc_inline.highlights Highlighted text configuration.
---@field italics markview.config.asciidoc_inline.italics
---@field monospaces markview.config.asciidoc_inline.monospaces

