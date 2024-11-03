local markview = {};

local spec = require("markview.spec");
---@type markview.cached_state
markview.cache = {}

---@type integer Autocmd group for markview
markview.augroup = vim.api.nvim_create_augroup("markview", { clear = true });

markview.state = {
	enable = true,
	hybrid_mode = true,

	buf_states = {},
	buf_hybrid_states = {},

	split_source = nil,
	split_buffer = vim.api.nvim_create_buf(false, true),
	split_window = nil
};

markview.func_val = function (val, ...)
	if type(val) == "function" and pcall(val, ...) then
		return val(...);
	elseif type(val) ~= "function" then
		return val;
	end
end

markview.get_config = function (opt, fallback)
	if vim.islist(opt) then
		return markview.func_val(spec.get(vim.list_extend({
			"preview"
		}, opt)) or fallback);
	end

	return markview.func_val(spec.get("preview", opt) or fallback);
end

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

markview.draw = function (buffer)
	local parser   = require("markview.parser");
	local renderer = require("markview.renderer");

	if markview.buf_is_safe(buffer) == false then
		return;
	end

	renderer.clear(buffer);

	local mode = vim.api.nvim_get_mode().mode;
	local lines = vim.api.nvim_buf_line_count(buffer);

	if not vim.list_contains(markview.get_config("modes", { "n" }), mode) then
		return;
	end

	local windows = vim.fn.win_findbuf(buffer);

	if lines < markview.get_config("max_file_length", 2) then
		local parsed, _  = parser.init(buffer);
		renderer.render(buffer, parsed);
	else
		for _, window in ipairs(windows) do
			local cursor = vim.api.nvim_win_get_cursor(window);
			local distance = markview.get_config("render_distance", 1);

			local parsed = parser.init(buffer, math.max(0, cursor[1] - distance), math.min(vim.api.nvim_buf_line_count(buffer), cursor[1] + distance));

			local range = { renderer.range(parsed) };

			if #range == 2 then
				renderer.clear(buffer, range[1], range[2]);
			end

			renderer.render(buffer, parsed);
		end
	end


	if #markview.get_config("hybrid_modes", {}) < 1 then
		return;
	elseif markview.state.hybrid_mode == false then
		return;
	elseif markview.state.buf_hybrid_states[buffer] == false then
		return;
	elseif vim.list_contains(markview.get_config("hybrid_modes", {}), mode) then
		for _, window in ipairs(windows) do
			local cursor = vim.api.nvim_win_get_cursor(window);

			local distance = markview.get_config("edit_distance", 1);
			local hidden_content  = parser.init(buffer, math.max(0, cursor[1] - distance), math.min(vim.api.nvim_buf_line_count(buffer), cursor[1] + distance), false);
			local hide_start, hide_end = renderer.range(hidden_content);

			if hide_start and hide_end then
				renderer.clear(buffer, markview.get_config("ignore_node_types", {}), hide_start, hide_end);
			end
		end
	end
end

markview.attach = function (event)
	local buffer  = event.buf;

	if not buffer then
		vim.notify("[ markview.nvim ]: Couldn't detect buffer!", vim.diagnostic.levels.WARN);
		return;
	elseif vim.api.nvim_buf_is_valid(buffer) == false then
		vim.notify("[ markview.nvim ]: Buffer isn't valid!", vim.diagnostic.severity.ERROR);
		return;
	elseif markview.cache[buffer] then
		-- vim.notify("[ markview.nvim ]: Buffer is already attached!", vim.diagnostic.severity.WARN);
		return;
	end

	markview.cache[buffer] = {};
	local redraw_events = {};

	for _, mode in ipairs(markview.get_config("modes", { "n" })) do
		if vim.list_contains({ "n", "v" }, mode) then
			table.insert(redraw_events, "TextChanged")
			table.insert(redraw_events, "CursorMoved")
		elseif vim.list_contains({ "i" }, mode) then
			table.insert(redraw_events, "TextChangedI")
			table.insert(redraw_events, "CursorMovedI")
		end
	end

	if markview.get_config("auto_start", false) == false then
		markview.state.buf_states[buffer] = false;
	else
		markview.state.buf_states[buffer] = true;
		markview.draw(buffer);
	end

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

	if
		spec.get("preview", "callbacks", "on_attach") and
		pcall(spec.get("preview", "callbacks", "on_attach") --[[ @as function ]], buffer, vim.fn.win_findbuf(buffer))
	then
		spec.get("preview", "callbacks", "on_attach")(buffer, vim.fn.win_findbuf(buffer));
	end
end

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

	if
		spec.get("preview", "callbacks", "on_detach") and
		pcall(spec.get("preview", "callbacks", "on_detach") --[[ @as function ]], buffer, vim.fn.win_findbuf(buffer))
	then
		spec.get("preview", "callbacks", "on_detach")(buffer, vim.fn.win_findbuf(buffer));
	end
end

markview.splitview_close = function (buffer)
	buffer = buffer or markview.state.split_source;

	if
		not markview.state.split_source
	then
		return;
	end

	pcall(vim.api.nvim_win_close, markview.state.split_window, true);
	pcall(vim.api.nvim_del_autocmd, markview.cache[buffer].splitview);

	markview.state.split_source = nil;
	markview.state.split_window = nil;

	markview.cache[buffer].splitview = nil;
	markview.state.buf_states[buffer] = true;

	markview.draw(buffer)
end

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

	vim.bo[markview.state.split_buffer].filetype = vim.bo[buffer].filetype;

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

markview.setup = function (config)
	local highlights = require("markview.highlights");

	spec.setup(config);
	highlights.create(spec.config.highlight_groups);
	-- vim.print("hi")
end

return markview;
