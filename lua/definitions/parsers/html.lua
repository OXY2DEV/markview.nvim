---@meta

------------------------------------------------------------------------------

--- Parsed version of an HTML container element.
---@class markview.parsed.html.container_elements
---
---@field class "html_container_element"
---
---@field opening_tag markview.parsed.html.container_elements.data Table containing information regarding the opening tag.
---@field closing_tag markview.parsed.html.container_elements.data Table containing information regarding the closing tag.
---
---@field name string Tag name(in lowercase).
---
---@field text string[] Text of this node.
---@field range markview.parsed.range Range of this node.

--- Container element segment data.
---@class markview.parsed.html.container_elements.data
---
---@field text string Text inside this segment.
---@field range integer[] Range of this segment(Result of `{ TSNode:range() }`).

------------------------------------------------------------------------------

---@class markview.parsed.html.headings
---
---@field class "html_heading"
---
---@field level integer Heading level.
---@field range markview.parsed.range
---@field text string[]

------------------------------------------------------------------------------

--- Parsed version of a void element.
---@class markview.parsed.html.void_elements
---
---@field class "html_void_element"
---
---@field name string Element name(always in lowercase).
---
---@field text string[]
---@field range markview.parsed.range

