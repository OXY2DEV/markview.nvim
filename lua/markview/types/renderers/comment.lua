---@meta

------------------------------------------------------------------------------

--[[ Configuration for `comments`. ]]
---@class markview.config.comment
---
---@field enable boolean Enable **comment** rendering.
---
---@field autolinks markview.config.comment.autolinks
---@field code_blocks markview.config.comment.code_blocks
---@field inline_codes markview.config.comment.inline_codes
---@field issues markview.config.comment.issues
---@field mentions markview.config.comment.mentions
---@field taglinks markview.config.comment.taglinks
---@field tasks markview.config.comment.tasks
---@field urls markview.config.comment.urls

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

------------------------------------------------------------------------------

--- Configuration for code blocks.
---@alias markview.config.comment.code_blocks
---| markview.config.comment.code_blocks.simple
---| markview.config.comment.code_blocks.block


---@class markview.config.comment.code_blocks.simple
---
---@field enable boolean Enable rendering of code blocks.
---
---@field border_hl? string Highlight group for borders.
---@field info_hl? string Highlight group for the info string.
---
---@field label_direction? "left" | "right" Position of the language & icon.
---@field label_hl? string Highlight group for the label.
---
---@field sign? boolean Enables signs for the code block?
---@field sign_hl? string Highlight group for the sign.
---
---@field style "simple" Only highlights the line. Enabled when `wrap` is enabled.
---
---@field default markview.config.comment.code_blocks.opts
---@field [string] markview.config.comment.code_blocks.opts


---@class markview.config.comment.code_blocks.block
---
---@field enable boolean Enable rendering of code blocks.
---
---@field border_hl? string Highlight group for borders.
---@field info_hl? string Highlight group for the info string.
---
---@field label_direction? "left" | "right" Position of the language & icon.
---@field label_hl? string Highlight group for the label.
---
---@field min_width? integer Minimum width of the code block.
---@field pad_amount? integer Number of `pad_char`s to add on the left & right side of the code block.
---@field pad_char? string Character used as padding.
---
---@field sign? boolean Enables signs for the code block?
---@field sign_hl? string Highlight group for the sign.
---
---@field style "block" Creates a block around the code block. Disabled when `wrap` is enabled.
---
---@field default markview.config.comment.code_blocks.opts
---@field [string] markview.config.comment.code_blocks.opts


--[[ Configuration for highlighting `lines` inside a code block. ]]
---@class markview.config.comment.code_blocks.opts
---
---@field block_hl
---| string Highlight group for the background of the line.
---| fun(buffer: integer, line: string): string? Takes `line` & the `buffer` containing it and returns a highlight group for the line.
---@field pad_hl
---| string Highlight group for the padding of the line.
---| fun(buffer: integer, line: string): string? Takes `line` & the `buffer` containing it and returns a highlight group for the padding..

------------------------------------------------------------------------------

--- Configuration for issues.
---@class markview.config.comment.issues
---
---@field enable boolean Enable rendering of `#issue`s.
---
---@field default markview.config.__inline Default configuration for issues.
---@field [string] markview.config.__inline Configuration for issues whose text matches with the key's pattern.

------------------------------------------------------------------------------

--- Configuration for mentions.
---@class markview.config.comment.mentions
---
---@field enable boolean Enable rendering of `@mention`s.
---
---@field default markview.config.__inline Default configuration for mentions.
---@field [string] markview.config.__inline Configuration for mentions whose text matches with the key's pattern.

------------------------------------------------------------------------------

--- Configuration for URLs.
---@class markview.config.comment.urls
---
---@field enable boolean Enable rendering of `URL`s.
---
---@field default markview.config.__inline Default configuration for URLs.
---@field [string] markview.config.__inline Configuration for URLs whose text matches with the key's pattern.


------------------------------------------------------------------------------

--- Configuration for taglinks.
---@class markview.config.comment.taglinks
---
---@field enable boolean Enable rendering of `|taglink|`s.
---
---@field default markview.config.__inline Default configuration.
---@field [string] markview.config.__inline Configuration for taglinks matching the key's pattern.

------------------------------------------------------------------------------

--- Configuration for autolinks.
---@class markview.config.comment.autolinks
---
---@field enable boolean Enable rendering of `<autolink>`s.
---
---@field default markview.config.__inline Default configuration.
---@field [string] markview.config.__inline Configuration for autolinks matching the key's pattern.

