---@meta

------------------------------------------------------------------------------------------

---@class markview.parsed.yaml.properties
---
---@field class "yaml_property"
---@field type "date" | "date_&_time" | "number" | "text" | "list" | "checkbox" | "nil" | "unknown"
---
---@field key string
---@field value string
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------------------

---@alias markview.parsed.yaml
---| markview.parsed.yaml.properties

---@class markview.parsed.yaml_sorted
---
---@field yaml_property markview.parsed.yaml.properties[]
