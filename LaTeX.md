# LaTeX

![LaTeX](https://github.com/OXY2DEV/markview.nvim/blob/images/Wiki/latex.jpg)

```lua
latex = {
    enable = true,

    --- Bracket conceal configuration.
    --- Shows () in specific cases
    brackets = {
        enable = true,

        --- Highlight group for the ()
        ---@type string
        hl = "@punctuation.brackets"
    },

    --- LaTeX blocks renderer
    block = {
        enable = true,

        --- Highlight group for the block
        ---@type string
        hl = "Code",

        --- Virtual text to show on the bottom
        --- right.
        --- First value is the text and second value
        --- is the highlight group.
        ---@type string[]
        text = { " LaTeX ", "Special" }
    },

    --- Configuration for inline LaTeX maths
    inline = {
        enable = true
    },

    --- Configuration for operators(e.g. "\frac{1}{2}")
    operators = {
        enable = true,
        configs = {
            sin = {
                --- Configuration for the extmark added
                --- to the name of the operator(e.g. "\sin").
                ---
                --- see `nvim_buf_set_extmark()` for all the
                --- options.
                ---@type table
                operator = {
                    conceal = "",
                    virt_text = { { "𝚜𝚒𝚗", "Special" } }
                },

                --- Configuration for the arguments of this
                --- operator.
                --- Item index is used to apply the configuration
                --- to a specific argument
                ---@type table[]
                args = {
                    {
                        --- Extmarks are only added
                        --- if a config for it exists.

                        --- Configuration for the extmark
                        --- added before this argument.
                        ---
                        --- see `nvim_buf_set_extmark` for more.
                        before = {},

                        --- Configuration for the extmark
                        --- added after this argument.
                        ---
                        --- see `nvim_buf_set_extmark` for more.
                        after = {},

                        --- Configuration for the extmark
                        --- added to the range of text of
                        --- this argument.
                        ---
                        --- see `nvim_buf_set_extmark` for more.
                        scope = {}
                    }
                }
            }
        }
    },

    --- Configuration for LaTeX symbols.
    symbols = {
        enable = true,

        --- Highlight group for the symbols.
        ---@type string?
        hl = "@operator.latex",

        --- Allows adding/modifying symbol definitions.
        overwrite = {
            --- Symbols can either be strings or functions.
            --- When the value is a function it receives the buffer
            --- id as the parameter.
            ---
            --- The resulting string is then used.
            ---@param buffer integer.
            today = function (buffer)
                return os.date("%d %B, %Y");
            end
        },

        --- Create groups of symbols to only change their
        --- appearance.
        groups = {
            {
                --- Matcher for this group.
                ---
                --- Can be a list of symbols or a function
                --- that takes the symbol as the parameter
                --- and either returns true or false.
                ---
                ---@type string[] | fun(symbol: string): boolean
                match = { "lim", "today" },

                --- Highlight group for this group.
                ---@type string
                hl = "Special"
            }
        }
    },

    subscript = {
        enable = true,

        hl = "MarkviewLatexSubscript"
    },

    superscript = {
        enable = true,

        hl = "MarkviewLatexSuperscript"
    }
}
```

