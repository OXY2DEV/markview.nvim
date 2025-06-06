---@meta

------------------------------------------------------------------------------

--- Configuration table for HTML preview.
---@class markview.config.html
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
---@field on_closing_tag? table | fun(tag: table): table Extmark configuration to use on the closing </tag>.
---@field on_node? table Extmark configuration to use on the element.
---@field on_opening_tag? table Extmark configuration to use on the opening <tag>.
---@field opening_tag_offset? fun(range: integer[]): integer[] Modifies the opening <tag>'s range.

------------------------------------------------------------------------------

--- HTML heading config.
---@class markview.config.html.headings
---
---@field enable boolean
---@field [string] table Configuration for <h[n]></h[n]>.

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
---@field on_node table | fun(tag: markview.config.html.void_elements): table

