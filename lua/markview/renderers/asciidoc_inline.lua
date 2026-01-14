local asciidoc_inline = {};

local utils = require("markview.utils");
local spec = require("markview.spec");

asciidoc_inline.ns = vim.api.nvim_create_namespace("markview/asciidoc_inline");

---@param buffer integer
---@param item markview.parsed.asciidoc_inline.bolds
asciidoc_inline.bold = function (buffer, item)
	---@type markview.config.asciidoc_inline.bolds?
	local config = spec.get({ "asciidoc_inline", "bolds" }, { eval_args = { buffer, item } });

	if not config then
		return;
	end

	local range = item.range;

	utils.set_extmark(buffer, asciidoc_inline.ns, range.row_start, range.col_start, {
		end_col = range.col_start + #(item.delimiters[1] or ""),
		conceal = "",
	});

	utils.set_extmark(buffer, asciidoc_inline.ns, range.row_end, range.col_end - #(item.delimiters[2] or ""), {
		end_col = range.col_end,
		conceal = "",
	});
end

---@param buffer integer
---@param item markview.parsed.asciidoc_inline.highlights
asciidoc_inline.highlight = function (buffer, item)
	---@type markview.config.asciidoc_inline.highlights?
	local main_config = spec.get({ "asciidoc_inline", "highlights" }, { fallback = nil });
	local range = item.range;

	if not main_config then
		return;
	end

	---@type markview.config.__inline?
	local config = utils.match(
		main_config,
		table.concat(item.text, "\n"),
		{
			eval_args = { buffer, item }
		}
	);

	if config == nil then
		return;
	end

	utils.set_extmark(buffer, asciidoc_inline.ns, range.row_start, range.col_start, {
		end_col = range.col_start + #(item.delimiters[1] or ""),
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	utils.set_extmark(buffer, asciidoc_inline.ns, range.row_start, range.col_start, {
		end_col = range.col_end, end_row = range.row_end,

		hl_group = utils.set_hl(config.hl),
		hl_mode = "combine"
	});

	utils.set_extmark(buffer, asciidoc_inline.ns, range.row_end, range.col_end - #(item.delimiters[2] or ""), {
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) },
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});
end

---@param buffer integer
---@param item markview.parsed.asciidoc_inline.italics
asciidoc_inline.italic = function (buffer, item)
	---@type markview.config.asciidoc_inline.italics?
	local config = spec.get({ "asciidoc_inline", "italics" }, { eval_args = { buffer, item } });

	if not config then
		return;
	end

	local range = item.range;

	utils.set_extmark(buffer, asciidoc_inline.ns, range.row_start, range.col_start, {
		end_col = range.col_start + #(item.delimiters[1] or ""),
		conceal = "",
	});

	utils.set_extmark(buffer, asciidoc_inline.ns, range.row_end, range.col_end - #(item.delimiters[2] or ""), {
		end_col = range.col_end,
		conceal = "",
	});
end

---@param buffer integer
---@param item markview.parsed.asciidoc_inline.monospaces
asciidoc_inline.monospace = function (buffer, item)
	---@type markview.config.asciidoc_inline.monospaces?
	local config = spec.get({ "asciidoc_inline", "monospaces" }, { eval_args = { buffer, item } });

	if not config then
		return;
	end

	local range = item.range;

	utils.set_extmark(buffer, asciidoc_inline.ns, range.row_start, range.col_start, {
		end_col = range.col_start + #(item.delimiters[1] or ""),
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	utils.set_extmark(buffer, asciidoc_inline.ns, range.row_start, range.col_start, {
		end_col = range.col_end, end_row = range.row_end,

		hl_group = utils.set_hl(config.hl),
		hl_mode = "combine"
	});

	utils.set_extmark(buffer, asciidoc_inline.ns, range.row_end, range.col_end - #(item.delimiters[2] or ""), {
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) },
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});
end

---@param buffer integer
---@param content markview.parsed.asciidoc_inline[]
asciidoc_inline.render = function (buffer, content)
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
