--- Configuration specification file
--- for `markview.nvim`.
---
--- It has the following tasks,
---    • Maintain backwards compatibility
---    • Check for issues with config
local spec = {};
local symbols = require("markview.symbols");

--- Creates a configuration table 
---@param name any
---@param text_pos any
---@param cmd_conceal any
---@param cmd_hl any
---@return table
local operator = function (name, text_pos, cmd_conceal, cmd_hl)
	---+${func}
	return {
		condition = function (item)
			return #item.args == 1;
		end,


		on_command = function (item)
			return {
				end_col = item.range[2] + (cmd_conceal or 1),
				conceal = "",

				virt_text_pos = text_pos or "overlay",
				virt_text = {
					{ symbols.tostring("default", name), cmd_hl }
				},

				hl_mode = "combine"
			}
		end,

		on_args = {
			{
				before = function (item)
					return {
						end_col = item.range[2] + 1,

						virt_text_pos = "overlay",
						virt_text = {
							{ "(", "italic" }
						},

						hl_mode = "combine"
					}
				end,

				after_offset = function (range)
					return { range[1], range[2], range[3], range[4] - 1 };
				end,

				after = function (item)
					return {
						end_col = item.range[4],

						virt_text_pos = "overlay",
						virt_text = {
							{ ")", "italic" }
						},

						hl_mode = "combine"
					}
				end
			}
		}
	};
	---_
end

spec.warnings = {};

spec.notify = function (chunks, opts)
	if not opts then opts = {}; end

	vim.api.nvim_echo(
		vim.list_extend(
			{
				{
					"█",
					opts.deprecated and "DiagnosticError" or "DiagnosticWarn"
				},
				{ " markview: ", "Special" }
			},
			chunks
		),
		true,
		{}
	);
	table.insert(spec.warnings, opts);
end

---@type markview.configuration
spec.default = {
	---+${conf}
	highlight_groups = {},

	renderers = {},

	experimental = {
		---+${conf}
		file_byte_read = 1000,
		text_filetypes = nil,
		list_empty_line_tolerance = 3
		---_
	};

	preview = {
		---+${conf}
		callbacks = {
			---+${func}
			on_attach = function (_, wins)
				local preview_modes = spec.get({ "preview", "modes" }) or {};
				local hybrid_modes = spec.get({ "preview", "hybrid_modes" }) or {};

				local concealcursor = "";

				for _, mde in ipairs(preview_modes) do
					if
						vim.list_contains(hybrid_modes, mde) == false and
						vim.list_contains({ "n", "v", "i", "c" }, mde)
					then
						concealcursor = concealcursor .. mde;
					end
				end

				for _, win in ipairs(wins) do
					vim.wo[win].conceallevel = 3;
					vim.wo[win].concealcursor = concealcursor;
				end
			end,
			on_detach = function (_, wins)
				for _, win in ipairs(wins) do
					vim.wo[win].conceallevel = 0;
					vim.wo[win].concealcursor = "";
				end
			end,

			on_mode_change = function (_, wins, mode)
				local preview_modes = spec.get({ "preview", "modes" }) or {};
				local hybrid_modes = spec.get({ "preview", "hybrid_modes" }) or {};

				local concealcursor = "";

				for _, mde in ipairs(preview_modes) do
					if
						vim.list_contains(hybrid_modes, mde) == false and
						vim.list_contains({ "n", "v", "i", "c" }, mde)
					then
						concealcursor = concealcursor .. mde;
					end
				end

				for _, win in ipairs(wins) do
					if
						vim.list_contains(preview_modes, mode) and
						require("markview").state.enable == true
					then
						vim.wo[win].conceallevel = 3;
						vim.wo[win].concealcursor = concealcursor;
					else
						vim.wo[win].conceallevel = 0;
						vim.wo[win].concealcursor = "";
					end
				end
			end
			---_
		},

		debounce = 50,
		edit_distance = { 1, 0 },
		enable_preview_on_attach = true,

		filetypes = { "markdown", "typst" },
		hybrid_modes = {},
		ignore_buftypes = { "nofile" },
		ignore_node_classes = {
			-- markdown = { "code_blocks" }
		},
		max_file_length = 1000,
		modes = { "n", "no", "c" },
		render_distance = vim.o.lines,
		splitview_winopts = {}
		---_
	},

	markdown = {
		tables = {
			---+ ${class, Tables}
			enable = true,

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
			},

			hl = {
				top = { "TableHeader", "TableHeader", "TableHeader", "TableHeader" },
				header = { "TableHeader", "TableHeader", "TableHeader" },
				separator = { "TableHeader", "TableHeader", "TableHeader", "TableHeader" },
				row = { "TableBorder", "TableBorder", "TableBorder" },
				bottom = { "TableBorder", "TableBorder", "TableBorder", "TableBorder" },

				overlap = { "TableBorder", "TableBorder", "TableBorder", "TableBorder" },

				align_left = "TableAlignLeft",
				align_right = "TableAlignRight",
				align_center = { "TableAlignCenter", "TableAlignCenter" }
			},

			col_min_width = 10,
			block_decorator = true,
			use_virt_lines = false
			---_
		},

		block_quotes = {
			enable = true,

			default = {
				border = "▋", hl = "MarkviewBlockQuoteDefault"
			},

			["abstract"] = {
				preview = "󱉫 Abstract",
				hl = "MarkviewBlockQuoteNote",

				title = true,
				icon = "󱉫",

				border = "▋"
			},
			["SUMMARY"] = {
				hl = "MarkviewBlockQuoteNote",
				preview = "󱉫 Summary",

				title = true,
				icon = "󱉫",

				border = "▋"
			},
			["TLDR"] = {
				hl = "MarkviewBlockQuoteNote",
				preview = "󱉫 Tldr",

				title = true,
				icon = "󱉫",

				border = "▋"
			},
			["TODO"] = {
				hl = "MarkviewBlockQuoteNote",
				preview = " Todo",

				title = true,
				icon = "",

				border = "▋"
			},
			["INFO"] = {
				hl = "MarkviewBlockQuoteNote",
				preview = " Info",

				custom_title = true,
				icon = "",

				border = "▋"
			},
			["SUCCESS"] = {
				hl = "MarkviewBlockQuoteOk",
				preview = "󰗠 Success",

				title = true,
				icon = "󰗠",

				border = "▋"
			},
			["CHECK"] = {
				hl = "MarkviewBlockQuoteOk",
				preview = "󰗠 Check",

				title = true,
				icon = "󰗠",

				border = "▋"
			},
			["DONE"] = {
				hl = "MarkviewBlockQuoteOk",
				preview = "󰗠 Done",

				title = true,
				icon = "󰗠",

				border = "▋"
			},
			["QUESTION"] = {
				hl = "MarkviewBlockQuoteWarn",
				preview = "󰋗 Question",

				title = true,
				icon = "󰋗",

				border = "▋"
			},
			["HELP"] = {
				hl = "MarkviewBlockQuoteWarn",
				preview = "󰋗 Help",

				title = true,
				icon = "󰋗",

				border = "▋"
			},
			["FAQ"] = {
				hl = "MarkviewBlockQuoteWarn",
				preview = "󰋗 Faq",

				title = true,
				icon = "󰋗",

				border = "▋"
			},
			["FAILURE"] = {
				hl = "MarkviewBlockQuoteError",
				preview = "󰅙 Failure",

				title = true,
				icon = "󰅙",

				border = "▋"
			},
			["FAIL"] = {
				hl = "MarkviewBlockQuoteError",
				preview = "󰅙 Fail",

				title = true,
				icon = "󰅙",

				border = "▋"
			},
			["MISSING"] = {
				hl = "MarkviewBlockQuoteError",
				preview = "󰅙 Missing",

				title = true,
				icon = "󰅙",

				border = "▋"
			},
			["DANGER"] = {
				hl = "MarkviewBlockQuoteError",
				preview = " Danger",

				title = true,
				icon = "",

				border = "▋"
			},
			["ERROR"] = {
				hl = "MarkviewBlockQuoteError",
				preview = " Error",

				title = true,
				icon = "",

				border = "▋"
			},
			["BUG"] = {
				hl = "MarkviewBlockQuoteError",
				preview = " Bug",

				title = true,
				icon = "",

				border = "▋"
			},
			["EXAMPLE"] = {
				hl = "MarkviewBlockQuoteSpecial",
				preview = "󱖫 Example",

				title = true,
				icon = "󱖫",

				border = "▋"
			},
			["QUOTE"] = {
				hl = "MarkviewBlockQuoteDefault",
				preview = " Quote",

				title = true,
				icon = "",

				border = "▋"
			},
			["CITE"] = {
				hl = "MarkviewBlockQuoteDefault",
				preview = " Cite",

				title = true,
				icon = "",

				border = "▋"
			},
			["HINT"] = {
				hl = "MarkviewBlockQuoteOk",
				preview = " Hint",

				title = true,
				icon = "",

				border = "▋"
			},
			["ATTENTION"] = {
				hl = "MarkviewBlockQuoteWarn",
				preview = " Attention",

				title = true,
				icon = "",

				border = "▋"
			},


			["NOTE"] = {
				match_string = "NOTE",
				hl = "MarkviewBlockQuoteNote",
				preview = "󰋽 Note",

				border = "▋"
			},
			["TIP"] = {
				match_string = "TIP",
				hl = "MarkviewBlockQuoteOk",
				preview = " Tip",

				border = "▋"
			},
			["IMPORTANT"] = {
				match_string = "IMPORTANT",
				hl = "MarkviewBlockQuoteSpecial",
				preview = " Important",

				border = "▋"
			},
			["WARNING"] = {
				match_string = "WARNING",
				hl = "MarkviewBlockQuoteWarn",
				preview = " Warning",

				border = "▋"
			},
			["CAUTION"] = {
				match_string = "CAUTION",
				hl = "MarkviewBlockQuoteError",
				preview = "󰳦 Caution",

				border = "▋"
			}
		},

		code_blocks = {
			---+${conf, Code blocks}
			enable = true,
			icons = "internal",

			style = "block",
			hl = "MarkviewCode",
			info_hl = "MarkviewCodeInfo",

			min_width = 60,
			pad_amount = 3,

			language_names = nil,
			language_direction = "right",

			sign = true, sign_hl = nil
			---_
		},

		headings = {
			---+ ${class, Headings}
			enable = true,
			shift_width = 1,

			heading_1 = {
				---+ ${conf, Heading 1}
				style = "icon",
				sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",

				icon = "󰼏  ", hl = "MarkviewHeading1",
				---_
			},
			heading_2 = {
				---+ ${conf, Heading 2}
				style = "icon",
				sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",
	
				icon = "󰎨  ", hl = "MarkviewHeading2",
				---_
			},
			heading_3 = {
				---+ ${conf, Heading 3}
				style = "icon",
	
				icon = "󰼑  ", hl = "MarkviewHeading3",
				---_
			},
			heading_4 = {
				---+ ${conf, Heading 4}
				style = "icon",
	
				icon = "󰎲  ", hl = "MarkviewHeading4",
				---_
			},
			heading_5 = {
				---+ ${conf, Heading 5}
				style = "icon",
	
				icon = "󰼓  ", hl = "MarkviewHeading5",
				---_
			},
			heading_6 = {
				---+ ${conf, Heading 6}
				style = "icon",
	
				icon = "󰎴  ", hl = "MarkviewHeading6",
				---_
			},

			setext_1 = {
				---+ ${conf, Setext heading 1}
				style = "decorated",

				sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",
				icon = "  ", hl = "MarkviewHeading1",
				border = "▂"
				---_
			},
			setext_2 = {
				---+ ${conf, Setext heading 2}
				style = "decorated",

				sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",
				icon = "  ", hl = "MarkviewHeading2",
				border = "▁"
				---_
			}
			---_
		},

		horizontal_rules = {
			---+ ${class, Horizontal rules}
			enable = true,

			parts = {
				{
					---+ ${conf, Left portion}
					type = "repeating",
					repeat_amount = function (buffer) --[[@as function]]
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
					---_
				},
				{
					type = "text",
					text = "  ",
					hl = "MarkviewIcon3Fg"
				},
				{
					---+ ${conf, Right portion}
					type = "repeating",
					repeat_amount = function (buffer) --[[@as function]]
						local utils = require("markview.utils");
						local window = utils.buf_getwin(buffer)

						local width = vim.api.nvim_win_get_width(window)
						local textoff = vim.fn.getwininfo(window)[1].textoff;

						return math.ceil((width - textoff - 3) / 2);
					end,

					direction = "right",
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
					---_
				}
			}
			---_
		},

		list_items = {
			---+${conf, List items}
			enable = true,

			indent_size = 2,
			shift_width = 4,

			marker_minus = {
				add_padding = true,
				conceal_on_checkboxes = true,

				text = "",
				hl = "MarkviewListItemMinus"
			},

			marker_plus = {
				add_padding = true,
				conceal_on_checkboxes = true,

				text = "",
				hl = "MarkviewListItemPlus"
			},

			marker_star = {
				add_padding = true,
				conceal_on_checkboxes = true,

				text = "",
				hl = "MarkviewListItemStar"
			},

			marker_dot = {
				add_padding = true,
				conceal_on_checkboxes = true,
			},

			marker_parenthesis = {
				add_padding = true,
				conceal_on_checkboxes = true,
			}
			---_
		},

		metadata_minus = {
			hl = "Code",
			border_hl = "CodeFg",

			border_top = "▄",
			border_bottom = "▀"
		},

		metadata_plus = {
			hl = "Code",
			border_hl = "CodeFg",

			border_top = "▄",
			border_bottom = "▀"
		},
	},
	markdown_inline = {
		block_references = {
			enable = true,

			default = {
				icon = "󰿨 ",
				hl = "Comment"
			}
		},

		checkboxes = {
			---+ ${conf, Minimal style checkboxes}
			enable = true,

			checked = { text = "󰗠", hl = "MarkviewCheckboxChecked" },
			unchecked = { text = "󰄰", hl = "MarkviewCheckboxUnchecked" },

			["/"] = { text = "󱎖", hl = "MarkviewCheckboxPending", scope_hl = "Special" },
			[">"] = { text = "", hl = "MarkviewCheckboxCancelled" },
			["<"] = { text = "󰃖", hl = "MarkviewCheckboxCancelled" },
			["-"] = { text = "󰍶", hl = "MarkviewCheckboxCancelled", scope_hl = "MarkviewCheckboxStriked" },

			["?"] = { text = "󰋗", hl = "MarkviewCheckboxPending" },
			["!"] = { text = "󰀦", hl = "MarkviewCheckboxUnchecked" },
			["*"] = { text = "󰓎", hl = "MarkviewCheckboxPending" },
			["'"] = { text = "󰸥", hl = "MarkviewCheckboxCancelled" },
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
			---_
		},

		entities = {
			enable = true,
			hl = "Special"
		},

		footnotes = {
			enable = true,

			default = {
				icon = "󰽒",
				hl = "MarkviewEmail"
			}
		},

		highlights = {
			default = {
				hl = "MarkviewHeading1"
			}
		},

		inline_codes = {
			enable = true,
			hl = "InlineCode",

			padding_left = " ",
			padding_right = " "
		},

		emails = {
			enable = true,

			default = {
				icon = " ",
				hl = "MarkviewEmail"
			}
		},

		uri_autolinks = {
			enable = true,

			default = {
				icon = " ",
				hl = "MarkviewEmail"
			}
		},

		images = {
			enable = true,
			__emoji_link_compatibility = true,

			default = {
				icon = "󰥶 ",
				hl = "MarkviewImage",
			},

			patterns = {
				{ match_string = "%.svg$", icon = "󰜡 " },
			}
		},

		embed_files = {
			enable = true,

			default = {
				icon = "󰠮 ",
				hl = "Special"
			}
		},

		internal_links = {
			enable = true,
			__emoji_link_compatibility = true,

			default = {
				icon = "󰌷 ",
				hl = "MarkviewHyperlink",
			},

			patterns = {
			}
		},

		hyperlinks = {
			enable = true,
			__emoji_link_compatibility = true,

			default = {
				icon = "󰌷 ",
				hl = "MarkviewHyperlink",
			},

			patterns = {
				---+ ${conf, Stack*}
				{ match_string = "stackoverflow%.com", icon = " " },
				{ match_string = "stackexchange%.com", icon = " " },
				---_

				{ match_string = "neovim%.org", icon = " " },

				{ match_string = "dev%.to", icon = " " },
				{ match_string = "github%.com", icon = " " },
				{ match_string = "reddit%.com", icon = " " },
				{ match_string = "freecodecamp%.org", icon = " " },

				{ match_string = "https://(.+)$", icon = "󰞉 " },
				{ match_string = "http://(.+)$", icon = "󰕑 " },
				{ match_string = "[%.]md$", icon = " " }
			}
		},

		escapes = {
			enable = true
		},
	},
	html = {
		headings = {
			enable = true,

			heading_1 = {
				hl_group = "MarkviewHeading1"
			},
			heading_2 = {
				hl_group = "MarkviewHeading2"
			},
			heading_3 = {
				hl_group = "MarkviewHeading3"
			},
			heading_4 = {
				hl_group = "MarkviewHeading4"
			},
			heading_5 = {
				hl_group = "MarkviewHeading5"
			},
			heading_6 = {
				hl_group = "MarkviewHeading6"
			},
		},
		container_elements = {
			enable = true,
			-- ["i"] = {
			-- 	on_opening_tag = { conceal = "" },
			-- 	on_closing_tag = { conceal = "" },
			-- }
		},
		void_elements = {
			enable = true,
			-- ["img"] = {
			-- 	on_node = { conceal = "" }
			-- }
		}
	},
	latex = {
		commands = {
			["frac"] = {
				condition = function (item)
					return #item.args == 2;
				end,
				on_command = {
					conceal = ""
				},

				on_args = {
					{
						before = function (item)
							return {
								end_col = item.range[2] + 1,
								conceal = "",

								virt_text_pos = "inline",
								virt_text = {
									{ "(" }
								}
							}
						end,

						after_offset = function (range)
							return { range[1], range[2], range[3], range[4] - 1 };
						end,
						after = function (item)
							return {
								end_col = item.range[4],
								conceal = "",

								virt_text_pos = "inline",
								virt_text = {
									{ ")" },
									{ " ÷ " }
								}
							}
						end
					}
				}
			},

			["sin"] = operator("sin"),
			["cos"] = operator("cos"),
			["tan"] = operator("tan"),

			["sinh"] = operator("sinh"),
			["cosh"] = operator("cosh"),
			["tanh"] = operator("tanh"),

			["csc"] = operator("csc"),
			["sec"] = operator("sec"),
			["cot"] = operator("cot"),

			["csch"] = operator("csch"),
			["sech"] = operator("sech"),
			["coth"] = operator("coth"),

			["arcsin"] = operator("arcsin"),
			["arccos"] = operator("arccos"),
			["arctan"] = operator("arctan"),

			["arg"] = operator("arg"),
			["deg"] = operator("deg"),
			["det"] = operator("det"),
			["dim"] = operator("dim"),
			["exp"] = operator("exp"),
			["gcd"] = operator("gcd"),
			["hom"] = operator("hom"),
			["inf"] = operator("inf"),
			["ker"] = operator("ker"),
			["lg"] = operator("lg"),

			["lim"] = operator("lim"),
			["liminf"] = operator("lim inf", "inline", 7, "@markup.math.latex"),
			["limsup"] = operator("lim sup", "inline", 7, "@markup.math.latex"),

			["ln"] = operator("ln"),
			["log"] = operator("log"),
			["min"] = operator("min"),
			["max"] = operator("max"),
			["Pr"] = operator("Pr"),
			["sup"] = operator("sup"),
			["sqrt"] = operator(symbols.entries.sqrt, "inline", 5, "@markup.math.latex"),
			["lvert"] = operator(symbols.entries.vert, "inline", 6, "@markup.math.latex"),
			["lVert"] = operator(symbols.entries.Vert, "inline", 6, "@markup.math.latex"),
		},
		parenthesis = {
			enable = true,
			left = "(",
			right = "(",
			hl = "Special"
		},

		escapes = { enable = true },
		symbols = { enable = true, hl = "Comment" },
		fonts = { enable = true },
		subscripts = { enable = true, hl = "LatexSubscript" },
		superscripts = { enable = true, hl = "LatexSuperscript" },
		texts = { enable = true },

		inlines = {
			enable = true,

			padding_left = " ",
			padding_right = " ",

			hl = "InlineCode"
		},
		blocks = {
			enable = true,
			hl = "Code",
			text = "  LaTeX ",
			text_hl = "CodeInfo",

			pad_amount = 3,
			pad_char = " "
		},
	},
	typst = {
		headings = {
			---+ ${class, Headings}
			enable = true,
			shift_width = 1,

			heading_1 = {
				---+ ${conf, Heading 1}
				style = "icon",
				sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",

				icon = "󰼏  ", hl = "MarkviewHeading1",
				---_
			},
			heading_2 = {
				---+ ${conf, Heading 2}
				style = "icon",
				sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",
	
				icon = "󰎨  ", hl = "MarkviewHeading2",
				---_
			},
			heading_3 = {
				---+ ${conf, Heading 3}
				style = "icon",
	
				icon = "󰼑  ", hl = "MarkviewHeading3",
				---_
			},
			heading_4 = {
				---+ ${conf, Heading 4}
				style = "icon",
	
				icon = "󰎲  ", hl = "MarkviewHeading4",
				---_
			},
			heading_5 = {
				---+ ${conf, Heading 5}
				style = "icon",
	
				icon = "󰼓  ", hl = "MarkviewHeading5",
				---_
			},
			heading_6 = {
				---+ ${conf, Heading 6}
				style = "icon",
	
				icon = "󰎴  ", hl = "MarkviewHeading6",
				---_
			},

			setext_1 = {
				---+ ${conf, Setext heading 1}
				style = "decorated",
	
				sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",
				icon = "  ", hl = "MarkviewHeading1",
				line = "▂"
				---_
			},
			setext_2 = {
				---+ ${conf, Setext heading 2}
				style = "decorated",

				sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",
				icon = "  ", hl = "MarkviewHeading2",
				line = "▁"
				---_
			}
			---_
		},

		codes = {
			style = "block",
			text_direction = "right",
			min_width = 60,

			text = "󰣖 Code",

			hl = "Code",
			text_hl = "Icon5"
		},

		raw_blocks = {
			style = "block",
			icons = "internal",
			language_direction = "right",

			min_width = 60,
			pad_amount = 3,

			hl = "Code"
		},

		escapes = { enable = true },

		labels = {
			hl = "InlineCode",
			padding_left = " ",
			padding_right = " "
		},

		list_items = {
			---+${conf, List items}
			enable = true,

			indent_size = 2,
			shift_width = 4,

			marker_minus = {
				add_padding = true,

				text = "",
				hl = "MarkviewListItemMinus"
			},

			marker_plus = {
				add_padding = true,

				text = "%d)",
				hl = "MarkviewListItemPlus"
			},

			marker_dot = {
				add_padding = true,
			}
			---_
		},

		raw_spans = {
			enable = true,

			padding_left = " ",
			padding_right = " ",

			hl = "InlineCode"
		},
		blocks = {
			enable = true,
			hl = "Code",
			text = "  LaTeX ",
			text_hl = "CodeInfo",

			pad_amount = 3,
			pad_char = " "
		},

		url_links = {
			enable = true,
			__emoji_link_compatibility = true,

			icon = " ",
			hl = "MarkviewEmail"
		},

		reference_links = {
			icon = " ",
			hl = "Hyperlink"
		},

		terms = {
			text = " ",
		}
	},
	yaml = {
		properties = {
			enable = true,
			hl = {
				["aliases"]    = "MarkviewIcon3",
				["cssclasses"] = "MarkviewIcon5",
				["checkbox"]   = "MarkviewIcon6",
				["date"]       = "MarkviewIcon2",
				["list"]       = "MarkviewIcon5",
				["number"]     = "MarkviewIcon6",
				["nil"]        = "MarkviewIcon1",
				["string"]     = "MarkviewIcon4",
				["tags"]       = "MarkviewIcon6",
				["time"]       = "MarkviewIcon3",
				["unknown"]    = "MarkviewIcon2"
			},
			text = {
				["aliases"]    = " 󱞫 ",
				["cssclasses"] = "  ",
				["checkbox"]   = " 󰄵 ",
				["date"]       = " 󰃭 ",
				["list"]       = " 󱉯 ",
				["number"]     = "  ",
				["nil"]        = "  ",
				["string"]     = "  ",
				["tags"]       = " 󰓻 ",
				["time"]       = " 󱑂 ",
				["unknown"]    = "  "
			}
		}
	}
	---_
};

spec.config = spec.default;

---+${custom, Option maps}
spec.preview = {
	"modes", "hybrid_modes",
	"filetypes", "buf_ignore",
	"callbacks",
	"debounce",
	"ignore_nodes",
	"max_file_length", "render_distance",
	"split_conf"
};
spec.experimental = {};

spec.markdown = {
	"block_quotes",
	"code_blocks",
	"footnotes",
	"headings",
	"horizontal_rules",
	"list_items",
	"tables"
};
spec.markdown_inline = {
	"checkboxes",
	"inline_codes",
	"links"
};
spec.html = {};
spec.latex = {};
spec.typst = {};
---_


spec.__preview = function (config)
	---+${func}
	for opt, val in pairs(config) do
		if opt == "buf_ignore" then
			spec.notify({
				{ " preview.buf_ignore ", "DiagnosticVirtualTextInfo" },
				{ " is deprecated! Use " },
				{ " preview.ignore_buftypes ", "DiagnosticVirtualTextHint" },
				{ " instead."},
			}, {
				class = "markview_opt_name_change",

				old = "preview.buf_ignore",
				new = "preview.ignore_buftypes"
			});

			config["ignore_buftypes"] = val;
			config["buf_ignore"] = nil;
		elseif opt == "debounce" then
			spec.notify({
				{ " preview.debounce ", "DiagnosticVirtualTextInfo" },
				{ " is deprecated! Use " },
				{ " preview.debounce_delay ", "DiagnosticVirtualTextHint" },
				{ " instead."},
			}, {
				class = "markview_opt_name_change",

				old = "preview.debounce",
				new = "preview.debounce_delay"
			});

			config["debounce_delay"] = val;
			config["debounce"] = nil;
		elseif opt == "ignore_nodes" then
			spec.notify({
				{ " preview.ignore_nodes ", "DiagnosticVirtualTextError" },
				{ " is deprecated! Use " },
				{ " preview.ignore_node_classes ", "DiagnosticVirtualTextHint" },
				{ " instead."},
			}, {
				class = "markview_opt_name_change",

				old = "preview.ignore_nodes",
				new = "preview.ignore_node_classes",

				deprecated = true
			});

			config["ignore_nodes"] = nil;
		elseif opt == "initial_state" then
			spec.notify({
				{ " preview.initial_state ", "DiagnosticVirtualTextInfo" },
				{ " is deprecated! Use " },
				{ " preview.enable_preview_on_attach ", "DiagnosticVirtualTextHint" },
				{ " instead."},
			}, {
				class = "markview_opt_name_change",

				old = "preview.initial_state",
				new = "preview.enable_preview_on_attach",

				deprecated = true
			});

			config["enable_preview_on_attach"] = val;
			config["initial_state"] = nil;
		elseif opt == "split_conf" then
			spec.notify({
				{ " preview.split_conf ", "DiagnosticVirtualTextInfo" },
				{ " is deprecated! Use " },
				{ " preview.splitview_winopts ", "DiagnosticVirtualTextHint" },
				{ " instead."},
			}, {
				class = "markview_opt_name_change",

				old = "preview.split_conf",
				new = "preview.splitview_winopts"
			});

			config["splitview_winopts"] = val;
			config["split_conf"] = nil;
		end
	end

	return config;
	---_
end

spec.__markdown = function (config)
	---+${func}
	for opt, val in pairs(config) do
		if
			opt == "block_quotes" and
			vim.islist(val.callouts)
		then
			spec.notify({
				{ " markdown.block_quotes.callouts ", "DiagnosticVirtualTextError" },
				{ " is deprecated!" },
			}, {
				class = "markview_opt_deprecated",
				deprecated = true,

				old = "preview.buf_ignore",
				new = "preview.ignore_buftypes"
			});

			local _n = {};

			for _, item in ipairs(val.callouts) do
				_n[string.lower(item.match_string)] = {
					hl = item.hl,
					preview = item.preview,
					preview_hl = item.preview_hl,

					title = item.title,
					icon = item.icon,

					border = item.border,
					border_hl = item.border_hl
				}
			end

			config["block_quotes"] = vim.tbl_extend("keep", {
				enable = val.enable,
				default = val.default or {}
			}, _n);
		elseif
			opt == "tables" and
			(
				vim.islist(val.parts) or
				vim.islist(val.hls)
			)
		then
			local _p, _h = val.parts, val.hls;
			local np, nh = {
				top = {},
				header = {},
				separator = {},
				row = {},
				bottom = {},

				align_left = nil,
				align_right = nil,
				align_center = {}
			}, val.hl or {
				top = {},
				header = {},
				separator = {},
				row = {},
				bottom = {},

				align_left = nil,
				align_right = nil,
				align_center = {}
			};

			if vim.islist(_p) then
				spec.notify({
					{ " markdown.tables.parts ", "DiagnosticVirtualTextInfo" },
					{ " should be a " },
					{ "table", "DiagnosticOk" },
					{ "! Got "},
					{ "list", "DiagnosticWarn" },
					{ ". "},
				}, {
					class = "markview_opt_invalid_type",

					should_be = "table",
					is = "list"
				});

				for p, part in ipairs(_p) do
					if vim.list_contains({ 1, 2, 3, 4 }, p) then
						np.top[p] = part;

						if p == 2 then
							np.separator[2] = part;
						end
					elseif p == 5 then
						np.separator[1] = part;
					elseif p == 6 then
						np.header[1] = part;
						np.header[2] = part;
						np.header[3] = part;

						np.row[1] = part;
						np.row[2] = part;
						np.row[3] = part;
					elseif p == 7 then
						np.separator[3] = part;
					elseif p == 8 then
						np.separator[4] = part;
					elseif vim.list_contains({ 9, 10, 11, 12 }, p) then
						np.bottom[p - 8] = part;
					elseif vim.list_contains({ 13, 14 }, p) then
						np.align_center[p - 12] = part;
					elseif p == 15 then
						np.align_left = part;
					else
						np.align_right = part;
					end
				end
			end

			if vim.islist(_h) then
				spec.notify({
					{ " markdown.tables.hls ", "DiagnosticVirtualTextInfo" },
					{ " is deprecated! Use " },
					{ " markdown.tables.hl ", "DiagnosticVirtualTextHint" },
					{ " instead."},
				}, {
					class = "markview_opt_name_change",
					deprecated = true,

					old = "markdown.tables.hls",
					new = "markdown.tables.hl"
				});

				spec.notify({
					{ " markdown.tables.hl ", "DiagnosticVirtualTextInfo" },
					{ " should be a " },
					{ "table", "DiagnosticOk" },
					{ "! Got "},
					{ "list", "DiagnosticWarn" },
					{ ". "},
				}, {
					class = "markview_opt_invalid_type",

					should_be = "table",
					is = "list"
				});

				for p, part in ipairs(_h) do
					if vim.list_contains({ 1, 2, 3, 4 }, p) then
						nh.top[p] = part;

						if p == 2 then
							nh.separator[2] = part;
						end
					elseif p == 5 then
						nh.separator[1] = part;
					elseif p == 6 then
						nh.header[1] = part;
						nh.header[2] = part;
						nh.header[3] = part;

						nh.row[1] = part;
						nh.row[2] = part;
						nh.row[3] = part;
					elseif p == 7 then
						nh.separator[3] = part;
					elseif p == 8 then
						nh.separator[4] = part;
					elseif vim.list_contains({ 9, 10, 11, 12 }, p) then
						nh.bottom[p - 8] = part;
					elseif vim.list_contains({ 13, 14 }, p) then
						nh.align_center[p - 12] = part;
					elseif p == 15 then
						nh.align_left = part;
					else
						nh.align_right = part;
					end
				end
			end

			---@type markdown.tables
			config["tables"] = {
				enable = val.enable,
				hl = nh,
				parts = np,
				use_virt_lines = val.use_virt_lines,
				block_decorator = val.block_decorator
			};
		end
	end

	return config;
	---_
end

spec.__markdown_inline = function (config)
	---+${func}
	for opt, val in pairs(config) do
		if
			opt == "checkboxes" and
			vim.islist(val.custom)
		then
			spec.notify({
				{ " markdown_inline.checkboxes.custom ", "DiagnosticVirtualTextError" },
				{ " is deprecated!" },
			}, {
				class = "markview_opt_deprecated",
				deprecated = true,

				old = "preview.buf_ignore",
				new = "preview.ignore_buftypes"
			});

			local _n = {};

			for _, item in ipairs(val.custom) do
				_n[string.lower(item.match_string)] = {
					hl = item.hl,
					scope_hl = item.scope_hl,
					text = item.text,
				}
			end

			config["checkboxes"] = vim.tbl_extend("keep", {
				enable = val.enable,
				checked = val.checked,
				unchecked = val.unchecked,
			}, _n);
		elseif
			vim.list_contains({ "footnotes", "emails", "uri_autolinks", "images", "embed_files", "internal_links", "hyperlinks" }, opt) and
			(val.text or val.hl)
		then
			if val.text then
				spec.notify({
					{ " markdown_inline." .. opt .. ".text ", "DiagnosticVirtualTextError" },
					{ " is deprecated! Use" },
					{ " markdown_inline." .. opt .. ".default.text ", "DiagnosticVirtualTextHint" },
					{ "instead." },
				}, {
					class = "markview_opt_deprecated",

					old = "preview.buf_ignore",
					new = "preview.ignore_buftypes"
				});
			end

			if val.hl then
				spec.notify({
					{ " markdown_inline." .. opt .. ".hl ", "DiagnosticVirtualTextError" },
					{ " is deprecated! Use" },
					{ " markdown_inline." .. opt .. ".default.hl ", "DiagnosticVirtualTextHint" },
					{ "instead." },
				}, {
					class = "markview_opt_deprecated",

					old = "preview.buf_ignore",
					new = "preview.ignore_buftypes"
				});
			end

			if val.custom then
				spec.notify({
					{ " markdown_inline." .. opt .. ".custom ", "DiagnosticVirtualTextError" },
					{ " is deprecated! Use" },
					{ " markdown_inline." .. opt .. ".patterns ", "DiagnosticVirtualTextHint" },
					{ "instead." },
				}, {
					class = "markview_opt_deprecated",

					old = "preview.buf_ignore",
					new = "preview.ignore_buftypes"
				});
			end

			config[opt] = {
				enable = val.enable,
				default = val.default or { text = val.text, hl = val.hl },

				patterns = val.patterns or val.custom
			};
		end
	end

	return config;
	---_
end

spec.fix_config = function (config)
	if type(config) ~= "table" then
		return {};
	end

	local _o = {
		renderers = config.renderers or {},

		splitview = config.splitview or {},
		preview = config.preview or {},
		experimental = config.experimental or {};

		markdown = config.markdown or {},
		markdown_inline = config.markdown_inline or {},
		html = config.html or {},
		latex = config.latex or {},
		typst = config.typst or {}
	};

	for key, value in pairs(config) do
		if vim.list_contains(spec.preview, key) then
			_o.preview[key] = value;
		elseif vim.list_contains(spec.experimental, key) then
			_o.experimental[key] = value;
		elseif vim.list_contains(spec.markdown, key) then
			_o.markdown[key] = value;
		elseif vim.list_contains(spec.markdown_inline, key) then
			_o.markdown_inline[key] = value;
		elseif vim.list_contains(spec.html, key) then
			_o.html[key] = value;
		elseif vim.list_contains(spec.latex, key) then
			_o.latex[key] = value
		elseif vim.list_contains(spec.typst, key) then
			_o.typst[key] = value;
		end
	end

	for k, v in pairs(_o) do
		if spec["__" .. k] then
			_o[k] = spec["__" .. k](v);
		end
	end

	return _o;
end

spec.setup = function (config)
	config = spec.fix_config(config);
	spec.config = vim.tbl_deep_extend("force", spec.default, config);

	-- vim.print(config)
end

spec.get = function (opts, func, ...)
	local _o = spec.config;

	for _, key in ipairs(opts or {}) do
		if _o[key] then
			if _o.enable == false then
				return;
			end

			_o = _o[key];
		else
			return;
		end
	end

	if func and pcall(_o, ...) then
		return _o(...);
	end

	return _o;
end

-- local k = vim.tbl_keys(spec.default.markdown);
-- table.sort(k)
-- vim.print(k)
return spec;
