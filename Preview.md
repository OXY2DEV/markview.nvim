# 💻 Preview options

>[!TIP]
> Type definitions are available in [definitions/preview.lua]().

Options that change when & how previews are shown are part of this. Default value can be found [here]().

```lua
---@type markview.config.preview
preview = {
    enable = true,
    enable_hybrid_mode = true,

    callbacks = {
        on_attach = function (_, wins)
            ---@type boolean
            local attach_state = spec.get({ "preview", "enable" }, { fallback = true, ignore_enable = true });

            if attach_state == false then
                return;
            end

            for _, win in ipairs(wins) do
                vim.wo[win].conceallevel = 3;
            end
        end,

        on_detach = function (_, wins)
            for _, win in ipairs(wins) do
                vim.wo[win].conceallevel = 0;
            end
        end,

        on_enable = function (_, wins)
            local attach_state = spec.get({ "preview", "enable" }, { fallback = true, ignore_enable = true });

            if attach_state == false then
                ---@type string[]
                local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
                ---@type string[]
                local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });

                local concealcursor = "";

                for _, mode in ipairs(preview_modes) do
                    if vim.list_contains(hybrid_modes, mode) == false and vim.list_contains({ "n", "v", "i", "c" }, mode) then
                        concealcursor = concealcursor .. mode;
                    end
                end

                for _, win in ipairs(wins) do
                    vim.wo[win].conceallevel = 3;
                    vim.wo[win].concealcursor = concealcursor;
                end
            else
                for _, win in ipairs(wins) do
                    vim.wo[win].conceallevel = 3;
                end
            end
        end,

        on_disable = function (_, wins)
            for _, win in ipairs(wins) do
                vim.wo[win].conceallevel = 0;
            end
        end,

        on_hybrid_enable = function (_, wins)
            ---@type string[]
            local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
            ---@type string[]
            local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });

            local concealcursor = "";

            for _, mode in ipairs(preview_modes) do
                if vim.list_contains(hybrid_modes, mode) == false and vim.list_contains({ "n", "v", "i", "c" }, mode) then
                    concealcursor = concealcursor .. mode;
                end
            end

            for _, win in ipairs(wins) do
                vim.wo[win].concealcursor = concealcursor;
            end
        end,

        on_hybrid_disable = function (_, wins)
            ---@type string[]
            local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
            local concealcursor = "";

            for _, mode in ipairs(preview_modes) do
                if vim.list_contains({ "n", "v", "i", "c" }, mode) then
                    concealcursor = concealcursor .. mode;
                end
            end

            for _, win in ipairs(wins) do
                vim.wo[win].concealcursor = concealcursor;
            end
        end,

        on_mode_change = function (_, wins, current_mode)
            ---@type string[]
            local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
            ---@type string[]
            local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });

            local concealcursor = "";

            for _, mode in ipairs(preview_modes) do
                if vim.list_contains(hybrid_modes, mode) == false and vim.list_contains({ "n", "v", "i", "c" }, mode) then
                    concealcursor = concealcursor .. mode;
                end
            end

            for _, win in ipairs(wins) do
                if vim.list_contains(preview_modes, current_mode) then
                    vim.wo[win].conceallevel = 3;
                    vim.wo[win].concealcursor = concealcursor;
                else
                    vim.wo[win].conceallevel = 0;
                    vim.wo[win].concealcursor = "";
                end
            end
        end,

        on_splitview_open = function (_, _, win)
            vim.wo[win].conceallevel = 3;
            vim.wo[win].concealcursor = "n";
        end
    },

    map_gx = true,

    debounce = 150,
    icon_provider = "internal",

    filetypes = { "markdown", "quarto", "rmd", "typst" },
    ignore_buftypes = { "nofile" },
    raw_previews = {},

    modes = { "n", "no", "c" },
    hybrid_modes = {},

    linewise_hybrid_mode = false,
    max_buf_lines = 1000,

    draw_range = { 2 * vim.o.lines, 2 * vim.o.lines },
    edit_range = { 0, 0 },

    splitview_winopts = {
        split = "right"
    },
}
```

## enable

- type: `boolean`
  default: `true`

Enables previews on any newly attached buffers.

>[!TIP]
> You can set this to `false`, if you prefer using `splitview` or have keymap for toggling previews!

## enable_hybrid_mode

- type: `boolean`
  default: `true`

Enables hybrid mode in previews.

>[!NOTE]
> This has no effect if [hybrid_modes](#hybrid_modes) isn't set!

## callbacks

- type: `markview.config.preview.callbacks`
  [default]()

Also see,

- [Autocmds]()

Callbacks are functions that can be run when specific things/events happen. Supported callbacks are,

### on_attach

- type: `function`

Parameters,

+ `buf`, integer
  The buffer being attached to.

+ `wins`, integer[]
  Windows that contain `buf`.

Called when attaching to a buffer.

### on_detach

- type: `function`

Parameters,

+ `buf`, integer
  The buffer being attached to.

+ `wins`, integer[]
  Windows that contain `buf`.

Called right before detaching from a buffer.

------

### on_enable

- type: `function`

Parameters,

+ `buf`, integer
  The buffer preview is being shown on.

+ `wins`, integer[]
  Windows that contain `buf`.

Called when enabling previews in a buffer.

### on_disable

- type: `function`

Parameters,

+ `buf`, integer
  The buffer preview is being disabled on.

+ `wins`, integer[]
  Windows that contain `buf`.

Called right before disabling previews in a buffer.

------

### on_hybrid_enable

- type: `function`

Parameters,

+ `buf`, integer
  The buffer where hybrid mode is being enabled on.

+ `wins`, integer[]
  Windows that contain `buf`.

Called when enabling `hybrid mode` in a buffer.

### on_hybrid_disable

- type: `function`

Parameters,

+ `buf`, integer
  The buffer where hybrid mode is being disabled on.

+ `wins`, integer[]
  Windows that contain `buf`.

Called when disabling `hybrid mode` in a buffer.

------

### on_mode_change

>[!CAUTION]
> Deprecated. Use at your own risk!

- type: `function`

Parameters,

+ `buf`, integer
  Buffer that emitted `ModeChanged`.

+ `wins`, integer[]
  Windows that contain `buf`.

+ `mode`, string
  Vim mode shorthand.

Called when changing modes.

------

### on_splitview_open

- type: `function`

Parameters,

+ `source`, integer
  Buffer whose preview will be shown.

+ `splitview_buf`, integer
  Preview buffer.

+ `splitview_win`, integer
  Preview window.

Called after running `splitOpen`.

### on_splitview_close

- type: `function`

Parameters,

+ `source`, integer
  Buffer whose preview is being shown.

+ `splitview_buf`, integer
  Preview buffer.

+ `splitview_win`, integer
  Preview window.

Called after running `splitClose`.

## map_gx

>[!CAUTION]
> As off `0.11.1`, this is no longer needed(at least for `markdown`) and is only left `true` for people who use old versions of Neovim.
>
> This will be removed in a future release!

- type: `boolean`
  default: `true`

Re-maps `gx` to support opening various links from `markdown` & `typst`.

## debounce

- type: `integer`
  default: `150`

Debounce delay for updating previews.

>[!CAUTION]
> Smaller values may impact performance negatively!

## icon_provider

- type: `"" | "internal" | "devicons" | "mini"`
  default: `"internal"`

Icon provider to use in various parts of the plugin(e.g. `code blocks`). 

## filetypes

- type: `string[]`
  default: `{ "markdown", "quarto", "rmd", "typst" }`

Filetypes that should show previews. The plugin will attach to any buffers matching any of these filetypes.

## ignore_buftypes

- type: `string[]`
  default: `{ "nofile" }`

Buftypes that should be ignored by this plugin. Buffers whose filetype matches any of these will not be attached to(even if the filetype matches [filetypes](#filetypes)).

## raw_previews

>[!IMPORTANT]
> This option only has effects if [hybrid_modes](#hybrid_modes) is active!

- type: `markview.config.preview.raw`
  default: `{}`

A map of language & preview options defining what should be shown as raw text in `hybrid mode`.

```lua
raw_previews = {
	-- This will cause only table's to show
    -- up as raw markdown in hybrid mode.
	markdown = { "tables" },

	-- An empty list means everything will show
    -- up as raw.
    markdown_inline = {},
    html = {},
    latex = {},
    typst = {},
    yaml = {},
}
```

## modes

- type: `string[]`
  default: `{ "n", "no", "c" }`

List of Vim-mode short-hands where preview will be shown. Possible values are,

+ `n`, Normal mode
+ `i`, Insert mode
+ `v`, Visual mode
+ `V`, Visual-line mode
+ ``, Visual-block mode
+ `no`, Normal-operation mode
+ `c`, Command mode

## hybrid_modes

- type: `string[]`
  default: `{}`

List of Vim-mode short-hands where `hybrid mode` will be used. Possible values are the same as [modes](#modes).

## linewise_hybrid_mode

- type: `boolean`
  default: `false`

Makes `hybrid mode` show the raw version of the line under the cursor instead of all the lines creating the tree-sitter node under the cursor.

>[!TIP]
> You can modify [edit_range](#edit_range) to change how many lines are shown as raw!

## max_buf_lines

- type: `integer`
  default: `1000`

Maximum number of lines a buffer can have for it to be rendered entirely.

If the number of lines is larger than this value, only the lines in the [draw_range](#draw_range) surrounding the cursor will be rendered.

>[!CAUTION]
> Setting this to a large value may impact performance negatively!

## draw_range

- type: `[ integer, integer ]`
  default: `{ 2 * vim.o.lines, 2 * vim.o.lines }`

Number of lines `before` & `after` the cursor to render/draw.

>[!IMPORTANT]
> This is done for **every cursor** a buffer has! A large value will impact performance negatively!

## edit_range

>[!NOTE]
> This option only affects `hybrid mode`!

- type: `[ integer, integer ]`
  default: `{ 0, 0 }`

Number of lines `before` & `after` that will be considered being edited.

If [linewise_hybrid_mode](#linewise_hybrid_mode) is enabled, this determines the number of lines that will shown raw around each cursor.

Otherwise, this will be used determine which nodes are considered under the cursor.

## splitview_winopts

- type: `vim.api.keyset.win_config`
  default: `{ split = "right" }`

Window configuration for the splitview window.

