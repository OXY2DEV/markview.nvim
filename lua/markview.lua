local markview = {};
local utils = require("markview.utils");

markview.parser = require("markview.parser");
markview.renderer = require("markview.renderer");
markview.keymaps = require("markview.keymaps");

markview.colors = require("markview.colors");

markview.list_contains = function (tbl, value)
	for index, item in ipairs(tbl) do
		if item == value or vim.deep_equal(item, value) then
			return true, index;
		end
	end

	return false;
end

markview.deep_merge = function (behavior, tbl_1, tbl_2)
	if not tbl_1 or type(tbl_1) ~= "table" then
		tbl_1 = {};
	end

	if not tbl_2 or type(tbl_2) ~= "table" then
		tbl_2 = {};
	end

	for key, value in pairs(tbl_2) do
		if not tbl_1[key] then
			tbl_1[key] = value;
			goto skip;
		end

		if type(value) ~= type(tbl_1[key]) then
			goto skip;
		end

		if vim.islist(value) then
			if not tbl_1.overwrite or tbl_1.overwrite and not vim.list_contains(tbl_1.overwrite, key) then
				for index, item in ipairs(value) do
					if not markview.list_contains(tbl_1[key], item) then
						table.insert(tbl_1[key], item);
					elseif tbl_1[key][index] and type(tbl_1[key][index]) == "table" and type(item) == "table" then
						tbl_1[key][index] = markview.deep_merge(behavior, tbl_1[key][index], item);
					elseif not markview.list_contains(tbl_1[key], item) then
						tbl_1[key][index] = item;
					end
				end
			else
				tbl_1[key] = value;
			end
		elseif type(value) == "table" then
			tbl_1[key] = markview.deep_merge(behavior, tbl_1[key], value);
		elseif behavior == "force" then
			tbl_1[key] = value;
		end

		::skip::
	end

	return tbl_1;
end

markview.hl_exits = function (hl_list, hl)
	for index, item in ipairs(hl_list) do
		if item.group_name == hl.group_name then
			return true, index;
		end
	end

	return false;
end

markview.added_hls = {};

markview.remove_hls = function ()
	if vim.tbl_isempty(markview.added_hls) then
		return;
	end

	for _, hl in ipairs(markview.added_hls) do
		if vim.fn.hlexists("Markview" .. hl) == 1 then
			vim.api.nvim_set_hl(0, "Markview" .. hl, {});
		end
	end
end

markview.add_hls = function (obj)
	markview.added_hls = {};
	local use_hl = {};

	for _, hl in ipairs(obj) do
		if hl.output and type(hl.output) == "function" and pcall(hl.output) then
			local _o = hl.output();
			local _n = {};

			for _, item in ipairs(_o) do
				local exists, index = markview.hl_exits(use_hl, item);

				if exists == true then
					table.remove(use_hl, index);
				else
					table.insert(_n, item.group_name);
				end
			end

			use_hl = vim.list_extend(use_hl, _o);
			markview.added_hls = vim.list_extend(markview.added_hls, _n);
		elseif hl.group_name and hl.value then
			local contains, index = markview.list_contains(markview.added_hls, hl.group_name);

			if contains == true and index then
				use_hl[index] = hl;
			else
				table.insert(use_hl, hl)
				table.insert(markview.added_hls, hl.group_name);
			end
		end
	end

	for _, hl in ipairs(use_hl) do
		local _opt = hl.value;

		if type(hl.value) == "function" then
			_opt = hl.value();
		end

		vim.api.nvim_set_hl(0, "Markview" .. hl.group_name, _opt);
	end
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
	filetypes = { "markdown", "quarto", "rmd" },
	callbacks = {
		on_enable = function (_, window)
			vim.wo[window].conceallevel = 2;
			vim.wo[window].concealcursor = "nc";
		end,
		on_disable = function (_, window)
			vim.wo[window].conceallevel = 0;
			vim.wo[window].concealcursor = "";
		end,

		on_mode_change = function (_, window, mode)
			if vim.list_contains(markview.configuration.modes, mode) then
				vim.wo[window].conceallevel = 2;
			else
				vim.wo[window].conceallevel = 0;
			end
		end
	},

	highlight_groups = {
		---+ ##code##
		{
			-- Heading level 1
			output = function ()
				if markview.colors.get_hl_value(0, "DiagnosticVirtualTextOk", "bg") and markview.colors.get_hl_value(0, "DiagnosticVirtualTextOk", "fg") then
					local bg = markview.colors.get_hl_value(0, "DiagnosticVirtualTextOk", "bg");
					local fg = markview.colors.get_hl_value(0, "DiagnosticVirtualTextOk", "fg");

					return {
						{
							group_name = "Heading1",
							value = {
								bg = bg,
								fg = fg,

								default = true
							}
						},
						{
							group_name = "Heading1Sign",
							value = {
								fg = fg,

								default = true
							}
						},
					}
				elseif markview.colors.get_hl_value(0, "DiagnosticOk", "fg") and markview.colors.bg() then
					local bg = markview.colors.bg();
					local fg = markview.colors.get_hl_value(0, "DiagnosticOk", "fg");

					local nr = markview.colors.get_hl_value(0, "LineNr", "bg");

					return {
						{
							group_name = "Heading1",
							value = {
								bg = vim.o.background == "dark"
									and
									markview.colors.mix(bg, fg, 0.5, 0.15)
									or
									markview.colors.mix(bg, fg, 0.85, 0.20),
								fg = fg,

								default = true
							}
						},
						{
							group_name = "Heading1Sign",
							value = {
								bg = nr,
								fg = fg,

								default = true
							}
						},
					}
				else
					local bg = markview.colors.get_hl_value(0, "Normal", "bg");
					local fg = vim.o.background == "dark" and "#a6e3a1" or "#40a02b";

					local nr = markview.colors.get_hl_value(0, "LineNr", "bg");

					return {
						{
							group_name = "Heading1",
							value = {
								bg = vim.o.background == "dark"
									and
									markview.colors.mix(bg, fg, 0.5, 0.15)
									or
									markview.colors.mix(bg, fg, 0.85, 0.20),
								fg = fg,

								default = true
							}
						},
						{
							group_name = "Heading1Sign",
							value = {
								bg = nr,
								fg = fg,

								default = true
							}
						},
					}
				end
			end
		},
		{
			-- Heading level 2
			output = function ()
				if markview.colors.get_hl_value(0, "DiagnosticVirtualTextHint", "bg") and markview.colors.get_hl_value(0, "DiagnosticVirtualTextHint", "fg") then
					local bg = markview.colors.get_hl_value(0, "DiagnosticVirtualTextHint", "bg");
					local fg = markview.colors.get_hl_value(0, "DiagnosticVirtualTextHint", "fg");

					return {
						{
							group_name = "Heading2",
							value = {
								bg = bg,
								fg = fg,

								default = true
							}
						},
						{
							group_name = "Heading2Sign",
							value = {
								fg = fg,

								default = true
							}
						},
					}
				elseif markview.colors.get_hl_value(0, "DiagnosticHint", "fg") and markview.colors.bg() then
					local bg = markview.colors.bg();
					local fg = markview.colors.get_hl_value(0, "DiagnosticHint", "fg");

					local nr = markview.colors.get_hl_value(0, "LineNr", "bg");

					return {
						{
							group_name = "Heading2",
							value = {
								bg = vim.o.background == "dark"
									and
									markview.colors.mix(bg, fg, 0.5, 0.15)
									or
									markview.colors.mix(bg, fg, 0.85, 0.20),
								fg = fg,

								default = true
							}
						},
						{
							group_name = "Heading2Sign",
							value = {
								bg = nr,
								fg = fg,

								default = true
							}
						},
					}
				else
					local bg = markview.colors.get_hl_value(0, "Normal", "bg");
					local fg = vim.o.background == "dark" and "#94e2d5" or "#179299";

					local nr = markview.colors.get_hl_value(0, "LineNr", "bg");

					return {
						{
							group_name = "Heading2",
							value = {
								bg = vim.o.background == "dark"
									and
									markview.colors.mix(bg, fg, 0.5, 0.15)
									or
									markview.colors.mix(bg, fg, 0.85, 0.20),
								fg = fg,

								default = true
							}
						},
						{
							group_name = "Heading2Sign",
							value = {
								bg = nr,
								fg = fg,

								default = true
							}
						},
					}
				end
			end
		},
		{
			-- Heading level 3
			output = function ()
				if markview.colors.get_hl_value(0, "DiagnosticVirtualTextInfo", "bg") and markview.colors.get_hl_value(0, "DiagnosticVirtualTextInfo", "fg") then
					local bg = markview.colors.get_hl_value(0, "DiagnosticVirtualTextInfo", "bg");
					local fg = markview.colors.get_hl_value(0, "DiagnosticVirtualTextInfo", "fg");

					return {
						{
							group_name = "Heading3",
							value = {
								bg = bg,
								fg = fg,

								default = true
							}
						},
						{
							group_name = "Heading3Sign",
							value = {
								fg = fg,

								default = true
							}
						},
					}
				elseif markview.colors.get_hl_value(0, "DiagnosticInfo", "fg") and markview.colors.bg() then
					local bg = markview.colors.bg();
					local fg = markview.colors.get_hl_value(0, "DiagnosticInfo", "fg");

					local nr = markview.colors.get_hl_value(0, "LineNr", "bg");

					return {
						{
							group_name = "Heading3",
							value = {
								bg = vim.o.background == "dark"
									and
									markview.colors.mix(bg, fg, 0.5, 0.15)
									or
									markview.colors.mix(bg, fg, 0.85, 0.20),
								fg = fg,

								default = true
							}
						},
						{
							group_name = "Heading3Sign",
							value = {
								bg = nr,
								fg = fg,

								default = true
							}
						},
					}
				else
					local bg = markview.colors.get_hl_value(0, "Normal", "bg");
					local fg = vim.o.background == "dark" and "#89dceb" or "#179299";

					local nr = markview.colors.get_hl_value(0, "LineNr", "bg");

					return {
						{
							group_name = "Heading3",
							value = {
								bg = vim.o.background == "dark"
									and
									markview.colors.mix(bg, fg, 0.5, 0.15)
									or
									markview.colors.mix(bg, fg, 0.85, 0.20),
								fg = fg,

								default = true
							}
						},
						{
							group_name = "Heading3Sign",
							value = {
								bg = nr,
								fg = fg,

								default = true
							}
						},
					}
				end
			end
		},
		{
			-- Heading level 4
			output = function ()
				if markview.colors.get_hl_value(0, "Special", "bg") and markview.colors.get_hl_value(0, "Special", "fg") then
					local bg = markview.colors.get_hl_value(0, "Special", "bg");
					local fg = markview.colors.get_hl_value(0, "Special", "fg");

					return {
						{
							group_name = "Heading4",
							value = {
								bg = bg,
								fg = fg,

								default = true
							}
						},
						{
							group_name = "Heading4Sign",
							value = {
								fg = fg,

								default = true
							}
						},
					}
				elseif markview.colors.get_hl_value(0, "Special", "fg") and markview.colors.bg() then
					local bg = markview.colors.bg();
					local fg = markview.colors.get_hl_value(0, "Special", "fg");

					local nr = markview.colors.get_hl_value(0, "LineNr", "bg");

					return {
						{
							group_name = "Heading4",
							value = {
								bg = vim.o.background == "dark"
									and
									markview.colors.mix(bg, fg, 0.5, 0.15)
									or
									markview.colors.mix(bg, fg, 0.85, 0.20),
								fg = fg,

								default = true
							}
						},
						{
							group_name = "Heading4Sign",
							value = {
								bg = nr,
								fg = fg,

								default = true
							}
						},
					}
				else
					local bg = markview.colors.get_hl_value(0, "Normal", "bg");
					local fg = vim.o.background == "dark" and "#f5c2e7" or "#ea76cb";

					local nr = markview.colors.get_hl_value(0, "LineNr", "bg");

					return {
						{
							group_name = "Heading4",
							value = {
								bg = vim.o.background == "dark"
									and
									markview.colors.mix(bg, fg, 0.5, 0.15)
									or
									markview.colors.mix(bg, fg, 0.85, 0.20),
								fg = fg,

								default = true
							}
						},
						{
							group_name = "Heading4Sign",
							value = {
								bg = nr,
								fg = fg,

								default = true
							}
						},
					}
				end
			end
		},
		{
			-- Heading level 5
			output = function ()
				if markview.colors.get_hl_value(0, "DiagnosticVirtualTextWarn", "bg") and markview.colors.get_hl_value(0, "DiagnosticVirtualTextWarn", "fg") then
					local bg = markview.colors.get_hl_value(0, "DiagnosticVirtualTextWarn", "bg");
					local fg = markview.colors.get_hl_value(0, "DiagnosticVirtualTextWarn", "fg");

					return {
						{
							group_name = "Heading5",
							value = {
								bg = bg,
								fg = fg,

								default = true
							}
						},
						{
							group_name = "Heading5Sign",
							value = {
								fg = fg,

								default = true
							}
						},
					}
				elseif markview.colors.get_hl_value(0, "DiagnosticWarn", "fg") and markview.colors.bg() then
					local bg = markview.colors.bg();
					local fg = markview.colors.get_hl_value(0, "DiagnosticWarn", "fg");

					local nr = markview.colors.get_hl_value(0, "LineNr", "bg");

					return {
						{
							group_name = "Heading5",
							value = {
								bg = vim.o.background == "dark"
									and
									markview.colors.mix(bg, fg, 0.5, 0.15)
									or
									markview.colors.mix(bg, fg, 0.85, 0.20),
								fg = fg,

								default = true
							}
						},
						{
							group_name = "Heading5Sign",
							value = {
								bg = nr,
								fg = fg,

								default = true
							}
						},
					}
				else
					local bg = markview.colors.get_hl_value(0, "Normal", "bg");
					local fg = vim.o.background == "dark" and "#F9E3AF" or "#DF8E1D";

					local nr = markview.colors.get_hl_value(0, "LineNr", "bg");

					return {
						{
							group_name = "Heading5",
							value = {
								bg = vim.o.background == "dark"
									and
									markview.colors.mix(bg, fg, 0.5, 0.15)
									or
									markview.colors.mix(bg, fg, 0.85, 0.20),
								fg = fg,

								default = true
							}
						},
						{
							group_name = "Heading5Sign",
							value = {
								bg = nr,
								fg = fg,

								default = true
							}
						},
					}
				end
			end
		},
		{
			-- Heading level 6
			output = function ()
				if markview.colors.get_hl_value(0, "DiagnosticVirtualTextError", "bg") and markview.colors.get_hl_value(0, "DiagnosticVirtualTextError", "fg") then
					local bg = markview.colors.get_hl_value(0, "DiagnosticVirtualTextError", "bg");
					local fg = markview.colors.get_hl_value(0, "DiagnosticVirtualTextError", "fg");

					return {
						{
							group_name = "Heading6",
							value = {
								bg = bg,
								fg = fg,

								default = true
							}
						},
						{
							group_name = "Heading6Sign",
							value = {
								fg = fg,

								default = true
							}
						},
					}
				elseif markview.colors.get_hl_value(0, "DiagnosticError", "fg") and markview.colors.bg() then
					local bg = markview.colors.bg();
					local fg = markview.colors.get_hl_value(0, "DiagnosticError", "fg");

					local nr = markview.colors.get_hl_value(0, "LineNr", "bg");

					return {
						{
							group_name = "Heading6",
							value = {
								bg = vim.o.background == "dark"
									and
									markview.colors.mix(bg, fg, 0.5, 0.15)
									or
									markview.colors.mix(bg, fg, 0.85, 0.20),
								fg = fg,

								default = true
							}
						},
						{
							group_name = "Heading6Sign",
							value = {
								bg = nr,
								fg = fg,

								default = true
							}
						},
					}
				else
					local bg = markview.colors.get_hl_value(0, "Normal", "bg");
					local fg = vim.o.background == "dark" and "#F38BA8" or "#D20F39";

					local nr = markview.colors.get_hl_value(0, "LineNr", "bg");

					return {
						{
							group_name = "Heading6",
							value = {
								bg = vim.o.background == "dark"
									and
									markview.colors.mix(bg, fg, 0.5, 0.15)
									or
									markview.colors.mix(bg, fg, 0.85, 0.20),
								fg = fg,

								default = true
							}
						},
						{
							group_name = "Heading6Sign",
							value = {
								bg = nr,
								fg = fg,

								default = true
							}
						},
					}
				end
			end
		},


		{
			group_name = "BlockQuoteDefault",
			value = function ()
				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "Comment", "fg"),

					vim.o.background == "dark" and "#6c7086" or "#9ca0b0";
				});

				return { fg = fg, default = true };
			end
		},
		{
			group_name = "BlockQuoteError",
			value = function ()
				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "DiagnosticError", "fg"),

					vim.o.background == "dark" and "#F38BA8" or "#D20F39";
				});

				return { fg = fg, default = true };
			end
		},
		{
			group_name = "BlockQuoteWarn",
			value = function ()
				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "DiagnosticWarn", "fg"),

					vim.o.background == "dark" and "#F9E3AF" or "#DF8E1D";
				});

				return { fg = fg, default = true };
			end
		},
		{
			group_name = "BlockQuoteOk",
			value = function ()
				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "DiagnosticOk", "fg"),

					vim.o.background == "dark" and "#a6e3a1" or "#40a02b";
				});

				return { fg = fg, default = true };
			end
		},
		{
			group_name = "BlockQuoteNote",
			value = function ()
				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "@comment.note", "bg"),
					markview.colors.get_hl_value(0, "@comment.note", "fg"),

					markview.colors.get_hl_value(0, "Title", "fg"),
					vim.o.background == "dark" and "#89b4fa" or "#1e66f5"
				});

				return { fg = fg, default = true };
			end
		},
		{
			group_name = "BlockQuoteSpecial",
			value = function ()
				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "Conditional", "fg"),
					markview.colors.get_hl_value(0, "Keyword", "fg"),

					vim.o.background == "dark" and "#cba6f7" or "#8839ef"
				});

				return { fg = fg, default = true };
			end
		},



		{
			group_name = "Code",
			value = function ()
				local bg = markview.colors.get({
					markview.colors.get_hl_value(0, "Normal", "bg"),
					markview.colors.get_hl_value(0, "Cursor", "fg"),
					markview.colors.get_hl_value(0, "EndOfBuffer", "bg"),
					markview.colors.get_hl_value(0, "EndOfBuffer", "fg"),

					vim.o.background == "dark" and "#1e1e2e" or "#cdd6f4"
				});

				local luminosity = markview.colors.get_brightness(bg);

				if luminosity < 0.5 then
					return {
						bg = markview.colors.mix(bg, bg, 1, math.max(luminosity, 0.25)),
						default = true
					};
				else
					return {
						bg = markview.colors.mix(bg, bg, 1, math.max(1 - luminosity, 0.05) * -1),
						default = true
					};
				end
			end
		},
		{
			group_name = "CodeInfo",
			value = function ()
				local bg = markview.colors.get({
					markview.colors.get_hl_value(0, "Normal", "bg"),
					markview.colors.get_hl_value(0, "Cursor", "fg"),
					markview.colors.get_hl_value(0, "EndOfBuffer", "bg"),
					markview.colors.get_hl_value(0, "EndOfBuffer", "fg"),

					vim.o.background == "dark" and "#1e1e2e" or "#cdd6f4"
				});

				local luminosity = markview.colors.get_brightness(bg);

				if luminosity < 0.5 then
					return {
						bg = markview.colors.mix(bg, bg, 1, math.max(luminosity, 0.25)),
						fg = markview.colors.get_hl_value(0, "Comment", "fg"),
						default = true
					};
				else
					return {
						bg = markview.colors.mix(bg, bg, 1, math.min(luminosity, 0.25) * -1),
						fg = markview.colors.get_hl_value(0, "Comment", "fg"),
						default = true
					};
				end
			end
		},
		{
			group_name = "InlineCode",
			value = function ()
				local bg = markview.colors.get({
					markview.colors.get_hl_value(0, "Normal", "bg"),
					markview.colors.get_hl_value(0, "Cursor", "fg"),
					markview.colors.get_hl_value(0, "EndOfBuffer", "bg"),
					markview.colors.get_hl_value(0, "EndOfBuffer", "fg"),

					vim.o.background == "dark" and "#1e1e2e" or "#cdd6f4"
				});

				local luminosity = markview.colors.get_brightness(bg);

				if luminosity < 0.5 then
					return {
						bg = markview.colors.mix(bg, bg, 1, math.max(luminosity, 0.5)),
						default = true
					};
				else
					return {
						bg = markview.colors.mix(bg, bg, 1, math.min(luminosity, 0.15) * -1),
						default = true
					};
				end
			end
		},


		{
			group_name = "CheckboxChecked",
			value = function ()
				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "DiagnosticOk", "fg"),

					vim.o.background == "dark" and "#a6e3a1" or "#40a02b";
				});

				return { fg = fg, default = true };
			end
		},
		{
			group_name = "CheckboxUnchecked",
			value = function ()
				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "DiagnosticError", "fg"),

					vim.o.background == "dark" and "#F38BA8" or "#D20F39";
				});

				return { fg = fg, default = true };
			end
		},
		{
			group_name = "CheckboxPending",
			value = function ()
				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "DiagnosticWarn", "fg"),

					vim.o.background == "dark" and "#F9E3AF" or "#DF8E1D";
				});

				return { fg = fg, default = true };
			end
		},
		{
			group_name = "CheckboxProgress",
			value = function ()
				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "Conditional", "fg"),
					markview.colors.get_hl_value(0, "Keyword", "fg"),

					vim.o.background == "dark" and "#cba6f7" or "#8839ef"
				});

				return { fg = fg, default = true };
			end
		},
		{
			group_name = "CheckboxCancelled",
			value = function ()
				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "Comment", "fg"),

					vim.o.background == "dark" and "#6c7086" or "#9ca0b0";
				});

				return { fg = fg, default = true };
			end
		},


		{
			group_name = "TableBorder",
			value = function ()
				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "@comment.note", "bg"),
					markview.colors.get_hl_value(0, "@comment.note", "fg"),

					markview.colors.get_hl_value(0, "Title", "fg"),
					vim.o.background == "dark" and "#89b4fa" or "#1e66f5"
				});

				return { fg = fg, default = true };
			end
		},
		{
			group_name = "TableAlignLeft",
			value = function ()
				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "@comment.note", "bg"),
					markview.colors.get_hl_value(0, "@comment.note", "fg"),

					markview.colors.get_hl_value(0, "Title", "fg"),
					vim.o.background == "dark" and "#89b4fa" or "#1e66f5"
				});

				return { fg = fg, default = true };
			end
		},
		{
			group_name = "TableAlignRight",
			value = function ()
				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "@comment.note", "bg"),
					markview.colors.get_hl_value(0, "@comment.note", "fg"),

					markview.colors.get_hl_value(0, "Title", "fg"),
					vim.o.background == "dark" and "#89b4fa" or "#1e66f5"
				});

				return { fg = fg, default = true };
			end
		},
		{
			group_name = "TableAlignCenter",
			value = function ()
				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "@comment.note", "bg"),
					markview.colors.get_hl_value(0, "@comment.note", "fg"),

					markview.colors.get_hl_value(0, "Title", "fg"),
					vim.o.background == "dark" and "#89b4fa" or "#1e66f5"
				});

				return { fg = fg, default = true };
			end
		},


		{
			group_name = "ListItemMinus",
			value = function ()
				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "DiagnosticWarn", "fg"),

					vim.o.background == "dark" and "#F9E3AF" or "#DF8E1D";
				});

				return { fg = fg, default = true };
			end
		},
		{
			group_name = "ListItemPlus",
			value = function ()
				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "DiagnosticOk", "fg"),

					vim.o.background == "dark" and "#a6e3a1" or "#40a02b";
				});

				return { fg = fg, default = true };
			end
		},
		{
			group_name = "ListItemStar",
			value = function ()
				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "@comment.note", "bg"),
					markview.colors.get_hl_value(0, "@comment.note", "fg"),

					markview.colors.get_hl_value(0, "Title", "fg"),
					vim.o.background == "dark" and "#89b4fa" or "#1e66f5"
				});

				return { fg = fg, default = true };
			end
		},


		{
			group_name = "Hyperlink",
			value = function ()
				if markview.colors.get_hl_value(0, "markdownLinkText", "fg") then
					return { link = "markdownLinkText", default = true };
				elseif markview.colors.get_hl_value(0, "@markup.link.label.markdown_inline", "fg") then
					return { link = "@markup.link.label.markdown_inline", default = true };
				end

				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "Label", "fg"),

					vim.o.background == "dark" and "#74c7ec" or "#209fb5"
				});

				return { fg = fg, underline = true, default = true };
			end
		},
		{
			group_name = "ImageLink",
			value = function ()
				if markview.colors.get_hl_value(0, "markdownLinkText", "fg") then
					return { link = "markdownLinkText", default = true };
				elseif markview.colors.get_hl_value(0, "@markup.link.label.markdown_inline", "fg") then
					return { link = "@markup.link.label.markdown_inline", default = true };
				end

				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "Label", "fg"),

					vim.o.background == "dark" and "#74c7ec" or "#209fb5"
				});

				return { fg = fg, underline = true, default = true };
			end
		},
		{
			group_name = "Email",
			value = function ()
				if markview.colors.get_hl_value(0, "@markup.link.url.markdown_inline", "fg") then
					return { link = "@markup.link.url.markdown_inline", default = true };
				elseif markview.colors.get_hl_value(0, "@markup.link.url", "fg") then
					return { link = "@markup.link.url", default = true };
				end

				local fg = markview.colors.get({
					markview.colors.get_hl_value(0, "Label", "fg"),

					vim.o.background == "dark" and "#f5e0dc" or "#dc8a78"
				});

				return { fg = fg, underline = true, default = true };
			end
		},


		{
			output = function ()
				return markview.colors.create_gradient("Gradient", markview.colors.get_hl_value(0, "Normal", "bg") or markview.colors.get_hl_value(0, "Cursor", "fg"), markview.colors.get_hl_value(0, "Title", "fg"), 10, "fg");
			end
		}
		---_
	},
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
				match_string = "TODO",
				callout_preview = " Todo",
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
				match_string = "QUESTION",
				callout_preview = "󰋗 Question",
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
				match_string = "DANGER",
				callout_preview = " Danger",
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
		overwrite = { "parts" },

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
			"╭", "─", "╮", "┬",
			"├", "│", "┤", "┼",
			"╰", "─", "╯", "┴",

			"╼", "╾", "╴", "╶"
		},
		hl = {
			"MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder",
			"MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder",
			"MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder",

			"MarkviewTableAlignLeft", "MarkviewTableAlignRight", "MarkviewTableAlignCenter", "MarkviewTableAlignCenter"
		},

		block_decorator = true,
		use_virt_lines = true
	},
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
			self.window = vim.api.nvim_open_win(self.buffer, false, vim.tbl_deep_extend("force", markview.configuration.split_conf or {}, {
				win = windows[1],
				split = "right"
			}));
		else
			vim.api.nvim_win_set_config(self.window, vim.tbl_deep_extend("force", markview.configuration.split_conf or {}, {
				win = windows[1],
				split = "right"
			}));
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
			local parsed_content = markview.parser.init(buf);
			local windows = utils.find_attached_wins(buf);

			if markview.configuration.callbacks and markview.configuration.callbacks.on_enable then
				for _, window in ipairs(windows) do
					pcall(markview.configuration.callbacks.on_enable, buf, window);
				end
			end

			markview.state.buf_states[buf] = true;

			markview.renderer.clear(buf);
			markview.renderer.render(buf, parsed_content, markview.configuration)
		end
	end,
	disableAll = function ()
		for _, buf in ipairs(markview.attached_buffers) do
			local windows = utils.find_attached_wins(buf);

			if markview.configuration.callbacks and markview.configuration.callbacks.on_disable then
				for _, window in ipairs(windows) do
					pcall(markview.configuration.callbacks.on_disable, buf, window);
				end
			end

			markview.state.buf_states[buf] = false;
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

		local windows = utils.find_attached_wins(buffer);

		local parsed_content = markview.parser.init(buffer);

		markview.state.buf_states[buffer] = true;

		for _, window in ipairs(windows) do
			pcall(markview.configuration.callbacks.on_enable, buf, window);
		end

		markview.renderer.clear(buffer);
		markview.renderer.render(buffer, parsed_content, markview.configuration)
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

		local windows = utils.find_attached_wins(buffer);

		local parsed_content = markview.parser.init(buffer);

		markview.state.buf_states[buffer] = true;

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
})

markview.setup = function (user_config)
	if user_config and user_config.highlight_groups then
		markview.configuration.highlight_groups = vim.list_extend(markview.configuration.highlight_groups, user_config.highlight_groups);
		user_config.highlight_groups = nil;
	end

	---@type markview.config
	-- Merged configuration tables
	markview.configuration = vim.tbl_deep_extend("force", markview.configuration, user_config or {});

	if vim.islist(markview.configuration.highlight_groups) then
		markview.remove_hls();
		markview.add_hls(markview.configuration.highlight_groups);
	end

	markview.commands.enableAll();
end

return markview;
