local typst = {};
local utils = require("markview.utils");

local set_hl = utils.set_hl;

---@type integer? Namespace used to render stuff, initially nil
typst.namespace = nil;

typst.headings = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	local conf = user_config["heading_" .. content.level];
	local shift = user_config.shift_width or vim.bo[buffer].shiftwidth;

	if not conf then
		return;
	end

	if conf.style == "simple" then
		vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_start, {
			undo_restore = false, invalidate = true,
			line_hl_group = set_hl(conf.hl),
			hl_mode = "combine"
		});
	elseif conf.style == "label" then
		local line_length = #content.text;
		local indent = shift * (content.level - 1);

		if conf.align then
			local win = vim.list_extend(vim.fn.win_findbuf(buffer), { vim.api.nvim_get_current_win() })[1];
			local textoff = conf.textoff or vim.fn.getwininfo(win)[1].textoff;
			local w = vim.api.nvim_win_get_width(win) - textoff;

			if conf.align == "left" then
				indent = 0;
			elseif conf.align == "center" then
				local t = vim.fn.strdisplaywidth(table.concat({
					conf.corner_left or "",
					conf.padding_left or "",
					conf.icon or "",

					content.text:gsub("^(%s*[=]+%s)", ""),

					conf.padding_right or "",
					conf.corner_right or "",
				}));

				indent = math.floor((w - t) / 2);
			else
				local t = vim.fn.strdisplaywidth(table.concat({
					conf.corner_left or "",
					conf.padding_left or "",
					conf.icon or "",

					content.text:gsub("^(%s*[=]+%s)", ""),

					conf.padding_right or "",
					conf.corner_right or "",
				}));

				indent = w - t;
			end
		end

		vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, 0, {
			undo_restore = false, invalidate = true,
			virt_text_pos = "inline",
			sign_text = conf.sign,
			sign_hl_group = set_hl(conf.sign_hl),
			hl_mode = "combine",
			end_col = content.col_start + content.level + 1,
			conceal = "",

			virt_text = {
				{ string.rep(" ", indent) },
				{ conf.corner_left or "", set_hl(conf.corner_left_hl) or set_hl(conf.hl) },
				{ conf.padding_left or "", set_hl(conf.padding_left_hl) or set_hl(conf.hl) },
				{ conf.icon or "", set_hl(conf.icon_hl) or set_hl(conf.hl) }
			},
		});

		vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_start, {
			hl_group = set_hl(conf.hl),
			end_col = content.col_end
		});

		vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, line_length, {
			undo_restore = false, invalidate = true,
			virt_text_pos = "overlay",
			hl_mode = "combine",

			virt_text = {
				{ conf.padding_right or "", set_hl(conf.padding_right_hl) or set_hl(conf.hl) },
				{ conf.corner_right or "", set_hl(conf.corner_right_hl) or set_hl(conf.hl) }
			},
		});
	elseif conf.style == "icon" then
		vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_start, {
			undo_restore = false, invalidate = true,
			virt_text_pos = "inline",
			sign_text = conf.sign,
			sign_hl_group = set_hl(conf.sign_hl),
			hl_mode = "combine",
			end_col = content.col_start + content.level + 1,
			conceal = "",

			virt_text = {
				{ conf.icon or "", set_hl(conf.icon_hl) or set_hl(conf.hl) }
			},
			line_hl_group = set_hl(conf.hl),
		});
	end
end

typst.escaped = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_start, {
		undo_restore = false, invalidate = true,
		end_col = content.col_start + 1,
		conceal = ""
	});
end

typst.list_items = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	local conf, is_ordered = nil, false;

	if content.marker == "-" then
		conf = user_config.marker_minus;
	elseif content.marker == "+" then
		conf = user_config.marker_plus;
	elseif content.marker:match("^%d+$") then
		conf = user_config.marker_dot;
	end

	if not conf then
		return;
	end

	if conf.add_padding == true then
		local level = math.floor(content.col_start / user_config.indent_size) + 1;

		for _, l in ipairs(content.lnums) do
			if l == -1 then
				goto continue;
			end

			vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start + (l - 1), 0, {
				undo_restore = false, invalidate = true,
				end_col = content.col_start,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = { { string.rep(" ", level * user_config.shift_width) } }
			});

			::continue::
		end

		if is_ordered == false then
			vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_start, {
				undo_restore = false, invalidate = true,
				end_col = content.col_start + 1,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = { { conf.text, set_hl(conf.hl) } }
			});
		end
	elseif is_ordered == false then
		vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_start, {
			undo_restore = false, invalidate = true,
			end_col = content.col_start + 1,
			conceal = "",

			virt_text_pos = "inline",
			virt_text = { { conf.text, set_hl(conf.hl) } }
		});
	end
end

typst.raw = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_start, {
		undo_restore = false, invalidate = true,
		virt_text_pos = "inline",
		hl_mode = "combine",
		end_col = content.col_start + 1,
		conceal = "",

		virt_text = {
			{ user_config.corner_left or "", set_hl(user_config.corner_left_hl) or set_hl(user_config.hl) },
			{ user_config.padding_left or "", set_hl(user_config.padding_left_hl) or set_hl(user_config.hl) },
			{ user_config.icon or "", set_hl(user_config.icon_hl) or set_hl(user_config.hl) }
		},
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_start, {
		end_col = content.col_end,
		hl_group = set_hl(user_config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_end - 1, {
		undo_restore = false, invalidate = true,
		virt_text_pos = "inline",
		hl_mode = "combine",
		end_col = content.col_end,
		conceal = "",

		virt_text = {
			{ user_config.corner_right or "", set_hl(user_config.corner_right_hl) or set_hl(user_config.hl) },
			{ user_config.padding_right or "", set_hl(user_config.padding_right_hl) or set_hl(user_config.hl) },
		},
	});
end

typst.math = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_start, {
		undo_restore = false, invalidate = true,
		virt_text_pos = "inline",
		hl_mode = "combine",
		end_col = content.col_start + 1,
		conceal = "",

		virt_text = {
			{ user_config.corner_left or "", set_hl(user_config.corner_left_hl) or set_hl(user_config.hl) },
			{ user_config.padding_left or "", set_hl(user_config.padding_left_hl) or set_hl(user_config.hl) },
			{ user_config.icon or "", set_hl(user_config.icon_hl) or set_hl(user_config.hl) }
		},
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_start, {
		end_col = content.col_end,
		hl_group = set_hl(user_config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_end - 1, {
		undo_restore = false, invalidate = true,
		virt_text_pos = "inline",
		hl_mode = "combine",
		end_col = content.col_end,
		conceal = "",

		virt_text = {
			{ user_config.corner_right or "", set_hl(user_config.corner_right_hl) or set_hl(user_config.hl) },
			{ user_config.padding_right or "", set_hl(user_config.padding_right_hl) or set_hl(user_config.hl) },
		},
	});
end

typst.strong = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_start, {
		end_col = content.col_start + 1,
		conceal = ""
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_end - 1, {
		end_col = content.col_end,
		conceal = ""
	});
end

typst.emphasis = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_start, {
		end_col = content.col_start + 1,
		conceal = ""
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_end - 1, {
		end_col = content.col_end,
		conceal = ""
	});
end

typst.label = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_start, {
		end_col = content.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = { { user_config.text, set_hl(user_config.hl) } }
	});
end

typst.ref = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_start, {
		end_col = content.col_start + 1,
		conceal = ""
	});
end

typst.term = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_start, {
		end_col = content.col_start + 2,
		conceal = ""
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.namespace, content.row_start, content.col_start, {
		end_col = content.col_start + 2 + #content.term,
		hl_group = set_hl(user_config.hl)
	});
end

typst.render = function (render_type, buffer, content, config_table)
	if not config_table or not config_table.typst then
		return;
	elseif config_table.typst and config_table.typst.enable == false then
		return;
	end

	local conf = config_table.typst;

	if render_type == "typst_heading" then
		pcall(typst.headings, buffer, content, conf.headings)
	elseif render_type == "typst_escaped" then
		pcall(typst.escaped, buffer, content, conf.headings)
	elseif render_type == "typst_list_item" then
		pcall(typst.list_items, buffer, content, conf.list_items)
	elseif render_type == "typst_raw" then
		pcall(typst.raw, buffer, content, conf.raw)
	elseif render_type == "typst_math" then
		pcall(typst.math, buffer, content, conf.raw)
	elseif render_type == "typst_strong" then
		pcall(typst.strong, buffer, content, conf.raw)
	elseif render_type == "typst_emphasis" then
		pcall(typst.emphasis, buffer, content, conf.raw)
	elseif render_type == "typst_label" then
		typst.label(buffer, content, conf.labels)
	elseif render_type == "typst_ref" then
		pcall(typst.ref, buffer, content, conf.raw)
	elseif render_type == "typst_term" then
		typst.term(buffer, content, conf.terms)
	end
end

return typst;
