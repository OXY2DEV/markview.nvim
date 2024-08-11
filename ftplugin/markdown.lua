local markview = require("markview");
local utils = require("markview.utils");

local ts_available, treesitter_parsers = pcall(require, "nvim-treesitter.parsers");
local function parser_installed(parser)
	return (ts_available and treesitter_parsers.has_parser(parser)) or pcall(vim.treesitter.query.get, parser, "highlights")
end

-- Check for requirements
if vim.fn.has("nvim-0.10") == 0 then
	vim.notify("[ markview.nvim ] : This plugin is only available on version 0.10.0 and higher!", vim.log.levels.WARN);
	return;
elseif not parser_installed("markdown") then
	vim.notify("[ markview.nvim ] : Treesitter parser for 'markdown' wasn't found!", vim.log.levels.WARN);
	return;
elseif not parser_installed("markdown_inline") then
	vim.notify("[ markview.nvim ] : Treesitter parser for 'markdown_inline' wasn't found!", vim.log.levels.WARN);
	return;
elseif not parser_installed("html") then
	vim.notify("[ markview.nvim ] : Treesitter parser for 'html' wasn't found! It is required for basic html tag support.", vim.log.levels.WARN);
	return;
end

if vim.islist(markview.configuration.buf_ignore) and vim.list_contains(markview.configuration.buf_ignore, vim.bo.buftype) then
	return
end

-- Don't add hls unless absolutely necessary
if not markview.set_hl_complete and vim.islist(markview.configuration.highlight_groups) then
	markview.add_hls(markview.configuration.highlight_groups)
	markview.set_hl_complete = true;
end

local markview_augroup = vim.api.nvim_create_augroup("markview_buf_" .. vim.api.nvim_get_current_buf(), { clear = true });

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	buffer = vim.api.nvim_get_current_buf(),
	group = markview_augroup,

	callback = function (event)
		local buffer = event.buf;
		local windows = utils.find_attached_wins(event.buf);

		if not vim.list_contains(markview.attached_buffers, buffer) then
			table.insert(markview.attached_buffers, buffer);
			markview.attached_windows = vim.list_extend(markview.attached_windows, windows)
		end

		if markview.state.enable == false then
			-- Call the on_disable callback before exiting
			if not markview.configuration.callbacks or not markview.configuration.callbacks.on_disable then
				return;
			end

			for _, window in ipairs(windows) do
				pcall(markview.configuration.callbacks.on_disable, buffer, window);
			end

			return;
		end

		if markview.state.buf_states[buffer] == false then
			-- Call the on_disable callback before exiting
			-- Even if only the buffer is disabled
			if not markview.configuration.callbacks or not markview.configuration.callbacks.on_disable then
				return;
			end

			for _, window in ipairs(windows) do
				pcall(markview.configuration.callbacks.on_disable, buffer, window);
			end

			return;
		end

		markview.state.buf_states[buffer] = true;

		local lines = vim.api.nvim_buf_line_count(buffer);

		markview.renderer.clear(buffer);

		if lines < (markview.configuration.max_length or 1000) then
			local parsed_content = markview.parser.init(buffer, markview.configuration);

			markview.renderer.render(buffer, parsed_content, markview.configuration)
		else
			local cursor = vim.api.nvim_win_get_cursor(0);
			local start = math.max(0, cursor[1] - (markview.configuration.render_range or 100));
			local stop = math.min(lines, cursor[1] + (markview.configuration.render_range or 100));

			local parsed_content = markview.parser.parse_range(buffer, markview.configuration, start, stop);

			markview.renderer.render(buffer, parsed_content, markview.configuration)
		end

		-- This needs all of the buffer to be parsed
		local keymap_content = markview.parser.init(buffer, markview.configuration);


		markview.keymaps.init(buffer, keymap_content, markview.configuration);
		for _, window in ipairs(windows) do
			if markview.configuration.callbacks and markview.configuration.callbacks.on_enable then
				pcall(markview.configuration.callbacks.on_enable, buffer, window);
			end
		end
	end
});

local cached_mode = nil;
local mode_timer = vim.uv.new_timer();

-- ISSUE: Work in progress
vim.api.nvim_create_autocmd({ "ModeChanged", "TextChanged" }, {
	buffer = vim.api.nvim_get_current_buf(),
	group = markview_augroup,

	callback = function (event)
		local buffer = event.buf;
		local windows = utils.find_attached_wins(event.buf);

		local mode_debounce = 50;

		local mode = vim.api.nvim_get_mode().mode;

		if cached_mode and cached_mode == mode then
			mode_debounce = 0;
		end

		if markview.state.enable == false then
			return;
		end

		if markview.state.buf_states[buffer] == false then
			return;
		end

		mode_timer:stop();
		mode_timer:start(mode_debounce, 0, vim.schedule_wrap(function ()
			mode = vim.api.nvim_get_mode().mode;

			-- Only on mode change or if the mode changed due to text changed
			if mode ~= cached_mode or event.event == "ModeChanged" then
				-- Call the on_mode_change callback before exiting
				if not markview.configuration.callbacks or not markview.configuration.callbacks.on_mode_change then
					goto noCallbacks;
				end

				for _, window in ipairs(windows) do
					pcall(markview.configuration.callbacks.on_mode_change, buffer, window, mode);
				end
			end

			::noCallbacks::

			-- In case something managed to change the mode
			cached_mode = mode; -- Still gotta update the cache

			-- Mode is a valid mode
			if markview.configuration.modes and vim.list_contains(markview.configuration.modes, mode) then
				local lines = vim.api.nvim_buf_line_count(buffer);
				local parsed_content;

				markview.renderer.clear(buffer);

				if lines < (markview.configuration.max_length or 1000) then
					parsed_content = markview.parser.init(buffer, markview.configuration);

					markview.renderer.render(buffer, parsed_content, markview.configuration);
				else
					local cursor = vim.api.nvim_win_get_cursor(0);
					local start = math.max(0, cursor[1] - (markview.configuration.render_range or 100));
					local stop = math.min(lines, cursor[1] + (markview.configuration.render_range or 100));

					parsed_content = markview.parser.parse_range(buffer, markview.configuration, start, stop);

					markview.renderer.render(buffer, parsed_content, markview.configuration)
				end

				markview.keymaps.init(buffer, parsed_content, markview.configuration);

				if not markview.configuration.hybrid_modes or not vim.list_contains(markview.configuration.hybrid_modes, mode) then
					return;
				end

				local cursor = vim.api.nvim_win_get_cursor(0);
				local start = math.max(0, cursor[1] - 1);
				local stop = math.min(lines, cursor[1]);

				local under_cursor = markview.parser.parse_range(event.buf, markview.configuration, start, stop);
				local clear_range = markview.renderer.get_content_range(under_cursor);

				if not clear_range or not clear_range[1] or not clear_range[2] then
					return;
				end

				markview.renderer.clear(event.buf, clear_range[1], clear_range[2])

			-- Mode is not a valid mode. Clear decorations.
			else
				-- Call an extra redraw to flush out screen updates
				markview.renderer.clear(buffer);
				vim.cmd("redraw!");
			end
		end));
	end
});

if not markview.configuration.hybrid_modes then
	return;
end

local events = {}
local move_timer = vim.uv.new_timer();

if vim.list_contains(markview.configuration.hybrid_modes, "n") or vim.list_contains(markview.configuration.hybrid_modes, "v") then
	table.insert(events, "CursorMoved");
end

if vim.list_contains(markview.configuration.hybrid_modes, "i") then
	table.insert(events, "CursorMovedI");
	table.insert(events, "TextChangedI"); -- For smoother experience when writing, potentially can cause bugs
end

vim.api.nvim_create_autocmd(events, {
	buffer = vim.api.nvim_get_current_buf(),
	group = markview_augroup,

	callback = function (event)
		if markview.state.enable == false then
			move_timer:stop();
			return;
		end

		if markview.state.buf_states[event.buf] == false then
			move_timer:stop();
			return;
		end

		move_timer:stop();
		move_timer:start(100, 0, vim.schedule_wrap(function ()
			local mode = vim.api.nvim_get_mode().mode;

			if not markview.configuration.hybrid_modes or not vim.list_contains(markview.configuration.hybrid_modes, mode) then
				return;
			end

			local lines = vim.api.nvim_buf_line_count(event.buf);
			local buffer = event.buf;

			local parsed_content;

			markview.renderer.clear(buffer);

			if lines < (markview.configuration.max_length or 1000) then
				parsed_content = markview.parser.init(buffer, markview.configuration);

				markview.renderer.render(buffer, parsed_content, markview.configuration)
			else
				local cursor = vim.api.nvim_win_get_cursor(0);
				local start = math.max(0, cursor[1] - (markview.configuration.render_range or 100));
				local stop = math.min(lines, cursor[1] + (markview.configuration.render_range or 100));

				parsed_content = markview.parser.parse_range(buffer, markview.configuration, start, stop);

				markview.renderer.render(buffer, parsed_content, markview.configuration)
			end

			if parsed_content and #parsed_content > 0 then
				markview.keymaps.init(buffer, parsed_content, markview.configuration);
			end

			local cursor = vim.api.nvim_win_get_cursor(0);
			local start = math.max(0, cursor[1] - 1);
			local stop = math.min(lines, cursor[1]);

			local under_cursor = markview.parser.parse_range(event.buf, markview.configuration, start, stop);
			local clear_range = markview.renderer.get_content_range(under_cursor);

			if not clear_range or not clear_range[1] or not clear_range[2] then
				return;
			end

			markview.renderer.clear(event.buf, clear_range[1], clear_range[2])
		end));
	end
})

