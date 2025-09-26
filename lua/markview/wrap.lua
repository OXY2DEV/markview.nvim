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
		local textoff = vim.fn.getwininfo(win)[1].textoff;

		local win_x = vim.api.nvim_win_get_position(win)[2];

		local text = vim.api.nvim_buf_get_lines(buffer, row, row + 1, false)[1];
		local chars = vim.fn.split(text, "\\zs");

		local c = 0;
		local before_start = true;

		local last_screencol = math.huge;

		for _, char in ipairs(chars) do
			c = c + #char;

			local x = vim.fn.screenpos(win, row + 1, c).col - (win_x + textoff);

			if x < last_screencol and before_start == true then
				before_start = false;
			elseif  x < last_screencol then
				local indent_opts = {
					undo_restore = false, invalidate = true,
					right_gravity = false,

					virt_text_pos = "inline",
					hl_mode = "combine",

					virt_text = indent;
				};

				vim.api.nvim_buf_set_extmark(
					buffer,
					ns,
					row,
					c - 1,
					indent_opts
				);
			end

			last_screencol = x;
		end
	end

	for row, indent in pairs(wrap.cache[buffer] or {}) do
		render_line(row, indent);
	end

	wrap.cache[buffer] = {};

	---|fE
end

return wrap;
