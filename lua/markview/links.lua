--- A simple link opener for `markview.nvim`.
---
--- This is a `tree-sitter` based wrapper
--- for `vim.ui.input()`.
local links = {};
local health = require("markview.health");
local spec = require("markview.spec");

--[[ Link reference maps for `buffers`. ]]
---@type table<integer, table<string, markview.parsed.range>>
links.reference = {};

--[[ Clears link references for `buffer`. ]]
---@param buffer integer
links.clear = function (buffer)
	links.reference[buffer] = {};
end

--[[ Adds a new link reference to `buffer`. ]]
---@param buffer integer
---@param name string
---@param range integer[]
links.new = function (buffer, name, range)
	---|fS

	if not links.reference[buffer] then
		links.reference[buffer] = {};
	end

	links.reference[buffer][name] = range;

	---|fE
end

--[[ Gets a link reference named `name` from `buffer`. ]]
---@param buffer integer
---@param name string
links.get = function (buffer, name)
	---|fS

	if not links.reference[buffer] then
		return;
	end

	return links.reference[buffer][name];

	---|fE
end

--[[ Parsed version of an `address`. ]]
---@class markview.links.parsed
---
---@field path? string
---@field url? string
---@field fragment? string

--[[ Parses given `address`. ]]
---@param address string
---@return markview.links.parsed
links.parse = function (address)
	---|fS

	local scheme = string.match(address, "^[a-zA-Z][a-zA-Z0-9+.-]*://")

	if scheme and vim.list_contains({ "http://", "https://", "ftp://" }, scheme) then
		-- Example: https://google.com
		-- Example: `ftp://...`
		return { url = address };
	elseif string.match(address, "^www%.") then
		-- Example: www.google.com
		return { url = address };
	elseif string.match(address, "^[a-zA-Z0-9+.-]+%.[a-zA-Z0-9]+") then
		-- Example: `google.com`

		---@diagnostic disable-next-line: undefined-field
		local stat = vim.uv.fs_stat(address)

		if stat == nil or stat.type ~= "file" then
			return { url = address };
		end
	elseif string.match(address, "^#") then
		-- Example: `#-heading-1`
		return { fragment = string.gsub(address, "^#", "") };
	end

	---@type string, string
	local path, fragment = string.match(address, "^(.+)#(.+)$");

	return {
		path = path or address,
		fragment = fragment == "" and nil or fragment
	};

	---|fE
end

--- Tree-sitter node processor.
---@type { [string]: fun(buffer: integer, node: table): string? }
local processors = {};

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
		local _text = text:gsub("^%[", ""):gsub("%]$", "");
		return _text;
	else
		local _text = text:gsub("\n", ""):gsub("^%[", ""):gsub("%]$", "");
		return _text;
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


--- [ Stuff ] ------------------------------------------------------------------------------

--[[ Checks if `address` is a *text file* using basic `heuristics`. ]]
---@param address string
---@return boolean
links.__text_file = function (address)
	---|fS

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

	---|fE
end

--[[ Go to `fragment` in `buffer`. ]]
---@param buffer integer
---@param fragment string
links.__to_fragment = function (buffer, fragment)
	---|fS

	require("markview.parser").parse_links(buffer);

	if
		not links.reference[buffer] or not links.reference[buffer][fragment]
	then
		health.print({
			kind = "msg",
			from = "markview/links.lua",
			fn = "__to_fragment()",

			message = {
				{ "Couldn't find ", "Comment" },
				{ string.format(" ID(%s) ", fragment), "DiagnosticVirtualTextHint" },
				{ " in document! ", "Comment" },
			}
		});
		return;
	end

	local item = links.reference[buffer][fragment];
	local wins = vim.fn.win_findbuf(buffer);

	if not wins or #wins == 0 then
		return;
	end

	-- NOTE: Add the current position to the `jumplist`. See #410.
	vim.cmd("normal! m'");
	pcall(
		vim.api.nvim_win_set_cursor,
		wins[1],
		{
			item.row_start + 1,
			item.col_start
		}
	);

	---|fE
end

--- Internal functions to open links.
---@param buffer integer
---@param address string?
links.__open = function (buffer, address)
	---|fS

	if type(address) ~= "string" then
		vim.api.nvim_buf_call(buffer, function ()
			address = vim.fn.expand("<cfile>");
		end);
	end

	---@cast address string

	--[[ Wrapper for `vim.ui.open`. ]]
	local function ui_open (path)
		local cmd, err = vim.ui.open(path);

		if cmd then
			cmd:wait();
		elseif err then
			health.print({
				kind = "msg",
				from = "markview/links.lua",
				fn = "__open()",

				message = {
					{ "Couldn't open: ", "Comment" },
					{ string.format(" %s ", path), "DiagnosticVirtualTextHint" },
					{ "; ", "Comment" },
					{ tostring(err), "DiagnosticVirtualTextHint" },
				}
			});
		end
	end

	local parsed = links.parse(address);

	local command = spec.get({ "experimental", "file_open_command" }, { fallback = "tabnew" });
	local prefer_nvim = spec.get({ "experimental", "prefer_nvim" }, { fallback = true });

	if parsed.fragment and not parsed.path then
		-- Go to `fragment` in the **current** buffer.
		links.__to_fragment(buffer, parsed.fragment);
	elseif parsed.path then
		-- Go to a *different* buffer.
		-- Optionally into it's fragment if `prefer_nvim` is `true`.
		if prefer_nvim then
			vim.cmd(string.format("%s %s", command, parsed.path));
			local buf = vim.fn.bufnr(parsed.path);

			if buf and parsed.fragment then
				links.__to_fragment(buf, parsed.fragment);
			end
		else
			ui_open(parsed.path);
		end
	else
		-- Let the OS handle it.
		ui_open(parsed.url or parsed.path);
	end

	---|fE
end

--- `Tree-sitter` based link opener.
---@param buffer integer
links.treesitter = function (buffer)
	local utils = require("markview.utils");
	local node;

	if vim.api.nvim_get_current_buf() == buffer then
		node = vim.treesitter.get_node({ ignore_injections = false });
	else
		local primary_win = utils.buf_getwin(buffer);
		local cursor = vim.api.nvim_win_get_cursor(primary_win);

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
end

--- Opens the link under the cursor.
---
--- Initially uses tree-sitter to find
--- a valid link.
---
--- Fallback to the `<cfile>` if no node
--- was found.
links.open = function ()
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
		health.print({
			kind = "msg",
			from = "markview/links.lua",
			fn = "__open()",

			message = {
				{ " tree-sitter parsers ", "DiagnosticVirtualTextHint" },
				{ " not found! Using " },
				{ " <cfile> ", "DiagnosticVirtualTextInfo" },
				{ "." }
			}
		});

		links.__open(buffer);
	end
end

return links;
