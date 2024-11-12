local typst = {};
local spec = require("markview.spec");
local utils = require("markview.utils");
local languages = require("markview.languages");

local devicons_loaded, devicons = pcall(require, "nvim-web-devicons");
local mini_loaded, MiniIcons = pcall(require, "mini.icons");

local get_config = function (...)
	local _c = spec.get({ "typst", ... });

	if
		not _c or
		(type(_c) == "table" and _c.enable == false)
	then
		return;
	end

	return _c;
end

typst.get_icon = function (icons, ft)
	if type(icons) ~= "string" or icons == "" then
		return "", "Normal";
	end

	if icons == "devicons" and devicons_loaded then
		return devicons.get_icon(nil, ft, { default = true })
	elseif icons == "mini" and mini_loaded then
		return MiniIcons.get("extension", ft);
	elseif icons == "internal" then
		return languages.get_icon(ft);
	end

	return "󰡯", "Normal";
end

typst.__ns = {
	__call = function (self, key)
		return self[key] or self.default;
	end
}

typst.ns = {
	default = vim.api.nvim_create_namespace("markview/typst"),
};
setmetatable(typst.ns, typst.__ns)

typst.set_ns = function ()
	local ns_pref = get_config("use_seperate_ns");
	if not ns_pref then ns_pref = true; end

	local available = vim.api.nvim_get_namespaces();
	local ns_list = {
		["headings"] = "markview/typst/headings",
		["injections"] = "markview/typst/injections",
		["links"] = "markview/typst/links",
		["symbols"] = "markview/typst/symbols",
	};

	if ns_pref == true then
		for ns, name in pairs(ns_list) do
			if vim.list_contains(available, ns) == false then
				typst.ns[ns] = vim.api.nvim_create_namespace(name);
			end
		end
	end
end

typst.custom_config = function (config, value)
	if not config.custom or not value then
		return config;
	end

	for _, custom in ipairs(config.custom) do
		if custom.match_string and value:match(custom.match_string) then
			return vim.tbl_deep_extend("force", config, custom);
		end
	end

	return config;
end


typst.escaped = function (buffer, item)
	local config = get_config("escapes");

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, typst.ns("symbols"), range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = "",
	});
end

typst.heading = function (buffer, item)
	local config = get_config("headings");

	if not config then
		return;
	elseif not config["heading_" .. item.level] then
		return;
	end

	local range = item.range;
	config = config["heading_" .. item.level];

	if config.style == "simple" then
		vim.api.nvim_buf_set_extmark(buffer, typst.ns("headings"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			line_hl_group = utils.set_hl(config.hl)
		});
	elseif config.style == "icon" then
		vim.api.nvim_buf_set_extmark(buffer, typst.ns("headings"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + item.level + 1,
			conceal = "",
			sign_text = config.sign,
			sign_hl_group = utils.set_hl(config.sign_hl),
			virt_text_pos = "inline",
			virt_text = {
				{ string.rep(" ", item.level * (get_config("headings").shift_width or 1)) },
				{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) },
			},
			line_hl_group = utils.set_hl(config.hl),

			hl_mode = "combine"
		});
	end
end

typst.list_item = function (buffer, item)
	local config = get_config("list_items") or {};

	if item.marker == "-" then
		config = config.marker_minus;
	elseif item.marker == "+" then
		config = config.marker_plus;
	elseif item.marker:match("%d+%.") then
		config = config.marker_dot;
	end

	if not config then
		return;
	end

	local indent = get_config("list_items", "indent_size");
	local shift  = get_config("list_items", "shift_width");

	local range = item.range;

	if config.add_padding == true then
		for l = range.row_start, range.row_end do
			local line = item.text[(l - range.row_start) + 1];

			vim.api.nvim_buf_set_extmark(buffer, typst.ns("symbols"), l, math.min(#line, range.col_start - item.indent), {
				undo_restore = false, invalidate = true,
				end_col = math.min(#line, range.col_start),
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(" ", math.floor((item.indent / indent) + 1) * shift) }
				}
			});
		end
	end

	if item.marker == "-" then
		vim.api.nvim_buf_set_extmark(buffer, typst.ns("symbols"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + 1,

			virt_text_pos = "overlay",
			virt_text = {
				{ config.text or "", utils.set_hl(config.hl) }
			}
		});
	elseif item.marker == "+" then
		vim.api.nvim_buf_set_extmark(buffer, typst.ns("symbols"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + 1,
			conceal = "",

			virt_text_pos = "inline",
			virt_text = {
				{ string.format(config.text or "%d.", item.number), utils.set_hl(config.hl) }
			}
		});
	end
end

typst.code = function (buffer, item)
	---+${func, Renders Code blocks}
	local config = get_config("codes");
	local range = item.range;

	if not config then
		return;
	end

	if config.style == "simple" then
		vim.api.nvim_buf_set_extmark(buffer, typst.ns("codes"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "right_align",
			virt_text = {
				{ config.text, utils.set_hl(config.text_hl or config.hl) },
			},

			sign_text = config.sign == true and sign or nil,
			sign_hl_group = utils.set_hl(config.sign_hl or config.hl)
		});


		vim.api.nvim_buf_set_extmark(buffer, typst.ns("code_blocks"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_row = range.row_end, end_col = range.col_end,
			line_hl_group = utils.set_hl(config.hl),
		});
	elseif config.style == "block" then
		local pad_amount = config.pad_amount or 3;
		local block_width = config.min_width - (2 * pad_amount);

		--- Get maximum length of the lines within the code block
		for l, line in ipairs(item.text) do
			if (l ~= 1 and l ~= #item.text) and vim.fn.strdisplaywidth(line) > block_width then
				block_width = vim.fn.strdisplaywidth(line);
			end
		end

		if config.text_direction == nil or config.text_direction == "left" then
			vim.api.nvim_buf_set_extmark(buffer, typst.ns("code_blocks"), range.row_start, range.col_start, {
				undo_restore = false, invalidate = true,

				virt_lines_above = true,
				virt_lines = {
					{
						{ string.rep(" ", range.col_start) },
						{ config.pad_char or " ", utils.set_hl(config.hl) },
						{ config.text or "", utils.set_hl(config.text_hl or config.hl) },
						{ string.rep(config.pad_char or " ", block_width + (pad_amount - 1) - (vim.fn.strdisplaywidth(config.text or ""))), utils.set_hl(config.hl) },
						{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
					}
				},

				sign_text = config.sign,
				sign_hl_group = utils.set_hl(config.sign_hl or config.hl),
			});
		elseif config.text_direction == "right" then
			vim.api.nvim_buf_set_extmark(buffer, typst.ns("code_blocks"), range.row_start, range.col_start, {
				undo_restore = false, invalidate = true,

				virt_lines_above = true,
				virt_lines = {
					{
						{ string.rep(" ", range.col_start) },
						{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
						{ string.rep(config.pad_char or " ", block_width + (pad_amount - 1) - (vim.fn.strdisplaywidth(config.text or ""))), utils.set_hl(config.hl) },
						{ config.text or "", utils.set_hl(config.text_hl or config.hl) },
						{ config.pad_char or " ", utils.set_hl(config.hl) },
					}
				},

				sign_text = config.sign,
				sign_hl_group = utils.set_hl(config.sign_hl or config.hl),
			});
		end

		vim.api.nvim_buf_set_extmark(buffer, typst.ns("code_blocks"), range.row_end, range.col_end, {
			undo_restore = false, invalidate = true,

			virt_lines = {
				{
					{ string.rep(" ", range.col_start) },
					{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
					{ string.rep(config.pad_char or " ", block_width), utils.set_hl(config.hl) },
					{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
				}
			}
		});

		for l = range.row_start, range.row_end, 1 do
			local line = item.text[(l + 1) - range.row_start];
			local final = line;

			--- Left padding
			vim.api.nvim_buf_set_extmark(buffer, typst.ns("code_blocks"), l, range.col_start, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) }
				},
			});

			--- Right padding
			vim.api.nvim_buf_set_extmark(buffer, typst.ns("code_blocks"), l, range.col_start + #line, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config.pad_char or " ", block_width - vim.fn.strdisplaywidth(final)), utils.set_hl(config.hl) },
					{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) }
				},
			});

			--- Background color
			vim.api.nvim_buf_set_extmark(buffer, typst.ns("code_blocks"), l, range.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + #line,
				hl_group = utils.set_hl(config.hl)
			});
		end
	end
	---_
end

typst.math = function (buffer, item)
	local range = item.range;
	local config;

	if get_config("inlines") and item.inline then
		---@type table
		config = get_config("inlines");

		vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + 1,
			conceal = "",

			virt_text_pos = "inline",
			virt_text = {
				{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
				{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
			},

			hl_mode = "combine"
		});

		vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_start, range.col_start + #item.text[1], {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) }
			}
		});

		vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_row = range.row_end,
			end_col = range.col_end,

			hl_group = utils.set_hl(config.hl),
		});

		vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_end, range.col_end - (item.closed and 1 or 0), {
			undo_restore = false, invalidate = true,
			end_col = range.col_end,
			conceal = "",

			virt_text_pos = "inline",
			virt_text = {
				{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
				{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) },
			},

			hl_mode = "combine"
		});

		vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_end, 0, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
			}
		});

		for l = 1, #item.text - 2 do
			vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_start + l, math.min(#item.text[l + 1], 0), {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
				}
			});

			vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_start + l, #item.text[l + 1], {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) }
				}
			});
		end
	elseif get_config("blocks") then
		---@type table
		config = get_config("blocks");

		vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + 1,
			conceal = "",

			virt_text_pos = "right_align",
			virt_text = { { config.text or "", utils.set_hl(config.text_hl or config.hl) } },

			hl_mode = "combine",
			line_hl_group = utils.set_hl(config.hl)
		});

		vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_end, math.max(0, range.col_end - 1), {
			undo_restore = false, invalidate = true,
			end_col = range.col_end,
			conceal = "",

			line_hl_group = utils.set_hl(config.hl)
		});

		for l = 1, #item.text - 2 do
			vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_start + l, range.col_start, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config.pad_char or "", config.pad_amount or 0), utils.set_hl(config.hl) }
				},

				line_hl_group = utils.set_hl(config.hl)
			});
		end
	end
end

typst.link_url = function (buffer, item)
	local config = get_config("url_links");

	if not config then
		return;
	end

	local range = item.range;
	config = typst.custom_config(config, item.label)

	vim.api.nvim_buf_set_extmark(buffer, typst.ns("links"), range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns("links"), range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns("links"), range.row_start, range.col_end, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) },
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});
end

typst.raw_block = function (buffer, item)
	---+${func, Renders Code blocks}
	local config = get_config("raw_blocks");
	local range = item.range;

	if not config then
		return;
	end

	local ft = languages.get_ft(item.language);
	local icon, hl, sign_hl = typst.get_icon(config.icons, ft);

	local sign = (config.icon or icon);
	sign_hl = config.sign_hl or sign_hl;

	if
		icon and
		icon ~= "" and
		not icon:match("(%s)$")
	then
		icon = " " .. icon .. " ";
	elseif not icon then
		icon = "";
	end

	local lang_name;

	--- In case the user changes the name ALWAYS prioritize
	--- user-defined names over the default ones.
	if config.language_names then
		--- It may be faster to use {key: value} instead,
		--- TODO: Use key value pairs instead.
		for match, replace in pairs(config.language_names) do
			if ft == match then
				lang_name = replace;
				goto nameFound;
			end
		end
	end

	lang_name = languages.get_name(ft)
	::nameFound::

	local label = icon .. lang_name;

	if config.style == "simple" then
		vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + 3 + vim.fn.strdisplaywidth(item.language or ""),
			conceal = "",

			virt_text_pos = config.language_direction == "left" and "right_align" or "inline",
			virt_text = {
				{ " " },
				{ label, utils.set_hl(hl) },
				{ " " },
			},

			hl_mode = "combine",

			sign_text = config.sign,
			sign_hl_group = utils.set_hl(config.sign_hl or config.hl)
		});

		vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_end, range.col_end - 3, {
			undo_restore = false, invalidate = true,
			end_col = range.col_end,
			conceal = ""
		});

		if not config.hl then return; end

		vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_row = range.row_end,
			end_col = range.col_end,

			line_hl_group = utils.set_hl(config.hl)
		});
	elseif config.style == "block" then
		local pad_amount = config.pad_amount or 0;
		local block_width = config.min_width - (2 * pad_amount);

		--- Get maximum length of the lines within the code block
		for l, line in ipairs(item.text) do
			if (l ~= 1 and l ~= #item.text) and vim.fn.strdisplaywidth(line) > block_width then
				block_width = vim.fn.strdisplaywidth(line);
			end
		end

		vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + 3 + vim.fn.strdisplaywidth(item.language or ""),
			conceal = "",
		});

		vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_start, range.col_start + #item.text[1], {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = config.language_direction == "left" and {
				{ config.pad_char or " ", utils.set_hl(config.hl) },
				{ label, utils.set_hl(hl) },
				{ string.rep(config.pad_char or " ", block_width - vim.fn.strdisplaywidth(label) - 1), utils.set_hl(config.hl) },
				{ string.rep(config.pad_char or " ", (2 * pad_amount)), utils.set_hl(config.hl) },
			} or {
				{ string.rep(config.pad_char or " ", (2 * pad_amount)), utils.set_hl(config.hl) },
				{ string.rep(config.pad_char or " ", block_width - vim.fn.strdisplaywidth(label) - 1), utils.set_hl(config.hl) },
				{ label, utils.set_hl(hl) },
				{ config.pad_char or " ", utils.set_hl(config.hl) },
			},

			hl_mode = "combine",

			sign_text = config.sign,
			sign_hl_group = utils.set_hl(config.sign_hl or config.hl)
		});

		vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_end, range.col_end - 3, {
			undo_restore = false, invalidate = true,
			end_col = range.col_end,
			conceal = "",
		});

		vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_end, range.col_end, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
				{ string.rep(config.pad_char or " ", block_width), utils.set_hl(config.hl) },
				{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
			},

			hl_mode = "combine"
		});

		for l = range.row_start + 1, range.row_end - 1 do
			local line = item.text[(l - range.row_start) + 1];

			vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), l, range.col_start, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
				},

				hl_mode = "combine"
			});

			vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), l, range.col_start + #line, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config.pad_char or " ", block_width - #line), utils.set_hl(config.hl) },
					{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
				},

				hl_mode = "combine"
			});

			vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), l, range.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + #line,

				hl_group = utils.set_hl(config.hl)
			});
		end
	end
	---_
end

typst.label = function (buffer, item)
	local config = get_config("labels");

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) },
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl),
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_end, range.col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) },
		},

		hl_mode = "combine"
	});
end

typst.link_ref = function (buffer, item)
	local config = get_config("reference_links");

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, typst.ns("links"), range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) },
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns("links"), range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl),
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns("links"), range.row_end, range.col_end, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) },
		},

		hl_mode = "combine"
	});
end

typst.raw_span = function (buffer, item)
	local config = get_config("raw_spans");

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) },
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl),
	});

	vim.api.nvim_buf_set_extmark(buffer, typst.ns("injections"), range.row_end, range.col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) },
		},

		hl_mode = "combine"
	});
end

typst.term = function (buffer, item)
	local config = get_config("terms");

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, typst.ns("symbols"), range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 2,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.text or "", utils.set_hl(config.hl) }
		}
	});
end


typst.render = function (buffer, content)
	for _, item in ipairs(content or {}) do
		if typst[item.class:gsub("^typst_", "")] then
			-- pcall(typst[item.class:gsub("^typst_", "")], buffer, item);
			typst[item.class:gsub("^typst_", "")](buffer, item);
		end
	end
end

typst.clear = function (buffer, ignore_ns, from, to)
	for name, ns in pairs(typst.ns) do
		if ignore_ns and vim.list_contains(ignore_ns, name) == false then
			vim.api.nvim_buf_clear_namespace(buffer, ns, from or 0, to or -1);
		end
	end
end

return typst;
