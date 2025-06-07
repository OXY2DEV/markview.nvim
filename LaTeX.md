# LaTeX Options

>[!TIP]
> You can find the type definitions in [definitions/latex.lua](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/definitions/renderers/latex.lua).

Options that change how $LaTeX$ is shown in previews are part of this. You can find the default values [here](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1581-L1880).

```lua
---@type markview.config.latex
latex = {
    enable = true,

    blocks = {
        enable = true,

        hl = "MarkviewCode",
        pad_char = " ",
        pad_amount = 3,

        text = "  LaTeX ",
        text_hl = "MarkviewCodeInfo"
    },

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
    },

    escapes = {
        enable = true
    },

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

    inlines = {
        enable = true,

        padding_left = " ",
        padding_right = " ",

        hl = "MarkviewInlineCode"
    },

    parenthesis = {
        enable = true,
    },

    subscripts = {
        enable = true,

        hl = "MarkviewSubscript"
    },

    superscripts = {
        enable = true,

        hl = "MarkviewSuperscript"
    },

    symbols = {
        enable = true,

        hl = "MarkviewComment"
    },

    texts = {
        enable = true
    },
},
```

## enable

- type: `boolean`
  default: `true`

Enables LaTeX previewing.

## blocks

- type: [markview.config.latex.blocks](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/definitions/renderers/latex.lua#L21-L31)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1584-L1593)

Changes how LaTeX blocks are shown.

```lua
---@type markview.config.latex.blocks
blocks = {
    enable = true,

    hl = "MarkviewCode",

    pad_amount = 3,
    pad_char = " ",

    text = "  LaTeX ",
    text_hl = "MarkviewCodeInfo"
},
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

### hl

- type: `string`
  default: `"MarkviewCode"`

Highlight group used as the background.

### pad_amount

- type: `integer`
  default: `3`

Number of [pad_char](#pad_char) to add before each line.

### pad_char

- type: `string`
  default: `" "`

Character used as padding the lines.

### text

- type: `string`
  default: `"  LaTeX "`

Text to show on the top right side of the block.

### text_hl

- type: `string`
  default: `"  LaTeX "`

Highlight group for [text](#text).

## commands

- type: [markview.config.latex.commands](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/definitions/renderers/latex.lua#L35-L58)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1595-L1817)

Changes how LaTeX commands are shown.

>[!IMPORTANT]
> `operator()` can be found [here](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L10-L72).

```lua
---@type markview.config.latex.commands
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
},
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

### \[string\]

- type: [markview.config.latex.commands.opts](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/definitions/renderers/latex.lua#L42-L48)

Configuration for `\string{...}`.

```lua
---@type markview.config.latex.commands.opts
["string"] = {
    condition = function () return true; end,

    command_offset = function (range)
        return range;
    end,
    on_command = {},
    on_arge = {},
},
```

#### condition

- type: `fun(item: markview.parsed.latex.commands): boolean`

See also,

- [markview.parsed.latex.commands](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/definitions/parsers/latex.lua#L14-L23)

Additional condition(s) for this command(e.g. specific number of arguments).

#### command_offset

- type: `fun(range: integer[]): integer[]`

See also,

- [markview.parsed.range](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/definitions/markview.lua#L61-L66)

Modifies the range of this command.

#### on_command

- type: `table`

Configuration for the extmark added to the command text. See `{opts}` in `:h nvim_buf_set_extmark()`.

#### on_args

- type: `table[]`

Configuration for the extmark added to the each argument. See `{opts}` in `:h nvim_buf_set_extmark()`.

```lua
---@type markview.config.latex.commands.arg_opts[]
on_args = {
    {
        after_offset = function (range)
            return { range[1], range[2], range[3], range[4] - 1 };
        end,
        before_offset = nil,
        content_offset = nil,

        condition = nil,

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
        end,
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
        on_content = nil,
    }
}
```

##### after_offset

- type: `fun(range: markview.parsed.range): markview.parsed.range`

Changes the range of `}` of an argument.

##### before_offset

- type: `fun(range: markview.parsed.range): markview.parsed.range`

Changes the range of `{` of an argument.

##### content_offset

- type: `fun(range: markview.parsed.range): markview.parsed.range`

Changes the range of the text between `{}` of an argument.

##### condition

- type: `fun(markview.parsed.latex.commands.arg): boolean`

Unused.

##### on_after

- type: `table`

Configuration for the extmark added to `}`(range is affected by [after_offset](#after_offset). See `{opts}` in `:h nvim_buf_set_extmark()`.

##### on_before

- type: `table`

Configuration for the extmark added to `{`(range is affected by [before_offset](#before_offset). See `{opts}` in `:h nvim_buf_set_extmark()`.

##### on_content

- type: `table`

Configuration for the extmark added to the text of the argument(range is affected by [content_offset](#content_offset). See `{opts}` in `:h nvim_buf_set_extmark()`.

## escapes

- type: `{ enable: boolean }`

Removes `\` from escaped characters in previews

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

## fonts

>[!NOTE]
> You need a modern font(font that support math symbols) for fonts to appear correctly!

- type: [markview.config.latex.fonts](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/definitions/renderers/latex.lua#L70-L83)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/markview/spec.lua#L1826-L1847)

Changes how fonts are shown in LaTeX.

```lua
---@type markview.config.latex.fonts
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

<h3 id="fonts_default">default</h3>

- type: `{ enable: boolean, hl?: string }`

Default configuration for fonts.

#### enable

- type: `boolean`
  default: `true`

Self-explanatory.

#### hl

- type: `string`
  default: `"MarkviewSpecial"`

Highlight group for this font.

### mathbf

- type: `{ enable: boolean, hl?: string }`

Configuration for `\mathbf{}`. Same as [default](#fonts_default).

### mathbfit

- type: `{ enable: boolean, hl?: string }`

Configuration for `\mathbfit{}`. Same as [default](#fonts_default).

### mathcal

- type: `{ enable: boolean, hl?: string }`

Configuration for `\mathcal{}`. Same as [default](#fonts_default).

### mathbfscr

- type: `{ enable: boolean, hl?: string }`

Configuration for `\mathbfscr{}`. Same as [default](#fonts_default).

### mathfrak

- type: `{ enable: boolean, hl?: string }`

Configuration for `\mathfrak{}`. Same as [default](#fonts_default).

### mathbb

- type: `{ enable: boolean, hl?: string }`

Configuration for `\mathbb{}`. Same as [default](#fonts_default).

### mathbffrak

- type: `{ enable: boolean, hl?: string }`

Configuration for `\mathbffrak{}`. Same as [default](#fonts_default).

### mathsf

- type: `{ enable: boolean, hl?: string }`

Configuration for `\mathsf{}`. Same as [default](#fonts_default).

### mathsfbf

- type: `{ enable: boolean, hl?: string }`

Configuration for `\mathsfbf{}`. Same as [default](#fonts_default).

### mathsfit

- type: `{ enable: boolean, hl?: string }`

Configuration for `\mathsfit{}`. Same as [default](#fonts_default).

### mathsfbfit

- type: `{ enable: boolean, hl?: string }`

Configuration for `\mathsfbfit{}`. Same as [default](#fonts_default).

### mathtt

- type: `{ enable: boolean, hl?: string }`

Configuration for `\mathtt{}`. Same as [default](#fonts_default).

### mathrm

- type: `{ enable: boolean, hl?: string }`

Configuration for `\mathrm{}`. Same as [default](#fonts_default).

## inlines

- type: [markview.config.latex.inlines](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/definitions/renderers/latex.lua#L87-L100)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/markview/spec.lua#L1849-L1856)

Configuration for inline maths. See [how inline elements are configured](https://github.com/OXY2DEV/markview.nvim/wiki/Configuration#-inline-elements).

## parenthesis

- type: `{ enable: boolean }`

Hides `{}`.

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

## subscripts

- type: [markview.config.latex.subscripts](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/latex.lua#L109-L114)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1859-L1863)

Configuration for subscripts(`_` & `_{}`).

```lua
---@type markview.config.latex.subscripts
subscripts = {
    enable = true,

    hl = "MarkviewSubscript"
},
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

### hl

- type: `string`
  default: `"MarkviewSubscript"`

Highlight group for subscript text.

## superscripts

- type: [markview.config.latex.superscripts](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/latex.lua#L118-L123)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1865-L1869)

Configuration for subscripts(`^` & `^{}`). Same as [subscripts](#subscripts).

## symbols

- type: [markview.config.latex.symbols](https://github.com/OXY2DEV/markview.nvim/blob/99d9a091915b994b378c4a9cc3553b3cbbe4bad5/lua/definitions/renderers/latex.lua)
  [default](https://github.com/OXY2DEV/markview.nvim/blob/a803117f272cc47733b67ebbaf1acb91095da276/lua/markview/spec.lua#L1871-L1875)

Configuration for subscripts(`^` & `^{}`). Same as [subscripts](#subscripts).

```lua
---@type markview.config.latex.symbols
symbols = {
    enable = true,

    hl = "MarkviewComment"
},
```

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

### hl

- type: `string`
  default: `"MarkviewComment"`

Highlight group for symbols.

## text

- type: `{ enable: boolean }`

Hides command from `\text{}`.

### enable

- type: `boolean`
  default: `true`

Self-explanatory.

