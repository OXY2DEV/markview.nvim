
---@meta

--- Plugin configuration related stuff.
local M = {};

-- [ Markview | Configuration ] -----------------------------------------------------------

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
