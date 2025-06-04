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
---@field escapes inline.escapes Escaped characters configuration.
---@field footnotes markview.config.markdown_inline.footnotes Footnotes configuration.
---@field highlights inline.highlights Highlighted text configuration.
---@field hyperlinks inline.hyperlinks Hyperlink configuration.
---@field images markview.config.markdown_inline.images Image link configuration.
---@field internal_links markview.config.markdown_inline.internal_links Internal link configuration.
---@field uri_autolinks markview.config.markdown_inline.uri_autolinks URI autolink configuration.

------------------------------------------------------------------------------

--- Configuration for block reference links.
---@class markview.config.markdown_inline.block_refs
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for block reference links.
---@field [string] config.inline_generic Configuration for block references whose label matches with the key's pattern.


---@class markview.parsed.markdown_inline.block_references
---
---@field class "inline_link_block_ref"
---
---@field file? string File name.
---@field block string Block ID.
---
---@field label string
---
---@field text string[]
---@field range inline_link.range

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

---@class markview.parsed.markdown_inline.checkboxes
---
---@field class "inline_checkbox"
---@field state string Checkbox state(text inside `[]`).
---
---@field text string[]
---@field range? node.range Range of the checkbox. `nil` when rendering list items.

------------------------------------------------------------------------------

--- Configuration for emails.
---@class markview.config.markdown_inline.emails
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for emails
---@field [string] config.inline_generic Configuration for emails whose label(address) matches `string`.


---@class markview.parsed.markdown_inline.emails
---
---@field class "inline_link_email"
---@field label string
---@field text string[]
---@field range inline_link.range

------------------------------------------------------------------------------

--- Configuration for obsidian's embed files.
---@class markview.config.markdown_inline.embed_files
---
---@field enable boolean
---
---@field default config.inline_generic_static Default configuration for embed file links.
---@field [string] config.inline_generic_static Configuration for embed file links whose label matches `string`.

---@class markview.parsed.markdown_inline.embed_files
---
---@field class "inline_link_embed_file"
---
---@field label string Text inside `[[...]]`.
---
---@field text string[]
---@field range node.range

------------------------------------------------------------------------------

--- Configuration for emoji shorthands.
---@class markview.config.markdown_inline.emojis
---
---@field enable boolean
---@field hl? string Highlight group for the emoji.

---@class markview.parsed.markdown_inline.emojis
---
---@field class "inline_emoji"
---
---@field name string Emoji name(without `:`).
---
---@field text string[]
---@field range node.range

------------------------------------------------------------------------------

--- Configuration for HTML entities.
---@class markview.config.markdown_inline.entities
---
---@field enable boolean
---
---@field hl? string Highlight group for the symbol.

---@class markview.parsed.markdown_inline.entities
---
---@field class "inline_entity"
---
---@field name string Entity name(text after "\")
---
---@field text string[]
---@field range node.range

------------------------------------------------------------------------------

--- Configuration for escaped characters.
---@alias inline.escapes { enable: boolean }

---@class markview.parsed.markdown_inline.escapes
---
---@field class "inline_escaped"
---
---@field text string[]
---@field range node.range

------------------------------------------------------------------------------

--- Configuration for footnotes.
---@class markview.config.markdown_inline.footnotes
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for footnotes.
---@field [string] config.inline_generic Configuration for footnotes whose label matches `string`.

---@class markview.parsed.markdown_inline.footnotes
---
---@field class "inline_footnotes"
---@field label string
---@field text string[]
---@field range inline_link.range

------------------------------------------------------------------------------

--- Configuration for highlighted texts.
---@class inline.highlights
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for highlighted text.
---@field [string] config.inline_generic Configuration for highlighted text that matches `string`.

---@class markview.parsed.markdown_inline.highlights
---
---@field class "inline_highlight"
---@field text string[]
---@field range node.range

------------------------------------------------------------------------------

--- Configuration for hyperlinks.
---@class inline.hyperlinks
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for hyperlinks.
---@field [string] config.inline_generic Configuration for links whose description matches `string`.

---@class markview.parsed.markdown_inline.hyperlinks
---
---@field class "inline_link_hyperlink"
---
---@field label? string
---@field description? string
---
---@field text string[]
---@field range inline_link.range

------------------------------------------------------------------------------

--- Configuration for image links.
---@class markview.config.markdown_inline.images
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for image links
---@field [string] config.inline_generic Configuration image links whose description matches `string`.

---@class markview.parsed.markdown_inline.images
---
---@field class "inline_link_image"
---@field label? string
---@field description? string
---@field text string[]
---@field range inline_link.range

------------------------------------------------------------------------------

--- Configuration for inline codes.
---@alias markview.config.markdown_inline.inline_codes config.inline_generic

---@class markview.parsed.markdown_inline.inline_codes
---
---@field class "inline_code_span"
---@field text string[]
---@field range node.range

------------------------------------------------------------------------------

--- Configuration for obsidian's internal links.
---@class markview.config.markdown_inline.internal_links
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for internal links.
---@field [string] config.inline_generic Configuration for internal links whose label match `string`.

---@class markview.parsed.markdown_inline.internal_links
---
---@field class "inline_link_internal"
---
---@field alias? string
---@field label string Text inside `[[...]]`.
---
---@field text string[]
---@field range inline_link.range

------------------------------------------------------------------------------

--- Configuration for uri autolinks.
---@class markview.config.markdown_inline.uri_autolinks
---
---@field enable boolean
---
---@field default config.inline_generic Default configuration for URI autolinks.
---@field [string] config.inline_generic Configuration for URI autolinks whose label match `string`.

---@class markview.parsed.markdown_inline.uri_autolinks
---
---@field class "inline_link_uri_autolinks"
---
---@field label string
---
---@field text string[]
---@field range inline_link.range

