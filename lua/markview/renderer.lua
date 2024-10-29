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

renderer.clear = function (buffer, from, to)
	vim.api.nvim_buf_clear_namespace(buffer, inl.ns, from or 0, to or -1);
	vim.api.nvim_buf_clear_namespace(buffer, mkd.ns, from or 0, to or -1);
	vim.api.nvim_buf_clear_namespace(buffer, ltx.ns, from or 0, to or -1);
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
