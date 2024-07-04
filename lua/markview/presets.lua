local presets = {};

presets.heading = {
	---@type { group_name: string, value: table }[]
	glow_hls = {
		{
			group_name = "glow_h1",
			value = { bg = "#74c7ec", fg = "#1e1e2e", bold = true }
		},
	},

	---@type markview.render_config.headings
	glow = {
		enable = true,

		heading_1 = {
			style = "label",

			hl = "glow_h1",
			icon = "",

			padding_left = " ",
			padding_right = " "
		},
	},

	---@type { group_name: string, value: table }[]
	simple_hls = {
		{
			group_name = "simple_h1",
			value = { bg = "#453244", fg = "#f38ba8", bold = true }
		},
		{
			group_name = "simple_h2",
			value = { bg = "#46393e", fg = "#fab387", bold = true }
		},
		{
			group_name = "simple_h3",
			value = { bg = "#464245", fg = "#f9e2af", bold = true }
		},
		{
			group_name = "simple_h4",
			value = { bg = "#374243", fg = "#a6e3a1", bold = true }
		},
		{
			group_name = "simple_h5",
			value = { bg = "#2e3d51", fg = "#74c7ec", bold = true }
		},
		{
			group_name = "simple_h6",
			value = { bg = "#393b54", fg = "#b4befe", bold = true }
		},
	},

	---@type markview.render_config.headings
	simple = {
		enable = true,

		heading_1 = {
			style = "simple",

			hl = "simple_h1"
		},
		heading_2 = {
			style = "simple",

			hl = "simple_h2"
		},
		heading_3 = {
			style = "simple",

			hl = "simple_h3"
		},
		heading_4 = {
			style = "simple",

			hl = "simple_h4"
		},
		heading_5 = {
			style = "simple",

			hl = "simple_h5"
		},
		heading_6 = {
			style = "simple",

			hl = "simple_h6"
		},
	},

	---@type markview.render_config.headings
	simple_better = {
		enable = true,
		shift_width = 0,

		heading_1 = {
			style = "icon",

			icon = " ",
			hl = "simple_h1"
		},
		heading_2 = {
			style = "icon",

			icon = " ",
			hl = "simple_h2"
		},
		heading_3 = {
			style = "icon",

			icon = " ",
			hl = "simple_h3"
		},
		heading_4 = {
			style = "icon",

			icon = " ",
			hl = "simple_h4"
		},
		heading_5 = {
			style = "icon",

			icon = " ",
			hl = "simple_h5"
		},
		heading_6 = {
			style = "icon",

			icon = " ",
			hl = "simple_h6"
		},
	},

	---@type { group_name: string, value: table }[]
	label_hls = {
		{
			group_name = "label_h1",
			value = { bg = "#f38ba8", fg = "#313244", bold = true }
		},
		{
			group_name = "label_h2",
			value = { bg = "#fab387", fg = "#313244", bold = true }
		},
		{
			group_name = "label_h3",
			value = { bg = "#f9e2af", fg = "#313244", bold = true }
		},
		{
			group_name = "label_h4",
			value = { bg = "#a6e3a1", fg = "#313244", bold = true }
		},
		{
			group_name = "label_h5",
			value = { bg = "#74c7ec", fg = "#313244", bold = true }
		},
		{
			group_name = "label_h6",
			value = { bg = "#b4befe", fg = "#313244", bold = true }
		},
	},

	---@type { group_name: string, value: table }[]
	label_hls_dark = {
		{
			group_name = "label_h1",
			value = { bg = "#453244", fg = "#f38ba8", bold = true }
		},
		{
			group_name = "label_h2",
			value = { bg = "#46393e", fg = "#fab387", bold = true }
		},
		{
			group_name = "label_h3",
			value = { bg = "#464245", fg = "#f9e2af", bold = true }
		},
		{
			group_name = "label_h4",
			value = { bg = "#374243", fg = "#a6e3a1", bold = true }
		},
		{
			group_name = "label_h5",
			value = { bg = "#2e3d51", fg = "#74c7ec", bold = true }
		},
		{
			group_name = "label_h6",
			value = { bg = "#393b54", fg = "#b4befe", bold = true }
		},
	},

	---@type markview.render_config.headings
	label = {
		enable = true,
		shift_width = 0,

		heading_1 = {
			style = "label",

			padding_left = " ",
			padding_right = " ",

			hl = "label_h1"
		},
		heading_2 = {
			style = "label",

			padding_left = " ",
			padding_right = " ",

			hl = "label_h2"
		},
		heading_3 = {
			style = "label",

			padding_left = " ",
			padding_right = " ",

			hl = "label_h3"
		},
		heading_4 = {
			style = "label",

			padding_left = " ",
			padding_right = " ",

			hl = "label_h4"
		},
		heading_5 = {
			style = "label",

			padding_left = " ",
			padding_right = " ",

			hl = "label_h5"
		},
		heading_6 = {
			style = "label",

			padding_left = " ",
			padding_right = " ",

			hl = "label_h6"
		},
	},

	---@type { group_name: string, value: table }[]
	decorated_hls = {
		{
			group_name = "decorated_h1",
			value = { bg = "#f38ba8", fg = "#313244", bold = true }
		},
		{
			group_name = "decorated_h1_inv",
			value = { fg = "#f38ba8", bold = true }
		},
		{
			group_name = "decorated_h2",
			value = { bg = "#fab387", fg = "#313244", bold = true }
		},
		{
			group_name = "decorated_h2_inv",
			value = { fg = "#fab387", bold = true }
		},
		{
			group_name = "decorated_h3",
			value = { bg = "#f9e2af", fg = "#313244", bold = true }
		},
		{
			group_name = "decorated_h3_inv",
			value = { fg = "#f9e2af", bold = true }
		},
		{
			group_name = "decorated_h4",
			value = { bg = "#a6e3a1", fg = "#313244", bold = true }
		},
		{
			group_name = "decorated_h4_inv",
			value = { fg = "#a6e3a1", bold = true }
		},
		{
			group_name = "decorated_h5",
			value = { bg = "#74c7ec", fg = "#313244", bold = true }
		},
		{
			group_name = "decorated_h5_inv",
			value = { fg = "#74c7ec", bold = true }
		},
		{
			group_name = "decorated_h6",
			value = { bg = "#b4befe", fg = "#313244", bold = true }
		},
		{
			group_name = "decorated_h6_inv",
			value = { fg = "#b4befe", bold = true }
		},
	},

	---@type { group_name: string, value: table }[]
	decorated_hls_dark = {
		{
			group_name = "decorated_h1",
			value = { bg = "#453244", fg = "#f38ba8", bold = true }
		},
		{
			group_name = "decorated_h1_inv",
			value = { fg = "#453244", bold = true }
		},
		{
			group_name = "decorated_h2",
			value = { bg = "#46393e", fg = "#fab387", bold = true }
		},
		{
			group_name = "decorated_h2_inv",
			value = { fg = "#46393e", bold = true }
		},
		{
			group_name = "decorated_h3",
			value = { bg = "#464245", fg = "#f9e2af", bold = true }
		},
		{
			group_name = "decorated_h3_inv",
			value = { fg = "#464245", bold = true }
		},
		{
			group_name = "decorated_h4",
			value = { bg = "#374243", fg = "#a6e3a1", bold = true }
		},
		{
			group_name = "decorated_h4_inv",
			value = { fg = "#374243", bold = true }
		},
		{
			group_name = "decorated_h5",
			value = { bg = "#2e3d51", fg = "#74c7ec", bold = true }
		},
		{
			group_name = "decorated_h5_inv",
			value = { fg = "#2e3d51", bold = true }
		},
		{
			group_name = "decorated_h6",
			value = { bg = "#393b54", fg = "#b4befe", bold = true }
		},
		{
			group_name = "decorated_h6_inv",
			value = { fg = "#393b54", bold = true }
		},
	},


	---@type markview.render_config.headings
	decorated = {
		enable = true,
		shift_width = 0,

		heading_1 = {
			style = "label",

			padding_left = " ",
			padding_right = " ",

			corner_right = "",
			corner_right_hl = "decorated_h1_inv",

			hl = "decorated_h1"
		},
		heading_2 = {
			style = "label",

			padding_left = " ",
			padding_right = " ",

			corner_right = "",
			corner_right_hl = "decorated_h2_inv",

			hl = "decorated_h2"
		},
		heading_3 = {
			style = "label",

			padding_left = " ",
			padding_right = " ",

			corner_right = "",
			corner_right_hl = "decorated_h3_inv",

			hl = "decorated_h3"
		},
		heading_4 = {
			style = "label",

			padding_left = " ",
			padding_right = " ",

			corner_right = "",
			corner_right_hl = "decorated_h4_inv",

			hl = "decorated_h4"
		},
		heading_5 = {
			style = "label",

			padding_left = " ",
			padding_right = " ",

			corner_right = "",
			corner_right_hl = "decorated_h5_inv",

			hl = "decorated_h5"
		},
		heading_6 = {
			style = "label",

			padding_left = " ",
			padding_right = " ",

			corner_right = "",
			corner_right_hl = "decorated_h6_inv",

			hl = "decorated_h6"
		},
	},
};

return presets;
