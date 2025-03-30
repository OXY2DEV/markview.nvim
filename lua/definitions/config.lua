
---@meta

--- Plugin configuration related stuff.
local M = {};

-- [ Markview | Configuration ] -----------------------------------------------------------

--- Configuration table for `markview.nvim`.
--- >[!NOTE]
--- > All options should be **dynamic**.
---@class mkv.config
---
---@field experimental? config.experimental | fun(): config.experimental
---@field highlight_groups? { [string]: config.hl } | fun(): { [string]: config.hl }
---@field preview? config.preview | fun(): config.preview
---@field renderers? config.renderer[] | fun(): config.renderer[]
---
---@field html? config.html | fun(): config.html
---@field latex? config.latex | fun(): config.latex
---@field markdown? config.markdown | fun(): config.markdown
---@field markdown_inline? config.markdown_inline | fun(): config.markdown_inline
---@field typst? config.typst | fun(): config.typst
---@field yaml? config.yaml | fun(): config.yaml
M.config = {
};

-- [ Markview | Configuration • Static ] --------------------------------------------------

--- Static configuration for `markview.nvim`.
---@class mkv.config_static
---
---@field experimental? config.experimental Experimental options.
---@field highlight_groups? { [string]: config.hl } Custom highlight groups.
---@field preview? config.preview Preview options.
---@field renderers? config.renderer[] Custom renderers.
---
---@field html? config.html HTML options.
---@field latex? config.latex LaTeX configuration.
---@field markdown? config.markdown Markdown configuration.
---@field markdown_inline? config.markdown_inline Inline markdown configuration.
---@field typst? config.typst Typst configuration.
---@field yaml? config.yaml YAML configuration.
M.config = {
	experimental = {},
	highlight_groups = {},
	preview = {},
	renderers = {},

	html = {},
	latex = {},
	markdown_inline = {},
	markdown = {},
	typst = {},
	yaml = {},
};

-- [ Markview | Experimental options ] ----------------------------------------------------

--- Configuration for experimental options.
---@class config.experimental
---
--- Opens text file inside Neovim.
---@field prefer_nvim? boolean
---
--- Command used to open files inside Neovim.
---@field file_open_command? string
--- Number of `bytes` to check before opening a link. Used for detecting when to open files inside Neovim.
---@field read_chunk_size? integer
---
--- Maximum number of empty lines that can stay between text of a list item.
---@field list_empty_line_tolerance? integer
---
--- String formats for detecting date in YAML.
---@field date_formats? string[]
--- String formats for detecting date & time in YAML.
---@field date_time_formats? string[]
M.experimental = {
    read_chunk_size = 1024,

    file_open_command = "tabnew",
    list_empty_line_tolerance = 3,

    date_formats = {
        "^%d%d%d%d%-%d%d%-%d%d$",                   --- YYYY-MM-DD
        "^%d%d%-%d%d%-%d%d%d%d$",                   --- DD-MM-YYYY, MM-DD-YYYY
        "^%d%d%-%d%d%-%d%d$",                       --- DD-MM-YY, MM-DD-YY, YY-MM-DD

        "^%d%d%d%d%/%d%d%/%d%d$",                   --- YYYY/MM/DD
        "^%d%d%/%d%d%/%d%d%d%d$",                   --- DD/MM/YYYY, MM/DD/YYYY

        "^%d%d%d%d%.%d%d%.%d%d$",                   --- YYYY.MM.DD
        "^%d%d%.%d%d%.%d%d%d%d$",                   --- DD.MM.YYYY, MM.DD.YYYY

        "^%d%d %a+ %d%d%d%d$",                      --- DD Month YYYY
        "^%a+ %d%d %d%d%d%d$",                      --- Month DD, YYYY
        "^%d%d%d%d %a+ %d%d$",                      --- YYYY Month DD

        "^%a+%, %a+ %d%d%, %d%d%d%d$",              --- Day, Month DD, YYYY
    },

    date_time_formats = {
        "^%a%a%a %a%a%a %d%d %d%d%:%d%d%:%d%d ... %d%d%d%d$", --- UNIX date time
        "^%d%d%d%d%-%d%d%-%d%dT%d%d%:%d%d%:%d%dZ$",           --- ISO 8601
    }
};

-- [ Markview | Renderers ] ---------------------------------------------------------------

---@class config.renderers Configuration for custom renderers.
---
---@field [string] fun(ns: integer, buffer: integer, item: table): nil
M.renderers = {
	yaml_property = function (ns, buffer, item)
		vim.print({ ns, buffer, item });
	end
};

return M;
