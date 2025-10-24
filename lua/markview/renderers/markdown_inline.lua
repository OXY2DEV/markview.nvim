local inline = {};

local spec = require("markview.spec");
local utils = require("markview.utils");
local entities = require("markview.entities");

local symbols = require("markview.symbols");

inline.ns = vim.api.nvim_create_namespace("markview/inline");

--- Render checkbox.
---@param buffer integer
---@param item markview.parsed.markdown_inline.checkboxes | markview.parsed.markdown.checkboxes
inline.checkbox = function (buffer, item)
	---@type markview.config.markdown_inline.checkboxes?
	local main_config = spec.get({ "markdown_inline", "checkboxes" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type { text: string, hl: string?, scope_hl: string? }
	local config;
	local state = item.state or "";
	local range = item.range;

	if ( state == "X" or state == "x" ) and spec.get({ "checked" }, { source = main_config, eval_args = { buffer, item } }) then
		config = spec.get({ "checked" }, { source = main_config, eval_args = { buffer, item } });
	elseif state == " " and spec.get({ "unchecked" }, { source = main_config, eval_args = { buffer, item } }) then
		config = spec.get({ "unchecked" }, { source = main_config, eval_args = { buffer, item } });
	elseif spec.get({ state }, { source = main_config, eval_args = { buffer, item } }) then
		config = spec.get({ state }, { source = main_config, eval_args = { buffer, item } });
	else
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.text, utils.set_hl(config.hl) }
		}
	});
end

--- Render inline codes.
---@param buffer integer
---@param item markview.parsed.markdown_inline.inline_codes
inline.code_span = function (buffer, item)
	---@type markview.config.__inline?
	local config = spec.get({ "markdown_inline", "inline_codes" }, { fallback = nil, eval_args = { buffer, item } });
	local range = item.range;

	if not config then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start + 1, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end - 1,
		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_end, range.col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) },
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	if range.row_start == range.row_end then
		return;
	end

	for l, line in ipairs(item.text) do
		if l == 1 then
			vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start + (l - 1), range.col_start + #line, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
				},

				hl_mode = "combine"
			});
		elseif l == #item.text then
			vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start + (l - 1), 0, {
				undo_restore = false, invalidate = true,
				right_gravity = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
				},

				hl_mode = "combine"
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start + (l - 1), 0, {
				undo_restore = false, invalidate = true,
				right_gravity = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
				},

				hl_mode = "combine"
			});
			vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start + (l - 1), #line, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
				},

				hl_mode = "combine"
			});
		end
	end
end

--- Render entity reference.
---@param buffer integer
---@param item markview.parsed.markdown_inline.entities
inline.entity = function (buffer, item)
	local config = spec.get({ "markdown_inline", "entities" }, { fallback = nil });
	local range = item.range;

	if not config then
		return;
	elseif not entities.get(item.name) then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ entities.get(item.name), utils.set_hl(config.hl) }
		}
	});
end

--- Render escaped characters.
---@param buffer integer
---@param item markview.parsed.markdown_inline.escapes
inline.escaped = function (buffer, item)
	---@type { enable: boolean }?
	local config = spec.get({ "markdown_inline", "escapes" }, { fallback = nil });
	local range = item.range;

	if not config then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = ""
	});
end

--- Render footnotes.
---@param buffer integer
---@param item markview.parsed.markdown_inline.footnotes
inline.footnote = function (buffer, item)
	---@type markview.config.markdown_inline.footnotes?
	local main_config = spec.get({ "markdown_inline", "footnotes" }, { fallback = nil });
	local range = item.range;

	if not main_config then
		return;
	end

	---@type markview.config.__inline?
	local config = utils.match(
		main_config,
		item.label,
		{
			eval_args = { buffer, item }
		}
	);

	if config == nil then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 2,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});
end

--- Render ==highlights==.
---@param buffer integer
---@param item markview.parsed.markdown_inline.highlights
inline.highlight = function (buffer, item)
	---@type markview.config.markdown_inline.highlights?
	local main_config = spec.get({ "markdown_inline", "highlights" }, { fallback = nil });
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

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 2,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start + 2, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end - 2,
		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_end - 2, {
		undo_restore = false, invalidate = true,
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

--- Renders :emojis:.
---@param buffer integer
---@param item markview.parsed.markdown_inline.emojis
inline.emoji = function (buffer, item)
	local config = spec.get({ "markdown_inline", "emoji_shorthands" }, { fallback = nil });
	local range = item.range;

	if not config then
		return;
	elseif not symbols.shorthands[item.name] then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ symbols.shorthands[item.name], utils.set_hl(config.hl) }
		}
	});
end

--- Render [[#^block_references]].
---@param buffer integer
---@param item markview.parsed.markdown_inline.block_refs
inline.link_block_ref = function (buffer, item)
	---@type markview.config.markdown_inline.block_refs?
	local main_config = spec.get({ "markdown_inline", "block_references" }, { fallback = nil });
	local range = item.range;

	if not main_config then
		return;
	end

	---@type markview.config.__inline?
	local config = utils.match(
		main_config,
		item.label,
		{
			eval_args = { buffer, item }
		}
	);

	if not config then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.label[2],
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,
		hl_group = utils.set_hl(config.hl)
	});

	if config.file_hl and vim.islist(range.file) then
		vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.file[1], range.file[2], {
			undo_restore = false, invalidate = true,
			end_row = range.file[3],
			end_col = range.file[4],
			hl_group = utils.set_hl(config.file_hl)
		});
	end

	if config.block_hl and vim.islist(range.block) then
		vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.block[1], range.block[2], {
			undo_restore = false, invalidate = true,
			end_row = range.block[3],
			end_col = range.block[4],
			hl_group = utils.set_hl(config.block_hl)
		});
	end

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_end - 2, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});
end

--- Render ![[embed_files]].
---@param buffer integer
---@param item markview.parsed.markdown_inline.embed_files
inline.link_embed_file = function (buffer, item)
	---@type markview.config.markdown_inline.embed_files?
	local main_config = spec.get({ "markdown_inline", "embed_files" }, { fallback = nil });
	local range = item.range;

	if not main_config then
		return;
	end

	---@type markview.config.__inline
	local config = utils.match(
		main_config,
		item.label,
		{
			eval_args = { buffer, item }
		}
	);

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 2,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_end - 2, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});
end

--- Render <email@mail.com>.
---@param buffer integer
---@param item markview.parsed.markdown_inline.emails
inline.link_email = function (buffer, item)
	---@type markview.config.markdown_inline.emails?
	local main_config = spec.get({ "markdown_inline", "emails" }, { fallback = nil });
	local range = item.range;

	if not main_config then
		return;
	end

	---@type markview.config.__inline
	local config = utils.match(
		main_config,
		item.label,
		{
			eval_args = { buffer, item }
		}
	);

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start + 1, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end - 1,
		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_end - 1, {
		undo_restore = false, invalidate = true,
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

--- Render [hyperlink].
---@param buffer integer
---@param item markview.parsed.markdown_inline.hyperlinks
inline.link_hyperlink = function (buffer, item)
	---@type markview.config.markdown_inline.hyperlinks?
	local main_config = spec.get({ "markdown_inline", "hyperlinks" }, { fallback = nil });
	local range = item.range;

	if not main_config then
		return;
	end

	---@type markview.config.__inline
	local config = utils.match(
		main_config,
		item.description,
		{
			eval_args = { buffer, item }
		}
	);

	---@type integer[]
	local r_label = range.label;

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, r_label[1], r_label[2] - 1, {
		undo_restore = false, invalidate = true,
		end_col = r_label[2],
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, r_label[1], r_label[2], {
		undo_restore = false, invalidate = true,
		end_row = r_label[3],
		end_col = r_label[4],
		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, r_label[3], r_label[4], {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	if r_label[1] == r_label[3] then
		return;
	end

	for l = r_label[1], r_label[3] do
		local line = item.text[(l - range.row_start) + 1];

		if l == r_label[1] then
			vim.api.nvim_buf_set_extmark(buffer, inline.ns, l, range.col_start + #line, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
				},

				hl_mode = "combine"
			});
		elseif l == r_label[3] then
			vim.api.nvim_buf_set_extmark(buffer, inline.ns, l, 0, {
				undo_restore = false, invalidate = true,
				right_gravity = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
				},

				hl_mode = "combine"
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, inline.ns, l, 0, {
				undo_restore = false, invalidate = true,
				right_gravity = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
				},

				hl_mode = "combine"
			});
			vim.api.nvim_buf_set_extmark(buffer, inline.ns, l, #line, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
				},

				hl_mode = "combine"
			});

		end
	end
end

--- Render ![image](image.svg).
---@param buffer integer
---@param item markview.parsed.markdown_inline.images
inline.link_image = function (buffer, item)
	---@type markview.config.markdown_inline.images?
	local main_config = spec.get({ "markdown_inline", "images" }, { fallback = nil });
	local range = item.range;

	if not main_config then
		return;
	end

	---@type markview.config.__inline
	local config = utils.match(
		main_config,
		item.description,
		{
			eval_args = { buffer, item }
		}
	);

	---@type integer[]
	local r_label = range.label;

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, r_label[1], r_label[2] - 1, {
		undo_restore = false, invalidate = true,
		end_col = r_label[2],
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, r_label[1], r_label[2], {
		undo_restore = false, invalidate = true,
		end_row = r_label[3],
		end_col = r_label[4],
		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, r_label[3], r_label[4], {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	if r_label[1] == r_label[3] then
		return;
	end

	for l = r_label[1], r_label[3] do
		local line = item.text[(l - range.row_start) + 1];

		if l == r_label[1] then
			vim.api.nvim_buf_set_extmark(buffer, inline.ns, l, range.col_start + #line, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
				},

				hl_mode = "combine"
			});
		elseif l == r_label[3] then
			vim.api.nvim_buf_set_extmark(buffer, inline.ns, l, 0, {
				undo_restore = false, invalidate = true,
				right_gravity = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
				},

				hl_mode = "combine"
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, inline.ns, l, 0, {
				undo_restore = false, invalidate = true,
				right_gravity = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
				},

				hl_mode = "combine"
			});
			vim.api.nvim_buf_set_extmark(buffer, inline.ns, l, #line, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
				},

				hl_mode = "combine"
			});

		end
	end
end

--- Render [[internal_links]].
---@param buffer integer
---@param item markview.parsed.markdown_inline.internal_links
inline.link_internal = function (buffer, item)
	---@type markview.config.markdown_inline.internal_links?
	local main_config = spec.get({ "markdown_inline", "internal_links" }, { fallback = nil });
	local range = item.range;

	if not main_config then
		return;
	end

	---@type markview.config.__inline
	local config = utils.match(
		main_config,
		item.label,
		{
			eval_args = { buffer, item }
		}
	);

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = vim.islist(range.alias) and range.alias[2] or (range.col_start + 2),
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, vim.islist(range.alias) and range.alias[4] or (range.col_end - 2), {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});
end

--- Render [shortcut_link].
---@param buffer integer
---@param item markview.parsed.markdown_inline.hyperlinks
inline.link_shortcut = function (buffer, item)
	---@type markview.config.markdown_inline.hyperlinks?
	local main_config = spec.get({ "markdown_inline", "hyperlinks" }, { fallback = nil });
	local range = item.range;

	if not main_config then
		return;
	end

	---@type markview.config.__inline
	local config = utils.match(
		main_config,
		item.label,
		{
			eval_args = { buffer, item }
		}
	);

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start + 1, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end - 1,
		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_end, range.col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	if range.row_start == range.row_end then
		return;
	end

	for l, line in ipairs(item.text) do
		if l == 1 then
			vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start + (l - 1), range.col_start + #line, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
				},

				hl_mode = "combine"
			});
		elseif l == #item.text then
			vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start + (l - 1), 0, {
				undo_restore = false, invalidate = true,
				right_gravity = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
				},

				hl_mode = "combine"
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start + (l - 1), 0, {
				undo_restore = false, invalidate = true,
				right_gravity = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
				},

				hl_mode = "combine"
			});
			vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start + (l - 1), #line, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
				},

				hl_mode = "combine"
			});
		end
	end
end

--- Render <https://uri_autolinks.com>
---@param buffer integer
---@param item markview.parsed.markdown_inline.uri_autolinks
inline.link_uri_autolink = function (buffer, item)
	---@type markview.config.markdown_inline.uri_autolinks?
	local main_config = spec.get({ "markdown_inline", "uri_autolinks" }, { fallback = nil });
	local range = item.range;

	if not main_config then
		return;
	end

	---@type markview.config.__inline
	local config = utils.match(
		main_config,
		item.label,
		{
			eval_args = { buffer, item }
		}
	);

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,
		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_end, range.col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});
end

--- Renders inline markdown.
---@param buffer integer
---@param content markview.parsed.markdown_inline[]
inline.render = function (buffer, content)
	local custom = spec.get({ "renderers" }, { fallback = {} });

	for _, item in ipairs(content or {}) do
		local success, err;

		if custom[item.class] then
			success, err = pcall(custom[item.class], inline.ns, buffer, item);
		else
			success, err = pcall(inline[item.class:gsub("^inline_", "")], buffer, item);
		end

		if success == false then
			require("markview.health").notify("trace", {
				level = 4,
				message = {
					{ " r/markdown_inline.lua: ", "DiagnosticVirtualTextInfo" },
					{ string.format(" %s ", item.class), "DiagnosticVirtualTextHint" },
					{ " " },
					{ err, "DiagnosticError" }
				}
			});
		end
	end
end

--- Clears markdown inline previews.
---@param buffer integer
---@param from integer?
---@param to integer?
inline.clear = function (buffer, from, to)
	vim.api.nvim_buf_clear_namespace(buffer, inline.ns, from or 0, to or -1);
end

return inline;
