local inline = {};
local utils = require("markview.utils");
local entities = require("markview.entities");

inline.ns = vim.api.nvim_create_namespace("markview/inline");

inline.config = nil;

inline.get_config = function (opt)
	local _c = inline.config;

	if not _c.markdown_inline or _c.markdown_inline.enable == false then
		return;
	elseif not _c.markdown_inline[opt] or _c.markdown_inline[opt].enable == false then
		return;
	end

	return _c.markdown_inline[opt];
end

inline.custom_config = function (config, value)
	if not config.custom or not value then
		return config;
	end

	for _, custom in ipairs(config.custom) do
		if custom.match_string and value:match(custom.match_string) then
			return vim.tbl_deep_extend("force", config, custom);
		end
	end

	return config;
end

inline.code_span = function (buffer, item)
	local config = inline.get_config("inline_codes");
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

inline.link_email = function (buffer, item)
	local config = inline.get_config("emails");
	local range = item.range;

	if not config then
		return;
	end

	config = inline.custom_config(config, item.label)

	---+${custom, Draw the parts for the email}
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
	---_
end

inline.link_image = function (buffer, item)
	local config = inline.get_config("images");
	local range = item.range;

	if not config then
		return;
	end

	config = inline.custom_config(config, item.label)

	---+${custom, Draw the parts for the image}
	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.desc_start or (range.col_start + 1),
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.desc_start or range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.desc_end or range.col_end,
		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.desc_end or (range.col_end - 3), {
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
	---_
end

inline.link_hyperlink = function (buffer, item)
	local config = inline.get_config("hyperlinks");
	local range = item.range;

	if not config then
		return;
	end

	config = inline.custom_config(config, item.label);

	---+${custom, Draw the parts for the image}
	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.desc_start or (range.col_start + 1),
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.desc_start or range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.desc_end or range.col_end,
		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.desc_end or (range.col_end - 3), {
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
	---_
end

inline.link_shortcut = function (buffer, item)
	local config = inline.get_config("hyperlinks");
	local range = item.range;

	if not config then
		return;
	end

	---+${custom, Draw the parts for the shortcut links}
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
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});
	---_
end

inline.link_uri_autolink = function (buffer, item)
	local config = inline.get_config("uri_autolinks");
	local range = item.range;

	if not config then
		return;
	end

	config = inline.custom_config(config, item.label);

	---+${custom, Draw the parts for the autolinks}
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
	---_
end

inline.link_internal = function (buffer, item)
	local config = inline.get_config("internal_links");
	local range = item.range;

	if not config then
		return;
	end

	config = inline.custom_config(config, item.label);

	---+${custom, Draw the parts for the internal links}
	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.alias_start or (range.col_start + 2),
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

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.alias_ene or (range.col_end - 2), {
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
	---_
end

inline.link_embed_file = function (buffer, item)
	local config = inline.get_config("embed_files");
	local range = item.range;

	if not config then
		return;
	end

	config = inline.custom_config(config, item.label);

	---+${custom, Draw the parts for the embed file links}
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

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.alias_ene or (range.col_end - 2), {
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
	---_
end

inline.link_block_ref = function (buffer, item)
	local config = inline.get_config("block_references");
	local range = item.range;

	if not config then
		return;
	end

	config = inline.custom_config(config, item.label);

	---+${custom, Draw the parts for the embed file links}
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

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.alias_ene or (range.col_end - 2), {
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
	---_
end

inline.escaped = function (buffer, item)
	local config = inline.get_config("escapes");
	local range = item.range;

	if not config then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = ""
	})
end

inline.entity = function (buffer, item)
	local config = inline.get_config("entities");
	local range = item.range;

	if not config then
		return;
	elseif not entities.get(item.text) then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ entities.get(item.text), utils.set_hl(config.hl) }
		}
	})
end

inline.checkbox = function (buffer, item)
	local config = inline.get_config("checkboxes");
	local range = item.range;

	if not config then
		return;
	else
		local found_state = false;

		if item.text == "X" or item.text == "x" and config.checked then
			config = config.checked;
			goto continue;
		elseif item.text == " " and config.unchecked then
			config = config.unchecked;
			goto continue;
		end

		for _, state in ipairs(config.custom or {}) do
			if item.text == state.match_string then
				config = state;
				found_state = true;
				break;
			end
		end

		if found_state == false then
			return;
		end

		::continue::
	end

	vim.api.nvim_buf_set_extmark(buffer, inline.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.text, utils.set_hl(config.hl) }
		}
	})
end

inline.render = function (buffer, content, config)
	inline.config = config;

	for _, item in ipairs(content or {}) do
		pcall(inline[item.class:gsub("^inline_", "")], buffer, item);
		-- inline[item.class:gsub("^inline_", "")](buffer, item);
	end
end

return inline;
