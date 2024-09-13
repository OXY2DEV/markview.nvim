local markview = {};
local utils = require("markview.utils");
local hls = require("markview.highlights");

markview.parser = require("markview.parser");
markview.renderer = require("markview.renderer");
markview.keymaps = require("markview.keymaps");

markview.colors = require("markview.colors");

markview.attached_buffers = {};
markview.attached_windows = {};

markview.state = {
	enable = true,
	hybrid_mode = true,
	buf_states = {}
};

markview.global_options = {};

---@type markview.config
markview.configuration = {
	split_conf = {
		split = "right"
	},
	filetypes = { "markdown", "quarto", "rmd" },
	callbacks = {
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
		end
	},

	highlight_groups = "dynamic",
	buf_ignore = { "nofile" },

	modes = { "n", "no" },
	hybrid_modes = nil,

	headings = {
		enable = true,
		shift_width = 3,

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
			style = "github",

			icon = "   ", hl = "MarkviewHeading1",
			underline = "━"
		},
		setext_2 = {
			style = "github",

			icon = "   ", hl = "MarkviewHeading2",
			underline = "─"
		}
	},

	latex = {
		enable = true,

		brackets = {
			enable = true,
			opening = {
				{ "(", "MarkviewHeading1Sign" },
				{ "{", "MarkviewHeading2Sign" },
				{ "[", "MarkviewHeading3Sign" },
			},
			closing = {
				{ ")", "MarkviewHeading1Sign" },
				{ "}", "MarkviewHeading2Sign" },
				{ "]", "MarkviewHeading3" },
			},

			-- scope = {
			-- 	"DiagnosticVirtualTextError",
			-- 	"DiagnosticVirtualTextOk",
			-- 	"DiagnosticVirtualTextWarn",
			-- }
		},

		inline = {
			enable = true
		},
		block = {
			hl = "Code",
			text = { " Latex ", "Special" }
		},

		symbols = {
			enable = true,
			overwrite = {}
		},

		subscript = {
			enable = true
		},
		superscript = {
			enable = true
		},
	},

	code_blocks = {
		enable = true,
		icons = true,

		style = "language",
		hl = "MarkviewCode",
		info_hl = "MarkviewCodeInfo",

		min_width = 60,
		pad_amount = 3,

		language_names = {
			{ "py", "python" },
			{ "cpp", "C++" }
		},
		language_direction = "right",

		sign = true, sign_hl = nil
	},

	block_quotes = {
		enable = true,
		overwrite = { "callouts" },

		default = {
			border = "▋", border_hl = "MarkviewBlockQuoteDefault"
		},

		callouts = {
			--- From `Obsidian`
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
			{
				match_string = "CUSTOM",
				callout_preview = "󰠳 Custom",
				callout_preview_hl = "MarkviewBlockQuoteWarn",

				custom_title = true,
				custom_icon = " 󰠳 ",

				border = "▋", border_hl = "MarkviewBlockQuoteWarn"
			}
		}
	},
	horizontal_rules = {
		enable = true,

		parts = {
			{
				type = "repeating",
				repeat_amount = function () --[[@as function]]
					local textoff = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].textoff;

					return math.floor((vim.o.columns - textoff - 3) / 2);
				end,

				text = "─",
				hl = {
					"MarkviewGradient1", "MarkviewGradient2", "MarkviewGradient3", "MarkviewGradient4", "MarkviewGradient5", "MarkviewGradient6", "MarkviewGradient7", "MarkviewGradient8", "MarkviewGradient9", "MarkviewGradient10"
				}
			},
			{
				type = "text",
				text = "  ",
			},
			{
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
			}
		}
	},
	html = {
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

		entites = {
			enable = true
		}
	},

	links = {
		enable = true,

		hyperlinks = {
			icon = "󰌷 ",
			hl = "MarkviewHyperlink",

			custom = {
				{
					match = "https://(.+)$",

					icon = "󰞉 ",
				},
				{
					match = "http://(.+)$",

					icon = "󰕑 ",
				},
				{
					match = "[%.]md$",

					icon = " ",
				}
			}
		},
		images = {
			icon = "󰥶 ",
			hl = "MarkviewImageLink",
		},
		emails = {
			icon = " ",
			hl = "MarkviewEmail"
		}
	},

	inline_codes = {
		enable = true,
		corner_left = " ",
		corner_right = " ",

		hl = "MarkviewInlineCode"
	},

	list_items = {
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
			text_hl = "MarkviewListItemStar"
		},
		marker_dot = {
			add_padding = true
		},
	},

	checkboxes = {
		enable = true,

		checked = {
			text = "✔", hl = "MarkviewCheckboxChecked"
		},
		pending = {
			text = "◯", hl = "MarkviewCheckboxPending"
		},
		unchecked = {
			text = "✘", hl = "MarkviewCheckboxUnchecked"
		},
		custom = {
			{
				match = "~",
				text = "◕",
				hl = "MarkviewCheckboxProgress"
			},
			{
				match = "o",
				text = "󰩹",
				hl = "MarkviewCheckboxCancelled"
			}
		}
	},

	tables = {
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
			"TableHeader", "TableHeader", "TableHeader",    "TableHeader",    "TableAlignCenter", "TableAlignCenter",
			"TableBorder", "TableBorder", "TableBorder",                     "TableAlignRight",
			"TableBorder", "TableBorder", "TableBorder",    "TableBorder"
		},

		block_decorator = true,
		use_virt_lines = true
	},

	escaped = {
		enable = true
	}
};

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

		if #content < (markview.configuration.max_length or 1000) then
			-- Buffer isn't too big. Render everything
			parsed_content = markview.parser.init(self.buffer, markview.configuration);

			markview.renderer.render(self.buffer, parsed_content, markview.configuration)
		else
			-- Buffer is too big, render only parts of it
			local start = math.max(0, cursor[1] - (markview.configuration.render_range or 100));
			local stop = math.min(lines, cursor[1] + (markview.configuration.render_range or 100));

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
					vim.api.nvim_buf_set_lines(self.buffer, 0, -1, false, content);
					vim.bo[self.buffer].modifiable = false;

					if #content < (markview.configuration.max_length or 1000) then
						-- Buffer isn't too big. Render everything
						parsed_content = markview.parser.init(self.buffer, markview.configuration);

						markview.renderer.render(self.buffer, parsed_content, markview.configuration)
					else
						-- Buffer is too big, render only parts of it
						local start = math.max(0, cursor[1] - (markview.configuration.render_range or 100));
						local stop = math.min(lines, cursor[1] + (markview.configuration.render_range or 100));

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

		if lines < (markview.configuration.max_length or 1000) then
			-- Buffer isn't too big. Render everything
			parsed_content = markview.parser.init(buffer, markview.configuration);

			markview.renderer.render(buffer, parsed_content, markview.configuration)
		else
			-- Buffer is too big, render only parts of it
			local cursor = vim.api.nvim_win_get_cursor(0);
			local start = math.max(0, cursor[1] - (markview.configuration.render_range or 100));
			local stop = math.min(lines, cursor[1] + (markview.configuration.render_range or 100));

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
	end
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

markview.unload = function ()
	for index, buf in ipairs(markview.attached_buffers) do
		if vim.api.nvim_buf_is_valid(buf) == false then
			table.remove(markview.attached_buffers, index);
		end
	end

	for index, win in ipairs(markview.attached_windows) do
		if vim.api.nvim_win_is_valid(win) == false then
			table.remove(markview.attached_windows, index);
		end
	end
end

markview.setup = function (user_config)
	if user_config and user_config.highlight_groups then
		markview.configuration.highlight_groups = vim.list_extend(markview.configuration.highlight_groups, user_config.highlight_groups);
		user_config.highlight_groups = nil;
	end

	---@type markview.config
	-- Merged configuration tables
	markview.configuration = vim.tbl_deep_extend("force", markview.configuration, user_config or {});

	if type(markview.configuration.highlight_groups) == "string" or vim.islist(markview.configuration.highlight_groups) then
		---@diagnostic disable-next-line
		hls.create(markview.configuration.highlight_groups)
	end
	markview.commands.enableAll();
end

return markview;
