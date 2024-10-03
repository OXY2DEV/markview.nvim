<p align="center">
    A highly customisable markdown previewer for <code>Neovim</code>
</p>

https://github.com/user-attachments/assets/ae3d2912-65d4-4dd7-a8bb-614c4406c4e3
<!-- It is not possible to use GitHub links for videos, so we have to manually upload this -->

<p align="center"><sub>Made on mobile, made for mobile.</sub></p>

## 📖 Table of contents

- [Migration guides](https://github.com/OXY2DEV/markview.nvim/wiki/Migration-guide)
- [Plugin options](https://github.com/OXY2DEV/markview.nvim/wiki/Plugin-options)

- [Block quotes](https://github.com/OXY2DEV/markview.nvim/wiki/Block-quotes)
- [Checkboxes](https://github.com/OXY2DEV/markview.nvim/wiki/Checkboxes)
- [Code blocks](https://github.com/OXY2DEV/markview.nvim/wiki/Code-blocks)
- [Headings](https://github.com/OXY2DEV/markview.nvim/wiki/Headings)
- [Horizontal rules](https://github.com/OXY2DEV/markview.nvim/wiki/Horizontal-rules)
- [HTML](https://github.com/OXY2DEV/markview.nvim/wiki/HTML)
- [Inline codes](https://github.com/OXY2DEV/markview.nvim/wiki/Inline-codes)
- [LaTeX](https://github.com/OXY2DEV/markview.nvim/wiki/LaTeX)
- [Links](https://github.com/OXY2DEV/markview.nvim/wiki/Links)
- [List items](https://github.com/OXY2DEV/markview.nvim/wiki/List-items)
- [Tables](https://github.com/OXY2DEV/markview.nvim/wiki/Tables)

## ✨ Configuration options

>[!NOTE]
> This wiki assumes basic understanding of `LuaCATS` annotations!
> This wiki is made to be used inside of the terminal!

Here's all the options of the plugin together.

Options are explained in more details in their own wiki pages!

```lua
{
    --- When true, markdown, html, latex aren't rendered inside
    --- of code blocks
    ---@type boolean
    __inside_code_block = false,

    --- Buffer types to ignore.
    ---@type string[]?
    buf_ignore = { "nofile" },

    --- Callbacks to execute during various states of the
    --- plugin
    callbacks = {
        --- Called when attaching to a buffer(while the plugin
        --- is enabled).
        ---@param buf integer Buffer ID
        ---@param win integer Window ID
        on_enable = function (buf, win) end,

        --- Called when disabling the plugin(either globally
        --- or in a buffer).
        ---@param buf integer Buffer ID
        ---@param win integer Window ID
        on_disable = function (buf, win) end,

        --- Called when changing "Vim modes"(while the plugin
        --- is enabled).
        ---@param buf integer Buffer ID
        ---@param win integer Window ID
        ---@param mode string Mode short name
        on_mode_change = function (buf, win, mode) end,

        --- Called when entering split view
        ---@param split_buf integer Buffer ID for the preview split
        ---@param split_win integer Window ID for the preview split
        split_enter = function (split_buf, split_win) end
    },

    --- Time in miliseconds to wait before a redraw occurs(after any
    --- of the redraw events).
    ---
    --- Redraw events are, cursorMoved, "ModeChanged", "TextChanged";
    ---
    --- Change this depending on your machine's power
    ---@type integer
    debounce = 50,

    --- Filetypes where the plugin is enabled
    ---@type string[]
    filetypes = { "markdown", "quarto", "rmd" },

    --- Highlight groups to use.
    --- Can be a list of tables that define the highlight groups.
    ---@type "dynamic" | "light" | "dark" | table[]
    highlight_groups = "dynamic",

    --- Vim modes where "hybrid mode" should be enabled.
    ---@type string[]
    hybrid_modes = nil,

    --- Tree-sitter query injections
    injections = {
        enable = true,

        languages = {
            --- Key is the language
            markdown = {
                enable = true,

                --- When true, other injections are replaced
                --- with the ones provided here
                ---@type boolean
                override = false,

                query = [[
                    (section
                        (atx_heading)) @fold (#set! @fold)
                ]]
            }
        }
    },

    --- Initial state of the plugin for newly attached buffers.
    --- When false, automatic previews are disabled. You can then
    --- enable the preview via a command.
    ---@type boolean
    initial_state = true,

    --- Maximum number of lines a buffer can have before only a part
    --- of it is rendered, instead of the entire buffer.
    ---@type integer
    max_file_length = 1000,

    --- Vim modes where the preview is shown
    ---@type string[]
    modes = { "n", "no", "c" },

    --- Number of lines to render on large files(when line count
    --- is larger then "max_file_length").
    ---@type integer
    render_distance = 100,

    --- Window configuration for the split window
    ---@type table
    split_conf = {
        split = "right"
    },

    block_quotes = {
        enable = true,

        --- Default configuration for block quotes.
        default = {
            --- Text to use as border for the block
            --- quote.
            --- Can also be a list if you want multiple
            --- border types!
            ---@type string | string[]
            border = "▋",

            --- Highlight group for "border" option. Can also
            --- be a list to create gradients.
            ---@type (string | string[])?
            hl = "MarkviewBlockQuoteDefault"
        },

        --- Configuration for custom block quotes
        callouts = {
            {
                --- String between "[!" & "]"
                ---@type string
                match_string = "ABSTRACT",

                --- Primary highlight group. Used by other options
                --- that end with "_hl" when their values are nil.
                ---@type string?
                hl = "MarkviewBlockQuoteNote",

                --- Text to show in the preview.
                ---@type string
                preview = "󱉫 Abstract",

                --- Highlight group for the preview text.
                ---@type string?
                preview_hl = nil

                --- When true, adds the ability to add a title
                --- to the block quote.
                ---@type boolean
                title = true,

                --- Icon to show before the title.
                ---@type string?
                icon = "󱉫 ",

                ---@type string | string
                border = "▋",

                ---@type (string | string[])?
                border_hl = nil
            },
        }
    },

    checkboxes = {
        enable = true,

        checked = {
            --- Text to show
            ---@type string
            text = "✔",

            --- Highlight group for "text"
            ---@type string?
            hl = "MarkviewCheckboxChecked",

            --- Highlight group to add to the body
            --- of the list item.
            ---@type string?
            scope_hl = nil
        },

        unchecked = {
            text = "✘", hl = "MarkviewCheckboxUnchecked",
            scope_hl = nil
        },

        --- Custom checkboxes configuration
        custom = {
            {
                --- Text inside []
                ---@type string
                match_string = "-",

                ---@type string
                text = "◯",

                ---@type string?
                hl = "MarkviewCheckboxPending",

                ---@type string?
                scope_hl = nil
            }
        }
    },

    code_blocks = {
        enable = true,

        --- Icon provider for the block icons & signs.
        ---
        --- Possible values are,
        ---   • "devicons", Uses `nvim-web-devicons`.
        ---   • "mini", Uses `mini.icons`.
        ---   • "internal", Uses the internal icon provider.
        ---   • "", Disables icons
        ---
        ---@type "devicons" | "mini" | "internal" | ""
        icons = "internal",

        --- Render style for the code block.
        ---
        --- Possible values are,
        ---   • "simple", Simple line highlighting.
        ---   • "language", Signs, icons & much more.
        ---
        ---@type "simple" | "language"
        style = "language",

        --- Primary highlight group.
        --- Used by other options that end with "_hl" when
        --- their values are nil.
        ---@type string
        hl = "MarkviewCode",

        --- Highlight group for the info string
        ---@type string[]
        info_hl = "MarkviewCodeInfo",

        --- Minimum width of a code block.
        ---@type integer
        min_width = 60,

        --- Left & right padding amount
        ---@type integer
        pad_amount = 3,

        --- Character to use as whitespace
        ---@type string?
        pad_char = " ",

        --- Table containing various code block language names
        --- and the text to show.
        --- e.g. { cpp = "C++" }
        ---@type { [string]: string }
        language_names = nil,

        --- Direction of the language preview
        ---@type "left" | "right"
        language_direction = "right",

        --- Enables signs
        ---@type boolean
        sign = true,

        --- Highlight group for the sign
        ---@type string?
        sign_hl = nil
    },

    footnotes = {
        enable = true,

        --- When true, uses Unicode characters to
        --- fake superscript text.
        ---@type boolean
        superscript = true,

        --- Highlight group for the footnotes
        hl = "Special"
    }

    headings = {
        enable = true,

        --- Amount of character to shift per heading level
        ---@type integer
        shift_width = 1,

        heading_1 = {
            style = "simple",

            --- Background highlight group.
            ---@type string
            hl = "MarkviewHeading1"
        },
        heading_2 = {
            style = "icon",

            --- Primary highlight group. Used by other
            --- options that end with "_hl" when their
            --- values are nil.
            ---@type string
            hl = "MarkviewHeading2",

            --- Character used to shift/indent the heading
            ---@type string
            shift_char = " ",

            --- Highlight group for the "shift_char"
            ---@type string?
            shift_hl = "MarkviewHeading2Sign",

            --- Text to show on the signcolumn
            ---@type string?
            sign = "󰌕 ",

            --- Highlight group for the sign
            ---@type string?
            sign_hl = "MarkviewHeading2Sign",

            --- Icon to show before the heading text
            ---@type string?
            icon = "󰼏  ",

            --- Highlight group for the Icon
            ---@type string?
            icon_hl = "MarkviewHeading2"
        },
        heading_3 = {
            style = "label",

            --- Alignment of the heading.
            ---@type "left" | "center" | "right"
            align = "center",

            --- Primary highlight group. Used by other
            --- options that end with "_hl" when their
            --- values are nil.
            ---@type string
            hl = "MarkviewHeading3",

            --- Left corner, Added before the left padding
            ---@type string?
            corner_left = nil,

            --- Left padding, Added before the icon
            ---@type string?
            padding_left = nil,

            --- Right padding, Added after the heading text
            ---@type string?
            padding_right = nil,

            --- Right corner, Added after the right padding
            ---@type string?
            corner_right = nil,

            ---@type string?
            corner_left_hl = nil,
            ---@type string?
            padding_left_hl = nil,

            ---@type string?
            padding_right_hl = nil,
            ---@type string?
            corner_right_hl = nil,

            --- Text to show on the signcolumn.
            ---@type string?
            sign = "󰌕 ",

            --- Highlight group for the sign.
            ---@type string?
            sign_hl = "MarkviewHeading2Sign",

            --- Icon to show before the heading text.
            ---@type string?
            icon = "󰼏  ",

            --- Highlight group for the Icon.
            ---@type string?
            icon_hl = "MarkviewHeading2"
        },
        heading_4 = {},
        heading_5 = {},
        heading_6 = {},

        setext_1 = {
            style = "simple",

            --- Background highlight group.
            ---@type string
            hl = "MarkviewHeading1"
        }
        setext_2 = {
            style = "decorated",

            --- Text to show on the signcolumn.
            ---@type string?
            sign = "󰌕 ",

            --- Highlight group for the sign.
            ---@type string?
            sign_hl = "MarkviewHeading2Sign",

            --- Icon to show before the heading text.
            ---@type string?
            icon = "  ",

            --- Highlight group for the Icon.
            ---@type string?
            icon_hl = "MarkviewHeading2",

            --- Bottom border for the heading.
            ---@type string?
            border = "▂",

            --- Highlight group for the bottom border.
            ---@type string?
            border_hl = "MarkviewHeading2"
        }
    },

    horizontal_rules = {
        enable = true,

        parts = {
            {
                type = "repeating",

                --- Amount of time to repeat the text
                --- Can be an integer or a function.
                ---
                --- If the value is a function the "buffer" ID
                --- is provided as the parameter.
                ---@type integer | fun(buffer: integer): nil
                repeat_amount = function (buffer)
                    local textoff = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].textoff;

                    return math.floor((vim.o.columns - textoff - 3) / 2);
                end,

                --- Text to repeat.
                ---@type string
                text = "─",

                --- Highlight group for this part.
                --- Can be a string(for solid color) or a
                --- list of string(for gradient)
                ---@type string[] | string
                hl = {
                    "MarkviewGradient1", "MarkviewGradient2", "MarkviewGradient3", "MarkviewGradient4", "MarkviewGradient5", "MarkviewGradient6", "MarkviewGradient7", "MarkviewGradient8", "MarkviewGradient9", "MarkviewGradient10"
                },

                --- Placement direction of the gradient.
                ---@type "left" | "right"
                direction = "left"
            },
            {
                type = "text",
                text = "  ",

                ---@type string?
                hl = "MarkviewGradient10"
            }
        }
    },

    html = {
        enable = true,

        --- Tag renderer for tags that have an
        --- opening & closing tag.
        tags = {
            enable = true,

            --- Default configuration
            default = {
                --- When true, the tag is concealed.
                ---@type boolean
                conceal = false,

                --- Highlight group for the text inside
                --- of the tag
                ---@type string?
                hl = nil
            },

            --- Configuration for specific tag(s).
            --- The key is the tag and the value is the
            --- used configuration.
            configs = {
                b = { conceal = true, hl = "Bold" },
                u = { conceal = true, hl = "Underlined" },
            }
        },

        --- HTML entity configuration
        entities = {
            enable = true,

            --- Highlight group for the rendered entity.
            ---@type string?
            hl = nil
        }
    },

    inline_codes = {
        enable = true,

        --- Primary highlight group. Used by other
        --- options that end with "_hl" when their
        --- values are nil.
        ---@type string
        hl = "MarkviewHeading3",

        --- Left corner, Added before the left padding.
        ---@type string?
        corner_left = nil,

        --- Left padding, Added before the text.
        ---@type string?
        padding_left = nil,

        --- Right padding, Added after the text.
        ---@type string?
        padding_right = nil,

        --- Right corner, Added after the right padding.
        ---@type string?
        corner_right = nil,

        ---@type string?
        corner_left_hl = nil,
        ---@type string?
        padding_left_hl = nil,

        ---@type string?
        padding_right_hl = nil,
        ---@type string?
        corner_right_hl = nil,
    },

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
    },

    links = {
        enable = true,

        --- Configuration for normal links
        hyperlinks = {
            enable = true,

            --- When true, link texts that start with an emoji
            --- won't have an icon in front of them.
            ---@type boolean
            __emoji_link_compatability = true,

            --- Icon to show.
            ---@type string?
            icon = "󰌷 ",

            --- Highlight group for the "icon".
            ---@type string?
            hl = "MarkviewHyperlink",

            --- Configuration for custom links.
            custom = {
                {
                    --- Pattern of the address.
                    ---@type string
                    match_string = "stackoverflow%.com",

                    --- Icon to show.
                    ---@type string?
                    icon = " ",

                    --- Highlight group for the icon
                    ---@type string?
                    hl = nil
                },
                { match_string = "stackexchange%.com", icon = " " },
            }
        },

        images = {
            enable = true,

            --- When true, link texts that start with an emoji
            --- won't have an icon in front of them.
            ---@type boolean
            __emoji_link_compatability = true,

            --- Icon to show.
            ---@type string?
            icon = "󰥶 ",

            --- Highlight group for the "icon".
            ---@type string?
            hl = "MarkviewImageLink",

            --- Configuration for custom image links.
            custom = {
                {
                    --- Pattern of the address.
                    ---@type string
                    match_string = "%.svg$",

                    --- Icon to show.
                    ---@type string?
                    icon = "󰜡 ",

                    --- Highlight group for the icon
                    ---@type string?
                    hl = nil
                },
            }
        },

        emails = {
            enable = true,

            --- Icon to show.
            ---@type string?
            icon = " ",

            --- Highlight group for the "icon".
            ---@type string?
            hl = "MarkviewEmail"

            --- Configuration for custom emails
            custom = {}
        },

        internal_links = {
            enable = true,

            --- When true, link texts that start with an emoji
            --- won't have an icon in front of them.
            __emoji_link_compatability = true,

            --- Icon to show.
            ---@type string?
            icon = " ",

            --- Highlight group for the "icon".
            ---@type string?
            hl = "MarkviewHyperlink",

            --- Configuration for custom internal links
            custom = {}
        }
    },

    list_items = {
        enable = true,

        --- Amount of spaces that defines an indent
        --- level of the list item.
        ---@type integer
        indent_size = 2,

        --- Amount of spaces to add per indent level
        --- of the list item.
        ---@type integer
        shift_width = 4,

        marker_minus = {
            add_padding = true,

            text = "",
            hl = "MarkviewListItemMinus"
        },
        marker_plus = {
            add_padding = true,

            text = "",
            hl = "MarkviewListItemPlus"
        },
        marker_star = {
            add_padding = true,

            text = "",
            hl = "MarkviewListItemStar"
        },

        --- These items do NOT have a text or
        --- a hl property!

        --- n. Items
        marker_dot = {
            add_padding = true
        },

        --- n) Items
        marker_parenthesis = {
            add_padding = true
        }
    },

    tables = {
        enable = true,

        --- Parts for the table border.
        ---@type { [string]: string[] }
        text = {
            top       = { "╭", "─", "╮", "┬" },
            header    = { "│", "│", "│" },
            separator = { "├", "┼", "┤", "─" },
            row       = { "│", "│", "│" },
            bottom    = { "╰", "─", "╯", "┴" },

            align_left = "╼",
            align_right = "╾",
            align_center = { "╴", "╶",}
        },

        --- Highlight groups for the "parts".
        ---@type { [string]: string[] }
        hls = {
            top       = { "TableHeader", "TableHeader", "TableHeader", "TableHeader" },
            header    = { "TableHeader", "TableHeader", "TableHeader" },
            separator = { "TableHeader", "TableHeader", "TableHeader", "TableHeader" },
            row       = { "TableBorder", "TableBorder", "TableBorder" },
            bottom    = { "TableBorder", "TableBorder", "TableBorder", "TableBorder" },

            align_left = "TableAlignLeft",
            align_right = "TableAlignRight",
            align_center = { "TableAlignCenter", "TableAlignCenter",}
        },

        --- Minimum width of a table cell
        ---@type integer?
        col_min_width = 5,

        --- When true, top & bottom borders aren't drawn
        ---@type boolean
        block_decorator = true,

        --- When true, top & bottom borders are made with
        --- virtual lines instead of virtual text.
        ---@type boolean
        use_virt_lines = true
    }
```

