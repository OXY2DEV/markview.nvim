--- Module for handling various core functionalities
--- of `markview`. E.g.
---     • Buffer attach/detach.
---     • Drawing/clearing previews.
---     • Hybrid mode & split view implementation.
--- 
local markview = {};
local spec = require("markview.spec");

---@type markview.cached_state
markview.cache = {}

---@type integer Autocmd group for markview
markview.augroup = vim.api.nvim_create_augroup("markview", { clear = true });

---@type markview.state Various plugin state variables.
markview.state = {
	enable = true,
	hybrid_mode = true,

	buf_states = {},
	buf_hybrid_states = {},

	split_source = nil,
	split_buffer = vim.api.nvim_create_buf(false, true),
	split_window = nil
};

--- Returns the evaluated value of a variable.
--- If `val` is not a function, it is returned
--- without any change.
---@param val any
---@param ... any
---@return any
markview.func_val = function (val, ...)
	if type(val) == "function" and pcall(val, ...) then
		return val(...);
	elseif type(val) ~= "function" then
		return val;
	end
end

--- Gets preview options.
--- Also handles fallback values & functions.
---@param opt string
---@param fallback any
---@return any
markview.get_config = function (opt, fallback)
	if vim.islist(opt) then
		return markview.func_val(spec.get(vim.list_extend({
			"preview"
		}, opt)) or fallback);
	end

	return markview.func_val(spec.get("preview", opt) or fallback);
end

--- Checks if a buffer is safe to use.
---@param buffer integer
---@return boolean
markview.buf_is_safe = function (buffer)
	if not buffer then
		markview.detach({ buf = buffer });
		return false;
	elseif vim.api.nvim_buf_is_valid(buffer) == false then
		markview.detach({ buf = buffer });
		return false;
	elseif markview.state.enable == false then
		return false;
	elseif markview.state.buf_states[buffer] == false then
		return false;
	elseif vim.v.exiting ~= vim.NIL then
		return false;
	end

	return true;
end

--- Preview drawing function.
---@param buffer integer
markview.draw = function (buffer)
	local parser   = require("markview.parser");
	local renderer = require("markview.renderer");

	if markview.buf_is_safe(buffer) == false then
		return;
	end

	--- Clear previously drawn extmarks(if any exists).
	renderer.clear(buffer);

	local mode = vim.api.nvim_get_mode().mode;
	local lines = vim.api.nvim_buf_line_count(buffer);

	--- Return if the mode isn't a preview mode.
	if not vim.list_contains(markview.get_config("modes", {}), mode) then
		return;
	end

	local windows = vim.fn.win_findbuf(buffer);

	--- Choose rendering mode,
	---     • Full, In case the file is shorter then `max_file_length`.
	---     • Partial, In case the file is longer then `max_file_length`.
	if lines < markview.get_config("max_file_length", 1000) then
		local parsed, _  = parser.init(buffer);
		renderer.render(buffer, parsed);
	else
		--- Do a render for each window.
		--- This ensures support for multi-window uses.
		for _, window in ipairs(windows) do
			local cursor = vim.api.nvim_win_get_cursor(window);
			local distance = markview.get_config("render_distance", 100);

			--- Parse things within the `distance` from
			--- the cursor.
			local parsed = parser.init(
				buffer,
				math.max(0, cursor[1] - distance),
				math.min(
					vim.api.nvim_buf_line_count(buffer),
					cursor[1] + distance
				)
			);

			local range = { renderer.range(parsed) };

			--- Range can be { nil, nil }, if no content
			--- was parsed.
			--- Ignore in that case.
			if #range == 2 then
				renderer.clear(buffer, range[1], range[2]);
			end

			renderer.render(buffer, parsed);
		end
	end

	--- Don't clear things under cursor if,
	---     • Hybrid mode isn't set(or {}).
	---     • Hybrid mode is disabled(globally or on buffer)
	if #markview.get_config("hybrid_modes", {}) < 1 then
		return;
	elseif markview.state.hybrid_mode == false then
		return;
	elseif markview.state.buf_hybrid_states[buffer] == false then
		return;
	elseif vim.list_contains(markview.get_config("hybrid_modes", {}), mode) then
		--- Clear range of nodes under the cursor(± `edit_distance`).
		--- Do it per window to support multi-window setup.
		for _, window in ipairs(windows) do
			local cursor = vim.api.nvim_win_get_cursor(window);

			local distance = markview.get_config("edit_distance", 1);
			local hidden_content  = parser.init(buffer, math.max(0, cursor[1] - distance), math.min(vim.api.nvim_buf_line_count(buffer), cursor[1] + distance), false);
			local hide_start, hide_end = renderer.range(hidden_content);

			if hide_start and hide_end then
				renderer.clear(
					buffer,
					markview.get_config("ignore_node_types", {}),
					hide_start,
					hide_end
				);
			end
		end
	end
end

--- Attaches to a buffer.
---@param event table
markview.attach = function (event)
	local buffer  = event.buf;

	if not buffer then
		vim.notify("[ markview.nvim ]: Couldn't detect buffer!", vim.diagnostic.levels.WARN);
		return;
	elseif vim.api.nvim_buf_is_valid(buffer) == false then
		vim.notify("[ markview.nvim ]: Buffer isn't valid!", vim.diagnostic.severity.ERROR);
		return;
	elseif markview.cache[buffer] then
		--- Don't show message for this as this can happen in
		--- some scenarios where an error didn't occur.
		---
		-- vim.notify("[ markview.nvim ]: Buffer is already attached!", vim.diagnostic.severity.WARN);
		return;
	end

	--- Clear the cache, as it may be outdated
	--- or `nil`.
	markview.cache[buffer] = {};
	local redraw_events = {};

	for _, mode in ipairs(markview.get_config("modes", { "n" })) do
		if vim.list_contains({ "n", "v" }, mode) then
			table.insert(redraw_events, "TextChanged");
			table.insert(redraw_events, "CursorMoved");
		elseif vim.list_contains({ "i" }, mode) then
			table.insert(redraw_events, "TextChangedI");
			table.insert(redraw_events, "CursorMovedI");
		end
	end

	--- If `auto_start` is disabled then only set
	--- the state and don't redraw.
	---
	--- State is set to "false" to prevent drawing
	--- from events/mode change.
	if markview.get_config("auto_start", false) == false then
		markview.state.buf_states[buffer] = false;
	else
		markview.state.buf_states[buffer] = true;
		markview.draw(buffer);
	end

	--- Use a timer to debounce the drawing process
	--- as otherwise this will hamper performance
	--- of Neovim(especially on "mobile").
	local timer = vim.uv.new_timer()

	markview.cache[buffer].redraw = vim.api.nvim_create_autocmd(redraw_events, {
		group = markview.augroup,
		buffer = buffer,
		callback = function (ev)
			timer:stop();
			timer:start(markview.get_config("debounce", 50), 0, vim.schedule_wrap(function ()
				if markview.buf_is_safe(event.buf) == false then
					return;
				end

				markview.draw(ev.buf or buffer);
			end));
		end
	});

	--- Run the `on_attach` callback.
	---@diagnostic disable
	if
		spec.get("preview", "callbacks", "on_attach") and
		pcall(
			spec.get("preview", "callbacks", "on_attach"),
			buffer,
			vim.fn.win_findbuf(buffer)
		)
	then
		spec.get("preview", "callbacks", "on_attach")(buffer, vim.fn.win_findbuf(buffer));
	end
	---@diagnostic enable
end

--- Detaches from an attached buffer
---@param event table
markview.detach = function (event)
	local buffer  = event.buf;
	local renderer = require("markview.renderer");

	if not buffer then
		vim.notify("[ markview.nvim ]: Couldn't detect buffer!", vim.diagnostic.levels.WARN);
		return;
	elseif vim.api.nvim_buf_is_valid(buffer) == false then
		vim.notify("[ markview.nvim ]: Buffer isn't valid!", vim.diagnostic.severity.ERROR);
		return;
	elseif not markview.cache[buffer] then
		vim.notify("[ markview.nvim ]: Buffer isn't attached!", vim.diagnostic.severity.WARN);
		return;
	end

	renderer.clear(buffer);
	vim.api.nvim_del_autocmd(markview.cache[buffer].redraw);
	markview.cache[buffer] = nil;

	--- Run the `on_detach` callback.
	---@diagnostic disable
	if
		spec.get("preview", "callbacks", "on_detach") and
		pcall(
			spec.get("preview", "callbacks", "on_detach"),
			buffer,
			vim.fn.win_findbuf(buffer)
		)
	then
		spec.get("preview", "callbacks", "on_detach")(buffer, vim.fn.win_findbuf(buffer));
	end
	---@diagnostic enable
end

--- Closes the split view window
---@param buffer integer?
markview.splitview_close = function (buffer)
	--- Always an integer.
	---
	---@cast buffer integer
	buffer = buffer or markview.state.split_source;

	if
		not markview.state.split_source
	then
		return;
	end

	--- Close the preview window.
	--- Delete the redraw autocmd.
	pcall(vim.api.nvim_win_close, markview.state.split_window, true);
	pcall(vim.api.nvim_del_autocmd, markview.cache[buffer].splitview);

	markview.state.split_source = nil;
	markview.state.split_window = nil;

	markview.cache[buffer].splitview = nil;
	markview.state.buf_states[buffer] = true;

	--- Draw stuff back on the main buffer(if possible).
	markview.draw(buffer)
end

--- Opens split view
---@param buffer integer
markview.splitview_open = function (buffer)
	if markview.buf_is_safe(buffer) == false then
		return;
	end

	local renderer = require("markview.renderer");

	markview.state.buf_states[buffer] = false;
	markview.state.split_source = buffer;

	if
		not markview.state.split_buffer or
		vim.api.nvim_buf_is_valid(markview.state.split_buffer) == false
	then
		markview.state.split_buffer = vim.api.nvim_create_buf(false, true);
	end

	if not markview.state.split_window then
		markview.state.split_window = vim.api.nvim_open_win(
			markview.state.split_buffer,
			false,
			markview.func_val(spec.get("splitview", "window") or {
				split = "right"
			})
		);
	elseif vim.api.nvim_win_is_valid(markview.state.split_window) == false then
		pcall(vim.api.nvim_win_close, markview.state.split_window, true);

		markview.state.split_window = vim.api.nvim_open_win(
			markview.state.split_buffer,
			false,
			markview.func_val(spec.get("splitview", "window") or {
				split = "right"
			})
		);
	end

	--- Inherit filetype from original buffer.
	vim.bo[markview.state.split_buffer].filetype = vim.bo[buffer].filetype;

	--- Copy the lines.
	vim.api.nvim_buf_set_lines(
		markview.state.split_buffer,
		0,
		-1,
		false,
		vim.api.nvim_buf_get_lines(
			buffer,
			0,
			-1,
			false
		)
	);

	--- Set cursor position.
	--- Only the first attached window's cursor
	--- is used.
	if #vim.fn.win_findbuf(buffer) > 0 then
		vim.api.nvim_win_set_cursor(
			markview.state.split_window,
			vim.api.nvim_win_get_cursor(vim.fn.win_findbuf(buffer)[1])
		);
	end

	markview.draw(markview.state.split_buffer);

	local timer = vim.uv.new_timer();

	if not markview.cache[buffer] then
		markview.cache[buffer] = {};
	end

	--- It doesn't make sense to only redraw on specific
	--- modes.
	--- May change over time.
	markview.cache[buffer].splitview = vim.api.nvim_create_autocmd({
		"TextChanged", "TextChangedI",
		"CursorMoved", "CursorMovedI"
	}, {
		group = markview.augroup,
		buffer = buffer,
		callback = function (ev)
			timer:stop();
			timer:start(markview.get_config("debounce", 25), 0, vim.schedule_wrap(function ()
				if markview.buf_is_safe(markview.state.split_buffer) == false then
					return;
				elseif
					not buffer or
					vim.api.nvim_buf_is_valid(buffer) == false
				then
					return;
				elseif
					vim.api.nvim_win_is_valid(markview.state.split_window) == false
				then
					markview.splitview_close();
					return;
				end

				renderer.clear(markview.state.split_buffer);

				vim.api.nvim_buf_set_lines(
					markview.state.split_buffer,
					0,
					-1,
					false,
					vim.api.nvim_buf_get_lines(
						ev.buf,
						0,
						-1,
						false
					)
				);

				--- Set cursor position.
				--- Only use the first attached window.
				if #vim.fn.win_findbuf(buffer) > 0 then
					vim.api.nvim_win_set_cursor(
						markview.state.split_window,
						vim.api.nvim_win_get_cursor(vim.fn.win_findbuf(buffer)[1])
					);
				end

				markview.draw(markview.state.split_buffer);
			end));
		end
	});
end

--- Plugin setup function(optional)
---@param config table?
markview.setup = function (config)
	local highlights = require("markview.highlights");

	spec.setup(config);
	highlights.create(spec.config.highlight_groups);
end

return markview;
