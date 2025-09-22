---@class markview.wrap.opts
---
---@field indent [ string, string? ][] Text to use as indentation in wraps.
---@field line string Text to wrap.
---@field ns integer Namespace for `extmarks`.
---@field row integer Row of line(**0-indexed**).

------------------------------------------------------------------------------

--[[ Text wrapping for `markview.nvim`. ]]
local wrap = {};
local utils = require("markview.utils");

--[[ Gets extmark for `[ lnum, col ]`. ]]
---@param buffer integer
---@param ns integer
---@param lnum integer
---@param col integer
---@return vim.api.keyset.get_extmark_item
wrap.get_extmark = function (buffer, ns, lnum, col)
	local extmarks = vim.api.nvim_buf_get_extmarks(buffer, ns, { lnum, col }, { lnum, col + 1 }, {
		details = true,
		type = "virt_text"
	});

	return extmarks[1];
end

--[[ Provides `wrapped indentation` to some text. ]]
---@param buffer integer
---@param opts markview.wrap.opts
wrap.wrap_indent = function (buffer, opts)
	---|fS

	local win = utils.buf_getwin(buffer);

	local win_width = vim.api.nvim_win_get_width(win);
	local textoff = vim.fn.getwininfo(win)[1].textoff;
	local W = win_width - textoff;
	local dsp_w = vim.fn.strdisplaywidth(opts.line or "");

	if dsp_w < W then
		return;
	end

	local win_x = vim.api.nvim_win_get_position(win)[2];
	local passed_start = false;
	local offset = win_x + textoff;

	for c = 1, dsp_w do
		--- `l` should be 1-indexed.
		---@type integer
		local x = vim.fn.screenpos(win, opts.row + 1, c).col - offset;

		if x == 0 then
			goto continue;
		if x ~= 1 then
			return;
		elseif passed_start == false then
			passed_start = true;
			goto continue;
		end

		local extmark = wrap.get_extmark(buffer, opts.ns, opts.row, c - 1);

		local extmark_opts = {
			undo_restore = false, invalidate = true,
			right_gravity = false,

			virt_text_pos = "inline",
			virt_text = opts.indent or {},

			hl_mode = "combine",
		};

		if extmark ~= nil then
			extmark_opts.id = extmark[1];
			extmark_opts.virt_text = vim.list_extend(extmark_opts.virt_text, extmark[4].virt_text);
		end

		vim.api.nvim_buf_set_extmark(buffer, opts.ns, opts.row, c - 1, extmark_opts);

		::continue::
	end

	---|fE
end

return wrap;
