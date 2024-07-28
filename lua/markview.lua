local markview = {};
markview.parser = require("markview/parser");
markview.renderer = require("markview/renderer");
markview.keymaps = require("markview/keymaps");

markview.colors = require("markview/colors");

markview.add_hls = function (obj)
	local use_hl = {};

	for _, hl in ipairs(obj) do
		if hl.output and type(hl.output) == "function" and pcall(hl.output) then
			use_hl = vim.list_extend(use_hl, hl.output())
		elseif hl.group_name and hl.value then
			table.insert(use_hl, hl)
		end
	end

	for _, hl in ipairs(use_hl) do
		local _opt = hl.value;

		if type(hl.value) == "function" then
			_opt = hl.value();
		end

		_opt.default = true;
		vim.api.nvim_set_hl(0, "Markview" .. hl.group_name, _opt);
	end
end

markview.find_attached_wins = function (buf)
	local attached_wins = {};

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == buf then
			table.insert(attached_wins, win);
		end
	end

	return attached_wins;
end


markview.attached_buffers = {};
markview.attached_windows = {};

markview.state = {
	enable = true,
	buf_states = {}
};

markview.global_options = {};

---@type markview.config
markview.configuration = {
	options = {
		on_enable = {
			conceallevel = 2,
			concealcursor = "n"
		},

		on_disable = {
			conceallevel = 0,
			concealcursor = ""
		}
	},

	highlight_groups = {
		{
			output = function ()
				local bg = markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg");
				local fg = markview.colors.get_hl_value(0, "markdownH1", "fg") or "#f38ba8";

				return {
					{
						group_name = "Col1",
						value = {
							bg = markview.colors.mix(bg, fg, 0.7, 0.25),
							fg = fg
						}
					},
					{
						group_name = "Col1Fg",
						value = {
							fg = fg
						}
					},
					{
						group_name = "Col1Inv",
						value = {
							bg = fg,
							fg = bg
						}
					},
				}
			end
		},

		{
			output = function ()
				local bg = markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg");
				local fg = markview.colors.get_hl_value(0, "markdownH2", "fg") or "#fab387";

				return {
					{
						group_name = "Col2",
						value = {
							bg = markview.colors.mix(bg, fg, 0.7, 0.25),
							fg = fg
						}
					},
					{
						group_name = "Col2Fg",
						value = {
							fg = fg
						}
					},
					{
						group_name = "Col2Inv",
						value = {
							bg = fg,
							fg = bg
						}
					},
				}
			end
		},

		{
			output = function ()
				local bg = markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg");
				local fg = markview.colors.get_hl_value(0, "markdownH3", "fg") or "#f9e2af";

				return {
					{
						group_name = "Col3",
						value = {
							bg = markview.colors.mix(bg, fg, 0.7, 0.25),
							fg = fg
						}
					},
					{
						group_name = "Col3Fg",
						value = {
							fg = fg
						}
					},
					{
						group_name = "Col3Inv",
						value = {
							bg = fg,
							fg = bg
						}
					},
				}
			end
		},

		{
			output = function ()
				local bg = markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg");
				local fg = markview.colors.get_hl_value(0, "markdownH4", "fg") or "#a6e3a1";


				return {
					{
						group_name = "Col4",
						value = {
							bg = markview.colors.mix(bg, fg, 0.7, 0.25),
							fg = fg
						}
					},
					{
						group_name = "Col4Fg",
						value = {
							fg = fg
						}
					},
					{
						group_name = "Col4Inv",
						value = {
							bg = fg,
							fg = bg
						}
					},
				}
			end
		},

		{
			output = function ()
				local bg = markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg");
				local fg = markview.colors.get_hl_value(0, "markdownH5", "fg") or "#74c7ec";

				return {
					{
						group_name = "Col5",
						value = {
							bg = markview.colors.mix(bg, fg, 0.7, 0.25),
							fg = fg
						}
					},
					{
						group_name = "Col5Fg",
						value = {
							fg = fg
						}
					},
					{
						group_name = "Col5Inv",
						value = {
							bg = fg,
							fg = bg
						}
					},
				}
			end
		},

		{
			output = function ()
				local bg = markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg");
				local fg = markview.colors.get_hl_value(0, "markdownH6", "fg") or "#b4befe";

				return {
					{
						group_name = "Col6",
						value = {
							bg = markview.colors.mix(bg, fg, 0.7, 0.25),
							fg = fg
						}
					},
					{
						group_name = "Col6Fg",
						value = {
							fg = fg
						}
					},
					{
						group_name = "Col6Inv",
						value = {
							bg = fg,
							fg = bg
						}
					},
				}
			end
		},

		{
			output = function ()
				local bg = markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg");
				local fg = markview.colors.get_hl_value(0, "Comment", "fg");

				return {
					{
						group_name = "Col7",
						value = {
							bg = markview.colors.mix(bg, fg, 0.7, 0.25),
							fg = fg
						}
					},
					{
						group_name = "Col7Fg",
						value = {
							fg = fg
						}
					},
					{
						group_name = "Col7Inv",
						value = {
							bg = fg,
							fg = bg
						}
					},
				}
			end
		},

		{
			group_name = "Layer",
			value = function ()
				local bg = markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg");
				local fg = markview.colors.get_hl_value(0, "Comment", "fg");

				local txt = markview.colors.get_hl_value(0, "FloatTitle", "fg")

				return {
					bg = markview.colors.mix(bg, fg, 1, 0.20),
					fg = txt
				}
			end
		},
		{
			group_name = "Layer2",
			value = function ()
				local bg = markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg");
				local fg = markview.colors.get_hl_value(0, "Comment", "fg");

				return {
					bg = markview.colors.mix(bg, fg, 0.85, 0.13),
				}
			end
		},
		{
			output = function ()
				return markview.colors.create_gradient("Gradient", markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg"), markview.colors.get_hl_value(0, "Title", "fg"), 10, "fg");
			end
		}
	},
	buf_ignore = { "nofile" },

	modes = { "n", "no" },

	headings = {
		enable = true,
		shift_width = 3,

		heading_1 = {
			style = "icon",
			sign = "󰌕 ", sign_hl = "MarkviewCol1Fg",

			icon = "󰼏  ", hl = "MarkviewCol1",

		},
		heading_2 = {
			style = "icon",
			sign = "󰌖 ", sign_hl = "MarkviewCol2Fg",

			icon = "󰎨  ", hl = "MarkviewCol2",
		},
		heading_3 = {
			style = "icon",

			icon = "󰼑  ", hl = "MarkviewCol3",
		},
		heading_4 = {
			style = "icon",

			icon = "󰎲  ", hl = "MarkviewCol4",
		},
		heading_5 = {
			style = "icon",

			icon = "󰼓  ", hl = "MarkviewCol5",
		},
		heading_6 = {
			style = "icon",

			icon = "󰎴  ", hl = "MarkviewCol6",
		},

		setext_1 = {
			style = "github",

			icon = "   ", hl = "MarkviewCol1",
			underline = "━"
		},
		setext_2 = {
			style = "github",

			icon = "   ", hl = "MarkviewCol2",
			underline = "─"
		}
	},

	code_blocks = {
		enable = true,

		style = "language",
		hl = "Layer2",

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

		default = {
			border = "▋", border_hl = "MarkviewCol7Fg"
		},

		callouts = {
			--- From `Obsidian`
			{
				match_string = "ABSTRACT",
				callout_preview = "󱉫 Abstract",
				callout_preview_hl = "MarkviewCol5Fg",

				custom_title = true,
				custom_icon = "󱉫 ",

				border = "▋", border_hl = "MarkviewCol5Fg"
			},
			{
				match_string = "TODO",
				callout_preview = " Todo",
				callout_preview_hl = "MarkviewCol5Fg",

				custom_title = true,
				custom_icon = " ",

				border = "▋", border_hl = "MarkviewCol5Fg"
			},
			{
				match_string = "SUCCESS",
				callout_preview = "󰗠 Success",
				callout_preview_hl = "MarkviewCol4Fg",

				custom_title = true,
				custom_icon = "󰗠 ",

				border = "▋", border_hl = "MarkviewCol4Fg"
			},
			{
				match_string = "QUESTION",
				callout_preview = "󰋗 Question",
				callout_preview_hl = "MarkviewCol2Fg",

				custom_title = true,
				custom_icon = "󰋗 ",

				border = "▋", border_hl = "MarkviewCol2Fg"
			},
			{
				match_string = "FAILURE",
				callout_preview = "󰅙 Failure",
				callout_preview_hl = "MarkviewCol1Fg",

				custom_title = true,
				custom_icon = "󰅙 ",

				border = "▋", border_hl = "MarkviewCol1Fg"
			},
			{
				match_string = "DANGER",
				callout_preview = " Danger",
				callout_preview_hl = "MarkviewCol1Fg",

				custom_title = true,
				custom_icon = "  ",

				border = "▋", border_hl = "MarkviewCol1Fg"
			},
			{
				match_string = "BUG",
				callout_preview = " Bug",
				callout_preview_hl = "MarkviewCol1Fg",

				custom_title = true,
				custom_icon = "  ",

				border = "▋", border_hl = "MarkviewCol1Fg"
			},
			{
				match_string = "EXAMPLE",
				callout_preview = "󱖫 Example",
				callout_preview_hl = "MarkviewCol6Fg",

				custom_title = true,
				custom_icon = " 󱖫 ",

				border = "▋", border_hl = "MarkviewCol6Fg"
			},
			{
				match_string = "QUOTE",
				callout_preview = " Quote",
				callout_preview_hl = "MarkviewCol7Fg",

				custom_title = true,
				custom_icon = "  ",

				border = "▋", border_hl = "MarkviewCol7Fg"
			},


			{
				match_string = "NOTE",
				callout_preview = "󰋽 Note",
				callout_preview_hl = "MarkviewCol5Fg",

				border = "▋", border_hl = "MarkviewCol5Fg"
			},
			{
				match_string = "TIP",
				callout_preview = " Tip",
				callout_preview_hl = "MarkviewCol4Fg",

				border = "▋", border_hl = "MarkviewCol4Fg"
			},
			{
				match_string = "IMPORTANT",
				callout_preview = " Important",
				callout_preview_hl = "MarkviewCol3Fg",

				border = "▋", border_hl = "MarkviewCol3Fg"
			},
			{
				match_string = "WARNING",
				callout_preview = " Warning",
				callout_preview_hl = "MarkviewCol2Fg",

				border = "▋", border_hl = "MarkviewCol2Fg"
			},
			{
				match_string = "CAUTION",
				callout_preview = "󰳦 Caution",
				callout_preview_hl = "MarkviewCol1Fg",

				border = "▋", border_hl = "MarkviewCol1Fg"
			},
			{
				match_string = "CUSTOM",
				callout_preview = "󰠳 Custom",
				callout_preview_hl = "MarkviewCol3Fg",

				custom_title = true,
				custom_icon = " 󰠳 ",

				border = "▋", border_hl = "MarkviewCol3Fg"
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

	links = {
		enable = true,

		inline_links = {
			icon = "󰌷 ", icon_hl = "markdownLinkText",
			hl = "markdownLinkText",
		},
		images = {
			icon = "󰥶 ", icon_hl = "markdownLinkText",
			hl = "markdownLinkText",
		},
		emails = {
			icon = " ", icon_hl = "@markup.link.url",
			hl = "@markup.link.url",
		}
	},

	inline_codes = {
		enable = true,
		corner_left = " ",
		corner_right = " ",

		hl = "Layer"
	},

	list_items = {
		marker_minus = {
			add_padding = true,

			text = "",
			hl = "markviewCol2Fg"
		},
		marker_plus = {
			add_padding = true,

			text = "",
			hl = "markviewCol4Fg"
		},
		marker_star = {
			add_padding = true,

			text = "",
			text_hl = "markviewCol6Fg"
		},
		marker_dot = {
			add_padding = true
		},
	},

	checkboxes = {
		enable = true,

		checked = {
			text = "✔", hl = "markviewCol4Fg"
		},
		pending = {
			text = "◯", hl = "MarkviewCol2Fg"
		},
		unchecked = {
			text = "✘", hl = "MarkviewCol1Fg"
		}
	},

	tables = {
		enable = true,
		text = {
			"╭", "─", "╮", "┬",
			"├", "│", "┤", "┼",
			"╰", "─", "╯", "┴",

			"╼", "╾", "╴", "╶"
		},
		hl = {
			"MarkviewCol1Fg", "MarkviewCol1Fg", "MarkviewCol1Fg", "MarkviewCol1Fg",
			"MarkviewCol1Fg", "MarkviewCol1Fg", "MarkviewCol1Fg", "MarkviewCol1Fg",
			"MarkviewCol1Fg", "MarkviewCol1Fg", "MarkviewCol1Fg", "MarkviewCol1Fg",

			"MarkviewCol1Fg", "MarkviewCol1Fg", "MarkviewCol1Fg", "MarkviewCol1Fg"
		},

		use_virt_lines = false
	},
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

		vim.o.conceallevel = 2;
		vim.o.concealcursor = "n";

		for _, buf in ipairs(markview.attached_buffers) do
			local parsed_content = markview.parser.init(buf);
			local windows = markview.find_attached_wins(buffer);
			local options = markview.configuration.options or {};

			for _, window in ipairs(windows) do
				vim.wo[window].conceallevel = type(options.on_enable) == "table" and options.on_enable.conceallevel or 2;
				vim.wo[window].concealcursor = type(options.on_enable) == "table" and options.on_enable.concealcursor or "n";
			end

			markview.renderer.clear(buf);
			markview.renderer.render(buf, parsed_content, markview.configuration)
		end
	end,
	disableAll = function ()
		for _, buf in ipairs(markview.attached_buffers) do
			local windows = markview.find_attached_wins(buffer);
			local options = markview.configuration.options or {};

			for _, window in ipairs(windows) do
				vim.wo[window].conceallevel = type(options.on_disable) == "table" and options.on_disable.conceallevel or markview.global_options.conceallevel;
				vim.wo[window].concealcursor = type(options.on_disable) == "table" and options.on_disable.concealcursor or markview.global_options.concealcursor;
			end

			markview.renderer.clear(buf);
		end

		markview.state.enable = false;
	end,

	toggle = function (buf)
		local buffer = tonumber(buf) or vim.api.nvim_get_current_buf();

		if not vim.list_contains(markview.attached_buffers, buffer) or not vim.api.nvim_buf_is_valid(buffer) then
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
		local options = markview.configuration.options or {};

		if not vim.list_contains(markview.attached_buffers, buffer) or not vim.api.nvim_buf_is_valid(buffer) then
			return;
		end

		local windows = markview.find_attached_wins(buffer);

		local parsed_content = markview.parser.init(buffer);

		markview.state.buf_states[buffer] = true;

		for _, window in ipairs(windows) do
			vim.wo[window].conceallevel = type(options.on_enable) == "table" and options.on_enable.conceallevel or 2;
			vim.wo[window].concealcursor = type(options.on_enable) == "table" and options.on_enable.concealcursor or "n";
		end

		markview.renderer.clear(buffer);
		markview.renderer.render(buffer, parsed_content, markview.configuration)
	end,

	disable = function (buf)
		local buffer = tonumber(buf) or vim.api.nvim_get_current_buf();
		local options = markview.configuration.options or {};

		if not vim.list_contains(markview.attached_buffers, buffer) or not vim.api.nvim_buf_is_valid(buffer) then
			return;
		end

		local windows = markview.find_attached_wins(buffer);

		for _, window in ipairs(windows) do
			vim.wo[window].conceallevel = type(options.on_disable) == "table" and options.on_disable.conceallevel or markview.global_options.conceallevel;
			vim.wo[window].concealcursor = type(options.on_disable) == "table" and options.on_disable.concealcursor or markview.global_options.concealcursor;
		end

		markview.renderer.clear(buffer);
		markview.state.buf_states[buffer] = false;
	end
}


vim.api.nvim_create_autocmd({ "colorscheme" }, {
	callback = function ()
		if type(markview.configuration.highlight_groups) == "table" then
			markview.add_hls(markview.configuration.highlight_groups);
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
					if vim.list_contains({ "enable", "disable", "toggle" }, cmd) then
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
})


markview.setup = function (user_config)
	---@type markview.config
	-- Merged configuration tables
	markview.configuration = vim.tbl_extend("keep", user_config or {}, markview.configuration);

	if vim.islist(markview.configuration.highlight_groups) then
		markview.add_hls(markview.configuration.highlight_groups);
	end
end

return markview;
