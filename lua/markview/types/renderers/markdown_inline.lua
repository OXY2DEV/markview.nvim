---@meta

--- Configuration for inline markdown.
---@class markview.config.markdown_inline
---
---@field enable boolean
---
---@field block_references markview.config.markdown_inline.block_refs Block reference link configuration.
---@field checkboxes markview.config.markdown_inline.checkboxes Checkbox configuration.
---@field inline_codes markview.config.markdown_inline.inline_codes Inline code/code span configuration.
---@field emails markview.config.markdown_inline.emails Email link configuration.
---@field embed_files markview.config.markdown_inline.embed_files Embed file link configuration.
---@field emoji_shorthands markview.config.markdown_inline.emojis Github styled emoji shorthands.
---@field entities markview.config.markdown_inline.entities HTML entities configuration.
---@field escapes markview.config.markdown_inline.escapes Escaped characters configuration.
---@field footnotes markview.config.markdown_inline.footnotes Footnotes configuration.
---@field highlights markview.config.markdown_inline.highlights Highlighted text configuration.
---@field hyperlinks markview.config.markdown_inline.hyperlinks Hyperlink configuration.
---@field images markview.config.markdown_inline.images Image link configuration.
---@field internal_links markview.config.markdown_inline.internal_links Internal link configuration.
---@field uri_autolinks markview.config.markdown_inline.uri_autolinks URI autolink configuration.

------------------------------------------------------------------------------

--- Configuration for block reference links.
---@class markview.config.markdown_inline.block_refs
---
---@field enable boolean
---
---@field default markview.config.__inline Default configuration for block reference links.
---@field [string] markview.config.__inline Configuration for block references whose label matches with the key's pattern.

------------------------------------------------------------------------------

--- Configuration for checkboxes.
---@class markview.config.markdown_inline.checkboxes
---
---@field enable boolean
---
---@field checked markview.config.markdown_inline.checkboxes.opts Configuration for [x] & [X].
---@field unchecked markview.config.markdown_inline.checkboxes.opts Configuration for [ ].
---
---@field [string] markview.config.markdown_inline.checkboxes.opts

---@class markview.config.markdown_inline.checkboxes.opts
---
---@field text string
---@field hl? string
---@field scope_hl? string Highlight group for the list item.

------------------------------------------------------------------------------

--- Configuration for emails.
---@class markview.config.markdown_inline.emails
---
---@field enable boolean
---
---@field default markview.config.__inline Default configuration for emails
---@field [string] markview.config.__inline Configuration for emails whose label(address) matches `string`.

------------------------------------------------------------------------------

--- Configuration for obsidian's embed files.
---@class markview.config.markdown_inline.embed_files
---
---@field enable boolean
---
---@field default markview.config.__inline Default configuration for embed file links.
---@field [string] markview.config.__inline Configuration for embed file links whose label matches `string`.

------------------------------------------------------------------------------

--- Configuration for emoji shorthands.
---@class markview.config.markdown_inline.emojis
---
---@field enable boolean
---@field hl? string Highlight group for the emoji.

------------------------------------------------------------------------------

--- Configuration for HTML entities.
---@class markview.config.markdown_inline.entities
---
---@field enable boolean
---
---@field hl? string Highlight group for the symbol.

------------------------------------------------------------------------------

--- Configuration for escaped characters.
---@alias markview.config.markdown_inline.escapes { enable: boolean }

------------------------------------------------------------------------------

--- Configuration for footnotes.
---@class markview.config.markdown_inline.footnotes
---
---@field enable boolean
---
---@field default markview.config.__inline Default configuration for footnotes.
---@field [string] markview.config.__inline Configuration for footnotes whose label matches `string`.

------------------------------------------------------------------------------

--- Configuration for highlighted texts.
---@class markview.config.markdown_inline.highlights
---
---@field enable boolean
---
---@field default markview.config.__inline Default configuration for highlighted text.
---@field [string] markview.config.__inline Configuration for highlighted text that matches `string`.

------------------------------------------------------------------------------

--- Configuration for hyperlinks.
---@class markview.config.markdown_inline.hyperlinks
---
---@field enable boolean
---
---@field default markview.config.__inline Default configuration for hyperlinks.
---@field [string] markview.config.__inline Configuration for links whose description matches `string`.

------------------------------------------------------------------------------

--- Configuration for image links.
---@class markview.config.markdown_inline.images
---
---@field enable boolean
---
---@field default markview.config.__inline Default configuration for image links
---@field [string] markview.config.__inline Configuration image links whose description matches `string`.

------------------------------------------------------------------------------

--- Configuration for inline codes.
---@alias markview.config.markdown_inline.inline_codes markview.config.__inline

------------------------------------------------------------------------------

--- Configuration for obsidian's internal links.
---@class markview.config.markdown_inline.internal_links
---
---@field enable boolean
---
---@field default markview.config.__inline Default configuration for internal links.
---@field [string] markview.config.__inline Configuration for internal links whose label match `string`.

------------------------------------------------------------------------------

--- Configuration for uri autolinks.
---@class markview.config.markdown_inline.uri_autolinks
---
---@field enable boolean
---
---@field default markview.config.__inline Default configuration for URI autolinks.
---@field [string] markview.config.__inline Configuration for URI autolinks whose label match `string`.

