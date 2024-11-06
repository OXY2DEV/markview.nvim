local spec = {};

spec.cache = {
	winopts = {}
};

spec.default = {
	highlight_groups = "dynamic",
	renderers = {},

	splitview = {
		window = function ()
			return {
				split = "above",
				height = math.floor(vim.o.lines * 0.25)
			}
		end
	},
	preview = {
		modes = { "n", "no", "c" },
		hybrid_modes = {},
		ignore_node_types = {
			-- markdown = { "code_blocks" }
		},

		auto_start = true,

		max_file_length = 1000,
		render_distance = 20,
		edit_distance = 1,
		debounce = 25,

		filetypes = { "markdown" },

		callbacks = {
			on_attach = function (_, wins)
				local preview_modes = spec.get("preview", "modes") or {};
				local hybrid_modes = spec.get("preview", "hybrid_modes") or {};

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
				local preview_modes = spec.get("preview", "modes") or {};
				local hybrid_modes = spec.get("preview", "hybrid_modes") or {};

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
		}
	},
	experimental = {
		list_empty_line_tolarance = 3
	};

	markdown = {
		block_quotes = {
			enable = true,

			default = {
				border = "▋", hl = "MarkviewBlockQuoteDefault"
			},

			callouts = {
				---+ ${conf, From Obsidian}
				{
					match_string = "ABSTRACT",
					preview = "󱉫 Abstract",
					hl = "MarkviewBlockQuoteNote",

					title = true,
					icon = "󱉫",

					border = "▋"
				},
				{
					match_string = "SUMMARY",
					hl = "MarkviewBlockQuoteNote",
					preview = "󱉫 Summary",

					title = true,
					icon = "󱉫",

					border = "▋"
				},
				{
					match_string = "TLDR",
					hl = "MarkviewBlockQuoteNote",
					preview = "󱉫 Tldr",

					title = true,
					icon = "󱉫",

					border = "▋"
				},
				{
					match_string = "TODO",
					hl = "MarkviewBlockQuoteNote",
					preview = " Todo",

					title = true,
					icon = "",

					border = "▋"
				},
				{
					match_string = "INFO",
					hl = "MarkviewBlockQuoteNote",
					preview = " Info",

					custom_title = true,
					icon = "",

					border = "▋"
				},
				{
					match_string = "SUCCESS",
					hl = "MarkviewBlockQuoteOk",
					preview = "󰗠 Success",

					title = true,
					icon = "󰗠",

					border = "▋"
				},
				{
					match_string = "CHECK",
					hl = "MarkviewBlockQuoteOk",
					preview = "󰗠 Check",

					title = true,
					icon = "󰗠",

					border = "▋"
				},
				{
					match_string = "DONE",
					hl = "MarkviewBlockQuoteOk",
					preview = "󰗠 Done",

					title = true,
					icon = "󰗠",

					border = "▋"
				},
				{
					match_string = "QUESTION",
					hl = "MarkviewBlockQuoteWarn",
					preview = "󰋗 Question",

					title = true,
					icon = "󰋗",

					border = "▋"
				},
				{
					match_string = "HELP",
					hl = "MarkviewBlockQuoteWarn",
					preview = "󰋗 Help",

					title = true,
					icon = "󰋗",

					border = "▋"
				},
				{
					match_string = "FAQ",
					hl = "MarkviewBlockQuoteWarn",
					preview = "󰋗 Faq",

					title = true,
					icon = "󰋗",

					border = "▋"
				},
				{
					match_string = "FAILURE",
					hl = "MarkviewBlockQuoteError",
					preview = "󰅙 Failure",

					title = true,
					icon = "󰅙",

					border = "▋"
				},
				{
					match_string = "FAIL",
					hl = "MarkviewBlockQuoteError",
					preview = "󰅙 Fail",

					title = true,
					icon = "󰅙",

					border = "▋"
				},
				{
					match_string = "MISSING",
					hl = "MarkviewBlockQuoteError",
					preview = "󰅙 Missing",

					title = true,
					icon = "󰅙",

					border = "▋"
				},
				{
					match_string = "DANGER",
					hl = "MarkviewBlockQuoteError",
					preview = " Danger",

					title = true,
					icon = "",

					border = "▋"
				},
				{
					match_string = "ERROR",
					hl = "MarkviewBlockQuoteError",
					preview = " Error",

					title = true,
					icon = "",

					border = "▋"
				},
				{
					match_string = "BUG",
					hl = "MarkviewBlockQuoteError",
					preview = " Bug",

					title = true,
					icon = "",

					border = "▋"
				},
				{
					match_string = "EXAMPLE",
					hl = "MarkviewBlockQuoteSpecial",
					preview = "󱖫 Example",

					title = true,
					icon = "󱖫",

					border = "▋"
				},
				{
					match_string = "QUOTE",
					hl = "MarkviewBlockQuoteDefault",
					preview = " Quote",

					title = true,
					icon = "",

					border = "▋"
				},
				{
					match_string = "CITE",
					hl = "MarkviewBlockQuoteDefault",
					preview = " Cite",

					title = true,
					icon = "",

					border = "▋"
				},
				{
					match_string = "HINT",
					hl = "MarkviewBlockQuoteOk",
					preview = " Hint",

					title = true,
					icon = "",

					border = "▋"
				},
				{
					match_string = "ATTENTION",
					hl = "MarkviewBlockQuoteWarn",
					preview = " Attention",

					title = true,
					icon = "",

					border = "▋"
				},
				---_
				---+ ${conf, From Github}
				{
					match_string = "NOTE",
					hl = "MarkviewBlockQuoteNote",
					preview = "󰋽 Note",

					border = "▋"
				},
				{
					match_string = "TIP",
					hl = "MarkviewBlockQuoteOk",
					preview = " Tip",

					border = "▋"
				},
				{
					match_string = "IMPORTANT",
					hl = "MarkviewBlockQuoteSpecial",
					preview = " Important",

					border = "▋"
				},
				{
					match_string = "WARNING",
					hl = "MarkviewBlockQuoteWarn",
					preview = " Warning",

					border = "▋"
				},
				{
					match_string = "CAUTION",
					hl = "MarkviewBlockQuoteError",
					preview = "󰳦 Caution",

					border = "▋"
				},
				---_

				---+ ${conf, Custom}
				{
					match_string = "CUSTOM",
					hl = "MarkviewBlockQuoteWarn",
					preview = "󰠳 Custom",

					custom_title = true,
					custom_icon = "󰠳",

					border = "▋"
				}
				---_
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

		horizontal_rules = {
			---+ ${class, Horizontal rules}
			enable = true,

			parts = {
				{
					---+ ${conf, Left portion}
					type = "repeating",
					repeat_amount = function () --[[@as function]]
						local textoff = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].textoff;

						return math.floor((vim.o.columns - textoff - 3) / 2);
					end,

					text = "─",
					hl = {
						"MarkviewGradient1", "MarkviewGradient2", "MarkviewGradient3", "MarkviewGradient4", "MarkviewGradient5", "MarkviewGradient6", "MarkviewGradient7", "MarkviewGradient8", "MarkviewGradient9", "MarkviewGradient10"
					}
					---_
				},
				{
					type = "text",
					text = "  ",
				},
				{
					---+ ${conf, Right portion}
					type = "repeating",
					repeat_amount = function () --[[@as function]]
						local textoff = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].textoff;

						return math.ceil((vim.o.columns - textoff - 3) / 2);
					end,

					direction = "right",
					text = "─",
					hl = {
						"MarkviewGradient1", "MarkviewGradient2", "MarkviewGradient3", "MarkviewGradient4", "MarkviewGradient5", "MarkviewGradient6", "MarkviewGradient7", "MarkviewGradient8", "MarkviewGradient9", "MarkviewGradient10"
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
			}
			---_
		},

		metadata_minus = {
			hl = "Code"
		},

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
			use_virt_lines = true
			---_
		},
	},
	markdown_inline = {
		inline_codes = {
			enable = true,
			hl = "InlineCode",

			padding_left = " ",
			padding_right = " "
		},

		emails = {
			enable = true,
			__emoji_link_compatability = true,

			icon = " ",
			hl = "MarkviewEmail"
		},

		uri_autolinks = {
			enable = true,
			__emoji_link_compatability = true,

			icon = " ",
			hl = "MarkviewEmail"
		},

		images = {
			enable = true,
			__emoji_link_compatability = true,

			icon = "󰥶 ",
			hl = "MarkviewImageLink",

			custom = {
				{ match_string = "%.svg$", icon = "󰜡 " },
			}
		},

		embed_files = {
			enable = true,

			icon = "󰠮 ",
			hl = "Special"
		},

		block_references = {
			enable = true,

			icon = "󰿨 ",
			hl = "Comment"
		},

		internal_links = {
			enable = true,
			__emoji_link_compatability = true,

			icon = "󰌷 ",
			hl = "MarkviewHyperlink",

			custom = {
			}
		},

		hyperlinks = {
			enable = true,
			__emoji_link_compatability = true,

			icon = "󰌷 ",
			hl = "MarkviewHyperlink",

			custom = {
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

		entities = {
			enable = true,
			hl = "Special"
		},

		checkboxes = {
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
					hl = "MarkviewCheckboxPending",
					scope_hl = "Special",
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
		},
	},
	html = {},
	latex = {
		brackets = {
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
	typst = {}
};

spec.config = spec.default;

---+${custom, Option maps}
spec.splitview = { "split_conf" };
spec.preview = {
	"modes", "hybrid_modes",
	"filetypes", "buf_ignore",
	"callbacks",
	"debounce",
	"ignore_nodes",
	"max_file_length", "render_distance"
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
		if vim.list_contains(spec.splitview, key) then
			_o.splitview[key] = value;
		elseif vim.list_contains(spec.preview, key) then
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


	--- Config parser functions go here!


	return _o;
end

spec.setup = function (config)
	config = spec.fix_config(config);
	spec.config = vim.tbl_deep_extend("force", spec.default, config);

	-- vim.print(config)
end

spec.get = function (...)
	local _o = spec.config;

	for _, key in ipairs({ ... }) do
		if _o[key] then
			_o = _o[key];
		else
			return;
		end
	end

	return _o;
end

return spec;
