local asciidoc = {};

local utils = require("markview.utils");
local spec = require("markview.spec");

asciidoc.ns = vim.api.nvim_create_namespace("markview/asciidoc");

---@param buffer integer
---@param item markview.parsed.asciidoc.document_titles
asciidoc.document_attribute = function (buffer, item)
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
end

---@param buffer integer
---@param item markview.parsed.asciidoc.images
asciidoc.image = function (buffer, item)
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
end

---@param buffer integer
---@param item markview.parsed.asciidoc.keycodes
asciidoc.keycode = function (buffer, item)
	---@type markview.config.asciidoc.keycodes?
	local main_config = spec.get({ "asciidoc", "keycodes" }, { fallback = nil });
	local range = item.range;

	if not main_config then
		return;
	end

	---@type markview.config.asciidoc.images.opts?
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

	vim.print(config.corner_left == nil)

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
end

---@param buffer integer
---@param item markview.parsed.asciidoc.document_titles
asciidoc.document_title = function (buffer, item)
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
		sign_hl_group = utils.set_hl(config.sign_hl),

		virt_text = {
			{ config.icon, config.icon_hl or config.hl },
		},
		line_hl_group = utils.set_hl(config.hl),
	});
end

--- Renders atx headings.
---@param buffer integer
---@param item markview.parsed.asciidoc.list_items
asciidoc.list_item = function (buffer, item)
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

	for r = range.row_start, range.row_end - 1, 1 do
		if r == range.row_start then
			if checkbox_config and not vim.tbl_isempty(checkbox_config) then
				utils.set_extmark(buffer, asciidoc.ns, r, range.col_start, {
					end_col = config.conceal_on_checkboxes and range.checkbox_start or range.marker_end,
					conceal = "",

					virt_text = {
						{ config.add_padding and string.rep(" ", #item.marker * shift_width) or "" },
						{ not config.conceal_on_checkboxes and config.text or "", config.hl },
					},
					hl_mode = "combine",
				});

				utils.set_extmark(buffer, asciidoc.ns, r, range.checkbox_start, {
					end_col = range.checkbox_end,
					conceal = "",

					virt_text = {
						{ checkbox_config.text or "", checkbox_config.hl },
					},
					hl_mode = "combine",
				});
			else
				utils.set_extmark(buffer, asciidoc.ns, r, range.col_start, {
					end_col = range.marker_end,
					conceal = "",

					virt_text = {
						{ config.add_padding and string.rep(" ", #item.marker * shift_width) or "" },
						{ config.text or "", config.hl },
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
	end
end

--- Renders atx headings.
---@param buffer integer
---@param item markview.parsed.asciidoc.section_titles
asciidoc.section_title = function (buffer, item)
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
			{ config.icon, config.icon_hl or config.hl },
		},
		line_hl_group = utils.set_hl(config.hl),
	});
end

---@param buffer integer
---@param item markview.parsed.asciidoc.tocs
asciidoc.toc = function (buffer, item)
	---@type markview.config.asciidoc.tocs?
	local main_config = spec.get({ "asciidoc", "tocs" }, { fallback = nil, eval_args = { buffer, item } });

	if not main_config then
		return;
	end

	local range = item.range;
	local lines = {};

	table.insert(lines, {
		{ main_config.icon or "", main_config.icon_hl or main_config.hl },
		{ item.title or "Table of contents", main_config.hl },
	});

	if item.entries and #item.entries > 0 then
		table.insert(lines, { { "" } });
	end

	for _, entry in ipairs(item.entries or {}) do
		---@type markview.config.asciidoc.tocs.opts?
		local config = spec.get({ "depth_" .. (entry.depth or 1) }, { source = main_config, eval_args = { buffer, item } });

		if config then
			local text = require("markview.renderers.asciidoc.tostring").tostring(buffer, entry.text, config.hl);
			local shift_by = (main_config.shift_width or 1) * ( (entry.depth or 1) - 1 );

			local line = {
				{ string.rep(config.shift_char or " ", shift_by), config.hl },
				{ config.icon or "", config.icon_hl or config.hl },
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
end

---@param buffer integer
---@param content markview.parsed.asciidoc[]
asciidoc.render = function (buffer, content)
	asciidoc.cache = {
		font_regions = {},
		style_regions = {
			superscripts = {},
			subscripts = {}
		},
	};

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
end

--- Clears decorations of HTML elements
---@param buffer integer
---@param from integer
---@param to integer
asciidoc.clear = function (buffer, from, to)
	vim.api.nvim_buf_clear_namespace(buffer, asciidoc.ns, from or 0, to or -1);
end

return asciidoc;
