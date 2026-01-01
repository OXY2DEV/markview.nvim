---@meta

------------------------------------------------------------------------------

---@class markview.config.comment.tasks
---
---@field enable boolean
---
---@field default markview.config.comment.tasks.opts
---@field [string] markview.config.comment.tasks.opts


---@class markview.config.comment.tasks.opts markview.config.__inline
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

---@alias markview.config.comment.inline_codes markview.config.__inline
