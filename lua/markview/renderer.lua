local renderer = {};

local mkd = require("markview.renderers.markdown")
local inl = require("markview.renderers.markdown_inline")
local ltx = require("markview.renderers.latex")

--- Renders things
---@param buffer integer
renderer.render = function (buffer, parsed_content)
	inl.render(buffer, parsed_content.markdown_inline)
	mkd.render(buffer, parsed_content.markdown)
	ltx.render(buffer, parsed_content.latex)
end

renderer.clear = function (buffer, ignore, from, to)
	ignore = vim.tbl_extend("force", {
		markdown = {},
		markdown_inline = {},
		html = {},
		latex = {},
		typst = {}
	}, ignore or {});

	mkd.clear(buffer, ignore.markdown, from, to);
	inl.clear(buffer, ignore.markdown_inline, from, to);
	ltx.clear(buffer, ignore.latex, from, to);
end

renderer.range = function (content)
	local _f, _t = nil, nil;

	for _, lang in pairs(content) do
		for _, item in ipairs(lang) do
			if not _f or item.range.row_start < _f then
				_f = item.range.row_start;
			end

			if not _t or item.range.row_end > _t then
				_t = item.range.row_end;
			end
		end
	end

	return _f, _t;
end

return renderer;
