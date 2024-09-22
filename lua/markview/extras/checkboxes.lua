local checkboxes = {};

local next_group = function (current_group)
	if current_group + 1 > #checkboxes.configuraton.states then
		return checkboxes.configuraton.states[(current_group + 1) % #checkboxes.configuraton.states]
	end

	return checkboxes.configuraton.states[current_group + 1];
end

local prev_group = function (current_group)
	if current_group - 1 < 1 then
		return checkboxes.configuraton.states[#checkboxes.configuraton.states]
	end

	return checkboxes.configuraton.states[current_group - 1];
end

checkboxes.cached_state = 1;

checkboxes.configuraton = {
	remove_markers = true,
	default_marker = "-",

	default_state = "X",

	states = {
		{ "X", " ", "-" },
		{ "o" },
	}
}

checkboxes.toggle = function ()
	local buffer = vim.api.nvim_get_current_buf();
	local from, to = vim.fn.getpos("v"), vim.fn.getpos(".");
	local hasMarkers = false;

	local text = vim.api.nvim_buf_get_lines(buffer, from[2] - 1, to[2], false);

	for _, line in ipairs(text) do
		if line:match("^%s*([%-%+%*])") then
			hasMarkers = true;
			break;
		end
	end

	for l, line in ipairs(text) do
		if line:match("^%s*[%-%+%*]%s*%[(.)%]") then
			local marker = line:match("^%s*([%-%+%*])");
			local box = line:match("^%s*[%-%+%*]%s*%[(.)%]");

			if checkboxes.configuraton.remove_markers == true then
				text[l] = line:gsub(marker .. "%s*%[" .. box .. "%]%s*", "");
			else
				text[l] = line:gsub(marker .. "%s*%[" .. box .. "%]", marker);
			end
		elseif hasMarkers == true and line:match("^%s*([%-%+%*])") then
			local marker = line:match("^%s*([%-%+%*])");
			local indent = line:match("^(%s*)");

			text[l] = line:gsub(indent .. marker, indent .. marker .. " [" .. checkboxes.configuraton.default[1] .. "]")
		elseif hasMarkers == false then
			text[l] = checkboxes.configuraton.preferred_marker .. " [" .. checkboxes.configuraton.default[1] .. "] " .. line;
		end
	end

	vim.api.nvim_buf_set_lines(buffer, from[2] - 1, to[2], false, text);
end

local get_index = function (box)
	for g, group in ipairs(checkboxes.configuraton.states) do
		if vim.list_contains(group, box) then
			for s, state in ipairs(group) do
				if state == box then
					return group, g, s;
				end
			end
		end
	end
end

checkboxes.cycle = {
	next = function ()
		local buffer = vim.api.nvim_get_current_buf();
		local from, to = vim.fn.getpos("v"), vim.fn.getpos(".");

		local text = vim.api.nvim_buf_get_lines(buffer, from[2] - 1, to[2], false);

		for l, line in ipairs(text) do
			if line:match("^%s*([%-%+%*])") then
				local marker = line:match("^%s*([%-%+%*])");
				local box = line:match("^%s*[%-%+%*]%s*%[(.)%]");
				local indent = line:match("^(%s*)");

				local states, _, s = get_index(box);

				local n_index = s + 1 > #states and (s + 1) % #states or s + 1;

				text[l] = line:gsub(indent .. marker .. "%s*%[%" .. box .. "%]", indent .. marker .. " [" .. states[n_index] .. "]")
			end
		end

		vim.api.nvim_buf_set_lines(buffer, from[2] - 1, to[2], false, text);
	end,
	prev = function ()
		local buffer = vim.api.nvim_get_current_buf();
		local from, to = vim.fn.getpos("v"), vim.fn.getpos(".");

		local text = vim.api.nvim_buf_get_lines(buffer, from[2] - 1, to[2], false);

		for l, line in ipairs(text) do
			if line:match("^%s*([%-%+%*])") then
				local marker = line:match("^%s*([%-%+%*])");
				local box = line:match("^%s*[%-%+%*]%s*%[(.)%]");
				local indent = line:match("^(%s*)");

				local states, _, s = get_index(box);

				local n_index = s - 1 < 1 and #states or s - 1;

				text[l] = line:gsub(indent .. marker .. "%s*%[%" .. box .. "%]", indent .. marker .. " [" .. states[n_index] .. "]")
			end
		end

		vim.api.nvim_buf_set_lines(buffer, from[2] - 1, to[2], false, text);
	end,

	above = function ()
		local buffer = vim.api.nvim_get_current_buf();
		local from, to = vim.fn.getpos("v"), vim.fn.getpos(".");

		local text = vim.api.nvim_buf_get_lines(buffer, from[2] - 1, to[2], false);

		for l, line in ipairs(text) do
			if line:match("^%s*([%-%+%*])") then
				local marker = line:match("^%s*([%-%+%*])");
				local box = line:match("^%s*[%-%+%*]%s*%[(.)%]");
				local indent = line:match("^(%s*)");

				local _, g, s = get_index(box);
				local n_states = next_group(g);

				if s > checkboxes.cached_state then
					checkboxes.cached_state = s;
				end

				local n_index = math.min(#n_states, checkboxes.cached_state);

				text[l] = line:gsub(indent .. marker .. "%s*%[%" .. box .. "%]", indent .. marker .. " [" .. n_states[n_index] .. "]")
			end
		end

		vim.api.nvim_buf_set_lines(buffer, from[2] - 1, to[2], false, text);
	end,
}





---@class mkv.extra.checkboxes.state
---
---@field marker? string
---@field checkbox? string

---@type table<integer, mkv.extra.checkboxes.state[]>
checkboxes.n_state = {};

checkboxes.n_update = function (buffer, line, str, save)
	if not checkboxes.n_state[buffer] then
		checkboxes.n_state[buffer] = {};
	end

	local checkbox = str:match("%s*[%-%+%*]%s*%[(.)%]");
	local marker = str:match("^%s*([%-%+%*])")
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
		checkboxes.n_state[buffer][line] = vim.tbl_extend("force", checkboxes.n_state[buffer][line] or {}, {
			marker = marker,
			checkbox = checkbox,

			group = group, state = state
		});
	end

	return {
		marker = marker,
		checkbox = checkbox,

		group = group, state = state
	};
end

checkboxes.n_toggle = function (remove_markers, exit)
	local buffer = vim.api.nvim_get_current_buf();
	local from, to = vim.fn.getpos("v"), vim.fn.getpos(".");
	local hasMarkers = false;

	from, to = math.min(from[2], to[2]), math.max(from[2], to[2])

	local text = vim.api.nvim_buf_get_lines(buffer, from - 1, to, false);

	for _, line in ipairs(text) do
		if line:match("^%s*([%-%+%*])") then
			hasMarkers = true;
			break;
		end
	end

	local inside_item, removed_item, list_indent = false, false, "";

	for l, line in ipairs(text) do
		if hasMarkers == true then
			local data = checkboxes.n_update(buffer, from + l - 1, line, true);
			local this = checkboxes.n_state[vim.api.nvim_get_current_buf()][from + l - 1];

			local indent = line:match("^(%s*)");

			if inside_item == true and line == "" then
				inside_item = false;
				list_indent = "";
			end

			if data.checkbox then
				-- Checkbox exists,
				-- Remove the checkbox
				removed_item = true;
				inside_item = false;

				if remove_markers == true or checkboxes.configuraton.remove_markers == true then
					text[l] = line:gsub(indent .. data.marker .. "%s+%[%" .. data.checkbox .. "%]" .. "%s?", indent)
				else
					text[l] = line:gsub(indent .. data.marker .. "%s+%[%" .. data.checkbox .. "%]", indent .. data.marker)
				end
			elseif data.marker then
				-- List marker exists,
				-- Add the checkbox
				removed_item = false;
				inside_item = true;

				if this.checkbox then
					text[l] = line:gsub(indent .. "%" .. data.marker .. "%s*", indent .. data.marker .. " [" .. this.checkbox .. "] ")
				else
					text[l] = line:gsub(indent .. "%" .. data.marker .. "%s*", indent .. data.marker .. " [" .. checkboxes.configuraton.default .. "] ")
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
		elseif not line:match("^(%s*)$") then
			checkboxes.n_update(buffer, from + l - 1, line, false);

			local this = checkboxes.n_state[vim.api.nvim_get_current_buf()][from + l - 1] or {};
			local indent = line:match("^(%s*)");

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
		local data = checkboxes.n_update(buffer, from + l - 1, line, false);

		if data.checkbox then
			local next = scroll(checkboxes.configuraton.states[data.group], data.state + 1, scroll_past_end)

			text[l] = line:gsub("%[%" .. data.checkbox .. "%]", "[" .. next .. "]")
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
		local data = checkboxes.n_update(buffer, from + l - 1, line, true);

		if data.checkbox then
			local next = scroll(checkboxes.configuraton.states[data.group], data.state - 1, scroll_past_end)

			text[l] = line:gsub("%[%" .. data.checkbox .. "%]", "[" .. next .. "]")
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
		local data = checkboxes.n_update(buffer, from + l - 1, line, false);

		if data.checkbox then
			local next = tbl_clamp(scroll(checkboxes.configuraton.states, data.group + 1, scroll_past_end), data.state);

			text[l] = line:gsub("%[%" .. data.checkbox .. "%]", "[" .. next .. "]")
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
		local data = checkboxes.n_update(buffer, from + l - 1, line, false);

		if data.checkbox then
			local next = tbl_clamp(scroll(checkboxes.configuraton.states, data.group - 1, scroll_past_end), data.state);

			text[l] = line:gsub("%[%" .. data.checkbox .. "%]", "[" .. next .. "]")
		end
	end

	vim.api.nvim_buf_set_lines(buffer, from - 1, to, false, text);
end

return checkboxes;
