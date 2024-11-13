--- Base module for `markview.nvim`.
--- Contains,
---     • State variables.
---     • Default autocmd group.
---     • Plugin commands implementations.
---     • Setup function.
---     • And various helper functions.
--- And other minor things!
local markview = {};
local spec = require("markview.spec");

--- Plugin state variables.
---@type markview.states
markview.state = {
	enable = true,
	hybrid_mode = true,

	autocmds = {},

	buffer_states = {},
	hybrid_states = {},

	splitview_source = nil,
	splitview_buffer = vim.api.nvim_create_buf(false, true),
	splitview_window = nil
};

--- Gets preview options.
---@param opts string[]
---@param ... any
---@return any
local get_config = function (opts, ...)
	---+${func,  Gets sub-options from the "preview" option.}
	return spec.get(
		vim.list_extend({ "preview" }, opts or {}),
		...
	);
	---_
end

--- Checks if a buffer is already attached.
---@param buffer integer
local buf_attached = function (buffer)
	local autocmds = vim.api.nvim_get_autocmds({
		group = markview.augroup, buffer = buffer
	});
	return not vim.tbl_isempty(autocmds);
end

---@type integer Autocmd group ID.
markview.augroup = vim.api.nvim_create_augroup("markview", { clear = true });

--- Cleans up invalid buffers.
markview.clean = function ()
	---+${func}
	for buffer, cmds in pairs(markview.state.autocmds) do
		if
			not buffer or
			vim.api.nvim_buf_is_loaded(buffer) == false or
			vim.api.nvim_buf_is_valid(buffer) == false
		then
			pcall(vim.api.nvim_del_autocmd, cmds.redraw);
			pcall(vim.api.nvim_del_autocmd, cmds.split_updater);

			markview.state.buffer_states[buffer] = nil;
			markview.state.hybrid_states[buffer] = nil;

			if markview.state.splitview_source == buffer then
				if vim.api.nvim_win_is_valid(markview.state.splitview_window) then
					vim.api.nvim_win_close(markview.state.splitview_window, true);
				end

				markview.state.splitview_source = nil;
			end
		end
	end
	---_
end

--- Checks if the buffer is safe.
---@param buffer integer
---@return boolean
local buf_is_safe = function (buffer)
	---+${func}
	markview.clean();

	if not buffer then
		return false;
	elseif vim.api.nvim_buf_is_valid(buffer) == false then
		return false;
	elseif vim.v.exiting ~= vim.NIL then
		return false;
	end

	return true;
	---_
end

--- Checks if the window is safe.
---@param window integer
---@return boolean
local win_is_safe = function (window)
	---+${func}
	if not window then
		return false;
	elseif vim.api.nvim_win_is_valid(window) == false then
		return false;
	elseif vim.api.nvim_win_get_tabpage(window) ~= vim.api.nvim_get_current_tabpage() then
		return false;
	end

	return true;
	---_
end

--- Checks if the buffer can be attached to.
---@param buffer integer
---@return boolean
local can_attach = function (buffer)
	---+${fund}
	markview.clean();

	if not buf_is_safe(buffer) then
		return false;
	elseif
		vim.list_contains(
			vim.tbl_keys(markview.state.buffer_states)
		)
	then
		return false;
	end

	return true;
	---_
end

--- Checks if decorations can be drawn on a buffer.
---@param buffer integer
---@return boolean
local can_draw = function (buffer)
	---+${func}
	markview.clean();

	if not buf_is_safe(buffer) then
		return false;
	elseif markview.state.enable == false then
		return false;
	elseif markview.state.buffer_states[buffer] == false then
		return false;
	end

	return true;
	---_
end

--- Draws preview on a buffer
---@param buffer integer
markview.draw = function (buffer)
	---+${func}
	if can_draw(buffer) == false then
		if buffer == markview.state.splitview_source then
			markview.commands.splitRedraw();
		end

		return;
	end

	local line_limit = get_config({ "max_file_length" }) or 0;
	local draw_range = get_config({ "render_distance" }) or 0;
	local edit_range = get_config({ "edit_distance" }) or 0;

	local line_count = vim.api.nvim_buf_line_count(buffer);

	local preview_modes = get_config({ "modes" }) or {};
	local hybrid_modes = get_config({ "hybrid_modes" }) or {};

	local mode = vim.api.nvim_get_mode().mode;

	if not vim.list_contains(preview_modes, mode) then return; end

	local parser = require("markview.parser");
	local renderer = require("markview.renderer");
	local content = {};

	markview.clear(buffer);

	if line_count <= line_limit then
		content = parser.parse(buffer, 0, -1, true);
		renderer.render(buffer, content);
	else
		for _, window in ipairs(vim.fn.win_findbuf(buffer)) do
			local cursor = vim.api.nvim_win_get_cursor(window);

			content = parser.init(
				buffer,
				math.max(0, cursor[1] - draw_range),
				math.min(
					vim.api.nvim_buf_line_count(buffer),
					cursor[1] + draw_range
				)
			);

			local clear_from, clear_to = renderer.range(content);

			if clear_from and clear_to then
				renderer.clear(buffer, nil, clear_from, clear_to);
			end

			renderer.render(buffer, content);
		end
	end

	if not vim.list_contains(hybrid_modes, mode) then return; end

	for _, window in ipairs(vim.fn.win_findbuf(buffer)) do
		local cursor = vim.api.nvim_win_get_cursor(window);

		content = parser.init(
			buffer,
			math.max(0, cursor[1] - edit_range[1]),
			math.min(
				vim.api.nvim_buf_line_count(buffer),
				cursor[1] + edit_range[2]
			),
			false
		);

		local clear_from, clear_to = renderer.range(content);

		if clear_from and clear_to then
			renderer.clear(
				buffer,
				get_config({ "ignore_node_classes" }),
				clear_from,
				clear_to
			);
		end
	end
	---_
end

--- Wrapper yo clear decorations from a buffer
---@param buffer integer
markview.clear = function (buffer)
	require("markview.renderer").clear(
		buffer,
		{},
		0,
		-1
	)
end

--- Holds various functions that you can run
--- vim `:Markview ...`.
---@type { [string]: function }
markview.commands = {
	---+${class}
	["attach"] = function (buffer)
		---+${class}
		buffer = buffer or vim.api.nvim_get_current_buf();

		if not can_attach(buffer) then return; end
		local initial_state = get_config({ "enable_preview_on_attach" }) or true;

		if buf_attached(buffer) then
			return;
		end

		markview.state.buffer_states[buffer] = initial_state;
		markview.state.autocmds[buffer] = {};

		local events = get_config({ "redraw_events" }) or {};
		local preview_modes = get_config({ "modes" }) or {};

		if
			vim.list_contains(preview_modes, "n") or
			vim.list_contains(preview_modes, "v")
		then
			table.insert(events, "CursorMoved");
			table.insert(events, "TextChanged");
		end

		if vim.list_contains(preview_modes, "i") then
			table.insert(events, "CursorMovedI");
			table.insert(events, "TextChangedI");
		end

		local debounce_delay = get_config({ "debounce" }) or 50;
		local debounce = vim.uv.new_timer();

		debounce:start(debounce_delay, 0, vim.schedule_wrap(function ()
			local call;

			if initial_state == true then
				markview.draw(buffer);
				call = get_config({ "callbacks", "on_attach" }, false)
			else
				markview.clear(buffer);
				call = get_config({ "callbacks", "on_detach" }, false)
			end

			if call and pcall(call, buffer, vim.fn.win_findbuf(buffer)) then call(buffer, vim.fn.win_findbuf(buffer)); end
		end));

		markview.state.autocmds[buffer].redraw = vim.api.nvim_create_autocmd(events, {
			group = markview.augroup,
			buffer = buffer,
			desc = "Buffer specific preview updater for `markview.nvim`.",

			callback = function ()
				debounce:stop();
				debounce:start(debounce_delay, 0, vim.schedule_wrap(function ()
					--- Drawer function
					markview.draw(buffer);
				end));
			end
		});
		---_
	end,
	["detach"] = function (buffer)
		---+${class}
		buffer = buffer or vim.api.nvim_get_current_buf();
		local call = get_config({ "callbacks", "on_detach" }, false)

		markview.clear(buffer);
		local cmds = markview.state.autocmds[buffer];

		pcall(vim.api.nvim_del_autocmd, cmds.redraw);
		pcall(vim.api.nvim_del_autocmd, cmds.split_updater);

		markview.state.buffer_states[buffer] = nil;
		markview.state.hybrid_states[buffer] = nil;

		if call and pcall(call, buffer, vim.fn.win_findbuf(buffer)) then call(buffer, vim.fn.win_findbuf(buffer)); end
		---_
	end,

	["toggleAll"] = function ()
		---+${class}
		if markview.state.enable == false then
			markview.commands.enableAll()
		else
			markview.commands.disableAll()
		end
		---_
	end,
	["enableAll"] = function ()
		---+${class}
		markview.state.enable = true;

		for _, buf in ipairs(vim.tbl_keys(markview.state.buffer_states)) do
			if can_draw(buf) then
				markview.draw(buf);
			end
		end

		local call = get_config({ "callbacks", "on_state_change" });

		if
			call and
			pcall(
				call,
				vim.tbl_keys(markview.state.buffer_states), markview.state.enable
			)
		then
			call(vim.tbl_keys(markview.state.buffer_states), markview.state.enable);
		end
		---_
	end,
	["disableAll"] = function ()
		---+${class}
		markview.state.enable = false;

		for buf, _ in ipairs(vim.tbl_keys(markview.state.buffer_states)) do
			if buf_is_safe(buf) then
				markview.clear(buf);
			end
		end

		local call = get_config({ "callbacks", "on_state_change" });

		if
			call and
			pcall(
				call,
				vim.tbl_keys(markview.state.buffer_states), markview.state.enable
			)
		then
			call(vim.tbl_keys(markview.state.buffer_states), markview.state.enable);
		end
		---_
	end,

	["toggle"] = function (buffer)
		---+${class}
		buffer = buffer or vim.api.nvim_get_current_buf();
		local state = markview.state.buffer_states[buffer];

		if state == nil then
			return;
		elseif state == true then
			markview.commands.disable(buffer);
		else
			markview.commands.enable(buffer);
		end
		---_
	end,
	["enable"] = function (buffer)
		---+${class}
		buffer = buffer or vim.api.nvim_get_current_buf();
		local call = get_config({ "callbacks", "on_enable" }, false)

		if markview.state.buffer_states[buffer] == nil then
			return;
		elseif buf_is_safe(buffer) == false then
			return;
		end

		markview.state.buffer_states[buffer] = true;
		markview.draw(buffer);

		if call and pcall(call, buffer, vim.fn.win_findbuf(buffer)) then call(buffer, vim.fn.win_findbuf(buffer)); end
		---_
	end,
	["disable"] = function (buffer)
		---+${class}
		buffer = buffer or vim.api.nvim_get_current_buf();
		local call = get_config({ "callbacks", "on_disable" }, false)

		if markview.state.buffer_states[buffer] == nil then
			return;
		elseif buf_is_safe(buffer) == false then
			return;
		end

		markview.state.buffer_states[buffer] = false;
		markview.clear(buffer);

		if call and pcall(call, buffer, vim.fn.win_findbuf(buffer)) then call(buffer, vim.fn.win_findbuf(buffer)); end
		---_
	end,

	["splitToggle"] = function ()
		---+${class}
		if not buf_is_safe(markview.state.splitview_source) then
			markview.commands.splitOpen();
		elseif
			markview.state.splitview_source and
			markview.state.splitview_window and
			vim.api.nvim_win_get_tabpage(markview.state.splitview_window) ~= vim.api.nvim_get_current_tabpage()
		then
			markview.commands.splitClose();
			markview.commands.splitOpen();
		else
			markview.commands.splitClose();
		end
		---_
	end,

	["splitRedraw"] = function ()
		---+${class}
		if
			not markview.state.splitview_source or
			buf_is_safe(markview.state.splitview_source) == false
		then
			markview.commands.splitClose();
			return;
		elseif buf_is_safe(markview.state.splitview_buffer) == false then
			markview.commands.splitClose();
			return;
		elseif win_is_safe(markview.state.splitview_window) == false then
			markview.commands.splitClose();
			return;
		end

		local utils = require("markview.utils");

		vim.api.nvim_buf_set_lines(
			markview.state.splitview_buffer,
			0,
			-1,
			false,
			vim.api.nvim_buf_get_lines(
				markview.state.splitview_source,
				0,
				-1,
				false
			)
		);

		vim.api.nvim_win_set_cursor(
			markview.state.splitview_window,
			vim.api.nvim_win_get_cursor(
				utils.buf_getwin(markview.state.splitview_source)
			)
		);

		markview.draw(markview.state.splitview_buffer)
		---_
	end,

	["splitOpen"] = function (buffer)
		---+${class}
		buffer = buffer or vim.api.nvim_get_current_buf();
		local utils = require("markview.utils");

		if buf_is_safe(buffer) == false then
			return;
		end

		markview.state.splitview_source = buffer;
		markview.state.buffer_states[markview.state.splitview_source] = false;
		markview.clear(markview.state.splitview_source)

		local ft = vim.bo[buffer].filetype;

		if buf_is_safe(markview.state.splitview_buffer) == false then
			markview.state.splitview_buffer = vim.api.nvim_create_buf(false, true);
		end

		vim.bo[markview.state.splitview_buffer].filetype = ft;

		vim.api.nvim_buf_set_lines(
			markview.state.splitview_buffer,
			0,
			-1,
			false,
			vim.api.nvim_buf_get_lines(
				markview.state.splitview_source,
				0,
				-1,
				false
			)
		);

		if win_is_safe(markview.state.splitview_window) == false then
			markview.state.splitview_window = vim.api.nvim_open_win(
				markview.state.splitview_buffer,
				false,
				get_config({
					"splitview_winopts"
				}, markview.state.splitview_buffer) or
				{
					split = "right"
				}
			);
		end

		vim.api.nvim_win_set_cursor(
			markview.state.splitview_window,
			vim.api.nvim_win_get_cursor(
				utils.buf_getwin(markview.state.splitview_source)
			)
		);

		local call = get_config({ "callbacks", "splitview_enable" }, false)

		if
			call and
			pcall(
				call,

				buffer,
				markview.state.splitview_buffer,
				markview.state.splitview_window
			)
		then
			call(
				buffer,
				markview.state.splitview_buffer,
				markview.state.splitview_window
			);
		end

		markview.commands.splitRedraw()
		---_
	end,

	["splitClose"] = function ()
		---+${class}
		if not markview.state.splitview_source then return; end

		if vim.api.nvim_win_is_valid(markview.state.splitview_window) then
			vim.api.nvim_win_close(markview.state.splitview_window, true);
		end

		markview.state.buffer_states[markview.state.splitview_source] = true;
		markview.draw(markview.state.splitview_source);

		markview.state.splitview_source = nil;

		local call = get_config({ "callbacks", "splitview_disable" });
		if call and pcall(call) then call(); end
		---_
	end
	---_
};

--- Executes the given command.
---@param cmd table
markview.exec = function (cmd)
	---+${class, Executes a given command}
	local args = cmd.fargs;

	if
		#args == 0
	then
		markview.commands.toggle(vim.api.nvim_get_current_buf())
	elseif
		vim.list_contains(
			vim.tbl_keys(markview.commands),
			args[1]
		)
	then
		local cmd_name = table.remove(args, 1);
		markview.commands[cmd_name](unpack(args)); ---@diagnostic disable-line
	end
	---_
end

--- Cmdline completion.
---@param arg_lead string
---@param cmdline string
---@param _ integer
---@return string[]
markview.completion = function (arg_lead, cmdline, _)
	---+${class, Completion provider}
	local nargs = 0;
	local args  = {};

	for arg in cmdline:gmatch("(%S+)") do
		if arg == "Markview" then goto continue; end

		nargs = nargs + 1;
		table.insert(args, arg);

		::continue::
	end

	local results = {};

	if
		(nargs == 0) or
		(nargs == 1 and cmdline:match("%S$"))
	then
		for cmd, _ in pairs(markview.commands) do
			if cmd:match(arg_lead) then
				table.insert(results, cmd);
			end
		end
	elseif
		(nargs == 1 and cmdline:match("%s$")) or
		(
			nargs == 2 and
			cmdline:match("%S$") and
			vim.list_contains(
				vim.tbl_keys(markview.commands),
				args[1]
			)
		)
	then
		for _, buf in ipairs(vim.tbl_keys(markview.state.buffer_states)) do
			table.insert(results, tostring(buf));
		end
	end

	table.sort(results);
	return results;
	---_
end

--- Plugin setup function(optional)
---@param config table?
markview.setup = function (config)
	local highlights = require("markview.highlights");

	spec.setup(config);
	---@diagnostic disable-next-line
	highlights.create(highlights.dynamic);
end

return markview;
