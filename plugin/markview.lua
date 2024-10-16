local markview = require("markview");
local utils = require("markview.utils");
local hls = require("markview.highlights");
local ts = require("markview.treesitter");

if vim.fn.has("nvim-0.10.0") == 0 then
	vim.notify("[ markview.nvim ]: Neovim version >=0.10 required!", vim.diagnostic.severity.ERROR)
	return;
end

---@diagnostic disable
ts.inject(markview.configuration.injections)
hls.create(markview.configuration.highlight_groups)
---@diagnostic enable

local buf_render = function (buffer)
	local lines = vim.api.nvim_buf_line_count(buffer);
	local parsed_content;

	local mode = vim.api.nvim_get_mode().mode;

	if lines < (markview.configuration.max_file_length or 1000) then
		-- Buffer isn't too big. Render everything
		parsed_content = markview.parser.init(buffer, markview.configuration);

		markview.renderer.render(buffer, parsed_content, markview.configuration)
	else
		-- Buffer is too big, render only parts of it
		local cursor = vim.api.nvim_win_get_cursor(0);
		local start = math.max(0, cursor[1] - markview.configuration.render_distance);
		local stop = math.min(lines, cursor[1] + markview.configuration.render_distance);

		parsed_content = markview.parser.init(buffer, markview.configuration, start, stop);

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
	local node = vim.treesitter.get_node({ bufnr = buffer, pos = { cursor[1] - 1, cursor[2]} });

	--- Don't hide stuff on specific nodes
	while node:parent() do
		if vim.list_contains(markview.configuration.ignore_nodes or {}, node:type()) then
			return;
		end

		node = node:parent();
	end

	-- Range to start & stop parsing
	local start = math.max(0, cursor[1] - 1);
	local stop = math.min(lines, cursor[1]);

	-- Get the contents range to clear
	local under_cursor = markview.parser.init(buffer, markview.configuration, start, stop);
	local clear_range = markview.renderer.get_content_range(under_cursor);

	-- Content range was invalid, nothing to clear
	if not clear_range or not clear_range[1] or not clear_range[2] then
		return;
	end

	markview.renderer.clear(buffer, clear_range[1], clear_range[2])
end



local redraw_autocmd = function (augroup, buffer, validate)
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
			local debounce = markview.configuration.debounce;

			-- Current mode
			local mode = vim.api.nvim_get_mode().mode;

			if event.event == "ModeChanged" and cached_mode == mode then
				debounce = 0;
			end

			timer:stop();
			timer:start(debounce, 0, vim.schedule_wrap(function ()
				if markview.autocmds[buffer] and markview.autocmds[buffer].was_detached == true then
					return;
				end

				if markview.state.enable == false or markview.state.buf_states[buffer] == false then
					return;
				end

        			if not vim.api.nvim_buf_is_loaded(buffer) then
          				return;
        			end

				if validate == false then
					goto noValidation;
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

				::noValidation::


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
				elseif vim.tbl_isempty(markview.configuration.modes) then
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
	markview.autocmds[buffer] = {
		was_detached = false,
		id = tmp
	}
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
		local mode = vim.api.nvim_get_mode().mode;

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

			goto addAutocmd;
		end

		-- Set state to true and call the callback
		markview.state.buf_states[buffer] = markview.configuration.initial_state;

		if markview.state.buf_states[buffer] == false or not vim.list_contains(markview.configuration.modes, mode) then
			for _, window in ipairs(windows) do
				if markview.configuration.callbacks and markview.configuration.callbacks.on_disable then
					pcall(markview.configuration.callbacks.on_disable, buffer, window);
				end
			end
		else
			for _, window in ipairs(windows) do
				if markview.configuration.callbacks and markview.configuration.callbacks.on_enable then
					pcall(markview.configuration.callbacks.on_enable, buffer, window);
				end
			end

			-- Clear the buffer before rendering things
			markview.renderer.clear(buffer);
			buf_render(buffer);
		end

		::addAutocmd::
		-- Augroup for the special autocmds
		local markview_augroup = vim.api.nvim_create_augroup("markview_buf_" .. buffer, { clear = true });
		redraw_autocmd(markview_augroup, buffer);
	end
})

vim.api.nvim_create_autocmd({ "User" }, {
	desc = "Attaches markview to the buffers",
	pattern = "MarkviewEnter",
	callback = function (event)
		local buffer = event.buf;

		if vim.list_contains(markview.attached_buffers, buffer) then
			return;
		end

		local windows = utils.find_attached_wins(buffer);
		local mode = vim.api.nvim_get_mode().mode;

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
		markview.state.buf_states[buffer] = markview.configuration.initial_state;

		if markview.state.buf_states[buffer] == false or not vim.list_contains(markview.configuration.modes, mode) then
			for _, window in ipairs(windows) do
				if markview.configuration.callbacks and markview.configuration.callbacks.on_disable then
					pcall(markview.configuration.callbacks.on_disable, buffer, window);
				end
			end
		else
			for _, window in ipairs(windows) do
				if markview.configuration.callbacks and markview.configuration.callbacks.on_enable then
					pcall(markview.configuration.callbacks.on_enable, buffer, window);
				end
			end

			-- Clear the buffer before rendering things
			markview.renderer.clear(buffer);
			buf_render(buffer);
		end

		-- Augroup for the special autocmds
		local markview_augroup = vim.api.nvim_create_augroup("markview_buf_" .. buffer, { clear = true });
		redraw_autocmd(markview_augroup, buffer, false);
	end
})

vim.api.nvim_create_autocmd("User", {
	pattern = "MarkviewLeave",
	callback = function (event)
		if not markview.autocmds[event.buf] then
			return;
		elseif markview.autocmds[event.buf].was_detached == true then
			return;
		end

		local data = markview.autocmds[event.buf];
		markview.renderer.clear(event.buf);
		data.was_detached = true;

		vim.api.nvim_del_autocmd(data.id);
		markview.unload(event.buf);
	end
});

