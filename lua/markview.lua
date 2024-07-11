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
		vim.api.nvim_set_hl(0, "Markview_" .. hl.group_name, _opt);
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
	restore_conceallevel = true,
	restore_concealcursor = false,

    on_enable = function() end,
    on_disable = function() end,

	highlight_groups = {
		{
			group_name = "col_1",
			value = function ()
				local bg = markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg");
				local fg = markview.colors.get_hl_value(0, "markdownH1", "fg") or "#f38ba8";

				return {
					bg = markview.colors.mix(bg, fg, 0.7, 0.25),
					fg = fg
				}
			end
		},
		{
			group_name = "col_1_fg",
			value = function ()
				local fg = markview.colors.get_hl_value(0, "markdownH1", "fg") or "#f38ba8";

				return {
					fg = fg
				}
			end
		},

		{
			group_name = "col_2",
			value = function ()
				local bg = markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg");
				local fg = markview.colors.get_hl_value(0, "markdownH2", "fg") or "#fab387";

				return {
					bg = markview.colors.mix(bg, fg, 0.7, 0.25),
					fg = fg
				}
			end
		},
		{
			group_name = "col_2_fg",
			value = function ()
				local fg = markview.colors.get_hl_value(0, "markdownH2", "fg") or "#fab387";

				return {
					fg = fg
				}
			end
		},

		{
			group_name = "col_3",
			value = function ()
				local bg = markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg");
				local fg = markview.colors.get_hl_value(0, "markdownH3", "fg") or "#f9e2af";

				return {
					bg = markview.colors.mix(bg, fg, 0.7, 0.25),
					fg = fg
				}
			end
		},
		{
			group_name = "col_3_fg",
			value = function ()
				local fg = markview.colors.get_hl_value(0, "markdownH3", "fg") or "#f9e2af";

				return {
					fg = fg
				}
			end
		},

		{
			group_name = "col_4",
			value = function ()
				local bg = markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg");
				local fg = markview.colors.get_hl_value(0, "markdownH4", "fg") or "#a6e3a1";

				return {
					bg = markview.colors.mix(bg, fg, 0.7, 0.25),
					fg = fg
				}
			end
		},
		{
			group_name = "col_4_fg",
			value = function ()
				local fg = markview.colors.get_hl_value(0, "markdownH4", "fg") or "#a6e3a1";

				return {
					fg = fg
				}
			end
		},

		{
			group_name = "col_5",
			value = function ()
				local bg = markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg");
				local fg = markview.colors.get_hl_value(0, "markdownH5", "fg") or "#74c7ec";

				return {
					bg = markview.colors.mix(bg, fg, 0.7, 0.25),
					fg = fg
				}
			end
		},
		{
			group_name = "col_5_fg",
			value = function ()
				local fg = markview.colors.get_hl_value(0, "markdownH5", "fg") or "#74c7ec";

				return {
					fg = fg
				}
			end
		},

		{
			group_name = "col_6",
			value = function ()
				local bg = markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg");
				local fg = markview.colors.get_hl_value(0, "markdownH6", "fg") or "#b4befe";

				return {
					bg = markview.colors.mix(bg, fg, 0.7, 0.25),
					fg = fg
				}
			end
		},
		{
			group_name = "col_6_fg",
			value = function ()
				local fg = markview.colors.get_hl_value(0, "markdownH6", "fg") or "#b4befe";

				return {
					fg = fg
				}
			end
		},

		{
			group_name = "col_7",
			value = function ()
				local bg = markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg");
				local fg = markview.colors.get_hl_value(0, "Comment", "fg");

				return {
					bg = markview.colors.mix(bg, fg, 0.7, 0.25),
					fg = fg
				}
			end
		},
		{
			group_name = "col_7_fg",
			value = function ()
				local fg = markview.colors.get_hl_value(0, "Comment", "fg");

				return {
					fg = fg
				}
			end
		},

		{
			group_name = "layer",
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
			group_name = "layer_2",
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
				return markview.colors.create_gradient("gradient_", markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg"), markview.colors.get_hl_value(0, "Title", "fg"), 10, "fg");
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
			sign = "󰌕 ", sign_hl = "Markview_col_1_fg",

			icon = "󰼏  ", hl = "Markview_col_1",

		},
		heading_2 = {
			style = "icon",
			sign = "󰌖 ", sign_hl = "Markview_col_2_fg",

			icon = "󰎨  ", hl = "Markview_col_2",
		},
		heading_3 = {
			style = "icon",

			icon = "󰼑  ", hl = "Markview_col_3",
		},
		heading_4 = {
			style = "icon",

			icon = "󰎲  ", hl = "Markview_col_4",
		},
		heading_5 = {
			style = "icon",

			icon = "󰼓  ", hl = "Markview_col_5",
		},
		heading_6 = {
			style = "icon",

			icon = "󰎴  ", hl = "Markview_col_6",
		},

		setext_1 = {
			style = "github",

			icon = "   ", hl = "Markview_col_1",
			underline = "━"
		},
		setext_2 = {
			style = "github",

			icon = "   ", hl = "Markview_col_2",
			underline = "─"
		}
	},

	code_blocks = {
		enable = true,

		style = "language",
		hl = "layer_2",

		position = "overlay",

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
			border = "▋", border_hl = "Markview_col_7_fg"
		},

		callouts = {
			--- From `Obsidian`
			{
				match_string = "ABSTRACT",
				callout_preview = "󱉫 Abstract",
				callout_preview_hl = "Markview_col_5_fg",

				custom_title = true,
				custom_icon = "󱉫 ",

				border = "▋", border_hl = "Markview_col_5_fg"
			},
			{
				match_string = "TODO",
				callout_preview = " Todo",
				callout_preview_hl = "Markview_col_5_fg",

				custom_title = true,
				custom_icon = " ",

				border = "▋", border_hl = "Markview_col_5_fg"
			},
			{
				match_string = "SUCCESS",
				callout_preview = "󰗠 Success",
				callout_preview_hl = "Markview_col_4_fg",

				custom_title = true,
				custom_icon = "󰗠 ",

				border = "▋", border_hl = "Markview_col_4_fg"
			},
			{
				match_string = "QUESTION",
				callout_preview = "󰋗 Question",
				callout_preview_hl = "Markview_col_2_fg",

				custom_title = true,
				custom_icon = "󰋗 ",

				border = "▋", border_hl = "Markview_col_2_fg"
			},
			{
				match_string = "FAILURE",
				callout_preview = "󰅙 Failure",
				callout_preview_hl = "Markview_col_1_fg",

				custom_title = true,
				custom_icon = "󰅙 ",

				border = "▋", border_hl = "Markview_col_1_fg"
			},
			{
				match_string = "DANGER",
				callout_preview = " Danger",
				callout_preview_hl = "Markview_col_1_fg",

				custom_title = true,
				custom_icon = "  ",

				border = "▋", border_hl = "Markview_col_1_fg"
			},
			{
				match_string = "BUG",
				callout_preview = " Bug",
				callout_preview_hl = "Markview_col_1_fg",

				custom_title = true,
				custom_icon = "  ",

				border = "▋", border_hl = "Markview_col_1_fg"
			},
			{
				match_string = "EXAMPLE",
				callout_preview = "󱖫 Example",
				callout_preview_hl = "Markview_col_6_fg",

				custom_title = true,
				custom_icon = " 󱖫 ",

				border = "▋", border_hl = "Markview_col_6_fg"
			},
			{
				match_string = "QUOTE",
				callout_preview = " Quote",
				callout_preview_hl = "Markview_col_7_fg",

				custom_title = true,
				custom_icon = "  ",

				border = "▋", border_hl = "Markview_col_7_fg"
			},


			{
				match_string = "NOTE",
				callout_preview = "󰋽 Note",
				callout_preview_hl = "Markview_col_5_fg",

				border = "▋", border_hl = "Markview_col_5_fg"
			},
			{
				match_string = "TIP",
				callout_preview = " Tip",
				callout_preview_hl = "Markview_col_4_fg",

				border = "▋", border_hl = "Markview_col_4_fg"
			},
			{
				match_string = "IMPORTANT",
				callout_preview = " Important",
				callout_preview_hl = "Markview_col_3_fg",

				border = "▋", border_hl = "Markview_col_3_fg"
			},
			{
				match_string = "WARNING",
				callout_preview = " Warning",
				callout_preview_hl = "Markview_col_2_fg",

				border = "▋", border_hl = "Markview_col_2_fg"
			},
			{
				match_string = "CAUTION",
				callout_preview = "󰳦 Caution",
				callout_preview_hl = "Markview_col_1_fg",

				border = "▋", border_hl = "Markview_col_1_fg"
			},
			{
				match_string = "CUSTOM",
				callout_preview = "󰠳 Custom",
				callout_preview_hl = "Markview_col_3_fg",

				custom_title = true,
				custom_icon = " 󰠳 ",

				border = "▋", border_hl = "Markview_col_3_fg"
			}
		}
	},
	horizontal_rules = {
		enable = true,

		position = "overlay",
		parts = {
			{
				type = "repeating",
				repeat_amount = function () --[[@as function]]
					return math.floor((vim.o.columns - 3) / 2);
				end,

				text = "─",
				hl = {
					"Markview_gradient_1", "Markview_gradient_2", "Markview_gradient_3", "Markview_gradient_4", "Markview_gradient_5", "Markview_gradient_6", "Markview_gradient_7", "Markview_gradient_8", "Markview_gradient_9", "Markview_gradient_10"
				}
			},
			{
				type = "text",
				text = "  ",

				repeat_amount = vim.o.columns
			},
			{
				type = "repeating",
				repeat_amount = function () --[[@as function]]
					return math.ceil((vim.o.columns - 3) / 2);
				end,

				direction = "right",
				text = "─",
				hl = {
					"Markview_gradient_1", "Markview_gradient_2", "Markview_gradient_3", "Markview_gradient_4", "Markview_gradient_5", "Markview_gradient_6", "Markview_gradient_7", "Markview_gradient_8", "Markview_gradient_9", "Markview_gradient_10"
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

		hl = "layer"
	},

	list_items = {
		marker_minus = {
			add_padding = true,

			text = "",
			hl = "markview_col_2_fg"
		},
		marker_plus = {
			add_padding = true,

			text = "",
			hl = "markview_col_4_fg"
		},
		marker_star = {
			add_padding = true,

			text = "",
			text_hl = "markview_col_6_fg"
		},
		marker_dot = {
			add_padding = true
		},
	},

	checkboxes = {
		enable = true,

		checked = {
			text = "✔", hl = "markview_col_4_fg"
		},
		pending = {
			text = "◯", hl = "Markview_col_2_fg"
		},
		unchecked = {
			text = "✘", hl = "Markview_col_1_fg"
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
			"col_1_fg", "col_1_fg", "col_1_fg", "col_1_fg",
			"col_1_fg", "col_1_fg", "col_1_fg", "col_1_fg",
			"col_1_fg", "col_1_fg", "col_1_fg", "col_1_fg",

			"col_1_fg", "col_1_fg", "col_1_fg", "col_1_fg"
		},

		use_virt_lines = false,
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

			markview.renderer.clear(buf);
			markview.renderer.render(buf, parsed_content, markview.configuration)
		end
        markview.configuration.on_enable()
	end,
	disableAll = function ()
		if markview.configuration.restore_conceallevel == true then
			vim.o.conceallevel = markview.global_options.conceallevel;
		else
			vim.o.conceallevel = 0;
		end

		if markview.configuration.restore_concealcursor == true then
			vim.o.concealcursor = markview.global_options.concealcursor;
		end

		for _, buf in ipairs(markview.attached_buffers) do
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

		if not vim.list_contains(markview.attached_buffers, buffer) or not vim.api.nvim_buf_is_valid(buffer) then
			return;
		end

		local windows = markview.find_attached_wins(buffer);

		local parsed_content = markview.parser.init(buffer);

		markview.state.buf_states[buffer] = true;

		for _, window in ipairs(windows) do
			vim.wo[window].conceallevel = 2;
			vim.wo[window].concealcursor = "n";
		end

		markview.renderer.clear(buffer);
		markview.renderer.render(buffer, parsed_content, markview.configuration)
        markview.configuration.on_enable()
	end,

	disable = function (buf)
		local buffer = tonumber(buf) or vim.api.nvim_get_current_buf();

		if not vim.list_contains(markview.attached_buffers, buffer) or not vim.api.nvim_buf_is_valid(buffer) then
			return;
		end

		local windows = markview.find_attached_wins(buffer);

		for _, window in ipairs(windows) do
			if markview.configuration.restore_conceallevel == true then
				vim.wo[window].conceallevel = markview.global_options.conceallevel;
			else
				vim.wo[window].conceallevel = 0;
			end

			if markview.configuration.restore_concealcursor == true then
				vim.wo[window].concealcursor = markview.global_options.concealcursor;
			end
		end

		markview.renderer.clear(buffer);
		markview.state.buf_states[buffer] = false;
        markview.configuration.on_disable()
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
