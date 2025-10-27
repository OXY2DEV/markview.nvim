---@meta

------------------------------------------------------------------------------

--- Configuration table for HTML preview.
---@class markview.config.html
---
---@field enable boolean Enable **HTML** rendering.
---
---@field container_elements markview.config.html.container_elements Configuration for container elements.
---@field headings markview.config.html.headings Configuration for headings(e.g. `<h1>`).
---@field void_elements markview.config.html.void_elements Configuration for void elements.

------------------------------------------------------------------------------

--[[ HTML `<container></container>` element config. ]]
---@class markview.config.html.container_elements
---
---@field enable boolean Enable rendering of container elements?
---@field [string] markview.config.html.container_elements.opts Configuration for `<string></string>`.


--- Configuration table for each container element type.
---@class markview.config.html.container_elements.opts
---
---@field closing_tag_offset? fun(range: integer[]): integer[] Modifies the closing `</tag>`'s range.
---@field node_offset? fun(range: integer[]): integer[] Modifies the element's range.
---@field opening_tag_offset? fun(range: integer[]): integer[] Modifies the opening `<tag>`'s range.
---
---@field on_closing_tag? table | fun(tag: table): table Extmark configuration to use on the closing `</tag>`.
---@field on_node? table Extmark configuration to use on the element.
---@field on_opening_tag? table Extmark configuration to use on the opening `<tag>`.

------------------------------------------------------------------------------

--- HTML heading config.
---@class markview.config.html.headings
---
---@field enable boolean Enable rendering of heading tags.
---@field [string] table Configuration for `<h[n]></h[n]>`.

------------------------------------------------------------------------------

--[[ HTML `<void>` element config. ]]
---@class markview.config.html.void_elements
---
---@field enable boolean Enable rendering of `<void>` elements.
---@field [string] markview.config.html.void_elements.opts Configuration for `<string>`.


--- Configuration table for a each void element type.
---@class markview.config.html.void_elements.opts
---
---@field node_offset? fun(range: integer[]): table Modifies the element's range.
---@field on_node table | fun(tag: markview.config.html.void_elements): table Extmark configuration to use on the element.

