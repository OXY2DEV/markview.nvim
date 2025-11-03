local autocmds = {};

autocmds.did_enter = false;
autocmds.pased_vimenter = false;

---@param buffer integer
---@param event_name string
---@param args vim.api.keyset.create_autocmd.callback_args
---@return boolean delay
---@return boolean | nil ignore
autocmds.use_delay = function (buffer, event_name, args)
	local noimmediate_autocmds = { "TextChanged", "TextChangedI" };

	if vim.list_contains(noimmediate_autocmds, event_name) then
		return true;
	elseif event_name == "CursorMoved" or event_name == "CursorMovedI" then
		local actions = require("markview.actions");
		local p_now = actions.in_preview_mode();

		local h_now = actions.in_hybrid_mode();

		---@type integer
		local max_l = require("markview.spec").get({ "preview", "max_buf_lines" }, { fallback = 1000, ignore_enable = true });

		if not p_now then
			return true, true;
		elseif not h_now and vim.api.nvim_buf_line_count(args.buf) < max_l then
			return true, true;
		end

		local MAX = vim.o.lines * 0.75;

		local last = vim.b[buffer].__markview_last_cursor or { 1, 0 };
		local now  = vim.api.nvim_win_get_cursor(tonumber(args.match) or 0);

		vim.b[buffer].__markview_last_cursor = now;

		if math.abs(now[1] - last[1]) >= MAX then
			return false;
		else
			return true;
		end
	elseif event_name == "ModeChanged" then
		local last, now = string.match(args.match, "^(.-):(.+)$");
		local actions = require("markview.actions");

		local p_last, p_now = actions.in_preview_mode(last), actions.in_preview_mode(now);
		local h_last, h_now = actions.in_hybrid_mode(last), actions.in_hybrid_mode(now);

		if h_last and h_now then
			return true, true;
		elseif p_last and p_now then
			return true, true;
		elseif p_last ~= p_now or h_last ~= h_now then
			return false;
		end
	end

	return true, true;
end

---@param args vim.api.keyset.create_autocmd.callback_args
autocmds.should_detach = function (args)
	local state = require("markview.state");

	if not args.buf or not state.enabled() or not state.buf_attached(args.buf) then
		return false;
	elseif not state.get_buffer_state(args.buf, false) then
		return false;
	end

	local spec = require("markview.spec");

	---@type string, string
	local bt, ft = vim.bo[args.buf].buftype, vim.bo[args.buf].filetype;

	local attach_ft = spec.get({ "preview", "filetypes" }, { fallback = {}, ignore_enable = true });
	local ignore_bt = spec.get({ "preview", "ignore_buftypes" }, { fallback = {}, ignore_enable = true });

	local condition = spec.get({ "preview", "condition" }, { eval_args = { args.buf } });

	if vim.list_contains(ignore_bt, bt) == true then
		return true;
	elseif vim.list_contains(attach_ft, ft) == false then
		return true;
	elseif condition == false then
		return true;
	end
end

------------------------------------------------------------------------------

---@param args vim.api.keyset.create_autocmd.callback_args
autocmds.modeChanged = function (args)
	local state = require("markview.state");

	if not args.buf or not state.enabled() or not state.buf_attached(args.buf) then
		return;
	elseif not state.get_buffer_state(args.buf, false) then
		return;
	end

	local use_delay, ignore = autocmds.use_delay(args.buf, args.event, args);

	if ignore then
		return;
	end

	local function action ()
		local actions = require("markview.actions");
		local p_now = actions.in_preview_mode();

		if args.buf == state.get_splitview_source() then
			return;
		elseif p_now then
			actions.render(args.buf);
		else
			actions.clear(args.buf);
		end
	end

	if use_delay then
		vim.defer_fn(action, 0);
	else
		action();
	end
end

---@param args vim.api.keyset.create_autocmd.callback_args
autocmds.bufHandle = function (args)
	local state = require("markview.state");

	if not state.enabled() then
		return;
	elseif not state.buf_safe(args.buf) or state.buf_attached(args.buf) then
		return;
	end

	local spec = require("markview.spec");

	---@type string, string
	local bt, ft = vim.bo[args.buf].buftype, vim.bo[args.buf].filetype;

	local attach_ft = spec.get({ "preview", "filetypes" }, { fallback = {}, ignore_enable = true });
	local ignore_bt = spec.get({ "preview", "ignore_buftypes" }, { fallback = {}, ignore_enable = true });

	local condition = spec.get({ "preview", "condition" }, { eval_args = { args.buf }, ignore_enable = true });

	if vim.list_contains(ignore_bt, bt) == true then
		--- Ignored buffer type.
		return;
	elseif vim.list_contains(attach_ft, ft) == false then
		--- Ignored file type.
		return;
	elseif condition == false then
		return;
	end

	require("markview.actions").attach(args.buf);
end

---@param args vim.api.keyset.create_autocmd.callback_args
autocmds.optionSet = function (args)
	if vim.v.option_old == vim.v.option_new then
		return;
	end

	if vim.list_contains({ "filetype", "buftype" }, args.match) then
		if autocmds.should_detach(args) then
			require("markview.actions").detach(args.buf);
		else
			autocmds.bufHandle(args);
		end
	elseif vim.list_contains({ "wrap", "linebreak" }, args.match) then
		local state = require("markview.state");

		if not state.buf_attached(args.buf) then
			return;
		end

		local actions = require("markview.actions");
		local buf_state = state.get_buffer_state(args.buf, false);

		if state.enabled() and buf_state and buf_state.enable and actions.in_preview_mode() then
			if args.buf == state.get_splitview_source() then
				return;
			else
				actions.render(args.buf);
			end
		end
	end
end

autocmds.cursor_timer = vim.uv.new_timer();

---@param args vim.api.keyset.create_autocmd.callback_args
autocmds.cursor = function (args)
	local state = require("markview.state");
	local actions = require("markview.actions");

	autocmds.cursor_timer:stop();
	local splitview_src = state.get_splitview_source();

	if not args.buf or not state.enabled() or not state.buf_attached(args.buf) then
		return;
	elseif args.buf ~= splitview_src then
		local buf_state = state.get_buffer_state(args.buf, false)

		if not buf_state or not buf_state.enable then
			return;
		end
	end

	local use_delay, ignore = autocmds.use_delay(args.buf, args.event, args);

	if ignore then
		if args.buf == splitview_src then
			actions.splitview_cursor();
		end

		return;
	end

	local function action ()
		local p_now = actions.in_preview_mode();

		if args.buf == state.get_splitview_source() then
			actions.splitview_render();
		elseif p_now then
			actions.render(args.buf);
		else
			actions.clear(args.buf);
		end
	end

	local delay = require("markview.spec").get({ "preview", "debounce" }, { fallback = 25, ignore_enable = true });

	if use_delay then
		autocmds.cursor_timer:start(delay, 0, vim.schedule_wrap(action));
	else
		action();
	end
end

---@param args vim.api.keyset.create_autocmd.callback_args
autocmds.file_changed = function (args)
	local state = require("markview.state");
	local actions = require("markview.actions");

	autocmds.cursor_timer:stop();

	if not state.buf_safe(args.buf) then
		--[[
			ISSUE: Avoid race condition with session plugins

			Some plugins *temporarily* create some file buffers.
			Check if the buffer is valid before advancing.
			See #356
		]]
		return;
	elseif not args.buf or not state.enabled() or not state.buf_attached(args.buf) then
		return;
	else
		local buf_state = state.get_buffer_state(args.buf, false)

		if not buf_state or not buf_state.enable then
			return;
		end
	end

	actions.set_query(args.buf);
end

autocmds.lazy_loaded = function ()
	require("markview.highlights").setup();
	require("markview.integrations").setup();

	autocmds.bufHandle({
		buf = vim.api.nvim_get_current_buf(),

		event = "BufEnter",
		file = vim.api.nvim_buf_get_name(0),

		id = -1,
		match = ""
	});
end

autocmds.setup = function ()
	if autocmds.did_enter then
		return;
	end

	autocmds.did_enter = true;

	vim.api.nvim_create_autocmd("ModeChanged", {
		callback = autocmds.modeChanged
	});

	vim.api.nvim_create_autocmd("OptionSet", {
		callback = autocmds.optionSet
	});

	vim.api.nvim_create_autocmd({
		"BufAdd", "BufEnter",
		"BufWinEnter"
	}, {
		callback = autocmds.bufHandle
	});

	vim.api.nvim_create_autocmd({
		"CursorMoved",  "TextChanged",
		"CursorMovedI", "TextChangedI"
	}, {
		callback = autocmds.cursor
	});

	vim.api.nvim_create_autocmd("FileChangedShellPost", {
		callback = autocmds.file_changed
	});

	vim.api.nvim_create_autocmd({
		"VimEnter",
		"ColorScheme"
	}, {
		callback = function (args)
			require("markview.highlights").setup();

			if args.event == "VimEnter" then
				autocmds.pased_vimenter = true;
				require("markview.integrations").setup();
			end
		end
	});

	if vim.v.vim_did_enter == 1 and autocmds.pased_vimenter == false then
		autocmds.lazy_loaded();
	end
end

return autocmds;
