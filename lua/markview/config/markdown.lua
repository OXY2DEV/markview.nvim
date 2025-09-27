return {
	enable = true,

	block_quotes = {
		enable = true,
		wrap = true,

		default = {
			border = "▋",
			hl = "MarkviewBlockQuoteDefault"
		},

		["ABSTRACT"] = {
			preview = "󱉫 Abstract",
			hl = "MarkviewBlockQuoteNote",

			title = true,
			icon = "󱉫",
		},
		["SUMMARY"] = {
			hl = "MarkviewBlockQuoteNote",
			preview = "󱉫 Summary",

			title = true,
			icon = "󱉫",
		},
		["TLDR"] = {
			hl = "MarkviewBlockQuoteNote",
			preview = "󱉫 Tldr",

			title = true,
			icon = "󱉫",
		},
		["TODO"] = {
			hl = "MarkviewBlockQuoteNote",
			preview = " Todo",

			title = true,
			icon = "",
		},
		["INFO"] = {
			hl = "MarkviewBlockQuoteNote",
			preview = " Info",

			custom_title = true,
			icon = "",
		},
		["SUCCESS"] = {
			hl = "MarkviewBlockQuoteOk",
			preview = "󰗠 Success",

			title = true,
			icon = "󰗠",
		},
		["CHECK"] = {
			hl = "MarkviewBlockQuoteOk",
			preview = "󰗠 Check",

			title = true,
			icon = "󰗠",
		},
		["DONE"] = {
			hl = "MarkviewBlockQuoteOk",
			preview = "󰗠 Done",

			title = true,
			icon = "󰗠",
		},
		["QUESTION"] = {
			hl = "MarkviewBlockQuoteWarn",
			preview = "󰋗 Question",

			title = true,
			icon = "󰋗",
		},
		["HELP"] = {
			hl = "MarkviewBlockQuoteWarn",
			preview = "󰋗 Help",

			title = true,
			icon = "󰋗",
		},
		["FAQ"] = {
			hl = "MarkviewBlockQuoteWarn",
			preview = "󰋗 Faq",

			title = true,
			icon = "󰋗",
		},
		["FAILURE"] = {
			hl = "MarkviewBlockQuoteError",
			preview = "󰅙 Failure",

			title = true,
			icon = "󰅙",
		},
		["FAIL"] = {
			hl = "MarkviewBlockQuoteError",
			preview = "󰅙 Fail",

			title = true,
			icon = "󰅙",
		},
		["MISSING"] = {
			hl = "MarkviewBlockQuoteError",
			preview = "󰅙 Missing",

			title = true,
			icon = "󰅙",
		},
		["DANGER"] = {
			hl = "MarkviewBlockQuoteError",
			preview = " Danger",

			title = true,
			icon = "",
		},
		["ERROR"] = {
			hl = "MarkviewBlockQuoteError",
			preview = " Error",

			title = true,
			icon = "",
		},
		["BUG"] = {
			hl = "MarkviewBlockQuoteError",
			preview = " Bug",

			title = true,
			icon = "",
		},
		["EXAMPLE"] = {
			hl = "MarkviewBlockQuoteSpecial",
			preview = "󱖫 Example",

			title = true,
			icon = "󱖫",
		},
		["QUOTE"] = {
			hl = "MarkviewBlockQuoteDefault",
			preview = " Quote",

			title = true,
			icon = "",
		},
		["CITE"] = {
			hl = "MarkviewBlockQuoteDefault",
			preview = " Cite",

			title = true,
			icon = "",
		},
		["HINT"] = {
			hl = "MarkviewBlockQuoteOk",
			preview = " Hint",

			title = true,
			icon = "",
		},
		["ATTENTION"] = {
			hl = "MarkviewBlockQuoteWarn",
			preview = " Attention",

			title = true,
			icon = "",
		},

		["NOTE"] = {
			hl = "MarkviewBlockQuoteNote",
			preview = "󰋽 Note",

			title = true,
			icon = "󰋽",
		},
		["TIP"] = {
			hl = "MarkviewBlockQuoteOk",
			preview = " Tip",

			title = true,
			icon = "",
		},
		["IMPORTANT"] = {
			hl = "MarkviewBlockQuoteSpecial",
			preview = " Important",

			title = true,
			icon = "",
		},
		["WARNING"] = {
			hl = "MarkviewBlockQuoteWarn",
			preview = " Warning",

			title = true,
			icon = "",
		},
		["CAUTION"] = {
			hl = "MarkviewBlockQuoteError",
			preview = "󰳦 Caution",

			title = true,
			icon = "󰳦",
		}
	},

	code_blocks = {
		enable = true,

		border_hl = "MarkviewCode",
		info_hl = "MarkviewCodeInfo",

		label_direction = "right",
		label_hl = nil,

		min_width = 60,
		pad_amount = 2,
		pad_char = " ",

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
		},

		style = "block",
		sign = true,
	},

	headings = {
		enable = true,

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

		setext_1 = {
			style = "decorated",

			sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",
			icon = "  ", hl = "MarkviewHeading1",
			border = "▂"
		},
		setext_2 = {
			style = "decorated",

			sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",
			icon = "  ", hl = "MarkviewHeading2",
			border = "▁"
		},

		shift_width = 1,

		org_indent = false,
		org_indent_wrap = true,
		org_shift_char = " ",
		org_shift_width = 1,
	},

	horizontal_rules = {
		enable = true,

		parts = {
			{
				type = "repeating",
				direction = "left",

				repeat_amount = function (buffer)
					local utils = require("markview.utils");
					local window = utils.buf_getwin(buffer)

					local width = vim.api.nvim_win_get_width(window)
					local textoff = vim.fn.getwininfo(window)[1].textoff;

					return math.floor((width - textoff - 3) / 2);
				end,

				text = "─",

				hl = {
					"MarkviewGradient1", "MarkviewGradient1",
					"MarkviewGradient2", "MarkviewGradient2",
					"MarkviewGradient3", "MarkviewGradient3",
					"MarkviewGradient4", "MarkviewGradient4",
					"MarkviewGradient5", "MarkviewGradient5",
					"MarkviewGradient6", "MarkviewGradient6",
					"MarkviewGradient7", "MarkviewGradient7",
					"MarkviewGradient8", "MarkviewGradient8",
					"MarkviewGradient9", "MarkviewGradient9"
				}
			},
			{
				type = "text",

				text = "  ",
				hl = "MarkviewIcon3Fg"
			},
			{
				type = "repeating",
				direction = "right",

				repeat_amount = function (buffer) --[[@as function]]
					local utils = require("markview.utils");
					local window = utils.buf_getwin(buffer)

					local width = vim.api.nvim_win_get_width(window)
					local textoff = vim.fn.getwininfo(window)[1].textoff;

					return math.ceil((width - textoff - 3) / 2);
				end,

				text = "─",
				hl = {
					"MarkviewGradient1", "MarkviewGradient1",
					"MarkviewGradient2", "MarkviewGradient2",
					"MarkviewGradient3", "MarkviewGradient3",
					"MarkviewGradient4", "MarkviewGradient4",
					"MarkviewGradient5", "MarkviewGradient5",
					"MarkviewGradient6", "MarkviewGradient6",
					"MarkviewGradient7", "MarkviewGradient7",
					"MarkviewGradient8", "MarkviewGradient8",
					"MarkviewGradient9", "MarkviewGradient9"
				}
			}
		}
	},

	list_items = {
		enable = true,
		wrap = true,

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
			conceal_on_checkboxes = true,

			text = "●",
			hl = "MarkviewListItemMinus"
		},

		marker_plus = {
			add_padding = true,
			conceal_on_checkboxes = true,

			text = "◈",
			hl = "MarkviewListItemPlus"
		},

		marker_star = {
			add_padding = true,
			conceal_on_checkboxes = true,

			text = "◇",
			hl = "MarkviewListItemStar"
		},

		marker_dot = {
			add_padding = true,
			conceal_on_checkboxes = true
		},

		marker_parenthesis = {
			add_padding = true,
			conceal_on_checkboxes = true
		}
	},

	metadata_minus = {
		enable = true,

		hl = "MarkviewCode",
		border_hl = "MarkviewCodeFg",

		border_top = "▄",
		border_bottom = "▀"
	},

	metadata_plus = {
		enable = true,

		hl = "MarkviewCode",
		border_hl = "MarkviewCodeFg",

		border_top = "▄",
		border_bottom = "▀"
	},

	reference_definitions = {
		enable = true,

		default = {
			icon = " ",
			hl = "MarkviewPalette4Fg"
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
	},

	tables = {
		enable = true,
		strict = false,

		block_decorator = true,
		use_virt_lines = false,

		parts = {
			top = { "╭", "─", "╮", "┬" },
			header = { "│", "│", "│" },
			separator = { "├", "─", "┤", "┼" },
			row = { "│", "│", "│" },
			bottom = { "╰", "─", "╯", "┴" },

			overlap = { "┝", "━", "┥", "┿" },

			align_left = "╼",
			align_right = "╾",
			align_center = { "╴", "╶" }
		},

		hl = {
			top = { "TableHeader", "TableHeader", "TableHeader", "TableHeader" },
			header = { "TableHeader", "TableHeader", "TableHeader" },
			separator = { "TableHeader", "TableHeader", "TableHeader", "TableHeader" },
			row = { "TableBorder", "TableBorder", "TableBorder" },
			bottom = { "TableBorder", "TableBorder", "TableBorder", "TableBorder" },

			overlap = { "TableBorder", "TableBorder", "TableBorder", "TableBorder" },

			align_left = "TableAlignLeft",
			align_right = "TableAlignRight",
			align_center = { "TableAlignCenter", "TableAlignCenter" }
		}
	},
};
