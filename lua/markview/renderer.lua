local renderer = {};
local devicons = require("nvim-web-devicons");

--- Returns a value with the specified inddx from entry
--- If index is nil then return the last value
--- If entry isn't a table then return it
---
---@param entry any
---@param index number
---@return any
local tbl_clamp = function (entry, index)
	if type(entry) ~= "table" then
		return entry;
	end

	if index <= #entry then
		return entry[index];
	end

	return entry[#entry];
end

local list_shift = function (tbl)
	local tmp = table.remove(tbl, 1);
	table.insert(tbl, tmp)

	return tbl;
end

--- Used internally for making custom horizontal rules
---
---@param str string
---@param width number
---@return string
local str_rep = function (str, width)
	if vim.fn.strchars(str) == 1 then
		return string.rep(str, width);
	end

	local str_len = vim.fn.strchars(str);
	local will_fit = math.floor(width / str_len);

	return string.rep(str, will_fit) .. string.sub(str, 1, width - (will_fit * str_len));
end

--- Used internally to add extra spacing to the tezxt
---
---@param text string
---@return number
local concealed_chars = function (text)
	local _o = 0;

	for _ in text:gmatch("%b**") do
		_o = _o + 2;
	end

	for _ in text:gmatch("%b__") do
		_o = _o + 2;
	end

	for _ in text:gmatch("%*%*%[(.-)%]%*%*") do
		_o = _o + 2;
	end

	return _o;
end

renderer.namespace = vim.api.nvim_create_namespace("markview");

renderer.add_hls = function (usr_hls)
	local hl_list = usr_hls or renderer.hls;

	for _, tbl in ipairs(hl_list) do
		vim.api.nvim_set_hl(0, tbl.group_name, tbl.value)
	end
end

renderer.hls = {
	{
		group_name = "markview_red",
		value = { bg = "#453244", fg = "#f38ba8" }
	},
	{
		group_name = "markview_red_fg",
		value = { fg = "#f38ba8" }
	},

	{
		group_name = "markview_orange",
		value = { bg = "#46393E", fg = "#fab387" }
	},
	{
		group_name = "markview_orange_fg",
		value = { fg = "#fab387" }
	},

	{
		group_name = "markview_yellow",
		value = { bg = "#464245", fg = "#f9e2af" }
	},
	{
		group_name = "markview_yellow_fg",
		value = { fg = "#f9e2af" }
	},

	{
		group_name = "markview_green",
		value = { bg = "#374243", fg = "#a6e3a1" }
	},
	{
		group_name = "markview_green_fg",
		value = { fg = "#a6e3a1" }
	},

	{
		group_name = "markview_blue",
		value = { bg = "#2E3D51", fg = "#74c7ec" }
	},
	{
		group_name = "markview_blue_fg",
		value = { fg = "#74c7ec" }
	},

	{
		group_name = "markview_mauve",
		value = { bg = "#393B54", fg = "#b4befe" }
	},
	{
		type = "normal",
		group_name = "markview_mauve_fg",
		value = { fg = "#b4befe" }
	},
	{
		group_name = "markview_grey",
		value = { bg = "#7E839A", fg = "#313244" }
	},
	{
		group_name = "markview_grey_fg",
		value = { fg = "#7E839A" }
	},

	{
		group_name = "code_block",
		value = { bg = "#181825" }
	},
	{
		group_name = "code_block_border",
		value = { bg = "#181825", fg = "#1e1e2e" }
	},
	{
		group_name = "inline_code_block",
		value = { bg = "#303030", fg = "#B4BEFE" }
	},
};

renderer.config = {
	modes = { "n" },
	header = {
		{
			style = "simple",
			line_hl = "markview_red",

			sign = "󰌕 ", sign_hl = "markview_red_fg",

			icon = "󰼏 ", icon_width = 1,
			icon_hl = "markview_red",
		},
		{
			style = "padded_icon",

			sign = "󰌖 ", sign_hl = "markview_orange_fg",

			icon = "󰎨 ", icon_width = 1,
			icon_hl = "markview_orange",
		},
		{
			style = "padded_icon",
			line_hl = "markview_yellow",

			icon = "󰼑 ", icon_width = 1,
			icon_hl = "markview_yellow",
		},
		{
			style = "padded_icon",
			line_hl = "markview_green",

			icon = "󰎲 ", icon_width = 1,
			icon_hl = "markview_green",
		},
		{
			style = "padded_icon",
			line_hl = "markview_blue",

			icon = "󰼓 ", icon_width = 1,
			icon_hl = "markview_blue",
		},
		{
			style = "padded_icon",
			line_hl = "markview_mauve",

			icon = "󰎴 ", icon_width = 1,
			icon_hl = "markview_mauve",
		}
	},

	code_block = {
		style = "language",
		block_hl = "code_block",

		padding = " ",
		minimum_width = 75,

		top_border = {
			language = true, language_hl = "Bold",

			sign = true, sign_hl = nil
		},
	},

	inline_code = {
		before = " ",
		after = " ",

		hl = "inline_code_block"
	},

	block_quote = {
		default = {
			border = "▋", border_hl = { "Glow_0", "Glow_1", "Glow_2", "Glow_3", "Glow_4", "Glow_5", "Glow_6", "Glow_7" }
		},

		callouts = {
			--- From `Obsidian`
			{
				match_string = "ABSTRACT",
				callout_preview = "󱉫 Abstract",
				callout_preview_hl = "markview_blue_fg",

				custom_title = true,
				custom_icon = "󱉫 ",

				border = "▋ ", border_hl = "markview_blue_fg"
			},
			{
				match_string = "TODO",
				callout_preview = " Todo",
				callout_preview_hl = "markview_blue_fg",

				custom_title = true,
				custom_icon = " ",

				border = "▋ ", border_hl = "markview_blue_fg"
			},
			{
				match_string = "SUCCESS",
				callout_preview = "󰗠 Success",
				callout_preview_hl = "markview_green_fg",

				custom_title = true,
				custom_icon = "󰗠 ",

				border = "▋ ", border_hl = "markview_green_fg"
			},
			{
				match_string = "QUESTION",
				callout_preview = "󰋗 Question",
				callout_preview_hl = "markview_orange_fg",

				custom_title = true,
				custom_icon = "󰋗 ",

				border = "▋ ", border_hl = "markview_orange_fg"
			},
			{
				match_string = "FAILURE",
				callout_preview = "󰅙 Failure",
				callout_preview_hl = "markview_red_fg",

				custom_title = true,
				custom_icon = "󰅙 ",

				border = "▋ ", border_hl = "markview_red_fg"
			},
			{
				match_string = "DANGER",
				callout_preview = " Danger",
				callout_preview_hl = "markview_red_fg",

				custom_title = true,
				custom_icon = "  ",

				border = "▋ ", border_hl = "markview_red_fg"
			},
			{
				match_string = "BUG",
				callout_preview = " Bug",
				callout_preview_hl = "markview_red_fg",

				custom_title = true,
				custom_icon = "  ",

				border = "▋ ", border_hl = "markview_red_fg"
			},
			{
				match_string = "EXAMPLE",
				callout_preview = "󱖫 Example",
				callout_preview_hl = "markview_mauve_fg",

				custom_title = true,
				custom_icon = " 󱖫 ",

				border = "▋ ", border_hl = "markview_mauve_fg"
			},
			{
				match_string = "QUOTE",
				callout_preview = " Quote",
				callout_preview_hl = "markview_grey_fg",

				custom_title = true,
				custom_icon = "  ",

				border = "▋ ", border_hl = "markview_grey_fg"
			},


			{
				match_string = "NOTE",
				callout_preview = "󰋽 Note",
				callout_preview_hl = "markview_blue_fg",

				border = "▋ ", border_hl = "markview_blue_fg"
			},
			{
				match_string = "TIP",
				callout_preview = " Tip",
				callout_preview_hl = "markview_green_fg",

				border = "▋ ", border_hl = "markview_green_fg"
			},
			{
				match_string = "IMPORTANT",
				callout_preview = " Important",
				callout_preview_hl = "markview_yellow_fg",

				border = "▋ ", border_hl = "markview_yellow_fg"
			},
			{
				match_string = "WARNING",
				callout_preview = " Warning",
				callout_preview_hl = "markview_orange_fg",

				border = "▋ ", border_hl = "markview_orange_fg"
			},
			{
				match_string = "CAUTION",
				callout_preview = "󰳦 Caution",
				callout_preview_hl = "rainbow1",

				border = "▋ ", border_hl = "rainbow1"
			},
			{
				match_string = "[!CUSTOM]",
				callout_preview = " 󰠳 Custom",
				callout_preview_hl = "rainbow3",

				custom_title = true,
				custom_icon = " 󰠳 ",

				border = "▋", border_hl = "rainbow3"
			}
		}
	},

	horizontal_rule = {
		style = "simple",
		border_char = "─",
		border_hl = "Comment",

		-- segments = {};
	},

	hyperlink = {
		icon = " ",
		hl = "Label"
	},

	image = {
		icon = " ",
		hl = "Label"
	},

	table = {
		remove_chars = {},
		table_chars = {
			"╭", "─", "╮", "┬",
			"├", "│", "┤", "┼",
			"╰", "─", "╯", "┴",

			"╼", "╾", "╴", "╶"
		},
		table_hls = {
			"rainbow1", "rainbow1", "rainbow1", "rainbow1",
			"rainbow1", "rainbow1", "rainbow1", "rainbow1",
			"rainbow1", "rainbow1", "rainbow1", "rainbow1",

			"rainbow1", "rainbow1", "rainbow1", "rainbow1"
		},

		use_virt_lines = false,
	},

	list_item = {
		marker_plus = {
			add_padding = true,

			marker = "•",
			marker_hl = "rainbow2"
		},
		marker_minus = {
			add_padding = true,

			marker = "•",
			marker_hl = "rainbow4"
		},
		marker_star = {
			add_padding = true,

			marker = "•",
			marker_hl = "rainbow2"
		},
		marker_dot = {
			add_padding = true
		},
	},

	checkbox = {
		checked = {
			marker = " ✔ ", marker_hl = "rainbow2"
		},
		uncheked = {
			marker = " ✘ ", marker_hl = "@markup.list.unchecked"
		}
	}
}

renderer.views = {};


renderer.render_header = function (buffer, component)
	local header_config = tbl_clamp(renderer.config.header, component.level);

	if header_config.style == "simple" then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			line_hl_group = header_config.line_hl,

			priority = 8,

			sign_text = header_config.sign,
			sign_hl_group = header_config.sign_hl,
		});
	elseif header_config.style == "icon" then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			line_hl_group = header_config.line_hl,

			priority = 8,

			sign_text = header_config.sign,
			sign_hl_group = header_config.sign_hl,

			virt_text_pos = "overlay",
			virt_text = {
				{ string.rep(header_config.pad_char or " ", component.level - 1), header_config.pad_hl or header_config.icon_hl },
				{ header_config.icon, header_config.icon_hl }
			}
		});
	elseif header_config.style == "padded_icon" then
		local icon_width = header_config.icon_width or vim.fn.strchars(header_config.icon);
		local column_start = component.col_start + component.level + vim.fn.strchars(header_config.icon) - 1 > component.col_end and component.col_end or component.col_start + component.level + vim.fn.strchars(header_config.icon) - 1;

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, column_start, {
			virt_text_pos = "inline",
			virt_text = {
				{ header_config.pad_char or " ", header_config.pad_hl or header_config.icon_hl },
			}
		});

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			line_hl_group = header_config.line_hl,

			priority = 8,

			sign_text = header_config.sign,
			sign_hl_group = header_config.sign_hl,

			virt_text_pos = "overlay",
			virt_text = {
				{ string.rep(header_config.pad_char or " ", component.col_start + component.level - icon_width < 0 and 0 or component.col_start + component.level - icon_width ), header_config.pad_hl or header_config.icon_hl },
				{ header_config.icon, header_config.icon_hl }
			}
		});
	end
end

renderer.render_code_block = function (buffer, component)
	local block_config = renderer.config.code_block;

	if type(block_config.minimum_width) == "number" and block_config.minimum_width > component.largest_line then
		component.largest_line = block_config.minimum_width
	end

	if block_config.style == "simple" then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ string.rep( block_config.pad_char or " ", 3 + vim.fn.strchars(component.language)), block_config.block_hl }
			}
		});

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + 1, component.col_start, {
			end_row = component.row_end - 2,
			end_col = component.col_end,

			line_hl_group = block_config.block_hl
		});

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_end - 1, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ string.rep( block_config.pad_char or " ", 3 + vim.fn.strchars(component.language)), block_config.block_hl }
			},

			line_hl_group = block_config.block_hl
		});
	elseif block_config.style == "padded" then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ string.rep(component.pad_char or " ", component.largest_line + 2), block_config.block_hl },
			}
		});

		for line, length in ipairs(component.line_lengths) do
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + line, component.col_start > length and length or component.col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ block_config.pad_char or " ", block_config.block_hl }
				}
			});

			vim.api.nvim_buf_add_highlight(buffer, renderer.namespace, block_config.block_hl, component.row_start + line, component.col_start, -1);

			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + line, -1, {
				virt_text_pos = "overlay",
				virt_text = {
					{ string.rep(block_config.pad_char or " ", component.largest_line - length + 1), block_config.block_hl }
				}
			});
		end

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_end - 1, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ string.rep(component.pad_char or " ", component.largest_line + 2), block_config.block_hl }
			}
		});
	elseif block_config.style == "language" then
		local icon, hl = devicons.get_icon(nil, component.language, { default = true });
		local pad_len = 3 - vim.fn.strchars(icon .. " ");

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "inline",
			virt_text = {
				{ block_config.pad_char ~= nil and icon .. block_config.pad_char or icon .. " ", hl },
				{ component.language, block_config.language_hl or hl },
				{ string.rep(block_config.pad_char or " ", pad_len) },
				{ string.rep(component.pad_char or " ", component.largest_line - vim.fn.strchars(icon .. component.language) - component.col_start), block_config.block_hl }
			},

			sign_text = block_config.top_border ~= nil and block_config.top_border.sign == true and icon or nil,
			sign_hl_group = block_config.top_border ~= nil and block_config.top_border.sign_hl ~= nil and block_config.top_border.sign_hl or hl,

			end_col = vim.fn.strchars(component.language) + 3,
			conceal = ""
		});

		for line, length in ipairs(component.line_lengths) do
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + line, component.col_start > length and length or component.col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ block_config.pad_char or " ", block_config.block_hl }
				}
			});

			vim.api.nvim_buf_add_highlight(buffer, renderer.namespace, block_config.block_hl, component.row_start + line, component.col_start, -1);

			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + line, - 1, {
				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(block_config.pad_char or " ", component.largest_line - length + 1), block_config.block_hl }
				},
			});
		end

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_end - 1, component.col_start, {
			virt_text_pos = "inline",
			virt_text = {
				{ string.rep( block_config.pad_char or " ", 3), block_config.block_hl },
				{ string.rep(component.pad_char or " ", component.largest_line - 1 - component.col_start), block_config.block_hl }
			},

			end_col = component.col_end,
			conceal = ""
		});
	end
end

renderer.render_block_quote = function (buffer, component)
	local quote_config;

	if component.callout ~= nil then
		for _, callout in ipairs(renderer.config.block_quote.callouts) do
			if type(callout.match_string) == "string" and callout.match_string:upper() == component.callout:upper() then
				quote_config = callout;

				break;
			end
		end

		if quote_config == nil then
			quote_config = renderer.config.block_quote.default;
		end
	else
		quote_config = renderer.config.block_quote.default;
	end

	if quote_config.custom_title == true and component.title ~= "" then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "inline",
			virt_text = {
				{ tbl_clamp(quote_config.border, 1), tbl_clamp(quote_config.border_hl, 1) },
				{ quote_config.custom_icon, quote_config.callout_preview_hl },
				{ component.title, quote_config.callout_preview_hl },
			},

			end_row = component.row_start, end_col = component.line_width,

			conceal = "",
			hl_mode = "combine"
		});
	elseif quote_config.callout_preview ~= nil then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "inline",
			virt_text = {
				{ tbl_clamp(quote_config.border, 1), tbl_clamp(quote_config.border_hl, 1) },
				{ quote_config.callout_preview, quote_config.callout_preview_hl },
			},

			end_row = component.row_start, end_col = component.line_width,

			conceal = "",
			hl_mode = "combine"
		});
	else
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "inline",
			virt_text = {
				{ tbl_clamp(quote_config.border, 1), tbl_clamp(quote_config.border_hl, 1) },
			},

			end_row = component.row_start, end_col = vim.fn.strchars(tbl_clamp(quote_config.border, 1)) + component.col_end,

			conceal = "",
			hl_mode = "combine"
		});
	end

	for line = 1, component.row_end - component.row_start - 1 do
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + line, component.col_start, {
			virt_text_pos = "inline",
			virt_text = {
				{ tbl_clamp(quote_config.border, line + 1), tbl_clamp(quote_config.border_hl, line + 1) }
			},

			end_row = component.row_start + line, end_col = vim.fn.strchars(tbl_clamp(quote_config.border, 1)) + component.col_end,

			conceal = "",
			hl_mode = "combine"
		});
	end
end

renderer.render_horizontal_rule = function (buffer, component)
	local hr_config = renderer.config.horizontal_rule;
	local columns = vim.o.columns;

	if hr_config.style == "simple" then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ str_rep(hr_config.border_char, columns), hr_config.border_hl },
			},

			hl_mode = "combine"
		});
	elseif hr_config.style == "fancy" then
		local seg_left = hr_config.segments ~= nil and hr_config.segments[1] or "─";
		local seg_mid = hr_config.segments ~= nil and hr_config.segments[2] or "   ";
		local seg_right = hr_config.segments ~= nil and hr_config.segments[3] or "─";

		local side_width_l = math.floor((columns - vim.fn.strchars(seg_mid)) / 2);
		local side_width_r = math.ceil((columns - vim.fn.strchars(seg_mid)) / 2);

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ str_rep(seg_left, side_width_l), hr_config.segments_hl ~= nil and hr_config.segments_hl[1] or hr_config.border_hl },
				{ seg_mid, hr_config.segments_hl ~= nil and hr_config.segments_hl[2] or hr_config.border_hl },
				{ str_rep(seg_right, side_width_r), hr_config.segments_hl ~= nil and hr_config.segments_hl[3] or hr_config.border_hl },
			},

			hl_mode = "combine"
		});
	end
end

renderer.render_hyperlink = function (buffer, component)
	local link_config = renderer.config.hyperlink;

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
		virt_text_pos = "inline",

		virt_text = {
			{ link_config.icon ~= nil and link_config.icon .. component.link_text or component.link_text, link_config.hl }
		},

		conceal = "",

		end_row = component.row_end,
		end_col = component.col_end
	})
end

renderer.render_img_link = function (buffer, component)
	local link_config = renderer.config.image;

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
		virt_text_pos = "inline",

		virt_text = {
			{ link_config.icon ~= nil and link_config.icon .. component.link_text or component.link_text, link_config.hl }
		},

		conceal = "",

		end_row = component.row_end,
		end_col = component.col_end
	})
end

renderer.render_inline_code = function (buffer, component)
	local inl_config = renderer.config.inline_code;

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
		virt_text_pos = "inline",

		virt_text = {
			{ inl_config.before, inl_config.hl },
			{ component.text, inl_config.hl },
			{ inl_config.after, inl_config.hl },
		},

		end_row = component.row_end,
		end_col = component.col_end
	})
end

renderer.render_table = function (buffer, component)
	local table_config = renderer.config.table;
	local column_text_alignment = {};

	for r_index, row in ipairs(component.rows) do
		local char_index = 0;
		local virt_line = {};

		local r_prev = r_index == 1 and 1 or r_index - 1;

		for cell_num, col in ipairs(row) do
			char_index = char_index + vim.fn.strchars(col);


			if r_index == 1 and col == "|" then
				if cell_num == 1 then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - 1), {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[6], table_config.table_hls[6] }
						}
					})

					table.insert(virt_line, { table_config.table_chars[1], table_config.table_hls[1] })
				elseif cell_num == #row then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - 1), {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[6], table_config.table_hls[6] }
						}
					})

					table.insert(virt_line, { table_config.table_chars[3], table_config.table_hls[3] })

					if component.row_start + (r_index - 2) < 0 then
						goto cell_skip;
					end

					if table_config.use_virt_lines == true then
						vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - 1), {
							virt_lines_above = true,
							virt_lines = { virt_line },

							hl_mode = "combine"
						})
					else
						vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 2), 0, {
							virt_text_pos = "overlay",
							virt_text = virt_line,

							hl_mode = "combine"
						})
					end

				else
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - 1), {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[6], table_config.table_hls[6] }
						}
					})

					table.insert(virt_line, { table_config.table_chars[4], table_config.table_hls[4] })
				end
				-- Clear
			elseif r_index == 1 and col:match("^[%s%-]*$") == nil then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - 1), {
					virt_text_pos = "inline",
					virt_text = {
						{ string.rep(" ", concealed_chars(col)) }
					}
				})

				table.insert(virt_line, { string.rep(table_config.table_chars[2], vim.fn.strchars(col)), table_config.table_hls[2] })
				-- Clear
			elseif r_index == #component.rows and col == "|" then
				if cell_num == 1 then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - 1), {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[6], table_config.table_hls[6] }
						}
					})

					table.insert(virt_line, { table_config.table_chars[9], table_config.table_hls[9] })
				elseif cell_num == #row then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - 1), {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[6], table_config.table_hls[6] }
						}
					})

					table.insert(virt_line, { table_config.table_chars[11], table_config.table_hls[11] })

					if table_config.use_virt_lines == true then
						vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - 1), {
							virt_lines_above = false,
							virt_lines = { virt_line },

							hl_mode = "combine"
						})
					else
						vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + r_index, 0, {
							virt_text_pos = "overlay",
							virt_text = virt_line,

							hl_mode = "combine"
						})
					end

				else
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - 1), {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[6], table_config.table_hls[6] }
						}
					})

					table.insert(virt_line, { table_config.table_chars[12], table_config.table_hls[12] })
				end
			elseif r_index == #component.rows and col:match("^[%s%-]*$") == nil then
				-- vim.print(column_text_alignment)

				if column_text_alignment[1] == "left" or column_text_alignment[1] == nil then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - 1), {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", concealed_chars(col)) }
						}
					})
				elseif column_text_alignment[1] == "center"  then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - 1), {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", math.floor(concealed_chars(col) / 2)) }
						}
					})
				end

				table.insert(virt_line, { string.rep(table_config.table_chars[10], vim.fn.strchars(col)), table_config.table_hls[10] })

				if column_text_alignment[1] == "right" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - vim.fn.strchars(col)), {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", concealed_chars(col)) }
						}
					})
				elseif column_text_alignment[1] == "center" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - vim.fn.strchars(col)), {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", math.ceil(concealed_chars(col) / 2)) }
						}
					})
				end

				column_text_alignment = list_shift(column_text_alignment)
				-- Clear
			elseif col == "|" and component.table_structure[r_index] == "seperator" then
				if cell_num == 1 then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - 1), {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[5], table_config.table_hls[5] }
						}
					})
				elseif cell_num == #row then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - 1), {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[7], table_config.table_hls[7] }
						}
					})
				else
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - 1), {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[8], table_config.table_hls[8] }
						}
					})
				end
			elseif col == "|" then
				if cell_num == 1 then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - 1), {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[6], table_config.table_hls[6] }
						}
					})
				elseif cell_num == #row then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - 1), {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[6], table_config.table_hls[6] }
						}
					})
				else
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - 1), {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[6], table_config.table_hls[6] }
						}
					})
				end
			elseif col:match("^[%s%-]*$") and col:match("^%s*$") == nil then
				local prev_size = vim.fn.strchars(component.rows[r_prev][cell_num]);
				-- local prev_con = concealed_chars(component.rows[r_prev][cell_num]);

				-- Here
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - vim.fn.strchars(col)), {
					virt_text_pos = "overlay",
					virt_text = {
						{
							string.rep(table_config.table_chars[2], prev_size), table_config.table_hls[2]
						}
					}
				})

				table.insert(column_text_alignment, "left")
			elseif col:match("^[%s%-:]*$") and col:match("^%s*$") == nil then
				local prev_size = vim.fn.strchars(component.rows[r_prev][cell_num]);
				local prev_con = concealed_chars(component.rows[r_prev][cell_num]);

				if string.sub(col, 1, 1) == ":" and string.sub(col, -1, -1) == ":" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - vim.fn.strchars(col)), {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[15], table_config.table_hls[15] or table_config.table_hls[2] },
							{ string.rep(table_config.table_chars[2], prev_size - 2), table_config.table_hls[2] },
							{ table_config.table_chars[16], table_config.table_hls[16] or table_config.table_hls[2] },
						}
					})

					table.insert(column_text_alignment, "center")
				elseif string.sub(col, 1, 1) == ":" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - vim.fn.strchars(col)), {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[13], table_config.table_hls[13] or table_config.table_hls[2] },
							{ string.rep(table_config.table_chars[2], prev_size - 1), table_config.table_hls[2] }
						}
					})

					table.insert(column_text_alignment, "left")
				elseif string.sub(col, -1, -1) == ":" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - vim.fn.strchars(col)), {
						virt_text_pos = "overlay",
						virt_text = {
							{ string.rep(table_config.table_chars[2], prev_size - 1), table_config.table_hls[2] },
							{ table_config.table_chars[14], table_config.table_hls[14] or table_config.table_hls[2] },
						}
					})

					table.insert(column_text_alignment, "right")
				else
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index - vim.fn.strchars(col)), {
						virt_text_pos = "overlay",
						virt_text = {
							{
								string.rep(table_config.table_chars[2], prev_size + prev_con), table_config.table_hls[2]
							}
						}
					})
				end
				-- Here
			else
				local concealed_ver = string.rep(" ", concealed_chars(col));

				-- vim.print(char_index)
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + (r_index - 1), component.col_start + (char_index), {
					virt_text_pos = "inline",
					virt_text = { {concealed_ver} }
				})
			end

			::cell_skip::
		end
	end
end

renderer.render_list = function (buffer, component)
	local ls_conf = {};

	if string.match(component.marker_symbol, "-") then
		ls_conf = renderer.config.list_item.marker_minus or {};
	elseif string.match(component.marker_symbol, "+") then
		ls_conf = renderer.config.list_item.marker_plus or {};
	elseif string.match(component.marker_symbol, "*") then
		ls_conf = renderer.config.list_item.marker_star or {};
	elseif string.match(component.marker_symbol, "[.]") then
		ls_conf = renderer.config.list_item.marker_dot or {};
	end

	if ls_conf.add_padding == true then
		local shiftwidth = vim.bo[buffer].shiftwidth or 4;

		for i = 0, (component.row_end - component.row_start) - 1 do
			--- BUG: Sometimes the marker is wider then 2 characters so we add the extra spaces to align it property
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + i, 0, {
				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(" ", shiftwidth - component.col_start - (vim.fn.strchars(component.marker_symbol) - 2)) }
				},

				hl_mode = "combine"
			});
		end
	end

	if ls_conf.marker ~= nil then
		--- BUG: Sometimes the marker is wider then 2 characters so we change the position of the marker to align it property
		if vim.fn.strchars(component.marker_symbol) > 2 then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start + (vim.fn.strchars(component.marker_symbol) - 2), {
				virt_text_pos = "overlay",
				virt_text = {
					{ ls_conf.marker, ls_conf.marker_hl }
				},

				hl_mode = "combine"
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
				virt_text_pos = "overlay",
				virt_text = {
					{ ls_conf.marker, ls_conf.marker_hl }
				},

				hl_mode = "combine"
			});
		end
	end
end

renderer.render_checkbox = function (buffer, component)
	local chk_conf = renderer.config.checkbox;

	if component.checked == true then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ chk_conf.checked.marker, chk_conf.checked.marker_hl }
			},

			hl_mode = "combine"
		});
	elseif component.checked == false then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ chk_conf.uncheked.marker, chk_conf.uncheked.marker_hl }
			},

			hl_mode = "combine"
		});
	end
end

renderer.render = function (buffer)
	local view = renderer.views[buffer];

	if view == nil then
		return;
	end

	for _, extmark in ipairs(view) do
		local fold_closed = vim.fn.foldclosed(extmark.row_start + 1);

		if fold_closed ~= -1 then
			goto extmark_skipped;
		end

		if extmark.type == "header" then
			renderer.render_header(buffer, extmark);
		elseif extmark.type == "code_block" then
			renderer.render_code_block(buffer, extmark);
		elseif extmark.type == "block_quote" then
			renderer.render_block_quote(buffer, extmark);
		elseif extmark.type == "horizontal_rule" then
			renderer.render_horizontal_rule(buffer, extmark);
		elseif extmark.type == "hyperlink" then
			renderer.render_hyperlink(buffer, extmark);
		elseif extmark.type == "image" then
			renderer.render_img_link(buffer, extmark);
		elseif extmark.type == "inline_code" then
			renderer.render_inline_code(buffer, extmark);
		elseif extmark.type == "table" then
			renderer.render_table(buffer, extmark);
		elseif extmark.type == "list_item" then
			renderer.render_list(buffer, extmark)
		elseif extmark.type == "checkbox" then
			renderer.render_checkbox(buffer, extmark)
		end

		::extmark_skipped::
	end
end

renderer.clear = function (buffer)
	vim.api.nvim_buf_clear_namespace(buffer, renderer.namespace, 0, -1)
end

return renderer;
