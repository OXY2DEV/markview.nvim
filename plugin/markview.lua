---@type integer Autocmd group ID.
local augroup = vim.api.nvim_create_augroup("markview", { clear = true });

local function register_blink_source ()
	---|fS

	local blink = package.loaded["blink.cmp"];

	if vim.g.markview_blink_loaded == true or blink == nil then
		return;
	end

	local add_provider = blink.add_source_provider or blink.add_provider;

	local blink_config = require("blink.cmp.config");
	local filetypes = require("markview.spec").get({ "preview", "filetypes" }, {
		fallback = {},
		ignore_enable = true
	});

	add_provider("markview", {
		name = "markview",
		module = "blink-markview",

		should_show_items = function ()
			return vim.tbl_contains(filetypes, vim.o.filetype);
		end
	});

	-- ISSUE, blink.cmp doesn't allow dynamically
	-- modifying source list.
	for _, filetype in ipairs(filetypes) do
		if blink_config then
			---|fS "feat: Modify blink sources"

			local default = blink_config.sources.default;

			if vim.islist(default) then
				-- If the default sources is a list
				-- we extend the list of sources.
				blink_config.sources.per_filetype[filetype] = vim.list_extend(default, { "markview" });
			else
				-- If it's a function we wrap it in
				-- *another* function.
				blink_config.sources.per_filetype[filetype] = function (...)
					local can_exec, result = pcall(default, ...);

					if can_exec and vim.islist(result) and not vim.list_contains(result, "markview") then
						return vim.list_extend(result, { "markview" });
					elseif can_exec == false then
						-- Emit errors in the original function.
						error(result);
					else
						return { "markview" };
					end
				end
			end

			---|fE
		else
			pcall(blink.add_filetype_source, filetype, "markview");
		end
	end

	vim.g.markview_blink_loaded = true;
	require("markview.health").notify("trace", {
		level = 5,
		message = "Registered source for blink.cmp."
	});

	---|fE
end

local function register_cmp_source ()
	---|fS

	local cmp = package.loaded["cmp"];

	if vim.g.markview_cmp_loaded == true or cmp == nil then
		return;
	end

	cmp.register_source("cmp-markview", require("cmp-markview"));

	local sources = cmp.get_config().sources or {};
	local filetypes = require("markview.spec").get({ "preview", "filetypes" }, {
		fallback = {},
		ignore_enable = true
	});

    ---|fS "feat: Modify nvim-cmp sources"
	cmp.setup.filetype(filetypes, {
		sources = vim.list_extend(sources, {
			{
				name = "cmp-markview",
				keyword_length = 1,
				options = {}
			}
		})
	});
    ---|fE

	vim.g.markview_cmp_loaded = true;
	require("markview.health").notify("trace", {
		level = 5,
		message = "Registered source for nvim-cmp."
	});

	---|fE
end

vim.api.nvim_create_autocmd("VimEnter", {
	group = augroup,
	callback = function ()
		require("markview.highlights").setup();

		register_blink_source();
		register_cmp_source();
	end
});

-- Updates the highlight groups.
vim.api.nvim_create_autocmd("ColorScheme", {
	group = augroup,
	callback = function ()
		local highlights = require("markview.highlights")
		highlights.create(highlights.groups);

		require("markview.health").notify("trace", {
			level = 5,
			message = "Updated highlight groups"
		});
	end
});

------------------------------------------------------------------------------

-- Mode changes.
vim.api.nvim_create_autocmd("ModeChanged", {
	group = augroup,
	callback = function (event)
		---|fS

		local markview = require("markview");
		local health = require("markview.health");
		local spec = require("markview.spec");

		local buffer = event.buf;
		local mode = vim.api.nvim_get_mode().mode;

		---@param do_render boolean
		local function set_breakindent (do_render)
			if vim.bo[buffer].ft ~= "markdown" then
				return;
			end

			local win = vim.fn.win_findbuf(buffer)[1];

			if not win then
				-- We don't need to set `breakindent` if the
				-- buffer isn't being viewed by any window.
				return;
			elseif do_render then
				-- warning: `breakindent` must be set before rendering!
				vim.w[win].__mkv_cached_breakindet = vim.wo[win].breakindent;
				vim.wo[win].breakindent = false;
			elseif vim.w[win].__mkv_cached_breakindet then
				vim.wo[win].breakindent = vim.w[win].__mkv_cached_breakindet;
			end
		end

		---@type string[] List of modes where preview is shown.
		local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
		---@type string[] List of modes where preview is shown.
		local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });

		---@diagnostic disable-next-line: undefined-field
		local old_mode = vim.v.event.old_mode;

		if markview.actions.__is_attached(buffer) == false then
			--- Buffer isn't attached!
			return;
		elseif markview.actions.__is_enabled(buffer) == false then
			--- Markview disabled on this buffer.
			set_breakindent(false);
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
					set_breakindent(true);
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
					set_breakindent(true);
					markview.render(buffer);
				end, 0);
			elseif vim.list_contains(preview_modes, old_mode) then
				--- Previous mode was a preview
				--- mode.
				--- Most likely the text hasn't
				--- changed.
				goto callback;
			else
				set_breakindent(true);
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
				set_breakindent(false);
				markview.clear(buffer);
			end
		end

		::callback::
		markview.actions.__exec_callback("on_mode_change", buffer, vim.fn.win_findbuf(buffer), mode)
		health.__child_indent_de();

		---|fE
	end
});

--- Registers buffers.
vim.api.nvim_create_autocmd({
	"BufAdd", "BufEnter",
	"BufWinEnter"
}, {
	group = augroup,
	callback = function (event)
		---|fS "feat: Attaches to new buffers"

		local markview = require("markview");
		local spec = require("markview.spec");

		local buffer = event.buf;
		markview.clean();

		if vim.api.nvim_buf_is_valid(buffer) == false then
			--- If the buffer got deleted before we
			--- get here, we ignore it.
			--- See #356
			return;
		elseif markview.state.enable == false then
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

		---|fE
	end
});

--- Timer for 'filetype', 'buftype' changes.
---@diagnostic disable-next-line: undefined-field
local bf_timer = vim.uv.new_timer();

vim.api.nvim_create_autocmd({
	"OptionSet"
}, {
	group = augroup,
	callback = function ()
		---|fS "feat: Attaches/Detaches on Option change"

		local markview = require("markview");
		local spec = require("markview.spec");

		bf_timer:stop()

		local buffer = vim.api.nvim_get_current_buf();
		local option = vim.fn.expand("<amatch>");

		local valid_options = { "filetype", "buftype" };

		---@type string, string
		local bt, ft = vim.bo[buffer].buftype, vim.bo[buffer].filetype;
		local attach_ft = spec.get({ "preview", "filetypes" }, { fallback = {}, ignore_enable = true });
		local ignore_bt = spec.get({ "preview", "ignore_buftypes" }, { fallback = {}, ignore_enable = true });

		local condition = spec.get({ "preview", "condition" }, { eval_args = { buffer } });

		if markview.state.enable == false then
			--- New buffers shouldn't be registered.
			return;
		elseif markview.actions.__is_attached(buffer) == true then
			--- Already attached to this buffer!
			--- We should check if the buffer is still valid.

			if vim.list_contains(ignore_bt, bt) == true then
				--- Ignored buffer type.
				bf_timer:start(5, 0, vim.schedule_wrap(function ()
					markview.actions.detach(buffer);
				end));
			elseif vim.list_contains(attach_ft, ft) == false then
				--- Ignored file type.
				bf_timer:start(5, 0, vim.schedule_wrap(function ()
					markview.actions.detach(buffer);
				end));
			elseif condition == false then
				bf_timer:start(5, 0, vim.schedule_wrap(function ()
					markview.actions.detach(buffer);
				end));
			end

			return;
		elseif vim.list_contains(valid_options, option) == false then
			--- We shouldn't do anything on other events.
			return;
		end

		if vim.list_contains(ignore_bt, bt) == true then
			--- Ignored buffer type.
			return;
		elseif vim.list_contains(attach_ft, ft) == false then
			--- Ignored file type.
			return;
		elseif condition == false then
			return;
		end

		bf_timer:start(5, 0, vim.schedule_wrap(function ()
			markview.actions.attach(buffer);
		end));

		---|fE
	end
});

--- Timer for 'wrap', 'linebreak' changes.
---@diagnostic disable-next-line: undefined-field
local o_timer = vim.uv.new_timer();

--- Option changes(e.g. wrap, linebreak)
vim.api.nvim_create_autocmd({ "OptionSet" }, {
	group = augroup,
	callback = function ()
		---|fS

		local markview = require("markview");
		local spec = require("markview.spec");

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

		---|fE
	end
});

---@diagnostic disable-next-line: undefined-field
local timer = vim.uv.new_timer();

-- Preview updates.
vim.api.nvim_create_autocmd({
	"CursorMoved",  "TextChanged",
	"CursorMovedI", "TextChangedI"
}, {
	group = augroup,
	callback = function (event)
		---|fS

		timer:stop();

		local markview = require("markview");
		local spec = require("markview.spec");

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
			---|fS

			if vim.list_contains({ "TextChanged", "TextChangedI" }, name) then
				--- Changes to the buffer content MUST
				--- always be debounced to ensure that
				--- this doesn't hamper typing.
				return false;
			end

			local win = vim.fn.win_findbuf(buffer)[1];

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

			---|fE
		end

		--- Handles the renderer for a buffer.
		local handle_renderer = function ()
			---|fS

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

			---|fE
		end

		--- Handles the splitview renderer.
		local function handle_splitview ()
			---|fS

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

			---|fE
		end

		if buffer == markview.state.splitview_source then
			handle_splitview();
		else
			-- Do these checks only for normal buffers.
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

		---|fE
	end
});

 ------------------------------------------------------------------------------------------

---@class markview.cmd_completions
---
---@field default fun(str: string): string[]
---@field [string] fun(args: string[], cmd: string): string[]
local get_complete_items = {
	---|fS

	default = function (str)
		---|fS

		local markview = require("markview");

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

		---|fE
	end,

	attach = function (args, cmd)
		---|fS

		local markview = require("markview");

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

		---|fE
	end,
	detach = function (args, cmd)
		---|fS

		local markview = require("markview");

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

		---|fE
	end,

	enable = function (args, cmd)
		---|fS

		local markview = require("markview");

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

		---|fE
	end,
	disable = function (args, cmd)
		---|fS

		local markview = require("markview");

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

		---|fE
	end,

	hybridToggle = function (args, cmd)
		---|fS

		local markview = require("markview");

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

		---|fE
	end,
	hybridDisable = function (args, cmd)
		---|fS

		local markview = require("markview");

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

		---|fE
	end,
	hybridEnable = function (args, cmd)
		---|fS

		local markview = require("markview");

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

		---|fE
	end,

	splitOpen = function (args, cmd)
		---|fS

		local markview = require("markview");

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

		---|fE
	end,

	render = function (args, cmd)
		---|fS

		local markview = require("markview");

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

		---|fE
	end,
	clear = function (args, cmd)
		---|fS

		local markview = require("markview");

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

		---|fE
	end

	---|fE
};

--- User command.
vim.api.nvim_create_user_command("Markview", function (cmd)
	---|fS

	local markview = require("markview");

	local function exec(fun, args)
		args = args or {};
		local fargs = {};

		for _, arg in ipairs(args) do
			if tonumber(arg) then
				table.insert(fargs, tonumber(arg));
			elseif arg == "true" or arg == "false" then
				table.insert(fargs, arg == "true");
			else
				-- BUG: is this used by any functions?
				-- table.insert(fargs, arg);
			end
		end

		pcall(fun, unpack(fargs));
	end

	---@type string[] Command arguments.
	local args = cmd.fargs;

	if #args == 0 then
		markview.commands.Toggle();
	elseif type(markview.commands[args[1]]) == "function" then
		-- FIXME: Change this if `vim.list_slice` becomes deprecated.
		exec(markview.commands[args[1]], vim.list_slice(args, 2))
	end

	---|fE
end, {
	---|fS

	nargs = "*",
	desc = "User command for `markview.nvim`",
	complete = function (_, cmd, cursorpos)
		local markview = require("markview");

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

	---|fE
});
