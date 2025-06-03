---@meta

--- Configuration for LaTeX.
---@class config.latex
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


-- [ LaTeX | LaTeX blocks ] ---------------------------------------------------------------

--- Configuration table for latex math blocks.
---@class markview.config.latex.blocks
---
---@field enable boolean
---
---@field hl? string
---@field pad_amount integer
---@field pad_char string
---
---@field text string | fun(buffer: integer, item: __latex.blocks): string
---@field text_hl? string

-- [ LaTeX | LaTeX blocks > Parameters ] --------------------------------------------------

---@class __latex.blocks
---
---@field class "latex_block"
---@field marker string
---
---@field text string[]
---@field range node.range


--- Configuration for LaTeX commands.
---@class markview.config.latex.commands
---
---@field enable boolean
---@field [string] commands.opts | fun(buffer: integer, item: __latex.commands): commands.opts


---@class commands.opts
---
---@field condition? fun(item: __latex.commands): boolean Condition used to determine if a command is valid.
---
---@field command_offset? fun(range: integer[]): integer[] Modifies the command's range(`{ row_start, col_start, row_end, col_end }`).
---@field on_command? config.extmark | fun(tag: table): config.extmark Extmark configuration to use on the command.
---@field on_args? commands.arg_opts[]? Configuration table for each argument.

---@class commands.arg_opts
---
---@field after_offset? fun(range: integer[]): integer[] Modifies the range of the argument(only for `on_after`).
---@field before_offset? fun(range: integer[]): integer[] Modifies the range of the argument(only for `on_before`).
---@field condition? fun(item: table): boolean Can be used to change when the command preview is shown.
---@field content_offset? fun(range: integer[]): table Modifies the argument's range(only for `on_content`).
---@field on_after? config.extmark | fun(tag: table): config.extmark Extmark configuration to use at the end of the argument.
---@field on_before? config.extmark | fun(tag: table): config.extmark Extmark configuration to use at the start of the argument.
---@field on_content? config.extmark | fun(tag: table): config.extmark Extmark configuration to use on the argument.

--- LaTeX commands(must have at least 1 argument).
---@class __latex.commands
---
---@field class "latex_command"
---
---@field command { name: string, range: integer[] } Command name(without `\`) and it's range.
---@field args { text: string, range: integer[] }[] List of arguments(inside `{...}`) with their text & range.
---
---@field text string[]
---@field range node.range


--- Configuration table for latex escaped characters.
---@class latex.escapes
---
---@field enable boolean Enables escaped character preview.
---@field hl? string Highlight group for the escaped character.


--- Escaped characters.
---@class __latex.escapes
---
---@field class "latex_escaped"
---
---@field text string[]
---@field range node.range


--- Configuration table for latex math fonts.
---@class markview.config.latex.fonts
---
---@field enable boolean
---
---@field default fonts.opts
---@field [string] fonts.opts


--- Configuration for a specific fonts.
---@class fonts.opts
---
---@field enable? boolean Whether to enable this font.
---@field hl? string | fun(buffer: integer, item: __latex.fonts): string? Highlight group for this font.


--- Math fonts
---@class __latex.fonts
---
---@field class "latex_font"
---
---@field name string Font name.
---
---@field text string[]
---@field range node.range


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

--- Inline LaTeX(typically made using `$...$`).
---@class __latex.inlines
---
---@field class "latex_inlines"
---@field marker string
---
---@field closed boolean Is there a closing `$`?
---@field text string[]
---@field range node.range


--- Configuration table for {}.
---@alias latex.parenthesis { enable: boolean }

--- {} in LaTeX.
---@class __latex.parenthesis
---
---@field class "latex_parenthesis"
---@field text string[]
---@field range node.range


--- Configuration for subscripts.
---@class latex.subscripts
---
---@field enable boolean Enables preview of subscript text.
---@field fake_preview? boolean When `true`, subscript characters are *faked*.
---@field hl? string | string[] Highlight group for the subscript text. Can be a list to use different hl for nested subscripts.

--- Subscript text(e.g. _h, _{hi}, _{+} etc.).
---@class __latex.subscripts
---
---@field class "latex_subscript"
---
---@field parenthesis boolean Is the text within `{...}`?
---@field level integer Level of the subscript text. Used for handling nested subscript text.
---@field preview boolean Can the text be previewed?
---
---@field text string[]
---@field range node.range


--- Configuration for superscripts.
---@class latex.superscripts
---
---@field enable boolean Enables preview of superscript text.
---@field fake_preview? boolean When `true`, superscript characters are *faked*.
---@field hl? string | string[] Highlight group for the superscript text. Can be a list to use different hl for nested superscripts.

--- Superscript text(e.g. ^h, ^{hi}, ^{+} etc.).
---@class __latex.superscripts
---
---@field class "latex_superscript"
---
---@field parenthesis boolean Is the text within `{...}`?
---@field level integer Level of the superscript text. Used for handling nested superscript text.
---@field preview boolean Can the text be previewed?
---
---@field text string[]
---@field range node.range


--- Configuration table for TeX math symbols.
---@class markview.config.latex.symbols
---
---@field enable boolean
---@field hl? string Highlight group for the symbols.

--- Math symbols in LaTeX(e.g. \Alpha).
---@class __latex.symbols
---
---@field class "latex_symbols"
---@field name string Symbol name(without the `\`).
---@field style "superscripts" | "subscripts" | nil Text styles to apply(if possible).
---
---@field text string[]
---@field range node.range


--- Configuration table for text.
---@alias latex.texts { enable: boolean }

--- `\text{}` nodes.
---@class __latex.text
---
---@field class "latex_text"
---@field text string[]
---@field range node.range


--- Groups of characters(without any spaces between them).
--- Used for applying fonts & text styles.
---@class __latex.word
---
---@field class "latex_word"
---
---@field text string[]
---@field range node.range

