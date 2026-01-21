---@type [ string, markview.config.asciidoc.keycodes ]
local keycodes = {
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
};


---@type markview.config.asciidoc
return {
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
		["*"] = { text = "󰓎", hl = "MarkviewCheckboxPending" },
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

	document_titles = {
		enable = true,

		sign = "󰛓 ",
		sign_hl = "MarkviewPalette7Sign",

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
