---@type markview.config.asciidoc_inline
return {
	bolds = { enable = true },
	italics = { enable = true },

	monospaces = {
		enable = true,
		hl = "MarkviewInlineCode",

		padding_left = " ",
		padding_right = " "
	},

	highlights = {
		enable = true,

		default = {
			padding_left = " ",
			padding_right = " ",

			hl = "MarkviewPalette3"
		}
	},
};
