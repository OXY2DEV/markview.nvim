# 👀 Latex

>[!Warning]
> Latex support is still experimental.

```lua
latex = {
    enable = true,

    brackets = {
        enable = true,
        opening = {
            { "(", "MarkviewHeading1Sign" },
            { "{", "MarkviewHeading2Sign" },
            { "[", "MarkviewHeading3Sign" },
        },
        closing = {
            { ")", "MarkviewHeading1Sign" },
            { "}", "MarkviewHeading2Sign" },
            { "]", "MarkviewHeading3" },
        },

        -- scope = {
        --  "DiagnosticVirtualTextError",
        --  "DiagnosticVirtualTextOk",
        --  "DiagnosticVirtualTextWarn",
        -- }
    },

    -- Hides $$ inside lines
    inline = {
        enable = true
    },

    -- Highlights lines within $$ $$
    block = {
        hl = "Code",
        text = { " Latex ", "Special" }
    },

    -- Symbols, e.g. \geq
    symbols = {
        enable = true,
        -- Your own set of symbols, e.g.
        -- {
        --   name = "symbol"
        -- }
        overwrite = {}
    },

    subscript = {
        enable = true
    },
    superscript = {
        enable = true
    },
}
```

