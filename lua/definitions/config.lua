
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
