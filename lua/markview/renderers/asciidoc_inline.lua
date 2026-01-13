local asciidoc_inline = {};

local utils = require("markview.utils");
local spec = require("markview.spec");

asciidoc_inline.ns = vim.api.nvim_create_namespace("markview/asciidoc_inline");

---@param buffer integer
---@param item markview.parsed.asciidoc_inline.document_titles
asciidoc_inline.bold = function (buffer, item)
	---@type markview.config.asciidoc_inline.bolds?
	local config = spec.get({ "asciidoc_inline", "bolds" }, { eval_args = { buffer, item } });

	if not config then
		return;
	end

	local range = item.range;

	utils.set_extmark(buffer, asciidoc_inline.ns, range.row_start, range.col_start, {
		end_col = range.col_start + 2,
		conceal = "",
	});

	if not string.match(item.text[#item.text] or "", "%*%*$") then
		return;
	end

	utils.set_extmark(buffer, asciidoc_inline.ns, range.row_end, range.col_end - 2, {
		end_col = range.col_end,
		conceal = "",
	});
end

---@param buffer integer
---@param item markview.parsed.asciidoc_inline.document_titles
asciidoc_inline.italic = function (buffer, item)
	---@type markview.config.asciidoc_inline.document_titles?
	local config = spec.get({ "asciidoc_inline", "italics" }, { eval_args = { buffer, item } });

	if not config then
		return;
	end

	local range = item.range;

	utils.set_extmark(buffer, asciidoc_inline.ns, range.row_start, range.col_start, {
		end_col = range.col_start + 1,
		conceal = "",
	});

	if not string.match(item.text[#item.text] or "", "%*$") then
		return;
	end

	utils.set_extmark(buffer, asciidoc_inline.ns, range.row_end, range.col_end - 1, {
		end_col = range.col_end,
		conceal = "",
	});
end

--- Renders HTML elements
---@param buffer integer
---@param content markview.parsed.asciidoc_inline[]
asciidoc_inline.render = function (buffer, content)
	asciidoc_inline.cache = {
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
			success, err = pcall(custom[item.class], asciidoc_inline.ns, buffer, item);
		else
			success, err = pcall(asciidoc_inline[item.class:gsub("^asciidoc_inline_", "")], buffer, item);
		end

		if success == false then
			require("markview.health").print({
				kind = "ERR",

				from = "renderers/asciidoc_inline.lua",
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
asciidoc_inline.clear = function (buffer, from, to)
	vim.api.nvim_buf_clear_namespace(buffer, asciidoc_inline.ns, from or 0, to or -1);
end

return asciidoc_inline;
