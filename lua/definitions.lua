---@meta

---------------------------------------------------------------
--- Configuration table
---------------------------------------------------------------

---@class markview.configuration configuration table for markview
---
---@field __inside_code_block boolean Experimental settings that stops rendering inside code blocks
---@field block_quotes markview.conf.block_quotes Block quote configuration
---@field buf_ignore? string[] Buffer types to ignore
---@field callbacks markview.conf.callbacks
---@field checkboxes markview.conf.checkboxes
---@field code_blocks markview.conf.code_blocks
---@field debounce number Time in miliseconds to wait before redrawing after an event
---@field escaped { enable: boolean } Configuration table for escaped characters
---@field filetypes string[] File types where the plugin is active
---@field footnotes markview.conf.footnotes
---@field headings markview.conf.headings
---@field highlight_groups? string | markview.conf.hl[] List of highlight groups
---@field horizontal_rules markview.conf.hrs
---@field html markview.conf.html
---@field hybrid_modes? string[] Modes where hybrid mode should be enabled
---@field initial_state boolean Whether to show the preview at start or not
---@field injections markview.conf.injections
---@field inline_codes markview.conf.inline_codes
---@field latex markview.conf.latex
---@field links markview.conf.links
---@field list_items markview.conf.list_items
---@field max_file_length? integer Maximum number of lines a file can have for it to be rendered entirely
---@field modes string[] Modes where the plugin will show preview
---@field render_distance integer Amount of lines(from the cursor) to render on large files
---@field split_conf table Window options for splitView
---@field tables markview.conf.tables

---------------------------------------------------------------
--- Configuration options table
---------------------------------------------------------------

--- Callbacks
---------------------------------------------------------------

---@class markview.conf.callbacks Callbacks run on various events
---
---@field on_enable fun(buf: integer, win: integer): nil
---@field on_disable fun(buf: integer, win: integer): nil
---@field on_mode_change fun(buf: integer, win: integer, mode: string): nil
---@field split_enter? fun(buf: integer, win: integer): nil

--- Block quotes
---------------------------------------------------------------

--- Configuration for callouts
---@class markview.block_quotes.callouts
---
---@field match_string string | string[] Patterns for this callout
---@field hl? string Primary highlight group
---@field preview string String to show instead of [!text]
---@field preview_hl? string Highlight group for callout_preview & custom_title
---@field title? boolean? When true, callouts can have titles
---@field icon? string? Icon for the title
---@field border string | string[] Text to use for the border
---@field border_hl? string | string[] Highlight group(s) for the border

--- Configuration table for block quotes, callouts & alerts
---@class markview.conf.block_quotes
---
---@field enable boolean
---@field default { border: string | string[], border_hl: string | string[] }
---@field callouts? markview.block_quotes.callouts[]

--- Checkbox
---------------------------------------------------------------

--- Configuration for custom checkboxes
---@class markview.checkboxes.conf
---
---@field match_string string | string[] Text inside [] to match for this checkbox style
---@field text string Text to show
---@field hl? string Highlight group for the text
---@field scope_hl? string Highlight group to add to the scope of a checkbox

--- Configuration table for checkboxes
---@class markview.conf.checkboxes
---
---@field enable boolean
---
---@field checked { text: string, hl: string?, scope_hl: string? } Configuration for checked checkboxes
---@field unchecked { text: string, hl: string?, scope_hl: string? } Configuration for unchecked checkboxes
---
---@field custom markview.checkboxes.conf[]

--- Code blocks
---------------------------------------------------------------

--- Configuration table for code blocks
---@class markview.conf.code_blocks
---
---@field enable boolean
---@field icons string Icon provider
---@field style "simple" | "block" Render style
---@field hl? string Highlight group for the code block
---@field info_hl? string Highlight group for the info string
---@field language_hl? string Highlight group for the language name
---
---@field min_width integer Minimum width of the code block
---@field pad_amount integer Width of left & right padding
---@field pad_char? string Character to use as padding
---
---@field language_direction "left" | "right" Direction of the language
---@field language_names? table<string, string>
---@field sign boolean When true, signs are shown
---@field sign_hl? string Highlight group for the sign

--- Footnotes
---------------------------------------------------------------

--- Configuration table for footnotes
---@class markview.conf.footnotes
---
---@field enable boolean
---@field superscript? boolean
---@field hl? string

--- Headings
---------------------------------------------------------------

---@class markview.headings.h
---
---@field style "simple" | "icon" | "label" Render style
---@field align? "left" | "center" | "right" Alignment for label styled headings
---@field hl? string Primary highlight group for the heading
---
---@field shift_char? string Text to use for shifting the icon
---@field shift_hl? string Highlight group for shift_char


---@class markview.h.simple
---
---@field style "simple" Render style
---@field hl? string Primary highlight group for the heading


---@class markview.h.label
---
---@field style "label" Render style
---@field align "left" | "center" | "right"
---@field hl? string Primary highlight group for the heading
---
---@field sign? string
---@field sign_hl? string
---
---@field icon? string
---@field icon_hl? string
---
---@field corner_left? string
---@field padding_left? string
---@field padding_right? string
---@field corner_right? string
---
---@field corner_left_hl? string
---@field padding_left_hl? string
---@field padding_right_hl? string
---@field corner_right_hl? string


---@class markview.h.icon
---
---@field style "icon" Render style
---@field hl? string Primary highlight group for the heading
---
---@field shift_char? string
---@field shift_hl? string
---
---@field sign? string
---@field sign_hl? string
---
---@field icon? string
---@field icon_hl? string

---@class markview.h.decorated
---
---@field style "decorated" Render style
---@field hl? string Primary highlight group for the heading
---
---@field sign? string
---@field sign_hl? string
---
---@field icon? string
---@field icon_hl? string
---
---@field border string
---@field border_hl? string

---@class markview.conf.headings
---
---@field enable boolean
---@field shift_width integer Number of spaces to add per heading level
---@field textoff? integer Default textoff value, affects alignment
---
---@field heading_1 (markview.h.simple | markview.h.label | markview.h.icon)
---@field heading_2 (markview.h.simple | markview.h.label | markview.h.icon)
---@field heading_3 (markview.h.simple | markview.h.label | markview.h.icon)
---@field heading_4 (markview.h.simple | markview.h.label | markview.h.icon)
---@field heading_5 (markview.h.simple | markview.h.label | markview.h.icon)
---@field heading_6 (markview.h.simple | markview.h.label | markview.h.icon)
---
---@field setext_1 (markview.h.simple | markview.h.decorated)
---@field setext_2 (markview.h.simple | markview.h.decorated)

--- Highlight groups
---------------------------------------------------------------

---@class markview.conf.hl
---
---@field group_name? string
---@field value? table
---
---@field output? fun(util: table): ({ group_name: string, value: table } | { group_name: string, value: table}[] | nil)

--- Horizontal rules
---------------------------------------------------------------

---@class markview.conf.hrs
---
---@field enable boolean
---@field parts (markview.hr.text | markview.hr.repeating)[]

--- Shows some text on the horizontal rule
---@class markview.hr.text
---
---@field type "text" Part type
---@field text string Text to show
---@field hl? string Highlight group for the text

--- Repeats provided text by the specified amount
---@class markview.hr.repeating
---
---@field type "repeating" Part type
---@field repeat_amount fun(buf: integer): integer | integer
---@field text string Text to repeat
---
---@field hl? string | string[] Highlight group for the text
---@field direction? "left" | "right" Direction from where to start adding hl

--- HTML
---------------------------------------------------------------

---@class markview.conf.html
---
---@field enable boolean
---
---@field tags markview.html.tags
---@field entities markview.html.entities

---@class markview.html.tags
---
---@field enable boolean
---
---@field default { conceal: boolean, hl: string }
---@field configs { [string]: { conceal: boolean, hl: string } }

---@class markview.html.entities
---
---@field enable boolean
---@field hl? string

--- Injections
---------------------------------------------------------------

---@class markview.conf.injections
---
---@field enable boolean
---@field languages? table<string, { enable: boolean?, overwrite: boolean?, query: string }>

--- Inline codes
---------------------------------------------------------------

---@class markview.conf.inline_codes
---
---@field enable boolean
---@field hl? string
---
---@field corner_left? string
---@field padding_left? string
---@field padding_right? string
---@field corner_right? string
---
---@field corner_left_hl? string
---@field padding_left_hl? string
---@field padding_right_hl? string
---@field corner_right_hl? string

--- LaTeX
---------------------------------------------------------------

---@class markview.conf.latex
---
---@field enable boolean
---@field brackets? markview.latex.brackets
---@field inline? { enable: boolean } Hides $...$ in inline latex
---@field block? markview.latex.block
---@field symbols? markview.latex.symbols
---@field operators? markview.latex.operators
---@field subscript? markview.latex.subscript
---@field superscript? markview.latex.superscript

---@class markview.latex.brackets
---
---@field enable boolean
---@field hl? string

---@class markview.latex.block
---
---@field enable boolean
---
---@field pad_amount? integer
---@field text? [ string, string? ]
---@field hl? string

---@class markview.latex.symbols
---
---@field enable boolean
---@field overwrite? table<string, string>
---@field groups? { match: (string[] | fun(txt: string): boolean), hl: string? }[]
---@field hl? string

---@class markview.latex.operators
---
---@field enable boolean
---@field configs table<string, markview.operators.config>

---@class markview.operators.config
---
---@field operator? table
---@field args? (table | nil)[]

---@class markview.latex.superscript
---
---@field enable boolean
---@field hl? string
---@field conceal_brackets? boolean

---@class markview.latex.subscript
---
---@field enable boolean
---@field hl? string
---@field conceal_brackets? boolean

--- Links
---------------------------------------------------------------

---@class markview.conf.links
---
---@field enable boolean
---
---@field hyperlinks markview.links.config
---@field internal_links markview.links.config
---@field images markview.links.config
---@field emails markview.links.config

---@class markview.links.config
---
---@field enable boolean
---
---@field hl? string
---
---@field icon string
---@field icon_hl? string
---
---@field corner_left? string
---@field padding_left? string
---@field padding_right? string
---@field corner_right? string
---
---@field corner_left_hl? string
---@field padding_left_hl? string
---@field padding_right_hl? string
---@field corner_right_hl? string
---
---@field custom? markview.links.custom[]

---@class markview.links.custom
---
---@field match_string string
---
---@field icon? string
---@field hl? string
---
---@field corner_left? string
---@field padding_left? string
---@field padding_right? string
---@field corner_right? string
---
---@field corner_left_hl? string
---@field padding_left_hl? string
---@field padding_right_hl? string
---@field corner_right_hl? string

--- List items
---------------------------------------------------------------

---@class markview.conf.list_items
---
---@field enable boolean
---
---@field indent_size integer
---@field shift_width integer
---
---@field marker_plus markview.list_items.item
---@field marker_minus markview.list_items.item
---@field marker_star markview.list_items.item
---
---@field marker_dot { add_padding: boolean }
---@field marker_parenthesis { add_padding: boolean }

---@class markview.list_items.item
---
---@field add_padding boolean
---@field text string
---@field hl? string

--- Tables
---------------------------------------------------------------

---@class markview.tables.parts
---
---@field top string[]
---@field header string[]
---@field separator string[]
---@field row string[]
---@field bottom string[]
---@field overlap string[]
---
---@field align_left string
---@field align_right string
---@field align_center [ string, string ]

---@class markview.conf.tables
---
---@field enable boolean
---@field block_decorator boolean
---@field use_virt_lines boolean
---@field col_min_width? integer
---
---@field parts markview.tables.parts
---@field hls? markview.tables.parts

-- vim:nospell:
