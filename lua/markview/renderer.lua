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

renderer.namespace = vim.api.nvim_create_namespace("markview");

renderer.config = {
	headers = {
		{
			mode = "icon_padding",

			padding_config = {
				virt_text = " ",
				virt_text_hl = "markview_h1",

				bg = "markview_h1_icon",
				sign = "󰌕 ", sign_hl = "rainbow1"
			},
			icon_config = {
				icon = "󰼏 ",
				icon_hl = "markview_h1_icon",
			},
		},
		{
			mode = "icon_padding",

			padding_config = {
				virt_text = " ",
				virt_text_hl = "markview_h2",

				bg = "markview_h2_icon",
				sign = "󰌕 ", sign_hl = "rainbow2"
			},
			icon_config = {
				icon = "󰎨 ",
				icon_hl = "markview_h2_icon",
			},
		},
		{
			mode = "icon_padding",

			padding_config = {
				virt_text = " ",
				virt_text_hl = "markview_h3",

				bg = "markview_h3_icon",
				sign = "󰌕 ", sign_hl = "rainbow3"
			},
			icon_config = {
				icon = "󰼑 ",
				icon_hl = "markview_h3_icon",
			},
		},
		{
			mode = "icon_padding",

			padding_config = {
				virt_text = " ",
				virt_text_hl = "markview_h4",

				bg = "markview_h4_icon",
				sign = "󰌕 ", sign_hl = "rainbow4"
			},
			icon_config = {
				icon = "󰎲 ",
				icon_hl = "markview_h4_icon",
			},
		},
		{
			mode = "icon_padding",

			padding_config = {
				virt_text = " ",
				virt_text_hl = "markview_h5",

				bg = "markview_h5_icon",
				sign = "󰌕 ", sign_hl = "rainbow5"
			},
			icon_config = {
				icon = "󰼓 ",
				icon_hl = "markview_h5_icon",
			},
		},
		{
			mode = "icon_padding",

			padding_config = {
				virt_text = " ",
				virt_text_hl = "markview_h6",

				bg = "markview_h6_icon",
				sign = "󰌕 ", sign_hl = "rainbow6"
			},
			icon_config = {
				icon = "󰎴 ",
				icon_hl = "markview_h6_icon",
			},
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
		mode = "decorated",
		block_bg = "code_block",

		top_border = {
			language = true, language_hl = "Bold",

			priority = 8,
			char = nil, char_hl = "code_block_border",

			sign = true
		},

		padding = {
			hl = "code_block",
			char = " "
		}
	},

	block_quote = {
		normal = {
			border = "▋", border_hl = { "Glow_0", "Glow_1", "Glow_2", "Glow_3", "Glow_4", "Glow_5", "Glow_6", "Glow_7" }
		},

		callouts = {
			{
				callout_string = "[!NOTE]",
				callout = " Note",
				callout_hl = "rainbow5",

				border = "▋ ", border_hl = "rainbow5"
			},
			{
				callout_string = "[!TIP]",
				callout = " Tip",
				callout_hl = "rainbow4",

				border = "▋ ", border_hl = "rainbow4"
			},
			{
				callout_string = "[!CUSTOM]",
				callout = "󰠳 Custom",
				callout_hl = "rainbow3",

				border = "▋ ", border_hl = "rainbow3"
			}
		}
	}
}

renderer.views = {};

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
			local level = #extmark.capture_text or 1;
			local header_config = tbl_clamp(renderer.config.headers, level);

			local icon_width = vim.fn.strchars(header_config.icon_config.icon);

			if header_config.mode == "icon_padding" then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, extmark.row_start, extmark.col_start + icon_width, {
					virt_text_pos = "inline",
					virt_text = {
						{ header_config.padding_config.virt_text, header_config.padding_config.virt_text_hl }
					},

					priority = 8,
					sign_text = header_config.padding_config.sign, sign_hl_group = header_config.padding_config.sign_hl,
					line_hl_group = header_config.padding_config.bg
				});
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, extmark.row_start, extmark.col_start, {
					virt_text_pos = "overlay",
					virt_text = {
						{ string.rep(" ", level - 1) .. header_config.icon_config.icon, header_config.icon_config.icon_hl }
					},

					priority = 8,
					line_hl_group = header_config.icon_config.bg
				});
			elseif header_config.mode == "icon" then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, extmark.row_start, extmark.col_start, {
					virt_text_pos = "overlay",
					virt_text = {
						{ string.rep(" ", level - 1) .. header_config.icon_config.icon .. string.rep(" ", level - icon_width), header_config.icon_config.icon_hl }
					},

					priority = 8,
					sign_text = header_config.icon_config.sign, sign_hl_group = header_config.icon_config.sign_hl,
					cursorline_hl_group = header_config.icon_config.bg
				});
			end
		elseif extmark.type == "code_block" then
			local code_block_config = renderer.config.code_block;

			if code_block_config.mode == "simple" then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, extmark.row_start, extmark.col_start, {
					virt_text_pos = "overlay",
					virt_text = {
						{ string.rep(" ", 3 + vim.fn.strchars(extmark.language)), code_block_config.block_bg }
					},

					priority = 8,
					end_row = extmark.row_end - 1,
					line_hl_group = code_block_config.block_bg
				});

				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, extmark.row_end - 1, extmark.col_start, {
					virt_text_pos = "overlay",
					virt_text = {
						{ string.rep(" ", 3 + vim.fn.strchars(extmark.language)), code_block_config.block_bg }
					},
				});
			elseif code_block_config.mode == "decorated" then
				local icon, hl = devicons.get_icon(nil, extmark.language, { default = true });
				local used_width = 1;
				local border = "";

				if code_block_config.top_border.language == true then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, extmark.row_start, extmark.col_start, {
						virt_text_pos = "overlay",
						virt_text = {
							{ icon ~= nil and icon .. " " or "Hi", hl or "" }
						},

						priority = 8,
						line_hl_group = code_block_config.block_bg
					});

					used_width = used_width + vim.fn.strchars(icon);

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, extmark.row_start, extmark.col_start + used_width, {
						virt_text_pos = "overlay",
						virt_text = {
							{ extmark.language ~= nil and extmark.language .. " " or "", code_block_config.top_border.language_hl or "Normal" }
						},

						priority = 8,
						line_hl_group = code_block_config.block_bg
					});

					used_width = used_width + vim.fn.strchars(extmark.language) + 1;
				end

				if type(code_block_config.top_border.char) == "string" then
					border = border .. string.rep(code_block_config.top_border.char, vim.o.columns - used_width - 1)
				end

				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, extmark.row_start, extmark.col_start + used_width, {
					virt_text_pos = "overlay",
					virt_text = {
						{ border, code_block_config.top_border.char_hl }
					},

					sign_text = (code_block_config.top_border.sign == true and icon ~= nil) and icon or nil, sign_hl_group = (code_block_config.top_border.sign == true and hl ~= nil) and hl or nil,

					priority = 8,
					end_row = extmark.row_end - 1,
					line_hl_group = code_block_config.block_bg
				});

				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, extmark.row_end - 1, extmark.col_start, {
					virt_text_pos = "overlay",
					virt_text = {
						{ string.rep(" ", 3 + vim.fn.strchars(extmark.language)), code_block_config.block_bg }
					},
				});

				if code_block_config.padding ~= nil then
					for l = 1, (extmark.row_end - extmark.row_start - 2) do
						vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, extmark.row_start + l, extmark.col_start, {
							virt_text_pos = "inline",
							virt_text = {
								{ code_block_config.padding.char, code_block_config.padding.hl }
							},
							priority = 8,
						});
					end

				end
			end
		elseif extmark.type == "block_quote" then
			local block_config;

			if extmark.callout ~= nil then
				for _, callout in ipairs(renderer.config.block_quote.callouts) do
					if callout.callout_string ==  extmark.callout then
						block_config = callout;
					end
				end

				if block_config == nil then
					block_config = renderer.config.block_quote.normal;
				end
			else
				block_config = renderer.config.block_quote.normal;
			end

			for b = 1, (extmark.row_end - extmark.row_start) do
				local border = tbl_clamp(block_config.border, b);
				local border_hl = tbl_clamp(block_config.border_hl, b);

				if block_config.callout ~= nil and b == 1 then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, extmark.row_start + (b - 1), extmark.col_start, {
						virt_text_pos = "overlay",
						virt_text = {
							{ border, border_hl },
							{ block_config.callout, block_config.callout_hl }
						}
					});
				else
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, extmark.row_start + (b - 1), extmark.col_start, {
						virt_text_pos = "overlay",
						virt_text = { { border, border_hl } }
					});
				end
			end
			-- vim.print(block_config)
			-- vim.print(extmark.row_end - extmark.row_start)
		end

		::extmark_skipped::
	end
end

renderer.clear = function (buffer)
	vim.api.nvim_buf_clear_namespace(buffer, renderer.namespace, 0, -1)
end

return renderer;
