---@type markview.config.typst
return {
	enable = true,

	code_blocks = {
		enable = true,

		hl = "MarkviewCode",

		min_width = 60,
		pad_amount = 3,
		pad_char = " ",

		style = "block",

		text = "󰣖 Code",
		text_direction = "right",
		text_hl = "MarkviewIcon5"
	},

	code_spans = {
		enable = true,

		padding_left = " ",
		padding_right = " ",

		hl = "MarkviewCode"
	},

	escapes = {
		enable = true
	},

	headings = {
		enable = true,
		shift_width = 1,

		heading_1 = {
			style = "icon",
			sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",

			icon = "󰼏  ", hl = "MarkviewHeading1",
		},
		heading_2 = {
			style = "icon",
			sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",

			icon = "󰎨  ", hl = "MarkviewHeading2",
		},
		heading_3 = {
			style = "icon",

			icon = "󰼑  ", hl = "MarkviewHeading3",
		},
		heading_4 = {
			style = "icon",

			icon = "󰎲  ", hl = "MarkviewHeading4",
		},
		heading_5 = {
			style = "icon",

			icon = "󰼓  ", hl = "MarkviewHeading5",
		},
		heading_6 = {
			style = "icon",

			icon = "󰎴  ", hl = "MarkviewHeading6",
		},

		org_indent = false,
		org_shift_char = " ",
		org_shift_width = 1,
	},

	labels = {
		enable = true,

		default = {
			hl = "MarkviewInlineCode",
			padding_left = " ",
			icon = " ",
			padding_right = " "
		}
	},

	list_items = {
		enable = true,

		indent_size = function (buffer)
			if type(buffer) ~= "number" then
				return vim.bo.shiftwidth or 4;
			end

			--- Use 'shiftwidth' value.
			return vim.bo[buffer].shiftwidth or 4;
		end,
		shift_width = 4,

		marker_minus = {
			add_padding = true,

			text = "●",
			hl = "MarkviewListItemMinus"
		},

		marker_plus = {
			add_padding = true,

			text = "%d)",
			hl = "MarkviewListItemPlus"
		},

		marker_dot = {
			add_padding = true,

			text = "%d.",
			hl = "MarkviewListItemStar"
		}
	},

	math_blocks = {
		enable = true,

		text = " 󰪚 Math ",
		pad_amount = 3,
		pad_char = " ",

		hl = "MarkviewCode",
		text_hl = "MarkviewCodeInfo"
	},

	math_spans = {
		enable = true,

		padding_left = " ",
		padding_right = " ",

		hl = "MarkviewInlineCode"
	},

	raw_blocks = {
		enable = true,

		style = "block",
		label_direction = "right",

		sign = true,

		min_width = 60,
		pad_amount = 3,
		pad_char = " ",

		border_hl = "MarkviewCode",

		default = {
			block_hl = "MarkviewCode",
			pad_hl = "MarkviewCode"
		},

		["diff"] = {
			block_hl = function (_, line)
				if line:match("^%+") then
					return "MarkviewPalette4";
				elseif line:match("^%-") then
					return "MarkviewPalette1";
				else
					return "MarkviewCode";
				end
			end,
			pad_hl = "MarkviewCode"
		}
	},

	raw_spans = {
		enable = true,

		padding_left = " ",
		padding_right = " ",

		hl = "MarkviewInlineCode"
	},

	reference_links = {
		enable = true,

		default = {
			icon = " ",
			hl = "MarkviewHyperlink"
		},
	},

	subscripts = {
		enable = true,

		hl = "MarkviewSubscript"
	},

	superscripts = {
		enable = true,

		hl = "MarkviewSuperscript"
	},

	symbols = {
		enable = true,

		hl = "Special"
	},

	terms = {
		enable = true,

		default = {
			text = " ",
			hl = "MarkviewPalette6Fg"
		},
	},

	url_links = {
		enable = true,

		default = {
			icon = " ",
			hl = "MarkviewEmail"
		},

		["github%.com/[%a%d%-%_%.]+%/?$"] = {
			--- github.com/<user>

			icon = " ",
			hl = "MarkviewPalette0Fg"
		},
		["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/?$"] = {
			--- github.com/<user>/<repo>

			icon = " ",
			hl = "MarkviewPalette0Fg"
		},
		["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/tree/[%a%d%-%_%.]+%/?$"] = {
			--- github.com/<user>/<repo>/tree/<branch>

			icon = " ",
			hl = "MarkviewPalette0Fg"
		},
		["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/commits/[%a%d%-%_%.]+%/?$"] = {
			--- github.com/<user>/<repo>/commits/<branch>

			icon = " ",
			hl = "MarkviewPalette0Fg"
		},

		["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/releases$"] = {
			--- github.com/<user>/<repo>/releases

			icon = " ",
			hl = "MarkviewPalette0Fg"
		},
		["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/tags$"] = {
			--- github.com/<user>/<repo>/tags

			icon = " ",
			hl = "MarkviewPalette0Fg"
		},
		["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/issues$"] = {
			--- github.com/<user>/<repo>/issues

			icon = " ",
			hl = "MarkviewPalette0Fg"
		},
		["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/pulls$"] = {
			--- github.com/<user>/<repo>/pulls

			icon = " ",
			hl = "MarkviewPalette0Fg"
		},

		["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/wiki$"] = {
			--- github.com/<user>/<repo>/wiki

			icon = " ",
			hl = "MarkviewPalette0Fg"
		},

		["developer%.mozilla%.org"] = {
			priority = -9999,

			icon = "󰖟 ",
			hl = "MarkviewPalette5Fg"
		},

		["w3schools%.com"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette4Fg"
		},

		["stackoverflow%.com"] = {
			priority = -9999,

			icon = "󰓌 ",
			hl = "MarkviewPalette2Fg"
		},

		["reddit%.com"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette2Fg"
		},

		["github%.com"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette6Fg"
		},

		["gitlab%.com"] = {
			priority = -9999,

			icon = "󰮠 ",
			hl = "MarkviewPalette2Fg"
		},

		["dev%.to"] = {
			priority = -9999,

			icon = "󱁴 ",
			hl = "MarkviewPalette0Fg"
		},

		["codepen%.io"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette6Fg"
		},

		["replit%.com"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette2Fg"
		},

		["jsfiddle%.net"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette5Fg"
		},

		["npmjs%.com"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette0Fg"
		},

		["pypi%.org"] = {
			priority = -9999,

			icon = "󰆦 ",
			hl = "MarkviewPalette0Fg"
		},

		["mvnrepository%.com"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette1Fg"
		},

		["medium%.com"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette6Fg"
		},

		["linkedin%.com"] = {
			priority = -9999,

			icon = "󰌻 ",
			hl = "MarkviewPalette5Fg"
		},

		["news%.ycombinator%.com"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette2Fg"
		},
	}
};
