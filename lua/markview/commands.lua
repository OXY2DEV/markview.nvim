local commands = {};

commands.Start = function ()
	require("markview.state").enable(true);
end
commands.Stop = function ()
	require("markview.state").enable(false);
end


commands.disable = function (buffer)
	require("markview.actions").disable(buffer);
end
commands.enable = function (buffer)
	require("markview.actions").enable(buffer);
end
commands.toggle = function (buffer)
	require("markview.actions").toggle(buffer);
end


commands.Disable = function ()
	local actions = require("markview.actions");
	actions.forEach(actions.disable, require("markview.state").get_attached_buffers());
end
commands.Enable = function ()
	local actions = require("markview.actions");
	actions.forEach(actions.enable, require("markview.state").get_attached_buffers());
end
commands.Toggle = function ()
	local actions = require("markview.actions");
	actions.forEach(actions.toggle, require("markview.state").get_attached_buffers());
end


commands.attach = function (buffer)
	require("markview.actions").attach(buffer);
end
commands.detach = function (buffer)
	require("markview.actions").detach(buffer);
end


commands.clear = function (buffer)
	buffer = buffer or vim.api.nvim_get_current_buf();
	require("markview.actions").clear(buffer);
end
commands.render = function (buffer)
	buffer = buffer or vim.api.nvim_get_current_buf();
	require("markview.actions").render(buffer);
end


commands.Clear = function ()
	local actions = require("markview.actions");

	actions.forEach(function (b)
		actions.clear(b);
	end, require("markview.state").get_attached_buffers());
end
commands.Render = function ()
	local actions = require("markview.actions");

	actions.forEach(function (b)
		local buf_state = require("markview.state").get_buffer_state(b, false);

		if buf_state and buf_state.enable then
			actions.render(b);
		end
	end, require("markview.state").get_attached_buffers());
end


commands.hybridDisable = function (buffer)
	require("markview.actions").hybridDisable(buffer);
end
commands.hybridEnable = function (buffer)
	require("markview.actions").hybridEnable(buffer);
end
commands.hybridToggle = function (buffer)
	---|fS

	buffer = buffer or vim.api.nvim_get_current_buf();
	local state = require("markview.state").get_buffer_state(buffer, false);

	if not state then
		return;
	elseif state.hybrid_mode then
		require("markview.actions").hybridDisable(buffer);
	else
		require("markview.actions").hybridEnable(buffer);
	end

	---|fE
end


commands.HybridDisable = function ()
	local actions = require("markview.actions");

	actions.forEach(function (b)
		actions.hybridDisable(b);
	end, require("markview.state").get_attached_buffers());
end
commands.HybridEnable = function ()
	local actions = require("markview.actions");

	actions.forEach(function (b)
		actions.hybridEnable(b);
	end, require("markview.state").get_attached_buffers());
end
commands.HybridToggle = function ()
	local actions = require("markview.actions");

	actions.forEach(function (b)
		actions.hybridToggle(b);
	end, require("markview.state").get_attached_buffers());
end


commands.linewiseDisable = function ()
	require("markview.spec").config.preview.linewise_hybrid_mode = false;
	local actions = require("markview.actions");

	actions.forEach(function (b)
		require("markview.actions").render(b);
	end, require("markview.state").get_enabled_buffers());
end
commands.linewiseEnable = function ()
	require("markview.spec").config.preview.linewise_hybrid_mode = true;
	local actions = require("markview.actions");

	actions.forEach(function (b)
		require("markview.actions").render(b);
	end, require("markview.state").get_enabled_buffers());
end
commands.linewiseToggle = function ()
	---@type boolean Is line-wise hybrid mode enabled?
	local linewise_hybrid_mode = require("markview.spec").get({ "preview", "linewise_hybrid_mode" }, { fallback = false, ignore_enable = true });

	if linewise_hybrid_mode then
		commands.linewiseDisable();
	else
		commands.linewiseEnable();
	end
end


commands.splitToggle = function ()
	require("markview.actions").splitToggle();
end

commands.splitRedraw = function ()
	require("markview.actions").splitview_render();
end

commands.splitOpen = function (buffer)
	require("markview.actions").splitOpen(buffer)
end

commands.splitClose = function ()
	require("markview.actions").splitClose()
end

--[[ Open `link` under cursor. ]]
commands.open = function ()
	require("markview.links").open();
end


commands.traceExport = function ()
	require("markview.health").export();
end
commands.traceShow = function ()
	require("markview.health").view();
end

commands.complete = function (_, cmd, cursorpos)
	local function is_subcommand(str)
		return commands[str] ~= nil;
	end

	local function num_to_items (nums, m)
		local output = {};

		for _, num in ipairs(nums) do
			if string.match(tostring(num), "^" .. tostring(m)) then
				table.insert(output, tostring(num));
			end
		end

		table.sort(output);
		return output;
	end

	local before = string.sub(cmd, 0, cursorpos);
	local parts = {};

	for part in string.gmatch(before, "%S+") do
		if tonumber(part) then
			table.insert(parts, tonumber(part));
		else
			table.insert(parts, part);
		end
	end

	if #parts == 1 or (#parts == 2 and not is_subcommand(parts[2])) then
		local _o = {};
		local invalid = { "setup", "complete" };

		for _, key in ipairs(vim.tbl_keys(commands)) do
			if vim.list_contains(invalid, key) == false and string.match(key, "^" .. (parts[2] or ".")) then
				table.insert(_o, key);
			end
		end

		table.sort(_o);
		return _o;
	elseif is_subcommand(parts[2]) == true then
		local state = require("markview.state");

		if vim.list_contains({ "enable", "disable", "toggle", "detach" }, parts[2]) then
			return num_to_items(
				state.get_attached_buffers(),
				#parts > 2 and parts[#parts] or ""
			);
		elseif vim.list_contains({ "attach", "clear", "render", "splitOpen" }, parts[2]) then
			return num_to_items(
				vim.api.nvim_list_bufs(),
				#parts > 2 and parts[#parts] or ""
			);
		elseif vim.list_contains({ "hybridEnable", "hybridDisable", "hybridToggle", "linewiseEnable", "linewiseDisable", "linewiseToggle" }, parts[2]) then
			return num_to_items(
				state.get_enabled_buffers(),
				#parts > 2 and parts[#parts] or ""
			);
		end
	end
end

commands.setup = function ()
	vim.api.nvim_create_user_command("Markview", function (args)
		local fargs = args.fargs;
		local sub_command = table.remove(fargs, 1);

		if not sub_command then
			commands.Toggle();
		elseif commands[sub_command] and vim.list_contains({ "complete", "setup" }, sub_command) == false then
			pcall(commands[sub_command], unpack(fargs));
		end
	end, {
		nargs = "*",
		complete = commands.complete
	});
end

return commands;
