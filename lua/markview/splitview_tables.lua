-- Materialize shared table layouts only in the disposable preview buffer.
-- No temporary virtual table, extmark inspection, or second render is needed.
local M = { ns = vim.api.nvim_create_namespace("markview/splitview-tables") };

function M.expand(buffer, content)
	local raw = vim.api.nvim_buf_get_lines(buffer, 0, -1, false);
	local spec = require("markview.spec");
	local custom = spec.get({ "renderers" }, { fallback = {} });
	local tables = {};
	if not custom.markdown_table then
		for _, item in ipairs(content.markdown or {}) do
			if item.class == "markdown_table" then
				local config = spec.get({ "markdown", "tables" }, { fallback = nil, eval_args = { buffer, item } });
				local plan = require("markview.renderers.markdown.table_wrap").layout(buffer, item, config);
				if plan then tables[#tables + 1] = plan; end
			end
		end
	end
	table.sort(tables, function(a, b) return a.first < b.first; end);
	local expanded, mapping, decorations = {}, {}, {};
	local row = 0;
	for _, object in ipairs(tables) do
		local lines = object.lines;
		if lines and object.first >= row then
			while row < object.first do
				mapping[row] = #expanded;
				expanded[#expanded + 1] = raw[row + 1];
				row = row + 1;
			end
			local start = #expanded;
			for r = object.first, object.last - 1 do
				mapping[r] = start;
				start = start + (object.row_heights[r - object.first + 1] or 1);
			end
			decorations[#decorations + 1] = { first = #expanded, last = #expanded + #lines, lines = lines };
			for _, chunks in ipairs(lines) do
				local text = {};
				for _, chunk in ipairs(chunks) do text[#text + 1] = chunk[1]; end
				expanded[#expanded + 1] = table.concat(text);
			end
			row = object.last;
		end
	end
	while row < #raw do
		mapping[row] = #expanded;
		expanded[#expanded + 1] = raw[row + 1];
		row = row + 1;
	end
	mapping[#raw] = #expanded;
	return expanded, mapping, decorations;
end

function M.highlight(buffer, decorations)
	M.clear(buffer);
	for _, object in ipairs(decorations) do
		-- These cells already contain converted preview text. Don't interpret
		-- residual inline markers a second time after expanding the buffer.
		require("markview.renderer").clear(buffer, object.first, object.last);
		for i, chunks in ipairs(object.lines) do
			local col = 0;
			for _, chunk in ipairs(chunks) do
				if chunk[2] and #chunk[1] > 0 then
					vim.api.nvim_buf_set_extmark(buffer, M.ns, object.first + i - 1, col, {
						end_col = col + #chunk[1], hl_group = chunk[2], priority = 200,
					});
				end
				col = col + #chunk[1];
			end
		end
	end
end

function M.clear(buffer, first, last)
	vim.api.nvim_buf_clear_namespace(buffer, M.ns, first or 0, last or -1);
end

return M;
