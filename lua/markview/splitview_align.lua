-- Match rendered object heights with disposable virtual whitespace in either
-- window. Padding never becomes part of the Markdown buffer.
local M = { ns = vim.api.nvim_create_namespace("markview/splitview-align") };

function M.clear(...)
	for i = 1, select("#", ...) do
		local buffer = select(i, ...);
		if buffer == 0 then buffer = vim.api.nvim_get_current_buf(); end
		if buffer and vim.api.nvim_buf_is_valid(buffer) then
			vim.api.nvim_buf_clear_namespace(buffer, M.ns, 0, -1);
		end
		if M.layout and (buffer == M.layout.source_buf or buffer == M.layout.preview_buf) then
			M.layout = nil;
		end
	end
end

local function height(win, first, last)
	local opts = { start_row = first, start_vcol = 0 };
	if last < vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(win)) then
		opts.end_row, opts.end_vcol = last, 0;
	end
	return vim.api.nvim_win_text_height(win, opts).all;
end

local function pad(buffer, row, amount)
	local lines = {};
	for _ = 1, amount do lines[#lines + 1] = { { "" } }; end
	vim.api.nvim_buf_set_extmark(buffer, M.ns, row, 0, {
		strict = false, virt_lines = lines, virt_lines_above = true,
		right_gravity = false, undo_restore = false,
	});
end

function M.update(source_win, preview_win, content, source_first, preview_first, count, mapping)
	local source = vim.api.nvim_win_get_buf(source_win);
	local preview = vim.api.nvim_win_get_buf(preview_win);
	M.clear(source, preview);
	local layout = {
		source_win = source_win, preview_win = preview_win,
		source_buf = source, preview_buf = preview,
		source_first = source_first, preview_first = preview_first,
		source_count = count, mapping = mapping,
	};
	if require("markview.spec").get({ "preview", "splitview_align" }, { fallback = true }) == false then
		layout.sync = false;
		M.layout = layout;
		return;
	end
	-- Refresh linebreak/conceal layout after replacing the preview text. Without
	-- this, text_height can still use widths cached before the last render.
	vim.cmd("redraw");
	local last = preview_first + count;
	local blocks = {};
	for _, item in ipairs(content.markdown or {}) do
		local r = item.range;
		if r and item.class ~= "markdown_section" then
			local stop = r.row_end + ((r.col_end or 0) > 0 and 1 or 0);
			local first = math.max(preview_first, r.row_start);
			stop = math.min(last, stop);
			if stop > first then blocks[#blocks + 1] = { first, stop }; end
		end
	end
	table.sort(blocks, function(a, b) return a[1] == b[1] and a[2] > b[2] or a[1] < b[1]; end);
	local merged = {};
	for _, block in ipairs(blocks) do
		local previous = merged[#merged];
		if previous and block[1] < previous[2] then
			previous[2] = math.max(previous[2], block[2]);
		else
			merged[#merged + 1] = block;
		end
	end
	local function align(first, stop)
		local sf, sl = source_first + first - preview_first, source_first + stop - preview_first;
		local pf, pl = mapping and mapping[first] or first, mapping and mapping[stop] or stop;
		local sh, ph = height(source_win, sf, sl), height(preview_win, pf, pl);
		if sh < ph then pad(source, sl, ph - sh);
		elseif ph < sh then pad(preview, pl, sh - ph); end
	end
	local row = preview_first;
	for _, block in ipairs(merged) do
		while row < block[1] do align(row, row + 1); row = row + 1; end
		align(block[1], block[2]);
		row = block[2];
	end
	while row < last do align(row, row + 1); row = row + 1; end
	-- The caller restores the source view after all padding has been rebuilt,
	-- then synchronizes once. Do not move a viewport during layout calculation.
	M.layout = layout;
end

-- Cursor line numbers alone cannot synchronize a concealed table. Match the
-- viewport's screen offset, including filler lines and soft-wrapped text.
function M.sync_view()
	if not M.layout or M.layout.sync == false then return; end
	local sw, pw = M.layout.source_win, M.layout.preview_win;
	local sf, pf = M.layout.source_first, M.layout.preview_first;
	if not vim.api.nvim_win_is_valid(sw) or not vim.api.nvim_win_is_valid(pw) then return; end
	if vim.api.nvim_win_get_buf(sw) ~= M.layout.source_buf
		or vim.api.nvim_win_get_buf(pw) ~= M.layout.preview_buf then return; end
	local view = vim.api.nvim_win_call(sw, vim.fn.winsaveview);
	local offset = height(sw, 0, view.topline - 1) - view.topfill;
	if view.skipcol > 0 then
		offset = offset + vim.api.nvim_win_text_height(sw, {
			start_row = view.topline - 1, start_vcol = 0,
			end_row = view.topline - 1, end_vcol = view.skipcol,
		}).all;
	end
	offset = math.max(0, offset - height(sw, 0, sf) + height(pw, 0, pf));
	local count = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(pw));
	local low, high = 0, count;
	while low < high do
		local mid = math.floor((low + high) / 2);
		local h = vim.api.nvim_win_text_height(pw, { start_row = 0, start_vcol = 0, end_row = mid }).all;
		if h > offset then high = mid; else low = mid + 1; end
	end
	local row = math.min(low, count - 1);
	local before = height(pw, 0, row);
	local target = { topline = row + 1, topfill = math.max(0, before - offset), skipcol = 0, leftcol = 0 };
	if row < count and offset > before then
		local line = vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(pw), row, row + 1, false)[1];
		local rendered = vim.api.nvim_win_text_height(pw, { start_row = row, start_vcol = 0, end_row = row });
		-- linebreak/inline decorations can make virtual columns exceed the
		-- source string width. Searching only that width truncates skipcol.
		local left, right = 1, math.max(vim.fn.strdisplaywidth(line), rendered.end_vcol) + 1;
		while left < right do
			local mid = math.floor((left + right) / 2);
			local h = vim.api.nvim_win_text_height(pw, { start_row = row, start_vcol = 0, end_row = row, end_vcol = mid }).all;
			if h > offset - before then right = mid; else left = mid + 1; end
		end
		target.skipcol = left - 1;
	end
	-- A mapped source cursor may be far down a rendered table even when its
	-- first rows are at the top of the source viewport. Keep the preview's
	-- cursor inside the requested screen so Neovim does not undo the scroll.
	local cursor = vim.api.nvim_win_get_cursor(pw);
	local cursor_offset = height(pw, 0, cursor[1] - 1);
	local win_height = vim.api.nvim_win_get_height(pw);
	local margin = math.min(vim.wo[pw].scrolloff, math.floor(win_height / 2));
	if cursor_offset < offset + margin or cursor_offset >= offset + win_height - margin then
		target.lnum = math.min(count, row + 1 + margin);
		target.col, target.curswant = 0, 0;
	end
	vim.api.nvim_win_call(pw, function() vim.fn.winrestview(target); end);
end

function M.cursor(buffer, cursor)
	if buffer == 0 then buffer = vim.api.nvim_get_current_buf(); end
	local layout = M.layout;
	local row = cursor[1] - 1;
	if layout and buffer == layout.preview_buf then
		row = row - layout.source_first + layout.preview_first;
		row = math.max(layout.preview_first, math.min(row, layout.preview_first + layout.source_count - 1));
		if layout.mapping then row = layout.mapping[row]; end
	end
	row = math.max(0, math.min(row, vim.api.nvim_buf_line_count(buffer) - 1));
	local text = vim.api.nvim_buf_get_lines(buffer, row, row + 1, false)[1];
	local col = math.min(cursor[2], #text);
	if col < #text then col = vim.fn.byteidx(text, vim.fn.charidx(text, col)); end
	return { row + 1, col };
end

return M;
