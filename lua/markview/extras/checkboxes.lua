local checkboxes = {};

local escape_string = function (input)
	if not input then
		return;
	end

	input = input:gsub("%%", "%%%");

	input = input:gsub("%(", "%%(");
	input = input:gsub("%)", "%%)");

	input = input:gsub("%.", "%%.");
	input = input:gsub("%+", "%%+");
	input = input:gsub("%-", "%%-");
	input = input:gsub("%*", "%%*");
	input = input:gsub("%?", "%%?");
	input = input:gsub("%^", "%%^");
	input = input:gsub("%$", "%%$");

	input = input:gsub("%[", "%%[");
	input = input:gsub("%]", "%%]");

	return input;
end


local str2bool = function (str)
	if not str then
		return false;
	elseif str == "true" then
		return true;
	end

	return false;
end

checkboxes.configuraton = {
	remove_markers = true,
	default_marker = "-",

	default_state = "X",

	states = {
		{ "X", " " },
		{ "o", "-" },
	}
}

---@class mkv.extra.checkboxes.state
---
---@field marker? string
---@field checkbox? string

---@type table<integer, mkv.extra.checkboxes.state[]>
checkboxes.state = {};

checkboxes.update = function (buffer, line, str, save)
	if not checkboxes.state[buffer] then
		checkboxes.state[buffer] = {};
	end

	local checkbox = str:match("^[%>%s]*[%-%+%*]%s*%[(.)%]");
	local marker = str:match("^[%>%s]*([%-%+%*])")
	local group, state;

	if checkbox then
		for g, grp in ipairs(checkboxes.configuraton.states) do
			if vim.list_contains(grp, checkbox) then
				for s, ste in ipairs(grp) do
					if ste == checkbox then
						group, state = g, s;
						break;
					end
				end
			end
		end
	end

	if save ~= false then
		checkboxes.state[buffer][line] = vim.tbl_extend("force", checkboxes.state[buffer][line] or {}, {
			marker = marker,
			checkbox = checkbox,

			group = group, state = state
		});
	end

	marker = escape_string(marker);
	checkbox = escape_string(checkbox);

	return {
		marker = marker,
		checkbox = checkbox,

		group = group, state = state
	};
end

checkboxes.toggle = function (remove_markers, exit)
	local buffer = vim.api.nvim_get_current_buf();
	local from, to = vim.fn.getpos("v"), vim.fn.getpos(".");
	local hasMarkers = false;

	if remove_markers == nil then
		remove_markers = checkboxes.configuraton.remove_markers;
	end

	if exit == nil then
		exit = checkboxes.configuraton.exit;
	end

	from, to = math.min(from[2], to[2]), math.max(from[2], to[2])

	local text = vim.api.nvim_buf_get_lines(buffer, from - 1, to, false);

	for _, line in ipairs(text) do
		if line:match("^[%>%s]*([%-%+%*])") then
			hasMarkers = true;
			break;
		end
	end

	local inside_item, removed_item, list_indent = false, false, "";

	for l, line in ipairs(text) do
		if hasMarkers == true then
			local data = checkboxes.update(buffer, from + (l - 1), line, true);
			local this = checkboxes.state[vim.api.nvim_get_current_buf()][from + l - 1];

			local indent = line:match("^([%>%s]*)");

			if inside_item == true and line == "" then
				inside_item = false;
				list_indent = "";
			end

			if data.checkbox then
				-- Checkbox exists,
				-- Remove the checkbox
				removed_item = true;
				inside_item = false;

				if remove_markers == true then
					text[l] = line:gsub(indent .. data.marker .. "%s+%[" .. data.checkbox .. "%]" .. "%s?", indent)
				else
					text[l] = line:gsub(indent .. data.marker .. "%s+%[" .. data.checkbox .. "%]", indent .. data.marker)
				end
			elseif data.marker then
				-- List marker exists,
				-- Add the checkbox
				removed_item = false;
				inside_item = true;

				if this.checkbox then
					text[l] = line:gsub(indent .. "%" .. data.marker .. "%s*", indent .. data.marker .. " [" .. this.checkbox .. "] ")
				else
					text[l] = line:gsub(indent .. "%" .. data.marker .. "%s*", indent .. data.marker .. " [" .. checkboxes.configuraton.default_state .. "] ")
				end
			elseif this.marker and this.checkbox then
				-- A previous marker existed
				-- Restore the marker & checkbox
				removed_item = false;
				inside_item = true;

				text[l] = line:gsub("^" .. indent, indent .. this.marker .. " [" .. this.checkbox .. "] ")
			elseif removed_item == true then
				text[l] = line:gsub("^" .. list_indent .. "  ", "")
			elseif inside_item == true then
				text[l] = line:gsub("^" .. indent, list_indent .. "  ")
			end
		elseif not line:match("^([%>%s]*)$") then
			checkboxes.update(buffer, from + l - 1, line, false);

			local this = checkboxes.state[vim.api.nvim_get_current_buf()][from + l - 1] or {};
			local indent = line:match("^([%>%s]*)");

			if this.checkbox then
				text[l] = line:gsub("^" .. indent, indent .. this.marker .. " [" .. this.checkbox .. "] ")
			else
				text[l] = line:gsub("^" .. indent, indent .. checkboxes.configuraton.default_marker .. " [" .. checkboxes.configuraton.default_state .. "] ")
			end
		end
	end

	vim.api.nvim_buf_set_lines(buffer, from - 1, to, false, text);

	if exit ~= false then
		vim.api.nvim_input("<ESC>");
	end
end

local scroll = function (array, index, scroll_past_end)
	if array[index] then
		return array[index];
	end

	if scroll_past_end == true then
		if index < 1 then
			return array[#array - index]
		elseif index > #array then
			return array[index % #array];
		end
	end

	if index < 1 then
		return array[#array - index]
	elseif index > #array then
		return array[#array];
	end
end

local tbl_clamp = function (tbl, index)
	return tbl[math.min(math.max(1, index), #tbl)];
end

checkboxes.forward = function (scroll_past_end)
	local buffer = vim.api.nvim_get_current_buf();
	local from, to = vim.fn.getpos("v"), vim.fn.getpos(".");

	from, to = math.min(from[2], to[2]), math.max(from[2], to[2])
	local text = vim.api.nvim_buf_get_lines(buffer, from - 1, to, false);

	for l, line in ipairs(text) do
		local data = checkboxes.update(buffer, from + l - 1, line, false);

		if data.checkbox then
			local next = scroll(checkboxes.configuraton.states[data.group], data.state + 1, scroll_past_end)

			text[l] = line:gsub("%[" .. data.checkbox .. "%]", "[" .. next .. "]")
		end
	end

	vim.api.nvim_buf_set_lines(buffer, from - 1, to, false, text);
end

checkboxes.backward = function (scroll_past_end)
	local buffer = vim.api.nvim_get_current_buf();
	local from, to = vim.fn.getpos("v"), vim.fn.getpos(".");

	from, to = math.min(from[2], to[2]), math.max(from[2], to[2])
	local text = vim.api.nvim_buf_get_lines(buffer, from - 1, to, false);

	for l, line in ipairs(text) do
		local data = checkboxes.update(buffer, from + l - 1, line, true);

		if data.checkbox then
			local next = scroll(checkboxes.configuraton.states[data.group], data.state - 1, scroll_past_end)

			text[l] = line:gsub("%[" .. data.checkbox .. "%]", "[" .. next .. "]")
		end
	end

	vim.api.nvim_buf_set_lines(buffer, from - 1, to, false, text);
end


checkboxes.next = function (scroll_past_end)
	local buffer = vim.api.nvim_get_current_buf();
	local from, to = vim.fn.getpos("v"), vim.fn.getpos(".");

	from, to = math.min(from[2], to[2]), math.max(from[2], to[2])
	local text = vim.api.nvim_buf_get_lines(buffer, from - 1, to, false);

	for l, line in ipairs(text) do
		local data = checkboxes.update(buffer, from + l - 1, line, false);

		if data.checkbox then
			local next = tbl_clamp(scroll(checkboxes.configuraton.states, data.group + 1, scroll_past_end), data.state);

			text[l] = line:gsub("%[" .. data.checkbox .. "%]", "[" .. next .. "]")
		end
	end

	vim.api.nvim_buf_set_lines(buffer, from - 1, to, false, text);
end

checkboxes.previous = function (scroll_past_end)
	local buffer = vim.api.nvim_get_current_buf();
	local from, to = vim.fn.getpos("v"), vim.fn.getpos(".");

	from, to = math.min(from[2], to[2]), math.max(from[2], to[2])
	local text = vim.api.nvim_buf_get_lines(buffer, from - 1, to, false);

	for l, line in ipairs(text) do
		local data = checkboxes.update(buffer, from + l - 1, line, false);

		if data.checkbox then
			local next = tbl_clamp(scroll(checkboxes.configuraton.states, data.group - 1, scroll_past_end), data.state);

			text[l] = line:gsub("%[" .. data.checkbox .. "%]", "[" .. next .. "]")
		end
	end

	vim.api.nvim_buf_set_lines(buffer, from - 1, to, false, text);
end

checkboxes.setup = function ()
	vim.api.nvim_create_user_command("CheckboxToggle", function (opts)
		local remove_markers, exit_mode = true, true;
		local fargs = opts.fargs;

		if #fargs > 0 then
			remove_markers = str2bool(fargs[1]);
			exit_mode = str2bool(fargs[2]);
		end

		checkboxes.toggle(remove_markers, exit_mode)
	end, {
		nargs = "*",
		desc = "Toggles checkboxes"
	});

	vim.api.nvim_create_user_command("CheckboxPrevSet", function (opts)
		local scroll_past_end = true;
		local fargs = opts.fargs;

		if #fargs > 0 then
			scroll_past_end = str2bool(fargs[1]);
		end

		checkboxes.previous(scroll_past_end);
	end, {
		desc = "Goes to the previous state state"
	});
	vim.api.nvim_create_user_command("CheckboxNextSet", function (opts)
		local scroll_past_end = true;
		local fargs = opts.fargs;

		if #fargs > 0 then
			scroll_past_end = str2bool(fargs[1]);
		end

		checkboxes.next(scroll_past_end);
	end, {
		desc = "Goes to the next state set"
	});

	vim.api.nvim_create_user_command("CheckboxNext", function (opts)
		local scroll_past_end = true;
		local fargs = opts.fargs;

		if #fargs > 0 then
			scroll_past_end = str2bool(fargs[1]);
		end

		checkboxes.forward(scroll_past_end);
	end, {
		desc = "Toggles checkboxes"
	});
	vim.api.nvim_create_user_command("CheckboxPrev", function (opts)
		local scroll_past_end = true;
		local fargs = opts.fargs;

		if #fargs > 0 then
			scroll_past_end = str2bool(fargs[1]);
		end

		checkboxes.backward(scroll_past_end);
	end, {
		desc = "Toggles checkboxes"
	});
end

return checkboxes;
