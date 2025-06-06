---@meta

--- Table containing various plugin states.
---@class markview.state
---
---@field enable boolean Should markview register new buffers?
---@field attached_buffers integer[] List of attached buffers.
---
---@field buffer_states { [integer]: { enable: boolean, hybrid_mode: boolean?, y: integer? } } Buffer local states.
---
---@field splitview_source? integer Source buffer for hybrid mode.
---@field splitview_buffer? integer Preview buffer for hybrid mode.
---@field splitview_window? integer Preview window for hybrid mode.


--- Configuration options for `markview.nvim`.
---@class markview.config
---
---@field experimental? markview.config.experimental
---@field preview? markview.config.preview
---@field renderers? table<string, function>
---
---@field html? markview.config.html
---@field latex? markview.config.latex
---@field markdown? markview.config.markdown
---@field markdown_inline? markview.config.markdown_inline
---@field typst? markview.config.typst
---@field yaml? markview.config.yaml


--- Options used for retrieving values from
--- the configuration table.
---@class markview.spec.get_opts
---
---@field fallback any Fallback value to return.
---
---@field eval? string[] Keys that should be evaluated(defaults to `vim.tbl_keys()`).
---@field eval_ignore? string[] Keys that shouldn't be evaluated.
---
---@field ignore_enable? boolean Whether to ignore `enable = false` when parsing config
---@field source? table Custom source config(defaults to `spec.config` when nil).
---
---@field eval_args? any[] Arguments used to evaluate the output value's keys.
---@field args? { __is_arg_list: boolean?, [integer]: any } Arguments used to parse the configuration table. Use `__is_arg_list = true` if nested configs use different arguments.


--- Maps a `node_type` to an option name.
---@class markview.renderer.option_maps
---
---@field html markview.renderer.option_map
---@field latex markview.renderer.option_map
---@field markdown markview.renderer.option_map
---@field markdown_inline markview.renderer.option_map
---@field typst markview.renderer.option_map
---@field yaml markview.renderer.option_map

---@alias markview.renderer.option_map table<string, string[]>


--- Tree-sitter node range.
---@class markview.parsed.range
---
---@field row_start integer
---@field row_end integer
---@field col_start integer
---@field col_end integer

------------------------------------------------------------------------------

---@class markview.config.__inline
---
---@field [string] any

