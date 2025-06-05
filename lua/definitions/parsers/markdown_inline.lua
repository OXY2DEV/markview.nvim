---@meta

------------------------------------------------------------------------------

---@class markview.parsed.markdown_inline.block_refs
---
---@field class "inline_link_block_ref"
---
---@field file? string File name.
---@field block string Block ID.
---
---@field label string
---
---@field text string[]
---@field range markview.parsed.markdown_inline.block_refs.range


---@class markview.parsed.markdown_inline.block_refs.range
---
---@field row_start integer
---@field col_start integer
---@field row_end integer
---@field col_end integer
---
---@field label integer[] Text inside `![[...]]`.
---@field block integer[] Block being referenced(everything after `#^`).
---@field file integer[] File name(everything before `#^`).

------------------------------------------------------------------------------

---@class markview.parsed.markdown_inline.checkboxes
---
---@field class "inline_checkbox"
---@field state string Checkbox state(text inside `[]`).
---
---@field text string[]
---@field range markview.parsed.range Range of the checkbox. `nil` when rendering list items.

------------------------------------------------------------------------------

---@class markview.parsed.markdown_inline.emails
---
---@field class "inline_link_email"
---
---@field label string
---
---@field text string[]
---@field range markview.parsed.markdown_inline.emails.range


---@class markview.parsed.markdown_inline.emails.range
---
---@field row_start integer
---@field col_start integer
---@field row_end integer
---@field col_end integer
---
---@field label integer[] Text inside `<...>`.

------------------------------------------------------------------------------

---@class markview.parsed.markdown_inline.embed_files
---
---@field class "inline_link_embed_file"
---
---@field label string Text inside `[[...]]`.
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.markdown_inline.emojis
---
---@field class "inline_emoji"
---
---@field name string Emoji name(without `:`).
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.markdown_inline.entities
---
---@field class "inline_entity"
---
---@field name string Entity name(text after "\")
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.markdown_inline.escapes
---
---@field class "inline_escaped"
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.markdown_inline.footnotes
---
---@field class "inline_footnotes"
---@field label string
---@field text string[]
---
---@field range markview.parsed.markdown_inline.footnotes.range


---@class markview.parsed.markdown_inline.footnotes.range
---
---@field row_start integer
---@field col_start integer
---@field row_end integer
---@field col_end integer
---
---@field label integer[] Text inside `[^...]`.

------------------------------------------------------------------------------

---@class markview.parsed.markdown_inline.highlights
---
---@field class "inline_highlight"
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.markdown_inline.hyperlinks
---
---@field class "inline_link_hyperlink"
---
---@field label? string
---@field description? string
---
---@field text string[]
---@field range markview.parsed.markdown_inline.hyperlinks.range


---@class markview.parsed.markdown_inline.hyperlinks.range
---
---@field row_start integer
---@field col_start integer
---@field row_end integer
---@field col_end integer
---
---@field label integer[] Text inside `[...]`.
---@field description integer[] Text inside `[](...)`/`[][...]`.

------------------------------------------------------------------------------

---@class markview.parsed.markdown_inline.images
---
---@field class "inline_link_image"
---
---@field label? string
---@field description? string
---
---@field text string[]
---@field range markview.parsed.markdown_inline.images.range


---@class markview.parsed.markdown_inline.images.range
---
---@field row_start integer
---@field col_start integer
---@field row_end integer
---@field col_end integer
---
---@field label integer[] Text inside `![...]`.
---@field description integer[] Text inside `![](...)`/`[][...]`.

------------------------------------------------------------------------------

---@class markview.parsed.markdown_inline.inline_codes
---
---@field class "inline_code_span"
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.markdown_inline.internal_links
---
---@field class "inline_link_internal"
---
---@field alias? string
---@field label string Text inside `[[...]]`.
---
---@field text string[]
---@field range markview.parsed.markdown_inline.internal_links.range


---@class markview.parsed.markdown_inline.internal_links.range
---
---@field row_start integer
---@field col_start integer
---@field row_end integer
---@field col_end integer
---
---@field label integer[] Text inside `[[...]]`(optionally everything before |).
---@field alias integer[] Text inside `[[ |...]]`.

------------------------------------------------------------------------------

---@class markview.parsed.markdown_inline.uri_autolinks
---
---@field class "inline_link_uri_autolinks"
---
---@field label string
---
---@field text string[]
---@field range markview.parsed.markdown_inline.uri_autolinks.range


---@class markview.parsed.markdown_inline.uri_autolinks.range
---
---@field row_start integer
---@field col_start integer
---@field row_end integer
---@field col_end integer
---
---@field label integer[] Text inside `[[...]]`(optionally everything before |).

