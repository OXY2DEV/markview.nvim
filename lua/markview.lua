local markview = {};
local utils = require("markview.utils");
local hls = require("markview.highlights");
local ts = require("markview.treesitter");
local latex = require("markview.latex_renderer");

markview.parser = require("markview.parser");
markview.renderer = require("markview.renderer");
markview.keymaps = require("markview.keymaps");

---@type integer[] List of attached buffers
markview.attached_buffers = {};

---@type integer[] List of attached windows
markview.attached_windows = {};

---@type { was_detached: boolean, id: integer }[]
markview.autocmds = {};

---@class markview.state Stores the various states of the plugin
---
---@field enable boolean Plugin state
---@field hybrid_mode boolean Hybrid mode state
---@field buf_states { [integer]: boolean } Buffer local plugin state
markview.state = {
	enable = true,
	hybrid_mode = true,
	buf_states = {}
};

---@type markview.configuration
markview.configuration = {
	__inside_code_block = false,

	block_quotes = {
		---+ ${class, Block quote}
		enable = true,

		default = {
			border = "▋", border_hl = "MarkviewBlockQuoteDefault"
		},

		callouts = {
			---+ ${conf, From `Obsidian`}
			{
				match_string = "ABSTRACT",
				callout_preview = "󱉫 Abstract",
				callout_preview_hl = "MarkviewBlockQuoteNote",

				custom_title = true,
				custom_icon = "󱉫 ",

				border = "▋", border_hl = "MarkviewBlockQuoteNote"
			},
			{
				match_string = "SUMMARY",
				callout_preview = "󱉫 Summary",
				callout_preview_hl = "MarkviewBlockQuoteNote",

				custom_title = true,
				custom_icon = "󱉫 ",

				border = "▋", border_hl = "MarkviewBlockQuoteNote"
			},
			{
				match_string = "TLDR",
				callout_preview = "󱉫 Tldr",
				callout_preview_hl = "MarkviewBlockQuoteNote",

				custom_title = true,
				custom_icon = "󱉫 ",

				border = "▋", border_hl = "MarkviewBlockQuoteNote"
			},
			{
				match_string = "TODO",
				callout_preview = " Todo",
				callout_preview_hl = "MarkviewBlockQuoteNote",

				custom_title = true,
				custom_icon = " ",

				border = "▋", border_hl = "MarkviewBlockQuoteNote"
			},
			{
				match_string = "INFO",
				callout_preview = " Info",
				callout_preview_hl = "MarkviewBlockQuoteNote",

				custom_title = true,
				custom_icon = " ",

				border = "▋", border_hl = "MarkviewBlockQuoteNote"
			},
			{
				match_string = "SUCCESS",
				callout_preview = "󰗠 Success",
				callout_preview_hl = "MarkviewBlockQuoteOk",

				custom_title = true,
				custom_icon = "󰗠 ",

				border = "▋", border_hl = "MarkviewBlockQuoteOk"
			},
			{
				match_string = "CHECK",
				callout_preview = "󰗠 Check",
				callout_preview_hl = "MarkviewBlockQuoteOk",

				custom_title = true,
				custom_icon = "󰗠 ",

				border = "▋", border_hl = "MarkviewBlockQuoteOk"
			},
			{
				match_string = "DONE",
				callout_preview = "󰗠 Done",
				callout_preview_hl = "MarkviewBlockQuoteOk",

				custom_title = true,
				custom_icon = "󰗠 ",

				border = "▋", border_hl = "MarkviewBlockQuoteOk"
			},
			{
				match_string = "QUESTION",
				callout_preview = "󰋗 Question",
				callout_preview_hl = "MarkviewBlockQuoteWarn",

				custom_title = true,
				custom_icon = "󰋗 ",

				border = "▋", border_hl = "MarkviewBlockQuoteWarn"
			},
			{
				match_string = "HELP",
				callout_preview = "󰋗 Help",
				callout_preview_hl = "MarkviewBlockQuoteWarn",

				custom_title = true,
				custom_icon = "󰋗 ",

				border = "▋", border_hl = "MarkviewBlockQuoteWarn"
			},
			{
				match_string = "FAQ",
				callout_preview = "󰋗 Faq",
				callout_preview_hl = "MarkviewBlockQuoteWarn",

				custom_title = true,
				custom_icon = "󰋗 ",

				border = "▋", border_hl = "MarkviewBlockQuoteWarn"
			},
			{
				match_string = "FAILURE",
				callout_preview = "󰅙 Failure",
				callout_preview_hl = "MarkviewBlockQuoteError",

				custom_title = true,
				custom_icon = "󰅙 ",

				border = "▋", border_hl = "MarkviewBlockQuoteError"
			},
			{
				match_string = "FAIL",
				callout_preview = "󰅙 Fail",
				callout_preview_hl = "MarkviewBlockQuoteError",

				custom_title = true,
				custom_icon = "󰅙 ",

				border = "▋", border_hl = "MarkviewBlockQuoteError"
			},
			{
				match_string = "MISSING",
				callout_preview = "󰅙 Missing",
				callout_preview_hl = "MarkviewBlockQuoteError",

				custom_title = true,
				custom_icon = "󰅙 ",

				border = "▋", border_hl = "MarkviewBlockQuoteError"
			},
			{
				match_string = "DANGER",
				callout_preview = " Danger",
				callout_preview_hl = "MarkviewBlockQuoteError",

				custom_title = true,
				custom_icon = "  ",

				border = "▋", border_hl = "MarkviewBlockQuoteError"
			},
			{
				match_string = "ERROR",
				callout_preview = " Error",
				callout_preview_hl = "MarkviewBlockQuoteError",

				custom_title = true,
				custom_icon = "  ",

				border = "▋", border_hl = "MarkviewBlockQuoteError"
			},
			{
				match_string = "BUG",
				callout_preview = " Bug",
				callout_preview_hl = "MarkviewBlockQuoteError",

				custom_title = true,
				custom_icon = "  ",

				border = "▋", border_hl = "MarkviewBlockQuoteError"
			},
			{
				match_string = "EXAMPLE",
				callout_preview = "󱖫 Example",
				callout_preview_hl = "MarkviewBlockQuoteSpecial",

				custom_title = true,
				custom_icon = " 󱖫 ",

				border = "▋", border_hl = "MarkviewBlockQuoteSpecial"
			},
			{
				match_string = "QUOTE",
				callout_preview = " Quote",
				callout_preview_hl = "MarkviewBlockQuoteDefault",

				custom_title = true,
				custom_icon = "  ",

				border = "▋", border_hl = "MarkviewBlockQuoteDefault"
			},
			{
				match_string = "CITE",
				callout_preview = " Cite",
				callout_preview_hl = "MarkviewBlockQuoteDefault",

				custom_title = true,
				custom_icon = "  ",

				border = "▋", border_hl = "MarkviewBlockQuoteDefault"
			},
			{
				match_string = "HINT",
				callout_preview = " Hint",
				callout_preview_hl = "MarkviewBlockQuoteOk",

				border = "▋", border_hl = "MarkviewBlockQuoteOk"
			},
			{
				match_string = "ATTENTION",
				callout_preview = " Attention",
				callout_preview_hl = "MarkviewBlockQuoteWarn",

				border = "▋", border_hl = "MarkviewBlockQuoteWarn"
			},
			---_
			---+ ${conf, From Github}
			{
				match_string = "NOTE",
				callout_preview = "󰋽 Note",
				callout_preview_hl = "MarkviewBlockQuoteNote",

				border = "▋", border_hl = "MarkviewBlockQuoteNote"
			},
			{
				match_string = "TIP",
				callout_preview = " Tip",
				callout_preview_hl = "MarkviewBlockQuoteOk",

				border = "▋", border_hl = "MarkviewBlockQuoteOk"
			},
			{
				match_string = "IMPORTANT",
				callout_preview = " Important",
				callout_preview_hl = "MarkviewBlockQuoteSpecial",

				border = "▋", border_hl = "MarkviewBlockQuoteSpecial"
			},
			{
				match_string = "WARNING",
				callout_preview = " Warning",
				callout_preview_hl = "MarkviewBlockQuoteWarn",

				border = "▋", border_hl = "MarkviewBlockQuoteWarn"
			},
			{
				match_string = "CAUTION",
				callout_preview = "󰳦 Caution",
				callout_preview_hl = "MarkviewBlockQuoteError",

				border = "▋", border_hl = "MarkviewBlockQuoteError"
			},
			---_

			---+ ${conf, Custom}
			{
				match_string = "CUSTOM",
				callout_preview = "󰠳 Custom",
				callout_preview_hl = "MarkviewBlockQuoteWarn",

				custom_title = true,
				custom_icon = " 󰠳 ",

				border = "▋", border_hl = "MarkviewBlockQuoteWarn"
			}
			---_
		}
		---_
	},

	buf_ignore = { "nofile" },

	callbacks = {
		---+ ${class, Callbacks}
		on_enable = function (_, window)
			local _m = {};

			if markview.state.hybrid_mode == true and vim.islist(markview.configuration.hybrid_modes) then
				for _, mod in ipairs(markview.configuration.modes) do
					if vim.list_contains({ "n", "i", "v", "c" }, mod) and
						not vim.list_contains(markview.configuration.hybrid_modes, mod)
					then
						table.insert(_m, mod);
					end
				end
			else
				for _, mod in ipairs(markview.configuration.modes) do
					if vim.list_contains({ "n", "i", "v", "c" }, mod) then
						table.insert(_m, mod);
					end
				end
			end

			vim.wo[window].conceallevel = 2;
			vim.wo[window].concealcursor = table.concat(_m);
		end,
		on_disable = function (_, window)
			vim.wo[window].conceallevel = 0;
			vim.wo[window].concealcursor = "";
		end,

		on_mode_change = function (_, window, mode)
			if vim.list_contains(markview.configuration.modes, mode) then
				local _m = {};

				if markview.state.hybrid_mode == true and vim.islist(markview.configuration.hybrid_modes) then
					for _, mod in ipairs(markview.configuration.modes) do
						if vim.list_contains({ "n", "i", "v", "c" }, mod) and
							not vim.list_contains(markview.configuration.hybrid_modes, mod)
						then
							table.insert(_m, mod);
						end
					end
				else
					for _, mod in ipairs(markview.configuration.modes) do
						if vim.list_contains({ "n", "i", "v", "c" }, mod) then
							table.insert(_m, mod);
						end
					end
				end

				vim.wo[window].concealcursor = table.concat(_m);
				vim.wo[window].conceallevel = 2;
			else
				vim.wo[window].conceallevel = 0;
				vim.wo[window].concealcursor = "";
			end
		end,

		split_enter = nil
		---_
	},

	checkboxes = {
		---+ ${class, Checkboxes}
		enable = true,

		checked = {
			text = "✔", hl = "MarkviewCheckboxChecked"
		},
		unchecked = {
			text = "✘", hl = "MarkviewCheckboxUnchecked"
		},
		custom = {
			---+ ${conf, Custom cehckboxes}
			{
				match_string = "-",
				text = "◯",
				hl = "MarkviewCheckboxPending"
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
			{
				match_string = "p",
				text = "󰩹",
				hl = "MarkviewCheckboxCancelled"
			}
			---_
		}
		---_
	},

	code_blocks = {
		---+ ${class, Code blocks}
		enable = true,
		icons = true,

		style = "language",
		hl = "MarkviewCode",
		info_hl = "MarkviewCodeInfo",

		min_width = 60,
		pad_amount = 3,

		language_names = nil,
		language_direction = "right",

		sign = true, sign_hl = nil
		---_
	},

	debounce = 50,
	escaped = { enable = true },

	filetypes = { "markdown", "quarto", "rmd" },

	footnotes = {
		enable = true,
		use_unicode = true,
		hl = "Special"
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
			style = "github",

			sign = "󰌕 ", sign_hl = "MarkviewHeading1Sign",
			icon = "  ", hl = "MarkviewHeading1",
			line = "▂"
			---_
		},
		setext_2 = {
			---+ ${conf, Setext heading 2}
			style = "github",

			sign = "󰌖 ", sign_hl = "MarkviewHeading2Sign",
			icon = "  ", hl = "MarkviewHeading2",
			line = "▁"
			---_
		}
		---_
	},

	highlight_groups = "dynamic",

	horizontal_rules = {
		---+ ${class, Horizontal rules}
		enable = true,

		parts = {
			{
				---+ ${conf, Lsft portion}
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

	html = {
		---+ ${class, Html}
		enable = true,

		tags = {
			enable = true,

			default = {
				conceal = false
			},

			configs = {
				b = { conceal = true, hl = "Bold" },
				strong = { conceal = true, hl = "Bold" },

				u = { conceal = true, hl = "Underlined" },

				i = { conceal = true, hl = "Italic" },
				emphasize = { conceal = true, hl = "Italic" },

				marked = { conceal = true, hl = "Special" },
			}
		},

		entities = {
			enable = true
		}
		---_
	},

	hybrid_modes = nil,

	injections = {
		---+ ${class, Query injections}
		enable = true,
		-- languages = {
		-- 	markdown = {
		-- 		enable = true,
		-- 		query = [[
		-- 			(section
		-- 				(atx_heading)
		-- 				) @fold
		-- 				(#set! @fold)
		-- 		]]
		-- 	}
		-- }
		---_
	},

	inline_codes = {
		---+ ${class, Inline codes}
		enable = true,
		corner_left = " ",
		corner_right = " ",

		hl = "MarkviewInlineCode"
		---_
	},

	latex = {
		---+ ${class, Latex}
		enable = true,

		---@diagnostic disable
		brackets = {
			enable = true,
			hl = "@punctuation.brackets"
		},
		operators = {
			enable = true,
			configs = latex.operator_conf
		},
		---@diagnostic enable

		inline = {
			enable = true
		},
		block = {
			enable = true,

			hl = "Code",
			text = { " LaTeX ", "Special" }
		},

		symbols = {
			enable = true,
			hl = "@operator.latex",
			overwrite = {},
			groups = {
				{
					match = { "lim", "today" },
					hl = "Special"
				}
			}
		},

		subscript = {
			enable = true,
			hl = "MarkviewLatexSubscript",
		},
		superscript = {
			enable = true,
			hl = "MarkviewLatexSuperscript",
		},
		---_
	},

	links = {
		---+ ${class, Links}
		enable = true,

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
		images = {
			enable = true,
			__emoji_link_compatability = true,

			icon = "󰥶 ",
			hl = "MarkviewImageLink",

			custom = {
				{ match_string = "%.svg$", icon = "󰜡 " },
			}
		},
		emails = {
			enable = true,
			__emoji_link_compatability = true,

			icon = " ",
			hl = "MarkviewEmail"
		},

		internal_links = {
			enable = true,
			__emoji_link_compatability = true,

			icon = " ",
			hl = "MarkviewHyperlink"
		}
		---_
	},

	list_items = {
		---+ ${class, List items}
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

			text = "",
			hl = "MarkviewListItemPlus"
		},
		marker_star = {
			add_padding = true,

			text = "",
			hl = "MarkviewListItemStar"
		},
		marker_dot = {
			add_padding = true
		},
		---_
	},

	initial_state = true,
	max_file_length = 1000,
	modes = { "n", "no", "c" },
	render_distance = 100,

	split_conf = {
		split = "right"
	},

	tables = {
		---+ ${class, Tablws}
		enable = true,
		text = {
			--- ╭ ─ ╮ ┬
			--- │ │ │   ╼
			--- ├ ┼ ┤ ─ ╴╶
			--- │ │ │   ╾
			--- ╰ ─ ╯ ┴
			"╭", "─", "╮", "┬",
			"│", "│", "│",      "╼",
			"├", "┼", "┤", "─", "╴", "╶",
			"│", "│", "│",      "╾",
			"╰", "─", "╯", "┴",
		},
		hl = {
			"TableHeader", "TableHeader", "TableHeader",    "TableHeader",
			"TableHeader", "TableHeader", "TableHeader",                     "TableAlignLeft",
			"TableHeader", "TableHeader", "TableHeader",    "TableHeader",   "TableAlignCenter", "TableAlignCenter",
			"TableBorder", "TableBorder", "TableBorder",                     "TableAlignRight",
			"TableBorder", "TableBorder", "TableBorder",    "TableBorder"
		},

		col_min_width = 5,
		block_decorator = true,
		use_virt_lines = true
		---_
	}
};

--- Split view related functions
---@class markview.splitView
---
---@field attached_buffer integer? Buffer ID of the currently attached buffer, `nil` if no buffer is attached
---@field augroup integer Autocmd group for scroll sync and closing the window
---
---@field close function Window closing function
---@field open function Window opening function
---@field init function Initializes the current buffer to be shown in a split
markview.splitView = {
	attached_buffer = nil,
	augroup = vim.api.nvim_create_augroup("markview_splitview", { clear = true }),

	buffer = vim.api.nvim_create_buf(false, true),
	window = nil,

	close = function (self)
		pcall(vim.api.nvim_win_close, self.window, true);
		self.augroup = vim.api.nvim_create_augroup("markview_splitview", { clear = true });

		self.attached_buffer = nil;
		self.window = nil;
	end,

	init = function (self, buffer)
		-- If buffer is already opened, exit
		if self.attached_buffer and (buffer == self.attached_buffer or buffer == self.buffer) then
			return;
		end

		self.augroup = vim.api.nvim_create_augroup("markview_splitview", { clear = true });

		-- Register the buffer
		self.attached_buffer = buffer;

		local windows = utils.find_attached_wins(buffer);

		-- Buffer isn't attached to a window
		if #windows == 0 then
			windows = { vim.api.nvim_get_current_win() };
			-- return;
		end

		-- If window doesn't exist, open it
		if not self.window or vim.api.nvim_win_is_valid(self.window) == false then
			self.window = vim.api.nvim_open_win(self.buffer, false, vim.tbl_deep_extend("force", {
				win = windows[1],
				split = "right"
			}, markview.configuration.split_conf or {}));

			pcall(markview.configuration.callbacks.split_enter, self.buffer, self.window);
		else
			vim.api.nvim_win_set_config(self.window, vim.tbl_deep_extend("force", {
				win = windows[1],
				split = "right"
			}, markview.configuration.split_conf or {}));
		end

		local content = vim.api.nvim_buf_get_lines(buffer, 0, -1, false);

		-- Write text to the split buffer
		vim.bo[self.buffer].modifiable = true;
		vim.api.nvim_buf_set_lines(self.buffer, 0, -1, false, content);
		vim.bo[self.buffer].modifiable = false;

		vim.bo[self.buffer].filetype = vim.bo[buffer].filetype;

		vim.wo[self.window].number = false;
		vim.wo[self.window].relativenumber = false;
		vim.wo[self.window].statuscolumn = "";

		vim.wo[self.window].cursorline = true;

		-- Run callback
		pcall(markview.configuration.callbacks.on_enable, self.buf, self.window);

		local cursor = vim.api.nvim_win_get_cursor(windows[1]);
		pcall(vim.api.nvim_win_set_cursor, self.window, cursor);

		local parsed_content;

		if #content < markview.configuration.max_file_length then
			-- Buffer isn't too big. Render everything
			parsed_content = markview.parser.init(self.buffer, markview.configuration);

			markview.renderer.render(self.buffer, parsed_content, markview.configuration)
		else
			-- Buffer is too big, render only parts of it
			local start = math.max(0, cursor[1] - markview.configuration.render_distance);
			local stop = math.min(lines, cursor[1] + markview.configuration.render_distance);

			parsed_content = markview.parser.parse_range(self.buffer, markview.configuration, start, stop);

			markview.renderer.render(self.buffer, parsed_content, markview.configuration)
		end


		local timer = vim.uv.new_timer();

		vim.api.nvim_create_autocmd({
			"CursorMoved", "CursorMovedI"
		}, {
			group = self.augroup,
			buffer = buffer,
			callback = vim.schedule_wrap(function ()
				-- Set cursor
				cursor = vim.api.nvim_win_get_cursor(windows[1]);
				pcall(vim.api.nvim_win_set_cursor, self.window, cursor);
			end)
		});

		vim.api.nvim_create_autocmd({
			"BufHidden"
		}, {
			group = self.augroup,
			buffer = buffer,
			callback = vim.schedule_wrap(function ()
				self:close();
			end)
		});
		vim.api.nvim_create_autocmd({
			"BufHidden"
		}, {
			group = self.augroup,
			buffer = self.buffer,
			callback = vim.schedule_wrap(function ()
				markview.commands.splitDisable(self.attached_buffer);
			end)
		});

		vim.api.nvim_create_autocmd({
			"TextChanged", "TextChangedI"
		}, {
			group = self.augroup,
			buffer = buffer,
			callback = vim.schedule_wrap(function ()
				timer:stop();
				timer:start(50, 0, vim.schedule_wrap(function ()
					content = vim.api.nvim_buf_get_lines(buffer, 0, -1, false);

					-- Write text to the split buffer
					vim.bo[self.buffer].modifiable = true;
					vim.api.nvim_buf_clear_namespace(self.buffer, markview.renderer.namespace, 0, -1);
					vim.api.nvim_buf_set_lines(self.buffer, 0, -1, false, content);
					vim.bo[self.buffer].modifiable = false;

					if #content < markview.configuration.max_file_length then
						-- Buffer isn't too big. Render everything
						parsed_content = markview.parser.init(self.buffer, markview.configuration);

						markview.renderer.render(self.buffer, parsed_content, markview.configuration)
					else
						-- Buffer is too big, render only parts of it
						local start = math.max(0, cursor[1] - markview.configuration.render_distance);
						local stop = math.min(lines, cursor[1] + markview.configuration.render_distance);

						parsed_content = markview.parser.parse_range(self.buffer, markview.configuration, start, stop);

						markview.renderer.render(self.buffer, parsed_content, markview.configuration)
					end
				end));
			end)
		});

		return self;
	end
};

markview.commands = {
	attach = function (buf)
		vim.api.nvim_exec_autocmds("User", { pattern = "MarkviewEnter", buffer = buf })
	end,
	detach = function (buf)
		vim.api.nvim_exec_autocmds("User", { pattern = "MarkviewLeave", buffer = buf })
	end,

	toggleAll = function ()
		if markview.state.enable == true then
			markview.commands.disableAll();
			markview.state.enable = false;
		else
			markview.commands.enableAll();
			markview.state.enable = true;
		end
	end,
	enableAll = function ()
		markview.state.enable = true;

		for _, buf in ipairs(markview.attached_buffers) do
			if markview.splitView.window and buf == markview.splitView.attached_buffer and vim.api.nvim_win_is_valid(markview.splitView.window) then
				goto continue;
			elseif markview.splitView.window and buf == markview.splitView.buffer and vim.api.nvim_win_is_valid(markview.splitView.window) then
				goto continue;
			end

			local parsed_content = markview.parser.init(buf);
			local windows = utils.find_attached_wins(buf);

			if markview.configuration.callbacks and markview.configuration.callbacks.on_enable then
				for _, window in ipairs(windows) do
					pcall(markview.configuration.callbacks.on_enable, buf, window);
				end
			end

			markview.state.buf_states[buf] = true;

			markview.renderer.clear(buf);
			markview.renderer.render(buf, parsed_content, markview.configuration);

			::continue::
		end
	end,
	disableAll = function ()
		for _, buf in ipairs(markview.attached_buffers) do
			if markview.splitView.window and buf == markview.splitView.attached_buffer and vim.api.nvim_win_is_valid(markview.splitView.window) then
				goto continue;
			elseif markview.splitView.window and buf == markview.splitView.buffer and vim.api.nvim_win_is_valid(markview.splitView.window) then
				goto continue;
			end

			local windows = utils.find_attached_wins(buf);

			if markview.configuration.callbacks and markview.configuration.callbacks.on_disable then
				for _, window in ipairs(windows) do
					pcall(markview.configuration.callbacks.on_disable, buf, window);
				end
			end

			markview.state.buf_states[buf] = false;
			markview.renderer.clear(buf);

			::continue::
		end

		markview.state.enable = false;
	end,

	toggle = function (buf)
		local buffer = tonumber(buf) or vim.api.nvim_get_current_buf();

		if not vim.list_contains(markview.attached_buffers, buffer) or not vim.api.nvim_buf_is_valid(buffer) then
			return;
		elseif markview.splitView.window and buf == markview.splitView.buffer and vim.api.nvim_win_is_valid(markview.splitView.window) then
			return;
		end

		local state = markview.state.buf_states[buffer];

		if state == true then
			markview.commands.disable(buffer)
			state = false;
		else
			markview.commands.enable(buffer);
			state = true;
		end
	end,
	enable = function (buf)
		local buffer = tonumber(buf) or vim.api.nvim_get_current_buf();

		if not vim.list_contains(markview.attached_buffers, buffer) or not vim.api.nvim_buf_is_valid(buffer) then
			return;
		end

		local windows = utils.find_attached_wins(buffer);

		markview.state.buf_states[buffer] = true;

		for _, window in ipairs(windows) do
			pcall(markview.configuration.callbacks.on_enable, buf, window);
		end

		local lines = vim.api.nvim_buf_line_count(buffer);
		local parsed_content;

		if lines < markview.configuration.max_file_length then
			-- Buffer isn't too big. Render everything
			parsed_content = markview.parser.init(buffer, markview.configuration);

			markview.renderer.render(buffer, parsed_content, markview.configuration)
		else
			-- Buffer is too big, render only parts of it
			local cursor = vim.api.nvim_win_get_cursor(0);
			local start = math.max(0, cursor[1] - markview.configuration.render_distance);
			local stop = math.min(lines, cursor[1] + (markview.configuration.render_distance));

			parsed_content = markview.parser.parse_range(buffer, markview.configuration, start, stop);

			markview.renderer.render(buffer, parsed_content, markview.configuration)
		end
	end,

	disable = function (buf)
		local buffer = tonumber(buf) or vim.api.nvim_get_current_buf();

		if not vim.list_contains(markview.attached_buffers, buffer) or not vim.api.nvim_buf_is_valid(buffer) then
			return;
		end

		local windows = utils.find_attached_wins(buffer);

		for _, window in ipairs(windows) do
			pcall(markview.configuration.callbacks.on_disable, buf, window);
		end

		markview.renderer.clear(buffer);
		markview.state.buf_states[buffer] = false;
	end,

	splitToggle = function (buf)
		local buffer = tonumber(buf) or vim.api.nvim_get_current_buf();

		if markview.splitView.attached_buffer and vim.api.nvim_buf_is_valid(markview.splitView.attached_buffer) then
			if buffer == markview.splitView.attached_buffer then
				markview.commands.splitDisable(buf);
			else
				markview.commands.enable(markview.splitView.attached_buffer);
				markview.commands.splitEnable(buf);
			end
		else
			markview.commands.splitEnable(buf);
		end
	end,

	splitDisable = function (buf)
		local buffer = tonumber(buf) or vim.api.nvim_get_current_buf();

		if not vim.list_contains(markview.attached_buffers, buffer) or not vim.api.nvim_buf_is_valid(buffer) then
			return;
		end

		markview.splitView:close();
		markview.state.buf_states[buffer] = true;

		local mode = vim.api.nvim_get_mode().mode;

		if markview.state.enable == false or not vim.list_contains(markview.configuration.modes, mode) then
			return;
		end

		local windows = utils.find_attached_wins(buffer);

		local parsed_content = markview.parser.init(buffer);

		for _, window in ipairs(windows) do
			pcall(markview.configuration.callbacks.on_enable, buf, window);
		end

		markview.renderer.clear(buffer);
		markview.renderer.render(buffer, parsed_content, markview.configuration)
	end,

	splitEnable = function (buf)
		local buffer = tonumber(buf) or vim.api.nvim_get_current_buf();

		if not vim.list_contains(markview.attached_buffers, buffer) or not vim.api.nvim_buf_is_valid(buffer) then
			return;
		end

		local windows = utils.find_attached_wins(buffer);

		for _, window in ipairs(windows) do
			pcall(markview.configuration.callbacks.on_disable, buf, window);
		end

		markview.renderer.clear(buffer);
		markview.state.buf_states[buffer] = false;

		markview.splitView:init(buffer);
	end,

	hybridToggle = function ()
		if markview.state.hybrid_mode == false then
			markview.state.hybrid_mode = true;
		else
			markview.state.hybrid_mode = false;
		end
	end,
	hybridEnable = function ()
		markview.state.hybrid_mode = true;
	end,
	hybridDisable = function ()
		markview.state.hybrid_mode = false;
	end,
}


vim.api.nvim_create_autocmd({ "colorscheme" }, {
	callback = function ()
		if type(markview.configuration.highlight_groups) == "string" or vim.islist(markview.configuration.highlight_groups) then
			---@diagnostic disable-next-line
			hls.create(markview.configuration.highlight_groups)
		end
	end
})

vim.api.nvim_create_user_command("Markview", function (opts)
	local fargs = opts.fargs;

	if #fargs < 1 then
		markview.commands.toggleAll();
	elseif #fargs == 1 and markview.commands[fargs[1]] then
		markview.commands[fargs[1]]();
	elseif #fargs == 2 and markview.commands[fargs[1]] then
		markview.commands[fargs[1]](fargs[2]);
	end
end, {
	nargs = "*",
	desc = "Controls for Markview.nvim",
	complete = function (arg_lead, cmdline, _)
		if arg_lead == "" then
			if not cmdline:find("^Markview%s+%S+") then
				return vim.tbl_keys(markview.commands);
			elseif cmdline:find("^Markview%s+(%S+)%s*$") then
				for cmd, _ in cmdline:gmatch("Markview%s+(%S+)%s*(%S*)") do
					-- ISSUE: Find a better way to find commands that accept arguments
					if vim.list_contains({ "enable", "disable", "toggle", "splitToggle" }, cmd) then
						local bufs = {};

						for _, buf in ipairs(markview.attached_buffers) do
							table.insert(bufs, tostring(buf));
						end

						return bufs;
					end
				end
			end
		end

		for cmd, arg in cmdline:gmatch("Markview%s+(%S+)%s*(%S*)") do
			if arg_lead == cmd then
				local cmds = vim.tbl_keys(markview.commands);
				local completions = {};

				for _, key in pairs(cmds) do
					if arg_lead == string.sub(key, 1, #arg_lead) then
						table.insert(completions, key)
					end
				end

				return completions
			elseif arg_lead == arg then
				local buf_complete = {};

				for _, buf in ipairs(markview.attached_buffers) do
					if tostring(buf):match(arg) then
						table.insert(buf_complete, tostring(buf))
					end
				end

				return buf_complete;
			end
		end
	end
});

markview.unload = function (buffer)
	for index, buf in ipairs(markview.attached_buffers) do
		if buffer and buf == buffer then
			table.remove(markview.attached_buffers, index);
		elseif vim.api.nvim_buf_is_valid(buf) == false then
			table.remove(markview.attached_buffers, index);
		end
	end

	for index, win in ipairs(markview.attached_windows) do
		if buffer and vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buffer then
			table.remove(markview.attached_windows, index);
		elseif vim.api.nvim_win_is_valid(win) == false then
			table.remove(markview.attached_windows, index);
		end
	end
end

markview.setup = function (user_config)
	if user_config and user_config.highlight_groups then
		if vim.islist(user_config.highlight_groups) then
			markview.configuration.highlight_groups = user_config.highlight_groups;
		else
			markview.configuration.highlight_groups = vim.list_extend(markview.configuration.highlight_groups, user_config.highlight_groups);
		end
	end

	---@type markview.configuration
	-- Merged configuration tables
	markview.configuration = vim.tbl_deep_extend("force", markview.configuration, user_config or {});

	if type(markview.configuration.highlight_groups) == "string" or vim.islist(markview.configuration.highlight_groups) then
		---@diagnostic disable-next-line
		hls.create(markview.configuration.highlight_groups)
	end

	ts.inject(markview.configuration.injections)
	markview.commands.enableAll();
end

return markview;
