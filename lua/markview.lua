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
local health = require("markview.health");

---@type markview.state
markview.state = {
	enable = true,

	attached_buffers = {},
	buffer_states = {},

	splitview_buffer = nil,
	splitview_source = nil,
	splitview_window = nil
};

-------------------------------------------------------------------------------------------

--- Simple 1-time renderer for `markview`.
---
--- A buffer must be cleared before being
--- able to render it again.
markview.strict_render = {
	---|fS "feat: Allow rendering buffers only once"

	---@type integer[] Buffers where immediate render was used.
	on = {},

	--- Clears an immediately rendered buffer.
	--- Makes rendering on that buffer possible
	--- again.
	---@param self table
	---@param buffer integer?
	clear = function (self, buffer)
		---|fS

		---@type integer
		buffer = buffer or vim.api.nvim_get_current_buf();

		if vim.list_contains(self.on, buffer) == false then
			return;
		end

		markview.clear(buffer);

		---|fS "chore: Simulate detaching from the buffer"

		markview.actions.__exec_callback("on_disable", buffer, vim.fn.win_findbuf(buffer))
		vim.api.nvim_exec_autocmds("User", {
			pattern = "MarkviewDisable",
			data = {
				buffer = buffer,
				windows = vim.fn.win_findbuf(buffer)
			}
		});

		markview.actions.__exec_callback("on_detach", buffer, vim.fn.win_findbuf(buffer))
		vim.api.nvim_exec_autocmds("User", {
			pattern = "MarkviewDetach",
			data = {
				buffer = buffer,
				windows = vim.fn.win_findbuf(buffer)
			}
		});

		---|fE

		for b, buf in ipairs(self.on) do
			if buf == buffer then
				table.remove(self.on, b);
				return;
			end
		end

		---|fE
	end,

	--- Immediately renders in buffer.
	--- Prevents redrawing on that buffer again(until cleared).
	---@param self table
	---@param buffer integer?
	render = function (self, buffer, max_lines)
		---|fS

		---@type integer
		buffer = buffer or vim.api.nvim_get_current_buf();
		max_lines = max_lines or spec.get({ "prevent", "max_buf_lines" }, { ignore_enable = true, fallback = 1000 });

		if vim.list_contains(self.on, buffer) then
			-- Already rendered.
			return;
		elseif vim.api.nvim_buf_line_count(buffer) >= max_lines then
			-- Buffer is too large.
			return;
		end

		local parser = require("markview.parser");
		local renderer = require("markview.renderer");

		markview.clear(buffer);
		local content = parser.parse(buffer, 0, -1, true);

		---|fS "chore: Simulate attaching to the buffer"

		markview.actions.__exec_callback("on_attach", buffer, vim.fn.win_findbuf(buffer))
		vim.api.nvim_exec_autocmds("User", {
			pattern = "MarkviewAttach",
			data = {
				buffer = buffer,
				windows = vim.fn.win_findbuf(buffer)
			}
		});

		markview.actions.__exec_callback("on_enable", buffer, vim.fn.win_findbuf(buffer))

		--- Execute the enable/disable one too.
		vim.api.nvim_exec_autocmds("User", {
			pattern = "MarkviewEnable",
			data = {
				buffer = buffer,
				windows = vim.fn.win_findbuf(buffer)
			}
		});

		---|fE

		renderer.render(buffer, content);
		table.insert(self.on, buffer);

		---|fE
	end

	---|fE
};

-------------------------------------------------------------------------------------------

--- Cleans up invalid buffers.
markview.clean = function ()
	---|fS

	--- Should a buffer be cleaned?
	---@param buffer integer
	---@return boolean
	local function should_clean(buffer)
		if type(buffer) ~= "number" then
			return true;
		elseif vim.api.nvim_buf_is_loaded(buffer) == false then
			return true;
		elseif vim.api.nvim_buf_is_valid(buffer) == false then
			return true;
		end

		return false;
	end

	for index, buffer in ipairs(markview.state.attached_buffers) do
		if should_clean(buffer) == true then
			table.remove(markview.state.attached_buffers, index);
			markview.state.buffer_states[buffer] = nil;

			if markview.state.splitview_source == buffer then
				markview.actions.splitClose();
			end
		end
	end

	---|fE
end

--- Checks if the buffer is safe.
---@param buffer integer?
---@return boolean
markview.buf_is_safe = function (buffer)
	---$|fS

	if type(buffer) ~= "number" then
		return false;
	elseif vim.api.nvim_buf_is_valid(buffer) == false then
		return false;
	elseif vim.v.exiting ~= vim.NIL then
		-- BUG, there's a bug where if this function
		-- is ran when exiting Neovim, then a crash
		-- happens or an error pops up.
		return false;
	end

	return true;

	---|fE
end

--- Checks if the window is safe.
---@param window integer?
---@return boolean
markview.win_is_safe = function (window)
	---|fS

	if not window then
		return false;
	elseif vim.api.nvim_win_is_valid(window) == false then
		return false;
	elseif vim.api.nvim_win_get_tabpage(window) ~= vim.api.nvim_get_current_tabpage() then
		-- NOTE, Some window functions can't be
		-- called if the window isn't visible/in
		-- the current tab.
		return false;
	end

	return true;

	---|fE
end

--- Checks if the buffer can be attached to.
---@param buffer integer
---@return boolean
markview.can_attach = function (buffer)
	---|fS

	if vim.list_contains(markview.state.attached_buffers, buffer) then
		return false;
	elseif  markview.buf_is_safe(buffer) == false then
		return false;
	end

	return true;

	---|fE
end

--- Wrapper to clear decorations from a buffer
---@param buffer integer
markview.clear = function (buffer)
	buffer = buffer or vim.api.nvim_get_current_buf();
	require("markview.renderer").clear(buffer, 0, -1);
end

--- Renders preview.
---@param buffer integer?
---@param state { enable: boolean, hybrid_mode: boolean? }?
---@param config? markview.config
markview.render = function (buffer, state, config)
	---|fS

	if config then
		spec.tmp_config = vim.tbl_deep_extend("force", spec.default, config);
	end

	---@type integer
	buffer = buffer or vim.api.nvim_get_current_buf();

	local parser = require("markview.parser");
	local renderer = require("markview.renderer");

	---@type integer Number of lines a buffer can have to be fully rendered.
	local line_limit = spec.get({ "preview", "max_buf_lines" }, { fallback = 1000, ignore_enable = true });
	---@type integer Buffer's line count.
	local line_count = vim.api.nvim_buf_line_count(buffer);

	---@type [ integer, integer ] Number of lines to draw on large buffers.
	local draw_range = spec.get({ "preview", "draw_range" }, { fallback = { vim.o.lines, vim.o.lines }, ignore_enable = true });
	---@type [ integer, integer ] Number of lines to be considered being edited.
	local edit_range = spec.get({ "preview", "edit_range" }, { fallback = { 0, 0 }, ignore_enable = true });

	---@type string[] List of modes where to use hybrid_mode.
	local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });
	---@type boolean Is line-wise hybrid mode enabled?
	local linewise_hybrid_mode = spec.get({ "preview", "linewise_hybrid_mode" }, { fallback = false, ignore_enable = true })

	---@type string Current mode shorthand.
	local mode = vim.api.nvim_get_mode().mode;

	state = state or markview.state.buffer_states[buffer];

	local function hybrid_mode()
		if type(state) == "table" and state.hybrid_mode == false then
			return false;
		else
			return vim.list_contains(hybrid_modes, mode);
		end
	end

	markview.clear(buffer);

	if state.enable == false then
		return;
	elseif line_count <= line_limit then
		local content, _ = parser.parse(buffer, 0, -1, true);

		if hybrid_mode() == true and linewise_hybrid_mode == false then
			for _, win in ipairs(vim.fn.win_findbuf(buffer)) do
				---@type [ integer, integer ] Cursor position.
				local cursor = vim.api.nvim_win_get_cursor(win);
				--- 1-index → 0-index
				cursor[1] = cursor[1] - 1;

				content = renderer.filter(content, nil, {
					math.max(0, cursor[1] - edit_range[1]),
					math.min(cursor[1] + edit_range[2], line_count)
				});
			end

			renderer.render(buffer, content);
		elseif hybrid_mode() == true then
			renderer.render(buffer, content);

			for _, win in ipairs(vim.fn.win_findbuf(buffer)) do
				---@type [ integer, integer ] Cursor position.
				local cursor = vim.api.nvim_win_get_cursor(win);
				--- 1-index → 0-index
				cursor[1] = cursor[1] - 1;

				renderer.clear(buffer,
					math.max(0, cursor[1] - edit_range[1]),
					math.min(cursor[1] + 1 + edit_range[2], line_count)
				);
			end
		else
			renderer.render(buffer, content);
		end
	else
		for _, win in ipairs(vim.fn.win_findbuf(buffer)) do
			---@type [ integer, integer ] Cursor position.
			local cursor = vim.api.nvim_win_get_cursor(win);
			--- 1-index → 0-index
			cursor[1] = cursor[1] - 1;

			local content, _ = parser.parse(buffer, math.max(0, cursor[1] - draw_range[1]), math.min(line_count, cursor[1] + draw_range[2]), true);

			if hybrid_mode() == true and linewise_hybrid_mode == false then
				content = renderer.filter(content, nil, {
					math.max(0, cursor[1] - edit_range[1]),
					math.min(cursor[1] + edit_range[2], line_count)
				});

				renderer.render(buffer, content);
			elseif hybrid_mode() == true then
				renderer.render(buffer, content);

				renderer.clear(buffer,
					math.max(0, cursor[1] - edit_range[1]),
					math.min(cursor[1] + 1 + edit_range[2], line_count)
				);
			else
				renderer.clear(buffer, renderer.get_range(content));
				renderer.render(buffer, content);
			end
		end
	end

	if config then
		spec.tmp_config = nil;
	end

	---|fE
end

--- Updates cursor position in splitview.
markview.update_splitview_cursor = function ()
	---|fS

	local utils = require("markview.utils");
	local buffer = markview.state.splitview_source;

	if markview.buf_is_safe(buffer) == false then
		--- Buffer isn't safe.
		-- markview.state.splitview_source = nil;
		pcall(markview.actions.splitClose);
		return;
	elseif markview.win_is_safe(utils.buf_getwin(buffer)) == false then
		--- Buffer doesn't have any windows attached.
		pcall(markview.actions.splitClose);
		return;
	end

	--- In case the preview buffer/window got
	--- deleted, we should regenerate them.
	markview.actions.__splitview_setup();

	local pre_win = markview.state.splitview_window;

	local cursor = vim.api.nvim_win_get_cursor(utils.buf_getwin(buffer));
	pcall(vim.api.nvim_win_set_cursor, pre_win, cursor);

	---|fE
end

markview.splitview_render = function ()
	---|fS

	local utils = require("markview.utils");

	---@type integer
	local buffer = markview.state.splitview_source;

	if markview.buf_is_safe(buffer) == false then
		--- Buffer isn't safe.
		-- markview.state.splitview_source = nil;
		pcall(markview.actions.splitClose);
		return;
	elseif markview.win_is_safe(utils.buf_getwin(buffer)) == false then
		--- Buffer doesn't have any windows attached.
		pcall(markview.actions.splitClose);
		return;
	end

	--- In case the preview buffer/window got
	--- deleted, we should regenerate them.
	markview.actions.__splitview_setup();

	local max_lines = spec.get({ "preview", "max_buf_lines" }, { fallback = 1000, ignore_enable = true });
	local line_count = vim.api.nvim_buf_line_count(buffer);

	local main_win = utils.buf_getwin(buffer);
	local cursor = vim.api.nvim_win_get_cursor(main_win);

	---@type integer, integer
	local pre_buf, pre_win = markview.state.splitview_buffer, markview.state.splitview_window;

	local lines = vim.api.nvim_buf_get_lines(
		buffer,
		math.max(0, cursor[1] - (max_lines + 1)),
		math.min(line_count, cursor[1] + (max_lines + 1)),
		false
	);
	vim.api.nvim_buf_set_lines(
		pre_buf,
		math.max(0, cursor[1] - (max_lines + 1)),
		math.min(line_count, cursor[1] + (max_lines + 1)),
		false,
		lines
	);

	pcall(vim.api.nvim_win_set_cursor, pre_win, cursor);

	markview.render(pre_buf, {
		enable = true,
		hybrid_mode = false
	});

	---|fE
end

-------------------------------------------------------------------------------------------

--- Various actions(provides core functionalities of `markview.nvim`).
markview.actions = {
	---|fS

	["__exec_callback"] = function (autocmd, ...)
		if vim.list_contains({ "string", "integer" }, type(autocmd)) == false then
			--- Invalid data type.
			return;
		end

		local callbacks = spec.get({ "preview", "callbacks" }, { fallback = nil, ignore_enable = true });
		pcall(callbacks[autocmd], ...);

		health.notify("trace", {
			level = 1,
			message = {
				{ "Callback: ", "Special" },
				{ " " .. autocmd .. " ", "DiagnosticVirtualTextInfo" }
			}
		});
	end,
	["__is_attached"] = function (buffer)
		buffer = buffer or vim.api.nvim_get_current_buf();
		return vim.list_contains(markview.state.attached_buffers, buffer);
	end,
	["__is_enabled"] = function (buffer)
		buffer = buffer or vim.api.nvim_get_current_buf();

		if vim.list_contains(markview.state.attached_buffers, buffer) == false then
			return false;
		elseif type(markview.state.buffer_states[buffer]) ~= "table" then
			return false;
		else
			return markview.state.buffer_states[buffer].enable;
		end
	end,

	["__splitview_setup"] = function ()
		---|fS

		if markview.buf_is_safe(markview.state.splitview_source) == false then
			return;
		end

		local utils = require("markview.utils");
		local win = utils.buf_getwin(markview.state.splitview_source);

		if markview.win_is_safe(win) == false then
			markview.actions.splitClose();
			return;
		end

		if markview.buf_is_safe(markview.state.splitview_buffer) == false then
			pcall(vim.api.nvim_buf_delete, markview.state.splitview_buffer, { force = true });
			markview.state.splitview_buffer = vim.api.nvim_create_buf(false, true);
		end

		vim.bo[markview.state.splitview_buffer].ft = vim.bo[markview.state.splitview_source].ft;

		if markview.win_is_safe(markview.state.splitview_window) == false then
			pcall(vim.api.nvim_win_close, markview.state.splitview_window, true);
			markview.state.splitview_window = vim.api.nvim_open_win(
				markview.state.splitview_buffer,
				false,
				spec.get({ "preview", "splitview_winopts", }, {
					fallback = { split = "right" },
					ignore_enable = true
				})
			);
		end

		vim.wo[markview.state.splitview_window].wrap = vim.wo[win].wrap;
		vim.wo[markview.state.splitview_window].linebreak = vim.wo[win].linebreak;

		---|fE
	end,

	["traceExport"] = function ()
		---|fS

		local scrolloff = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].textoff;
		local buf_width = vim.o.columns - scrolloff;

		local version = vim.version();
		local colorscheme = vim.g.colors_name or "";

		local time_col = math.max(20, math.floor((buf_width - 7) * 0.2));
		local desc_col = buf_width - (time_col + 3);

		local function center (text, width)
			if vim.fn.strdisplaywidth(text) > width then
				return vim.fn.strcharpart(text, width);
			else
				local pad_amount = width - vim.fn.strdisplaywidth(text);
				return string.rep(" ", math.ceil(pad_amount / 2)) .. text .. string.rep(" ", math.floor(pad_amount / 2));
			end
		end

		local lines = {
			"Plugin: markview.nvim",
			"Time: " .. os.date(),
			string.format("Nvim version: %d.%d.%d", version.major, version.minor, version.patch),
			"Colorscheme: " .. colorscheme,
			"",
			"Level description,",
			"  1 = START",
			"  2 = PAUSE",
			"  3 = STOP",
			"  4 = ERROR",
			"  5 = LOG",
			"  6 = ENABLE",
			"  7 = DISABLE",
			"  8 = ATTACH",
			"  9 = DETACH",
			"",
			"Trace,",
			string.rep("-", time_col) .. "•-------•" .. string.rep("-", desc_col),
			center("Time-stamp", time_col) .. "|" .. " Level " .. "|" .. center("Action", desc_col),
			string.rep("-", time_col) .. "•-------•" .. string.rep("-", desc_col)
		};

		for _, entry in ipairs(health.log) do
			if entry.kind ~= "trace" then
				goto continue;
			end

			table.insert(lines, string.format(
				"%s|%s| %s",
				center(
					string.format("%-12s", string.rep("  ", entry.indent) .. entry.timestamp),
					time_col
				),
				center(tostring(entry.level or 0), 7),
				entry.message
			));

		    ::continue::
		end

		table.insert(lines, string.rep("-", time_col) .. "•-------•" .. string.rep("-", desc_col))
		table.insert(lines, "");
		table.insert(lines, "vim:nomodifiable:nowrap:nospell:");

		local trace_file = io.open("trace.txt", "w");

		if not trace_file then
			return;
		end

		trace_file:write(table.concat(lines, "\n"));
		trace_file:close();

		---|fE
	end,
	["traceShow"] = function (from, to)
		health.trace_open(from, to);
	end,

	--- Registers a buffer to be preview-able.
	---@param buffer integer?
	["attach"] = function (buffer, state)
		---|fS

		---@type integer
		buffer = buffer or vim.api.nvim_get_current_buf();

		if markview.can_attach(buffer) == false then
			--- Failed to attach.
			return;
		end

		health.notify("trace", {
			level = 8,
			message = string.format("Attached: %d", buffer)
		});
		health.__child_indent_in();

		---@type boolean Should preview be enabled on the buffer?
		local enable = spec.get({ "preview", "enable" }, { fallback = true, ignore_enable = true });
		---@type boolean Should hybrid mode be enabled on the buffer?
		local hm_enable = spec.get({ "preview", "enable_hybrid_mode" }, { fallback = true, ignore_enable = true });

		table.insert(markview.state.attached_buffers, buffer);

		if state then
			markview.state.buffer_states[buffer] = state;
		elseif markview.state.buffer_states[buffer] == nil then
			markview.state.buffer_states[buffer] = {
				enable = enable,
				events = true,
				hybrid_mode = hm_enable,
			};
		end

		---@type boolean Whether `gx` should be remapped.
		local map_gx = spec.get({ "preview", "map_gx" }, { ignore_enable = true, fallback = true });

		if map_gx == true then
			vim.api.nvim_buf_set_keymap(buffer, "n", "gx", "<CMD>Markview open<CR>", {
				desc = "Tree-sitter based link opener from `markview.nvim`."
			});
		end

		--- Execute the attaching callback.
		markview.actions.__exec_callback("on_attach", buffer, vim.fn.win_findbuf(buffer))
		--- Execute the autocmd too.
		vim.api.nvim_exec_autocmds("User", {
			pattern = "MarkviewAttach",
			data = {
				buffer = buffer,
				windows = vim.fn.win_findbuf(buffer)
			}
		});

		if enable == true then
			markview.actions.__exec_callback("on_enable", buffer, vim.fn.win_findbuf(buffer))

			--- Execute the enable/disable one too.
			vim.api.nvim_exec_autocmds("User", {
				pattern = "MarkviewEnable",
				data = {
					buffer = buffer,
					windows = vim.fn.win_findbuf(buffer)
				}
			});
			markview.render(buffer);

			if hm_enable == true then
				--- Execute the hybrid mode enabling callback.
				markview.actions.__exec_callback("on_hybrid_enable", buffer, vim.fn.win_findbuf(buffer))
				--- Execute the autocmd too.
				vim.api.nvim_exec_autocmds("User", {
					pattern = "MarkviewHybridEnable",
					data = {
						buffer = buffer,
						windows = vim.fn.win_findbuf(buffer)
					}
				});
			else
				--- Execute the hybrid mode disabling callback.
				markview.actions.__exec_callback("on_hybrid_disable", buffer, vim.fn.win_findbuf(buffer))
				--- Execute the autocmd too.
				vim.api.nvim_exec_autocmds("User", {
					pattern = "MarkviewHybridDisable",
					data = {
						buffer = buffer,
						windows = vim.fn.win_findbuf(buffer)
					}
				});
			end
		else
			markview.actions.__exec_callback("on_disable", buffer, vim.fn.win_findbuf(buffer))
			markview.clear(buffer);

			--- Execute the enable/disable one too.
			vim.api.nvim_exec_autocmds("User", {
				pattern = "MarkviewDisable",
				data = {
					buffer = buffer,
					windows = vim.fn.win_findbuf(buffer)
				}
			});
		end

		health.__child_indent_de();
		---|fE
	end,
	--- Detaches previewer from a buffer.
	---@param buffer integer?
	["detach"] = function (buffer)
		---|fS

		---@type integer
		buffer = buffer or vim.api.nvim_get_current_buf();

		if markview.buf_is_safe(buffer) == false then
			--- Something went wrong.
			return;
		elseif markview.can_attach(buffer) == true then
			--- This buffer hasn't been attached to.
			return;
		end

		health.notify("trace", {
			level = 9,
			message = string.format("Detached: %d", buffer)
		});
		health.__child_indent_in();

		--- Execute the attaching autocmd.
		markview.actions.__exec_callback("on_detach", buffer, vim.fn.win_findbuf(buffer))
		--- Execute the autocmd too.
		vim.api.nvim_exec_autocmds("User", {
			pattern = "MarkviewDetach",
			data = {
				buffer = buffer,
				windows = vim.fn.win_findbuf(buffer)
			}
		});

		--- Remove the entry.
		--- DON'T REMOVE THE STATES THOUGH!
		--- (We may need them in the future)
		for i, buf in ipairs(markview.state.attached_buffers) do
			if buf == buffer then
				table.remove(markview.state.attached_buffers, i);
			end
		end

		--- Clear decorations too!
		markview.clear(buffer);
		health.__child_indent_de()
		---|fE
	end,

	["disable"] = function (buffer)
		---|fS
		---@type integer
		buffer = buffer or vim.api.nvim_get_current_buf();

		if markview.actions.__is_attached(buffer) == false then
			return;
		elseif type(markview.state.buffer_states[buffer]) ~= "table" then
			markview.state.buffer_states[buffer] = nil;
			return;
		elseif buffer == markview.state.splitview_source then
			markview.state.buffer_states[buffer].enable = false;
			markview.state.buffer_states[buffer].y = -999;

			return;
		end

		health.notify("trace", {
			level = 7,
			message = string.format("Disabled: %d", buffer)
		});
		health.__child_indent_in();

		markview.state.buffer_states[buffer].enable = false;
		markview.clear(buffer);

		--- Execute the attaching autocmd.
		markview.actions.__exec_callback("on_disable", buffer, vim.fn.win_findbuf(buffer))
		--- Execute the autocmd too.
		vim.api.nvim_exec_autocmds("User", {
			pattern = "MarkviewDisable",
			data = {
				buffer = buffer,
				windows = vim.fn.win_findbuf(buffer)
			}
		});

		local mode = vim.api.nvim_get_mode().mode;
		---@type string[]
		local hybd_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });

		if vim.list_contains(hybd_modes, mode) == false then
			health.__child_indent_de();
			return;
		end

		--- Execute the attaching autocmd.
		markview.actions.__exec_callback("on_hybrid_disable", buffer, vim.fn.win_findbuf(buffer))
		--- Execute the autocmd too.
		vim.api.nvim_exec_autocmds("User", {
			pattern = "MarkviewHybridDisable",
			data = {
				buffer = buffer,
				windows = vim.fn.win_findbuf(buffer)
			}
		});
		health.__child_indent_de();
		---|fE
	end,
	["enable"] = function (buffer)
		---|fS
		---@type integer
		buffer = buffer or vim.api.nvim_get_current_buf();

		if markview.actions.__is_attached(buffer) == false then
			return;
		elseif type(markview.state.buffer_states[buffer]) ~= "table" then
			markview.state.buffer_states[buffer] = nil;
			return;
		elseif buffer == markview.state.splitview_source then
			markview.state.buffer_states[buffer].enable = true;
			markview.splitview_render();
			return;
		end

		health.notify("trace", {
			level = 6,
			message = string.format("Enabled: %d", buffer)
		});
		health.__child_indent_in();

		markview.state.buffer_states[buffer].enable = true;

		local mode = vim.api.nvim_get_mode().mode;
		---@type string[]
		local prev_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
		---@type string[]
		local hybd_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });

		if vim.list_contains(prev_modes, mode) == false then
			health.__child_indent_de();
			return;
		end

		markview.render(buffer);

		--- Execute the attaching autocmd.
		markview.actions.__exec_callback("on_enable", buffer, vim.fn.win_findbuf(buffer))
		--- Execute the autocmd too.
		vim.api.nvim_exec_autocmds("User", {
			pattern = "MarkviewEnable",
			data = {
				buffer = buffer,
				windows = vim.fn.win_findbuf(buffer)
			}
		});

		if vim.list_contains(hybd_modes, mode) == false then
			health.__child_indent_de();
			return;
		end

		--- Execute the attaching autocmd.
		markview.actions.__exec_callback("on_hybrid_enable", buffer, vim.fn.win_findbuf(buffer))
		--- Execute the autocmd too.
		vim.api.nvim_exec_autocmds("User", {
			pattern = "MarkviewHybridEnable",
			data = {
				buffer = buffer,
				windows = vim.fn.win_findbuf(buffer)
			}
		});
		health.__child_indent_de();
		---|fE
	end,

	["hybridEnable"] = function (buffer)
		---|fS

		buffer = buffer or vim.api.nvim_get_current_buf();

		if markview.actions.__is_attached(buffer) == false then
			return;
		elseif markview.state.buffer_states[buffer] then
			markview.state.buffer_states[buffer].hybrid_mode = true;

			if markview.state.buffer_states[buffer].enable == false then
				return;
			elseif buffer == markview.state.splitview_source then
				return;
			end

			markview.render(buffer);

			local mode = vim.api.nvim_get_mode().mode;
			---@type string[]
			local hybd_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });

			if vim.list_contains(hybd_modes, mode) == false then
				return;
			end

			--- Execute the attaching autocmd.
			markview.actions.__exec_callback("on_hybrid_enable", buffer, vim.fn.win_findbuf(buffer))
			--- Execute the autocmd too.
			vim.api.nvim_exec_autocmds("User", {
				pattern = "MarkviewHybridEnable",
				data = {
					buffer = buffer,
					windows = vim.fn.win_findbuf(buffer)
				}
			});
		end

		---|fE
	end,

	["hybridDisable"] = function (buffer)
		---|fS

		buffer = buffer or vim.api.nvim_get_current_buf();

		if markview.actions.__is_attached(buffer) == false then
			return;
		elseif markview.state.buffer_states[buffer] then
			markview.state.buffer_states[buffer].hybrid_mode = false;

			if markview.state.buffer_states[buffer].enable == false then
				return;
			elseif buffer == markview.state.splitview_source then
				return;
			end

			markview.render(buffer);

			local mode = vim.api.nvim_get_mode().mode;
			---@type string[]
			local hybd_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });

			if vim.list_contains(hybd_modes, mode) == false then
				return;
			end

			--- Execute the attaching autocmd.
			markview.actions.__exec_callback("on_hybrid_disable", buffer, vim.fn.win_findbuf(buffer))
			--- Execute the autocmd too.
			vim.api.nvim_exec_autocmds("User", {
				pattern = "MarkviewHybridDisable",
				data = {
					buffer = buffer,
					windows = vim.fn.win_findbuf(buffer)
				}
			});
		end

		---|fE
	end,

	["splitOpen"] = function (buffer)
		--|fS

		---@type integer
		buffer = buffer or vim.api.nvim_get_current_buf();

		if markview.buf_is_safe(buffer) == false then
			return;
		end

		markview.actions.splitClose();

		if markview.actions.__is_enabled(buffer) == true then
			markview.actions.__exec_callback("on_disable", buffer, vim.fn.win_findbuf(buffer));
			vim.api.nvim_exec_autocmds("User", {
				pattern = "MarkviewDisable",
				data = {
					buffer = buffer,
					windows = vim.fn.win_findbuf(buffer)
				}
			});
		end

		markview.state.splitview_source = buffer;
		markview.actions.__splitview_setup();
		markview.clear(buffer);

		markview.actions.__exec_callback("on_splitview_open", buffer, markview.state.splitview_buffer, markview.state.splitview_window);
		vim.api.nvim_exec_autocmds("User", {
			pattern = "MarkviewSplitviewOpen",
			data = {
				source = buffer,
				preview_buffer = markview.state.splitview_buffer,
				preview_window = markview.state.splitview_window
			}
		});

		markview.splitview_render();
		---|fE
	end,
	["splitClose"] = function ()
		---|fS
		if type(markview.state.splitview_source) ~= "number" then
			--- Splitview's source buffer isn't a number. Why?
			--- Assuming it's `nil`, we should stop here.
			return;
		end

		--- FEAT, Allow `on_splitview_close` to take arguments
		--- regarding splitview.
		markview.actions.__exec_callback("on_splitview_close", markview.state.splitview_source, markview.state.splitview_buffer, markview.state.splitview_window);
		vim.api.nvim_exec_autocmds("User", {
			pattern = "MarkviewSplitviewClose",
			data = {
				source = markview.state.splitview_source,
				preview_buffer = markview.state.splitview_buffer,
				preview_window = markview.state.splitview_window
			}
		});

		--- Attempt to close the window.
		--- Also remove the reference to that window.
		pcall(vim.api.nvim_win_close, markview.state.splitview_window, true);

		--- We should also clean up the preview buffer(if possible).
		if markview.buf_is_safe(markview.state.splitview_buffer) == true then
			markview.clear(markview.state.splitview_buffer);
			vim.api.nvim_buf_set_lines(markview.state.splitview_buffer, 0, -1, false, {});
		end

		---@type integer
		local buffer = markview.state.splitview_source;

		markview.state.splitview_window = nil;
		markview.state.splitview_source = nil;

		if markview.buf_is_safe(buffer) == false then
			--- Source buffer isn't safe for `markview` to work.
			return;
		elseif type(markview.state.buffer_states[buffer]) ~= "table" then
			--- We never attached to the source buffer.
			return;
		end

		markview.actions.__exec_callback("on_enable", buffer, vim.fn.win_findbuf(buffer));
		vim.api.nvim_exec_autocmds("User", {
			pattern = "MarkviewEnable",
			data = {
				buffer = buffer,
				windows = vim.fn.win_findbuf(buffer)
			}
		});

		--- Don't forget to render the preview if possible.
		if markview.state.buffer_states[buffer].enable == true then
			markview.render(buffer);
		end
		---|fE
	end

	---|fE
};

--- Holds various functions that you can run
--- vim `:Markview ...`.
---@type { [string]: function }
markview.commands = {
	---|fS

	["traceExport"] = function ()
		markview.actions.traceExport();
	end,
	["traceShow"] = function (from, to)
		if pcall(tonumber, from) and pcall(tonumber, to) then
			health.trace_open(tonumber(from), tonumber(to));
		else
			health.trace_open();
		end
	end,

	["attach"] = function (buffer)
		markview.actions.attach(buffer);
	end,
	["detach"] = function (buffer)
		markview.actions.detach(buffer);
	end,

	["Toggle"] = function ()
		---|fS
		for _, buf in ipairs(markview.state.attached_buffers) do
			markview.commands.toggle(buf);
		end
		---|fE
	end,
	["Enable"] = function ()
		for _, buf in ipairs(markview.state.attached_buffers) do
			markview.actions.enable(buf);
		end
	end,
	["Disable"] = function ()
		for _, buf in ipairs(markview.state.attached_buffers) do
			markview.actions.disable(buf);
		end
	end,

	["Render"] = function ()
		for _, buf in ipairs(markview.state.attached_buffers) do
			if markview.actions.__is_enabled(buf) then
				markview.render(buf);
			end
		end
	end,
	["Clear"] = function ()
		for _, buf in ipairs(markview.state.attached_buffers) do
			if markview.actions.__is_enabled(buf) then
				markview.clear(buf);
			end
		end
	end,

	["render"] = function (buffer)
		buffer = buffer or vim.api.nvim_get_current_buf();

		markview.render(buffer);
	end,
	["clear"] = function (buffer)
		buffer = buffer or vim.api.nvim_get_current_buf();

		markview.clear(buffer);
	end,

	["toggleAll"] = function ()
		health.notify("deprecation", {
			option = ":Markview toggleAll",
			alter = ":Markview Toggle",
			silent = true
		});

		markview.commands.Toggle();
	end,
	["enableAll"] = function ()
		health.notify("deprecation", {
			option = ":Markview enableAll",
			alter = ":Markview Enable",
			silent = true
		});

		markview.commands.Enable();
	end,
	["disableAll"] = function ()
		health.notify("deprecation", {
			option = ":Markview disableAll",
			alter = ":Markview Disable",
			silent = true
		});

		markview.commands.Disable();
	end,

	["toggle"] = function (buffer)
		---|fS
		buffer = buffer or vim.api.nvim_get_current_buf();

		local state = markview.state.buffer_states[buffer];

		if state == nil then
			return;
		elseif state.enable == true then
			markview.commands.disable(buffer);
		else
			markview.commands.enable(buffer);
		end
		---|fE
	end,
	["enable"] = function (buffer)
		markview.actions.enable(buffer)
	end,
	["disable"] = function (buffer)
		markview.actions.disable(buffer)
	end,

	["hybridToggle"] = function (buffer)
		buffer = buffer or vim.api.nvim_get_current_buf();

		if markview.actions.__is_attached(buffer) == false then
			return;
		elseif type(markview.state.buffer_states[buffer]) ~= "table" then
			return;
		elseif markview.state.buffer_states[buffer].hybrid_mode == true then
			markview.actions.hybridDisable(buffer);
		else
			markview.actions.hybridEnable(buffer);
		end
	end,
	["hybridDisable"] = function (buffer)
		markview.actions.hybridDisable(buffer);
	end,
	["hybridEnable"] = function (buffer)
		markview.actions.hybridEnable(buffer);
	end,

	["linewiseEnable"] = function ()
		spec.config.preview.linewise_hybrid_mode = true;

		for _, buf in ipairs(markview.state.attached_buffers) do
			if markview.actions.__is_enabled(buf) then
				markview.render(buf);
			end
		end
	end,
	["linewiseDisable"] = function ()
		spec.config.preview.linewise_hybrid_mode = false;

		for _, buf in ipairs(markview.state.attached_buffers) do
			if markview.actions.__is_enabled(buf) then
				markview.render(buf);
			end
		end
	end,
	["linewiseToggle"] = function ()
		---@type boolean Is line-wise hybrid mode enabled?
		local linewise_hybrid_mode = spec.get({ "preview", "linewise_hybrid_mode" }, { fallback = false, ignore_enable = true });

		spec.config.preview.linewise_hybrid_mode = not linewise_hybrid_mode;

		for _, buf in ipairs(markview.state.attached_buffers) do
			if markview.actions.__is_enabled(buf) then
				markview.render(buf);
			end
		end
	end,

	["HybridToggle"] = function ()
		for _, buf in ipairs(markview.state.attached_buffers) do
			markview.commands.hybridToggle(buf);
		end
	end,

	["HybridDisable"] = function ()
		for _, buf in ipairs(markview.state.attached_buffers) do
			markview.commands.hybridDisable(buf);
		end
	end,

	["HybridEnable"] = function ()
		for _, buf in ipairs(markview.state.attached_buffers) do
			markview.commands.hybridEnable(buf);
		end
	end,

	["splitToggle"] = function ()
		---|fS

		if type(markview.state.splitview_source) ~= "number" then
			markview.actions.splitOpen();
		elseif markview.win_is_safe(markview.state.splitview_window) == false then
			markview.actions.splitClose();
			markview.actions.splitOpen();
		else
			markview.actions.splitClose();
		end
		---|fE
	end,

	["splitRedraw"] = function ()
		markview.splitview_render();
	end,

	["splitOpen"] = function (buffer)
		markview.actions.splitOpen(buffer)
	end,

	["splitClose"] = function ()
		markview.actions.splitClose()
	end,

	["Start"] = function ()
		markview.state.enable = true;
	end,
	["Stop"] = function ()
		markview.state.enable = false;
	end,

	["open"] = function ()
		require("markview.links").open();
	end
	---|fE
};

-------------------------------------------------------------------------------------------

--- Plugin setup function(optional)
---@param config table?
markview.setup = function (config)
	spec.setup(config);

	local highlights = require("markview.highlights");
	highlights.setup(spec.get({ "highlight_groups" }, { fallback = {} }));

	markview.commands.Render();
end

return markview;
-- vim:foldmethod=marker:foldmarker=|fS,|fE:
