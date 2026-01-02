return {
	enable = true,

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

	tasks = {
		default = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰋽 ",

			hl = "MarkviewPalette1",
		},
	},

	issues = {
		default = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰋽 ",

			hl = "MarkviewPalette6",
		},
	},
	mentions = {
		default = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰋽 ",

			hl = "MarkviewPalette6",
		},
	},
};
