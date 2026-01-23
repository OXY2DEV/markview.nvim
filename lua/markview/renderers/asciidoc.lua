local asciidoc = {};

local utils = require("markview.utils");
local spec = require("markview.spec");

asciidoc.ns = vim.api.nvim_create_namespace("markview/asciidoc");

---@param buffer integer
---@param item markview.parsed.asciidoc.admonitions
asciidoc.admonition = function (buffer, item)
	---|fS

	---@type markview.config.asciidoc.admonitions?
	local main_config = spec.get({ "asciidoc", "admonitions" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type markview.config.asciidoc.admonitions.opts?
	local config = utils.match(main_config, item.kind, {
		case_insensitive = true,

		ignore_keys = { "enable" },
		eval_args = { buffer, item }
	});

	if not config then
		return;
	end

	local range = item.range;
	local row_end = range.kind[3];
	local col_end = range.kind[4];

	vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.kind[1], range.kind[2], {
		undo_restore = false, invalidate = true,
		end_row = row_end,
		end_col = col_end,

		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, row_end, col_end - 1, {
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
		vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, row_end, col_end, {
			undo_restore = false, invalidate = true,
			end_row = range.row_end,
			end_col = range.col_end,

			hl_group = utils.set_hl(config.desc_hl)
		});
	end

	---|fE
end

---@param buffer integer
---@param item markview.parsed.asciidoc.document_titles
asciidoc.document_attribute = function (buffer, item)
	---|fS

	---@type markview.config.asciidoc.document_titles?
	local config = spec.get({ "asciidoc", "document_attributes" }, { eval_args = { buffer, item } });

	if not config then
		return;
	end

	local range = item.range;

	utils.set_extmark(buffer, asciidoc.ns, range.row_start, range.col_start, {
		end_row = range.row_end - 1,
		conceal_lines = "",
	});

	---|fE
end

---@param buffer integer
---@param item markview.parsed.asciidoc.document_titles
asciidoc.document_title = function (buffer, item)
	---|fS

	---@type markview.config.asciidoc.document_titles?
	local config = spec.get({ "asciidoc", "document_titles" }, { eval_args = { buffer, item } });

	if not config then
		return;
	end

	local range = item.range;

	utils.set_extmark(buffer, asciidoc.ns, range.row_start, range.col_start, {
		-- Remove `=%s*` amount of characters.
		end_col = range.col_start + #string.match(item.text[1] or "", "=+%s*"),
		conceal = "",

		sign_text = tostring(config.sign or ""),
		sign_hl_group = utils.set_hl(config.sign_hl or config.hl),

		virt_text = {
			{ config.icon, utils.set_hl(config.icon_hl or config.hl) },
		},
		line_hl_group = utils.set_hl(config.hl),
	});

	---|fE
end

--- Renders horizontal rules/line breaks.
---@param buffer integer
---@param item markview.parsed.asciidoc.hrs
asciidoc.hr = function (buffer, item)
	---|fS

	---@type markview.config.asciidoc.hrs?
	local config = spec.get({ "asciidoc", "horizontal_rules" }, { fallback = nil, eval_args = { buffer, item } });
	local range = item.range;

	if not config then
		return;
	end

	local virt_text = {};
	local function val(opt, index, wrap)
		if vim.islist(opt) == false then
			return opt;
		elseif #opt < index then
			if wrap == true then
				local mod = index % #opt;
				return mod == 0 and opt[#opt] or opt[mod];
			else
				return opt[#opt];
			end
		elseif index < 0 then
			return opt[1];
		end

		return opt[index];
	end

	for _, part in ipairs(config.parts) do
		if part.type == "text" then
			table.insert(virt_text, { part.text, utils.set_hl(part.hl --[[ @as string ]]) });
		elseif part.type == "repeating" then
			local rep     = spec.get({ "repeat_amount" }, { source = part, fallback = 1, eval_args = { buffer, item } });
			local hl_rep  = spec.get({ "repeat_hl" }, { source = part, fallback = false, eval_args = { buffer, item } });
			local txt_rep = spec.get({ "repeat_text" }, { source = part, fallback = false, eval_args = { buffer, item } });

			for r = 1, rep, 1 do
				if part.direction == "right" then
					table.insert(virt_text, {
						val(part.text, (rep - r) + 1, txt_rep),
						val(part.hl, (rep - r) + 1, hl_rep)
					});
				else
					table.insert(virt_text, {
						val(part.text, r, txt_rep),
						val(part.hl, r, hl_rep)
					});
				end
			end
		end
	end

	vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.row_start, 0, {
		undo_restore = false, invalidate = true,
		virt_text_pos = "overlay",
		virt_text = virt_text,

		hl_mode = "combine"
	});

	---|fE
end

---@param buffer integer
---@param item markview.parsed.asciidoc.images
asciidoc.image = function (buffer, item)
	---|fS

	---@type markview.config.asciidoc.images?
	local main_config = spec.get({ "asciidoc", "images" }, { fallback = nil });
	local range = item.range;

	if not main_config then
		return;
	end

	---@type markview.config.asciidoc.images.opts?
	local config = utils.match(
		main_config,
		item.destination,
		{
			eval_args = { buffer, item }
		}
	);

	if config == nil then
		return;
	end

	utils.set_extmark(buffer, asciidoc.ns, range.row_start, range.col_start, {
		end_col = range.destination[2],
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	if config.text then
		utils.set_extmark(buffer, asciidoc.ns, range.destination[1], range.destination[2], {
			end_col = range.destination[4], end_row = range.destination[3],

			virt_text = {
				{ config.text or "", utils.set_hl(config.text_hl or config.hl) }
			},

			hl_mode = "combine"
		});
	else
		utils.set_extmark(buffer, asciidoc.ns, range.destination[1], range.destination[2], {
			end_col = range.destination[4], end_row = range.destination[3],

			hl_group = utils.set_hl(config.hl),
			hl_mode = "combine"
		});
	end

	utils.set_extmark(buffer, asciidoc.ns, range.row_end, range.destination[4], {
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
---@param item markview.parsed.asciidoc.keycodes
asciidoc.keycode = function (buffer, item)
	---|fS

	---@type markview.config.asciidoc.keycodes?
	local main_config = spec.get({ "asciidoc", "keycodes" }, { fallback = nil });
	local range = item.range;

	if not main_config then
		return;
	end

	---@type markview.config.asciidoc.keycodes.opts?
	local config = utils.match(
		main_config,
		string.upper(item.content or ""),
		{
			eval_args = { buffer, item }
		}
	);

	if config == nil then
		return;
	end

	utils.set_extmark(buffer, asciidoc.ns, range.row_start, range.col_start, {
		end_col = range.content[2],
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	utils.set_extmark(buffer, asciidoc.ns, range.content[1], range.content[2], {
		end_col = range.content[4], end_row = range.content[3],

		hl_group = utils.set_hl(config.hl),
		hl_mode = "combine"
	});

	utils.set_extmark(buffer, asciidoc.ns, range.row_end, range.content[4], {
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
---@param item markview.parsed.asciidoc.list_items
asciidoc.list_item = function (buffer, item)
	---|fS

	---@type markview.config.asciidoc.list_items?
	local main_config = spec.get({ "asciidoc", "list_items" }, { fallback = nil, eval_args = { buffer, item } });

	if not main_config then
		return;
	end

	---@type markview.config.asciidoc.list_items.opts?
	local config;

	if string.match(item.marker, "%*") then
		config = spec.get({ "marker_star" }, { source = main_config, eval_args = { buffer, item } });
	elseif string.match(item.marker, "%-") then
		config = spec.get({ "marker_minus" }, { source = main_config, eval_args = { buffer, item } });
	else
		config = spec.get({ "marker_dot" }, { source = main_config, eval_args = { buffer, item } });
	end

	if not config then
		return;
	end

	---@cast config markview.config.asciidoc.list_items.opts

	---@type markview.config.asciidoc.checkboxes.opts?
	local checkbox_config;

	if item.checkbox == "*" then
		checkbox_config = spec.get({ "asciidoc", "checkboxes", "checked" }, { eval_args = { buffer, item } });
	elseif item.checkbox == " " then
		checkbox_config = spec.get({ "asciidoc", "checkboxes", "unchecked" }, { eval_args = { buffer, item } });
	elseif item.checkbox then
		local checkboxes = spec.get({ "asciidoc", "checkboxes" }, { eval_args = { buffer, item } });
		local _state = vim.pesc(tostring(item.checkbox));

		checkbox_config = utils.match(checkboxes, "^" .. _state .. "$", { default = false, ignore_keys = { "checked", "unchecked", "enable" }, eval_args = { buffer, item } });
	end

	local shift_width = main_config.shift_width or 2;
	local range = item.range;

	local scope_hl = checkbox_config and checkbox_config.scope_hl or nil;

	for r = range.row_start, range.row_end - 1, 1 do
		local line = item.text[(r - range.row_start) + 1];

		if r == range.row_start then
			if checkbox_config and not vim.tbl_isempty(checkbox_config) then
				utils.set_extmark(buffer, asciidoc.ns, r, range.col_start, {
					end_col = config.conceal_on_checkboxes and range.checkbox_start or range.marker_end,
					conceal = "",

					virt_text = {
						{ config.add_padding and string.rep(" ", #item.marker * shift_width) or "" },
						{ not config.conceal_on_checkboxes and config.text or "", utils.set_hl(config.hl) },
					},
					hl_mode = "combine",
				});

				utils.set_extmark(buffer, asciidoc.ns, r, range.checkbox_start, {
					end_col = range.checkbox_end,
					conceal = "",

					virt_text = {
						{ checkbox_config.text or "", utils.set_hl(checkbox_config.hl) },
					},
					hl_mode = "combine",
				});
			else
				utils.set_extmark(buffer, asciidoc.ns, r, range.col_start, {
					end_col = range.marker_end,
					conceal = "",

					virt_text = {
						{ config.add_padding and string.rep(" ", #item.marker * shift_width) or "" },
						{ config.text or "", utils.set_hl(config.hl) },
					},
					hl_mode = "combine",
				});
			end
		elseif config.add_padding then
			utils.set_extmark(buffer, asciidoc.ns, r, 0, {
				virt_text = {
					{ string.rep(" ", #item.marker * shift_width) },
				},
				hl_mode = "combine",
			});
		end

		if scope_hl then
			if r == range.row_start then
				utils.set_extmark(buffer, asciidoc.ns, r, range.col_start, {
					undo_restore = false, invalidate = true,
					end_col = #item.text[1],

					hl_group = utils.set_hl(scope_hl)
				});
			elseif line ~= "" then
				local spaces = line:match("^([%>%s]*)");

				vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.row_start + (r - 1), #spaces, {
					undo_restore = false, invalidate = true,
					end_col = #line,

					hl_group = utils.set_hl(scope_hl)
				});
			end
		end
	end

	---|fE
end

---@param buffer integer
---@param item markview.parsed.asciidoc.literal_blocks
asciidoc.literal_block = function (buffer, item)
	---|fS

	---@type markview.config.asciidoc.literal_blocks?
	local config = spec.get({ "asciidoc", "literal_blocks" }, { fallback = nil, eval_args = { buffer, item } });

	local delims = item.delimiters;
	local range = item.range;

	if not config then
		return;
	end

	local label = { config.label, utils.set_hl(config.label_hl or config.hl) };
	local win = utils.buf_getwin(buffer);

	--[[ *Basic* rendering of `code blocks`. ]]
	local function render_simple()
		---|fS

		local conceal_from = range.start_delim[2] + #string.match(item.delimiters[1], "^%s*");
		local conceal_to = #delims[1];

		if config.label_direction == nil or config.label_direction == "left" then
			vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.row_start, conceal_from, {
				undo_restore = false, invalidate = true,

				end_col = conceal_to,
				conceal = "",

				sign_text = config.sign,
				sign_hl_group = utils.set_hl(config.sign_hl),

				virt_text_pos = "inline",
				virt_text = { label },

				line_hl_group = utils.set_hl(config.hl)
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.row_start, conceal_from, {
				undo_restore = false, invalidate = true,

				end_col = conceal_to,
				conceal = "",

				sign_text = config.sign,
				sign_hl_group = utils.set_hl(config.sign_hl),

				virt_text_pos = "right_align",
				virt_text = { label },

				line_hl_group = utils.set_hl(config.hl)
			});
		end

		--- Background
		for l = range.row_start + 1, range.row_end - 1 do
			vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, l, 0, {
				undo_restore = false, invalidate = true,
				end_row = l,

				line_hl_group = utils.set_hl(config.hl)
			});
		end

		vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.row_end, (range.col_start + #item.text[#item.text]) - #delims[2], {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + #item.text[#item.text],
			conceal = "",

			line_hl_group = utils.set_hl(config.hl)
		});

		---|fE
	end

	--- Renders block style code blocks.
	local function render_block ()
		---|fS

		---|fS "chunk: Calculate various widths"

		local pad_amount = config.pad_amount or 0;
		local block_width = config.min_width or 60;

		local pad_char = config.pad_char or " ";

		---@type integer[] Visual width of lines.
		local line_widths = {};

		for l, line in ipairs(item.text) do
			if l ~= 1 and l ~= #item.text then
				table.insert(line_widths, vim.fn.strdisplaywidth(line));

				if vim.fn.strdisplaywidth(line) > (block_width - (2 * pad_amount)) then
					block_width = vim.fn.strdisplaywidth(line) + (2 * pad_amount);
				end
			end
		end

		local label_width = utils.virt_len({ label });

		---|fE

		local delim_conceal_from = range.start_delim[2] + #string.match(item.delimiters[1], "^%s*");
		local conceal_to = #delims[1];

		---|fS "chunk: Top border"

		local visible_info = string.sub(item.text[1], (conceal_to + 1) - range.col_start);
		local left_padding = visible_info ~= "" and 1 or pad_amount;

		local pad_width = vim.fn.strdisplaywidth(
			string.rep(pad_char, left_padding)
		);

		-- Hide the leading `backticks`s.
		vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.row_start, delim_conceal_from, {
			undo_restore = false, invalidate = true,

			end_col = conceal_to,
			conceal = "",

			sign_text = config.sign,
			sign_hl_group = utils.set_hl(config.sign_hl),
		});

		if config.label_direction == "right" then
			vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.row_start, delim_conceal_from, {
				virt_text_pos = "inline",
				virt_text = {
					{
						string.rep(" " or pad_char, left_padding),
						utils.set_hl(config.hl)
					}
				}
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.row_start, range.col_start + #item.text[1], {
				virt_text_pos = "inline",
				virt_text = {
					{
						string.rep(" " or pad_char, left_padding),
						utils.set_hl(config.hl)
					}
				}
			});
		end

		---|fS "chunk: Prettify info"

		-- Calculating the amount of spacing to add,
		-- 1. Used space = label width(`label_width`) + padding size(`pad_width`).
		-- 2. Total block width - Used space
		local spacing = block_width - (label_width + pad_width);

		vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.row_start, range.col_start + #item.text[1], {
			virt_text_pos = "inline",
			virt_text = {
				{
					string.rep(pad_char, spacing),
					utils.set_hl(config.hl)
				},
			}
		});

		---|fE

		---|fS "chunk: Place label"

		local top_border = {
		};

		if config.label_direction == "right" then
			top_border.col_start = range.start_delim[2] + #item.text[1];
		else
			top_border.col_start = range.start_delim[4];
		end

		vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.row_start, top_border.col_start, {
			virt_text_pos = "inline",
			virt_text = { label }
		});

		---|fE

		---|fE

		--- Line padding
		for l, width in ipairs(line_widths) do
			local line = item.text[l + 1];

			if width ~= 0 then
				vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.row_start + l, line ~= "" and range.col_start or 0, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(" ", pad_amount),
							utils.set_hl(config.hl --[[ @as string ]])
						}
					},
				});

				vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.row_start + l, range.col_start + #line, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(" ", math.max(0, block_width - (( 2 * pad_amount) + width))),
							utils.set_hl(config.hl --[[ @as string ]])
						},
						{
							string.rep(" ", pad_amount),
							utils.set_hl(config.hl --[[ @as string ]])
						}
					},
				});

				--- Background
				vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.row_start + l, range.col_start, {
					undo_restore = false, invalidate = true,
					end_col = range.col_start + #line,

					hl_group = utils.set_hl(config.hl --[[ @as string ]])
				});
			else
				local buf_line = vim.api.nvim_buf_get_lines(buffer, range.row_start + l, range.row_start + l + 1, false)[1];

				vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.row_start + l, #buf_line, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(" ", math.max(0, range.col_start - #buf_line))
						},
						{
							string.rep(" ", pad_amount),
							utils.set_hl(config.hl --[[ @as string ]])
						},
						{
							string.rep(" ", math.max(0, block_width - (2 * pad_amount))),
							utils.set_hl(config.hl --[[ @as string ]])
						},
						{
							string.rep(" ", pad_amount),
							utils.set_hl(config.hl --[[ @as string ]])
						},
					},
				});
			end
		end

		--- Render bottom
		if item.delimiters[2] then
			local end_delim_conceal_from = range.end_delim[2] + #string.match(item.delimiters[2], "^%s*");

			vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.row_end, end_delim_conceal_from, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + #item.text[#item.text],
				conceal = ""
			});

			vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.row_end, end_delim_conceal_from, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{
						string.rep(" ", block_width),
						utils.set_hl(config.hl)
					}
				}
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, asciidoc.ns, range.row_end, range.col_start, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{
						string.rep(" ", block_width),
						utils.set_hl(config.hl)
					}
				}
			});
		end

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
---@param item markview.parsed.asciidoc.section_titles
asciidoc.section_title = function (buffer, item)
	---|fS

	---@type markview.config.asciidoc.section_titles?
	local main_config = spec.get({ "asciidoc", "section_titles" }, { fallback = nil, eval_args = { buffer, item } });

	if not main_config then
		return;
	end

	---@type markview.config.asciidoc.section_titles.opts?
	local config = spec.get({ "title_" .. (#item.marker - 1) }, { source = main_config, eval_args = { buffer, item } });

	if not config then
		return;
	end

	local shift_width = spec.get({ "shift_width" }, { source = main_config, fallback = 1, eval_args = { buffer, item } });

	local range = item.range;

	utils.set_extmark(buffer, asciidoc.ns, range.row_start, range.col_start, {
		end_col = range.col_start + #item.marker,
		conceal = "",

		sign_text = tostring(config.sign or ""),
		sign_hl_group = utils.set_hl(config.sign_hl),

		virt_text = {
			{ string.rep(" ", (#item.marker - 1) * shift_width) },
			{ config.icon, utils.set_hl(config.icon_hl or config.hl) },
		},
		line_hl_group = utils.set_hl(config.hl),
	});

	---|fE
end

---@param buffer integer
---@param item markview.parsed.asciidoc.tocs
asciidoc.toc = function (buffer, item)
	---|fS

	---@type markview.config.asciidoc.tocs?
	local main_config = spec.get({ "asciidoc", "tocs" }, { fallback = nil, eval_args = { buffer, item } });

	if not main_config then
		return;
	end

	local range = item.range;
	local lines = {};

	table.insert(lines, {
		{ main_config.icon or "", utils.set_hl(main_config.icon_hl or main_config.hl) },
		{ item.title or "Table of contents", utils.set_hl(main_config.hl) },
	});

	if item.entries and #item.entries > 0 then
		table.insert(lines, { { "" } });
	end

	for _, entry in ipairs(item.entries or {}) do
		---@type markview.config.asciidoc.tocs.opts?
		local config = spec.get({ "depth_" .. (entry.depth or 1) }, { source = main_config, eval_args = { buffer, item } });

		if config then
			local text = require("markview.renderers.asciidoc.tostring").tostring(buffer, entry.text, utils.set_hl(config.hl) --[[@as string]]);
			local shift_by = (main_config.shift_width or 1) * ( (entry.depth or 1) - 1 );

			local line = {
				{ string.rep(config.shift_char or " ", shift_by), utils.set_hl(config.hl) },
				{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) },
			};

			vim.list_extend(line, text);
			table.insert(lines, line);
		end
	end

	local title = table.remove(lines, 1);

	if range.position then
		utils.set_extmark(buffer, asciidoc.ns, range.row_start, range.col_start, {
			end_row = range.row_end - 1,
			conceal_lines = "",
		});

		local r_pos = range.position --[[@as markview.parsed.range]];

		utils.set_extmark(buffer, asciidoc.ns, r_pos.row_start, r_pos.col_start, {
			end_col = r_pos.col_end,
			conceal = "",

			virt_text = title,
			virt_text_pos = "inline",

			sign_text = main_config.sign or "",
			sign_hl_group = utils.set_hl(main_config.sign_hl),

			virt_lines = lines,
			hl_mode = "combine",
		});
	else
		utils.set_extmark(buffer, asciidoc.ns, range.row_start, range.col_start, {
			end_col = range.col_end,
			conceal = "",

			virt_text = title,
			virt_text_pos = "inline",

			sign_text = main_config.sign or "",
			sign_hl_group = utils.set_hl(main_config.sign_hl),

			virt_lines = lines,
			hl_mode = "combine",
		});
	end

	---|fE
end

---@param buffer integer
---@param content markview.parsed.asciidoc[]
asciidoc.render = function (buffer, content)
	---|fS

	local custom = spec.get({ "renderers" }, { fallback = {} });

	for _, item in ipairs(content or {}) do
		local success, err;

		if custom[item.class] then
			success, err = pcall(custom[item.class], asciidoc.ns, buffer, item);
		else
			success, err = pcall(asciidoc[item.class:gsub("^asciidoc_", "")], buffer, item);
		end

		if success == false then
			require("markview.health").print({
				kind = "ERR",

				from = "renderers/asciidoc.lua",
				fn = "render() -> " .. item.class,

				message = {
					{ tostring(err), "DiagnosticError" }
				}
			});
		end
	end

	---|fE
end

---@param buffer integer
---@param from integer
---@param to integer
asciidoc.clear = function (buffer, from, to)
	vim.api.nvim_buf_clear_namespace(buffer, asciidoc.ns, from or 0, to or -1);
end

return asciidoc;
