---@meta

------------------------------------------------------------------------------

--- A `task`.
---@class markview.parsed.doctext.tasks
---
---@field class "doctext_task"
---
---@field kind string Type of task(e.g. `feat`, `TODO` etc.)
---@field text string
---@field range markview.parsed.doctext.tasks.range


---@class markview.parsed.doctext.tasks.range
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


--- An issue reference.
---@class markview.parsed.doctext.issues
---
---@field class "doctext_issue"
---
---@field text string
---@field range markview.parsed.range


--- A mention.
---@class markview.parsed.doctext.mentions
---
---@field class "doctext_mention"
---
---@field text string
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@alias markview.parsed.doctext
---| markview.parsed.doctext.tasks
