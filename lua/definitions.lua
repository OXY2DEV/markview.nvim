---@meta

---•------------
--- Internals
---•------------

---@class markview.cached_state Cached autocmds for buffers
---
---@field [integer] { redraw: integer, delete: integer, splitview: integer }


---@class markview.state Various plugin states.
---
--- Determines whether the plugin is enabled or not.
---@field enable boolean
---
--- Determines whether "hybrid mode" is enabled or not.
--- When `false`, hybrid mode is temporarily disabled.
---@field hybrid_mode boolean
---
--- Plugin states in different buffers.
--- Can be used to disable preview in specific buffers.
---@field buf_states { [integer]: boolean }
---
--- Hybrid mode states in different buffers.
--- Can be used to disable hybrid mode in specific buffers.
---@field buf_hybrid_states { [integer]: boolean }
---
---
--- When not `nil` represents the source buffer for "split view".
--- Should become `nil` when disabling "split view".
---@field split_source integer?
---
--- Buffer where the preview is shown.
--- It's text updates on every redraw cycle of the plugin.
---@field split_buffer integer?
---
--- Window where the preview is shown.
--- By default it's value is `nil`.
---@field split_window integer?

