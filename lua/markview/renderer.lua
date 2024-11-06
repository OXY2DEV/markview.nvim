local renderer = {};

renderer.markdown = require("markview.renderers.markdown")
renderer.markdown_inline = require("markview.renderers.markdown_inline")
renderer.latex = require("markview.renderers.latex")
renderer.yaml = require("markview.renderers.yaml")

--- Renders things
---@param buffer integer
renderer.render = function (buffer, parsed_content)
	for lang, content in pairs(parsed_content) do
		if renderer[lang] then
			renderer[lang].render(buffer, content);
		end
	end
end

renderer.clear = function (buffer, ignore, from, to)
	ignore = vim.tbl_extend("force", {
		markdown = {},
		markdown_inline = {},
		html = {},
		latex = {},
		typst = {},
		yaml = {}
	}, ignore or {});

	for lang, content in pairs(ignore) do
		if renderer[lang] then
			renderer[lang].clear(buffer, content, from, to);
		end
	end
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
