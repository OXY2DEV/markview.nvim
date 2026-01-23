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

------------------------------------------------------------------------------

--[[ Options for a specific highlight type. ]]
---@alias markview.config.asciidoc_inline.highlights.opts markview.config.__inline

------------------------------------------------------------------------------

---@class markview.config.asciidoc_inline.italics
---
---@field enable boolean

------------------------------------------------------------------------------

---@alias markview.config.asciidoc_inline.monospaces markview.config.__inline

------------------------------------------------------------------------------

---@class markview.config.asciidoc_inline.uris
---
---@field enable boolean Enable rendering of unlabeled URIs.
---
---@field default markview.config.asciidoc_inline.uris.opts Default configuration for URIs.
---@field [string] markview.config.asciidoc_inline.uris.opts Configuration for URIs that matches `string`.


---@class markview.config.asciidoc_inline.uris.opts
---
---@field corner_left? string Left corner.
---@field corner_left_hl? string Highlight group for the left corner.
---
---@field padding_left? string Left padding(added after `corner_left`).
---@field padding_left_hl? string Highlight group for the left padding.
---
---@field icon? string Icon(added after `padding_left`).
---@field icon_hl? string Highlight group for the icon.
---
--[[ Text to show instead of the `URL`.]]
---@field text?
---| string
---| function(buffer: integer, item: markview.parsed.asciidoc_inline.uris): string
---@field text_hl? string Highlight group for the text.
---
---@field hl? string Default highlight group(used by `*_hl` options when they are not set).
---
---@field padding_right? string Right padding.
---@field padding_right_hl? string Highlight group for the right padding.
---
---@field corner_right? string Right corner(added after `padding_right`).
---@field corner_right_hl? string Highlight group for the right corner.


------------------------------------------------------------------------------

---@class markview.config.asciidoc_inline
---
---@field enable boolean Enable rendering of inline asciidoc.
---
---@field bolds markview.config.asciidoc_inline.bolds
---@field highlights markview.config.asciidoc_inline.highlights
---@field italics markview.config.asciidoc_inline.italics
---@field monospaces markview.config.asciidoc_inline.monospaces
---@field uris markview.config.asciidoc_inline.uris

