---@meta

------------------------------------------------------------------------------

--- Configuration for checkboxes.
---@class markview.config.asciidoc.admonitions
---
---@field enable boolean Enable rendering of admonitions.
---
---@field default markview.config.asciidoc.admonitions.opts Default configuration for admonitions.
---@field [string] markview.config.asciidoc.admonitions.opts Configuration for `[string]` admonitions.


---@class markview.config.asciidoc.admonitions.opts
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
---@field hl? string Default highlight group(used by `*_hl` options when they are not set).
---@field desc_hl? string Highlight group for the `description`.
---
---@field padding_right? string Right padding.
---@field padding_right_hl? string Highlight group for the right padding.
---
---@field corner_right? string Right corner(added after `padding_right`).
---@field corner_right_hl? string Highlight group for the right corner.

------------------------------------------------------------------------------

--- Configuration for checkboxes.
---@class markview.config.asciidoc.checkboxes
---
---@field enable boolean Enable rendering of checkboxes.
---
---@field checked markview.config.markdown_inline.checkboxes.opts Configuration for `[*]`.
---@field unchecked markview.config.markdown_inline.checkboxes.opts Configuration for `[ ]`.
---
---@field [string] markview.config.markdown_inline.checkboxes.opts Configuration for `[string]` checkbox.


--[[ Options for a specific checkbox. ]]
---@class markview.config.asciidoc.checkboxes.opts
---
---@field text string Text used to replace `[]` part.
---@field hl? string Highlight group for `text`.
---@field scope_hl? string Highlight group for the list item.

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

--- Configuration for image links.
---@class markview.config.asciidoc.images
---
---@field enable boolean Enable rendering of image links
---
---@field default markview.config.asciidoc.images.opts Default configuration for image links
---@field [string] markview.config.asciidoc.images.opts Configuration image links whose description matches `string`.


--[[ Options for a specific image link type. ]]
---@class markview.config.asciidoc.images.opts
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

--- Configuration for image links.
---@class markview.config.asciidoc.literal_blocks
---
---@field enable boolean Enable rendering of image links
---@field style? "simple" | "block"
---
---@field pad_amount? integer
---@field pad_char? string
---@field min_width? integer
---
---@field label? string
---@field label_hl? string
---@field label_direction? "left" | "right"
---
---@field sign? string
---@field sign_hl? string
---
---@field hl? string

------------------------------------------------------------------------------

--- Configuration for keycodes.
---@class markview.config.asciidoc.keycodes
---
---@field enable boolean Enable rendering of keycodes
---
---@field default markview.config.asciidoc.keycodes.opts Default configuration for keycodes
---@field [string] markview.config.asciidoc.keycodes.opts Configuration of keycodes whose content matches `string`. **NOTE:** Case-insensitive


--[[ Options for a specific keycode type. ]]
---@alias markview.config.asciidoc.keycodes.opts markview.config.__inline

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
---@field admonitions markview.config.asciidoc.admonitions
---@field checkboxes markview.config.asciidoc.checkboxes
---@field document_attributes markview.config.asciidoc.document_attributes
---@field document_titles markview.config.asciidoc.document_titles
---@field list_items markview.config.asciidoc.list_items
---@field section_titles markview.config.asciidoc.section_titles
---@field tocs markview.config.asciidoc.tocs

