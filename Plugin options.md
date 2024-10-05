# 🪷 Plugin options

Options that don't deal with `rendering` of nodes.

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

    --- When using "hybrid mode" if the cursor is inside
    --- specific nodes the decorations will not be removed.
    ---@type string[]?
    ignore_modes = nil,

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
    }
}
```

