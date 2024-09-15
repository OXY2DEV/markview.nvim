local markview = require("markview");
local utils = require("markview.utils");
local hls = require("markview.highlights");
local ts = require("markview.treesitter");

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


ts.inject(markview.configuration.injections)
hls.create(markview.configuration.highlight_groups)

local buf_render = function (buffer)
	local lines = vim.api.nvim_buf_line_count(buffer);
	local parsed_content;

	local mode = vim.api.nvim_get_mode().mode;

	if lines < (markview.configuration.max_length or 1000) then
		-- Buffer isn't too big. Render everything
		parsed_content = markview.parser.init(buffer, markview.configuration);

		markview.renderer.render(buffer, parsed_content, markview.configuration)
	else
		-- Buffer is too big, render only parts of it
		local cursor = vim.api.nvim_win_get_cursor(0);
		local start = math.max(0, cursor[1] - (markview.configuration.render_range or 100));
		local stop = math.min(lines, cursor[1] + (markview.configuration.render_range or 100));

		parsed_content = markview.parser.parse_range(buffer, markview.configuration, start, stop);

		markview.renderer.render(buffer, parsed_content, markview.configuration)
	end

	markview.keymaps.init(buffer, parsed_content, markview.configuration);

	-- Don't do hybrid mode stuff unless needed
	if not markview.configuration.hybrid_modes or not vim.list_contains(markview.configuration.hybrid_modes, mode) then
		return;
	elseif markview.state.hybrid_mode == false then
		return;
	end

	local win = utils.find_attached_wins(buffer)[1];

	-- Get the cursor
	local cursor = vim.api.nvim_win_get_cursor(win or 0);

	-- Range to start & stop parsing
	local start = math.max(0, cursor[1] - 1);
	local stop = math.min(lines, cursor[1]);

	-- Get the contents range to clear
	local under_cursor = markview.parser.parse_range(buffer, markview.configuration, start, stop);
	local clear_range = markview.renderer.get_content_range(under_cursor);

	-- Content range was invalid, nothing to clear
	if not clear_range or not clear_range[1] or not clear_range[2] then
		return;
	end

	markview.renderer.clear(buffer, clear_range[1], clear_range[2])
end



local redraw_autocmd = function (augroup, buffer)
	local update_events = { "BufEnter", "ModeChanged", "TextChanged" };

	if vim.list_contains(markview.configuration.modes, "n") or vim.list_contains(markview.configuration.modes, "v") then
		table.insert(update_events, "CursorMoved");
	end

	if vim.list_contains(markview.configuration.modes, "i") then
		table.insert(update_events, "CursorMovedI");
		table.insert(update_events, "TextChangedI"); -- For smoother experience when writing, potentially can cause bugs
	end

	-- Mode
	local cached_mode = vim.api.nvim_get_mode().mode;
	local timer = vim.uv.new_timer();

	-- This is just a cache
	local r_autocmd;

	local tmp = vim.api.nvim_create_autocmd(update_events, {
		buffer = buffer,
		group = augroup,
		callback = function (event)
			local windows = utils.find_attached_wins(buffer);
			local debounce = markview.configuration.debounce or 50;

			-- Current mode
			local mode = vim.api.nvim_get_mode().mode;

			if event.event == "ModeChanged" and cached_mode == mode then
				debounce = 0;
			end

			timer:stop();
			timer:start(debounce, 0, vim.schedule_wrap(function ()
				if markview.state.enable == false or markview.state.buf_states[buffer] == false then
					return;
				end

				--- Incorrect file type
				if not vim.list_contains(markview.configuration.filetypes or { "markdown" }, vim.bo[buffer].filetype) then
					markview.unload();
					vim.api.nvim_del_autocmd(r_autocmd);

					return;
				end

				-- Incorrect buffer type
				if vim.islist(markview.configuration.buf_ignore) and vim.list_contains(markview.configuration.buf_ignore, vim.bo[buffer].buftype) then
					markview.unload();
					vim.api.nvim_del_autocmd(r_autocmd);

					return
				end


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

				cached_mode = mode; -- Still gotta update the cache

				if vim.list_contains(markview.configuration.modes, mode) then
					markview.renderer.clear(buffer);
					buf_render(buffer);
				else
					markview.renderer.clear(buffer);
					vim.cmd("redraw!");
				end
			end));
		end
	});

	r_autocmd = tmp;
end

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	desc = "Attaches markview to the buffers",
	callback = function (event)
		local buffer = event.buf;

		local ft = vim.bo[buffer].filetype;
		local bt = vim.bo[buffer].buftype;

		--- Incorrect file type
		if not vim.list_contains(markview.configuration.filetypes or { "markdown" }, ft) then
			return;
		end

		-- Incorrect buffer type
		if vim.islist(markview.configuration.buf_ignore) and vim.list_contains(markview.configuration.buf_ignore, bt) then
			return
		end

		local windows = utils.find_attached_wins(buffer);

		-- If not attached then attach
		if not vim.list_contains(markview.attached_buffers, buffer) then
			table.insert(markview.attached_buffers, buffer);
			markview.attached_windows = vim.list_extend(markview.attached_windows, windows);
		end

		-- Plugin is disabled
		if markview.state.enable == false or markview.state.buf_states[buffer] == false then
			-- Call the on_disable callback before exiting
			if not markview.configuration.callbacks or not markview.configuration.callbacks.on_disable then
				return;
			end

			for _, window in ipairs(windows) do
				pcall(markview.configuration.callbacks.on_disable, buffer, window);
			end

			return;
		end

		-- Set state to true and call the callback
		markview.state.buf_states[buffer] = true;

		for _, window in ipairs(windows) do
			if markview.configuration.callbacks and markview.configuration.callbacks.on_enable then
				pcall(markview.configuration.callbacks.on_enable, buffer, window);
			end
		end

		-- Clear the buffer before rendering things
		markview.renderer.clear(buffer);
		buf_render(buffer);

		-- Augroup for the special autocmds
		local markview_augroup = vim.api.nvim_create_augroup("markview_buf_" .. buffer, { clear = true });

		redraw_autocmd(markview_augroup, buffer);
	end
})


