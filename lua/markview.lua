local markview = {};
markview.parser = require("markview/parser");
markview.renderer = require("markview/renderer");

markview.add_hls = function (usr_hls)
	local hl_list = usr_hls or renderer.hls;

  for group_name, tbl in pairs(hl_list) do
    vim.api.nvim_set_hl(0, "Markview_" .. group_name, tbl.value)
  end
end

markview.attached_buffers = {};

markview.suppressed = false;

markview.global_options = {};

---@type markview.config
markview.configuration = {
	restore_conceallevel = true,
	restore_concealcursor = false,

	highlight_groups = {
		red       = { value = { bg = "#453244", fg = "#f38ba8" } },
		red_fg    = { value = { fg = "#f38ba8" } },

		orange    = { value = { bg = "#46393E", fg = "#fab387" } },
		orange_fg = { value = { fg = "#fab387" } },

		yellow    = { value = { bg = "#464245", fg = "#f9e2af" } },
		yellow_fg = { value = { fg = "#f9e2af" } },

		green     = { value = { bg = "#374243", fg = "#a6e3a1" } },
		green_fg  = { value = { fg = "#a6e3a1" } },

		blue      = { value = { bg = "#2E3D51", fg = "#74c7ec" } },
		blue_fg   = { value = { fg = "#74c7ec" } },

		mauve     = { value = { bg = "#393B54", fg = "#b4befe" } },
                mauve_fg  = { value = { fg = "#b4befe" }, type = "normal" },

		grey      = { value = { bg = "#7E839A", fg = "#313244" } },
		grey_fg   = { value = { fg = "#7E839A" } },

		dark      = { value = { bg = "#181825" } },
		dark_2    = { value = { bg = "#303030", fg = "#B4BEFE" } },

		gradient_0 = { value = { fg = "#6583b6" } },
		gradient_1 = { value = { fg = "#637dac" } },
		gradient_2 = { value = { fg = "#6177a2" } },
		gradient_3 = { value = { fg = "#5f7198" } },
		gradient_4 = { value = { fg = "#5d6c8e" } },
		gradient_5 = { value = { fg = "#5b6684" } },
		gradient_6 = { value = { fg = "#59607a" } },
	},
	buf_ignore = { "nofile" },

	modes = { "n" },

	headings = {
		enable = true,
		shift_width = 3,

		heading_1 = {
			style = "icon",
			sign = "󰌕 ", sign_hl = "markview_red_fg",

			icon = "󰼏  ", hl = "markview_red",

		},
		heading_2 = {
			style = "icon",
			sign = "󰌖 ", sign_hl = "markview_orange_fg",

			icon = "󰎨  ", hl = "markview_orange",
		},
		heading_3 = {
			style = "icon",

			icon = "󰼑  ", hl = "markview_yellow",
		},
		heading_4 = {
			style = "icon",

			icon = "󰎲  ", hl = "markview_green",
		},
		heading_5 = {
			style = "icon",

			icon = "󰼓  ", hl = "markview_blue",
		},
		heading_6 = {
			style = "icon",

			icon = "󰎴  ", hl = "markview_mauve",
		}
	},

	code_blocks = {
		enable = true,

		style = "language",
		hl = "dark",

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
			border = "▋", border_hl = { "gradient_0", "gradient_1", "gradient_2", "gradient_3", "gradient_4", "gradient_5", "gradient_6" }
		},

		callouts = {
			--- From `Obsidian`
			{
				match_string = "ABSTRACT",
				callout_preview = "󱉫 Abstract",
				callout_preview_hl = "markview_blue_fg",

				custom_title = true,
				custom_icon = "󱉫 ",

				border = "▋", border_hl = "markview_blue_fg"
			},
			{
				match_string = "TODO",
				callout_preview = " Todo",
				callout_preview_hl = "markview_blue_fg",

				custom_title = true,
				custom_icon = " ",

				border = "▋", border_hl = "markview_blue_fg"
			},
			{
				match_string = "SUCCESS",
				callout_preview = "󰗠 Success",
				callout_preview_hl = "markview_green_fg",

				custom_title = true,
				custom_icon = "󰗠 ",

				border = "▋", border_hl = "markview_green_fg"
			},
			{
				match_string = "QUESTION",
				callout_preview = "󰋗 Question",
				callout_preview_hl = "markview_orange_fg",

				custom_title = true,
				custom_icon = "󰋗 ",

				border = "▋", border_hl = "markview_orange_fg"
			},
			{
				match_string = "FAILURE",
				callout_preview = "󰅙 Failure",
				callout_preview_hl = "markview_red_fg",

				custom_title = true,
				custom_icon = "󰅙 ",

				border = "▋", border_hl = "markview_red_fg"
			},
			{
				match_string = "DANGER",
				callout_preview = " Danger",
				callout_preview_hl = "markview_red_fg",

				custom_title = true,
				custom_icon = "  ",

				border = "▋", border_hl = "markview_red_fg"
			},
			{
				match_string = "BUG",
				callout_preview = " Bug",
				callout_preview_hl = "markview_red_fg",

				custom_title = true,
				custom_icon = "  ",

				border = "▋", border_hl = "markview_red_fg"
			},
			{
				match_string = "EXAMPLE",
				callout_preview = "󱖫 Example",
				callout_preview_hl = "markview_mauve_fg",

				custom_title = true,
				custom_icon = " 󱖫 ",

				border = "▋", border_hl = "markview_mauve_fg"
			},
			{
				match_string = "QUOTE",
				callout_preview = " Quote",
				callout_preview_hl = "markview_grey_fg",

				custom_title = true,
				custom_icon = "  ",

				border = "▋", border_hl = "markview_grey_fg"
			},


			{
				match_string = "NOTE",
				callout_preview = "󰋽 Note",
				callout_preview_hl = "markview_blue_fg",

				border = "▋", border_hl = "markview_blue_fg"
			},
			{
				match_string = "TIP",
				callout_preview = " Tip",
				callout_preview_hl = "markview_green_fg",

				border = "▋", border_hl = "markview_green_fg"
			},
			{
				match_string = "IMPORTANT",
				callout_preview = " Important",
				callout_preview_hl = "markview_yellow_fg",

				border = "▋", border_hl = "markview_yellow_fg"
			},
			{
				match_string = "WARNING",
				callout_preview = " Warning",
				callout_preview_hl = "markview_orange_fg",

				border = "▋", border_hl = "markview_orange_fg"
			},
			{
				match_string = "CAUTION",
				callout_preview = "󰳦 Caution",
				callout_preview_hl = "rainbow1",

				border = "▋", border_hl = "rainbow1"
			},
			{
				match_string = "CUSTOM",
				callout_preview = " 󰠳 Custom",
				callout_preview_hl = "rainbow3",

				custom_title = true,
				custom_icon = " 󰠳 ",

				border = "▋", border_hl = "rainbow3"
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
					"gradient_6", "gradient_5", "gradient_4", "gradient_3", "gradient_2", "gradient_1", "gradient_0"
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
					"gradient_6", "gradient_5", "gradient_4", "gradient_3", "gradient_2", "gradient_1", "gradient_0"
				}
			}
		}
	},

	hyperlinks = {
		enable = true,

		icon = "󰌷 ", icon_hl = "markdownLinkText",
		text_hl = "markdownLinkText",
	},
	images = {
		enable = true,

		icon = "󰥶 ", icon_hl = "markdownLinkText",
		text_hl = "markdownLinkText",
	},

	inline_codes = {
		enable = true,
		corner_left = " ",
		corner_right = " ",

		hl = "dark_2"
	},

	list_items = {
		marker_plus = {
			add_padding = true,

			text = "•",
			hl = "rainbow2"
		},
		marker_minus = {
			add_padding = true,

			text = "•",
			hl = "rainbow4"
		},
		marker_star = {
			add_padding = true,

			text = "•",
			text_hl = "rainbow2"
		},
		marker_dot = {
			add_padding = true
		},
	},

	checkboxes = {
		enable = true,

		checked = {
			text = "✔", hl = "@markup.list.checked"
		},
		unchecked = {
			text = "✘", hl = "@markup.list.unchecked"
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
			"red_fg", "red_fg", "red_fg", "red_fg",
			"red_fg", "red_fg", "red_fg", "red_fg",
			"red_fg", "red_fg", "red_fg", "red_fg",

			"red_fg", "red_fg", "red_fg", "red_fg"
		},

		use_virt_lines = false,
	},
};

markview.commands = {
	toggleAll = function ()
		if markview.suppressed == true then
			markview.suppressed = false;

			vim.o.conceallevel = 2;
			vim.o.concealcursor = "n";

			for _, buf in ipairs(markview.attached_buffers) do
				local parsed_content = markview.parser.init(buf);

				markview.renderer.clear(buf);
				markview.renderer.render(buf, parsed_content, markview.configuration)
			end
		else
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

			markview.suppressed = true;
		end
	end,
	enableAll = function ()
		markview.suppressed = false;

		vim.o.conceallevel = 2;
		vim.o.concealcursor = "n";

		for _, buf in ipairs(markview.attached_buffers) do
			local parsed_content = markview.parser.init(buf);

			markview.renderer.clear(buf);
			markview.renderer.render(buf, parsed_content, markview.configuration)
		end
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

		markview.suppressed = true;
	end,

	enable = function ()
		local buffer = vim.api.nvim_get_current_buf();
		local parsed_content = markview.parser.init(buffer);

		vim.wo.conceallevel = 2;
		vim.wo.concealcursor = "n";

		markview.renderer.clear(buffer);
		markview.renderer.render(buffer, parsed_content, markview.configuration)
	end,

	disable = function ()
		if markview.configuration.restore_conceallevel == true then
			vim.wo.conceallevel = markview.global_options.conceallevel;
		else
			vim.wo.conceallevel = 0;
		end

		if markview.configuration.restore_concealcursor == true then
			vim.wo.concealcursor = markview.global_options.concealcursor;
		end

		markview.renderer.clear(vim.api.nvim_get_current_buf());
	end
}


if vim.islist(markview.configuration.highlight_groups) then
	markview.add_hls(markview.configuration.highlight_groups);
end


vim.api.nvim_create_autocmd({ "colorscheme" }, {
	callback = function ()
			markview.add_hls(markview.configuration.highlight_groups);
	end
})

vim.api.nvim_create_user_command("Markview", function (opts)
	local fargs = opts.fargs;

	if #fargs < 1 then
		markview.commands.toggleAll();
	elseif markview.commands[fargs[1]] then
		markview.commands[fargs[1]]();
	end
end, {
	nargs = "*",
	desc = "Temporarily disable(suppress) Markview preview"
})


markview.setup = function (user_config)
	---@type markview.config
	-- Merged configuration tables

	markview.configuration = vim.tbl_deep_extend("keep", user_config or {}, markview.configuration);
		markview.add_hls(markview.configuration.highlight_groups);
end

return markview;
