---@class markview.wrap.opts
---
---@field indent [ string, string? ][] Text to use as indentation in wraps.
---@field line string Text to wrap.
---@field ns integer Namespace for `extmarks`.
---@field row integer Row of line(**0-indexed**).

---@alias markview.wrap.data.value [ string, string? ][]

---@class markview.wrap.data
---
---@field [integer] [ string, string? ][]

------------------------------------------------------------------------------

--[[
Text soft-wrapping support for `markview.nvim`.

Usage,

```lua
vim.o.wrap = true;
```

>[!NOTE]
> Make sure not to *disable* wrapping for Nodes!
]]
local wrap = {};
local utils = require("markview.utils");

---@type table<integer, markview.wrap.data>
wrap.cache = {};

--[[ Registers `indent` to be used for `range` in `buffer`. ]]
---@param buffer integer
---@param range { row: integer }
---@param indent markview.wrap.data.value
wrap.wrap_indent = function (buffer, range, indent)
	---|fS

	if not wrap.cache[buffer] then
		wrap.cache[buffer] = {};
	end

	local row = range.row;

	if not wrap.cache[buffer][row] then
		wrap.cache[buffer][row] = {};
	end

	---@type integer? Window to use for 
	local win = utils.buf_getwin(buffer);

	if not win then
		return;
	end

	local height = vim.api.nvim_win_text_height(win, {
		start_row = range.row,
		end_row = range.row
	});

	if height.all == 1 then
		return;
	end

	wrap.cache[buffer][row] = vim.list_extend(wrap.cache[buffer][row], indent);

	---|fE
end

--[[
Wraps text based on *heuristics*. Relies on `virt_text_win_col`.
Based on the original pull request(#393) by @itsjunetime.

NOTE: This works by positioning the `extmark` in the estimated wrap position.

Then we use `virt_text_win_col` to place it at the start of that *wrapped* line.
]]
---@param buffer integer
---@param win integer
---@param row integer
---@param ns integer
---@param indent [ string, string? ][]
wrap.huristic_wrap = function (buffer, win, row, ns, indent)
	---|fS

	local textoff = vim.fn.getwininfo(win)[1].textoff;

	local win_w = vim.api.nvim_win_get_width(win);
	local width = win_w - textoff;

	local text = vim.api.nvim_buf_get_lines(buffer, row, row + 1, false)[1] or "";

	---|fS "chunk: Calculate text width"

	---@type table<integer, integer> Maps a `display width` to it's `character index`.
	local dsp_char_map = {};
	local text_width = 0;

	for c, char in ipairs(vim.fn.split(text, "\\zs")) do
		local w = vim.fn.strdisplaywidth(char);

		for _w = 1, w, 1 do
			dsp_char_map[text_width + _w] = c;
		end

		text_width = text_width + w;
	end

	---|fE

	---@type integer Number of soft-wraps.
	local divisions = math.floor(text_width / width);

	for d = 1, divisions, 1 do
		local char = dsp_char_map[d * width];

		local indent_opts = {
			undo_restore = false, invalidate = true,
			right_gravity = false,

			virt_text_pos = "inline",
			hl_mode = "combine",

			virt_text = indent;
			virt_text_win_col = 0
		};


		vim.api.nvim_buf_set_extmark(
			buffer,
			ns,
			row,
			char - 1,
			indent_opts
		);
	end

	---|fE
end

--[[ Provides `wrapped indentation` to some text. ]]
---@param buffer integer
wrap.render = function (buffer, ns)
	---|fS

	---@type integer? Window to use for 
	local win = utils.buf_getwin(buffer);

	if not win then
		return;
	end

	local function render_line (row, indent)
		wrap.huristic_wrap(buffer, win, row, ns, indent);
	end

	for row, indent in pairs(wrap.cache[buffer] or {}) do
		render_line(row, indent);
	end

	wrap.cache[buffer] = {};

	---|fE
end

return wrap;
