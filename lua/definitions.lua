---@meta

---•------------
--- Internals
---•------------

---@class markview.cached_state Cached autocmds for buffers
---
---@field [integer] { redraw: integer, delete: integer, splitview: integer }


---@class markview.states Various plugin states.
---
--- Stores autocmd IDs.
---@field autocmds { [string]: table }
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
---@field buffer_states { [integer]: boolean }
---
--- Hybrid mode states in different buffers.
--- Can be used to disable hybrid mode in specific buffers.
---@field hybrid_states { [integer]: boolean }
---
---
--- When not `nil` represents the source buffer for "split view".
--- Should become `nil` when disabling "split view".
---@field splitview_source integer?
---
--- Buffer where the preview is shown.
--- It's text updates on every redraw cycle of the plugin.
---@field splitview_buffer integer?
---
--- Window where the preview is shown.
--- By default it's value is `nil`.
---@field splitview_window integer?

---•----------------
--- Configuration
---•----------------

---@class markview.configuration Configuration table for `markview.nvim`.
---
---@field highlight_groups table
---@field renderers table
---
---@field experimental markview.o.experimental
---@field preview markview.o.preview
---
---@field html table
---@field latex table
---@field markdown table
---@field markdown_inline table
---@field typst table
---@field yaml table

---@class markview.o.experimental
---
---@field file_byte_read integer
---@field list_empty_line_tolerance integer
---@field text_filetypes string[]?

---@class markview.o.preview
---
---@field enable_preview_on_attach boolean
---@field callbacks { [string]: function }
---@field debounce integer
---@field edit_distance [integer, integer]
---@field hybrid_modes string[]
---@field ignore_buftypes string[]
---@field ignore_node_classes table
---@field max_file_length integer
---@field render_distance integer
---@field splitview_winopts table





















