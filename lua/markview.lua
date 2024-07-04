local markview = {};
markview.parser = require("markview/parser");
markview.renderer = require("markview/renderer");

markview.add_hls = function (usr_hls)
	local hl_list = usr_hls or renderer.hls;

	for _, tbl in ipairs(hl_list) do
		vim.api.nvim_set_hl(0, "Markview_" .. tbl.group_name, tbl.value)
	end
end

markview.global_options = {};

---@type markview.config
markview.configuration = {
	restore_conceallevel = true,
	restore_concealcursor = false,

	highlight_groups = {
		{
			group_name = "red",
			value = { bg = "#453244", fg = "#f38ba8" }
		},
		{
			group_name = "red_fg",
			value = { fg = "#f38ba8" }
		},

		{
			group_name = "orange",
			value = { bg = "#46393E", fg = "#fab387" }
		},
		{
			group_name = "orange_fg",
			value = { fg = "#fab387" }
		},

		{
			group_name = "yellow",
			value = { bg = "#464245", fg = "#f9e2af" }
		},
		{
			group_name = "yellow_fg",
			value = { fg = "#f9e2af" }
		},

		{
			group_name = "green",
			value = { bg = "#374243", fg = "#a6e3a1" }
		},
		{
			group_name = "green_fg",
			value = { fg = "#a6e3a1" }
		},

		{
			group_name = "blue",
			value = { bg = "#2E3D51", fg = "#74c7ec" }
		},
		{
			group_name = "blue_fg",
			value = { fg = "#74c7ec" }
		},

		{
			group_name = "mauve",
			value = { bg = "#393B54", fg = "#b4befe" }
		},
		{
			type = "normal",
			group_name = "mauve_fg",
			value = { fg = "#b4befe" }
		},
		{
			group_name = "grey",
			value = { bg = "#7E839A", fg = "#313244" }
		},
		{
			group_name = "grey_fg",
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
	},
	buf_ignore = { "nofile" },

	modes = { "n" },

	headings = {
		enable = true,
		shift_width = 3,

		heading_1 = {
			style = "icon",
			sign = "󰌕 ", sign_hl = "markview_red_fg",

			icon = "󰼏  ", hl = "markview_red",

		},
		heading_2 = {
			style = "icon",
			sign = "󰌖 ", sign_hl = "markview_orange_fg",

			icon = "󰎨  ", hl = "markview_orange",
		},
		heading_3 = {
			style = "icon",

			icon = "󰼑  ", hl = "markview_yellow",
		},
		heading_4 = {
			style = "icon",

			icon = "󰎲  ", hl = "markview_green",
		},
		heading_5 = {
			style = "icon",

			icon = "󰼓  ", hl = "markview_blue",
		},
		heading_6 = {
			style = "icon",

			icon = "󰎴  ", hl = "markview_mauve",
		}
	},

	code_blocks = {
		enable = true,

		style = "language",
		hl = "code_block",

		position = "overlay",

		min_width = 60,
		pad_amount = 3,

		language_names = {
			{ "py", "python" },
			{ "cpp", "C++" }
		},

		sign = true, sign_hl = nil
	},

	block_quotes = {
		enable = true,

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

				border = "▋", border_hl = "markview_blue_fg"
			},
			{
				match_string = "TODO",
				callout_preview = " Todo",
				callout_preview_hl = "markview_blue_fg",

				custom_title = true,
				custom_icon = " ",

				border = "▋", border_hl = "markview_blue_fg"
			},
			{
				match_string = "SUCCESS",
				callout_preview = "󰗠 Success",
				callout_preview_hl = "markview_green_fg",

				custom_title = true,
				custom_icon = "󰗠 ",

				border = "▋", border_hl = "markview_green_fg"
			},
			{
				match_string = "QUESTION",
				callout_preview = "󰋗 Question",
				callout_preview_hl = "markview_orange_fg",

				custom_title = true,
				custom_icon = "󰋗 ",

				border = "▋", border_hl = "markview_orange_fg"
			},
			{
				match_string = "FAILURE",
				callout_preview = "󰅙 Failure",
				callout_preview_hl = "markview_red_fg",

				custom_title = true,
				custom_icon = "󰅙 ",

				border = "▋", border_hl = "markview_red_fg"
			},
			{
				match_string = "DANGER",
				callout_preview = " Danger",
				callout_preview_hl = "markview_red_fg",

				custom_title = true,
				custom_icon = "  ",

				border = "▋", border_hl = "markview_red_fg"
			},
			{
				match_string = "BUG",
				callout_preview = " Bug",
				callout_preview_hl = "markview_red_fg",

				custom_title = true,
				custom_icon = "  ",

				border = "▋", border_hl = "markview_red_fg"
			},
			{
				match_string = "EXAMPLE",
				callout_preview = "󱖫 Example",
				callout_preview_hl = "markview_mauve_fg",

				custom_title = true,
				custom_icon = " 󱖫 ",

				border = "▋", border_hl = "markview_mauve_fg"
			},
			{
				match_string = "QUOTE",
				callout_preview = " Quote",
				callout_preview_hl = "markview_grey_fg",

				custom_title = true,
				custom_icon = "  ",

				border = "▋", border_hl = "markview_grey_fg"
			},


			{
				match_string = "NOTE",
				callout_preview = "󰋽 Note",
				callout_preview_hl = "markview_blue_fg",

				border = "▋", border_hl = "markview_blue_fg"
			},
			{
				match_string = "TIP",
				callout_preview = " Tip",
				callout_preview_hl = "markview_green_fg",

				border = "▋", border_hl = "markview_green_fg"
			},
			{
				match_string = "IMPORTANT",
				callout_preview = " Important",
				callout_preview_hl = "markview_yellow_fg",

				border = "▋", border_hl = "markview_yellow_fg"
			},
			{
				match_string = "WARNING",
				callout_preview = " Warning",
				callout_preview_hl = "markview_orange_fg",

				border = "▋", border_hl = "markview_orange_fg"
			},
			{
				match_string = "CAUTION",
				callout_preview = "󰳦 Caution",
				callout_preview_hl = "rainbow1",

				border = "▋", border_hl = "rainbow1"
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
	horizontal_rules = {
		enable = true,

		position = "overlay",
		parts = {
			{
				type = "repeating",
				repeat_amount = function () --[[@as function]]
					return math.floor((vim.o.columns - 5) / 2);
				end,

				text = "H",
				hl = {
					"Glow_7", "Glow_6", "Glow_5", "Glow_4", "Glow_3", "Glow_2", "Glow_1", "Glow_0"
				}
			},
			{
				type = "text",
				text = "─",

				repeat_amount = vim.o.columns
			},
			{
				type = "repeating",
				repeat_amount = function ()
					return math.ceil((vim.o.columns - 5) / 2);
				end,

				direction = "right",
				text = "H",
				hl = {
					"Glow_7", "Glow_6", "Glow_5", "Glow_4", "Glow_3", "Glow_2", "Glow_1", "Glow_0"
				}
			}
		}
	},

	hyperlinks = {
		enable = true,

		icon = "󰌷 ", icon_hl = "markdownLinkText",
		text_hl = "markdownLinkText",
	},
	images = {
		enable = true,

		icon = "󰥶 ", icon_hl = "markdownLinkText",
		text_hl = "markdownLinkText",
	},

	inline_codes = {
		enable = true,
		corner_left = " ",
		corner_right = " ",
		shift_char = "",
		hl = "inline_code_block"

		-- icon = " ", icon_hl = "t_1",
		-- hl = "t", text_hl = "t_1",
	},

	list_items = {
		marker_plus = {
			add_padding = true,

			text = "•",
			hl = "rainbow2"
		},
		marker_minus = {
			add_padding = true,

			text = "•",
			hl = "rainbow4"
		},
		marker_star = {
			add_padding = true,

			text = "•",
			text_hl = "rainbow2"
		},
		marker_dot = {
			add_padding = true
		},
	},

	checkboxes = {
		enable = true,

		checked = {
			text = "✔", hl = "@markup.list.checked"
		},
		unchecked = {
			text = "✘", hl = "@markup.list.unchecked"
		}
	},

	tables = {
		enable = true,
		text = {
			"╭", "─", "╮", "┬",
			"├", "│", "┤", "┼",
			"╰", "─", "╯", "┴",

			"╼", "╾", "╴", "╶"
		},
		hl = {
			"red_fg", "red_fg", "red_fg", "red_fg",
			"red_fg", "red_fg", "red_fg", "red_fg",
			"red_fg", "red_fg", "red_fg", "red_fg",

			"red_fg", "red_fg", "red_fg", "red_fg"
		},

		use_virt_lines = false,
	},
};

markview.setup = function (user_config)
	---@type markview.config
	-- Merged configuration tables
	markview.configuration = vim.tbl_extend("keep", user_config or {}, markview.configuration);

	if vim.islist(markview.configuration.highlight_groups) then
		markview.add_hls(markview.configuration.highlight_groups);
	end
end

return markview;
