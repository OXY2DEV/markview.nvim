# Horizontal rules

![Horizontal rules](https://github.com/OXY2DEV/markview.nvim/blob/images/Wiki/horizontal_rules.jpg)

```lua
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
}
```



