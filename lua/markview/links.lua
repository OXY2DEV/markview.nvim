--- A simple link opener for `markview.nvim`.
---
--- This is a `tree-sitter` based wrapper
--- for `vim.ui.input()`.
---
--- Features:
---     • Flexible enough to work on any
---       of the supported nodes.
---     • Opens text files/selected filetypes
---       inside **Neovim**.
---     • Multiple file open methods.
local links = {};
local spec = require("markview.spec");

--- Opens an address via `vim.ui.open()`.
---@param address string
links.__open_in_app = function (address)
	local cmd, err = vim.ui.open(address);
	if err then
		vim.notify("[ Markview.nvim ] : Failed to open: " .. link.address, vim.diagnostic.severity.WARN)
		return;
	end

	if cmd then
		cmd:wait();
		return;
	end
end

--- Opens a file inside **Neovim**.
---@param address string
links.__open_in_nvim = function (address)
	local method = spec.get("links", "nvim_open_method") or "tab";

	if method == "tab" then
		vim.cmd("tabnew " .. address);
	elseif method == "split" then
		vim.cmd("split " .. address);
	elseif method == "vsplit" then
		vim.cmd("vsplit " .. address);
	elseif method == "replace" then
		vim.cmd("edit " .. address);
	end
end

--- Internal function that handles
--- opening links.
---@param address string?
links.__open = function (address)
	if not address then
		return;
	end

	local extension = vim.fn.fnamemodify(address, ":e");

	if spec.get("links", "open_in_nvim") then
		---+${default, Configuration for filetypes to open in nvim exists}
		local in_nvim = spec.get("links", "open_in_nvim");

		if
			not address:match("^http") and
			not address:match("^www%.") and

			vim.list_contains(in_nvim, extension)
		then
			links.__open_in_nvim(address);
		else
			links.__open_in_app(address);
		end
		---_
		return;
	end

	local file = io.open(address, "rb");

	if not file then
		links.__open_in_app(address);
		return;
	end

	local read_bytes = spec.get("experimental", "file_byte_read") or 1024;
	local bytes = file:read(read_bytes);
	file:close();

	for b = 1, #bytes do
		local byte = bytes:byte(b);

		if
			byte < 32 and
			not vim.list_contains({ 9, 10, 13 }, byte)
		then
			links.__open_in_app(address);
			return;
		end
	end

	links.__open_in_nvim(address);
end

--- Opens an inline link.
--- Example: `[text](https://www.neovim.org)`
---@param node table
---@param buffer integer
links.inline_link = function (node, buffer)
	local to = node:child(4);
	if not to then return; end

	links.__open(vim.treesitter.get_node_text(to, buffer))
end;

--- Opens an image link.
--- Example: `![text](https://www.neovim.org)`
---@param node table
---@param buffer integer
links.image = function (node, buffer)
	local to = node:child(5);
	if not to then return; end

	links.__open(vim.treesitter.get_node_text(to, buffer))
end;

--- Opens an shortcut link.
--- Example: `[https://www.neovim.org]`
---@param node table
---@param buffer integer
links.shortcut_link = function (node, buffer)
	local to = node:child(1);
	if not to then return; end

	local address = vim.treesitter.get_node_text(to, buffer);
	if address:match("|") then
		address = address:match("^([^%|]+)%|");
	end

	links.__open(address)
end

--- Opens an uri_autolink.
--- Example: `<https://www.neovim.org>`
---@param node table
---@param buffer integer
links.uri_autolink = function (node, buffer)
	local to = node;
	if not to then return; end

	links.__open(
		vim.treesitter.get_node_text(to, buffer):gsub("^%<", ""):gsub("%>$", "")
	);
end;

--- Opens the link under the cursor.
---
--- Initially uses tree-sitter to find
--- a valid link.
---
--- Fallback to the `<cfile>` if no node
--- was found.
links.open = function ()
	local buffer = vim.api.nvim_get_current_buf();
	local node = vim.treesitter.get_node({
		ignore_injections = false
	});

	while node do
		if links[node:type()] then
			links[node:type()](node, buffer);
			return;
		end

		node = node:parent();
	end

	links.__open_in_app(vim.fn.expand("<cfile>"));
end

return links;
