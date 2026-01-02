---@meta

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

--- An issue reference.
---@class markview.parsed.comment.issues
---
---@field class "comment_issue"
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
---| markview.parsed.comment.tasks


---@class markview.parsed.comment_sorted
---
---@field tasks markview.parsed.comment.tasks[]

