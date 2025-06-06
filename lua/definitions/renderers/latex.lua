---@meta

--- Configuration for LaTeX.
---@class markview.config.latex
---
---@field enable boolean
---
---@field blocks? markview.config.latex.blocks LaTeX blocks configuration(typically made with `$$...$$`).
---@field commands? markview.config.latex.commands LaTeX commands configuration(e.g. `\frac{x}{y}`).
---@field escapes? markview.config.latex.escapes LaTeX escaped characters configuration.
---@field fonts? markview.config.latex.fonts LaTeX fonts configuration(e.g. `\mathtt{}`).
---@field inlines? markview.config.latex.inlines Inline LaTeX configuration(typically made with `$...$`).
---@field parenthesis? markview.config.latex.parenthesis Configuration for hiding `{}`.
---@field subscripts? markview.config.latex.subscripts LaTeX subscript configuration(`_{}`, `_x`).
---@field superscripts? markview.config.latex.superscripts LaTeX superscript configuration(`^{}`, `^x`).
---@field symbols? markview.config.latex.symbols TeX math symbols configuration(e.g. `\alpha`).
---@field texts? markview.config.latex.texts Text block configuration(`\text{}`).

------------------------------------------------------------------------------

--- Configuration table for latex math blocks.
---@class markview.config.latex.blocks
---
---@field enable boolean
---
---@field hl? string
---@field pad_amount integer
---@field pad_char string
---
---@field text string
---@field text_hl? string

------------------------------------------------------------------------------

--- Configuration for LaTeX commands.
---@class markview.config.latex.commands
---
---@field enable boolean
---@field [string] markview.config.latex.commands.opts


---@class markview.config.latex.commands.opts
---
---@field condition? fun(item: markview.parsed.latex.commands): boolean Condition used to determine if a command is valid.
---
---@field command_offset? fun(range: integer[]): integer[] Modifies the command's range(`{ row_start, col_start, row_end, col_end }`).
---@field on_command? table Extmark configuration to use on the command.
---@field on_args? markview.config.latex.commands.arg_opts[]? Configuration table for each argument.

---@class markview.config.latex.commands.arg_opts
---
---@field after_offset? fun(range: integer[]): integer[] Modifies the range of the argument(only for `on_after`).
---@field before_offset? fun(range: integer[]): integer[] Modifies the range of the argument(only for `on_before`).
---@field condition? fun(item: table): boolean Can be used to change when the command preview is shown.
---@field content_offset? fun(range: integer[]): table Modifies the argument's range(only for `on_content`).
---@field on_after? table | fun(item: markview.parsed.latex.commands): table Extmark configuration to use at the end of the argument.
---@field on_before? table | fun(item: markview.parsed.latex.commands): table Extmark configuration to use at the start of the argument.
---@field on_content? table | fun(item: markview.parsed.latex.commands): table Extmark configuration to use on the argument.

------------------------------------------------------------------------------

--- Configuration table for latex escaped characters.
---@class markview.config.latex.escapes
---
---@field enable boolean Enables escaped character preview.
---@field hl? string Highlight group for the escaped character.

------------------------------------------------------------------------------

--- Configuration table for latex math fonts.
---@class markview.config.latex.fonts
---
---@field enable boolean
---
---@field default markview.config.latex.fonts.opts
---@field [string] markview.config.latex.fonts.opts


--- Configuration for a specific fonts.
---@class markview.config.latex.fonts.opts
---
---@field enable? boolean Whether to enable this font.
---@field hl? string | fun(buffer: integer, item: markview.parsed.latex.fonts): string? Highlight group for this font.

------------------------------------------------------------------------------

--- Configuration table for inline latex math.
---@class markview.config.latex.inlines
---
---@field enable boolean Enables preview of inline latex maths.
---
---@field corner_left? string Left corner.
---@field corner_left_hl? string Highlight group for left corner.
---@field corner_right? string Right corner.
---@field corner_right_hl? string Highlight group for right corner.
---@field hl? string Base Highlight group.
---@field padding_left? string Left padding.
---@field padding_left_hl? string Highlight group for left padding.
---@field padding_right? string Right padding.
---@field padding_right_hl? string Highlight group for right padding.

------------------------------------------------------------------------------

--- Configuration table for {}.
---@alias markview.config.latex.parenthesis { enable: boolean }

------------------------------------------------------------------------------

--- Configuration for subscripts.
---@class markview.config.latex.subscripts
---
---@field enable boolean Enables preview of subscript text.
---@field fake_preview? boolean When `true`, subscript characters are *faked*.
---@field hl? string | string[] Highlight group for the subscript text. Can be a list to use different hl for nested subscripts.

------------------------------------------------------------------------------

--- Configuration for superscripts.
---@class markview.config.latex.superscripts
---
---@field enable boolean Enables preview of superscript text.
---@field fake_preview? boolean When `true`, superscript characters are *faked*.
---@field hl? string | string[] Highlight group for the superscript text. Can be a list to use different hl for nested superscripts.

------------------------------------------------------------------------------

--- Configuration table for TeX math symbols.
---@class markview.config.latex.symbols
---
---@field enable boolean
---@field hl? string Highlight group for the symbols.

------------------------------------------------------------------------------

--- Configuration table for text.
---@alias markview.config.latex.texts { enable: boolean }

