---@meta


---@class markview.notify.deprecation
---
---@field option string
---
---@field ignore? boolean
---@field alter? string Alternative.
---@field tip? string Additional string.

---@class markview.notify.type_mismatch
---
---@field option string
---@field uses string
---@field got string

---@class markview.notify.hl
---
---@field group string
---@field value any
---@field message string

--- Tracing messages.
---@class markview.notify.trace
---
---@field level? integer
---@field message [ string, string? ][] | string
---@field indent? integer
---@field child_indent? integer


---@alias markview.notify.opts
---| markview.notify.deprecation
---| markview.notify.type_mismatch
---| markview.notify.hl
---| markview.notify.trace


---@class markview.health.log
---
---@field kind "deprecation" | "type_mismatch" | "hl" | "trace"
---@field ignore? boolean Should this be ignored?
---
---@field notification? [ string, string? ][] Virtual text style message to show.
---
---@field name? string Used for `deprecations`, name of the option/command/feature.
---@field alternative? string Used for `deprecations`, alternatives to use instead.
---@field tip? string Used for `deprecations`, additional tips to show.
---
---@field option? string Used for `type_mismatch`, option name for the type-mismatch.
---@field requires? string Used for `type_mismatch`, the required type.
---@field received? string Used for `type_mismatch`, the received type.
---
---@field group? string Used for `hl`, name of the highlight group.
---@field message? string Used for `hl`, The message to show.

