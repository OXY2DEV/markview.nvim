local html = {};

local utils = require("markview.utils");
local spec = require("markview.spec");

html.ns = vim.api.nvim_create_namespace("markview/html");

--- Renders container elements
---@param buffer integer
---@param item __html.container_elements
html.container_element = function (buffer, item)
	---+${func}

	---@type html.container_elements?
	local main_config = spec.get({ "html", "container_elements" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type container_elements.opts?
	local config = utils.match(main_config, item.name, {
		ignore_keys = { "enable" },
		default = false,
		eval_args = { buffer, item }
	});

	if not config then
		return;
	end

	if item.opening_tag and config.on_opening_tag then
		local open_conf = spec.get({ "on_opening_tag" }, { source = config, eval_args = { item.opening_tag } });
		local range = item.opening_tag.range;

		if pcall(config.opening_tag_offset, range) then
			range = config.opening_tag_offset(range);
		end


		vim.api.nvim_buf_set_extmark(
			buffer,
			html.ns,
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
		local node_conf = spec.get({ "on_node" }, { source = config, eval_args = { item } });
		local range = {
			item.range.row_start, item.range.col_start,
			item.range.row_end,   item.range.col_end
		};

		if pcall(config.node_offset, range) then
			range = config.node_offset(range);
		end

		vim.api.nvim_buf_set_extmark(
			buffer,
			html.ns,
			range[1],
			range[2],
			vim.tbl_extend("force", {
				undo_restore = false, invalidate = true,

				end_row = range[3],
				end_col = range[4]
			}, node_conf)
		)
	end

	if item.closing_tag and config.on_closing_tag then
		local close_conf = spec.get({ "on_closing_tag" }, { source = config, eval_args = { item.closing_tag } });
		local range = item.closing_tag.range;

		if pcall(config.closing_tag_offset, range) then
			range = config.closing_tag_offset(range);
		end

		vim.api.nvim_buf_set_extmark(
			buffer,
			html.ns,
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

--- Renders headings.
---@param buffer integer
---@param item __html.headings
html.heading = function (buffer, item)
	---+${func}

	---@type html.headings
	local main_config = spec.get({ "html", "headings" }, { fallback = nil });

	if not main_config then
		return;
	elseif not spec.get({ "heading_" .. item.level }, { source = main_config }) then
		return;
	end

	local range = item.range;

	---@type config.extmark
	local config = spec.get({ "heading_" .. item.level }, { source = main_config, eval_args = { buffer, item } });

	vim.api.nvim_buf_set_extmark(
		buffer,
		html.ns,

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

--- Renders void elements
---@param buffer integer
---@param item __html.void_elements
html.void_element = function (buffer, item)
	---+${func}

	---@type html.void_elements?
	local main_config = spec.get({ "html", "void_elements" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type void_elements.opts
	local config = utils.match(main_config, item.name, { default = false, eval_args = { buffer, item } })

	if not main_config then
		return;
	end

	if config.on_node then
		local node_conf = spec.get({ "on_node" }, { source = config, eval_args = { item } });
		local range = {
			item.range.row_start, item.range.col_start,
			item.range.row_end,   item.range.col_end
		};

		if pcall(config.node_offset, range) then
			range = config.node_offset(range);
		end

		vim.api.nvim_buf_set_extmark(
			buffer,
			html.ns,
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

	local custom = spec.get({ "renderers" }, { fallback = {} });

	for _, item in ipairs(content or {}) do
		local success, err;

		if custom[item.class] then
			success, err = pcall(custom[item.class], html.ns, buffer, item);
		else
			success, err = pcall(html[item.class:gsub("^html_", "")], buffer, item);
		end

		if success == false then
			require("markview.health").notify("trace", {
				level = 4,
				message = {
					{ " r/html.lua: ", "DiagnosticVirtualTextInfo" },
					{ string.format(" %s ", item.class), "DiagnosticVirtualTextHint" },
					{ " " },
					{ err, "DiagnosticError" }
				}
			});
		end
	end
	---_
end

--- Clears decorations of HTML elements
---@param buffer integer
---@param from integer
---@param to integer
html.clear = function (buffer, from, to)
	vim.api.nvim_buf_clear_namespace(buffer, html.ns, from or 0, to or -1);
end

return html;
