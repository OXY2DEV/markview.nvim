local asciidoc = {};

local utils = require("markview.utils");
local spec = require("markview.spec");

asciidoc.ns = vim.api.nvim_create_namespace("markview/asciidoc");

---@param buffer integer
---@param item markview.parsed.asciidoc.document_titles
asciidoc.document_attribute = function (buffer, item)
	---@type markview.config.asciidoc.document_titles?
	local config = spec.get({ "asciidoc", "document_attributes" }, { eval_args = { buffer, item } });

	if not config then
		return;
	end

	local range = item.range;

	utils.set_extmark(buffer, asciidoc.ns, range.row_start, range.col_start, {
		end_row = range.row_end - 1,
		conceal_lines = "",
	});
end

---@param buffer integer
---@param item markview.parsed.asciidoc.document_titles
asciidoc.document_title = function (buffer, item)
	---@type markview.config.asciidoc.document_titles?
	local config = spec.get({ "asciidoc", "document_titles" }, { eval_args = { buffer, item } });

	if not config then
		return;
	end

	local range = item.range;

	utils.set_extmark(buffer, asciidoc.ns, range.row_start, range.col_start, {
		-- Remove `=%s*` amount of characters.
		end_col = range.col_start + #string.match(item.text[1] or "", "=+%s*"),
		conceal = "",

		sign_text = tostring(config.sign or ""),
		sign_hl_group = utils.set_hl(config.sign_hl),

		virt_text = {
			{ config.icon, config.icon_hl or config.hl },
		},
		line_hl_group = utils.set_hl(config.hl),
	});
end

---@param buffer integer
---@param content markview.parsed.asciidoc[]
asciidoc.render = function (buffer, content)
	asciidoc.cache = {
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
			success, err = pcall(custom[item.class], asciidoc.ns, buffer, item);
		else
			success, err = pcall(asciidoc[item.class:gsub("^asciidoc_", "")], buffer, item);
		end

		if success == false then
			require("markview.health").print({
				kind = "ERR",

				from = "renderers/asciidoc.lua",
				fn = "render() -> " .. item.class,

				message = {
					{ tostring(err), "DiagnosticError" }
				}
			});
		end
	end
end

--- Clears decorations of HTML elements
---@param buffer integer
---@param from integer
---@param to integer
asciidoc.clear = function (buffer, from, to)
	vim.api.nvim_buf_clear_namespace(buffer, asciidoc.ns, from or 0, to or -1);
end

return asciidoc;
