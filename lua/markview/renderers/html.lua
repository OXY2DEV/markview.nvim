local html = {};
local spec = require("markview.spec");

local get_config = function (...)
	local _c = spec.get({ "html", ... });

	if not _c or _c.enable == false then
		return;
	end

	return _c;
end

html.__ns = {
	__call = function (self, key)
		return self[key] or self.default;
	end
}

html.ns = {
	default = vim.api.nvim_create_namespace("markview/html"),
};
setmetatable(html.ns, html.__ns)

html.set_ns = function ()
	local ns_pref = get_config("use_seperate_ns");
	if not ns_pref then ns_pref = true; end

	local available = vim.api.nvim_get_namespaces();
	local ns_list = {
		["headings"] = "markview/html/headings",
		["container_elements"] = "markview/html/container_elements",
		["void_elements"] = "markview/html/void_elements"
	};

	if ns_pref == true then
		for ns, name in pairs(ns_list) do
			if vim.list_contains(available, ns) == false then
				html.ns[ns] = vim.api.nvim_create_namespace(name);
			end
		end
	end
end

--- Renders headings.
---@param buffer integer
---@param item __html.heading_item
html.heading = function (buffer, item)
	---+${func}
	local config = get_config("headings");

	if not config then
		return;
	elseif not config["heading_" .. item.level] then
		return;
	end

	local range = item.range;
	config = config["heading_" .. item.level];

	vim.api.nvim_buf_set_extmark(
		buffer,
		html.ns("headings"),

		range.row_start,
		range.col_start,
		vim.tbl_extend("force", {
			undo_restore = false, invalidate = true,

			end_row = range.row_end,
			end_col = range.col_end,
		}, config)
	);
	---_
end

--- Renders container elements
---@param buffer integer
---@param item __html.container_item
html.container_element = function (buffer, item)
	---+${func}
	local config = get_config("container_elements");
	local keys = vim.tbl_keys(config);

	if not config then
		return;
	elseif item.name == "enable" then
		return;
	elseif
		not vim.list_contains(keys, string.lower(item.name)) and
		not vim.list_contains(keys, string.upper(item.name)) and
		not vim.list_contains(keys, item.name)
	then
		return;
	end

	---@type html.container_opts
	config = config[string.lower(item.name)] or config[string.upper(item.name)] or config[item.name];

	local eval = function (val, ...)
		if type(val) ~= "function" then
			return val;
		elseif not pcall(val, ...) then
			return;
		end

		return val(...)
	end

	if
		item.opening_tag and
		config.on_opening_tag
	then
		local open_conf = eval(config.on_opening_tag, item.opening_tag);
		local range = item.opening_tag.range;

		if pcall(config.opening_tag_offset, range) then range = config.opening_tag_offset(range) end

		vim.api.nvim_buf_set_extmark(
			buffer,
			html.ns("element_container"),
			range[1],
			range[2],
			vim.tbl_extend("force", {
				undo_restore = false, invalidate = true,

				end_row = range[3],
				end_col = range[4]
			}, open_conf)
		)
	end

	if config.on_node then
		local node_conf = eval(config.on_node, item);
		local range = {
			item.range.row_start, item.range.col_start,
			item.range.row_end,   item.range.col_end
		};

		if pcall(config.node_offset, range) then range = config.node_offset(range) end

		vim.api.nvim_buf_set_extmark(
			buffer,
			html.ns("element_container"),
			range[1],
			range[2],
			vim.tbl_extend("force", {
				undo_restore = false, invalidate = true,

				end_row = range[3],
				end_col = range[4]
			}, node_conf)
		)
	end

	if
		item.closing_tag and
		config.on_closing_tag
	then
		local close_conf = eval(config.on_closing_tag, item.closing_tag);
		local range = item.closing_tag.range;

		if pcall(config.closing_tag_offset, range) then range = config.closing_tag_offset(range) end

		vim.api.nvim_buf_set_extmark(
			buffer,
			html.ns("element_container"),
			range[1],
			range[2],
			vim.tbl_extend("force", {
				undo_restore = false, invalidate = true,

				end_row = range[3],
				end_col = range[4]
			}, close_conf)
		)
	end
	---_
end

--- Renders void elements
---@param buffer integer
---@param item __html.void_item
html.void_element = function (buffer, item)
	---+${func}
	local config = get_config("void_elements");
	local keys = vim.tbl_keys(config);

	if not config then
		return;
	elseif item.name == "enable" then
		return;
	elseif
		not vim.list_contains(keys, string.lower(item.name)) and
		not vim.list_contains(keys, string.upper(item.name)) and
		not vim.list_contains(keys, item.name)
	then
		return;
	end

	---@type html.void_opts
	config = config[string.lower(item.name)] or config[string.upper(item.name)] or config[item.name];

	local eval = function (val, ...)
		if type(val) ~= "function" then
			return val;
		elseif not pcall(val, ...) then
			return;
		end

		return val(...)
	end

	if config.on_node then
		local node_conf = eval(config.on_node, item);
		local range = {
			item.range.row_start, item.range.col_start,
			item.range.row_end,   item.range.col_end
		};

		if pcall(config.node_offset, range) then range = config.node_offset(range) end

		vim.api.nvim_buf_set_extmark(
			buffer,
			html.ns("element_void"),
			range[1],
			range[2],
			vim.tbl_extend("force", {
				undo_restore = false, invalidate = true,

				end_row = range[3],
				end_col = range[4]
			}, node_conf)
		)
	end
	---_
end

--- Renders HTML elements
---@param buffer integer
---@param content table[]
html.render = function (buffer, content)
	---+${func}
	html.cache = {
		font_regions = {},
		style_regions = {
			superscripts = {},
			subscripts = {}
		},
	};

	for _, item in ipairs(content or {}) do
		if html[item.class:gsub("^html_", "")] then
			pcall(html[item.class:gsub("^html_", "")], buffer, item);
			-- html[item.class:gsub("^html_", "")](buffer, item);
		end
	end
	---_
end

--- Clears decorations of HTML elements
---@param buffer integer
---@param ignore_ns string[]?
---@param from integer
---@param to integer
html.clear = function (buffer, ignore_ns, from, to)
	for name, ns in pairs(html.ns) do
		if ignore_ns and vim.list_contains(ignore_ns, name) == false then
			vim.api.nvim_buf_clear_namespace(buffer, ns, from or 0, to or -1);
		end
	end
end

return html;
