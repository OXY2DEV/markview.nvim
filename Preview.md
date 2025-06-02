# 💻 Preview options

>[!TIP]
> Type definitions are available in [definitions/preview.lua]().

Options that change when & how previews are shown are part of this.

```lua
---@type markview.config.preview
preview = {
    enable = true,
    enable_hybrid_mode = true,

    callbacks = {
        on_attach = function (_, wins)
            --- Initial state for attached buffers.
            ---@type string
            local attach_state = spec.get({ "preview", "enable" }, { fallback = true, ignore_enable = true });

            if attach_state == false then
                --- Attached buffers will not have their previews
                --- enabled.
                --- So, don't set options.
                return;
            end

            for _, win in ipairs(wins) do
                --- Preferred conceal level should
                --- be 3.
                vim.wo[win].conceallevel = 3;
            end
        end,

        on_detach = function (_, wins)
            for _, win in ipairs(wins) do
                --- Only set `conceallevel`.
                --- `concealcursor` will be
                --- set via `on_hybrid_disable`.
                vim.wo[win].conceallevel = 0;
            end
        end,

        on_enable = function (_, wins)
            --- Initial state for attached buffers.
            ---@type string
            local attach_state = spec.get({ "preview", "enable" }, { fallback = true, ignore_enable = true });

            if attach_state == false then
                -- If the window's aren't initially
                -- attached, we need to set the 
                -- 'concealcursor' too.

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
    ignore_previews = {},

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

