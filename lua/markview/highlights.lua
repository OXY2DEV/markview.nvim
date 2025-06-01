--- *Dynamic* highlight group related methods
--- for `markview.nvim`.
local highlights = {};

local utils = require("markview.utils");

local lerp = utils.lerp;
local clamp = utils.clamp;

--- Returns RGB value from the provided input.
--- Supported input types,
---     • Hexadecimal values(`#FFFFFF` & `FFFFFF`).
---     • Number value of the hexadecimal color(from `nvim_get_hl()`).
---     • Color name(e.g. `red`, `green`).
--- 
---@param input string | number[]
---@return number[]?
highlights.rgb = function (input)
	--- Lookup table for the regular color names.
	--- For example,
	---     • `red` → `#FF0000`.
	---     • `green` → `#00FF00`.
	--- 
	---@type { [string]: string }
	local lookup = {
		["red"] = "#FF0000",        ["lightred"] = "#FFBBBB",      ["darkred"] = "#8B0000",
		["green"] = "#00FF00",      ["lightgreen"] = "#90EE90",    ["darkgreen"] = "#006400",    ["seagreen"] = "#2E8B57",
		["blue"] = "#0000FF",       ["lightblue"] = "#ADD8E6",     ["darkblue"] = "#00008B",     ["slateblue"] = "#6A5ACD",
		["cyan"] = "#00FFFF",       ["lightcyan"] = "#E0FFFF",     ["darkcyan"] = "#008B8B",
		["magenta"] = "#FF00FF",    ["lightmagenta"] = "#FFBBFF",  ["darkmagenta"] = "#8B008B",
		["yellow"] = "#FFFF00",     ["lightyellow"] = "#FFFFE0",   ["darkyellow"] = "#BBBB00",   ["brown"] = "#A52A2A",
		["grey"] = "#808080",       ["lightgrey"] = "#D3D3D3",     ["darkgrey"] = "#A9A9A9",
		["gray"] = "#808080",       ["lightgray"] = "#D3D3D3",     ["darkgray"] = "#A9A9A9",
		["black"] = "#000000",      ["white"] = "#FFFFFF",
		["orange"] = "#FFA500",     ["purple"] = "#800080",        ["violet"] = "#EE82EE"
	};

	--- Lookup table for the Neovim-specific color names.
	--- For example,
	---     • `nvimdarkblue` → `#004C73`.
	---     • `nvimdarkred` → `#590008`.
	--- 
	---@type { [string]: string }
	local lookup_nvim = {
		["nvimdarkblue"] = "#004C73",    ["nvimlightblue"] = "#A6DBFF",
		["nvimdarkcyan"] = "#007373",    ["nvimlightcyan"] = "#8CF8F7",
		["nvimdarkgray1"] = "#07080D",   ["nvimlightgray1"] = "#EEF1F8",
		["nvimdarkgray2"] = "#14161B",   ["nvimlightgray2"] = "#E0E2EA",
		["nvimdarkgray3"] = "#2C2E33",   ["nvimlightgray3"] = "#C4C6CD",
		["nvimdarkgray4"] = "#4F5258",   ["nvimlightgray4"] = "#9B9EA4",
		["nvimdarkgrey1"] = "#07080D",   ["nvimlightgrey1"] = "#EEF1F8",
		["nvimdarkgrey2"] = "#14161B",   ["nvimlightgrey2"] = "#E0E2EA",
		["nvimdarkgrey3"] = "#2C2E33",   ["nvimlightgrey3"] = "#C4C6CD",
		["nvimdarkgrey4"] = "#4F5258",   ["nvimlightgrey4"] = "#9B9EA4",
		["nvimdarkgreen"] = "#005523",   ["nvimlightgreen"] = "#B3F6C0",
		["nvimdarkmagenta"] = "#470045", ["nvimlightmagenta"] = "#FFCAFF",
		["nvimdarkred"] = "#590008",     ["nvimlightred"] = "#FFC0B9",
		["nvimdarkyellow"] = "#6B5300",  ["nvimlightyellow"] = "#FCE094",
	};

	if type(input) == "string" then
		--- Match cases,
		---     • RR GG BB, # is optional.
		---     • R G B, # is optional.
		---     • Color name.
		---     • HSL values(as `{ h, s, l }`)

		if input:match("^%#?(%x%x?)(%x%x?)(%x%x?)$") then
			--- Pattern explanation:
			---     #? RR? GG? BB?
			--- String should have **3** parts & each part
			--- should have a minimum of *1* & a maximum
			--- of *2* characters.
			---
			--- # is optional.
			---
			---@type string, string, string
			local r, g, b = input:match("^%#?(%x%x?)(%x%x?)(%x%x?)$");

			return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) };
		elseif lookup[input] then
			local r, g, b = lookup[input]:match("(%x%x)(%x%x)(%x%x)$");

			return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) };
		elseif lookup_nvim[input] then
			local r, g, b = lookup_nvim[input]:match("(%x%x)(%x%x)(%x%x)$");

			return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) };
		end

	elseif type(input) == "number" then
		--- Format the number into a hexadecimal string.
		--- Then get the **r**, **g**, **b** parts.
		--- 
		---@type string, string, string
		local r, g, b = string.format("%06x", input):match("(%x%x)(%x%x)(%x%x)$");

		return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) };
	end
end

--- Simple RGB *color-mixer* function.
--- Supports mixing colors by % values.
---
--- NOTE: `per_1` & `per_2` are between
--- **0** & **1**.
--- 
---@param c_1 number[]
---@param c_2 number[]
---@param per_1 number
---@param per_2 number
---@return number[]
highlights.mix = function (c_1, c_2, per_1, per_2)
	local _r = (c_1[1] * per_1) + (c_2[1] * per_2);
	local _g = (c_1[2] * per_1) + (c_2[2] * per_2);
	local _b = (c_1[3] * per_1) + (c_2[3] * per_2);

	return { math.floor(_r), math.floor(_g), math.floor(_b) };
end

--- RGB to hexadecimal string converter.
---
---@param color number[]
---@return string
highlights.rgb_to_hex = function (color)
	return string.format("#%02x%02x%02x", math.floor(color[1]), math.floor(color[2]), math.floor(color[3]))
end

--- RGB to HSL converter.
--- Input: `{ r, g, b }` where,
---   r ∈ [0, 255]
---   g ∈ [0, 255]
---   b ∈ [0, 255]
---
--- Return: `{ h, s, l }` where,
---   h ∈ [0, 360]
---   s ∈ [0, 1]
---   l ∈ [0, 1]
---
---@param color number[]
---@return number[]
highlights.rgb_to_hsl = function (color)
	local nR, nG, nB = color[1] / 255, color[2] / 255, color[3] / 255;
	local min, max = math.min(nR, nG, nB), math.max(nR, nG, nB);

	local h, s, l;
	l = (min + max) / 2;

	if min == max then
		s = 0;
	elseif l <= 0.5 then
		s = (max - min) / (max + min);
	else
		s = (max - min) / (2 - max - min);
	end

	if max == nR then
		h = (nG - nB) / (max - min);
	elseif max == nG then
		h = 2 + (nB - nR) / (max - min);
	else
		h = 4 + (nR - nG) / (max - min);
	end

	if h < 0 then
		h = 1 - h;
	end

	return { h * 60, s, l };
end

--- HSL to RGB converter.
--- Input: `{ h, s, l }` where,
---   h ∈ [0, 360]
---   s ∈ [0, 1]
---   l ∈ [0, 1]
---
--- Return: `{ r, g, b }` where,
---   r ∈ [0, 255]
---   g ∈ [0, 255]
---   b ∈ [0, 255]
---
---@param color integer[]
highlights.hsl_to_rgb = function (color)
	local h, s, l = color[1] / 360, color[2], color[3];

	if s == 0 then
		return { l * 255, l * 255, l * 255 };
	end

	local tmp_1, tmp_2;

	if l < 0.5 then
		tmp_1 = l * (1 + s);
	else
		tmp_1 = l + s - (l * s);
	end

	tmp_2 = (2 * l) - tmp_1;
	local tR, tG, tB;

	tR = h + 0.333;
	tG = h;
	tB = h - 0.333;

	tR = tR < 0 and tR + 1 or tR;
	tG = tG < 0 and tG + 1 or tG;
	tB = tB < 0 and tB + 1 or tB;

	local function checker (val)
		if 6 * val < 1 then
			return tmp_2 + (tmp_1 - tmp_2) * 6 * val;
		elseif 2 * val < 1 then
			return tmp_1;
		elseif 3 * val < 2 then
			return tmp_2 + (tmp_1 - tmp_2) * (0.666 - val) * 6;
		else
			return tmp_2;
		end
	end

	return {
		clamp(checker(tR) * 255, 0, 255),
		clamp(checker(tG) * 255, 0, 255),
		clamp(checker(tB) * 255, 0, 255),
	};
end

--- Deprecated RGB to HSL converter.
---@param rgb integer[]
---@return integer[]
---@deprecated
highlights.hsl = function (rgb)
	vim.notify("[ markview.nvim ]: highlights.hsl is deprecated. Use 'highlights.rgb_to_hsl' instead", vim.log.levels.WARN);
	return highlights.rgb_to_hsl(rgb);
end

--- Gets the luminosity of a RGB value.
---
--- Input: `{ r, g, b }` where,
---   r ∈ [0, 255]
---   g ∈ [0, 255]
---   b ∈ [0, 255]
---
--- Return: `l` where,
---   l ∈ [0, 1]
---
---@param input number[]
---@return number
highlights.lumen = function (input)
	local min = math.min(input[1], input[2], input[3]);
	local max = math.max(input[1], input[2], input[3]);

	return (min + max) / 2;
end

--- Mixes a color with it's background based on
--- the provided `alpha`(between 0 & 1).
---
--- Input:
---   fg: `{ r, g, b }` where,
---     r ∈ [0, 255]
---     g ∈ [0, 255]
---     b ∈ [0, 255]
---
---   bg: `{ r, g, b }` where,
---     r ∈ [0, 255]
---     g ∈ [0, 255]
---     b ∈ [0, 255]
---
---   alpha: `a` where,
---     a ∈ [0, 1]
---
---@param fg number[]
---@param bg number[]
---@param alpha number
---@return number[]
---@deprecated
highlights.opacify = function (fg, bg, alpha)
	vim.notify("[ markview.nvim ]: highlights.opacify is deprecated. Use 'highlights.mix' instead", vim.log.levels.WARN);
	return {
		math.floor((fg[1] * alpha) + (bg[1] * (1 - alpha))),
		math.floor((fg[2] * alpha) + (bg[2] * (1 - alpha))),
		math.floor((fg[3] * alpha) + (bg[3] * (1 - alpha))),
	}
end

--- Turns RGB color-space into XYZ.
---
--- Input: `{ r, g, b }` where,
---   r ∈ [0, 255]
---   g ∈ [0, 255]
---   b ∈ [0, 255]
---
---@param color number[]
---@return number[]
highlights.rgb_to_xyz = function (color)
	local RGB = {};

	for c, channel in ipairs(color) do
		local _ch = channel / 255;

		if _ch <= 0.04045 then
			_ch = _ch / 12.92;
		else
			_ch = ((_ch + 0.055) / 1.055)^2.4;
		end

		RGB[c] = _ch;
	end

	local matrix = {
		0.4124504, 0.3575761, 0.1804375,
		0.2126729, 0.7151522, 0.0721750,
		0.0193339, 0.1191920, 0.9503041
	};

	return {
		(RGB[1] * matrix[1] + RGB[2] * matrix[2] + RGB[3] * matrix[3]) * 100,
		(RGB[1] * matrix[4] + RGB[2] * matrix[5] + RGB[3] * matrix[6]) * 100,
		(RGB[1] * matrix[7] + RGB[2] * matrix[8] + RGB[3] * matrix[9]) * 100
	}
end

--- Turns XYZ color-space into RGB.
---@param color number[]
---@return number[]
highlights.xyz_to_rgb = function (color)
	local XYZ = color;

	for c, channel in ipairs(color) do
		local _ch = channel / 100;
		XYZ[c] = _ch;
	end

	local rev_matrix = {
		3.2404542, -1.5371385, -0.4985314,
		-0.9692660, 1.8760108, 0.0415560,
		0.0556434, -0.2040259, 1.0572252
	};

	local RGB = {
		XYZ[1] * rev_matrix[1] + XYZ[2] * rev_matrix[2] + XYZ[3] * rev_matrix[3],
		XYZ[1] * rev_matrix[4] + XYZ[2] * rev_matrix[5] + XYZ[3] * rev_matrix[6],
		XYZ[1] * rev_matrix[7] + XYZ[2] * rev_matrix[8] + XYZ[3] * rev_matrix[9]
	};

	for c, channel in ipairs(RGB) do
		local _ch = channel;

		if _ch <= 0.0031308 then
			_ch = _ch * 12.92;
		else
			_ch = (1.055 * (_ch^(1 / 2.4))) - 0.055;
		end

		RGB[c] = utils.clamp(_ch * 255, 0, 255);
	end

	return RGB;
end

--- Turns XYZ color-space into Lab.
---@param color number[]
---@return number[]
highlights.xyz_to_lab = function (color)
	local ref_point = { 95.047, 100, 108.883 };

	local f = function (t)
		if t > (6 / 29)^3 then
			return t^(1/3);
		else
			return ( (1 / 3) * t * ((6 / 29)^-2) ) + (4 / 29);
		end
	end

	return {
		( 116 * f(color[2] / ref_point[2]) ) - 16,
		500 * (  f(color[1] / ref_point[1]) - f(color[2] / ref_point[2]) ),
		200 * (  f(color[2] / ref_point[2]) - f(color[3] / ref_point[3]) )
	};
end

--- Turns Lab color-space into XYZ.
---@param color number[]
---@return number[]
highlights.lab_to_xyz = function (color)
	local ref_point = { 95.047, 100, 108.883 };

	local f_inv = function (t)
		if t > (6 / 29) then
			return t^3;
		else
			return 3 * ((6 / 29)^2) * (t - (4 / 29));
		end
	end

	local tmp = (color[1] + 16) / 116;

	return {
		ref_point[1] * f_inv( tmp + (color[2] / 500) ),
		ref_point[2] * f_inv(tmp),
		ref_point[3] * f_inv( tmp - (color[3] / 200) )
	};
end

--- Turns RGB color-space into Lab.
---@param RGB number[]
---@return number[]
highlights.rgb_to_lab = function (RGB)
	local XYZ = highlights.rgb_to_xyz(RGB);
	return highlights.xyz_to_lab(XYZ);
end

--- Turns Lab color-space into RGB.
---@param Lab number[]
---@return number[]
highlights.lab_to_rgb = function (Lab)
	local XYZ = highlights.lab_to_xyz(Lab);
	return highlights.xyz_to_rgb(XYZ);
end

--- Holds info about highlight groups.
---@type string[]
highlights.created = {};

--- Wrapper function for `nvim_set_hl()`.
---@param name string
---@param value table
highlights.set_hl = function (name, value)
	local found, v = pcall(vim.api.nvim_get_hl, 0, { name = name, create = false, link = false });

	if found and vim.tbl_isempty(v) == false then
		return;
	end

	local success, err = pcall(vim.api.nvim_set_hl, 0, name, value);

	if success == false and err then
		require("markview.health").notify("hl", {
			group = name,
			value = value,

			message = err
		});
	else
		table.insert(highlights.created, name);
	end
end

--- Creates highlight groups from an array of tables
---@param array { [string]: config.hl | fun(): config.hl }
highlights.create = function (array)
	highlights.created = {};

	if type(array) == "string" then
		if not highlights[array] then
			return;
		end

		array = highlights[array];
	end

	local hls = vim.tbl_keys(array) or {};
	table.sort(hls);

	for _, hl in ipairs(hls) do
		local value = array[hl];

		if not hl:match("^Markview") then
			hl = "Markview" .. hl;
		end

		if type(value) == "table" then
			highlights.set_hl(hl, value);
		else
			local val = value();

			if vim.islist(val) then
				for _, item in ipairs(val) do
					highlights.set_hl(item.group_name, item.value);
				end
			else
				highlights.set_hl(hl, val);
			end
		end
	end
end

--- Destroys created highlight groups.
--- Internal function! Should be only called
--- manually!
highlights.destroy = function ()
	for _, name in ipairs(highlights.created) do
		--- BUG, `nvim_set_hl()` gives unexpected
		--- behavior.
		vim.cmd("hi clear " .. name);
	end

	highlights.created = {};
end

--- Is the background "dark"?
--- Returns values based on this condition(when provided).
---@param on_light any
---@param on_dark any
---@return any
local is_dark = function (on_light, on_dark)
	return vim.o.background == "dark" and (on_dark or true) or (on_light or false);
end

--- Gets {property} from a list of highlight groups.
---@param property string
---@param groups string[]
---@param light any
---@param dark any
---@return any
highlights.get_property = function (property, groups, light, dark)
	local val;

	for _, item in ipairs(groups) do
		if
			vim.fn.hlexists(item) and
			vim.api.nvim_get_hl(0, { name = item, link = false })[property]
		then
			val = vim.api.nvim_get_hl(0, { name = item, link = false })[property];
			break;
		end
	end

	if val then
		return vim.list_contains({ "fg", "bg", "sp" }, property) and highlights.rgb(val) or val;
	end

	return vim.list_contains({ "fg", "bg", "sp" }, property) and highlights.rgb(is_dark(light, dark)) or is_dark(light, dark);
end

--- Gets color properties from a highlight group.
---@param opt string
---@param fallback any
---@param on_light any
---@param on_dark any
---@return any
---@deprecated
highlights.color = function (opt, fallback, on_light, on_dark)
	vim.notify("[ markview.nvim ]: highlights.color is deprecated. Use 'highlights.get_property' instead", vim.log.levels.WARN);
	highlights.get_property(opt, fallback, on_light, on_dark);
end

--- Generates a heading highlight group.
---@return config.hl
---@deprecated
highlights.generate_heading = function (opts)
	local vim_bg = highlights.rgb_to_lab(highlights.get_property(
		"bg",
		opts.bg_fallbacks or { "Normal" },
		opts.light_bg or "#FFFFFF",
		opts.dark_bg or "#000000"
	));
	local h_fg = highlights.rgb_to_lab(highlights.get_property(
		"fg",
		opts.fallbacks,
		opts.light_fg or "#000000",
		opts.dark_fg or "#FFFFFF"
	));

	local l_bg = highlights.lumen(highlights.lab_to_rgb(vim_bg));
	local alpha = opts.alpha or (l_bg > 0.5 and 0.15 or 0.25);

	local res_bg = highlights.lab_to_rgb(highlights.mix(h_fg, vim_bg, alpha, 1 - alpha));

	vim_bg = highlights.lab_to_rgb(vim_bg);
	h_fg = highlights.lab_to_rgb(h_fg);

	return {
		bg = highlights.rgb_to_hex(res_bg),
		fg = highlights.rgb_to_hex(h_fg)
	};
end

--- Generates a highlight group.
---@param opts { source_opt: string?, output_opt: string?, hl_opts: config.hl?, source: string[], fallback_light: string, fallback_dark: string }
---@return config.hl
highlights.hl_generator = function (opts)
	local hi = highlights.get_property(
		opts.source_opt or "fg",
		opts.source or { "Normal" },
		opts.fallback_light or "#000000",
		opts.fallback_dark or "#FFFFFF"
	);

	return vim.tbl_extend("force", {
		[opts.output_opt or "fg"] = highlights.rgb_to_hex(hi)
	}, opts.hl_opts or {})
end

---@type { [string]: function }
highlights.dynamic = {
	["0P"] = function ()
		local vim_bg = highlights.rgb_to_lab(highlights.get_property(
			"bg",
			{ "Normal" },
			"#EFF1F5",
			"#1E1E2E"
		));
		local h_fg = highlights.rgb_to_lab(highlights.get_property(
			"fg",
			{ "Comment" },
			"#9CA0B0",
			"#6C7086"
		));

		local l_bg = highlights.lumen(highlights.lab_to_rgb(vim_bg));
		local alpha = vim.g.__mkv_palette_alpha or (l_bg > 0.5 and 0.15 or 0.25);

		local nr_bg = vim.api.nvim_get_hl(0, { name = "LineNr", link = false }).bg
		local res_bg = highlights.lab_to_rgb(highlights.mix(h_fg, vim_bg, alpha, 1 - alpha));

		vim_bg = highlights.lab_to_rgb(vim_bg);
		h_fg = highlights.lab_to_rgb(h_fg);

		return {
			{
				group_name = "MarkviewPalette0",
				value = {
					default = true,

					bg = highlights.rgb_to_hex(res_bg),
					fg = highlights.rgb_to_hex(h_fg)
				}
			},
			{
				group_name = "MarkviewPalette0Fg",
				value = {
					default = true,

					fg = highlights.rgb_to_hex(h_fg)
				}
			},
			{
				group_name = "MarkviewPalette0Bg",
				value = {
					default = true,

					bg = highlights.rgb_to_hex(res_bg),
				}
			},
			{
				group_name = "MarkviewPalette0Sign",
				value = {
					default = true,

					bg = nr_bg,
					fg = highlights.rgb_to_hex(h_fg)
				}
			}
		};
	end,
	["1P"] = function ()
		local vim_bg = highlights.rgb_to_lab(highlights.get_property(
			"bg",
			{ "Normal" },
			"#EFF1F5",
			"#1E1E2E"
		));
		local h_fg = highlights.rgb_to_lab(highlights.get_property(
			"fg",
			{ "@markup.heading.1.markdown", "@markup.heading", "markdownH1"  },
			"#D20F39",
			"#F38BA8"
		));

		local l_bg = highlights.lumen(highlights.lab_to_rgb(vim_bg));
		local alpha = vim.g.__mkv_palette_alpha or (l_bg > 0.5 and 0.15 or 0.25);

		local nr_bg = vim.api.nvim_get_hl(0, { name = "LineNr", link = false }).bg
		local res_bg = highlights.lab_to_rgb(highlights.mix(h_fg, vim_bg, alpha, 1 - alpha));

		vim_bg = highlights.lab_to_rgb(vim_bg);
		h_fg = highlights.lab_to_rgb(h_fg);

		return {
			{
				group_name = "MarkviewPalette1",
				value = {
					default = true,

					bg = highlights.rgb_to_hex(res_bg),
					fg = highlights.rgb_to_hex(h_fg)
				}
			},
			{
				group_name = "MarkviewPalette1Fg",
				value = {
					default = true,

					fg = highlights.rgb_to_hex(h_fg)
				}
			},
			{
				group_name = "MarkviewPalette1Bg",
				value = {
					default = true,

					bg = highlights.rgb_to_hex(res_bg),
				}
			},
			{
				group_name = "MarkviewPalette1Sign",
				value = {
					default = true,

					bg = nr_bg,
					fg = highlights.rgb_to_hex(h_fg)
				}
			}
		};
	end,
	["2P"] = function ()
		local vim_bg = highlights.rgb_to_lab(highlights.get_property(
			"bg",
			{ "Normal" },
			"#EFF1F5",
			"#1E1E2E"
		));
		local h_fg = highlights.rgb_to_lab(highlights.get_property(
			"fg",
			{ "@markup.heading.2.markdown", "@markup.heading", "markdownH2"  },
			"#FAB387",
			"#FE640B"
		));

		local l_bg = highlights.lumen(highlights.lab_to_rgb(vim_bg));
		local alpha = vim.g.__mkv_palette_alpha or (l_bg > 0.5 and 0.15 or 0.25);

		local nr_bg = vim.api.nvim_get_hl(0, { name = "LineNr", link = false }).bg
		local res_bg = highlights.lab_to_rgb(highlights.mix(h_fg, vim_bg, alpha, 1 - alpha));

		vim_bg = highlights.lab_to_rgb(vim_bg);
		h_fg = highlights.lab_to_rgb(h_fg);

		return {
			{
				group_name = "MarkviewPalette2",
				value = {
					default = true,

					bg = highlights.rgb_to_hex(res_bg),
					fg = highlights.rgb_to_hex(h_fg)
				}
			},
			{
				group_name = "MarkviewPalette2Fg",
				value = {
					default = true,

					fg = highlights.rgb_to_hex(h_fg)
				}
			},
			{
				group_name = "MarkviewPalette2Bg",
				value = {
					default = true,

					bg = highlights.rgb_to_hex(res_bg),
				}
			},
			{
				group_name = "MarkviewPalette2Sign",
				value = {
					default = true,

					bg = nr_bg,
					fg = highlights.rgb_to_hex(h_fg)
				}
			}
		};
	end,
	["3P"] = function ()
		local vim_bg = highlights.rgb_to_lab(highlights.get_property(
			"bg",
			{ "Normal" },
			"#EFF1F5",
			"#1E1E2E"
		));
		local h_fg = highlights.rgb_to_lab(highlights.get_property(
			"fg",
			{ "@markup.heading.3.markdown", "@markup.heading", "markdownH3"  },
			"#DF8E1D",
			"#F9E2AF"
		));

		local l_bg = highlights.lumen(highlights.lab_to_rgb(vim_bg));
		local alpha = vim.g.__mkv_palette_alpha or (l_bg > 0.5 and 0.15 or 0.25);

		local nr_bg = vim.api.nvim_get_hl(0, { name = "LineNr", link = false }).bg
		local res_bg = highlights.lab_to_rgb(highlights.mix(h_fg, vim_bg, alpha, 1 - alpha));

		vim_bg = highlights.lab_to_rgb(vim_bg);
		h_fg = highlights.lab_to_rgb(h_fg);

		return {
			{
				group_name = "MarkviewPalette3",
				value = {
					default = true,

					bg = highlights.rgb_to_hex(res_bg),
					fg = highlights.rgb_to_hex(h_fg)
				}
			},
			{
				group_name = "MarkviewPalette3Fg",
				value = {
					default = true,

					fg = highlights.rgb_to_hex(h_fg)
				}
			},
			{
				group_name = "MarkviewPalette3Bg",
				value = {
					default = true,

					bg = highlights.rgb_to_hex(res_bg),
				}
			},
			{
				group_name = "MarkviewPalette3Sign",
				value = {
					default = true,

					bg = nr_bg,
					fg = highlights.rgb_to_hex(h_fg)
				}
			}
		};
	end,
	["4P"] = function ()
		local vim_bg = highlights.rgb_to_lab(highlights.get_property(
			"bg",
			{ "Normal" },
			"#EFF1F5",
			"#1E1E2E"
		));
		local h_fg = highlights.rgb_to_lab(highlights.get_property(
			"fg",
			{ "@markup.heading.4.markdown", "@markup.heading", "markdownH4"  },
			"#40A02B",
			"#A6E3A1"
		));

		local l_bg = highlights.lumen(highlights.lab_to_rgb(vim_bg));
		local alpha = vim.g.__mkv_palette_alpha or (l_bg > 0.5 and 0.15 or 0.25);

		local nr_bg = vim.api.nvim_get_hl(0, { name = "LineNr", link = false }).bg
		local res_bg = highlights.lab_to_rgb(highlights.mix(h_fg, vim_bg, alpha, 1 - alpha));

		vim_bg = highlights.lab_to_rgb(vim_bg);
		h_fg = highlights.lab_to_rgb(h_fg);

		return {
			{
				group_name = "MarkviewPalette4",
				value = {
					default = true,

					bg = highlights.rgb_to_hex(res_bg),
					fg = highlights.rgb_to_hex(h_fg)
				}
			},
			{
				group_name = "MarkviewPalette4Fg",
				value = {
					default = true,

					fg = highlights.rgb_to_hex(h_fg)
				}
			},
			{
				group_name = "MarkviewPalette4Bg",
				value = {
					default = true,

					bg = highlights.rgb_to_hex(res_bg),
				}
			},
			{
				group_name = "MarkviewPalette4Sign",
				value = {
					default = true,

					bg = nr_bg,
					fg = highlights.rgb_to_hex(h_fg)
				}
			}
		};
	end,
	["5P"] = function ()
		local vim_bg = highlights.rgb_to_lab(highlights.get_property(
			"bg",
			{ "Normal" },
			"#EFF1F5",
			"#1E1E2E"
		));
		local h_fg = highlights.rgb_to_lab(highlights.get_property(
			"fg",
			{ "@markup.heading.5.markdown", "@markup.heading", "markdownH5"  },
			"#209FB5",
			"#74C7EC"
		));

		local l_bg = highlights.lumen(highlights.lab_to_rgb(vim_bg));
		local alpha = vim.g.__mkv_palette_alpha or (l_bg > 0.5 and 0.15 or 0.25);

		local nr_bg = vim.api.nvim_get_hl(0, { name = "LineNr", link = false }).bg
		local res_bg = highlights.lab_to_rgb(highlights.mix(h_fg, vim_bg, alpha, 1 - alpha));

		vim_bg = highlights.lab_to_rgb(vim_bg);
		h_fg = highlights.lab_to_rgb(h_fg);

		return {
			{
				group_name = "MarkviewPalette5",
				value = {
					default = true,

					bg = highlights.rgb_to_hex(res_bg),
					fg = highlights.rgb_to_hex(h_fg)
				}
			},
			{
				group_name = "MarkviewPalette5Fg",
				value = {
					default = true,

					fg = highlights.rgb_to_hex(h_fg)
				}
			},
			{
				group_name = "MarkviewPalette5Bg",
				value = {
					default = true,

					bg = highlights.rgb_to_hex(res_bg),
				}
			},
			{
				group_name = "MarkviewPalette5Sign",
				value = {
					default = true,

					bg = nr_bg,
					fg = highlights.rgb_to_hex(h_fg)
				}
			}
		};
	end,
	["6P"] = function ()
		local vim_bg = highlights.rgb_to_lab(highlights.get_property(
			"bg",
			{ "Normal" },
			"#EFF1F5",
			"#1E1E2E"
		));
		local h_fg = highlights.rgb_to_lab(highlights.get_property(
			"fg",
			{ "@markup.heading.6.markdown", "@markup.heading", "markdownH6"  },
			"#7287FD",
			"#B4BEFE"
		));

		local l_bg = highlights.lumen(highlights.lab_to_rgb(vim_bg));
		local alpha = vim.g.__mkv_palette_alpha or (l_bg > 0.5 and 0.15 or 0.25);

		local nr_bg = vim.api.nvim_get_hl(0, { name = "LineNr", link = false }).bg
		local res_bg = highlights.lab_to_rgb(highlights.mix(h_fg, vim_bg, alpha, 1 - alpha));

		vim_bg = highlights.lab_to_rgb(vim_bg);
		h_fg = highlights.lab_to_rgb(h_fg);

		return {
			{
				group_name = "MarkviewPalette6",
				value = {
					default = true,

					bg = highlights.rgb_to_hex(res_bg),
					fg = highlights.rgb_to_hex(h_fg)
				}
			},
			{
				group_name = "MarkviewPalette6Fg",
				value = {
					default = true,

					fg = highlights.rgb_to_hex(h_fg)
				}
			},
			{
				group_name = "MarkviewPalette6Bg",
				value = {
					default = true,

					bg = highlights.rgb_to_hex(res_bg),
				}
			},
			{
				group_name = "MarkviewPalette6Sign",
				value = {
					default = true,

					bg = nr_bg,
					fg = highlights.rgb_to_hex(h_fg)
				}
			}
		};
	end,
	["7P"] = function ()
		local vim_bg = highlights.rgb_to_lab(highlights.get_property(
			"bg",
			{ "Normal" },
			"#EFF1F5",
			"#1E1E2E"
		));
		local h_fg = highlights.rgb_to_lab(highlights.get_property(
			"fg",
			{ "@conditional", "@keyword.conditional", "Conditional" },
			"#8839EF",
			"#CBA6F7"
		));

		local l_bg = highlights.lumen(highlights.lab_to_rgb(vim_bg));
		local alpha = vim.g.__mkv_palette_alpha or (l_bg > 0.5 and 0.15 or 0.25);

		local nr_bg = vim.api.nvim_get_hl(0, { name = "LineNr", link = false }).bg
		local res_bg = highlights.lab_to_rgb(highlights.mix(h_fg, vim_bg, alpha, 1 - alpha));

		vim_bg = highlights.lab_to_rgb(vim_bg);
		h_fg = highlights.lab_to_rgb(h_fg);

		return {
			{
				group_name = "MarkviewPalette7",
				value = {
					default = true,

					bg = highlights.rgb_to_hex(res_bg),
					fg = highlights.rgb_to_hex(h_fg)
				}
			},
			{
				group_name = "MarkviewPalette7Fg",
				value = {
					default = true,

					fg = highlights.rgb_to_hex(h_fg)
				}
			},
			{
				group_name = "MarkviewPalette7Bg",
				value = {
					default = true,

					bg = highlights.rgb_to_hex(res_bg),
				}
			},
			{
				group_name = "MarkviewPalette7Sign",
				value = {
					default = true,

					bg = nr_bg,
					fg = highlights.rgb_to_hex(h_fg)
				}
			}
		};
	end,

	["BlockQuoteDefault"] = function ()
		return {
			default = true,
			link = "MarkviewPalette0Fg"
		};
	end,

	["BlockQuoteError"] = function ()
		return {
			default = true,
			link = "MarkviewPalette1Fg"
		};
	end,

	["BlockQuoteNote"] = function ()
		return {
			default = true,
			link = "MarkviewPalette5Fg"
		};
	end,

	["BlockQuoteOk"] = function ()
		return {
			default = true,
			link = "MarkviewPalette4Fg"
		};
	end,

	["BlockQuoteSpecial"] = function ()
		return {
			default = true,
			link = "MarkviewPalette3Fg"
		};
	end,

	["BlockQuoteWarn"] = function ()
		return {
			default = true,
			link = "MarkviewPalette2Fg"
		};
	end,
	["CheckboxCancelled"] = function ()
		return {
			default = true,
			link = "MarkviewPalette0Fg"
		};
	end,
	["CheckboxChecked"] = function ()
		return {
			default = true,
			link = "MarkviewPalette4Fg"
		};
	end,
	["CheckboxPending"] = function ()
		return {
			default = true,
			link = "MarkviewPalette2Fg"
		};
	end,
	["CheckboxProgress"] = function ()
		return {
			default = true,
			link = "MarkviewPalette6Fg"
		};
	end,
	["CheckboxUnchecked"] = function ()
		return {
			default = true,
			link = "MarkviewPalette1Fg"
		};
	end,
	["CheckboxStriked"] = function ()
		return {
			default = true,
			strikethrough = true,
			fg = vim.api.nvim_get_hl(0, { name = "MarkviewPalette0Fg" }).fg
		};
	end,
	["Code"] = function ()
		local vim_bg = highlights.rgb_to_hsl(highlights.get_property(
			"bg",
			{ "Normal" },
			"#FFFFFF",
			"#000000"
		));

		if vim_bg[3] > 0.5 then
			vim_bg[3] = clamp(vim_bg[3] - 0.05, 0.1, 0.9);
		else
			vim_bg[3] = clamp(vim_bg[3] + 0.05, 0.1, 0.9);
		end

		vim_bg = highlights.hsl_to_rgb(vim_bg);

		return {
			bg = highlights.rgb_to_hex(vim_bg)
		};
	end,
	["CodeInfo"] = function ()
		local vim_bg = highlights.rgb_to_hsl(highlights.get_property(
			"bg",
			{ "Normal" },
			"#FFFFFF",
			"#000000"
		));
		local code_fg = highlights.get_property(
			"fg",
			{ "Comment" },
			"#9CA0B0",
			"#6C7086"
		);

		if vim_bg[3] > 0.5 then
			vim_bg[3] = clamp(vim_bg[3] - 0.05, 0.1, 0.9);
		else
			vim_bg[3] = clamp(vim_bg[3] + 0.05, 0.1, 0.9);
		end

		vim_bg = highlights.hsl_to_rgb(vim_bg);

		return {
			bg = highlights.rgb_to_hex(vim_bg),
			fg = highlights.rgb_to_hex(code_fg)
		};
	end,
	["CodeFg"] = function ()
		local vim_bg = highlights.rgb_to_hsl(highlights.get_property(
			"bg",
			{ "Normal" },
			"#FFFFFF",
			"#000000"
		));

		if vim_bg[3] > 0.5 then
			vim_bg[3] = clamp(vim_bg[3] - 0.05, 0.1, 0.9);
		else
			vim_bg[3] = clamp(vim_bg[3] + 0.05, 0.1, 0.9);
		end

		vim_bg = highlights.hsl_to_rgb(vim_bg);

		return {
			fg = highlights.rgb_to_hex(vim_bg)
		};
	end,
	["InlineCode"] = function ()
		local vim_bg = highlights.rgb_to_hsl(highlights.get_property(
			"bg",
			{ "Normal" },
			"#FFFFFF",
			"#000000"
		));

		if vim_bg[3] > 0.5 then
			vim_bg[3] = clamp(vim_bg[3] - 0.1, 0.1, 0.9);
		else
			vim_bg[3] = clamp(vim_bg[3] + 0.1, 0.1, 0.9);
		end

		vim_bg = highlights.hsl_to_rgb(vim_bg);

		return {
			bg = highlights.rgb_to_hex(vim_bg)
		};
	end,


	["Icon0"] = function ()
		return highlights.hl_generator({
			source = { "MarkviewPalette0" },
			light_fg = "#FE640B",
			dark_fg = "#FAB387",

			hl_opts = {
				bg = vim.api.nvim_get_hl(0, { name = "MarkviewCode", link = false }).bg
			}
		});
	end,

	["Icon1"] = function ()
		return highlights.hl_generator({
			source = { "MarkviewPalette1" },
			light_fg = "#FE640B",
			dark_fg = "#FAB387",

			hl_opts = {
				bg = vim.api.nvim_get_hl(0, { name = "MarkviewCode", link = false }).bg
			}
		});
	end,

	["Icon2"] = function ()
		return highlights.hl_generator({
			source = { "MarkviewPalette2" },
			light_fg = "#FE640B",
			dark_fg = "#FAB387",

			hl_opts = {
				bg = vim.api.nvim_get_hl(0, { name = "MarkviewCode", link = false }).bg
			}
		});
	end,

	["Icon3"] = function ()
		return highlights.hl_generator({
			source = { "MarkviewPalette3" },
			light_fg = "#F9E2AF",
			dark_fg = "#DF8E1D",

			hl_opts = {
				bg = vim.api.nvim_get_hl(0, { name = "MarkviewCode", link = false }).bg
			}
		});
	end,

	["Icon4"] = function ()
		return highlights.hl_generator({
			source = { "MarkviewPalette4" },
			light_fg = "#A6E3A1",
			dark_fg = "#40A02B",

			hl_opts = {
				bg = vim.api.nvim_get_hl(0, { name = "MarkviewCode", link = false }).bg
			}
		});
	end,

	["Icon5"] = function ()
		return highlights.hl_generator({
			source = { "MarkviewPalette5" },
			light_fg = "#74C7EC",
			dark_fg = "#209FB5",

			hl_opts = {
				bg = vim.api.nvim_get_hl(0, { name = "MarkviewCode", link = false }).bg
			}
		});
	end,

	["Icon6"] = function ()
		return highlights.hl_generator({
			source = { "MarkviewPalette6" },
			light_fg = "#B4BEFE",
			dark_fg = "#7287FD",

			hl_opts = {
				bg = vim.api.nvim_get_hl(0, { name = "MarkviewCode", link = false }).bg
			}
		});
	end,
	["Heading1"] = function ()
		return {
			default = true,
			link = "MarkviewPalette1"
		};
	end,
	["Heading2"] = function ()
		return {
			default = true,
			link = "MarkviewPalette2"
		};
	end,
	["Heading3"] = function ()
		return {
			default = true,
			link = "MarkviewPalette3"
		};
	end,
	["heading4"] = function ()
		return {
			default = true,
			link = "MarkviewPalette4"
		};
	end,
	["Heading5"] = function ()
		return {
			default = true,
			link = "MarkviewPalette5"
		};
	end,
	["Heading6"] = function ()
		return {
			default = true,
			link = "MarkviewPalette6"
		};
	end,


	["Heading1Sign"] = function ()
		return {
			default = true,
			link = "MarkviewPalette1Sign"
		};
	end,
	["Heading2Sign"] = function ()
		return {
			default = true,
			link = "MarkviewPalette2Sign"
		};
	end,
	["Heading3Sign"] = function ()
		return {
			default = true,
			link = "MarkviewPalette3Sign"
		};
	end,
	["heading4Sign"] = function ()
		return {
			default = true,
			link = "MarkviewPalette4Sign"
		};
	end,
	["Heading5Sign"] = function ()
		return {
			default = true,
			link = "MarkviewPalette5Sign"
		};
	end,
	["Heading6Sign"] = function ()
		return {
			default = true,
			link = "MarkviewPalette6Sign"
		};
	end,

	["Gradient0"] = function ()
		local from = highlights.get_property("bg", { "Normal" }, "#CDD6F4", "#1E1E2E");

		return {
			default = true,
			fg = highlights.rgb_to_hex(from);
		};
	end,
	["Gradient1"] = function ()
		local from = highlights.get_property("bg", { "Normal" }, "#CDD6F4", "#1E1E2E");
		local to   = highlights.get_property("fg", { "Title" }, "#1e66f5", "#89b4fa");

		return {
			default = true,
			fg = highlights.rgb_to_hex({
				lerp(from[1], to[1], 1 / 9),
				lerp(from[2], to[2], 1 / 9),
				lerp(from[3], to[3], 1 / 9),
			});
		};
	end,
	["Gradient2"] = function ()
		local from = highlights.get_property("bg", { "Normal" }, "#CDD6F4", "#1E1E2E");
		local to   = highlights.get_property("fg", { "Title" }, "#1e66f5", "#89b4fa");

		return {
			default = true,
			fg = highlights.rgb_to_hex({
				lerp(from[1], to[1], 2 / 9),
				lerp(from[2], to[2], 2 / 9),
				lerp(from[3], to[3], 2 / 9),
			});
		};
	end,
	["Gradient3"] = function ()
		local from = highlights.get_property("bg", { "Normal" }, "#CDD6F4", "#1E1E2E");
		local to   = highlights.get_property("fg", { "Title" }, "#1e66f5", "#89b4fa");

		return {
			default = true,
			fg = highlights.rgb_to_hex({
				lerp(from[1], to[1], 3 / 9),
				lerp(from[2], to[2], 3 / 9),
				lerp(from[3], to[3], 3 / 9),
			});
		};
	end,
	["Gradient4"] = function ()
		local from = highlights.get_property("bg", { "Normal" }, "#CDD6F4", "#1E1E2E");
		local to   = highlights.get_property("fg", { "Title" }, "#1e66f5", "#89b4fa");

		return {
			default = true,
			fg = highlights.rgb_to_hex({
				lerp(from[1], to[1], 4 / 9),
				lerp(from[2], to[2], 4 / 9),
				lerp(from[3], to[3], 4 / 9),
			});
		};
	end,
	["Gradient5"] = function ()
		local from = highlights.get_property("bg", { "Normal" }, "#CDD6F4", "#1E1E2E");
		local to   = highlights.get_property("fg", { "Title" }, "#1e66f5", "#89b4fa");

		return {
			default = true,
			fg = highlights.rgb_to_hex({
				lerp(from[1], to[1], 5 / 9),
				lerp(from[2], to[2], 5 / 9),
				lerp(from[3], to[3], 5 / 9),
			});
		};
	end,
	["Gradient6"] = function ()
		local from = highlights.get_property("bg", { "Normal" }, "#CDD6F4", "#1E1E2E");
		local to   = highlights.get_property("fg", { "Title" }, "#1e66f5", "#89b4fa");

		return {
			default = true,
			fg = highlights.rgb_to_hex({
				lerp(from[1], to[1], 6 / 9),
				lerp(from[2], to[2], 6 / 9),
				lerp(from[3], to[3], 6 / 9),
			});
		};
	end,
	["Gradient7"] = function ()
		local from = highlights.get_property("bg", { "Normal" }, "#CDD6F4", "#1E1E2E");
		local to   = highlights.get_property("fg", { "Title" }, "#1e66f5", "#89b4fa");

		return {
			default = true,
			fg = highlights.rgb_to_hex({
				lerp(from[1], to[1], 7 / 9),
				lerp(from[2], to[2], 7 / 9),
				lerp(from[3], to[3], 7 / 9),
			});
		};
	end,
	["Gradient8"] = function ()
		local from = highlights.get_property("bg", { "Normal" }, "#CDD6F4", "#1E1E2E");
		local to   = highlights.get_property("fg", { "Title" }, "#1e66f5", "#89b4fa");

		return {
			default = true,
			fg = highlights.rgb_to_hex({
				lerp(from[1], to[1], 8 / 9),
				lerp(from[2], to[2], 8 / 9),
				lerp(from[3], to[3], 8 / 9),
			});
		};
	end,
	["Gradient9"] = function ()
		local to   = highlights.get_property("fg", { "Title" }, "#CDD6F4", "#1E1E2E");

		return {
			default = true,
			fg = highlights.rgb_to_hex(to);
		};
	end,

	["Hyperlink"] = function ()
		return {
			default = true,
			link = "@markup.link.label.markdown_inline"
		}
	end,

	["Image"] = function ()
		return {
			default = true,
			link = "@markup.link.label.markdown_inline"
		}
	end,

	["Email"] = function ()
		return {
			default = true,
			link = "@markup.link.url.markdown_inline"
		}
	end,
	["Subscript"] = function ()
		return {
			default = true,
			link = "MarkviewPalette3Fg"
		};
	end,
	["Superscript"] = function ()
		return {
			default = true,
			link = "MarkviewPalette6Fg"
		};
	end,
	["ListItemMinus"] = function ()
		return {
			default = true,
			link = "MarkviewPalette2Fg"
		};
	end,
	["ListItemPlus"] = function ()
		return {
			default = true,
			link = "MarkviewPalette4Fg"
		};
	end,
	["ListItemStar"] = function ()
		return {
			default = true,
			link = "MarkviewPalette6Fg"
		};
	end,
	["TableHeader"] = function ()
		return {
			default = true,
			link = "@markup.heading.markdown"
		};
	end,

	["TableBorder"] = function ()
		return {
			default = true,
			link = "MarkviewPalette5Fg"
		};
	end,

	["TableAlignLeft"] = function ()
		return {
			default = true,
			link = "@markup.heading.markdown"
		}
	end,

	["TableAlignCenter"] = function ()
		return {
			default = true,
			link = "@markup.heading.markdown"
		}
	end,

	["TableAlignRight"] = function ()
		return {
			default = true,
			link = "@markup.heading.markdown"
		}
	end,
};

highlights.groups = highlights.dynamic;

--- Setup function.
---@param opt { [string]: config.hl }?
highlights.setup = function (opt)
	if type(opt) == "table" then
		highlights.groups = vim.tbl_extend("force", highlights.groups, opt);
	end

	highlights.create(highlights.groups);
end

return highlights;
--- vim:foldmethod=indent:
