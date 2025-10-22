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
	__index = function (_, key)
		if vim.list_contains({ "setup", "complete" }, key) then
			return;
		end

		return require("markview.commands")[key];
	end
};
markview.commands = setmetatable({}, markview.commands);

---@param config markview.config?
markview.setup = function (config)
	require("markview.spec").setup(config);
end

return markview;
