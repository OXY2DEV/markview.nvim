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
---@field html markview.o.html
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

---•----------------
--- HTML
---•----------------

---@class markview.o.html HTML config table
---
---@field container_elements html.container_elements
---@field headings { enable: boolean, [string]: table }
---@field void_elements html.void_elements


---@class html.container_elements
---
---@field enable boolean
---@field [string] html.container_opts


---@class html.container_opts
---
---@field on_closing_tag? fun(item: { text: string, range: integer[] }):table|table
---@field closing_tag_offset? fun(range: integer[]):integer[]
---
---@field on_node? fun(item: __html.container_item):table|table
---@field node_offset? fun(range: integer[]):integer[]
---
---@field on_opening_tag? fun(item: { name: string, range: integer[] }):table|table
---@field opening_tag_offset? fun(range: integer[]): integer[]


---@class html.void_elements
---
---@field enable boolean
---@field [string] html.container_opts


---@class html.void_opts
---
---@field on_node? fun(item: __html.container_item):table|table
---@field node_offset? fun(range: integer[]):integer[]


 ------------------------------------------------------------------------------------------


---@class __html.container_item
---
---@field class "markview_container_element"
---@field closing_tag { text: string, range: integer[] }
---@field name string
---@field opening_tag { text: string, range: integer[] }
---@field text string[]
---@field range { row_start: integer, col_start: integer, row_end: integer, col_end: integer }


---@class __html.heading_item
---
---@field class "html_heading"
---@field level integer
---@field text string[]
---@field range { row_start: integer, col_start: integer, row_end: integer, col_end: integer }


---@class __html.void_item
---
---@field class "markview_void_element"
---@field name string
---@field text string[]
---@field range { row_start: integer, col_start: integer, row_end: integer, col_end: integer }

---•----------------
--- Markdown
---•----------------

---@class markview.o.markdown
---
---@field block_quotes markdown.block_quotes
---@field code_blocks markdown.code_blocks
---@field headings markdown.headings
---@field horizontal_rules markdown.horizontal_rules
---@field list_items markdown.list_items
---@field metadata_minus markdown.metadata
---@field metadata_plus markdown.metadata
---@field tables markdown.tables


---@class markdown.block_quotes
---
---@field enable boolean
---@field default block_quotes.opts
---@field [string] block_quotes.opts


---@class block_quotes.opts
---
---@field border? string | string[]
---@field border_hl? string | string[]
---
---@field hl? string
---
---@field icon? string
---@field icon_hl? string
---
---@field preview? string
---@field preview_hl? string
---
---@field title? boolean


---@class markdown.code_blocks
---
---@field hl? string
---@field icons "devicons" | "mini" | "internal" | nil
---@field info_hl? string
---@field language_direction "left" | "right"
---@field language_hl? string
---@field language_names? { [string]: string }
---@field min_width integer
---@field pad_amount integer
---@field pad_char string
---@field sign? boolean
---@field sign_hl? string
---@field style "simple" | "block"


---@class markdown.headings
---
---@field enable boolean
---
---@field heading_1 headings.atx
---@field heading_2 headings.atx
---@field heading_3 headings.atx
---@field heading_4 headings.atx
---@field heading_5 headings.atx
---@field heading_6 headings.atx
---
---@field setext_1 headings.setext
---@field setext_2 headings.setext


---@class headings.atx
---
---@field align? "left" | "center" | "right"
---@field corner_left? string
---@field corner_left_hl? string
---@field corner_right? string
---@field corner_right_hl? string
---@field hl? string
---@field icon? string
---@field icon_hl? string
---@field padding_left? string
---@field padding_left_hl? string
---@field padding_right? string
---@field padding_right_hl? string
---@field sign? string
---@field sign_hl? string
---@field style "simple" | "label" | "icon"


---@class headings.setext
---
---@field border? string
---@field border_hl? string
---@field hl? string
---@field icon? string
---@field icon_hl? string
---@field style "simple" | "decorated"


---@class markdown.horizontal_rules
---
---@field enable boolean
---@field parts (horizontal_rules.text | horizontal_rules.repeating)[]


---@class horizontal_rules.repeating
---
---@field direction "left" | "right"
---@field hl? string
---@field repeat_amount integer | fun(buffer: integer): integer
---@field text string
---@field type "repeating"


---@class horizontal_rules.text
---
---@field hl? string
---@field text string
---@field type "text"


---@class markdown.list_items
---
---@field enable boolean
---@field indent_size integer
---
---@field marker_dot? table
---@field marker_minus? table
---@field marker_parenthesis? table
---@field marker_plus? table
---@field marker_star? table
---
---@field shift_width integer


---@class list_items.unordered
---
---@field add_padding? boolean
---@field conceal_on_checkboxes? boolean
---@field hl? string
---@field text string


---@class list_items.ordered
---
---@field add_padding? boolean
---@field conceal_on_checkboxes? boolean


---@class markdown.metadata
---
---@field border_bottom? string
---@field border_bottom_hl? string
---@field border_hl? string
---@field border_top? string
---@field border_top_hl? string
---@field hl? string
---
---@field enable boolean


---@class markdown.tables
---
---@field block_decorator boolean
---@field enable boolean
---@field hl table
---@field parts table
---@field use_virt_lines boolean


---@class tables.parts
---
---@field top string[]
---@field header string[]
---@field separator string[]
---@field row string[]
---@field bottom string[]
---
---@field overlap string[]
---
---@field align_left string
---@field align_right string
---@field align_center [ string, string ]

--[[
--]]




