local comment = {};

local utils = require("markview.utils");
local spec = require("markview.spec");

comment.ns = vim.api.nvim_create_namespace("markview/comment");

---@param buffer integer
---@param item markview.parsed.comment.tasks
comment.task = function (buffer, item)
	---|fS

	---@type markview.config.comment.tasks?
	local main_config = spec.get({ "comment", "tasks" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type markview.config.comment.tasks.opts?
	local config = utils.match(main_config, item.kind, {
		case_insensitive = true,

		ignore_keys = { "enable" },
		eval_args = { buffer, item }
	});

	if not config then
		return;
	end

	local range = item.range;
	local row_end = range.label_row_end or range.kind[3];
	local col_end = range.label_col_end or range.kind[4];

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.kind[1], range.kind[2], {
		undo_restore = false, invalidate = true,
		end_row = row_end,
		end_col = col_end,

		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, row_end, col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	if config.desc_hl then
		vim.api.nvim_buf_set_extmark(buffer, comment.ns, row_end, col_end, {
			undo_restore = false, invalidate = true,
			end_row = range.row_end,
			end_col = range.col_end,

			hl_group = utils.set_hl(config.desc_hl)
		});
	end

	---|fE
end

---@param buffer integer
---@param item markview.parsed.comment.issues
comment.task_scope = function (buffer, item)
	---|fS

	---@type markview.config.comment.tasks?
	local main_config = spec.get({ "comment", "task_scopes" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type markview.config.comment.tasks.opts?
	local config = utils.match(main_config, item.text[1] or "", {
		ignore_keys = { "enable" },
		eval_args = { buffer, item }
	});

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_end, range.col_end, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	---|fE
end

---@param buffer integer
---@param item markview.parsed.comment.issues
comment.issue = function (buffer, item)
	---|fS

	---@type markview.config.comment.tasks?
	local main_config = spec.get({ "comment", "issues" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type markview.config.comment.tasks.opts?
	local config = utils.match(main_config, item.text[1] or "", {
		ignore_keys = { "enable" },
		eval_args = { buffer, item }
	});

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_end, range.col_end, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	---|fE
end

---@param buffer integer
---@param item markview.parsed.comment.mentions
comment.mention = function (buffer, item)
	---|fS

	---@type markview.config.comment.tasks?
	local main_config = spec.get({ "comment", "mentions" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type markview.config.comment.tasks.opts?
	local config = utils.match(main_config, item.text[1] or "", {
		ignore_keys = { "enable" },
		eval_args = { buffer, item }
	});

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_end, range.col_end, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	---|fE
end

---@param buffer integer
---@param item markview.parsed.comment.inline_codes
comment.inline_code = function (buffer, item)
	---|fS

	---@type markview.config.comment.inline_codes?
	local config = spec.get({ "comment", "inline_codes" }, { fallback = nil });

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_end, range.col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	---|fE
end

--- Renders fenced code blocks.
---@param buffer integer
---@param item markview.parsed.comment.code_blocks
comment.code_block = function (buffer, item)
	---|fS

	---@type markview.config.comment.code_blocks?
	local config = spec.get({ "comment", "code_blocks" }, { fallback = nil, eval_args = { buffer, item } });

	local delims = item.delimiters;
	local range = item.range;

	if not config then
		return;
	end

	-- vim.print(item)

	local decorations = require("markview.filetypes").get(item.language);
	local label = { string.format(" %s%s ", decorations.icon, decorations.name), config.label_hl or decorations.icon_hl };
	local win = utils.buf_getwin(buffer);

	--- Gets highlight configuration for a line.
	---@param line string
	---@return markview.config.comment.code_blocks.opts
	local function get_line_config(line)
		local line_conf = utils.match(config, item.language, {
			eval_args = { buffer, line },
			def_fallback = {
				block_hl = config.border_hl,
				pad_hl = config.border_hl
			},
			fallback = {
				block_hl = config.border_hl,
				pad_hl = config.border_hl
			}
		});

		return line_conf;
	end

	--[[ *Basic* rendering of `code blocks`. ]]
	local function render_simple()
		---|fS

		---@cast config markview.config.comment.code_blocks.simple

		local conceal_from = range.start_delim[2];
		local conceal_to = range.col_start + #(item.text[1] or "");

		if config.label_direction == nil or config.label_direction == "left" then
			vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, conceal_from, {
				undo_restore = false, invalidate = true,

				end_col = conceal_to,
				conceal = "",

				sign_text = config.sign == true and decorations.sign or nil,
				sign_hl_group = utils.set_hl(config.sign_hl or decorations.sign_hl),

				virt_text_pos = "inline",
				virt_text = { label },

				line_hl_group = utils.set_hl(config.border_hl)
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, conceal_from, {
				undo_restore = false, invalidate = true,

				end_col = conceal_to,
				conceal = "",

				sign_text = config.sign == true and decorations.sign or nil,
				sign_hl_group = utils.set_hl(config.sign_hl or decorations.sign_hl),

				virt_text_pos = "right_align",
				virt_text = { label },

				line_hl_group = utils.set_hl(config.border_hl)
			});
		end

		--- Background
		for l = range.row_start + 1, range.row_end - 1 do
			local line = item.text[(l - range.row_start) + 1];
			local line_config = get_line_config(line);

			vim.api.nvim_buf_set_extmark(buffer, comment.ns, l, 0, {
				undo_restore = false, invalidate = true,
				end_row = l,

				line_hl_group = utils.set_hl(line_config.block_hl --[[ @as string ]])
			});
		end

		vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_end, (range.col_start + #item.text[#item.text]) - #delims[2], {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + #item.text[#item.text],
			conceal = "",

			line_hl_group = utils.set_hl(config.border_hl)
		});

		---|fE
	end

	--- Renders block style code blocks.
	local function render_block ()
		---|fS

		---@cast config markview.config.comment.code_blocks.block

		---|fS "chunk: Calculate various widths"

		local pad_amount = config.pad_amount or 0;
		local block_width = config.min_width or 60;

		local pad_char = config.pad_char or " ";

		---@type integer[] Visual width of lines.
		local line_widths = {};

		for l, line in ipairs(item.text) do
			local final = require("markview.renderers.markdown").get_visual_text:init(decorations.name, line);

			if l ~= 1 and l ~= #item.text then
				table.insert(line_widths, vim.fn.strdisplaywidth(final));

				if vim.fn.strdisplaywidth(final) > (block_width - (2 * pad_amount)) then
					block_width = vim.fn.strdisplaywidth(final) + (2 * pad_amount);
				end
			end
		end

		local label_width = utils.virt_len({ label });

		---|fE

		local delim_conceal_from = range.start_delim[2];
		local conceal_to = range.col_start + #(item.text[1] or "");

		---|fS "chunk: Top border"

		local left_padding = pad_amount;

		local pad_width = vim.fn.strdisplaywidth(
			string.rep(pad_char, left_padding)
		);

		-- Hide the leading `backticks`s.
		vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,

			end_col = conceal_to,
			conceal = ""
		});

		if config.label_direction == "right" then
			vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, delim_conceal_from, {
				virt_text_pos = "inline",
				virt_text = {
					{
						string.rep(" " or pad_char, left_padding),
						utils.set_hl(config.border_hl)
					}
				}
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, range.col_start + #item.text[1], {
				virt_text_pos = "inline",
				virt_text = {
					{
						string.rep(" " or pad_char, left_padding),
						utils.set_hl(config.border_hl)
					}
				}
			});
		end

		-- Calculating the amount of spacing to add,
		-- 1. Used space = label width(`label_width`) + padding size(`pad_width`).
		-- 2. Total block width - Used space
		local spacing = block_width - (label_width + pad_width);

		vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, range.col_start + #item.text[1], {
			virt_text_pos = "inline",
			virt_text = {
				{
					string.rep(pad_char, spacing),
					utils.set_hl(config.border_hl)
				},
			}
		});

		---|fS "chunk: Place label"

		local top_border = {
		};

		if config.label_direction == "right" then
			top_border.col_start = range.start_delim[2] + #item.text[1];
		else
			top_border.col_start = range.start_delim[4];
		end

		vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, top_border.col_start, {
			virt_text_pos = "inline",
			virt_text = { label }
		});

		---|fE

		---|fE

		--- Line padding
		for l, width in ipairs(line_widths) do
			local line = item.text[l + 1];
			local line_config = get_line_config(line);

			if width ~= 0 then
				vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start + l, line ~= "" and range.col_start or 0, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(" ", pad_amount),
							utils.set_hl(line_config.pad_hl --[[ @as string ]])
						}
					},
				});

				vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start + l, range.col_start + #line, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(" ", math.max(0, block_width - (( 2 * pad_amount) + width))),
							utils.set_hl(line_config.block_hl --[[ @as string ]])
						},
						{
							string.rep(" ", pad_amount),
							utils.set_hl(line_config.pad_hl --[[ @as string ]])
						}
					},
				});

				--- Background
				vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start + l, range.col_start, {
					undo_restore = false, invalidate = true,
					end_col = range.col_start + #line,

					hl_group = utils.set_hl(line_config.block_hl --[[ @as string ]])
				});
			else
				local buf_line = vim.api.nvim_buf_get_lines(buffer, range.row_start + l, range.row_start + l + 1, false)[1];

				vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start + l, #buf_line, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(" ", math.max(0, range.col_start - #buf_line))
						},
						{
							string.rep(" ", pad_amount),
							utils.set_hl(line_config.pad_hl --[[ @as string ]])
						},
						{
							string.rep(" ", math.max(0, block_width - (2 * pad_amount))),
							utils.set_hl(line_config.block_hl --[[ @as string ]])
						},
						{
							string.rep(" ", pad_amount),
							utils.set_hl(line_config.pad_hl --[[ @as string ]])
						},
					},
				});
			end
		end

		--- Render bottom
		local end_delim_conceal_from = range.end_delim[2] + #string.match(item.delimiters[2], "^%s*");

		vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_end, end_delim_conceal_from, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + #item.text[#item.text],
			conceal = ""
		});

		vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_end, end_delim_conceal_from, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{
					string.rep(" ", block_width),
					utils.set_hl(config.border_hl)
				}
			}
		});

		---|fE
	end

	if not win or config.style == "simple" or item.uses_tab or ( vim.o.wrap == true or vim.wo[win].wrap == true ) then
		render_simple();
	elseif config.style == "block" then
		render_block()
	end

	---|fE
end

---@param buffer integer
---@param item markview.parsed.comment.urls
comment.url = function (buffer, item)
	---|fS

	---@type markview.config.comment.urls?
	local main_config = spec.get({ "comment", "urls" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type markview.config.__inline?
	local config = utils.match(main_config, item.text[1] or "", {
		ignore_keys = { "enable" },
		eval_args = { buffer, item }
	});

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_end, range.col_end, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	---|fE
end

---@param buffer integer
---@param item markview.parsed.comment.taglinks
comment.taglink = function (buffer, item)
	---|fS

	---@type markview.config.comment.taglinks?
	local main_config = spec.get({ "comment", "taglinks" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type markview.config.__inline?
	local config = utils.match(main_config, item.text[1] or "", {
		ignore_keys = { "enable" },
		eval_args = { buffer, item }
	});

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_end, range.col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	---|fE
end

---@param buffer integer
---@param item markview.parsed.comment.autolinks
comment.autolink = function (buffer, item)
	---|fS

	---@type markview.config.comment.autolinks?
	local main_config = spec.get({ "comment", "autolinks" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type markview.config.__inline?
	local config = utils.match(main_config, item.text[1] or "", {
		ignore_keys = { "enable" },
		eval_args = { buffer, item }
	});

	if not config then
		return;
	end

	local range = item.range;

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_col = range.col_start + 1,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end,
		end_col = range.col_end,

		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, comment.ns, range.row_end, range.col_end - 1, {
		undo_restore = false, invalidate = true,
		end_col = range.col_end,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	---|fE
end

--- Renders HTML elements
---@param buffer integer
---@param content markview.parsed.comment[]
comment.render = function (buffer, content)
	local custom = spec.get({ "renderers" }, { fallback = {} });

	for _, item in ipairs(content or {}) do
		local success, err;

		if custom[item.class] then
			success, err = pcall(custom[item.class], comment.ns, buffer, item);
		else
			success, err = pcall(comment[item.class:gsub("^comment_", "")], buffer, item);
		end

		if success == false then
			require("markview.health").print({
				kind = "ERR",

				from = "renderers/comment.lua",
				fn = "render() -> " .. item.class,

				message = {
					{ tostring(err), "DiagnosticError" }
				}
			});
		end
	end
end

--- Clears decorations of HTML elements
---@param buffer integer
---@param from integer
---@param to integer
comment.clear = function (buffer, from, to)
	vim.api.nvim_buf_clear_namespace(buffer, comment.ns, from or 0, to or -1);
end

return comment;
