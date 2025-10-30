---@meta

--- Configuration for inline markdown.
---@class markview.config.markdown_inline
---
---@field enable boolean Enable **inline markdown** rendering.
---
---@field block_references markview.config.markdown_inline.block_refs Block reference link configuration.
---@field checkboxes markview.config.markdown_inline.checkboxes Checkbox configuration.
---@field emails markview.config.markdown_inline.emails Email link configuration.
---@field embed_files markview.config.markdown_inline.embed_files Embed file link configuration.
---@field emoji_shorthands markview.config.markdown_inline.emojis Github styled emoji shorthands.
---@field entities markview.config.markdown_inline.entities HTML entities configuration.
---@field escapes markview.config.markdown_inline.escapes Escaped characters configuration.
---@field footnotes markview.config.markdown_inline.footnotes Footnotes configuration.
---@field highlights markview.config.markdown_inline.highlights Highlighted text configuration.
---@field hyperlinks markview.config.markdown_inline.hyperlinks Hyperlink configuration.
---@field images markview.config.markdown_inline.images Image link configuration.
---@field inline_codes markview.config.markdown_inline.inline_codes Inline code/code span configuration.
---@field internal_links markview.config.markdown_inline.internal_links Internal link configuration.
---@field uri_autolinks markview.config.markdown_inline.uri_autolinks URI autolink configuration.

------------------------------------------------------------------------------

--- Configuration for block reference links.
---@class markview.config.markdown_inline.block_refs
---
---@field enable boolean Enable rendering of block references.
---
---@field default markview.config.__inline Default configuration for block reference links.
---@field [string] markview.config.__inline Configuration for block references whose label matches with the key's pattern.

------------------------------------------------------------------------------

--- Configuration for checkboxes.
---@class markview.config.markdown_inline.checkboxes
---
---@field enable boolean Enable rendering of checkboxes.
---
---@field checked markview.config.markdown_inline.checkboxes.opts Configuration for `[x]` & `[X]`.
---@field unchecked markview.config.markdown_inline.checkboxes.opts Configuration for `[ ]`.
---
---@field [string] markview.config.markdown_inline.checkboxes.opts Configuration for `[string]` checkbox.


--[[ Options for a specific checkbox. ]]
---@class markview.config.markdown_inline.checkboxes.opts
---
---@field text string Text used to replace `[]` part.
---@field hl? string Highlight group for `text`.
---@field scope_hl? string Highlight group for the list item.

------------------------------------------------------------------------------

--- Configuration for emails.
---@class markview.config.markdown_inline.emails
---
---@field enable boolean Enable rendering of Emails.
---
---@field default markview.config.markdown_inline.emails.opts Default configuration for emails
---@field [string] markview.config.markdown_inline.emails.opts Configuration for emails whose label(address) matches `string`.


--[[ Options for a specific email type. ]]
---@alias markview.config.markdown_inline.emails.opts markview.config.__inline

------------------------------------------------------------------------------

--- Configuration for obsidian's embed files.
---@class markview.config.markdown_inline.embed_files
---
---@field enable boolean Enable rendering of Embed files.
---
---@field default markview.config.markdown_inline.embed_files.opts Default configuration for embed file links.
---@field [string] markview.config.markdown_inline.embed_files.opts Configuration for embed file links whose label matches `string`.


--[[ Options for a specific embed file type. ]]
---@alias markview.config.markdown_inline.embed_files.opts markview.config.__inline

------------------------------------------------------------------------------

--- Configuration for Github-styled emoji shorthands.
---@class markview.config.markdown_inline.emojis
---
---@field enable boolean Enable rendering of emoji shorthands.
---@field hl? string Highlight group for the emoji.

------------------------------------------------------------------------------

--- Configuration for HTML entities.
---@class markview.config.markdown_inline.entities
---
---@field enable boolean Enable rendering of HTML entities.
---@field hl? string Highlight group for the symbol.

------------------------------------------------------------------------------

--- Configuration for escaped characters.
---@class markview.config.markdown_inline.escapes
---
---@field enable boolean Enable rendering of escaped characters.

------------------------------------------------------------------------------

--- Configuration for footnotes.
---@class markview.config.markdown_inline.footnotes
---
---@field enable boolean Enable rendering of footnotes.
---
---@field default markview.config.markdown_inline.footnotes.opts Default configuration for footnotes.
---@field [string] markview.config.markdown_inline.footnotes.opts Configuration for footnotes whose label matches `string`.


--[[ Options for a specific footnote type. ]]
---@alias markview.config.markdown_inline.footnotes.opts markview.config.__inline

------------------------------------------------------------------------------

--- Configuration for Obsidian-style highlighted texts.
---@class markview.config.markdown_inline.highlights
---
---@field enable boolean Enable rendering of highlighted text.
---
---@field default markview.config.markdown_inline.highlights.opts Default configuration for highlighted text.
---@field [string] markview.config.markdown_inline.highlights.opts Configuration for highlighted text that matches `string`.


--[[ Options for a specific footnote type. ]]
---@alias markview.config.markdown_inline.highlights.opts markview.config.__inline

------------------------------------------------------------------------------

--- Configuration for hyperlinks.
---@class markview.config.markdown_inline.hyperlinks
---
---@field enable boolean Enable rendering of hyperlink.
---
---@field default markview.config.markdown_inline.hyperlinks.opts Default configuration for hyperlinks.
---@field [string] markview.config.markdown_inline.hyperlinks.opts Configuration for links whose description matches `string`.


--[[ Options for a specific hyperlink type. ]]
---@alias markview.config.markdown_inline.hyperlinks.opts markview.config.__inline

------------------------------------------------------------------------------

--- Configuration for image links.
---@class markview.config.markdown_inline.images
---
---@field enable boolean Enable rendering of image links
---
---@field default markview.config.markdown_inline.images.opts Default configuration for image links
---@field [string] markview.config.markdown_inline.images.opts Configuration image links whose description matches `string`.


--[[ Options for a specific image link type. ]]
---@alias markview.config.markdown_inline.images.opts markview.config.__inline

------------------------------------------------------------------------------

--- Configuration for inline codes.
---@alias markview.config.markdown_inline.inline_codes markview.config.__inline

------------------------------------------------------------------------------

--- Configuration for obsidian's internal links.
---@class markview.config.markdown_inline.internal_links
---
---@field enable boolean Enable rendering of internal links.
---
---@field default markview.config.markdown_inline.internal_links.opts Default configuration for internal links.
---@field [string] markview.config.markdown_inline.internal_links.opts Configuration for internal links whose label match `string`.


--[[ Options for a specific internal link type. ]]
---@alias markview.config.markdown_inline.internal_links.opts markview.config.__inline

------------------------------------------------------------------------------

--- Configuration for URI autolinks.
---@class markview.config.markdown_inline.uri_autolinks
---
---@field enable boolean Enable rendering of URI autolinks.
---
---@field default markview.config.markdown_inline.uri_autolinks.opts Default configuration for URI autolinks.
---@field [string] markview.config.markdown_inline.uri_autolinks.opts Configuration for URI autolinks whose label match `string`.


--[[ Options for a specific URI autolink type. ]]
---@alias markview.config.markdown_inline.uri_autolinks.opts markview.config.__inline

