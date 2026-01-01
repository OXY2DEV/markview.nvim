local doctext = {};

local utils = require("markview.utils");
local spec = require("markview.spec");

doctext.ns = vim.api.nvim_create_namespace("markview/doctext");

---@param buffer integer
---@param item markview.parsed.doctext.tasks
doctext.task = function (buffer, item)
	---|fS

	---@type markview.config.doctext.tasks?
	local main_config = spec.get({ "doctext", "tasks" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type markview.config.doctext.tasks.opts?
	local config = utils.match(main_config, item.kind, {
		ignore_keys = { "enable" },
		eval_args = { buffer, item }
	});

	if not config then
		return;
	end

	local range = item.range;
	local row_end = range.label_row_end or range.kind[3];
	local col_end = range.label_col_end or range.kind[4];

	vim.api.nvim_buf_set_extmark(buffer, doctext.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, doctext.ns, range.kind[1], range.kind[2], {
		undo_restore = false, invalidate = true,
		end_row = row_end,
		end_col = col_end,

		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, doctext.ns, row_end, col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	if config.desc_hl then
		vim.api.nvim_buf_set_extmark(buffer, doctext.ns, row_end, col_end, {
			undo_restore = false, invalidate = true,
			end_row = range.row_end,
			end_col = range.col_end,

			hl_group = utils.set_hl(config.desc_hl)
		});
	end

	---|fE
end

---@param buffer integer
---@param item markview.parsed.doctext.issues
doctext.issue = function (buffer, item)
	---|fS

	---@type markview.config.doctext.tasks?
	local main_config = spec.get({ "doctext", "issues" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type markview.config.doctext.tasks.opts?
	local config = utils.match(main_config, item.text[1] or "", {
		ignore_keys = { "enable" },
		eval_args = { buffer, item }
	});

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, doctext.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, doctext.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, doctext.ns, range.row_end, range.col_end, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	---|fE
end

---@param buffer integer
---@param item markview.parsed.doctext.mentions
doctext.mention = function (buffer, item)
	---|fS

	---@type markview.config.doctext.tasks?
	local main_config = spec.get({ "doctext", "mentions" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type markview.config.doctext.tasks.opts?
	local config = utils.match(main_config, item.text[1] or "", {
		ignore_keys = { "enable" },
		eval_args = { buffer, item }
	});

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, doctext.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, doctext.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, doctext.ns, range.row_end, range.col_end, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	---|fE
end

--- Renders HTML elements
---@param buffer integer
---@param content markview.parsed.doctext[]
doctext.render = function (buffer, content)
	local custom = spec.get({ "renderers" }, { fallback = {} });

	for _, item in ipairs(content or {}) do
		local success, err;

		if custom[item.class] then
			success, err = pcall(custom[item.class], doctext.ns, buffer, item);
		else
			success, err = pcall(doctext[item.class:gsub("^doctext_", "")], buffer, item);
		end

		if success == false then
			require("markview.health").print({
				kind = "ERR",

				from = "renderers/doctext.lua",
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
doctext.clear = function (buffer, from, to)
	vim.api.nvim_buf_clear_namespace(buffer, doctext.ns, from or 0, to or -1);
end

return doctext;
