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
	-- vim.notify("CALLING WRAP_INDENT WITH ROW " .. tostring(opts.row) .. " whose contents are '" .. (opts.line or "") .. "'");

	local win = utils.buf_getwin(buffer);

	local full_indent_text = "";
	for _, txt_and_hi in ipairs(opts.indent) do
		full_indent_text = full_indent_text .. txt_and_hi[1];
	end
	local indent_len = vim.fn.strdisplaywidth(full_indent_text);

	-- vim.notify("full indent text is '" .. full_indent_text .. "', and its len is " .. tostring(indent_len));

	local win_width = vim.api.nvim_win_get_width(win);
	local textoff = vim.fn.getwininfo(win)[1].textoff;
	local W = win_width - (textoff + indent_len);
	local dsp_w = vim.fn.strdisplaywidth(opts.line or "");

	if dsp_w < W then
		return;
	end

	local win_x = vim.api.nvim_win_get_position(win)[2];
	local offset = win_x + textoff;
	local start_idx_off = 1;
	local num_indents = math.floor(dsp_w / W);

	local start_disp_row = vim.fn.screenpos(win, opts.row + 1, 0).row;

	-- vim.notify("we think that there are " .. num_indents .. " indents for W of " .. W .. " and dsp_w of " .. tostring(dsp_w) .. "(win_width is " .. tostring(win_width) .. ", textoff is " .. tostring(textoff) .. ")");

	for line_to_indent = 0, num_indents do
		-- vim.notify("ok we're looking at line " .. line_to_indent .. " for opts.row " .. opts.row);

		if start_idx_off > 1 then
			start_idx_off = start_idx_off + win_width;
		end

		local passed_start = false;

		while true do
			local pos = vim.fn.screenpos(win, opts.row + 1, start_idx_off);

			-- vim.notify("got a pos at col " .. pos.col .. ", row " .. pos.row .. " for start_idx_off " .. start_idx_off .. ", offset " .. offset);

			local x = pos.col - offset;

			if not passed_start then
				-- if the line we started on + the number of lines we should have traversed by now
				-- is a row number greater than the row that this character appears on, we need to
				-- go to the next character 'cause we're probably right by the beginning of the row,
				-- but just barely on the row above it
				if start_disp_row + line_to_indent > pos.row then
					start_idx_off = start_idx_off + 1;
					goto continue;
				end

				-- if we are on a character *past* the first one, but we haven't already marked *passed_start*,
				-- then we gotta jump back by a bit more than we think
				if (x > 1) and not passed_start then
					start_idx_off = (start_idx_off - (pos.col + 1)) + textoff;
					goto continue;
				end
			end

			-- vim.notify("got past fail loop with col " .. pos.col .. ", row " .. pos.row .. " for start_idx_off " .. start_idx_off);
			-- vim.notify("x is " .. tostring(x) .. ", passed_start? " .. tostring(passed_start));

			if x ~= 1 then
				goto next_line;
			elseif not passed_start then
				passed_start = true;

				if line_to_indent == 0 then
					start_idx_off = start_idx_off + 1;
					goto continue;
				end
			end

			local extmark = wrap.get_extmark(buffer, opts.ns, opts.row, start_idx_off - 1);

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

			-- vim.notify("setting extmark...");

			vim.api.nvim_buf_set_extmark(buffer, opts.ns, opts.row, start_idx_off - 1, extmark_opts);
			start_idx_off = start_idx_off + 1;

			::continue::
		end

		::next_line::
	end

	---|fE
end

return wrap;
