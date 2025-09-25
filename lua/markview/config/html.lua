return {
	enable = true,

	container_elements = {
		enable = true,

		["^a$"] = {
			on_opening_tag = { conceal = "", virt_text_pos = "inline", virt_text = { { "", "MarkviewHyperlink" } } },
			on_node = { hl_group = "MarkviewHyperlink" },
			on_closing_tag = { conceal = "" },
		},
		["^b$"] = {
			on_opening_tag = { conceal = "" },
			on_node = { hl_group = "Bold" },
			on_closing_tag = { conceal = "" },
		},
		["^code$"] = {
			on_opening_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { " ", "MarkviewInlineCode" } } },
			on_node = { hl_group = "MarkviewInlineCode" },
			on_closing_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { " ", "MarkviewInlineCode" } } },
		},
		["^em$"] = {
			on_opening_tag = { conceal = "" },
			on_node = { hl_group = "@text.emphasis" },
			on_closing_tag = { conceal = "" },
		},
		["^i$"] = {
			on_opening_tag = { conceal = "" },
			on_node = { hl_group = "Italic" },
			on_closing_tag = { conceal = "" },
		},
		["^mark$"] = {
			on_opening_tag = { conceal = "" },
			on_node = { hl_group = "MarkviewPalette1" },
			on_closing_tag = { conceal = "" },
		},
		["^pre$"] = {
			on_opening_tag = { conceal = "" },
			on_node = { hl_group = "Special" },
			on_closing_tag = { conceal = "" },
		},
		["^strong$"] = {
			on_opening_tag = { conceal = "" },
			on_node = { hl_group = "@text.strong" },
			on_closing_tag = { conceal = "" },
		},
		["^sub$"] = {
			on_opening_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "↓[", "MarkviewSubscript" } } },
			on_node = { hl_group = "MarkviewSubscript" },
			on_closing_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "]", "MarkviewSubscript" } } },
		},
		["^sup$"] = {
			on_opening_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "↑[", "MarkviewSuperscript" } } },
			on_node = { hl_group = "MarkviewSuperscript" },
			on_closing_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "]", "MarkviewSuperscript" } } },
		},
		["^u$"] = {
			on_opening_tag = { conceal = "" },
			on_node = { hl_group = "Underlined" },
			on_closing_tag = { conceal = "" },
		},
	},

	headings = {
		enable = true,

		heading_1 = {
			hl_group = "MarkviewPalette1Bg"
		},
		heading_2 = {
			hl_group = "MarkviewPalette2Bg"
		},
		heading_3 = {
			hl_group = "MarkviewPalette3Bg"
		},
		heading_4 = {
			hl_group = "MarkviewPalette4Bg"
		},
		heading_5 = {
			hl_group = "MarkviewPalette5Bg"
		},
		heading_6 = {
			hl_group = "MarkviewPalette6Bg"
		},
	},

	void_elements = {
		enable = true,

		["^hr$"] = {
			on_node = {
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ "─", "MarkviewGradient2" },
					{ "─", "MarkviewGradient3" },
					{ "─", "MarkviewGradient4" },
					{ "─", "MarkviewGradient5" },
					{ " ◉ ", "MarkviewGradient9" },
					{ "─", "MarkviewGradient5" },
					{ "─", "MarkviewGradient4" },
					{ "─", "MarkviewGradient3" },
					{ "─", "MarkviewGradient2" },
				}
			}
		},
		["^br$"] = {
			on_node = {
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ "󱞦", "Comment" },
				}
			}
		},
	}
};
