local checkboxes = {};
local spec = require("markview.spec");
local utils = require("markview.utils");

---@class markview.extras.checkbox.config
---
---@field default string Default checkbox state.
---@field remove_style
---| "disable" Clears state.
---| "checkbox" Removes checkbox.
---| "list_item" Removes list item.
---@field states string[][] List of sets containing various checkbox states.
checkboxes.config = {
	default = "X",
	remove_style = "disable",

	states = {
		{ " ", "/", "X" },
		{ "<", ">" },
		{ "?", "!", "*" },
		{ '"' },
		{ "l", "b", "i" },
		{ "S", "I" },
		{ "p", "c" },
		{ "f", "k", "w" },
		{ "u", "d" }
	}
};

--- When key is a buffer, maps a line number to a checkbox state.
---@class markview.extras.checkbox.state
---
---@field [integer] { [integer]: string }
checkboxes.cache = {};

--- Cache the checkbox state of a specific line.
---@param buffer integer
---@param lnum integer
---@param state string
checkboxes.register_state = function (buffer, lnum, state)
	if not checkboxes.cache[buffer] then
		checkboxes.cache[buffer] = {};
	elseif state == nil then
		return;
	end

	checkboxes.cache[buffer][lnum] = state;
end

--- Gets the row, col coordinates for a given
--- state
---@param state string
---@return [ integer, integer ]?
checkboxes.get_state_coords = function (state)
	for y, row in ipairs(checkboxes.config.states) do
		for x, col in ipairs(row) do
			if col == state then
				return { x, y };
			end
		end
	end

	return nil;
end

--- Normalizes `num` between 0 & `max`.
---@param num number
---@param max number
---@return number
local normalize = function (num, max)
	if num > max then
		num = num % max;
	elseif num < 0 then
		num = max + num;

		if num < 0 then
			num = max - (math.abs(num) % max)
		end

	elseif num == 0 then
		num = max;
	end

	return num == 0 and max or num;
end


--- Checkbox toggle sub-module.
local toggler = {};

--- Removes checkbox from a line.
---@param buffer integer
---@param lnum integer
---@param line string
---@return string
---@return table
toggler.__remove_checkbox = function (buffer, lnum, line)
	local before, state, after;

	--- Pattern should change based on the list
	--- item style.
	if line:match("^[%s%>]*[%-%+%*]") then
		before, state, after = line:match("^([%s%>]*[%-%+%*]%s+%[)(.?)(%].*)$");
	else
		before, state, after = line:match("^([%s%>]*%d+[%.%)]%s+%[)(.?)(%].*)$");
	end

	--- Cache state.
	checkboxes.register_state(buffer, lnum, state);

	--- Remove different things based on the
	--- option's value.
	if checkboxes.config.remove_style == "disable" then
		return before .. " " .. after, { before, state, after };
	elseif checkboxes.config.remove_style == "checkbox" then
		return before:gsub("%s+%[$", "") .. " " .. after:gsub("^%]%s", ""), { before, state, after };
	elseif checkboxes.config.remove_style == "list_item" then
		if before:match("[%-%+%*]%s+%[$") then
			return before:gsub("[%-%+%*]%s+%[$", "") .. after:gsub("^%]%s", ""), { before, state, after };
		else
			return before:gsub("%d+[%.%)]%s+%[$", "") .. after:gsub("^%]%s", ""), { before, state, after };
		end
	end

	return line, { before, state, after };
end

--- Adds checkbox to lines
---@param buffer integer
---@param lnum integer
---@param line string
---@return string
---@return string[]
toggler.__add_checkbox = function (buffer, lnum, line)
	local before, state, after;
	local cached_state;

	--- Get the cached state, if possible.
	if checkboxes.cache[buffer] and checkboxes.cache[buffer][lnum] then
		cached_state = checkboxes.cache[buffer][lnum];
	end

	--- Change the text differently depending on whether
	--- it has [], [ ] or just the list item.
	---
	--- This is based on the assumption that the checker
	--- function didn't fail.
	if line:match("^[%s%>]*[%-%+%*]%s+%[%]") or line:match("^[%s%>]*%d+[%.%)]%s+%[%]") then
		if line:match("^[%s%>]*[%-%+%*]") then
			before, state, after = line:match("^([%s%>]*[%-%+%*]%s+%[)(.?)(%].*)$");
		else
			before, state, after = line:match("^([%s%>]*%d+[%.%)]%s+%[)(.?)(%].*)$");
		end

		return before .. (checkboxes.config.default or "") .. after, { before, state, after };
	elseif line:match("^[%s%>]*[%-%+%*]%s+%[ %]") or line:match("^[%s%>]*%d+[%.%)]%s+%[ %]") then
		if line:match("^[%s%>]*[%-%+%*]") then
			before, state, after = line:match("^([%s%>]*[%-%+%*]%s+%[)( )(%].*)$");
		else
			before, state, after = line:match("^([%s%>]*%d+[%.%)]%s+%[)( )(%].*)$");
		end

		return before .. (cached_state or checkboxes.config.default or "") .. after, { before, state, after };
	else
		if line:match("^[%s%>]*[%-%+%*]") then
			before, after = line:match("^([%s%>]*[%-%+%*])(.*)$");
		else
			before, after = line:match("^([%s%>]*%d+[%.%)])(.*)$");
		end

		return before .. string.format(" [%s]", cached_state or checkboxes.config.default or "") .. after, { before, state, after };
	end
end

--- Function to run if the text has list item markers.
---@param buffer integer
---@param from integer
---@param to integer
---@param lines string[]
---@return string[]
toggler.__has_markers = function (buffer, from, to, lines)
	local state = "normal";
	local tolerance = spec.get({ "experimental", "list_empty_line_tolerance" }, { fallback = 3 });
	local empty_lines = 0;

	--- Store the number of characters before the marker.
	---
	--- WARN, this is assuming `expandtab` is in use!
	--- FIXME, Find a better way to check if a line is
	--- part of a list item or not.
	local col_start = 0;

	--- Does this line have a checkbox? Do we remove it?
	---@param line string
	---@return boolean
	local function should_remove_checkbox(line)
		if line:match("^[%s%>]*[%-%+%*]%s+%[%]") or line:match("^[%s%>]*%d+[%.%)]%s+%[%]") then
			if checkboxes.config.remove_style == "disable" then
				return false;
			else
				return true;
			end
		elseif line:match("^[%s%>]*[%-%+%*]%s+%[ %]") or line:match("^[%s%>]*%d+[%.%)]%s+%[ %]") then
			if checkboxes.config.remove_style == "disable" then
				return false;
			else
				return true;
			end
		elseif line:match("^[%s%>]*[%-%+%*]%s+%[.%]") or line:match("^[%s%>]*%d+[%.%)]%s+%[.%]") then
			return true;
		end

		return false;
	end

	--- Should this line have a checkbox?
	---@param line string
	---@return boolean
	local function should_add_checkbox(line)
		if checkboxes.config.remove_style == "disable" and line:match("^[%s%>]*[%-%+%*]%s+%[%]") or line:match("^[%s%>]*%d+[%.%)]%s+%[%]") then
			return true;
		elseif checkboxes.config.remove_style == "disable" and line:match("^[%s%>]*[%-%+%*]%s+%[ %]") or line:match("^[%s%>]*%d+[%.%)]%s+%[ %]") then
			return true;
		elseif line:match("^[%s%>]*[%-%+%*]%s+") or line:match("^[%s%>]*%d+[%.%)]%s+") then
			--- Cache state here
			return true;
		end

		return false;
	end

	for l, line in ipairs(lines) do
		if should_remove_checkbox(line) then
			empty_lines = 0;
			state = "remove";

			local replace, data = toggler.__remove_checkbox(buffer, from + (l - 1), line);
			lines[l] = replace;

			col_start = vim.fn.strchars(data[1]:gsub("[%-%+%*]%s+%[$", ""):gsub("%d+[%.%)]%s+%[$", ""));
		elseif should_add_checkbox(line) then
			empty_lines = 0;
			state = "add"; --- This is for future use.

			local replace, data = toggler.__add_checkbox(buffer, from + (l - 1), line);
			lines[l] = replace;

			col_start = vim.fn.strchars(data[1]:gsub("[%-%+%*]%s+%[$", ""):gsub("%d+[%.%)]%s+%[$", ""));
		elseif line:match("^[%s%>]*$") then
			--- This will mimic the behavior of how
			--- list items are rendered by the plugin.
			if empty_lines >= tolerance then
				state = "normal";
			else
				empty_lines = empty_lines + 1;
			end
		elseif state == "remove" then
			local before = vim.fn.strcharpart(line, 0, col_start + 2);

			if before:match("^[%s%>]*$") and checkboxes.config.remove_style == "list_item" then
				lines[l] = vim.fn.strcharpart(line, 0, math.max(0, col_start - 2)) .. vim.fn.strcharpart(line, col_start);
			elseif before:match("^[%s%>]*$") == nil then
				state = "normal";
			end
		end
	end

	return lines;
end

--- Initializes the checkbox toggler on a specified
--- range inside the given buffer.
---@param buffer integer?
---@param from integer?
---@param to integer?
toggler.init = function (buffer, from, to)
	buffer = buffer or vim.api.nvim_get_current_buf();

	local pos = vim.fn.getpos;
	local row_start, row_end;

	if from and to then
		row_start = math.min(from, to);
		row_end   = math.max(from, to);
	elseif pos("v")[2] ~= pos(".")[2] then
		row_start = math.min(pos("v")[2], pos(".")[2]) - 1;
		row_end   = math.max(pos("v")[2], pos(".")[2]);
	else
		row_start = pos(".")[2] - 1;
		row_end   = pos(".")[2];
	end

	local lines = vim.api.nvim_buf_get_lines(buffer, row_start, row_end, false);
	local contains_markers = false;

	for _, line in ipairs(lines) do
		if line:match("^[%s%>]*[%-%+%*]") or line:match("^[%s%>]*%d+[%.%)]") then
			contains_markers = true;
			break;
		end
	end

	if contains_markers == true then
		lines = toggler.__has_markers(buffer, row_start, row_end, lines);
	else
		return;
	end

	vim.api.nvim_buf_set_lines(buffer, row_start, row_end, false, lines);
end

--- Checkbox state changer sub-module
local changer = {};

changer.init = function (buffer, from, to, x, y)
	--- Set some default values
	buffer = buffer or vim.api.nvim_get_current_buf();
	x = x or 0;
	y = y or 0;

	local pos = vim.fn.getpos;
	local row_start, row_end;

	if from and to then
		row_start = math.min(from, to);
		row_end   = math.max(from, to);
	elseif pos("v")[2] ~= pos(".")[2] then
		row_start = math.min(pos("v")[2], pos(".")[2]) - 1;
		row_end   = math.max(pos("v")[2], pos(".")[2]);
	else
		row_start = pos(".")[2] - 1;
		row_end   = pos(".")[2];
	end

	local lines = vim.api.nvim_buf_get_lines(buffer, row_start, row_end, false);

	--- Changes the provided state and returns the
	--- new state
	---@param state string
	---@param lnum integer
	---@return string
	local change_state = function (state, lnum)
		local coords = checkboxes.get_state_coords(state);

		if coords == nil then
			checkboxes.register_state(buffer, lnum, state);
			return state;
		end

		coords[2] = normalize(coords[2] + y, #checkboxes.config.states);

		local set = checkboxes.config.states[coords[2]];
		coords[1] = normalize(coords[1] + x, #set);

		checkboxes.register_state(buffer, lnum, set[coords[1]]);
		return set[coords[1]];
	end

	for l, line in ipairs(lines) do
		if line:match("^[%s%>]*[%-%+%*]%s+%[.%]") then
			local _, chk_e, state = line:find("^[%s%>]*[%-%+%*%)]%s+%[(.)%]");
			local new_state = change_state(state, (l - 1) + row_start);

			lines[l] = line:sub(0, chk_e - 2) .. new_state .. line:sub(chk_e);
		elseif line:match("^[%s%>]*%d+[%.%)]%s+%[.%]") then
			local _, chk_e, state = line:find("^[%s%>]*%d+[%.%)]%s+%[(.)%]");
			local new_state = change_state(state, (l - 1) + row_start);

			lines[l] = line:sub(0, chk_e - 2) .. new_state .. line:sub(chk_e);
		end
	end

	vim.api.nvim_buf_set_lines(buffer, row_start, row_end, false, lines);
end

local interactive = {};

interactive.ui_ns = vim.api.nvim_create_namespace("markview-extras-checkboxes");
interactive.source_buffer = nil;
interactive.ui_buffer = vim.api.nvim_create_buf(false, true);
interactive.ui_window = nil;

interactive.keymaps = {};
interactive.coordinate = nil;

--- Draws the UI.
interactive.__draw = function ()
	if not interactive.ui_buffer or vim.api.nvim_buf_is_valid(interactive.ui_buffer) == false then
		interactive.ui_buffer = vim.api.nvim_create_buf(false, true);
	end

	vim.api.nvim_buf_clear_namespace(interactive.ui_buffer, interactive.ui_ns, 0, -1);
	vim.api.nvim_buf_set_lines(interactive.ui_buffer, 0, -1, false, { "" });

	local width = 14;
	local _v = {};

	local set = checkboxes.config.states[interactive.coordinate[2]];
	local x = interactive.coordinate[1];

	if x - 1 < 1 or x - 1 > #set then
		table.insert(_v, { " •", "MarkviewGradient4" });
		table.insert(_v, { "⊘", "MarkviewGradient3" });
		table.insert(_v, { "• ", "MarkviewGradient4" });
	else
		table.insert(_v, { " •", "MarkviewGradient4" });
		table.insert(_v, { set[x - 1], "MarkviewGradient3" })
		table.insert(_v, { "• ", "MarkviewGradient4" });
	end

	table.insert(_v, { "[", "MarkviewGradient6" });
	table.insert(_v, { set[math.min(#set, x)], "MarkviewGradient9" })
	table.insert(_v, { "]", "MarkviewGradient6" });

	if x + 1 > #set then
		table.insert(_v, { " •", "MarkviewGradient4" });
		table.insert(_v, { "⊘", "MarkviewGradient3" });
		table.insert(_v, { "• ", "MarkviewGradient4" });
	else
		table.insert(_v, { " •", "MarkviewGradient4" });
		table.insert(_v, { set[x + 1], "MarkviewGradient3" })
		table.insert(_v, { "• ", "MarkviewGradient4" });
	end

	vim.api.nvim_buf_set_extmark(interactive.ui_buffer, interactive.ui_ns, 0, 0, {
		virt_text_pos = "inline",
		virt_text = _v
	});

	if not interactive.ui_window or vim.api.nvim_win_is_valid(interactive.ui_window) == false then
		interactive.ui_window = vim.api.nvim_open_win(interactive.ui_buffer, false, {
			relative = "cursor",
			row = 1,
			col = -1 * math.floor(width / 2),

			width = width,
			height = 1,

			-- focusable = false
		});
	else
		vim.api.nvim_win_set_config(interactive.ui_window, {
			relative = "cursor",
			row = 1,
			col = -1 * math.floor(width / 2),

			width = width,
			height = 1,

			-- focusable = false
		});
	end

	local erange = interactive.edit_range;
	local line = vim.api.nvim_buf_get_lines(interactive.source_buffer, erange[1], erange[1] + 1, false)[1];

	vim.api.nvim_buf_set_text(
		interactive.source_buffer,
		erange[1],
		#vim.fn.strcharpart(line, 0, erange[2]),
		erange[1],
		#vim.fn.strcharpart(line, 0, erange[3]),
		{ set[math.min(#set, x)] }
	);
end

--- Closes the interactive state changer
--- window and restores keymaps.
interactive.__close = function ()
	pcall(vim.api.nvim_win_close, interactive.ui_window, true);

	vim.api.nvim_buf_del_keymap(interactive.source_buffer, "n", "h");
	vim.api.nvim_buf_del_keymap(interactive.source_buffer, "n", "j");
	vim.api.nvim_buf_del_keymap(interactive.source_buffer, "n", "k");
	vim.api.nvim_buf_del_keymap(interactive.source_buffer, "n", "l");

	for _, keymap in ipairs(interactive.keymaps) do
		vim.api.nvim_buf_set_keymap(
			interactive.source_buffer,
			keymap.mode,
			keymap.lhs or "",
			keymap.rhs or "",
			{
				callback = keymap.callback
			}
		);
	end
end

--- Caches keymaps for h, j, k & l.
---@param buffer integer
interactive.__cache_keymaps = function (buffer)
	for _, keymap in ipairs(vim.api.nvim_buf_get_keymap(buffer, "n")) do
		if vim.list_contains({ "h", "j", "k", "l" }, keymap.lhs) then
			table.insert(interactive.keymaps, keymap);
		end
	end

	vim.api.nvim_buf_set_keymap(buffer, "n", "h", "", {
		callback = function ()
			interactive.__h();
		end
	});

	vim.api.nvim_buf_set_keymap(buffer, "n", "j", "", {
		callback = function ()
			interactive.__j();
		end
	});

	vim.api.nvim_buf_set_keymap(buffer, "n", "k", "", {
		callback = function ()
			interactive.__k();
		end
	});

	vim.api.nvim_buf_set_keymap(buffer, "n", "l", "", {
		callback = function ()
			interactive.__l();
		end
	});
end

interactive.__h = function ()
	local set = checkboxes.config.states[interactive.coordinate[2]];

	interactive.coordinate = {
		normalize(interactive.coordinate[1] - 1, #set),
		interactive.coordinate[2]
	};
	interactive.__draw();
end

interactive.__l = function ()
	local set = checkboxes.config.states[interactive.coordinate[2]];

	interactive.coordinate = {
		normalize(interactive.coordinate[1] + 1, #set),
		interactive.coordinate[2]
	};
	interactive.__draw();
end

interactive.__j = function ()
	interactive.coordinate = {
		interactive.coordinate[1],
		normalize(interactive.coordinate[2] + 1, #checkboxes.config.states),
	};
	interactive.__draw();
end

interactive.__k = function ()
	interactive.coordinate = {
		interactive.coordinate[1],
		normalize(interactive.coordinate[2] - 1, #checkboxes.config.states),
	};
	interactive.__draw();
end

--- Initiates an interactive checkbox state
--- changer.
interactive.init = function ()
	local buffer = vim.api.nvim_get_current_buf();
	local cursor = vim.api.nvim_win_get_cursor(0);

	interactive.source_buffer = buffer;

	local line = vim.api.nvim_buf_get_lines(buffer, cursor[1] - 1, cursor[1], false)[1];
	local state, col_start, col_end;

	if line:match("^[%s%>]*[%-%+%*]%s+%[.%]") then
		local match = line:match("^[%s%>]*[%-%+%*]%s+%[.%]");
		local len = vim.fn.strchars(match);

		state = match:match("%[(.)%]$");
		col_start = #vim.fn.strcharpart(match, 0, len - 2);
		col_end = #vim.fn.strcharpart(match, 0, len - 1);
	elseif line:match("^[%s%>]*%d+[%.%)]%s+%[.%]") then
		local match = line:match("^[%s%>]*%d+[%.%)]%s+%[.%]");
		local len = vim.fn.strchars(match);

		state = match:match("%[(.)%]$");
		col_start = #vim.fn.strcharpart(match, 0, len - 2);
		col_end = #vim.fn.strcharpart(match, 0, len - 1);
	else
		return;
	end

	if state == nil or checkboxes.get_state_coords(state) == nil then
		return;
	end

	interactive.coordinate = checkboxes.get_state_coords(state)
	interactive.edit_range = { cursor[1] - 1, col_start, col_end };
	interactive.__draw();
	interactive.__cache_keymaps(buffer);

	local on_keypress;

	on_keypress = vim.on_key(function (_, raw)
		if not vim.list_contains({ "h", "j", "k", "l" }, raw) then
			vim.on_key(nil, on_keypress);
			interactive.__close();
		end
	end);
end

checkboxes.toggler = toggler;
checkboxes.change = changer;
checkboxes.interactive = interactive;

--- Commands for this module.
checkboxes.__completion = utils.create_user_command_class({
	default = {
		completion = function (arg_lead)
			local comp = {};

			for _, item in ipairs({ "toggle", "change", "interactive" }) do
				if item:match(arg_lead) then
					table.insert(comp, item);
				end
			end

			table.sort(comp);
			return comp;
		end,
		action = function (params)
			if params.line1 ~= params.line2 then
				checkboxes.toggler.init(0, params.line1 - 1, params.line2);
			else
				checkboxes.toggler.init();
			end
		end
	},
	sub_commands = {
		["toggle"] = {
			action = function (params)
				if params.line1 ~= params.line2 then
					checkboxes.toggler.init(0, params.line1 - 1, params.line2);
				else
					checkboxes.toggler.init();
				end
			end
		},
		["change"] = {
			action = function (params)
				local x = tonumber(params.fargs[2]);
				local y = tonumber(params.fargs[3]);

				if params.line1 ~= params.line2 then
					checkboxes.change.init(0, params.line1 - 1, params.line2, x, y);
				else
					checkboxes.change.init(0, nil, nil, x, y);
				end
			end
		},
		["interactive"] = {
			action = function ()
				checkboxes.interactive.init();
			end
		},
	}
});

--- New command
vim.api.nvim_create_user_command("Checkbox", function (params)
	checkboxes.__completion:exec(params)
end, {
	nargs = "*",
	complete = function (...)
		return checkboxes.__completion:comp(...)
	end,
	range = true
});

---@param config markview.extras.checkbox.config?
checkboxes.setup = function (config)
	if not config then
		return;
	end

	checkboxes.config = vim.tbl_deep_extend("force", checkboxes.config, config);
end

return checkboxes;
