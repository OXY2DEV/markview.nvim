--[[
Base module for `markview.nvim`.

Contains,
- State variables.
- Default autocmd group.
- Plugin commands implementations.
- Setup function.
- And various helper functions.

And other minor things!

Usage,

```lua
require("markview").setup();
```
]]
local markview = {};

markview.clear = function (buffer)
	require("markview.actions").clear(buffer);
end

markview.render = function (buffer, state, config)
	require("markview.actions").render(buffer, state, config);
end

--[[
Allows *strictly* rendering into `buffer`. To redraw preview of `buffer` it must first be **cleared**.

Useful if you want include it into some function that runs **very frequently**, but only want to render *on demand*/*conditionally*.

You can draw on a buffer like so,

```lua
local renderer = require("markview").strict_render;

renderer:render(0, nil);
```

To redraw into the same buffer you have to run,

```lua
renderer:clear();
renderer:render(0, nil);
```
]]
markview.strict_render = {
	---|fS "feat: Allow rendering buffers strictly(on_demand)"

	---@type table<integer, boolean> Buffers where strict render was used.
	on = {},

	--[[ Allows `buffer` to be rendered again. ]]
	---@param self table
	---@param buffer integer?
	clear = function (self, buffer)
		---|fS

		buffer = buffer or vim.api.nvim_get_current_buf();
		---@cast buffer integer

		if vim.list_contains(self.on, buffer) == false then
			return;
		end

		local actions = require("markview.actions");
		actions.clear(buffer);

		---|fS "chunk: Simulate detaching from the buffer"

		actions.autocmd("on_disable", buffer, vim.fn.win_findbuf(buffer))
		actions.autocmd("on_detach", buffer, vim.fn.win_findbuf(buffer))

		---|fE

		for b, buf in ipairs(self.on) do
			if buf == buffer then
				table.remove(self.on, b);
				return;
			end
		end

		---|fE
	end,

	--[[ Renders `buffer` and prevents redrawing until `:clear()` is called. ]]
	---@param self table
	---@param buffer? integer?
	---@param max_lines? integer
	render = function (self, buffer, max_lines)
		---|fS

		buffer = buffer or vim.api.nvim_get_current_buf();
		max_lines = max_lines or require("markview.spec").get({ "preview", "max_buf_lines" }, { ignore_enable = true, fallback = 1000 }) --[[@as integer]];

		if vim.list_contains(self.on, buffer) then
			return;
		elseif vim.api.nvim_buf_line_count(buffer) >= max_lines then
			return;
		end

		local actions = require("markview.actions");

		---|fS "chore: Simulate attaching to the buffer"

		actions.autocmd("on_attach", buffer, vim.fn.win_findbuf(buffer))
		actions.autocmd("on_enable", buffer, vim.fn.win_findbuf(buffer))

		---|fE

		actions.clear(buffer);
		actions.render(buffer, { enable = true, hybrid_mode = false });

		table.insert(self.on, buffer);

		---|fE
	end

	---|fE
};

markview.actions = {
	__index = function (_, key)
		return require("markview.actions")[key];
	end
};
markview.actions = setmetatable({}, markview.actions);

markview.commands = {
	---|fS

	Start = function ()
		require("markview.state").enable(true);
	end,
	Stop = function ()
		require("markview.state").enable(false);
	end,


	disable = function (buffer)
		markview.actions.disable(buffer)
	end,
	enable = function (buffer)
		markview.actions.enable(buffer)
	end,
	toggle = function (buffer)
		---|fS

		buffer = buffer or vim.api.nvim_get_current_buf();
		local state = require("markview.state").get_buffer_state(buffer, false);

		if state == nil then
			return;
		elseif state.enable == true then
			markview.actions.disable(buffer);
		else
			markview.actions.enable(buffer);
		end

		---|fE
	end,


	Disable = function ()
		local actions = require("markview.actions");
		actions.forEach(markview.actions.disable, require("markview.state").get_attached_buffers());
	end,
	Enable = function ()
		local actions = require("markview.actions");
		actions.forEach(markview.actions.enable, require("markview.state").get_attached_buffers());
	end,
	Toggle = function ()
		local actions = require("markview.actions");
		actions.forEach(markview.actions.toggle, require("markview.state").get_attached_buffers());
	end,


	attach = function (buffer)
		markview.actions.attach(buffer);
	end,
	detach = function (buffer)
		markview.actions.detach(buffer);
	end,


	clear = function (buffer)
		buffer = buffer or vim.api.nvim_get_current_buf();
		markview.clear(buffer);
	end,
	render = function (buffer)
		buffer = buffer or vim.api.nvim_get_current_buf();
		markview.render(buffer);
	end,


	Clear = function ()
		require("markview.actions").forEach(function (b)
			markview.actions.clear(b);
		end, require("markview.state").get_attached_buffers());
	end,
	Render = function ()
		require("markview.actions").forEach(function (b)
			local buf_state = require("markview.state").get_buffer_state(b, false);

			if buf_state and buf_state.enable then
				markview.actions.render(b);
			end
		end, require("markview.state").get_attached_buffers());
	end,


	hybridDisable = function (buffer)
		markview.actions.hybridDisable(buffer);
	end,
	hybridEnable = function (buffer)
		markview.actions.hybridEnable(buffer);
	end,
	hybridToggle = function (buffer)
		---|fS

		buffer = buffer or vim.api.nvim_get_current_buf();
		local state = require("markview.state").get_buffer_state(buffer, false);

		if not state then
			return;
		elseif state.hybrid_mode then
			markview.actions.hybridDisable(buffer);
		else
			markview.actions.hybridEnable(buffer);
		end

		---|fE
	end,


	HybridDisable = function ()
		require("markview.actions").forEach(function (b)
			markview.actions.hybridDisable(b);
		end, require("markview.state").get_attached_buffers());
	end,
	HybridEnable = function ()
		require("markview.actions").forEach(function (b)
			markview.actions.hybridEnable(b);
		end, require("markview.state").get_attached_buffers());
	end,
	HybridToggle = function ()
		require("markview.actions").forEach(function (b)
			markview.actions.hybridToggle(b);
		end, require("markview.state").get_attached_buffers());
	end,


	linewiseDisable = function ()
		require("markview.spec").config.preview.linewise_hybrid_mode = false;

		require("markview.actions").forEach(function (b)
			markview.render(b);
		end, require("markview.state").get_enabled_buffers());
	end,
	linewiseEnable = function ()
		require("markview.spec").config.preview.linewise_hybrid_mode = true;

		require("markview.actions").forEach(function (b)
			markview.render(b);
		end, require("markview.state").get_enabled_buffers());
	end,
	linewiseToggle = function ()
		---@type boolean Is line-wise hybrid mode enabled?
		local linewise_hybrid_mode = require("markview.spec").get({ "preview", "linewise_hybrid_mode" }, { fallback = false, ignore_enable = true });

		if linewise_hybrid_mode then
			markview.commands.linewiseDisable();
		else
			markview.commands.linewiseEnable();
		end
	end,


	splitToggle = function ()
		markview.actions.splitToggle();
	end,

	splitRedraw = function ()
		markview.actions.splitview_render();
	end,

	splitOpen = function (buffer)
		markview.actions.splitOpen(buffer)
	end,

	splitClose = function ()
		markview.actions.splitClose()
	end,

	--[[ Open `link` under cursor. ]]
	open = function ()
		require("markview.links").open();
	end,


	traceExport = function ()
		-- markview.actions.traceExport();
	end,
	traceShow = function (from, to)
		-- if pcall(tonumber, from) and pcall(tonumber, to) then
		-- 	health.trace_open(tonumber(from), tonumber(to));
		-- else
		-- 	health.trace_open();
		-- end
	end,

	---|fE
};

---@param config markview.config?
markview.setup = function (config)
	require("markview.spec").setup(config);

	vim.api.nvim_create_user_command("Markview", function ()
		require("markview.highlights").setup();
		markview.actions.splitToggle();
	end, {});
end

return markview;
