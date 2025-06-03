--- Configuration specification file
--- for `markview.nvim`.
---
--- It has the following tasks,
---    • Maintain backwards compatibility
---    • Check for issues with config
local spec = {};
local health = require("markview.health");

--- Creates a configuration table for a LaTeX command.
---@param name string Command name(Text to show).
---@param text_pos? "overlay" | "inline" `virt_text_pos` extmark options.
---@param cmd_conceal? integer Characters to conceal.
---@param cmd_hl? string Highlight group for the command.
---@return commands.opts
local operator = function (name, text_pos, cmd_conceal, cmd_hl)
	return {
		condition = function (item)
			return #item.args == 1;
		end,

		on_command = function (item)
			local symbols = require("markview.symbols");

			return {
				end_col = item.range[2] + (cmd_conceal or 1),
				conceal = "",

				virt_text_pos = text_pos or "overlay",
				virt_text = {
					{ symbols.tostring("default", name), cmd_hl or "@keyword.function" }
				},

				hl_mode = "combine"
			}
		end,

		on_args = {
			{
				on_before = function (item)
					return {
						end_col = item.range[2] + 1,

						virt_text_pos = "overlay",
						virt_text = {
							{ "(", "@punctuation.bracket" }
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

						virt_text_pos = "overlay",
						virt_text = {
							{ ")", "@punctuation.bracket" }
						},

						hl_mode = "combine"
					}
				end
			}
		}
	};
end

spec.warnings = {};

--- `vim.notify()` with extra steps.
---@param chunks [ string, string? ][]
---@param opts { silent: boolean, level: integer? }
spec.notify = function (chunks, opts)
	if not opts then opts = {}; end

	local highlights = {
		[vim.log.levels.DEBUG] = "DiagnosticInfo",
		[vim.log.levels.ERROR] = "DiagnosticError",
		[vim.log.levels.INFO] = "DiagnosticInfo",
		[vim.log.levels.OFF] = "Comment",
		[vim.log.levels.TRACE] = "DiagnosticInfo",
		[vim.log.levels.WARN] = "DiagnosticWarn"
	};

	vim.api.nvim_echo(
		vim.list_extend(
			{
				{
					"󰇈 markview",
					highlights[opts.level or vim.log.levels.WARN]
				},
				{ ": " }
			},
			chunks
		),
		true,
		{}
	);

	if opts.silent ~= true then
		table.insert(spec.warnings, opts);
	end
end

---@type markview.config
spec.default = {
	experimental = {
		date_formats = {
			"^%d%d%d%d%-%d%d%-%d%d$",      --- YYYY-MM-DD
			"^%d%d%-%d%d%-%d%d%d%d$",      --- DD-MM-YYYY, MM-DD-YYYY
			"^%d%d%-%d%d%-%d%d$",          --- DD-MM-YY, MM-DD-YY, YY-MM-DD

			"^%d%d%d%d%/%d%d%/%d%d$",      --- YYYY/MM/DD
			"^%d%d%/%d%d%/%d%d%d%d$",      --- DD/MM/YYYY, MM/DD/YYYY

			"^%d%d%d%d%.%d%d%.%d%d$",      --- YYYY.MM.DD
			"^%d%d%.%d%d%.%d%d%d%d$",      --- DD.MM.YYYY, MM.DD.YYYY

			"^%d%d %a+ %d%d%d%d$",         --- DD Month YYYY
			"^%a+ %d%d %d%d%d%d$",         --- Month DD, YYYY
			"^%d%d%d%d %a+ %d%d$",         --- YYYY Month DD

			"^%a+%, %a+ %d%d%, %d%d%d%d$", --- Day, Month DD, YYYY
		},

		date_time_formats = {
			"^%a%a%a %a%a%a %d%d %d%d%:%d%d%:%d%d ... %d%d%d%d$", --- UNIX date time
			"^%d%d%d%d%-%d%d%-%d%dT%d%d%:%d%d%:%d%dZ$",           --- ISO 8601
		},

		prefer_nvim = false,
		file_open_command = "tabnew",

		list_empty_line_tolerance = 3,

		read_chunk_size = 1024,
	};

	highlight_groups = {},

	preview = {
		enable = true,
		enable_hybrid_mode = true,

		callbacks = {
			on_attach = function (_, wins)
				--- Initial state for attached buffers.
				---@type string
				local attach_state = spec.get({ "preview", "enable" }, { fallback = true, ignore_enable = true });

				if attach_state == false then
					--- Attached buffers will not have their previews
					--- enabled.
					--- So, don't set options.
					return;
				end

				for _, win in ipairs(wins) do
					--- Preferred conceal level should
					--- be 3.
					vim.wo[win].conceallevel = 3;
				end
			end,

			on_detach = function (_, wins)
				for _, win in ipairs(wins) do
					--- Only set `conceallevel`.
					--- `concealcursor` will be
					--- set via `on_hybrid_disable`.
					vim.wo[win].conceallevel = 0;
				end
			end,

			on_enable = function (_, wins)
				--- Initial state for attached buffers.
				---@type string
				local attach_state = spec.get({ "preview", "enable" }, { fallback = true, ignore_enable = true });

				if attach_state == false then
					-- If the window's aren't initially
					-- attached, we need to set the 
					-- 'concealcursor' too.

					---@type string[]
					local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
					---@type string[]
					local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });

					local concealcursor = "";

					for _, mode in ipairs(preview_modes) do
						if vim.list_contains(hybrid_modes, mode) == false and vim.list_contains({ "n", "v", "i", "c" }, mode) then
							concealcursor = concealcursor .. mode;
						end
					end

					for _, win in ipairs(wins) do
						vim.wo[win].conceallevel = 3;
						vim.wo[win].concealcursor = concealcursor;
					end
				else
					for _, win in ipairs(wins) do
						vim.wo[win].conceallevel = 3;
					end
				end
			end,

			on_disable = function (_, wins)
				for _, win in ipairs(wins) do
					vim.wo[win].conceallevel = 0;
				end
			end,

			on_hybrid_enable = function (_, wins)
				---@type string[]
				local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
				---@type string[]
				local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });

				local concealcursor = "";

				for _, mode in ipairs(preview_modes) do
					if vim.list_contains(hybrid_modes, mode) == false and vim.list_contains({ "n", "v", "i", "c" }, mode) then
						concealcursor = concealcursor .. mode;
					end
				end

				for _, win in ipairs(wins) do
					vim.wo[win].concealcursor = concealcursor;
				end
			end,

			on_hybrid_disable = function (_, wins)
				---@type string[]
				local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
				local concealcursor = "";

				for _, mode in ipairs(preview_modes) do
					if vim.list_contains({ "n", "v", "i", "c" }, mode) then
						concealcursor = concealcursor .. mode;
					end
				end

				for _, win in ipairs(wins) do
					vim.wo[win].concealcursor = concealcursor;
				end
			end,

			on_mode_change = function (_, wins, current_mode)
				---@type string[]
				local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
				---@type string[]
				local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });

				local concealcursor = "";

				for _, mode in ipairs(preview_modes) do
					if vim.list_contains(hybrid_modes, mode) == false and vim.list_contains({ "n", "v", "i", "c" }, mode) then
						concealcursor = concealcursor .. mode;
					end
				end

				for _, win in ipairs(wins) do
					if vim.list_contains(preview_modes, current_mode) then
						vim.wo[win].conceallevel = 3;
						vim.wo[win].concealcursor = concealcursor;
					else
						vim.wo[win].conceallevel = 0;
						vim.wo[win].concealcursor = "";
					end
				end
			end,

			on_splitview_open = function (_, _, win)
				vim.wo[win].conceallevel = 3;
				vim.wo[win].concealcursor = "n";
			end
		},

		map_gx = true,

		debounce = 150,
		icon_provider = "internal",

		filetypes = { "markdown", "quarto", "rmd", "typst" },
		ignore_buftypes = { "nofile" },
		raw_previews = {},

		modes = { "n", "no", "c" },
		hybrid_modes = {},

		linewise_hybrid_mode = false,
		max_buf_lines = 1000,

		draw_range = { 2 * vim.o.lines, 2 * vim.o.lines },
		edit_range = { 0, 0 },

		splitview_winopts = {
			split = "right"
		},
	},

	renderers = {},

	markdown = {
		enable = true,

		block_quotes = {
			enable = true,
			wrap = true,

			default = {
				border = "▋",
				hl = "MarkviewBlockQuoteDefault"
			},

			["ABSTRACT"] = {
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
			enable = true,

			style = "block",

			label_direction = "right",

			border_hl = "MarkviewCode",
			info_hl = "MarkviewCodeInfo",

			min_width = 60,
			pad_amount = 2,
			pad_char = " ",

			sign = true,

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
			}
		},

		headings = {
			enable = true,

			shift_width = 1,

			org_indent = false,
			org_indent_wrap = true,
			org_shift_char = " ",
			org_shift_width = 1,

			heading_1 = {
				style = "icon",
				sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",

				icon = "󰼏  ", hl = "MarkviewHeading1",
			},
			heading_2 = {
				style = "icon",
				sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",

				icon = "󰎨  ", hl = "MarkviewHeading2",
			},
			heading_3 = {
				style = "icon",

				icon = "󰼑  ", hl = "MarkviewHeading3",
			},
			heading_4 = {
				style = "icon",

				icon = "󰎲  ", hl = "MarkviewHeading4",
			},
			heading_5 = {
				style = "icon",

				icon = "󰼓  ", hl = "MarkviewHeading5",
			},
			heading_6 = {
				style = "icon",

				icon = "󰎴  ", hl = "MarkviewHeading6",
			},

			setext_1 = {
				style = "decorated",

				sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",
				icon = "  ", hl = "MarkviewHeading1",
				border = "▂"
			},
			setext_2 = {
				style = "decorated",

				sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",
				icon = "  ", hl = "MarkviewHeading2",
				border = "▁"
			}
		},

		horizontal_rules = {
			enable = true,

			parts = {
				{
					type = "repeating",
					direction = "left",

					repeat_amount = function (buffer)
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
				},
				{
					type = "text",

					text = "  ",
					hl = "MarkviewIcon3Fg"
				},
				{
					type = "repeating",
					direction = "right",

					repeat_amount = function (buffer) --[[@as function]]
						local utils = require("markview.utils");
						local window = utils.buf_getwin(buffer)

						local width = vim.api.nvim_win_get_width(window)
						local textoff = vim.fn.getwininfo(window)[1].textoff;

						return math.ceil((width - textoff - 3) / 2);
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
				}
			}
		},

		list_items = {
			enable = true,
			wrap = true,

			indent_size = function (buffer)
				if type(buffer) ~= "number" then
					return vim.bo.shiftwidth or 4;
				end

				--- Use 'shiftwidth' value.
				return vim.bo[buffer].shiftwidth or 4;
			end,
			shift_width = 4,

			marker_minus = {
				add_padding = true,
				conceal_on_checkboxes = true,

				text = "●",
				hl = "MarkviewListItemMinus"
			},

			marker_plus = {
				add_padding = true,
				conceal_on_checkboxes = true,

				text = "◈",
				hl = "MarkviewListItemPlus"
			},

			marker_star = {
				add_padding = true,
				conceal_on_checkboxes = true,

				text = "◇",
				hl = "MarkviewListItemStar"
			},

			marker_dot = {
				add_padding = true,
				conceal_on_checkboxes = true
			},

			marker_parenthesis = {
				add_padding = true,
				conceal_on_checkboxes = true
			}
		},

		metadata_minus = {
			enable = true,

			hl = "MarkviewCode",
			border_hl = "MarkviewCodeFg",

			border_top = "▄",
			border_bottom = "▀"
		},

		metadata_plus = {
			enable = true,

			hl = "MarkviewCode",
			border_hl = "MarkviewCodeFg",

			border_top = "▄",
			border_bottom = "▀"
		},

		reference_definitions = {
			enable = true,

			default = {
				icon = " ",
				hl = "MarkviewPalette4Fg"
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

		tables = {
			enable = true,
			strict = false,

			col_min_width = 10,
			block_decorator = true,
			use_virt_lines = false,

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
			}
		},
	},
	markdown_inline = {
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
	},
	html = {
		enable = true,

		container_elements = {
			enable = true,

			["^a$"] = {
				on_opening_tag = { conceal = "", virt_text_pos = "inline", virt_text = { { "", "MarkviewHyperlink" } } },
				on_node = { hl_group = "MarkviewHyperlink" },
				on_closing_tag = { conceal = "" },
			},
			["^b$"] = {
				on_opening_tag = { conceal = "" },
				on_node = { hl_group = "Bold" },
				on_closing_tag = { conceal = "" },
			},
			["^code$"] = {
				on_opening_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { " ", "MarkviewInlineCode" } } },
				on_node = { hl_group = "MarkviewInlineCode" },
				on_closing_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { " ", "MarkviewInlineCode" } } },
			},
			["^em$"] = {
				on_opening_tag = { conceal = "" },
				on_node = { hl_group = "@text.emphasis" },
				on_closing_tag = { conceal = "" },
			},
			["^i$"] = {
				on_opening_tag = { conceal = "" },
				on_node = { hl_group = "Italic" },
				on_closing_tag = { conceal = "" },
			},
			["^mark$"] = {
				on_opening_tag = { conceal = "" },
				on_node = { hl_group = "MarkviewPalette1" },
				on_closing_tag = { conceal = "" },
			},
			["^pre$"] = {
				on_opening_tag = { conceal = "" },
				on_node = { hl_group = "Special" },
				on_closing_tag = { conceal = "" },
			},
			["^strong$"] = {
				on_opening_tag = { conceal = "" },
				on_node = { hl_group = "@text.strong" },
				on_closing_tag = { conceal = "" },
			},
			["^sub$"] = {
				on_opening_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "↓[", "MarkviewSubscript" } } },
				on_node = { hl_group = "MarkviewSubscript" },
				on_closing_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "]", "MarkviewSubscript" } } },
			},
			["^sup$"] = {
				on_opening_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "↑[", "MarkviewSuperscript" } } },
				on_node = { hl_group = "MarkviewSuperscript" },
				on_closing_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "]", "MarkviewSuperscript" } } },
			},
			["^u$"] = {
				on_opening_tag = { conceal = "" },
				on_node = { hl_group = "Underlined" },
				on_closing_tag = { conceal = "" },
			},
		},

		headings = {
			enable = true,

			heading_1 = {
				hl_group = "MarkviewPalette1Bg"
			},
			heading_2 = {
				hl_group = "MarkviewPalette2Bg"
			},
			heading_3 = {
				hl_group = "MarkviewPalette3Bg"
			},
			heading_4 = {
				hl_group = "MarkviewPalette4Bg"
			},
			heading_5 = {
				hl_group = "MarkviewPalette5Bg"
			},
			heading_6 = {
				hl_group = "MarkviewPalette6Bg"
			},
		},

		void_elements = {
			enable = true,

			["^hr$"] = {
				on_node = {
					conceal = "",

					virt_text_pos = "inline",
					virt_text = {
						{ "─", "MarkviewGradient2" },
						{ "─", "MarkviewGradient3" },
						{ "─", "MarkviewGradient4" },
						{ "─", "MarkviewGradient5" },
						{ " ◉ ", "MarkviewGradient9" },
						{ "─", "MarkviewGradient5" },
						{ "─", "MarkviewGradient4" },
						{ "─", "MarkviewGradient3" },
						{ "─", "MarkviewGradient2" },
					}
				}
			},
			["^br$"] = {
				on_node = {
					conceal = "",

					virt_text_pos = "inline",
					virt_text = {
						{ "󱞦", "Comment" },
					}
				}
			},
		}
	},
	latex = {
		enable = true,

		blocks = {
			enable = true,

			hl = "MarkviewCode",
			pad_char = " ",
			pad_amount = 3,

			text = "  LaTeX ",
			text_hl = "MarkviewCodeInfo"
		},

		commands = {
			enable = true,

			["boxed"] = {
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
									{ " ", "MarkviewPalette4Fg" },
									{ "[", "@punctuation.bracket.latex" }
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
									{ "]", "@punctuation.bracket" }
								},

								hl_mode = "combine"
							}
						end
					}
				}
			},
			["frac"] = {
				condition = function (item)
					return #item.args == 2;
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
									{ "(", "@punctuation.bracket" }
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
									{ ")", "@punctuation.bracket" },
									{ " ÷ ", "@keyword.function" }
								},

								hl_mode = "combine"
							}
						end
					},
					{
						on_before = function (item)
							return {
								end_col = item.range[2] + 1,
								conceal = "",

								virt_text_pos = "inline",
								virt_text = {
									{ "(", "@punctuation.bracket" }
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
									{ ")", "@punctuation.bracket" },
								},

								hl_mode = "combine"
							}
						end
					},
				}
			},

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
									{ "󱈥 ", "MarkviewPalette2Fg" },
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
			["liminf"] = operator("lim inf", "inline", 7),
			["limsup"] = operator("lim sup", "inline", 7),

			["ln"] = operator("ln"),
			["log"] = operator("log"),
			["min"] = operator("min"),
			["max"] = operator("max"),
			["Pr"] = operator("Pr"),
			["sup"] = operator("sup"),
			["sqrt"] = function ()
				local symbols = require("markview.symbols");
				return operator(symbols.entries.sqrt, "inline", 5);
			end,
			["lvert"] = function ()
				local symbols = require("markview.symbols");
				return operator(symbols.entries.vert, "inline", 6);
			end,
			["lVert"] = function ()
				local symbols = require("markview.symbols");
				return operator(symbols.entries.Vert, "inline", 6);
			end,
		},

		escapes = {
			enable = true
		},

		fonts = {
			enable = true,

			default = {
				enable = true,
				hl = "MarkviewSpecial"
			},

			mathbf = { enable = true },
			mathbfit = { enable = true },
			mathcal = { enable = true },
			mathbfscr = { enable = true },
			mathfrak = { enable = true },
			mathbb = { enable = true },
			mathbffrak = { enable = true },
			mathsf = { enable = true },
			mathsfbf = { enable = true },
			mathsfit = { enable = true },
			mathsfbfit = { enable = true },
			mathtt = { enable = true },
			mathrm = { enable = true },
		},

		inlines = {
			enable = true,

			padding_left = " ",
			padding_right = " ",

			hl = "MarkviewInlineCode"
		},

		parenthesis = {
			enable = true,

			left = "(",
			right = "(",
			hl = "@punctuation.bracket"
		},

		subscripts = {
			enable = true,

			hl = "MarkviewSubscript"
		},

		superscripts = {
			enable = true,

			hl = "MarkviewSuperscript"
		},

		symbols = {
			enable = true,

			hl = "MarkviewComment"
		},

		texts = {
			enable = true
		},
	},
	typst = {
		enable = true,

		code_blocks = {
			enable = true,

			style = "block",
			text_direction = "right",

			min_width = 60,
			pad_amount = 3,
			pad_char = " ",

			text = "󰣖 Code",

			hl = "MarkviewCode",
			text_hl = "MarkviewIcon5"
		},

		code_spans = {
			enable = true,

			padding_left = " ",
			padding_right = " ",

			hl = "MarkviewCode"
		},

		escapes = {
			enable = true
		},

		headings = {
			enable = true,
			shift_width = 1,

			heading_1 = {
				style = "icon",
				sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",

				icon = "󰼏  ", hl = "MarkviewHeading1",
			},
			heading_2 = {
				style = "icon",
				sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",

				icon = "󰎨  ", hl = "MarkviewHeading2",
			},
			heading_3 = {
				style = "icon",

				icon = "󰼑  ", hl = "MarkviewHeading3",
			},
			heading_4 = {
				style = "icon",

				icon = "󰎲  ", hl = "MarkviewHeading4",
			},
			heading_5 = {
				style = "icon",

				icon = "󰼓  ", hl = "MarkviewHeading5",
			},
			heading_6 = {
				style = "icon",

				icon = "󰎴  ", hl = "MarkviewHeading6",
			}
		},

		labels = {
			enable = true,

			default = {
				hl = "MarkviewInlineCode",
				padding_left = " ",
				icon = " ",
				padding_right = " "
			}
		},

		list_items = {
			enable = true,

			indent_size = function (buffer)
				if type(buffer) ~= "number" then
					return vim.bo.shiftwidth or 4;
				end

				--- Use 'shiftwidth' value.
				return vim.bo[buffer].shiftwidth or 4;
			end,
			shift_width = 4,

			marker_minus = {
				add_padding = true,

				text = "●",
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
		},

		math_blocks = {
			enable = true,

			text = " 󰪚 Math ",
			pad_amount = 3,
			pad_char = " ",

			hl = "MarkviewCode",
			text_hl = "MarkviewCodeInfo"
		},

		math_spans = {
			enable = true,

			padding_left = " ",
			padding_right = " ",

			hl = "MarkviewInlineCode"
		},

		raw_blocks = {
			enable = true,

			style = "block",
			label_direction = "right",

			sign = true,

			min_width = 60,
			pad_amount = 3,
			pad_char = " ",

			border_hl = "MarkviewCode",

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
			}
		},

		raw_spans = {
			enable = true,

			padding_left = " ",
			padding_right = " ",

			hl = "MarkviewInlineCode"
		},

		reference_links = {
			enable = true,

			default = {
				icon = " ",
				hl = "MarkviewHyperlink"
			},
		},

		subscripts = {
			enable = true,

			hl = "MarkviewSubscript"
		},

		superscripts = {
			enable = true,

			hl = "MarkviewSuperscript"
		},

		symbols = {
			enable = true,

			hl = "Special"
		},

		terms = {
			enable = true,

			default = {
				text = " ",
				hl = "MarkviewPalette6Fg"
			},
		},

		url_links = {
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
		}
	},
	yaml = {
		enable = true,

		properties = {
			enable = true,

			data_types = {
				["text"] = {
					text = " 󰗊 ", hl = "MarkviewIcon4"
				},
				["list"] = {
					text = " 󰝖 ", hl = "MarkviewIcon5"
				},
				["number"] = {
					text = "  ", hl = "MarkviewIcon6"
				},
				["checkbox"] = {
					---@diagnostic disable
					text = function (_, item)
						return item.value == "true" and " 󰄲 " or " 󰄱 "
					end,
					---@diagnostic enable
					hl = "MarkviewIcon6"
				},
				["date"] = {
					text = " 󰃭 ", hl = "MarkviewIcon2"
				},
				["date_&_time"] = {
					text = " 󰥔 ", hl = "MarkviewIcon3"
				}
			},

			default = {
				use_types = true,

				border_top = " │ ",
				border_middle = " │ ",
				border_bottom = " ╰╸",

				border_hl = "MarkviewComment"
			},

			["^tags$"] = {
				match_string = "^tags$",
				use_types = false,

				text = " 󰓹 ",
				hl = nil
			},
			["^aliases$"] = {
				match_string = "^aliases$",
				use_types = false,

				text = " 󱞫 ",
				hl = nil
			},
			["^cssclasses$"] = {
				match_string = "^cssclasses$",
				use_types = false,

				text = "  ",
				hl = nil
			},


			["^publish$"] = {
				match_string = "^publish$",
				use_types = false,

				text = "  ",
				hl = nil
			},
			["^permalink$"] = {
				match_string = "^permalink$",
				use_types = false,

				text = "  ",
				hl = nil
			},
			["^description$"] = {
				match_string = "^description$",
				use_types = false,

				text = " 󰋼 ",
				hl = nil
			},
			["^image$"] = {
				match_string = "^image$",
				use_types = false,

				text = " 󰋫 ",
				hl = nil
			},
			["^cover$"] = {
				match_string = "^cover$",
				use_types = false,

				text = " 󰹉 ",
				hl = nil
			}
		}
	}
};

spec.config = vim.deepcopy(spec.default);
spec.tmp_config = nil;

spec.fixup = {
	["buf_ignore"] = function (value)
		health.notify("deprecation", {
			option = "buf_ignore",
			alter = "preview → ignore_buftypes"
		});

		if vim.islist(value) == false then
			return {};
		end

		return {
			preview = {
				ignore_buftypes = value;
			}
		};
	end,
	["callbacks"] = function (value)
		health.notify("deprecation", {
			option = "callbacks",
			alter = "preview → callbacks"
		});

		if type(value) ~= "table" then
			return {};
		end

		return {
			preview = {
				callbacks = value;
			}
		};
	end,
	["debounce"] = function (value)
		health.notify("deprecation", {
			option = "debounce",
			alter = "preview → debounce"
		});

		if type(value) ~= "number" then
			return {};
		end

		return {
			preview = {
				debounce = value;
			}
		};
	end,
	["filetypes"] = function (value)
		health.notify("deprecation", {
			option = "filetypes",
			alter = "preview → filetypes"
		});

		if vim.islist(value) == false then
			return {};
		end

		return {
			preview = {
				filetypes = value;
			}
		};
	end,
	["hybrid_modes"] = function (value)
		health.notify("deprecation", {
			option = "hybrid_modes",
			alter = "preview → hybrid_modes"
		});

		if vim.islist(value) == false then
			return {};
		end

		return {
			preview = {
				hybrid_modes = value;
			}
		};
	end,
	["ignore_nodes"] = function (_)
		health.notify("deprecation", {
			option = "ignore_nodes",
			alter = "preview → ignore_previews"
		});

		return {};
	end,
	["initial_state"] = function (value)
		health.notify("deprecation", {
			option = "initial_state",
			alter = "preview → enable"
		});

		if type(value) ~= "boolean" then
			return {};
		else
			return {
				preview = {
					enable = value
				}
			};
		end
	end,
	["max_file_length"] = function (value)
		health.notify("deprecation", {
			option = "max_file_length",
			alter = "preview → max_buf_lines"
		});

		if type(value) ~= "integer" then
			return {};
		else
			return {
				preview = {
					max_buf_lines = value
				}
			};
		end
	end,
	["modes"] = function (value)
		health.notify("deprecation", {
			option = "modes",
			alter = "preview → modes"
		});

		if vim.islist(value) == false then
			return {};
		end

		return {
			preview = {
				modes = value;
			}
		};
	end,
	["render_distance"] = function (value)
		health.notify("deprecation", {
			option = "render_distance",
			alter = "preview → draw_range"
		});

		if vim.islist(value) == false or #value ~= 2 then
			return {};
		elseif type(value) == "number" then
			health.notify("type", {
				option = "preview → draw_range",
				uses = "[ integer, integer ]",
				got = type(value)
			});

			return {
				preview = {
					draw_range = { value, value }
				}
			};
		end

		return {};
	end,
	["split_conf"] = function (value)
		health.notify("deprecation", {
			option = "split_conf",
			alter = "preview → splitview_winopts"
		});

		if type(value) ~= "table" then
			health.notify("type", {
				option = "preview → splitview_winopts",
				uses = "table",
				got = type(value)
			});

			return {};
		end

		return {
			preview = {
				splitview_winopts = value;
			}
		};
	end,

	["injections"] = function ()
		health.notify("deprecation", {
			option = "injections",
			tip = {
				{ "See ", "Normal" },
				{ " :h markview-advanced ", "DiagnosticVirtualTextHint" }
			}
		});

		return {};

	end,


	["block_quotes"] = function (config)
		local _o = {
			markdown = {
				block_quotes = {};
			}
		};

		--- Handles old callout definitions.
		---@param callouts table[]
		local handle_callouts = function (callouts)
			health.notify("deprecation", {
				option = "markdown → block_quotes → callouts",
				tip = {
					{ "Create a callout using the " },
					{ " match_string ", "DiagnosticVirtualTextInfo" },
					{ " as the key inside " },
					{ " markdown → block_quotes ", "DiagnosticVirtualTextHint" },
					{ "." },
				}
			});

			for _, callout in ipairs(callouts) do
				if callout.match_string then
					_o.markdown.block_quotes[callout.match_string] = {
						border = callout.border,
						border_hl = callout.border_hl,

						hl = callout.hl,

						icon = callout.icon,
						icon_hl = callout.icon_hl,

						preview = callout.preview,
						preview_hl = callout.preview_hl,

						title = callout.title,
					};
				end
			end
		end

		for key, value in pairs(config) do
			if key == "callouts" then
				if vim.islist(value) then
					handle_callouts(value);
				end
			else
				_o.markdown.block_quotes[key] = value;
			end
		end

		return _o;
	end,
	["code_blocks"] = function (config)
		local _o = {
			preview = {},
			markdown = {
				code_blocks = {}
			}
		};

		for key, value in pairs(config) do
			if key == "icon" then
				health.notify("deprecation", {
					option = "code_blocks → icon",
					alter = "preview → icon_provider"
				});

				_o.preview.icon_provider = value;
			elseif key == "language_names" then
				health.notify("deprecation", {
					option = "code_blocks → language_names"
				});
			elseif key == "hl" then
				health.notify("deprecation", {
					option = "code_blocks → hl",
					alter = "code_blocks → border_hl"
				});

				_o.markdown.code_blocks.border_hl = value;
			elseif key == "style" then
				if value == "minimal" then
					health.notify("type", {
						option = "markdown → code_blocks → style",
						uses = '"simple" | "block"',
						got = '"minimal"'
					});

					_o.markdown.code_blocks.style = "block";
				else
					_o.markdown.code_blocks.style = value;
				end
			else
				_o.markdown.code_blocks[key] = value;
			end
		end

		return _o;
	end,
	["headings"] = function (value)
		health.notify("deprecation", {
			option = "headings",
			alter = "markdown → headings"
		});

		return {
			markdown = {
				headings = value
			}
		};
	end,
	["horizontal_rules"] = function (value)
		health.notify("deprecation", {
			option = "horizontal_rules",
			alter = "markdown → horizontal_rules"
		});

		return {
			markdown = {
				horizontal_rules = value
			}
		};
	end,
	["list_items"] = function (value)
		health.notify("deprecation", {
			option = "list_items",
			alter = "markdown → list_items"
		});

		return {
			markdown = {
				list_items = value
			}
		};
	end,
	["tables"] = function (config)
		local _o = {
			markdown = {
				tables = {}
			}
		};

		health.notify("deprecation", {
			option = "tables",
			alter = "markdown → tables"
		});

		for k, v in pairs(config) do
			if k == "parts" and vim.islist(v) then
				--- Legacy option spec
			elseif k == "hl" and vim.islist(v) then
				--- Legacy option spec
			elseif k == "col_min_width" then
				health.notify("deprecation", {
					option = "markdown → tables → col_min_width"
				});
			else
				_o.markdown.tables[k] = v;
			end
		end

		return _o;
	end,

	["inline_codes"] = function (value)

		return {
			markdown_inline = {
				inline_codes = value
			}
		};
	end,
	["checkboxes"] = function (config)
		local _o = {
			markdown_inline = {
				checkboxes = {}
			}
		};

		for k, v in pairs(config) do
			if k == "custom" then
				if vim.islist(v) == false then
					goto invalid_type;
				end

				for _, entry in ipairs(v) do
					if entry.match_string then
						_o.markdown_inline.checkboxes[entry.match_string] = {
							text = entry.text,
							hl = entry.hl,

							scope_hl = entry.scope_hl
						};
					end
				end

				::invalid_type::
			else
				_o.markdown_inline.checkboxes[k] = v;
			end
		end

		return _o;
	end,
	["links"] = function (config)
		local _o = {
			markdown_inline = {}
		};

		--- Handles link config tables.
		---@param opt string
		---@param val table
		local function handle_link (opt, val)
			local _l = {
				default = {}
			};

			for k, v in pairs(val) do
				if k == "icon" then
					_l.default[k] = v;
				elseif k == "hl" then
					_l.default[k] = v;
				elseif k == "custom" then
					if vim.islist(v) == false then
						goto invalid_type;
					end

					for _, entry in ipairs(v) do
						if entry.match_string then
							_l[entry.match_string] = {
								text = entry.text,
								hl = entry.hl
							};
						end
					end

					::invalid_type::
				elseif k ~= "__emoji_link_compatability" then
					_l[k] = v;
				end
			end

			_o.markdown_inline[opt] = _l;
		end

		for k, v in pairs(config) do
			if vim.list_contains({ "hyperlinks", "images", "emails", "internals" }, k) then
				if k == "internals" then
					handle_link("internal_links", v);
				else
					handle_link(k, v);
				end
			end
		end

		return _o;
	end,
	["footnotes"] = function (config)
		local _o = {
			markdown_inline = {
				footnotes = {}
			}
		};

		--- Handles link config tables.
		---@param opt string
		---@param val table
		local function handle_link (opt, val)
			local _l = {
				default = {}
			};

			for k, v in pairs(val) do
				if k == "icon" then
					_l.default[k] = v;
				elseif k == "hl" then
					_l.default[k] = v;
				elseif k == "custom" then
					if vim.islist(v) == false then
						goto invalid_type;
					end

					for _, entry in ipairs(v) do
						if entry.match_string then
							_l[entry.match_string] = {
								text = entry.text,
								hl = entry.hl
							};
						end
					end

					::invalid_type::
				elseif k ~= "use_unicode" then
					_l[k] = v;
				end
			end

			_o.markdown_inline[opt] = _l;
		end

		handle_link("footnotes", config);
		return _o;
	end,

	["html"] = function (value)
		if value.entities then
			health.notify("deprecation", {
				option = "html → entities",
				alter = "markdown_inline → entities"
			});
		end

		return {
			markdown_inline = {
				entities = value.entities
			},
			html = {
				container_elements = value.container_elements,
				headings = value.headings,
				void_elements = value.void_elements
			}
		};
	end,

	["latex"] = function (config)
		local _o = {
			latex = {}
		};

		for k, v in pairs(config) do
			if k == "brackets" then
				health.notify("deprecation", {
					option = "latex → brackets",
					alter = "latex → parenthesis"
				});

				_o.latex.parenthesis = v;
			elseif k == "block" then
				health.notify("deprecation", {
					option = "latex → block",
					alter = "latex → blocks"
				});

				_o.latex.blocks = v;
			elseif k == "inline" then
				health.notify("deprecation", {
					option = "latex → inline",
					alter = "latex → inlines"
				});

				_o.latex.inlines = v;
			elseif k == "operators" then
				health.notify("deprecation", {
					option = "latex → operators",
					alter = "latex → commands"
				});

				local _c = {};

				for _, entry in ipairs(v) do
					_c[entry.match_string] = {
						-- TODO, here
					};
				end

				_o.latex.commands = _c;
			elseif k == "symbols" then
				if v.overwrite then
					health.notify("deprecation", {
						option = "latex → symbols → overwrite"
					});
				end

				if v.groups then
					health.notify("deprecation", {
						option = "latex → symbols → groups",
						tip = {
							{ " latex → symbols → hl ", "DiagnosticVirtualTextInfo" },
							{ " can be a " },
							{ " fun(buffer, item): string? ", "DiagnosticVirtualTextHint" },
							{ "." },
						}
					});
				end

				_o.latex.symbols = {
					enable = v.enable,
					hl = v.hl
				};
			elseif k == "subscript" then
				health.notify("deprecation", {
					option = "latex → subscript",
					alter = "latex → subscripts"
				});

				_o.latex.subscripts = v;
			elseif k == "superscript" then
				health.notify("deprecation", {
					option = "latex → superscript",
					alter = "latex → superscripts"
				});

				_o.latex.superscripts = v;
			end
		end

		return _o;
	end
};

--- Tries to fix deprecated config spec
---@param config table?
---@return table
spec.fix_config = function (config)
	if type(config) ~= "table" then
		return {};
	end

	--- Table containing valid options.
	local main = {
		renderers = config.renderers,
		highlight_groups = config.highlight_groups,

		preview = config.preview,
		experimental = config.experimental,

		html = config.html,
		latex = config.latex,
		markdown = config.markdown,
		markdown_inline = config.markdown_inline,
		typst = config.typst,
		yaml = config.yaml,
	};

	--- Table containing the fixed version of
	--- deprecated options.
	local fixed = {};

	for k, v in pairs(config) do
		if spec.fixup[k] then
			local _f, _r = pcall(spec.fixup[k], v);

			if _f == true then
				fixed = vim.tbl_deep_extend("force", fixed, _r);
			end
		end
	end

	if vim.tbl_isempty(fixed) == false then
		health.fixed_config = fixed;
	end

	return vim.tbl_deep_extend("force", main, fixed);
end

--- Setup function for markview.
---@param config markview.config?
spec.setup = function (config)
	config = spec.fix_config(config);
	spec.config = vim.tbl_deep_extend("force", spec.config, config);
end

--- Function to retrieve configuration options
--- from a config table.
---@param keys ( string | integer )[]
---@param opts markview.spec.get_opts
---@return any
spec.get = function (keys, opts)
	--- In case the values are correctly provided..
	keys = keys or {};
	opts = opts or {};

	--- Turns a dynamic value into
	--- a static value.
	---@param val any | fun(...): any
	---@param args any[]?
	---@return any
	local function to_static(val, args)
		if type(val) ~= "function" then
			return val;
		end

		args = args or {};

		if pcall(val, unpack(args)) then
			return val(unpack(args));
		else
			return nil;
		end
	end

	---@param index integer | string
	---@return any
	local function get_arg(index)
		if type(opts.args) ~= "table" then
			return {};
		elseif opts.args.__is_arg_list == true then
			return opts.args[index];
		else
			return opts.args;
		end
	end

	--- Temporarily store the value.
	---
	--- Use `deepcopy()` as we may need to
	--- modify this value.
	---@type any
	local val;

	if type(opts.source) == "table" or type(opts.source) == "function" then
		val = opts.source;
	elseif spec.tmp_config then
		val = spec.tmp_config;
	elseif spec.config then
		val = spec.config;
	else
		val = {};
	end

	--- Turn the main value into a static value.
	--- [ In case a function was provided as the source. ]
	val = to_static(val, get_arg("init"));

	if type(val) ~= "table" then
		--- The source isn't a table.
		return opts.fallback;
	end

	for k, key in ipairs(keys) do
		if k ~= #keys then
			val = to_static(val[key], val.args);

			if type(val) ~= "table" then
				return opts.fallback;
			elseif opts.ignore_enable ~= true and val.enable == false then
				return opts.fallback;
			end
		else
			--- Do not evaluate the final
			--- value.
			---
			--- It should be evaluated using
			--- `eval_args`.
			val = val[key];
		end
	end

	if vim.islist(opts.eval_args) == true and type(val) == "table" then
		local _e = {};
		local eval = opts.eval or vim.tbl_keys(val);
		local ignore = opts.eval_ignore or {};

		for k, v in pairs(val) do
			if type(v) ~= "function" then
				--- A silly attempt at reducing
				--- wasted time due to extra
				--- logic.
				_e[k] = v;
			elseif vim.list_contains(ignore, k) == false then
				if vim.list_contains(eval, k) then
					_e[k] = to_static(v, opts.eval_args);
				else
					_e[k] = v;
				end
			else
				_e[k] = v;
			end
		end

		val = _e;
	elseif vim.islist(opts.eval_args) == true and type(val) == "function" then
		val = to_static(val, opts.eval_args);
	end

	if val == nil and opts.fallback then
		return opts.fallback;
	elseif type(val) == "table" and ( opts.ignore_enable ~= true and val.enable == false ) then
		return opts.fallback;
	else
		return val;
	end
end

return spec;
-- vim:foldmethod=indent
