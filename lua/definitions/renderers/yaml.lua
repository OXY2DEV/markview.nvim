---@meta

------------------------------------------------------------------------------------------

--- Configuration for YAML.
---@class markview.config.yaml
---
---@field enable boolean
---@field properties markview.config.yaml.properties


--- Configuration for YAML properties.
---@class markview.config.yaml.properties
---
---@field enable boolean
---
---@field data_types { [string]: markview.config.yaml.properties.opts } Configuration for various data types.
---
---@field default markview.config.yaml.properties.opts Default configuration for properties.
---@field [string] markview.config.yaml.properties.opts Configuration for properties whose name matches `string`.


---@class markview.config.yaml.properties.opts
---
---@field border_bottom? string Scope guide border bottom.
---@field border_bottom_hl? string
---
---@field border_hl? string
---
---@field border_middle? string Scope guide border middle.
---@field border_middle_hl? string
---
---@field border_top? string Scope guide border top.
---@field border_top_hl? string
---
---@field hl? string
---@field text? string
---
---@field use_types? boolean When `true`, the configuration table merges with the value's data type configuration.

