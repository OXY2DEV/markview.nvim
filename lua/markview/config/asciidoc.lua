---@type [ string, markview.config.asciidoc.keycodes ]
local keycodes = {
	---|fS

	default = {
		padding_left = " ",
		padding_right = " ",

		icon = "󰌌 ",
		hl = "MarkviewPalette6",
	},

	ctrl = {
		icon = " ",
		hl = "MarkviewPalette3",
	},

	shift = {
		icon = "󰘶 ",
		hl = "MarkviewPalette4",
	},

	meta = {
		icon = "󰘵 ",
		hl = "MarkviewPalette2",
	},

	super = {
		icon = "󰌽 ",
		hl = "MarkviewPalette5",
	},

	command = {
		icon = "󰘳 ",
		hl = "MarkviewPalette5",
	},

	caps_lock = {
		icon = "󰘲 ",
		hl = "MarkviewPalette1",
	},

	space = {
		icon = "󱁐 ",
		hl = "MarkviewPalette5",
	},

	enter = {
		icon = "󰌑 ",
		hl = "MarkviewPalette2",
	},

	tab = {
		icon = "󰌒 ",
		hl = "MarkviewPalette3",
	},

	---|fE
};


---@type markview.config.asciidoc
return {
	enable = true,

	admonitions = {
		enable = true,

		default = {
			padding_left = " ",
			padding_right = " ",

			icon = " ",

			hl = "MarkviewPalette5",
		},

		important = {
			padding_left = " ",
			padding_right = " ",

			icon = " ",

			hl = "MarkviewPalette1",
		},

		tip = {
			padding_left = " ",
			padding_right = " ",

			icon = " ",

			hl = "MarkviewPalette4",
		},

		caution = {
			padding_left = " ",
			padding_right = " ",

			icon = " ",

			hl = "MarkviewPalette7",
		},

		warn = {
			padding_left = " ",
			padding_right = " ",

			icon = " ",

			hl = "MarkviewPalette3",
		},
	},

	checkboxes = {
		enable = true,

		checked = { text = "󰗠", hl = "MarkviewCheckboxChecked", scope_hl = "MarkviewCheckboxChecked" },
		unchecked = { text = "󰄰", hl = "MarkviewCheckboxUnchecked", scope_hl = "MarkviewCheckboxUnchecked" },

		["/"] = { text = "󱎖", hl = "MarkviewCheckboxPending" },
		[">"] = { text = "", hl = "MarkviewCheckboxCancelled" },
		["<"] = { text = "󰃖", hl = "MarkviewCheckboxCancelled" },
		["-"] = { text = "󰍶", hl = "MarkviewCheckboxCancelled", scope_hl = "MarkviewCheckboxStriked" },

		["?"] = { text = "󰋗", hl = "MarkviewCheckboxPending" },
		["!"] = { text = "󰀦", hl = "MarkviewCheckboxUnchecked" },
		['"'] = { text = "󰸥", hl = "MarkviewCheckboxCancelled" },
		["l"] = { text = "󰆋", hl = "MarkviewCheckboxProgress" },
		["b"] = { text = "󰃀", hl = "MarkviewCheckboxProgress" },
		["i"] = { text = "󰰄", hl = "MarkviewCheckboxChecked" },
		["S"] = { text = "", hl = "MarkviewCheckboxChecked" },
		["I"] = { text = "󰛨", hl = "MarkviewCheckboxPending" },
		["p"] = { text = "", hl = "MarkviewCheckboxChecked" },
		["c"] = { text = "", hl = "MarkviewCheckboxUnchecked" },
		["f"] = { text = "󱠇", hl = "MarkviewCheckboxUnchecked" },
		["k"] = { text = "", hl = "MarkviewCheckboxPending" },
		["w"] = { text = "", hl = "MarkviewCheckboxProgress" },
		["u"] = { text = "󰔵", hl = "MarkviewCheckboxChecked" },
		["d"] = { text = "󰔳", hl = "MarkviewCheckboxUnchecked" },
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

	literal_blocks = {
		enable = true,

		hl = "MarkviewCode",

		sign = "hi",

		label = "Hello ",
		label_direction = "right",
		label_hl = nil,

		min_width = 60,
		pad_amount = 2,
		pad_char = " ",

		style = "block",
	},

	document_titles = {
		enable = true,

		sign = "󰛓 ",

		icon = "󰛓 ",
		hl = "MarkviewPalette7",
	},
	section_titles = {
		enable = true,

		title_1 = {
			sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",

			icon = "󰼏  ", hl = "MarkviewHeading1",
		},
		title_2 = {
			sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",

			icon = "󰎨  ", hl = "MarkviewHeading2",
		},
		title_3 = {

			icon = "󰼑  ", hl = "MarkviewHeading3",
		},
		title_4 = {

			icon = "󰎲  ", hl = "MarkviewHeading4",
		},
		title_5 = {

			icon = "󰼓  ", hl = "MarkviewHeading5",
		},
		title_6 = {

			icon = "󰎴  ", hl = "MarkviewHeading6",
		},

		shift_width = 1,
	},

	document_attributes = {
		enable = true,
	},

	images = {
		enable = true,

		default = {
			icon = "󰥶 ",
			hl = "MarkviewImage",
		},

		["%.svg$"] = { icon = "󰜡 " },
		["%.png$"] = { icon = "󰸭 " },
		["%.jpg$"] = { icon = "󰈥 " },
		["%.gif$"] = { icon = "󰵸 " },
		["%.pdf$"] = { icon = " " }
	},

	keycodes = {
		enable = true,

		default = keycodes.default,

		["^CTRL"] = keycodes.ctrl,
		["^%<[cC]"] = keycodes.ctrl,

		["^SHIFT"] = keycodes.shift,
		["^%<[sS]"] = keycodes.shift,

		["^META"] = keycodes.meta,
		["^OPT"] = keycodes.meta,
		["^ALT"] = keycodes.meta,
		["^%<[mM]"] = keycodes.meta,

		["^SUPER"] = keycodes.super,
		["^%<[dD]"] = keycodes.super,

		["^CMD"] = keycodes.command,
		["^COMMAND"] = keycodes.command,

		["CAPS.LOCK"] = keycodes.caps_lock,
		["SPACE"] = keycodes.space,
		["TAB"] = keycodes.tab,
		["ENTER"] = keycodes.enter,
	},

	tocs = {
		enable = true,

		shift_width = 2,
		hl = "MarkviewPalette2Fg",

		sign = "󰙅 ",
		sign_hl = "MarkviewPalette2Sign",

		depth_1 = {
			icon = "◆ ",
			icon_hl = "Comment",

			hl = "MarkviewPalette5Fg",
		},
		depth_2 = {
			icon = "◇ ",
			icon_hl = "Comment",

			hl = "MarkviewPalette5Fg",
		},
		depth_3 = {
			icon = "◆ ",
			icon_hl = "Comment",

			hl = "MarkviewPalette5Fg",
		},
		depth_4 = {
			icon = "◇ ",
			icon_hl = "Comment",

			hl = "MarkviewPalette5Fg",
		},
		depth_5 = {
			icon = "◆ ",
			icon_hl = "Comment",

			hl = "MarkviewPalette5Fg",
		},
	},

	list_items = {
		enable = true,
		shift_width = 4,

		marker_dot = {
			add_padding = true,
			conceal_on_checkboxes = true,

			text = function (_, item)
				return string.format("%d.", item.n);
			end,
			hl = "@markup.list.markdown",
		},

		marker_minus = {
			add_padding = true,
			conceal_on_checkboxes = true,

			text = "●",
			hl = "MarkviewListItemMinus"
		},

		marker_star = {
			add_padding = true,
			conceal_on_checkboxes = true,

			text = "◇",
			hl = "MarkviewListItemStar"
		},
	},
};
