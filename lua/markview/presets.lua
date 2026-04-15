---@diagnostic disable missing-field
local presets = {};

---@type table<string, markview.config.markdown.block_quotes>
presets.block_quotes = {
	obsidian = {
		default = {
			line_hl = "MarkviewPalette0",
		},

		["ABSTRACT"] = {
			line_hl = "MarkviewPalette5",
		},
		["SUMMARY"] = {
			line_hl = "MarkviewPalette5",
		},
		["TLDR"] = {
			line_hl = "MarkviewPalette5",
		},
		["TODO"] = {
			line_hl = "MarkviewPalette5",
		},
		["INFO"] = {
			line_hl = "MarkviewPalette5",
		},
		["SUCCESS"] = {
			line_hl = "MarkviewPalette4",
		},
		["CHECK"] = {
			line_hl = "MarkviewPalette4",
		},
		["DONE"] = {
			line_hl = "MarkviewPalette4",
		},
		["QUESTION"] = {
			line_hl = "MarkviewPalette2",
		},
		["HELP"] = {
			line_hl = "MarkviewPalette2",
		},
		["FAQ"] = {
			line_hl = "MarkviewPalette2",
		},
		["FAILURE"] = {
			line_hl = "MarkviewPalette1",
		},
		["FAIL"] = {
			line_hl = "MarkviewPalette1",
		},
		["MISSING"] = {
			line_hl = "MarkviewPalette1",
		},
		["DANGER"] = {
			line_hl = "MarkviewPalette1",
		},
		["ERROR"] = {
			line_hl = "MarkviewPalette1",
		},
		["BUG"] = {
			line_hl = "MarkviewPalette1",
		},
		["EXAMPLE"] = {
			line_hl = "MarkviewPalette3",
		},
		["QUOTE"] = {
			line_hl = "MarkviewPalette0",
		},
		["CITE"] = {
			line_hl = "MarkviewPalette0",
		},
		["HINT"] = {
			line_hl = "MarkviewPalette4",
		},
		["ATTENTION"] = {
			line_hl = "MarkviewPalette2",
		},

		["NOTE"] = {
			line_hl = "MarkviewPalette5",
		},
		["TIP"] = {
			line_hl = "MarkviewPalette4",
		},
		["IMPORTANT"] = {
			line_hl = "MarkviewPalette3",
		},
		["WARNING"] = {
			line_hl = "MarkviewPalette2",
		},
		["CAUTION"] = {
			line_hl = "MarkviewPalette1",
		}
	},
};

presets.checkboxes = {
	legacy = {
		---+ ${conf, Old checkboxes}
		enable = true,

		checked = {
			text = "✔", hl = "MarkviewCheckboxChecked",
			scope_hl = "MarkviewCheckboxStriked"
		},
		unchecked = {
			text = "✘", hl = "MarkviewCheckboxUnchecked"
		},
		custom = {
			---+ ${conf, Custom cehckboxes}
			{
				match_string = "-",
				text = "◯",
				hl = "MarkviewCheckboxPending",
			},
			{
				match_string = "~",
				text = "◕",
				hl = "MarkviewCheckboxProgress"
			},
			{
				match_string = "o",
				text = "󰩹",
				hl = "MarkviewCheckboxCancelled"
			},
			---_
		}
		---_
	},

	nerd = {
		---+ ${conf, Uses nerd font characters}
		enable = true,

		checked = {
			text = "", hl = "MarkviewCheckboxChecked",
			scope_hl = "MarkviewCheckboxStriked"
		},
		unchecked = {
			text = "", hl = "MarkviewCheckboxUnchecked"
		},
		custom = {
			{
				match_string = "-",
				text = "",
				hl = "MarkviewCheckboxPending"
			},
			{
				match_string = "~",
				text = "",
				hl = "MarkviewCheckboxProgress"
			},
			{
				match_string = "o",
				text = "",
				hl = "MarkviewCheckboxCancelled"
			}
		}
	---_
	},

	---@deprecated
	minimal = {
		---+ ${conf, Minimal style checkboxes}
		enable = true,

		checked = {
			text = "󰗠", hl = "MarkviewCheckboxChecked"
		},
		unchecked = {
			text = "󰄰", hl = "MarkviewCheckboxUnchecked"
		},
		custom = {
			{
				match_string = "/",
				text = "󱎖",
				hl = "MarkviewCheckboxPending"
			},
			{
				match_string = ">",
				text = "",
				hl = "MarkviewCheckboxCancelled"
			},
			{
				match_string = "<",
				text = "󰃖",
				hl = "MarkviewCheckboxCancelled"
			},
			{
				match_string = "-",
				text = "󰍶",
				hl = "MarkviewCheckboxCancelled",
				scope_hl = "MarkviewCheckboxStriked"
			},

			{
				match_string = "?",
				text = "󰋗",
				hl = "MarkviewCheckboxPending"
			},
			{
				match_string = "!",
				text = "󰀦",
				hl = "MarkviewCheckboxUnchecked"
			},
			{
				match_string = "*",
				text = "󰓎",
				hl = "MarkviewCheckboxPending"
			},
			{
				match_string = '"',
				text = "󰸥",
				hl = "MarkviewCheckboxCancelled"
			},
			{
				match_string = "l",
				text = "󰆋",
				hl = "MarkviewCheckboxProgress"
			},
			{
				match_string = "b",
				text = "󰃀",
				hl = "MarkviewCheckboxProgress"
			},
			{
				match_string = "i",
				text = "󰰄",
				hl = "MarkviewCheckboxChecked"
			},
			{
				match_string = "S",
				text = "",
				hl = "MarkviewCheckboxChecked"
			},
			{
				match_string = "I",
				text = "󰛨",
				hl = "MarkviewCheckboxPending"
			},
			{
				match_string = "p",
				text = "",
				hl = "MarkviewCheckboxChecked"
			},
			{
				match_string = "c",
				text = "",
				hl = "MarkviewCheckboxUnchecked"
			},
			{
				match_string = "f",
				text = "󱠇",
				hl = "MarkviewCheckboxUnchecked"
			},
			{
				match_string = "k",
				text = "",
				hl = "MarkviewCheckboxPending"
			},
			{
				match_string = "w",
				text = "",
				hl = "MarkviewCheckboxProgress"
			},
			{
				match_string = "u",
				text = "󰔵",
				hl = "MarkviewCheckboxChecked"
			},
			{
				match_string = "d",
				text = "󰔳",
				hl = "MarkviewCheckboxUnchecked"
			},
		}
		---_
	}
};

presets.headings = {
	glow = {
		---+ ${conf, Glow-like headings}
		enable = true,
		shift_width = 0,

		heading_1 = {
			style = "label",
			sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",

			padding_left = " ", padding_right = " ",
			icon = "󰼏 ", hl = "MarkviewHeading1",

		},
		heading_2 = {
			style = "label",
			sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",

			padding_left = " ", padding_right = " ",
			icon = "󰎨 ", hl = "MarkviewHeading2",
		},
		heading_3 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			icon = "󰼑 ", hl = "MarkviewHeading3",
		},
		heading_4 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			icon = "󰎲 ", hl = "MarkviewHeading4",
		},
		heading_5 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			icon = "󰼓 ", hl = "MarkviewHeading5",
		},
		heading_6 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			icon = "󰎴 ", hl = "MarkviewHeading6",
		}
		---_
	},
	glow_center = {
		---+ ${conf, Centered glow-like headings}
		enable = true,
		shift_width = 0,

		heading_1 = {
			style = "label",
			sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",
			align = "center",

			padding_left = " ", padding_right = " ",
			icon = "󰼏 ", hl = "MarkviewHeading1",

		},
		heading_2 = {
			style = "label",
			sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",
			align = "center",

			padding_left = " ", padding_right = " ",
			icon = "󰎨 ", hl = "MarkviewHeading2",
		},
		heading_3 = {
			style = "label",
			align = "center",

			padding_left = " ", padding_right = " ",
			icon = "󰼑 ", hl = "MarkviewHeading3",
		},
		heading_4 = {
			style = "label",
			align = "center",

			padding_left = " ", padding_right = " ",
			icon = "󰎲 ", hl = "MarkviewHeading4",
		},
		heading_5 = {
			style = "label",
			align = "center",

			padding_left = " ", padding_right = " ",
			icon = "󰼓 ", hl = "MarkviewHeading5",
		},
		heading_6 = {
			style = "label",
			align = "center",

			padding_left = " ", padding_right = " ",
			icon = "󰎴 ", hl = "MarkviewHeading6",
		}
		---_
	},

	slanted = {
		---+ ${conf, Rounded cornered headings}
		enable = true,
		shift_width = 0,

		heading_1 = {
			style = "label",
			sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewPalette1Fg",
			hl = "MarkviewHeading1",

		},
		heading_2 = {
			style = "label",
			sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewPalette2Fg",
			hl = "MarkviewHeading2",
		},
		heading_3 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewPalette3Fg",
			hl = "MarkviewHeading3",
		},
		heading_4 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewPalette4Fg",
			hl = "MarkviewHeading4",
		},
		heading_5 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewPalette5Fg",
			hl = "MarkviewHeading5",
		},
		heading_6 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewPalette6Fg",
			hl = "MarkviewHeading6",
		}
		---_
	},
	arrowed = {
		---+ ${conf, Arrow cornered headings}
		enable = true,
		shift_width = 0,

		heading_1 = {
			style = "label",
			sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewPalette1Fg",
			hl = "MarkviewHeading1",

		},
		heading_2 = {
			style = "label",
			sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewPalette2Fg",
			hl = "MarkviewHeading2",
		},
		heading_3 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewPalette3Fg",
			hl = "MarkviewHeading3",
		},
		heading_4 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewPalette4Fg",
			hl = "MarkviewHeading4",
		},
		heading_5 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewPalette5Fg",
			hl = "MarkviewHeading5",
		},
		heading_6 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewPalette6Fg",
			hl = "MarkviewHeading6",
		}
		---_
	},

	simple = {
		---+ ${conf, Rounded cornered headings}
		enable = true,
		shift_width = 0,
		textoff = 7,

		heading_1 = {
			style = "label",
			sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",
			align = "center",

			padding_left = "╾──────╴ ", padding_right = " ╶──────╼",
			icon = "", hl = "MarkviewHeading1Sign",

		},
		heading_2 = {
			style = "label",
			sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",
			align = "center",

			padding_left = "╾─────╴ ", padding_right = " ╶─────╼",
			icon = "", hl = "MarkviewHeading2Sign",
		},
		heading_3 = {
			style = "label",
			align = "center",

			padding_left = "╾────╴ ", padding_right = " ╶────╼",
			icon = "", hl = "MarkviewHeading3Sign",
		},
		heading_4 = {
			style = "label",
			align = "center",

			padding_left = "╾───╴ ", padding_right = " ╶───╼",
			icon = "", hl = "MarkviewHeading4Sign",
		},
		heading_5 = {
			style = "label",
			align = "center",

			padding_left = "╾──╴ ", padding_right = " ╶──╼",
			icon = "", hl = "MarkviewHeading5Sign",
		},
		heading_6 = {
			style = "label",
			align = "center",

			padding_left = "╾─╴ ", padding_right = " ╶─╼",
			icon = "", hl = "MarkviewHeading6Sign",
		}
		---_
	},
	marker = {
		---+ ${conf, Rounded cornered headings}
		enable = true,
		shift_width = 0,
		textoff = 7,

		heading_1 = {
			style = "icon",
			sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",

			icon = "█ ", icon_hl = "MarkviewHeading1Sign",
			hl = "MarkviewHeading1",

		},
		heading_2 = {
			style = "icon",
			sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",

			icon = "█ ", icon_hl = "MarkviewHeading2Sign",
			hl = "MarkviewHeading2",
		},
		heading_3 = {
			style = "icon",

			icon = "█ ", icon_hl = "MarkviewHeading3Sign",
			hl = "MarkviewHeading3",
		},
		heading_4 = {
			style = "icon",

			icon = "█ ", icon_hl = "MarkviewHeading4Sign",
			hl = "MarkviewHeading4",
		},
		heading_5 = {
			style = "icon",

			icon = "█ ", icon_hl = "MarkviewHeading5Sign",
			hl = "MarkviewHeading5",
		},
		heading_6 = {
			style = "icon",

			icon = "█ ", icon_hl = "MarkviewHeading6Sign",
			hl = "MarkviewHeading6",
		}
		---_
	},

	numbered = {
		heading_1 = {
			icon = function (_, item)
				return table.concat(item.levels, ".") .. " ";
			end
		},
		heading_2 = {
			icon = function (_, item)
				return table.concat(item.levels, ".") .. " ";
			end
		},
		heading_3 = {
			icon = function (_, item)
				return table.concat(item.levels, ".") .. " ";
			end
		},
		heading_4 = {
			icon = function (_, item)
				return table.concat(item.levels, ".") .. " ";
			end
		},
		heading_5 = {
			icon = function (_, item)
				return table.concat(item.levels, ".") .. " ";
			end
		},
		heading_6 = {
			icon = function (_, item)
				return table.concat(item.levels, ".") .. " ";
			end
		},
	},
};

presets.horizontal_rules = {
	thin = {
		---+ ${conf, Thin horizontal rule}
		enable = true,

		parts = {
			{
				type = "repeating",
				repeat_amount = function () --[[@as function]]
					return vim.o.columns;
				end,

				text = "─",
				hl = "Comment"
			}
		}
		---_
	},
	thick = {
		---+ ${conf, Thicker horizontal rule}
		enable = true,

		parts = {
			{
				type = "repeating",
				repeat_amount = function () --[[@as function]]
					return vim.o.columns;
				end,

				text = "━",
				hl = "Comment"
			}
		}
		---_
	},
	double = {
		---+ ${conf, Double horizontal rule}
		enable = true,

		parts = {
			{
				type = "repeating",
				repeat_amount = function () --[[@as function]]
					return vim.o.columns;
				end,

				text = "═",
				hl = "Comment"
			}
		}
		---_
	},
	dashed = {
		---+ ${conf, Dashed horizontal rule}
		enable = true,

		parts = {
			{
				type = "repeating",
				repeat_amount = function () --[[@as function]]
					return vim.o.columns;
				end,

				text = "╴",
				hl = "Comment"
			}
		}
		---_
	},
	dotted = {
		---+ ${conf, Dotted horizontal rule}
		enable = true,

		parts = {
			{
				type = "repeating",
				repeat_amount = function () --[[@as function]]
					return vim.o.columns;
				end,

				text = "╌",
				hl = "Comment"
			}
		}
		---_
	},

	solid = {
		---+ ${conf, Solid horizontal rule}
		enable = true,

		parts = {
			{
				type = "repeating",
				repeat_amount = function () --[[@as function]]
					return vim.o.columns;
				end,

				text = "█",
				hl = "Comment"
			}
		}
		---_
	},
	arrowed = {
		---+ ${conf, Arrowed horizontal rule}
		enable = true,

		parts = {
			{
				type = "repeating",
				repeat_amount = function () --[[@as function]]
					local textoff = math.max(vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].textoff, 7);

					return math.floor((vim.o.columns - textoff - 3) / 4);
				end,

				direction = "right",
				text = "",
				hl = {
					"MarkviewGradient10", "MarkviewGradient9",
					"MarkviewGradient8", "MarkviewGradient7",
					"MarkviewGradient6", "MarkviewGradient5",
					"MarkviewGradient4", "MarkviewGradient3",
				}
			},
			{
				type = "text",
				text = "  ",
				hl = "MarkviewGradient10"
			},
			{
				type = "repeating",
				repeat_amount = function () --[[@as function]]
					local textoff = math.max(vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].textoff, 7);

					return math.ceil((vim.o.columns - textoff - 3) / 4);
				end,

				text = "",
				hl = {
					"MarkviewGradient10", "MarkviewGradient9",
					"MarkviewGradient8", "MarkviewGradient7",
					"MarkviewGradient6", "MarkviewGradient5",
					"MarkviewGradient4", "MarkviewGradient3",
				}
			}
		}
		---_
	}
};

presets.tables = {
	none = {
		---+${lua}
		parts = {
			top = { " ", " ", " ", " " },
			header = { " ", " ", " " },
			separator = { " ", "-", " ", " " },
			row = { " ", " ", " " },
			bottom = { " ", " ", " ", " " },

			overlap = { " ", " ", " ", " " },

			align_left = "-",
			align_right = "-",
			align_center = { "-", "-" }
		}
		---_
	},

	single = {
		---+${lua}
		parts = {
			top = { "┌", "─", "┐", "┬" },
			header = { "│", "│", "│" },
			separator = { "├", "─", "┤", "┼" },
			row = { "│", "│", "│" },
			bottom = { "└", "─", "┘", "┴" },

			overlap = { "┝", "━", "┥", "┿" },

			align_left = "╼",
			align_right = "╾",
			align_center = { "╴", "╶" }
		}
		---_
	},
	double = {
		---+${lua}
		parts = {
			top = { "╔", "═", "╗", "╦" },
			header = { "║", "║", "║" },
			separator = { "╠", "═", "╣", "╬" },
			row = { "║", "║", "║" },
			bottom = { "╚", "═", "╝", "╩" },

			overlap = { "╟", "─", "╢", "╫" },

			align_left = "━",
			align_right = "━",
			align_center = { "━", "━" }
		}
		---_
	},
	rounded = {
		---+${lua}
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
		}
		---_
	},
	solid = {
		---+${lua}
		parts = {
			top = { "█", "█", "█", "█" },
			header = { "█", "█", "█" },
			separator = { "█", "█", "█", "█" },
			row = { "█", "█", "█" },
			bottom = { "█", "█", "█", "█" },

			overlap = { "█", "█", "█", "█" },

			align_left = "█",
			align_right = "█",
			align_center = { "█", "█" }
		}
		---_
	}
};

------------------------------------------------------------------------------

local links = {
	default = {
		icon = "↗ ",
	},

	["github%.com/[%a%d%-%_%.]+%/?$"] = {
		icon = "↗ ",
	},
	["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/?$"] = {
		icon = "↗ ",
	},
	["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/tree/[%a%d%-%_%.]+%/?$"] = {
		icon = "↗ ",
	},
	["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/commits/[%a%d%-%_%.]+%/?$"] = {
		icon = "↗ ",
	},

	["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/releases$"] = {
		icon = "↗ ",
	},
	["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/tags$"] = {
		icon = "↗ ",
	},
	["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/issues$"] = {
		icon = "↗ ",
	},
	["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/pulls$"] = {
		icon = "↗ ",
	},

	["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/wiki$"] = {
		icon = "↗ ",
	},

	["developer%.mozilla%.org"] = {
		icon = "↗ ",
	},

	["w3schools%.com"] = {
		icon = "↗ ",
	},

	["stackoverflow%.com"] = {
		icon = "↗ ",
	},

	["reddit%.com"] = {
		icon = "↗ ",
	},

	["github%.com"] = {
		icon = "↗ ",
	},

	["gitlab%.com"] = {
		icon = "↗ ",
	},

	["dev%.to"] = {
		icon = "↗ ",
	},

	["codepen%.io"] = {
		icon = "↗ ",
	},

	["replit%.com"] = {
		icon = "↗ ",
	},

	["jsfiddle%.net"] = {
		icon = "↗ ",
	},

	["npmjs%.com"] = {
		icon = "↗ ",
	},

	["pypi%.org"] = {
		icon = "↗ ",
	},

	["mvnrepository%.com"] = {
		icon = "↗ ",
	},

	["medium%.com"] = {
		icon = "↗ ",
	},

	["linkedin%.com"] = {
		icon = "↗ ",
	},

	["news%.ycombinator%.com"] = {
		icon = "↗ ",
	},
};

presets.no_nerd_fonts = {
	preview = {
		icon_provider = "",
	},

	markdown = {
		block_quotes = {
			["ABSTRACT"] = {
				preview = "Abstract ",
				icon = "",
			},
			["SUMMARY"] = {
				preview = "Summary ",
				icon = "",
			},
			["TLDR"] = {
				preview = "Tldr ",
				icon = "",
			},
			["TODO"] = {
				preview = "Todo ",
				icon = "",
			},
			["INFO"] = {
				preview = "Info ",
				icon = "",
			},
			["SUCCESS"] = {
				preview = "Success ",
				icon = "",
			},
			["CHECK"] = {
				preview = "Check ",
				icon = "",
			},
			["DONE"] = {
				preview = "Done ",
				icon = "",
			},
			["QUESTION"] = {
				preview = "Question ",
				icon = "",
			},
			["HELP"] = {
				preview = "Help" ,
				icon = "",
			},
			["FAQ"] = {
				preview = "Faq ",
				icon = "",
			},
			["FAILURE"] = {
				preview = "Failure ",
				icon = "",
			},
			["FAIL"] = {
				preview = "Fail ",
				icon = "",
			},
			["MISSING"] = {
				preview = "Missing ",
				icon = "",
			},
			["DANGER"] = {
				preview = "Danger ",
				icon = "",
			},
			["ERROR"] = {
				preview = "Error ",
				icon = "",
			},
			["BUG"] = {
				preview = "Bug ",
				icon = "",
			},
			["EXAMPLE"] = {
				preview = "Example ",
				icon = "",
			},
			["QUOTE"] = {
				preview = "Quote ",
				icon = "",
			},
			["CITE"] = {
				preview = "Cite ",
				icon = "",
			},
			["HINT"] = {
				preview = "Hint ",
				icon = "",
			},
			["ATTENTION"] = {
				preview = "Attention ",
				icon = "",
			},


			["NOTE"] = {
				preview = " Note ",
			},
			["TIP"] = {
				preview = " Tip ",
			},
			["IMPORTANT"] = {
				preview = " Important ",
			},
			["WARNING"] = {
				preview = " Warning ",
			},
			["CAUTION"] = {
				preview = " Caution",
			}
		},

		headings = {
			heading_1 = {
				sign = "",
				icon = ""
			},
			heading_2 = {
				sign = "",
				icon = ""
			},
			heading_3 = {
				icon = ""
			},
			heading_4 = {
				icon = ""
			},
			heading_5 = {
				icon = ""
			},
			heading_6 = {
				icon = ""
			},

			setext_1 = {
				sign = "",
				icon = ""
			},
			setext_2 = {
				sign = "",
				icon = ""
			}
		},

		reference_definitions = links,
	},
	markdown_inline = {
		block_references = {
			default = {
				icon = "↗ ",
			},
		},

		checkboxes = {
			checked = { text = "✔" },
			unchecked = { text = "✘" },

			["/"] = { text = "/" },
			[">"] = { text = ">" },
			["<"] = { text = "<" },
			["-"] = { text = "-" },

			["?"] = { text = "?" },
			["!"] = { text = "!" },
			["*"] = { text = "*" },
			['"'] = { text = '"' },
			["l"] = { text = "l" },
			["b"] = { text = "b" },
			["i"] = { text = "i" },
			["S"] = { text = "S" },
			["I"] = { text = "I" },
			["p"] = { text = "p" },
			["c"] = { text = "c" },
			["f"] = { text = "f" },
			["k"] = { text = "k" },
			["w"] = { text = "w" },
			["u"] = { text = "u" },
			["d"] = { text = "d" },
		},

		emails = {
			default = {
				icon = "📨 ",
			},

			["%@gmail%.com$"] = {
				icon = "📨 ",
			},

			["%@outlook%.com$"] = {
				icon = "📨 ",
			},

			["%@yahoo%.com$"] = {
				icon = "📨 ",
			},

			["%@icloud%.com$"] = {
				icon = "📨 ",
			}
		},

		embed_files = {
			default = {
				icon = "↗ ",
			}
		},

		footnotes = {
			default = {
				icon = "↗ ",
			},

			["^%d+$"] = {
				icon = "↗ ",
			}
		},

		hyperlinks = links,

		images = {
			default = {
				icon = "🌄 ",
			},

			["%.svg$"] = { icon = "🌄 " },
			["%.png$"] = { icon = "🌄 " },
			["%.jpg$"] = { icon = "🌄 " },
			["%.gif$"] = { icon = "🌄 " },
			["%.pdf$"] = { icon = "🌄 " }
		},

		internal_links = {
			default = {
				icon = "↗ ",
			},
		},

		uri_autolinks = links,
	},
	html = {
		container_elements = {
			["^a$"] = {
				on_opening_tag = { conceal = "", virt_text_pos = "inline", virt_text = { { "↗ ", "MarkviewHyperlink" } } },
			},
		},

		void_elements = {
			["^br$"] = {
				on_node = {
					virt_text = {
						{ "⤵", "Comment" },
					}
				}
			},
		}
	},
	latex = {
		blocks = {
			text = " LaTeX ",
		},

		commands = {
			["vec"] = {
				condition = function (item)
					return #item.args == 1;
				end,
				on_command = {
					conceal = ""
				},

				on_args = {
					{
						on_before = function (item)
							return {
								end_col = item.range[2] + 1,
								conceal = "",

								virt_text_pos = "inline",
								virt_text = {
									{ "", "MarkviewPalette2Fg" },
									{ "(", "@punctuation.bracket.latex" }
								},

								hl_mode = "combine"
							}
						end,

						after_offset = function (range)
							return { range[1], range[2], range[3], range[4] - 1 };
						end,
						on_after = function (item)
							return {
								end_col = item.range[4],
								conceal = "",

								virt_text_pos = "inline",
								virt_text = {
									{ ")", "@punctuation.bracket" }
								},

								hl_mode = "combine"
							}
						end
					}
				}
			},
		},
	},
	typst = {
		code_blocks = {
			text = "Code",
		},

		headings = {
			heading_1 = {
				sign = "",
				icon = " ",
			},
			heading_2 = {
				sign = "",
				icon = " "
			},
			heading_3 = {
				icon = " "
			},
			heading_4 = {
				icon = " "
			},
			heading_5 = {
				icon = " "
			},
			heading_6 = {
				icon = " "
			}
		},

		labels = {
			default = {
				icon = "◪ ",
			}
		},


		math_blocks = {
			text = " Math ",
		},

		reference_links = {
			default = {
				icon = "↗ ",
			},
		},

		terms = {
			default = {
				text = "↗ ",
			},
		},

		url_links = links
	},
	yaml = {
		enable = false,
	}
};

return presets;
