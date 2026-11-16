-- Compute a table layout independently of its single-window or split renderer.
local M = {};

---@class markview.table_layout
---@field first integer Zero-based first source row.
---@field last integer Exclusive source row boundary.
---@field lines table[] Flattened highlighted display rows.
---@field rows table[][] Display rows grouped by source row.
---@field row_heights integer[] Number of display rows for each source row.
---@field blank table[] Highlighted empty body row.

local function width(text)
	return vim.fn.strdisplaywidth(text);
end

-- Prefer spaces between words, but split long words/CJK at character boundaries.
local function wrap(text, limit)
	local lines, current = {}, "";
	for _, char in ipairs(vim.fn.split(text, "\\zs")) do
		if width(current .. char) > limit and current ~= "" then
			local before, after = current:match("^(.*)%s+([^%s]*)$");
			if before and before:find("%S") then
				table.insert(lines, vim.trim(before));
				current = after;
			end
			if width(current .. char) > limit and current ~= "" then
				table.insert(lines, current);
				current = "";
			end
		end
		if current ~= "" or char:find("%S") then
			current = current .. char;
		end
	end
	if current ~= "" or #lines == 0 then
		table.insert(lines, current);
	end
	return lines;
end

---@return markview.table_layout?
function M.layout(buffer, item, config, natural_widths)
	if buffer == 0 then buffer = vim.api.nvim_get_current_buf(); end
	if not config or config.wrap == false or vim.fn.has("nvim-0.11") == 0 then
		return;
	end
	local utils = require("markview.utils");
	local win = utils.buf_getwin(buffer);
	if not win or not vim.api.nvim_win_is_valid(win) then return; end
	-- Extmarks are buffer-local, but native wrap positions are window-local.
	-- A single set cannot paint the same source at two different geometries.
	-- Fall back to the original renderer instead of overwriting cell rows.
	for _, other in ipairs(vim.fn.win_findbuf(buffer)) do
		if vim.api.nvim_win_get_width(other) - vim.fn.getwininfo(other)[1].textoff
			~= vim.api.nvim_win_get_width(win) - vim.fn.getwininfo(win)[1].textoff
			or vim.wo[other].wrap ~= vim.wo[win].wrap
			or vim.wo[other].linebreak ~= vim.wo[win].linebreak
			or vim.wo[other].breakindent ~= vim.wo[win].breakindent
			or vim.wo[other].showbreak ~= vim.wo[win].showbreak then
			return;
		end
	end
	local available = vim.api.nvim_win_get_width(win)
		- vim.fn.getwininfo(win)[1].textoff - item.range.col_start - 1;
	if not natural_widths then
		natural_widths = {};
		for _, row in ipairs(vim.list_extend({ item.header, item.separator }, item.rows)) do
			local c = 0;
			for _, cell in ipairs(row) do
				if cell.class == "column" then
					c = c + 1;
					natural_widths[c] = math.max(natural_widths[c] or 0, width(cell.text));
				end
			end
		end
	end
	local count = #natural_widths;
	local natural = count + 1;
	for _, w in ipairs(natural_widths) do natural = natural + w; end
	if natural <= available or count == 0 then return; end

	-- One border per cell, two padding spaces, and at least two text columns.
	local budget = available - (count * 3 + 1);
	if budget < count * 2 then return; end
	local widths, desired, rows = {}, {}, {};
	local stringify = require("markview.renderers.markdown.tostring").tostring;
	for _, row in ipairs(vim.list_extend({ item.header }, item.rows)) do
		local cells = {};
		for _, cell in ipairs(row) do
			if cell.class == "column" then
				local value = vim.trim(stringify(buffer, cell.text)):gsub("\t", "    ");
				table.insert(cells, value);
				local c = #cells;
				desired[c] = math.max(desired[c] or 2, width(value));
			end
		end
		-- Keep unparsed continuation text visible rather than hiding it behind
		-- an empty row when an older Markdown parser cannot recognize it.
		if #cells == 0 then return; end
		table.insert(rows, cells);
	end
	for c = 1, count do widths[c] = 2; end
	for _ = count * 2 + 1, budget do
		local smallest;
		for c = 1, count do
			if widths[c] < (desired[c] or 2)
				and (not smallest or widths[c] < widths[smallest]) then
				smallest = c;
			end
		end
		if not smallest then break; end
		widths[smallest] = widths[smallest] + 1;
	end

	local parts, highlights = config.parts, config.hl;
	local indent = string.rep(" ", item.range.col_start);
	local function hl(kind, i)
		local values = highlights[kind];
		return utils.set_hl(type(values) == "table" and values[math.min(i, #values)] or values);
	end
	local function border(kind)
		local p = parts[kind];
		local chunks = { { indent }, { p[1], hl(kind, 1) } };
		for c = 1, count do
			table.insert(chunks, { string.rep(p[2], widths[c] + 2), hl(kind, 2) });
			table.insert(chunks, { c == count and p[3] or p[4], hl(kind, c == count and 3 or 4) });
		end
		return chunks;
	end
	local function draw(cells, header)
		local wrapped, height, lines = {}, 1, {};
		local kind = header and "header" or "row";
		for c = 1, count do
			wrapped[c] = wrap(cells[c] or "", widths[c]);
			height = math.max(height, #wrapped[c]);
		end
		for l = 1, height do
			local chunks = { { indent }, { parts[kind][1], hl(kind, 1) } };
			for c = 1, count do
				local value = wrapped[c][l] or "";
				local padding = widths[c] - width(value);
				local align = item.alignments[c];
				local left = align == "right" and padding or align == "center" and math.floor(padding / 2) or 0;
				table.insert(chunks, { " " .. string.rep(" ", left) .. value .. string.rep(" ", padding - left) .. " ", header and hl(kind, 2) or "Normal" });
				table.insert(chunks, { parts[kind][c == count and 3 or 2], hl(kind, c == count and 3 or 2) });
			end
			table.insert(lines, chunks);
		end
		return lines;
	end
	local lines = draw(rows[1], true);
	if config.block_decorator then table.insert(lines, 1, border("top")); end
	local row_heights = { #lines, 1 };
	table.insert(lines, border("separator"));
	for r = 2, #rows do
		local drawn = draw(rows[r], false);
		row_heights[#row_heights + 1] = #drawn;
		vim.list_extend(lines, drawn);
	end
	if config.block_decorator then
		table.insert(lines, border("bottom"));
		row_heights[#row_heights] = row_heights[#row_heights] + 1;
	end
	local row_lines, offset = {}, 1;
	for _, h in ipairs(row_heights) do
		row_lines[#row_lines + 1] = vim.list_slice(lines, offset, offset + h - 1);
		offset = offset + h;
	end
	return {
		first = item.range.row_start, last = item.range.row_end,
		rows = row_lines, lines = lines, row_heights = row_heights,
		blank = draw({}, false)[1],
	};
end

function M.render(buffer, item, config, natural_widths)
	local plan = M.layout(buffer, item, config, natural_widths);
	if not plan then return false; end
	require("markview.renderers.markdown.table_state").add(buffer, plan);
	return true;
end

return M;
