---@meta

------------------------------------------------------------------------------

--[[
An autolink.

```comment
<hello>
```
]]
---@class markview.parsed.comment.autolinks
---
---@field class "comment_autolink"
---@field destination string Text between `<>`.
---
---@field text string
---@field range markview.parsed.range

------------------------------------------------------------------------------

--- A `task`.
---@class markview.parsed.comment.tasks
---
---@field class "comment_task"
---
---@field kind string Type of task(e.g. `feat`, `TODO` etc.)
---@field text string
---@field range markview.parsed.comment.tasks.range


---@class markview.parsed.comment.tasks.range
---
---@field label_row_end? integer End row of a label(A label may be like `foo:`, `bar(topic):`).
---@field label_col_end? integer End column of a label(A label may be like `foo:`, `bar(topic):`).
---
---@field kind integer[] Range of the `task kind`(result of `{ TSNode:range() }`).
---
---@field row_start integer
---@field row_end integer
---@field col_start integer
---@field col_end integer

------------------------------------------------------------------------------

--- A `task` scope.
---@class markview.parsed.comment.task_scopes
---
---@field class "comment_task_scopes"
---
---@field text string
---@field range markview.parsed.comment.tasks.range

------------------------------------------------------------------------------

--- An issue reference.
---@class markview.parsed.comment.issues
---
---@field class "comment_issue"
---
---@field text string
---@field range markview.parsed.range

------------------------------------------------------------------------------

--- An URL.
---@class markview.parsed.comment.urls
---
---@field class "comment_url"
---@field destination string
---
---@field text string
---@field range markview.parsed.range

------------------------------------------------------------------------------

--- A taglink.
---@class markview.parsed.comment.taglinks
---
---@field class "comment_taglink"
---
---@field text string
---@field range markview.parsed.range

------------------------------------------------------------------------------

--- A mention.
---@class markview.parsed.comment.mentions
---
---@field class "comment_mention"
---
---@field text string
---@field range markview.parsed.range

------------------------------------------------------------------------------

--- A mention.
---@class markview.parsed.comment.inline_codes
---
---@field class "comment_inline_code"
---
---@field text string
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@class markview.parsed.comment.code_blocks
---
---@field class "markdown_code_block"
---@field uses_tab boolean Does the code block use tab inside it? Used for switching render style.
---
---@field delimiters [ string, string ] Code block delimiters(```).
---@field language string? Language string(typically after ```).
---@field info_string string? Extra information(typically after the language).
---
---@field text string[]
---@field range markview.parsed.comment.code_blocks.range


---@class markview.parsed.comment.code_blocks.range
---
---@field start_delim integer[] Range of the **start** delimiter.
---@field end_delim? integer[] Range of the **end** delimiter.
---
---@field row_start integer
---@field row_end integer
---@field col_start integer
---@field col_end integer
---
---@field language? integer[] Range of the language string.
---@field info_string? integer[] Range of info string.

------------------------------------------------------------------------------

---@alias markview.parsed.comment
---| markview.parsed.comment.autolinks
---| markview.parsed.comment.code_blocks
---| markview.parsed.comment.inline_codes
---| markview.parsed.comment.issues
---| markview.parsed.comment.mentions
---| markview.parsed.comment.taglinks
---| markview.parsed.comment.tasks
---| markview.parsed.comment.task_scopes
---| markview.parsed.comment.urls


---@class markview.parsed.comment_sorted
---
---@field autolinks markview.parsed.comment.autolinks[]
---@field code_blocks markview.parsed.comment.code_blocks[]
---@field inline_codes markview.parsed.comment.inline_codes[]
---@field issues markview.parsed.comment.issues[]
---@field mentions markview.parsed.comment.mentions[]
---@field taglinks markview.parsed.comment.taglinks[]
---@field tasks markview.parsed.comment.tasks[]
---@field task_scopes markview.parsed.comment.task_scopes[]
---@field urls markview.parsed.comment.urls[]

