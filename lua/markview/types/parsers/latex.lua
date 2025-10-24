---@meta


---@class markview.parsed.latex.blocks
---
---@field class "latex_block"
---@field marker string
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

--- LaTeX commands(must have at least 1 argument).
---@class markview.parsed.latex.commands
---
---@field class "latex_command"
---
---@field command { name: string, range: integer[] } Command name(without `\`) and it's range.
---@field args { text: string, range: integer[] }[] List of arguments(inside `{...}`) with their text & range.
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

--- Escaped characters.
---@class markview.parsed.latex.escapes
---
---@field class "latex_escaped"
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

--- Math fonts
---@class markview.parsed.latex.fonts
---
---@field class "latex_font"
---@field name string Font name.
---
---@field text string[]
---@field range markview.parsed.latex.fonts.range


---@class markview.parsed.latex.fonts.range
---
---@field row_start integer
---@field col_start integer
---@field row_end integer
---@field col_end integer
---
---@field font integer[] Range of the `\font` command.

------------------------------------------------------------------------------

--- Inline LaTeX(typically made using `$...$`).
---@class markview.parsed.latex.inlines
---
---@field class "latex_inlines"
---@field marker string
---
---@field closed boolean Is there a closing `$`?
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

--- {} in LaTeX.
---@class markview.parsed.latex.parenthesis
---
---@field class "latex_parenthesis"
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

--- Subscript text(e.g. _h, _{hi}, _{+} etc.).
---@class markview.parsed.latex.subscripts
---
---@field class "latex_subscript"
---
---@field parenthesis boolean Is the text within `{...}`?
---@field level integer Level of the subscript text. Used for handling nested subscript text.
---@field preview boolean Can the text be previewed?
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

--- Superscript text(e.g. ^h, ^{hi}, ^{+} etc.).
---@class markview.parsed.latex.superscripts
---
---@field class "latex_superscript"
---
---@field parenthesis boolean Is the text within `{...}`?
---@field level integer Level of the superscript text. Used for handling nested superscript text.
---@field preview boolean Can the text be previewed?
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

--- Math symbols in LaTeX(e.g. \Alpha).
---@class markview.parsed.latex.symbols
---
---@field class "latex_symbols"
---@field name string Symbol name(without the `\`).
---@field style "superscripts" | "subscripts" | nil Text styles to apply(if possible).
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

--- `\text{}` nodes.
---@class markview.parsed.latex.text
---
---@field class "latex_text"
---@field text string[]
---@field range markview.parsed.range


--- Groups of characters(without any spaces between them).
--- Used for applying fonts & text styles.
---@class markview.parsed.latex.word
---
---@field class "latex_word"
---
---@field text string[]
---@field range markview.parsed.range

------------------------------------------------------------------------------

---@alias markview.parsed.latex
---| markview.parsed.latex.blocks
---| markview.parsed.latex.commands
---| markview.parsed.latex.escapes
---| markview.parsed.latex.fonts
---| markview.parsed.latex.inlines
---| markview.parsed.latex.parenthesis
---| markview.parsed.latex.subscripts
---| markview.parsed.latex.superscripts
---| markview.parsed.latex.symbols
---| markview.parsed.latex.text
---| markview.parsed.latex.word

---@class markview.parsed.latex_sorted
---
---@field latex_block markview.parsed.latex.blocks[]
---@field latex_command markview.parsed.latex.commands[]
---@field latex_escaped markview.parsed.latex.escapes[]
---@field latex_font markview.parsed.latex.fonts[]
---@field latex_inlines markview.parsed.latex.inlines[]
---@field latex_parenthesis markview.parsed.latex.parenthesis[]
---@field latex_subscript markview.parsed.typst.subscripts[]
---@field latex_superscript markview.parsed.typst.superscripts[]
---@field latex_symbols markview.parsed.latex.symbols[]
---@field latex_text markview.parsed.latex.text[]
---@field latex_word markview.parsed.latex.word[]

