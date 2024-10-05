local presets = {};

---@type { [string]: markview.conf.checkboxes }
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
			icon = "󰼏  ", hl = "MarkviewHeading1",

		},
		heading_2 = {
			style = "label",
			sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",

			padding_left = " ", padding_right = " ",
			icon = "󰎨  ", hl = "MarkviewHeading2",
		},
		heading_3 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			icon = "󰼑  ", hl = "MarkviewHeading3",
		},
		heading_4 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			icon = "󰎲  ", hl = "MarkviewHeading4",
		},
		heading_5 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			icon = "󰼓  ", hl = "MarkviewHeading5",
		},
		heading_6 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			icon = "󰎴  ", hl = "MarkviewHeading6",
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
			icon = "󰼏  ", hl = "MarkviewHeading1",

		},
		heading_2 = {
			style = "label",
			sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",
			align = "center",

			padding_left = " ", padding_right = " ",
			icon = "󰎨  ", hl = "MarkviewHeading2",
		},
		heading_3 = {
			style = "label",
			align = "center",

			padding_left = " ", padding_right = " ",
			icon = "󰼑  ", hl = "MarkviewHeading3",
		},
		heading_4 = {
			style = "label",
			align = "center",

			padding_left = " ", padding_right = " ",
			icon = "󰎲  ", hl = "MarkviewHeading4",
		},
		heading_5 = {
			style = "label",
			align = "center",

			padding_left = " ", padding_right = " ",
			icon = "󰼓  ", hl = "MarkviewHeading5",
		},
		heading_6 = {
			style = "label",
			align = "center",

			padding_left = " ", padding_right = " ",
			icon = "󰎴  ", hl = "MarkviewHeading6",
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
			corner_right = "", corner_right_hl = "MarkviewHeading1Sign",
			icon = "󰼏  ", hl = "MarkviewHeading1",

		},
		heading_2 = {
			style = "label",
			sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewHeading2Sign",
			icon = "󰎨  ", hl = "MarkviewHeading2",
		},
		heading_3 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewHeading3Sign",
			icon = "󰼑  ", hl = "MarkviewHeading3",
		},
		heading_4 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewHeading4Sign",
			icon = "󰎲  ", hl = "MarkviewHeading4",
		},
		heading_5 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewHeading5Sign",
			icon = "󰼓  ", hl = "MarkviewHeading5",
		},
		heading_6 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewHeading6Sign",
			icon = "󰎴  ", hl = "MarkviewHeading6",
		}
		---_
	},
	arrow = {
		---+ ${conf, Arrow cornered headings}
		enable = true,
		shift_width = 0,

		heading_1 = {
			style = "label",
			sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewHeading1Sign",
			icon = "󰼏  ", hl = "MarkviewHeading1",

		},
		heading_2 = {
			style = "label",
			sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewHeading2Sign",
			icon = "󰎨  ", hl = "MarkviewHeading2",
		},
		heading_3 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewHeading3Sign",
			icon = "󰼑  ", hl = "MarkviewHeading3",
		},
		heading_4 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewHeading4Sign",
			icon = "󰎲  ", hl = "MarkviewHeading4",
		},
		heading_5 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewHeading5Sign",
			icon = "󰼓  ", hl = "MarkviewHeading5",
		},
		heading_6 = {
			style = "label",

			padding_left = " ", padding_right = " ",
			corner_right = "", corner_right_hl = "MarkviewHeading6Sign",
			icon = "󰎴  ", hl = "MarkviewHeading6",
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

			icon = "█ ", icon_hl = "MarkviewHeading5Sign",
			hl = "MarkviewHeading6",
		}
		---_
	}
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

return presets;
