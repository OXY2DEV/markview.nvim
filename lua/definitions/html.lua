---@meta

------------------------------------------------------------------------------

--- Configuration table for HTML preview.
---@class config.html
---
---@field enable boolean
---
--- Configuration for container elements.
---@field container_elements markview.config.html.container_elements
---  Configuration for headings(e.g. `<h1>`).
---@field headings markview.config.html.headings
--- Configuration for void elements.
---@field void_elements markview.config.html.void_elements

------------------------------------------------------------------------------

--- HTML <container></container> element config.
---@class markview.config.html.container_elements
---
---@field enable boolean
---@field [string] markview.config.html.container_elements.opts Configuration for <string></string>.

--- Configuration table for a specific container element.
---@class markview.config.html.container_elements.opts
---
---@field closing_tag_offset? fun(range: integer[]): integer[] Modifies the closing </tag>'s range.
---@field node_offset? fun(range: integer[]): integer[] Modifies the element's range.
---@field on_closing_tag? config.extmark | fun(tag: table): config.extmark Extmark configuration to use on the closing </tag>.
---@field on_node? config.extmark Extmark configuration to use on the element.
---@field on_opening_tag? config.extmark Extmark configuration to use on the opening <tag>.
---@field opening_tag_offset? fun(range: integer[]): integer[] Modifies the opening <tag>'s range.

--- Parsed version of an HTML container element.
---@class markview.parsed.html.container_elements
---
---@field class "html_container_element"
---
---@field opening_tag __container.data Table containing information regarding the opening tag.
---@field closing_tag __container.data Table containing information regarding the closing tag.
---
---@field name string Tag name(in lowercase).
---
---@field text string[] Text of this node.
---@field range node.range Range of this node.

--- Container element segment data.
---@class __container.data
---
---@field text string Text inside this segment.
---@field range integer[] Range of this segment(Result of `{ TSNode:range() }`).

------------------------------------------------------------------------------

--- HTML heading config.
---@class markview.config.html.headings
---
---@field enable boolean
---@field [string] config.extmark Configuration for <h[n]></h[n]>.

---@class __html.headings
---
---@field class "html_heading"
---@field level integer Heading level.
---@field range node.range
---@field text string[]

------------------------------------------------------------------------------

--- HTML <void> element config.
---@class markview.config.html.void_elements
---
---@field enable boolean
---@field [string] markview.config.html.void_elements.opts Configuration for <string>.

--- Configuration table for a specific void element.
---@class markview.config.html.void_elements.opts
---
---@field node_offset? fun(range: integer[]): table
---@field on_node config.extmark | fun(tag: markview.config.html.void_elements): config.extmark

--- Parsed version of a void element.
---@class markview.config.html.void_elements
---
---@field class "html_void_element"
---
---@field name string Element name(always in lowercase).
---
---@field text string[]
---@field range node.range

