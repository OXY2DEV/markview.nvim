return {
	enable = true,

	properties = {
		enable = true,

		data_types = {
			["text"] = {
				text = "󰗊 ", hl = "MarkviewIcon4"
			},
			["list"] = {
				text = "󰝖 ", hl = "MarkviewIcon5"
			},
			["number"] = {
				text = " ", hl = "MarkviewIcon6"
			},
			["checkbox"] = {
				---@diagnostic disable
				text = function (_, item)
					return item.value == "true" and "󰄲 " or "󰄱 "
				end,
				---@diagnostic enable
				hl = "MarkviewIcon6"
			},
			["date"] = {
				text = "󰃭 ", hl = "MarkviewIcon2"
			},
			["date_&_time"] = {
				text = "󰥔 ", hl = "MarkviewIcon3"
			}
		},

		default = {
			use_types = true,

			border_top = nil,
			border_middle = nil,
			border_bottom = nil,

			border_hl = nil,
		},

		["^tags$"] = {
			use_types = false,

			text = "󰓹 ",
			hl = "MarkviewIcon0"
		},
		["^aliases$"] = {
			match_string = "^aliases$",
			use_types = false,

			text = "󱞫 ",
			hl = "MarkviewIcon2"
		},
		["^cssclasses$"] = {
			match_string = "^cssclasses$",
			use_types = false,

			text = " ",
			hl = "MarkviewIcon3"
		},


		["^publish$"] = {
			match_string = "^publish$",
			use_types = false,

			text = "󰅧 ",
			hl = "MarkviewIcon5"
		},
		["^permalink$"] = {
			match_string = "^permalink$",
			use_types = false,

			text = " ",
			hl = "MarkviewIcon2"
		},
		["^description$"] = {
			match_string = "^description$",
			use_types = false,

			text = "󰋼 ",
			hl = "MarkviewIcon0"
		},
		["^image$"] = {
			match_string = "^image$",
			use_types = false,

			text = "󰋫 ",
			hl = "MarkviewIcon4"
		},
		["^cover$"] = {
			match_string = "^cover$",
			use_types = false,

			text = "󰹉 ",
			hl = "MarkviewIcon2"
		}
	}
};
