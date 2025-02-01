--- Functionality provider for `markview.nvim`.
--- Functionalities that are implemented,
---
---   + Buffer registration.
---   + Command.
---   + Dynamic highlight groups.
---
--- **Author**: MD. Mouinul Hossain Shawon (OXY2DEV)

local markview = require("markview");
local spec = require("markview.spec");
local health = require("markview.health");

health.notify("trace", {
	level = 1,
	message = "Start"
});

--- Was the completion source loaded?
if vim.g.markview_cmp_loaded == nil then
	vim.g.markview_cmp_loaded = false;
end

 ------------------------------------------------------------------------------------------

--- Sets up the highlight groups.
--- Should be called AFTER loading
--- colorschemes.
require("markview.highlights").setup();

health.notify("trace", {
	level = 5,
	message = "Created highlight groups"
});

local available_directives = vim.treesitter.query.list_directives();

if vim.list_contains(available_directives, "conceal-patch!") == false then
	--- FIX, Patch for the broken (fenced_code_block) concealment.
	--- Doesn't hide leading spaces before ```.
	vim.treesitter.query.add_directive("conceal-patch!", function (match, _, bufnr, predicate, metadata)
		---+${lua}
		local id = predicate[2];
		local node = match[id];

		local r_s, c_s, r_e, c_e = node:range();
		local line = vim.api.nvim_buf_get_lines(bufnr, r_s, r_s + 1, true)[1];

		if not line then
			return;
		elseif not metadata[id] then
			metadata[id] = { range = {} };
		end

		line = line:sub(c_s + 1, #line);
		local spaces = line:match("^(%s*)%S"):len();

		metadata[id].range[1] = r_s;
		metadata[id].range[2] = c_s + spaces;
		metadata[id].range[3] = r_e;
		metadata[id].range[4] = c_e;

		metadata[id].conceal = "";
		---_
	end);

	health.notify("trace", {
		level = 5,
		message = {
			{ "Added tree-sitter directive ", "Special" },
			{ " conceal-patch! ", "DiagnosticVirtualTextInfo" }
		}
	});
end

 ------------------------------------------------------------------------------------------

--- Registers completion sources for `markview.nvim`.
local function register_source()
	---+${lua}

	---@type boolean, table
	local has_cmp, cmp = pcall(require, "cmp");

	if has_cmp == false then
		return;
	elseif vim.g.markview_cmp_loaded == false then
		--- Completion source for `markview.nvim`.
		local mkv_src = require("cmp-markview");
		cmp.register_source("cmp-markview", mkv_src);

		vim.g.markview_cmp_loaded = true;
	end

	local old_src = cmp.get_config().sources or {};

	if vim.list_contains(old_src, "cmp-markview") then
		return;
	end

	cmp.setup.buffer({
		sources = vim.list_extend(old_src, {
			{
				name = "cmp-markview",
				keyword_length = 1,
				options = {}
			}
		})
	});

	health.notify("trace", {
		level = 5,
		message = "Registered source for nvim-cmp."
	});
	---_
end

--- Registers buffers.
vim.api.nvim_create_autocmd({ "BufAdd", "BufEnter" }, {
	group = markview.augroup,
	callback = function (event)
		---+${lua}
		local buffer = event.buf;

		if markview.state.enable == false then
			--- New buffers shouldn't be registered.
			return;
		elseif markview.actions.__is_attached(buffer) == true then
			--- Already attached to this buffer!
			return;
		end

		---@type string, string
		local bt, ft = vim.bo[buffer].buftype, vim.bo[buffer].filetype;
		local attach_ft = spec.get({ "preview", "filetypes" }, { fallback = {}, ignore_enable = true });
		local ignore_bt = spec.get({ "preview", "ignore_buftypes" }, { fallback = {}, ignore_enable = true });

		local condition = spec.get({ "preview", "condition" }, { eval_args = { buffer } });

		if vim.list_contains(ignore_bt, bt) == true then
			--- Ignored buffer type.
			return;
		elseif vim.list_contains(attach_ft, ft) == false then
			--- Ignored file type.
			return;
		elseif condition == false then
			return;
		end

		markview.actions.attach(buffer);
		register_source();
		---_
	end
});

local o_timer = vim.uv.new_timer();

--- Option changes(e.g. wrap, linebreak)
vim.api.nvim_create_autocmd({ "OptionSet" }, {
	group = markview.augroup,
	callback = function ()
		---+${lua}
		local buffer = vim.api.nvim_get_current_buf();
		local option = vim.fn.expand("<amatch>");

		local valid_options = { "wrap", "linebreak" };

		---@type string[] List of modes where preview is shown.
		local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
		local mode = vim.api.nvim_get_mode().mode;

		if markview.actions.__is_attached(buffer) == false then
			--- Not attached to a buffer
			return;
		elseif markview.actions.__is_enabled(buffer) == false then
			--- Disabled on this buffer.
			return;
		elseif vim.list_contains(preview_modes, mode) == false then
			--- Wrong mode.
			return;
		elseif vim.list_contains(valid_options, option) == false then
			--- This option shouldn't cause a redraw.
			return;
		elseif vim.v.option_old == vim.v.option_new then
			--- Option value wasn't changed.
			return;
		end

		o_timer:stop()
		o_timer:start(5, 0, vim.schedule_wrap(function ()
			markview.render(buffer);
		end));
		---_
	end
});

--- Mode changes.
vim.api.nvim_create_autocmd({ "ModeChanged" }, {
	group = markview.augroup,
	callback = function (event)
		---+${lua}
		local buffer = event.buf;
		local mode = vim.api.nvim_get_mode().mode;

		---@type string[] List of modes where preview is shown.
		local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
		---@type string[] List of modes where preview is shown.
		local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });

		local old_mode = vim.v.event.old_mode;

		if markview.actions.__is_attached(buffer) == false then
			--- Buffer isn't attached!
			return;
		elseif markview.actions.__is_enabled(buffer) == false then
			--- Markview disabled on this buffer.
			markview.clear(buffer);
			return;
		elseif buffer == markview.state.splitview_source then
			--- Splitview should only update from
			--- cursor movements or content changes.
			return;
		end

		if vim.list_contains(hybrid_modes, mode) then
			health.notify("trace", {
				level = 1,
				message = string.format("Mode(%s): %d", mode, buffer);
			});
			health.__child_indent_in();

			if vim.list_contains(hybrid_modes, old_mode) then
				--- Switching between 2 hybrid modes.
				goto callback;
			else
				vim.defer_fn(function ()
					markview.render(buffer);
				end, 0);
			end
		elseif vim.list_contains(preview_modes, mode) then
			health.notify("trace", {
				level = 1,
				message = string.format("Mode(%s): %d", mode, buffer);
			});
			health.__child_indent_in();

			--- Preview
			if vim.list_contains(hybrid_modes, old_mode) then
				vim.defer_fn(function ()
					markview.render(buffer);
				end, 0);
			elseif vim.list_contains(preview_modes, old_mode) then
				--- Previous mode was a preview
				--- mode.
				--- Most likely the text hasn't
				--- changed.
				goto callback;
			else
				markview.render(buffer);
			end
		else
			health.notify("trace", {
				level = 2,
				message = string.format("Mode(%s): %d", mode, buffer);
			});
			health.__child_indent_in();

			--- Clear
			if vim.list_contains(preview_modes, old_mode) == false then
				--- Previous mode was not a preview
				--- mode.
				--- Most likely a preview shouldn't
				--- have occurred.
				goto callback;
			else
				markview.clear(buffer);
			end
		end

		::callback::
		markview.actions.__exec_callback("on_mode_change", buffer, vim.fn.win_findbuf(buffer), mode)
		health.__child_indent_de();
		---_
	end
});

local timer = vim.uv.new_timer();

--- Preview updates.
vim.api.nvim_create_autocmd({
	"CursorMoved",  "TextChanged",
	"CursorMovedI", "TextChangedI"
}, {
	group = markview.augroup,
	callback = function (event)
		---+${lua}
		timer:stop();

		local buffer = event.buf;
		local name = event.event;
		local mode = vim.api.nvim_get_mode().mode;

		---@type string[] List of modes where preview is shown.
		local modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
		---@type string[] List of modes where preview is shown.
		local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });
		local delay = spec.get({ "preview", "debounce" }, { fallback = 25, ignore_enable = true });

		--- Checks if we need to immediately render
		--- previews or not.
		---@return boolean
		local function immediate_render ()
			---+${lua}
			if vim.list_contains({ "TextChanged", "TextChangedI" }, name) then
				--- Changes to the buffer content MUST
				--- always be debounced to ensure that
				--- this doesn't hamper typing.
				return false;
			end

			local utils = require("markview.utils");
			local win = utils.buf_getwin(buffer);

			if type(win) ~= "number" or markview.win_is_safe(win) == false then
				--- Window isn't safe.
				--- This shouldn't occur normally.
				return false;
			end

			local distance_threshold = math.floor(vim.o.lines * 0.75);
			local pos_y = vim.api.nvim_win_get_cursor(win)[1];

			local old = markview.state.buffer_states[buffer].y or 0;
			local diff = math.abs(pos_y - old);

			--- Update the cached cursor position.
			if not markview.state.buffer_states[buffer].y then
				markview.state.buffer_states[buffer].y = pos_y;
			elseif diff >= distance_threshold then
				markview.state.buffer_states[buffer].y = pos_y;
			end

			if diff >= distance_threshold then
				--- User has covered a significant
				--- distance since the last redraw.
				---
				--- We probably should redraw.
				return true;
			else
				--- User still hasn't covered a large
				--- distance.
				---
				--- We shouldn't redraw.
				return false;
			end
			---_
		end

		--- Handles the renderer for a buffer.
		local handle_renderer = function ()
			---+${lua}

			---@type integer
			local lines = vim.api.nvim_buf_line_count(buffer);
			---@type integer
			local max_l = spec.get({ "preview", "max_buf_lines" }, { fallback = 1000, ignore_enable = true });

			if lines >= max_l then
				if immediate_render() == true then
					--- Use a small delay to prevent input
					--- lags when doing `gg` or `G`.
					-- markview.render(buffer);
					vim.defer_fn(function ()
						if vim.v.exiting ~= vim.NIL then
							return;
						end

						markview.render(buffer);
					end, 0);
				else
					timer:start(delay, 0, vim.schedule_wrap(function ()
						if vim.v.exiting ~= vim.NIL then
							return;
						end

						markview.render(buffer);
					end));
				end
			elseif vim.list_contains(hybrid_modes, mode) then
				if not markview.state.buffer_states[buffer] then
					return;
				elseif markview.state.buffer_states[buffer].hybrid_mode == false then
					return;
				end

				--- Hybrid mode movements MUST be
				--- handled through debounce.
				timer:start(delay, 0, vim.schedule_wrap(function ()
					if vim.v.exiting ~= vim.NIL then
						return;
					end

					markview.render(buffer);
				end));
			elseif vim.list_contains({ "TextChanged", "TextChangedI" }, name) then
				--- Buffer content changes MUST be
				--- handle via debounce.
				timer:start(delay, 0, vim.schedule_wrap(function ()
					if vim.v.exiting ~= vim.NIL then
						return;
					end

					markview.render(buffer);
				end));
			end

			---_
		end

		--- Handles the splitview renderer.
		local function handle_splitview ()
			---+${lua}

			---@type integer
			local lines = vim.api.nvim_buf_line_count(buffer);
			---@type integer
			local max_l = spec.get({ "preview", "max_buf_lines" }, { fallback = 1000, ignore_enable = true });

			if lines >= max_l then
				if immediate_render() == true then
					--- Use a small delay to prevent input
					--- lags when doing `gg` or `G`.
					-- markview.render(buffer);
					vim.defer_fn(function ()
						if vim.v.exiting ~= vim.NIL then
							return;
						end

						markview.splitview_render();
					end, 0);
				elseif vim.list_contains({ "CursorMoved", "CursorMovedI" }, name) then
					--- BUG, on Android changing cursor
					--- position outside of `defer_fn`
					--- results in high input lags.
					vim.defer_fn(function ()
						if vim.v.exiting ~= vim.NIL then
							return;
						end

						markview.update_splitview_cursor();
					end, 0);
				else
					--- Buffer content change(use debounce).
					timer:start(delay, 0, vim.schedule_wrap(function ()
						if vim.v.exiting ~= vim.NIL then
							return;
						end

						markview.splitview_render();
					end));
				end
			elseif vim.list_contains({ "TextChanged", "TextChangedI" }, name) then
				timer:start(delay, 0, vim.schedule_wrap(function ()
					if vim.v.exiting ~= vim.NIL then
						return;
					end

					markview.splitview_render();
				end));
			else
				vim.defer_fn(function ()
					if vim.v.exiting ~= vim.NIL then
						return;
					end

					markview.update_splitview_cursor();
				end, 0);
			end

			---_
		end

		if buffer == markview.state.splitview_source then
			handle_splitview();
		else
			--- Do these checks only for normal buffers.
			if markview.actions.__is_attached(buffer) == false then
				return;
			elseif markview.actions.__is_enabled(buffer) == false then
				return;
			elseif vim.list_contains(modes, mode) == false then
				if buffer == markview.state.splitview_source then
					handle_splitview();
				end

				return;
			end

			handle_renderer();
		end
		---_
	end
});

--- Updates the highlight groups.
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function ()
		local hls = require("markview.highlights");
		hls.create(hls.groups);

		health.notify("trace", {
			level = 5,
			message = "Updated highlight groups"
		});
	end
});

 ------------------------------------------------------------------------------------------

---@type mkv.cmd_completion
local get_complete_items = {
	default = function (str)
		---+${lua}
		if str == nil then
			local _o = vim.tbl_keys(markview.commands);
			table.sort(_o);

			return _o;
		end

		local _o = {};

		for _, key in ipairs(vim.tbl_keys(markview.commands)) do
			if string.match(key, "^" .. str) then
				table.insert(_o, key);
			end
		end

		table.sort(_o);
		return _o;
		---_
	end,

	attach = function (args, cmd)
		---+${lua}
		if #args > 3 then
			--- Too many arguments!
			return {};
		elseif #args >= 3 and string.match(cmd, "%s$") then
			--- Attempting to get completion beyond
			--- the argument count.
			return {};
		end

		local buf = args[3];
		local _o = {};

		for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
			if markview.buf_is_safe(buffer) == false then
				goto continue;
			end

			if buf == nil then
				table.insert(_o, tostring(buffer));
			elseif string.match(tostring(buffer), "^" .. buf) then
				table.insert(_o, tostring(buffer));
			end

		    ::continue::
		end

		table.sort(_o);
		return _o;
		---_
	end,
	detach = function (args, cmd)
		---+${lua}
		if #args > 3 then
			--- Too many arguments!
			return {};
		elseif #args >= 3 and string.match(cmd, "%s$") then
			--- Attempting to get completion beyond
			--- the argument count.
			return {};
		end

		local buf = args[3];
		local _o = {};

		for _, buffer in ipairs(markview.state.attached_buffers) do
			if markview.buf_is_safe(buffer) == false then
				goto continue;
			end

			if buf == nil then
				table.insert(_o, tostring(buffer));
			elseif string.match(tostring(buffer), "^" .. buf) then
				table.insert(_o, tostring(buffer));
			end

		    ::continue::
		end

		table.sort(_o);
		return _o;
		---_
	end,

	enable = function (args, cmd)
		---+${lua}
		if #args > 3 then
			--- Too many arguments!
			return {};
		elseif #args >= 3 and string.match(cmd, "%s$") then
			--- Attempting to get completion beyond
			--- the argument count.
			return {};
		end

		local buf = args[3];
		local _o = {};

		for _, buffer in ipairs(markview.state.attached_buffers) do
			if markview.buf_is_safe(buffer) == false or markview.actions.__is_enabled(buffer) == true then
				goto continue;
			end

			if buf == nil then
				table.insert(_o, tostring(buffer));
			elseif string.match(tostring(buffer), "^" .. buf) then
				table.insert(_o, tostring(buffer));
			end

		    ::continue::
		end

		table.sort(_o);
		return _o;
		---_
	end,
	disable = function (args, cmd)
		---+${lua}
		if #args > 3 then
			--- Too many arguments!
			return {};
		elseif #args >= 3 and string.match(cmd, "%s$") then
			--- Attempting to get completion beyond
			--- the argument count.
			return {};
		end

		local buf = args[3];
		local _o = {};

		for _, buffer in ipairs(markview.state.attached_buffers) do
			if markview.buf_is_safe(buffer) == false or markview.actions.__is_enabled(buffer) == false then
				goto continue;
			end

			if buf == nil then
				table.insert(_o, tostring(buffer));
			elseif string.match(tostring(buffer), "^" .. buf) then
				table.insert(_o, tostring(buffer));
			end

		    ::continue::
		end

		table.sort(_o);
		return _o;
		---_
	end,

	hybridToggle = function (args, cmd)
		---+${lua}
		if #args > 3 then
			--- Too many arguments!
			return {};
		elseif #args >= 3 and string.match(cmd, "%s$") then
			--- Attempting to get completion beyond
			--- the argument count.
			return {};
		end

		local buf = args[3];
		local _o = {};

		for _, buffer in ipairs(markview.state.attached_buffers) do
			if markview.buf_is_safe(buffer) == false or markview.actions.__is_enabled(buffer) == false then
				goto continue;
			end

			if buf == nil then
				table.insert(_o, tostring(buffer));
			elseif string.match(tostring(buffer), "^" .. buf) then
				table.insert(_o, tostring(buffer));
			end

		    ::continue::
		end

		table.sort(_o);
		return _o;
		---_
	end,
	hybridDisable = function (args, cmd)
		---+${lua}
		if #args > 3 then
			--- Too many arguments!
			return {};
		elseif #args >= 3 and string.match(cmd, "%s$") then
			--- Attempting to get completion beyond
			--- the argument count.
			return {};
		end

		local buf = args[3];
		local _o = {};

		for _, buffer in ipairs(markview.state.attached_buffers) do
			if markview.buf_is_safe(buffer) == false or markview.actions.__is_enabled(buffer) == false then
				goto continue;
			end

			if buf == nil then
				table.insert(_o, tostring(buffer));
			elseif string.match(tostring(buffer), "^" .. buf) then
				table.insert(_o, tostring(buffer));
			end

		    ::continue::
		end

		table.sort(_o);
		return _o;
		---_
	end,
	hybridEnable = function (args, cmd)
		---+${lua}
		if #args > 3 then
			--- Too many arguments!
			return {};
		elseif #args >= 3 and string.match(cmd, "%s$") then
			--- Attempting to get completion beyond
			--- the argument count.
			return {};
		end

		local buf = args[3];
		local _o = {};

		for _, buffer in ipairs(markview.state.attached_buffers) do
			if markview.buf_is_safe(buffer) == false or markview.actions.__is_enabled(buffer) == false then
				goto continue;
			end

			if buf == nil then
				table.insert(_o, tostring(buffer));
			elseif string.match(tostring(buffer), "^" .. buf) then
				table.insert(_o, tostring(buffer));
			end

		    ::continue::
		end

		table.sort(_o);
		return _o;
		---_
	end,

	splitOpen = function (args, cmd)
		---+${lua}
		if #args > 3 then
			--- Too many arguments!
			return {};
		elseif #args >= 3 and string.match(cmd, "%s$") then
			--- Attempting to get completion beyond
			--- the argument count.
			return {};
		end

		local buf = args[3];
		local _o = {};

		for _, buffer in ipairs(markview.state.attached_buffers) do
			if markview.buf_is_safe(buffer) == false then
				goto continue;
			end

			if buf == nil then
				table.insert(_o, tostring(buffer));
			elseif string.match(tostring(buffer), "^" .. buf) then
				table.insert(_o, tostring(buffer));
			end

		    ::continue::
		end

		table.sort(_o);
		return _o;
		---_
	end,

	render = function (args, cmd)
		---+${lua}
		if #args > 3 then
			--- Too many arguments!
			return {};
		elseif #args >= 3 and string.match(cmd, "%s$") then
			--- Attempting to get completion beyond
			--- the argument count.
			return {};
		end

		local buf = args[3];
		local _o = {};

		for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
			if markview.buf_is_safe(buffer) == false then
				goto continue;
			end

			if buf == nil then
				table.insert(_o, tostring(buffer));
			elseif string.match(tostring(buffer), "^" .. buf) then
				table.insert(_o, tostring(buffer));
			end

		    ::continue::
		end

		table.sort(_o);
		return _o;
		---_
	end,
	clear = function (args, cmd)
		---+${lua}
		if #args > 3 then
			--- Too many arguments!
			return {};
		elseif #args >= 3 and string.match(cmd, "%s$") then
			--- Attempting to get completion beyond
			--- the argument count.
			return {};
		end

		local buf = args[3];
		local _o = {};

		for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
			if markview.buf_is_safe(buffer) == false then
				goto continue;
			end

			if buf == nil then
				table.insert(_o, tostring(buffer));
			elseif string.match(tostring(buffer), "^" .. buf) then
				table.insert(_o, tostring(buffer));
			end

		    ::continue::
		end

		table.sort(_o);
		return _o;
		---_
	end
};

--- User command.
vim.api.nvim_create_user_command("Markview", function (cmd)
	---+${lua}

	local function exec(fun, args)
		args = args or {};
		local fargs = {};

		for _, arg in ipairs(args) do
			if tonumber(arg) then
				table.insert(fargs, tonumber(arg));
			elseif arg == "true" or arg == "false" then
				table.insert(fargs, arg == "true");
			else
				--- BUG, is this used by any functions?
				-- table.insert(fargs, arg);
			end
		end

		---@diagnostic disable-next-line
		pcall(fun, unpack(fargs));
	end

	---@type string[] Command arguments.
	local args = cmd.fargs;

	if #args == 0 then
		markview.commands.Toggle();
	elseif type(markview.commands[args[1]]) == "function" then
		--- FIXME, Change this if `vim.list_slice` becomes deprecated.
		exec(markview.commands[args[1]], vim.list_slice(args, 2))
	end
	---_
end, {
	---+${lua}
	nargs = "*",
	desc = "User command for `markview.nvim`",
	complete = function (_, cmd, cursorpos)
		local function is_subcommand(str)
			return markview.commands[str] ~= nil;
		end

		local before = string.sub(cmd, 0, cursorpos);
		local parts = {};

		for part in string.gmatch(before, "%S+") do
			table.insert(parts, part);
		end

		if #parts == 1 then
			return get_complete_items.default(parts[2]);
		elseif #parts == 2 and is_subcommand(parts[2]) == false then
			return get_complete_items.default(parts[2]);
		elseif is_subcommand(parts[2]) == true and get_complete_items[parts[2]] ~= nil then
			return get_complete_items[parts[2]](parts, before);
		end
	end
	---_
});
