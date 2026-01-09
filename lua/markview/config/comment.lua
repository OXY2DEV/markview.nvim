---@type markview.config.comment
return {
	enable = true,

	autolinks = {
		enable = true,

		default = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰋽 ",

			hl = "MarkviewPalette6",
		},
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

	inline_codes = {
		padding_left = " ",
		padding_right = " ",

		hl = "MarkviewInlineCode",
	},

	issues = {
		enable = true,

		default = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰋽 ",

			hl = "MarkviewPalette6",
		},
	},

	mentions = {
		enable = true,

		default = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰋽 ",

			hl = "MarkviewPalette6",
		},
	},

	taglinks = {
		enable = true,

		default = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰋽 ",

			hl = "MarkviewPalette6",
		},
	},

	tasks = {
		enable = true,

		default = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰄰 ",

			hl = "MarkviewPalette1",
		},

		["^feat"] = {
			padding_left = " ",
			padding_right = " ",

			icon = "󱕅 ",

			hl = "MarkviewPalette7",
		},

		praise = {
			padding_left = " ",
			padding_right = " ",

			icon = "󱥋 ",

			hl = "MarkviewPalette3",
		},

		["^suggest"] = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰣖 ",

			hl = "MarkviewPalette2",
		},

		thought = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰧑 ",

			hl = "MarkviewPalette0",
		},

		note = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰠮 ",

			hl = "MarkviewPalette5",
		},

		["^info"] = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰋼 ",

			hl = "MarkviewPalette0",
		},

		xxx = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰓽 ",

			hl = "MarkviewPalette0",
		},

		["^nit"] = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰩰 ",

			hl = "MarkviewPalette6",
		},

		["^warn"] = {
			padding_left = " ",
			padding_right = " ",

			icon = " ",

			hl = "MarkviewPalette3",
		},

		fix = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰁨 ",

			hl = "MarkviewPalette7",
		},

		hack = {
			padding_left = " ",
			padding_right = " ",

			icon = "󱍔 ",

			hl = "MarkviewPalette1",
		},

		typo = {
			padding_left = " ",
			padding_right = " ",

			icon = " ",

			hl = "MarkviewPalette0",
		},

		wip = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰦖 ",

			hl = "MarkviewPalette2",
		},

		issue = {
			padding_left = " ",
			padding_right = " ",

			icon = " ",

			hl = "MarkviewPalette1",
		},

		["error"] = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰅙 ",

			hl = "MarkviewPalette1",
		},

		fixme = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰶯 ",

			hl = "MarkviewPalette4",
		},

		deprecated = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰩆 ",

			hl = "MarkviewPalette1",
		},
	},

	urls = {
		enable = true,

		default = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰋽 ",

			hl = "MarkviewPalette6",
		},
	},
};
