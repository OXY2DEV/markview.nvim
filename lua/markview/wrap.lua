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

	-- first, we want to determine exactly how much visual space the entire indent will take up
	local full_indent_text = "";
	for _, txt_and_hi in ipairs(opts.indent) do
		full_indent_text = full_indent_text .. txt_and_hi[1];
	end
	local indent_len = vim.fn.strdisplaywidth(full_indent_text);

	local win_width = vim.api.nvim_win_get_width(win);
	local textoff = vim.fn.getwininfo(win)[1].textoff;
	-- `W` is the max number of characters each line is allowed to be
	local W = win_width - (textoff + indent_len);
	local dsp_w = vim.fn.strdisplaywidth(opts.line or "");

	if dsp_w < W then
		return;
	end

	local win_x = vim.api.nvim_win_get_position(win)[2];
	local offset = win_x + textoff;

	-- `char_inspect_idx` is an index to pass into `screenpos` to determine where the character that we're
	-- currently inspecting visually sits in the neovim grid
	local char_inspect_idx = 1;

	-- `num_indents` is the number of visual lines that this process will end up with.
	local num_indents = math.floor(dsp_w / W);

	-- determine where, on the neovim grid, the {very first character we're inspecting} lies.
	local start_disp_row = vim.fn.screenpos(win, opts.row + 1, 1).row;

	-- now go through each line and add the indent on the front of it
	for line_to_indent = 0, num_indents do
		-- if we're not on the very first line, add a whole line's worth (without the indent 'cause it may not be
		-- considered as applied yet) to go, roughly, to the next line.
		if line_to_indent > 0 then
			char_inspect_idx = char_inspect_idx + (win_width - textoff);
		end

		local passed_start = false;

		for i = 0, W do
			-- get the position of the character we're inspecting
			local pos = vim.fn.screenpos(win, opts.row + 1, char_inspect_idx);

			local x = pos.col - offset;

			-- this block only functions to move `char_inspect_idx` slightly forwards or backwards to find
			-- the very beginning of the line, so if we've already found the start and moved passed it, we
			-- don't need to do any of this determining
			if not passed_start then
				-- if we get here, then we've ran offscreen, like not the whole line can fit or something.
				-- Just bail.
				if pos.row == 0 then
					return;
				end

				-- if the line we started on + the number of lines we should have traversed by now
				-- is a row number greater than the row that this character appears on, we need to
				-- go to the next character 'cause we're probably right by the beginning of the row,
				-- but just barely on the row above it
				if start_disp_row + line_to_indent > pos.row then
					char_inspect_idx = char_inspect_idx + 1;
					goto continue;
				end

				-- if we are on a character *past* the first one, but we haven't already marked *passed_start*,
				-- then we gotta jump back by a bit more than we think
				if x > 1 then
					char_inspect_idx = char_inspect_idx - (pos.col + 1);
					goto continue;
				end
			end

			if x ~= 1 then
				goto next_line;
			elseif not passed_start then
				passed_start = true;

				-- only on the first line do we ignore the very first character, and instead only add the extmarks after it
				if line_to_indent == 0 then
					char_inspect_idx = char_inspect_idx + 1;
					goto continue;
				end
			end

			local extmark = wrap.get_extmark(buffer, opts.ns, opts.row, char_inspect_idx - 1);

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

			vim.api.nvim_buf_set_extmark(buffer, opts.ns, opts.row, char_inspect_idx - 1, extmark_opts);

			-- then just increment to the next character at the end of all this
			char_inspect_idx = char_inspect_idx + 1;

			::continue::
		end

		::next_line::
	end

	---|fE
end

return wrap;
