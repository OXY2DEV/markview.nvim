---@meta

--- Table containing various plugin states.
---@class markview.state
---
---@field enable boolean Should markview register new buffers?
---@field attached_buffers integer[] List of attached buffers.
---
---@field buffer_states table<integer, markview.state.buf> Buffer local states.
---
---@field splitview_source? integer Source buffer for hybrid mode.
---@field splitview_buffer? integer Preview buffer for hybrid mode.
---@field splitview_window? integer Preview window for hybrid mode.
---
---@field modified_queries boolean Has the `markdown` been modified?


--[[ Buffer state for `markview.nvim`. ]]
---@class markview.state.buf
---
---@field enable boolean Is the `preview` enabled?
---@field hybrid_mode boolean Is `hybrid_mode` enabled?


--- Configuration options for `markview.nvim`.
---@class markview.config
---
---@field experimental? markview.config.experimental
---@field html? markview.config.html
---@field latex? markview.config.latex
---@field markdown? markview.config.markdown
---@field markdown_inline? markview.config.markdown_inline
---@field preview? markview.config.preview
---@field renderers? table<string, function>
---@field typst? markview.config.typst
---@field yaml? markview.config.yaml


--[[ Sub-commands for `markview.nvim`. ]]
---@class markview.commands
---
---@field Start fun(): nil Starts `markview`.
---@field Stop fun(): nil Starts `markview`.
---
---@field disable fun (buffer: integer?): nil Disables `preview` for `buffer`.
---@field enable fun (buffer: integer?): nil Enables `preview` for `buffer`.
---@field toggle fun (buffer: integer?): nil Toggles `preview` for `buffer`.
---
---@field Disable fun (): nil Disables `preview` for all *attached* buffers.
---@field Enable fun (): nil Enables `preview` for all *attached* buffers.
---@field Toggle fun (): nil Toggles `preview` for all *attached* buffers.
---
---@field attach fun (buffer: integer?): nil Attaches `markview` to `buffer`.
---@field detach fun (buffer: integer?): nil Detaches `markview` from `buffer`.
---
---
---@field clear fun (buffer: integer?): nil Clears previews in `buffer`.
---@field render fun (buffer: integer?): nil Renders previews in `buffer`.
---
---@field Clear fun (): nil Clears previews in all *attached* buffers.
---@field Render fun (): nil Renders previews in all *attached* buffers.
---
---
---@field hybridDisable fun (buffer: integer?): nil Disables `hybrid mode`(if enabled) for `buffer`. NOTE: Needs `config.preview.hybrid_modes` to be set.
---@field hybridEnable fun (buffer: integer?): nil Enables `hybrid mode`(if disables) for `buffer`. NOTE: Needs `config.preview.hybrid_modes` to be set.
---@field hybridToggle fun (buffer: integer?): nil Toggles `hybrid mode` for `buffer`. NOTE: Needs `config.preview.hybrid_modes` to be set.
---
---@field HybridDisable fun (buffer: integer?): nil Disables `hybrid mode`(if enabled). NOTE: Needs `config.preview.hybrid_modes` to be set.
---@field HybridEnable fun (buffer: integer?): nil Enables `hybrid mode`(if disables). NOTE: Needs `config.preview.hybrid_modes` to be set.
---@field HybridToggle fun (buffer: integer?): nil Toggles `hybrid mode`. NOTE: Needs `config.preview.hybrid_modes` to be set.
---
---@field linewiseDisable fun (): nil Disables `linewise hybrid mode`(if enabled). NOTE: Needs `config.preview.hybrid_modes` to be set.
---@field linewiseEnable fun (): nil Enables `linewise hybrid mode`(if disables). NOTE: Needs `config.preview.hybrid_modes` to be set.
---@field linewiseToggle fun (): nil Toggles `linewise hybrid mode`. NOTE: Needs `config.preview.hybrid_modes` to be set.









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
---@field enable? boolean Only valid if it's a top level option, Used for disabling previews.
---@field virtual? boolean In `inline_codes`, when `true` masks the text with a virtual text(useful if the line has a background).
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
---
---@field padding_right? string Right padding.
---@field padding_right_hl? string Highlight group for the right padding.
---
---@field corner_right? string Right corner(added after `padding_right`).
---@field corner_right_hl? string Highlight group for the right corner.
---
---
---
---@field block_hl? string Only for `block_references`, highlight group for the block name.
---@field file_hl? string Only for `block_references`, highlight group for the file name.

