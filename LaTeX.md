<!--markdoc
    {
        "generic": {
            "filename": "../doc/markview.nvim-latex.txt",
            "force_write": true,
            "header": {
                "desc": "🧩 LaTeX options for `markview.nvim`",
                "tag": "markview.nvim-latex"
            }
        },
        "markdown": {
            "heading_ratio": [ 26, 54 ],
            "list_items": {
                "marker_minus": "◆",
                "marker_plus": "◇"
            },
            "tags": {
                "enable": [ "markview.nvim-latex.enable" ],
                "blocks": [ "markview.nvim-latex.blocks" ],
                "commands": [ "markview.nvim-latex.commands" ],
                "escapes": [ "markview.nvim-latex.escapes" ],
                "fonts": [ "markview.nvim-latex.fonts" ],
                "inlines": [ "markview.nvim-latex.inlines" ],
                "parenthesis": [ "markview.nvim-latex.parenthesis" ],
                "subscripts": [ "markview.nvim-latex.subscripts" ],
                "superscripts": [ "markview.nvim-latex.superscripts" ],
                "symbols": [ "markview.nvim-latex.symbols" ],
                "texts": [ "markview.nvim-latex.texts" ]
            }
        }
    }
-->
<!--markdoc_ignore_start-->
# 🧩 LaTeX
<!--markdoc_ignore_end-->

```lua from: ../lua/markview/types/renderers/latex.lua class: markview.config.latex
--- Configuration for LaTeX.
---@class markview.config.latex
---
---@field enable boolean Enable **LaTeX** rendering.
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
```

## enable

```lua
enable = true
```

## blocks

```lua from: ../lua/markview/types/renderers/latex.lua class: markview.config.latex.blocks
--- Configuration table for latex math blocks.
---@class markview.config.latex.blocks
---
---@field enable boolean Enable rendering of `LaTeX blocks`.
---
---@field hl? string Highlight group for the block.
---@field pad_amount integer Number of `pad_char`s to add before each line.
---@field pad_char string Character to use as padding.
---
---@field text string Label text shown on the top right side.
---@field text_hl? string Highlight group for the label.
```

Enables rendering of multiline LaTeX blocks.

```lua
blocks = {
    enable = true,

    hl = "MarkviewCode",
    pad_char = " ",
    pad_amount = 3,

    text = "  LaTeX ",
    text_hl = "MarkviewCodeInfo"
},
```

## commands

```lua from: ../lua/markview/types/renderers/latex.lua class: markview.config.latex.commands
--- Configuration for LaTeX commands.
---@class markview.config.latex.commands
---
---@field enable boolean Enables rendering of LaTeX commands.
---@field [string] markview.config.latex.commands.opts Options for `\string` command.
```

Changes how LaTeX commands are shown.

```lua
--- Creates a configuration table for a LaTeX command.
---@param name string Command name(Text to show).
---@param text_pos? "overlay" | "inline" `virt_text_pos` extmark options.
---@param cmd_conceal? integer Characters to conceal.
---@param cmd_hl? string Highlight group for the command.
---@return markview.config.latex.commands.opts
local operator = function (name, text_pos, cmd_conceal, cmd_hl)
	return {
		condition = function (item)
			return #item.args == 1;
		end,

		on_command = function (item)
			local symbols = require("markview.symbols");

			return {
				end_col = item.range[2] + (cmd_conceal or 1),
				conceal = "",

				virt_text_pos = text_pos or "overlay",
				virt_text = {
					{ symbols.tostring("default", name), cmd_hl or "@keyword.function" }
				},

				hl_mode = "combine"
			}
		end,

		on_args = {
			{
				on_before = function (item)
					return {
						end_col = item.range[2] + 1,

						virt_text_pos = "overlay",
						virt_text = {
							{ "(", "@punctuation.bracket" }
						},

						hl_mode = "combine"
					}
				end,

				after_offset = function (range)
					return { range[1], range[2], range[3], range[4] - 1 };
				end,

				on_after = function (item)
					return {
						end_col = item.range[4],

						virt_text_pos = "overlay",
						virt_text = {
							{ ")", "@punctuation.bracket" }
						},

						hl_mode = "combine"
					}
				end
			}
		}
	};
end

commands = {
    enable = true,

    ["boxed"] = {
        condition = function (item)
            return #item.args == 1;
        end,
        on_command = {
            conceal = ""
        },

        on_args = {
            {
                on_before = function (item)
                    return {
                        end_col = item.range[2] + 1,
                        conceal = "",

                        virt_text_pos = "inline",
                        virt_text = {
                            { " ", "MarkviewPalette4Fg" },
                            { "[", "@punctuation.bracket.latex" }
                        },

                        hl_mode = "combine"
                    }
                end,

                after_offset = function (range)
                    return { range[1], range[2], range[3], range[4] - 1 };
                end,
                on_after = function (item)
                    return {
                        end_col = item.range[4],
                        conceal = "",

                        virt_text_pos = "inline",
                        virt_text = {
                            { "]", "@punctuation.bracket" }
                        },

                        hl_mode = "combine"
                    }
                end
            }
        }
    },
    ["frac"] = {
        condition = function (item)
            return #item.args == 2;
        end,
        on_command = {
            conceal = ""
        },

        on_args = {
            {
                on_before = function (item)
                    return {
                        end_col = item.range[2] + 1,
                        conceal = "",

                        virt_text_pos = "inline",
                        virt_text = {
                            { "(", "@punctuation.bracket" }
                        },

                        hl_mode = "combine"
                    }
                end,

                after_offset = function (range)
                    return { range[1], range[2], range[3], range[4] - 1 };
                end,
                on_after = function (item)
                    return {
                        end_col = item.range[4],
                        conceal = "",

                        virt_text_pos = "inline",
                        virt_text = {
                            { ")", "@punctuation.bracket" },
                            { " ÷ ", "@keyword.function" }
                        },

                        hl_mode = "combine"
                    }
                end
            },
            {
                on_before = function (item)
                    return {
                        end_col = item.range[2] + 1,
                        conceal = "",

                        virt_text_pos = "inline",
                        virt_text = {
                            { "(", "@punctuation.bracket" }
                        },

                        hl_mode = "combine"
                    }
                end,

                after_offset = function (range)
                    return { range[1], range[2], range[3], range[4] - 1 };
                end,
                on_after = function (item)
                    return {
                        end_col = item.range[4],
                        conceal = "",

                        virt_text_pos = "inline",
                        virt_text = {
                            { ")", "@punctuation.bracket" },
                        },

                        hl_mode = "combine"
                    }
                end
            },
        }
    },

    ["vec"] = {
        condition = function (item)
            return #item.args == 1;
        end,
        on_command = {
            conceal = ""
        },

        on_args = {
            {
                on_before = function (item)
                    return {
                        end_col = item.range[2] + 1,
                        conceal = "",

                        virt_text_pos = "inline",
                        virt_text = {
                            { "󱈥 ", "MarkviewPalette2Fg" },
                            { "(", "@punctuation.bracket.latex" }
                        },

                        hl_mode = "combine"
                    }
                end,

                after_offset = function (range)
                    return { range[1], range[2], range[3], range[4] - 1 };
                end,
                on_after = function (item)
                    return {
                        end_col = item.range[4],
                        conceal = "",

                        virt_text_pos = "inline",
                        virt_text = {
                            { ")", "@punctuation.bracket" }
                        },

                        hl_mode = "combine"
                    }
                end
            }
        }
    },

    ["sin"] = operator("sin"),
    ["cos"] = operator("cos"),
    ["tan"] = operator("tan"),

    ["sinh"] = operator("sinh"),
    ["cosh"] = operator("cosh"),
    ["tanh"] = operator("tanh"),

    ["csc"] = operator("csc"),
    ["sec"] = operator("sec"),
    ["cot"] = operator("cot"),

    ["csch"] = operator("csch"),
    ["sech"] = operator("sech"),
    ["coth"] = operator("coth"),

    ["arcsin"] = operator("arcsin"),
    ["arccos"] = operator("arccos"),
    ["arctan"] = operator("arctan"),

    ["arg"] = operator("arg"),
    ["deg"] = operator("deg"),
    ["det"] = operator("det"),
    ["dim"] = operator("dim"),
    ["exp"] = operator("exp"),
    ["gcd"] = operator("gcd"),
    ["hom"] = operator("hom"),
    ["inf"] = operator("inf"),
    ["ker"] = operator("ker"),
    ["lg"] = operator("lg"),

    ["lim"] = operator("lim"),
    ["liminf"] = operator("lim inf", "inline", 7),
    ["limsup"] = operator("lim sup", "inline", 7),

    ["ln"] = operator("ln"),
    ["log"] = operator("log"),
    ["min"] = operator("min"),
    ["max"] = operator("max"),
    ["Pr"] = operator("Pr"),
    ["sup"] = operator("sup"),

    ---@diagnostic disable:assign-type-mismatch
    ["sqrt"] = function ()
        local symbols = require("markview.symbols");
        return operator(symbols.entries.sqrt, "inline", 5);
    end,
    ["lvert"] = function ()
        local symbols = require("markview.symbols");
        return operator(symbols.entries.vert, "inline", 6);
    end,
    ["lVert"] = function ()
        local symbols = require("markview.symbols");
        return operator(symbols.entries.Vert, "inline", 6);
    end,
    ---@diagnostic enable:assign-type-mismatch
},
```

Each command has the following options

```lua from: ../lua/markview/types/renderers/latex.lua class: markview.config.latex.commands.opts
--- Options for LaTeX command.
---@class markview.config.latex.commands.opts
---
---@field condition? fun(item: markview.parsed.latex.commands): boolean Condition used to determine if a command is valid.
---
---@field command_offset? fun(range: integer[]): integer[] Modifies the command's range(`{ row_start, col_start, row_end, col_end }`).
---@field on_command? table Extmark configuration to use on the command.
---@field on_args? markview.config.latex.commands.arg_opts[]? Configuration table for each argument.
```

## escapes

```lua from: ../lua/markview/types/renderers/latex.lua class: markview.config.latex.escapes
--- Configuration table for latex escaped characters.
---@class markview.config.latex.escapes
---
---@field enable boolean Enable rendering of **escaped character**.
---@field hl? string Highlight group for the escaped character.
```

Changes how escaped characters are shown.

```lua
escapes = {
    enable = true
},
```

## fonts

```lua from: ../lua/markview/types/renderers/latex.lua class: markview.config.latex.fonts
--- Configuration table for latex math fonts.
---@class markview.config.latex.fonts
---
---@field enable boolean Enable rendering of math fonts.
---
---@field default markview.config.latex.fonts.opts Options for the default font.
---@field [string] markview.config.latex.fonts.opts Options for `string` font.
```

Changes how various math fonts are shown.

```lua
fonts = {
    enable = true,

    default = {
        enable = true,
        hl = "MarkviewSpecial"
    },

    mathbf = { enable = true },
    mathbfit = { enable = true },
    mathcal = { enable = true },
    mathbfscr = { enable = true },
    mathfrak = { enable = true },
    mathbb = { enable = true },
    mathbffrak = { enable = true },
    mathsf = { enable = true },
    mathsfbf = { enable = true },
    mathsfit = { enable = true },
    mathsfbfit = { enable = true },
    mathtt = { enable = true },
    mathrm = { enable = true },
},
```

Each font has the following options.

```lua from: ../lua/markview/types/renderers/latex.lua class: markview.config.latex.fonts.opts
--- Configuration options for a specific math font.
---@class markview.config.latex.fonts.opts
---
---@field enable? boolean Enable rendering of this font.
---@field hl?
---| string Highlight group for this font.
---| fun(buffer: integer, item: markview.parsed.latex.fonts): string? Use the buffer & item data and return a group for this font.
```

## inlines

```lua from: ../lua/markview/types/renderers/latex.lua class: markview.config.latex.inlines
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
```

Changes how inline maths are shown.

```lua
inlines = {
    enable = true,

    padding_left = " ",
    padding_right = " ",

    hl = "MarkviewInlineCode"
},
```

## parenthesis

```lua from: ../lua/markview/types/renderers/latex.lua class: markview.config.latex.parenthesis
--- Configuration table for parenthesis.
---@class markview.config.latex.parenthesis
---
---@field enable boolean Enable rendering of parenthesis.
```

Changes how parenthesis are shown in LaTeX.

```lua
parenthesis = {
    enable = true,
},
```

## subscripts

```lua from: ../lua/markview/types/renderers/latex.lua class: markview.config.latex.subscripts
--- Configuration for subscripts.
---@class markview.config.latex.subscripts
---
---@field enable boolean Enables preview of subscript text.
---
---@field fake_preview? boolean Use Unicode characters to mimic subscript text.
---@field hl? string | string[] Highlight group for the subscript text. Can be a list to use different hl for nested subscripts.
```

Changes how subscript text looks.

>[!NOTE]
> Rendering relies on Unicode character support(as there are no subscript character group).

```lua
subscripts = {
    enable = true,

    hl = "MarkviewSubscript"
},
```

## superscripts

```lua from: ../lua/markview/types/renderers/latex.lua class: markview.config.latex.superscripts
--- Configuration for superscripts.
---@class markview.config.latex.superscripts
---
---@field enable boolean Enables preview of superscript text.
---
---@field fake_preview? boolean Use Unicode characters to mimic superscript text.
---@field hl? string | string[] Highlight group for the superscript text. Can be a list to use different hl for nested superscripts.
```

Changes how superscript text looks.

>[!NOTE]
> Rendering relies on Unicode character support(as there are no superscript character group).

```lua
superscripts = {
    enable = true,

    hl = "MarkviewSuperscript"
},
```

## symbols

```lua from: ../lua/markview/types/renderers/latex.lua class: markview.config.latex.symbols
--- Configuration table for TeX math symbols.
---@class markview.config.latex.symbols
---
---@field enable boolean Enable rendering of Math symbols.
---
---@field hl? string Highlight group for the symbols.
```

Changes how math symbols are shown.

```lua
symbols = {
    enable = true,

    hl = "MarkviewComment"
},
```

## text

```lua from: ../lua/markview/types/renderers/latex.lua class: markview.config.latex.texts
---@class markview.config.latex.texts
---
---@field enable boolean Enable rendering of text blocks.
```

Changes how math symbols are shown.

```lua
texts = {
    enable = true
},
```

