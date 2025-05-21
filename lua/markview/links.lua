--- A simple link opener for `markview.nvim`.
---
--- This is a `tree-sitter` based wrapper
--- for `vim.ui.input()`.
local links = {};
local health = require("markview.health");
local spec = require("markview.spec");

--- Tree-sitter node processor.
---@type { [string]: fun(buffer: integer, node: table): string? }
local processors = {};

---+${lua}

---@param buffer integer
---@param node table
---@return string?
processors.email_autolink = function (buffer, node)
	local address = vim.treesitter.get_node_text(node, buffer);
	address = address:gsub("^%<", ""):gsub("%>$", "");

	return string.format("mailto:%s", address);
end

---@param buffer integer
---@param node table
---@return string?
processors.inline_link = function (buffer, node)
	local address = node:child(4);

	if address == nil then
		return;
	end

	return vim.treesitter.get_node_text(address, buffer);
end

---@param buffer integer
---@param node table
---@return string?
processors.link_reference_definition = function (buffer, node)
	local address = node:named_child(1);

	if address == nil then
		return;
	end

	return vim.treesitter.get_node_text(address, buffer);
end

---@param buffer integer
---@param node table
---@return string?
processors.shortcut_link = function (buffer, node)
	local range = { node:range() };
	local text = vim.treesitter.get_node_text(node, buffer);

	local before = vim.api.nvim_buf_get_lines(buffer, range[1], range[1] + 1, false)[1];
	before = before:sub(0, range[2]);

	local after = vim.api.nvim_buf_get_lines(buffer, range[3], range[3] + 1, false)[1];
	after = after:sub(range[4]);

	if ( range[1] == range[3] ) and before:match("%[$") and after:match("^%]") then
		-- Obsidian internal links or embed files.
		return text:gsub("^%[", ""):gsub("%]$", "");
	else
		return text:gsub("\n", ""):gsub("^%[", ""):gsub("%]$", "");
	end
end

---@param buffer integer
---@param node table
---@return string?
processors.image = function (buffer, node)
	local address = node:named_child(1);

	if address == nil then
		return;
	end

	return vim.treesitter.get_node_text(address, buffer);
end

---@param buffer integer
---@param node table
---@return string?
processors.uri_autolink = function (buffer, node)
	local address = vim.treesitter.get_node_text(node, buffer);
	address = address:gsub("^%<", ""):gsub("%>$", "");

	return address;
end

---@param buffer integer
---@param node table
---@return string?
processors.url = function (buffer, node)
	return vim.treesitter.get_node_text(node, buffer);
end

---_

--- [ Stuff ] ------------------------------------------------------------------------------

--- Checks if {address} is a text file or not.
---@param address string
---@return boolean
links.__text_file = function (address)
	---+${lua}

    local file = io.open(address, "rb");

	if file == nil then
		--- File doesn't exist.
		return false;
	end

	---@type integer
	local read_bytes = spec.get({ "experimental", "read_chunk_size" }, { fallback = 1024 });
	---@type string
	local bytes = file:read(read_bytes);

	file:close();

	if bytes == nil then
		--- Unreadable or Empty file.
		return false;
	elseif bytes:find("\x00") then
		--- Null byte?
		return false;
	end

	local bom = bytes:sub(1, 3);

	if bom == "\xEF\xBB\xBF" then
		return true;
	elseif bom == "\xFF\xFE" or bom == "\xFE\xFF" then
		return true;
	end

	local valid, invalid = 0, 0;

	for b = 1, #bytes do
		local byte = string.byte(bytes, b);

		if byte >= 32 and byte <= 126 then
			valid = valid + 1;
		elseif vim.list_contains({ 9, 10, 13 }, byte) then
			valid = valid + 1;
		else
			invalid = invalid + 1;
		end
	end

	local validity_threshold = 0.9;

	if (valid / #bytes) >= validity_threshold then
		return true;
	else
		return false;
	end
	---_
end

--- Internal functions to open links.
---@param buffer integer
---@param address string?
links.__open = function (buffer, address)
	---+${lua}
	if type(address) ~= "string" then
		vim.api.nvim_buf_call(buffer, function ()
			address = vim.fn.expand("<cfile>");
		end);
	end

	---@cast address string

	--- Checks if a {path} can be opened.
	---@param path string
	---@return boolean
	local function can_open (path)
		---+${lua}

		local stat = vim.uv.fs_stat(path)

		if stat == nil then
			return false;
		elseif stat.type ~= "file" then
			return false;
		end

		return true;
		---_
	end

	--- Wrapper for `vim.ui.open`.
	---@param path string
	local ui_open = function (path)
		---+${lua}

		local cmd, err = vim.ui.open(path);

		if cmd then
			cmd:wait();
		elseif err then
			health.notify("msg", {
				message = { err, "DiagnosticError" }
			});
		end
		---_
	end

	if can_open(address) == false then
		--- {address} isn't a file or it doesn't
		--- exist.
		ui_open(address);
	elseif links.__text_file(address) == true then
		local command = spec.get({ "experimental", "file_open_command" }, { fallback = "tabnew" });
		local prefer_nvim = spec.get({ "experimental", "prefer_nvim" }, { fallback = true });

		if prefer_nvim then
			--- Text file. Open inside Neovim.
			vim.cmd(string.format("%s %s", command, address));
		else
			ui_open(address);
		end
	else
		--- This is a file, but not a text file.
		ui_open(address);
	end
	---_
end

--- `Tree-sitter` based link opener.
---@param buffer integer
links.treesitter = function (buffer)
	---+${lua}

	local utils = require("markview.utils");
	local node;

	if vim.api.nvim_get_current_buf() == buffer then
		node = vim.treesitter.get_node({ ignore_injections = false });
	else
		local primary_win = utils.buf_getwin(buffer);
		local cursor = vimm.api.nvim_win_get_cursor(primary_win);

		node = vim.treesitter.get_node({ bufnr = buffer, pos = cursor, ignore_injections = true });
	end

	while node do
		if pcall(processors[node:type()], buffer, node) then
			local link = processors[node:type()](buffer, node);

			links.__open(buffer, link);
			return;
		end

		node = node:parent();
	end
	---_
end

--- Opens the link under the cursor.
---
--- Initially uses tree-sitter to find
--- a valid link.
---
--- Fallback to the `<cfile>` if no node
--- was found.
links.open = function ()
	---+${lua}

	local utils = require("markview.utils");
	local buffer = vim.api.nvim_get_current_buf();

	local ts_available = function ()
		local ft = vim.bo[buffer].ft;
		local language = vim.treesitter.language.get_lang(ft);

		if language == nil then
			return false;
		elseif utils.parser_installed(language) == false then
			return false;
		end

		return true;
	end

	if ts_available() == true then
		--- Use tree-sitter based link detector.
		links.treesitter(buffer);
	else
		health.notify("msg", {
			message = {
				{ " tree-sitter parsers ", "DiagnosticVirtualTextHint" },
				{ " not found! Using " },
				{ " <cfile> ", "DiagnosticVirtualTextInfo" },
				{ "." }
			}
		});

		links.__open(buffer);
	end
	---_
end

return links;
