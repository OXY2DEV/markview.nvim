return {
	enable = true,

	block_references = {
		enable = true,

		default = {
			icon = "󰿨 ",

			hl = "MarkviewPalette6Fg",
			file_hl = "MarkviewPalette0Fg",
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

	emails = {
		enable = true,

		default = {
			icon = " ",
			hl = "MarkviewEmail"
		},

		["%@gmail%.com$"] = {
			--- user@gmail.com

			icon = "󰊫 ",
			hl = "MarkviewPalette0Fg"
		},

		["%@outlook%.com$"] = {
			--- user@outlook.com

			icon = "󰴢 ",
			hl = "MarkviewPalette5Fg"
		},

		["%@yahoo%.com$"] = {
			--- user@yahoo.com

			icon = " ",
			hl = "MarkviewPalette6Fg"
		},

		["%@icloud%.com$"] = {
			--- user@icloud.com

			icon = "󰀸 ",
			hl = "MarkviewPalette6Fg"
		}
	},

	embed_files = {
		enable = true,

		default = {
			icon = "󰠮 ",
			hl = "MarkviewPalette7Fg"
		}
	},

	entities = {
		enable = true,
		hl = "Special"
	},

	emoji_shorthands = {
		enable = true
	},

	escapes = {
		enable = true
	},

	footnotes = {
		enable = true,

		default = {
			icon = "󰯓 ",
			hl = "MarkviewHyperlink"
		},

		["^%d+$"] = {
			--- Numbered footnotes.

			icon = "󰯓 ",
			hl = "MarkviewPalette4Fg"
		}
	},

	highlights = {
		enable = true,

		default = {
			padding_left = " ",
			padding_right = " ",

			hl = "MarkviewPalette3"
		}
	},

	hyperlinks = {
		enable = true,

		default = {
			icon = "󰌷 ",
			hl = "MarkviewHyperlink",
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

			icon = " ",
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

	inline_codes = {
		enable = true,
		hl = "MarkviewInlineCode",

		padding_left = " ",
		padding_right = " "
	},

	internal_links = {
		enable = true,

		default = {
			icon = " ",
			hl = "MarkviewPalette7Fg",
		},
	},

	uri_autolinks = {
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

			icon = " ",
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
};
