local renderer = {};
local devicons = require("nvim-web-devicons");

local tbl_clamp = function (entry, index)
	if type(entry) ~= "table" then
		return entry;
	end

	if index <= #entry then
		return entry[index];
	end

	return entry[#entry];
end

local str_rep = function (str, width)
	if vim.fn.strchars(str) == 1 then
		return string.rep(str, width);
	end

	local str_len = vim.fn.strchars(str);
	local will_fit = math.floor(width / str_len);

	return string.rep(str, will_fit) .. string.sub(str, 1, width - (will_fit * str_len));
end

local get_text_width = function (str, remove_chars)
	if remove_chars ~= nil then
		return vim.fn.strchars(str);
	end

	local t;

	for _, char in ipairs(remove_chars) do
		t = string.gsub(t or str, char, "");
	end

	return vim.fn.strchars(t);
end

renderer.namespace = vim.api.nvim_create_namespace("markview");

renderer.config = {
	header = {
		{
			style = "padded_icon",
			line_hl = "markview_h1",

			sign = "󰌕 ", sign_hl = "rainbow1",

			icon = "󰼏 ",
			icon_hl = "markview_h1_icon",
		},
		{
			style = "padded_icon",
			line_hl = "markview_h2",

			icon = "󰎨 ",
			icon_hl = "markview_h2_icon",
		},
		{
			style = "padded_icon",
			line_hl = "markview_h3",

			icon = "󰼑 ",
			icon_hl = "markview_h3_icon",
		},
		{
			style = "padded_icon",
			line_hl = "markview_h4",

			icon = "󰎲 ",
			icon_hl = "markview_h4_icon",
		},
		{
			style = "padded_icon",
			line_hl = "markview_h5",

			icon = "󰼓 ",
			icon_hl = "markview_h5_icon",
		},
		{
			style = "padded_icon",
			line_hl = "markview_h6",

			icon = "󰎴 ",
			icon_hl = "markview_h6_icon",
		},
		-- {
		-- 	mode = "icon",
		-- 	icon_config = {
		-- 		icon = "󰼏 ",
		-- 		icon_hl = "Normal"
		-- 	},
		-- }
	},

	code_block = {
		style = "language",
		mode = "decorated",
		block_hl = "code_block",

		top_border = {
			language = true, language_hl = "Bold",

			priority = 8,
			char = nil, char_hl = "code_block_border",

			sign = true
		},

		padding = " "
	},

	inline_code = {
		before = " ",
		after = " ",

		hl = "code_block"
	},

	block_quote = {
		default = {
			border = "▋", border_hl = { "Glow_0", "Glow_1", "Glow_2", "Glow_3", "Glow_4", "Glow_5", "Glow_6", "Glow_7" }
		},

		callouts = {
			{
				match_string = "[!NOTE]",
				callout_preview = "  Note",
				callout_preview_hl = "rainbow5",

				border = "▋ ", border_hl = "rainbow5"
			},
			{
				match_string = "[!TIP]",
				callout_preview = " Tip",
				callout_preview_hl = "rainbow4",

				border = "▋ ", border_hl = "rainbow4"
			},
			{
				match_string = "[!CUSTOM]",
				callout_preview = "󰠳 Custom",
				callout_preview_hl = "rainbow3",

				border = "▋ ", border_hl = "rainbow3"
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
		remove_chars = { "`" },
		table_chars = {
			"╭", "─", "╮", "┬",
			"├", "│", "┤", "┼",
			"╰", "─", "╯", "┴"
		},
		table_hls = {
			"rainbow1",
			"rainbow1",
			"rainbow1",
			"rainbow1",
			"rainbow1",
			"rainbow1",
			"rainbow1",
			"rainbow1",
			"rainbow1",
			"rainbow1",
			"rainbow1",
			"rainbow1",
		},

		use_virt_lines = false,
	},

	list_item = {
		marker_plus = {
			add_padding = true,
			check_indent_level = true,

			marker = "•",
			marker_hl = "rainbow2"
		},
		marker_minus = {
			add_padding = true,
		},
		marker_star = {},
	},

	checkbox = {
		checked = {
			marker = " ✔ ", marker_hl = "@markup.list.checked"
		},
		uncheked = {
			marker = " ✘ ", marker_hl = "@markup.list.unchecked"
		}
	}
}

renderer.views = {};


renderer.render_header = function (buffer, component)
	local header_config = tbl_clamp(renderer.config.header, component.level);

	-- vim.print(header_config)
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
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start + component.level + vim.fn.strchars(header_config.icon) - 1, {
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
				{ string.rep(header_config.pad_char or " ", component.level - 1), header_config.pad_hl or header_config.icon_hl },
				{ header_config.icon, header_config.icon_hl }
			}
		});
	end
end

renderer.render_code_block = function (buffer, component)
	local block_config = renderer.config.code_block;

	if block_config.style == "simple" then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ string.rep( block_config.space_char or " ", 3 + vim.fn.strchars(component.language)), block_config.block_hl }
			},

			line_hl_group = block_config.block_hl
		});

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + 1, component.col_start, {
			end_row = component.row_end - 2,
			end_col = component.col_end,

			line_hl_group = block_config.block_hl
		});

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_end - 1, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ string.rep( block_config.space_char or " ", 3 + vim.fn.strchars(component.language)), block_config.block_hl }
			},

			line_hl_group = block_config.block_hl
		});
	elseif block_config.style == "padded" then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ string.rep( block_config.space_char or " ", 3 + vim.fn.strchars(component.language)), block_config.block_hl }
			},

			line_hl_group = block_config.block_hl
		});

		for line = 1, component.row_end - component.row_start - 1 do
			if component.col_start ~= 0 then
				break;
			end

			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + line, component.col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ block_config.padding or " ", block_config.block_hl }
				},

				line_hl_group = block_config.block_hl
			});
		end

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_end - 1, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ string.rep( block_config.space_char or " ", 3 + vim.fn.strchars(component.language)), block_config.block_hl }
			},

			line_hl_group = block_config.block_hl
		});
	elseif block_config.style == "language" then
		local icon, hl = devicons.get_icon(nil, component.language, { default = true });
		local pad_len = 3 - vim.fn.strchars(icon .. " ");

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ icon .. " ", hl },
				{ component.language, block_config.language_hl or hl },
				{ string.rep(" ", pad_len) }
			},

			line_hl_group = block_config.block_hl
		});

		for line = 1, component.row_end - component.row_start - 1 do
			if component.col_start ~= 0 then
				break;
			end

			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + line, component.col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ block_config.padding or " ", block_config.block_hl }
				},

				line_hl_group = block_config.block_hl
			});
		end

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_end - 1, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ string.rep( block_config.space_char or " ", 3 + vim.fn.strchars(component.language)), block_config.block_hl }
			},

			line_hl_group = block_config.block_hl
		});
	end
end

renderer.render_block_quote = function (buffer, component)
	local quote_config;

	if component.callout ~= nil then
		for _, callout in ipairs(renderer.config.block_quote.callouts) do
			if callout.match_string == component.callout then
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

	if quote_config.callout_preview ~= nil then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ tbl_clamp(quote_config.border, 1), tbl_clamp(quote_config.border_hl, 1) },
				{ quote_config.callout_preview, quote_config.callout_preview_hl }
			}
		});
	else
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ tbl_clamp(quote_config.border, 1), tbl_clamp(quote_config.border_hl, 1) },
			}
		});
	end

	for line = 1, component.row_end - component.row_start - 1 do
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + line, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ tbl_clamp(quote_config.border, line + 1), tbl_clamp(quote_config.border_hl, line + 1) }
			}
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
				{ string.rep(hr_config.border_char or "•", columns), hr_config.border_hl }
			}
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
			}
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
		virt_text_pos = "overlay",

		virt_text = {
			{ inl_config.before, inl_config.hl },
			{ component.text, inl_config.hl },
			{ inl_config.after, inl_config.hl },
		}
	})
end

renderer.render_table = function (buffer, component)
	local table_config = renderer.config.table;

	for r_index, row in ipairs(component.cells) do
		local this_row = component.table_structure[r_index];

		local current_width = component.col_start;

		if r_index == 1 then
			local virt_line = {};

			for c_index, col in ipairs(row) do
				if col == "|" and c_index == 1 then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + r_index - 1, current_width, {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[6], table_config.table_hls[6] }
						}
					});

					table.insert(virt_line, { table_config.table_chars[1], table_config.table_hls[1] })
				elseif col == "|" and c_index == #row then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + r_index - 1, current_width, {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[6], table_config.table_hls[6] }
						}
					});

					table.insert(virt_line, { table_config.table_chars[3], table_config.table_hls[3] })
				elseif col == "|" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + r_index - 1, current_width, {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[6], table_config.table_hls[6] }
						}
					});

					table.insert(virt_line, { table_config.table_chars[4], table_config.table_hls[4] })
				else
					table.insert(virt_line, { string.rep(table_config.table_chars[2], get_text_width(col, table_config.remove_chars)), table_config.table_hls[2] })
				end

				current_width = current_width + get_text_width(col, table_config.remove_chars);
			end

			if table_config.use_virt_lines == true then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + r_index - 1, 0, {
					virt_lines_above = true,
					virt_lines = {
						virt_line
					}
				});
			elseif table_config.use_virt_lines == false then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + r_index - 2, 0, {
					virt_text_pos = "overlay",
					virt_text = virt_line
				});
			end
		elseif r_index == #component.cells then
			local virt_line = {};

			for c_index, col in ipairs(row) do
				if col == "|" and c_index == 1 then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + r_index - 1, current_width, {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[6], table_config.table_hls[6] }
						}
					});

					table.insert(virt_line, { table_config.table_chars[9], table_config.table_hls[9] })
				elseif col == "|" and c_index == #row then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + r_index - 1, current_width, {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[6], table_config.table_hls[6] }
						}
					});

					table.insert(virt_line, { table_config.table_chars[11], table_config.table_hls[11] })
				elseif col == "|" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + r_index - 1, current_width, {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[6], table_config.table_hls[6] }
						}
					});

					table.insert(virt_line, { table_config.table_chars[12], table_config.table_hls[12] })
				else
					table.insert(virt_line, { string.rep(table_config.table_chars[10], get_text_width(col, table_config.remove_chars)), table_config.table_hls[10] })
				end

				current_width = current_width + get_text_width(col, table_config.remove_chars);
			end

			if table_config.use_virt_lines == true then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + r_index - 1, 0, {
					virt_lines_above = false,
					virt_lines = {
						virt_line
					}
				});
			else
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + r_index, 0, {
					virt_text_pos = "overlay",
					virt_text = virt_line
				});
			end
		elseif this_row == "seperator" then
			for c_index, col in ipairs(row) do
				if col == "|" and c_index == 1 then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + r_index - 1, current_width, {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[5], table_config.table_hls[5] }
						}
					});
				elseif col == "|" and c_index == #row then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + r_index - 1, current_width, {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[7], table_config.table_hls[7] }
						}
					});
				elseif col == "|" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + r_index - 1, current_width, {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[8], table_config.table_hls[8] }
						}
					});
				elseif string.match(col, "^%-*$") then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + r_index - 1, current_width, {
						virt_text_pos = "overlay",
						virt_text = {
							{ string.rep(table_config.table_chars[2], get_text_width(col, table_config.remove_chars)), table_config.table_hls[2] }
						}
					});
				end

				current_width = current_width + get_text_width(col, table_config.remove_chars);
			end
		elseif this_row == "content" then
			for _, col in ipairs(row) do
				if col == "|" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start + r_index - 1, current_width, {
						virt_text_pos = "overlay",
						virt_text = {
							{ table_config.table_chars[6], table_config.table_hls[6] }
						}
					});
				end

				current_width = current_width + get_text_width(col, table_config.remove_chars);
			end
		end
	end
end

renderer.render_list = function (buffer, component)
	local ls_conf = {};

	if string.match(component.marker, "-") then
		ls_conf = renderer.config.list_item.marker_minus or {};
	elseif string.match(component.marker, "+") then
		ls_conf = renderer.config.list_item.marker_plus or {};
	elseif string.match(component.marker, "*") then
		ls_conf = renderer.config.list_item.marker_star or {};
	end

	if ls_conf.add_padding == true and ls_conf.check_indent_level == true then
		local shiftwidth = vim.bo[buffer].shiftwidth or 4;

		if component.col_start == 0 then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(" ", shiftwidth) }
				}
			});
		end
	elseif ls_conf.add_padding == true then
		local shiftwidth = vim.bo[buffer].shiftwidth or 4;

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "inline",
			virt_text = {
				{ string.rep(" ", shiftwidth) }
			}
		});
	end

	if ls_conf.marker ~= nil then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ ls_conf.marker, ls_conf.marker_hl }
			}
		});
	end
end

renderer.render_checkbox = function (buffer, component)
	local chk_conf = renderer.config.checkbox;

	if component.checked == true then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ chk_conf.checked.marker, chk_conf.checked.marker_hl }
			}
		});
	elseif component.checked == false then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, component.row_start, component.col_start, {
			virt_text_pos = "overlay",
			virt_text = {
				{ chk_conf.uncheked.marker, chk_conf.uncheked.marker_hl }
			}
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
