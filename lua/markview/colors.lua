local colors = {};

colors.clamp = function (val, min, max)
	return math.min(math.max(val, min), max)
end

colors.lerp = function (x, y, t)
	return x + ((y - x) * t);
end

colors.name_to_hex = function (name)
	---+ ##code##
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
	---_

	return lookup[string.lower(name)] or lookup_nvim[string.lower(name)];
end

colors.name_to_rgb = function (name)
	local hex = colors.name_to_hex(name);

	if not hex then
		return;
	end

	return colors.hex_to_rgb(hex);
end

colors.num_to_hex = function (num)
	if not num then
		return;
	end

	if num == 0 then
		return "#000000";
	elseif num ~= nil then
		return string.format("#%06X", num);
	end
end

colors.num_to_rgb = function (num)
	if not num then
		return;
	end

	local hex = string.format("%x", num);

	return {
		r = tonumber(hex:sub(1, 2), 16),
		g = tonumber(hex:sub(3, 4), 16),
		b = tonumber(hex:sub(5, 6), 16),
	}
end

colors.hex_to_rgb = function (str)
	str = str:gsub("#", "");

	if #str == 3 then
		return {
			r = tonumber(str:sub(1, 1), 16),
			g = tonumber(str:sub(2, 2), 16),
			b = tonumber(str:sub(3, 3), 16),
		}
	elseif #str == 6 then
		return {
			r = tonumber(str:sub(1, 2), 16),
			g = tonumber(str:sub(3, 4), 16),
			b = tonumber(str:sub(5, 6), 16),
		}
	end
end

colors.rgb_to_hex = function (tbl)
	return string.format("#%02X%02X%02X", tbl.r, tbl.g, tbl.b);
end

colors.get_hl_value = function (ns_id, hl_group, value)
	if vim.fn.hlexists(hl_group) == 0 then
		return;
	end

	local hl = vim.api.nvim_get_hl(ns_id, { name = hl_group, link = false, create = false });

	if value == "fg" then
		if type(hl.fg) == "string" and hl.fg:match("^[#]?(%x+)$") then
			return colors.name_to_hex(hl.fg)
		else
			return colors.num_to_hex(hl.fg)
		end
	elseif value == "bg" then
		if type(hl.bg) == "string" and hl.bg:match("^[#]?(%x+)$") then
			return colors.name_to_hex(hl.bg)
		else
			return colors.num_to_hex(hl.bg)
		end
	elseif value == "sp" then
		if type(hl.sp) == "string" and hl.sp:match("^[#]?(%x+)$") then
			return colors.name_to_hex(hl.sp)
		else
			return colors.num_to_hex(hl.sp)
		end
	else
		return hl[value];
	end
end

colors.create_gradient = function (name_prefix, from, to, steps, mode)
	local start, stop;

	if type(from) == "table" then
		start = from;
	elseif type(from) == "string" then
		start = colors.hex_to_rgb(from);
	end

	if type(to) == "table" then
		stop = to;
	elseif type(to) == "string" then
		stop = colors.hex_to_rgb(to);
	end

	local _t = {};

	for s = 0, (steps - 1) do
		local r = colors.lerp(start.r, stop.r, s / (steps - 1));
		local g = colors.lerp(start.g, stop.g, s / (steps - 1));
		local b = colors.lerp(start.b, stop.b, s / (steps - 1));

		local _o = {};

		if mode == "fg" then
			_o.fg = colors.rgb_to_hex({ r = r, g = g, b = b });
		elseif mode == "bg" then
			_o.bg = colors.rgb_to_hex({ r = r, g = g, b = b });
		elseif mode == "both" then
			_o.bg = colors.rgb_to_hex({ r = r, g = g, b = b });
			_o.fg = colors.rgb_to_hex({ r = r, g = g, b = b });
		end

		table.insert(_t, {
			group_name = (name_prefix or "") .. tostring(s + 1),
			value = _o
		})
	end

	return _t;
end

colors.mix = function (color_1, color_2, per_1, per_2)
	local c_1, c_2;

	if type(color_1) == "table" then
		c_1 = color_1;
	elseif type(color_1) == "string" and color_1:match("^[#]?(%x+)$") then
		c_1 = colors.hex_to_rgb(color_1);
	elseif type(color_1) == "string" then
		c_1 = colors.name_to_rgb(color_1);
	end

	if type(color_2) == "table" then
		c_2 = color_2;
	elseif type(color_2) == "string" and color_2:match("^[#]?(%x+)$") then
		c_2 = colors.hex_to_rgb(color_2);
	elseif type(color_2) == "string" then
		c_1 = colors.name_to_rgb(color_2);
	end

	if not c_1 or not c_2 then
		return;
	end

	local _r = colors.clamp((c_1.r * per_1) + (c_2.r * per_2), 1, 255);
	local _g = colors.clamp((c_1.g * per_1) + (c_2.g * per_2), 1, 255);
	local _b = colors.clamp((c_1.b * per_1) + (c_2.b * per_2), 1, 255);

	return colors.rgb_to_hex({ r = _r, g = _g, b = _b });
end

colors.get_brightness = function (color)
	if type(color) == "string" and color:match("^[#]?(%x+)$") then
		color = colors.hex_to_rgb(color);
	elseif type(color_1) == "string" then
		color = colors.name_to_rgb(color);
	elseif type(color) == "number" then
		color = colors.num_to_rgb(color);
	end

	for key, value in pairs(color) do
		if value > 1 then
			color[key] = value / 255;
		end
	end

	return (color.r * 0.2126) + (color.g * 0.7152) + (color.b * 0.0722);
end

colors.brightest = function (col_list, debug)
	if not col_list then
		return;
	elseif not vim.islist(col_list) then
		local tmp = {};

		for _, item in pairs(col_list) do
			table.insert(tmp,item);
		end

		col_list = tmp;
	end

	local _c = {};

	for _, col in ipairs(col_list) do
		if type(col) == "string" and col:match("^[#]?(%x+)$") then
			table.insert(_c, colors.hex_to_rgb(col));
		elseif type(col) == "string" then
			table.insert(_c, colors.name_to_rgb(col));
		elseif type(col) == "number" then
			table.insert(_c, colors.num_to_rgb(col));
		elseif type(col) == "table" then
			table.insert(_c, col);
		end
	end


	local _b = 0;
	local brightest;

	for _, c in ipairs(_c) do
		local brightness = colors.get_brightness(c) or 0;

		if brightness >= _b then
			_b = brightness;
			brightest = c;
		end
	end

	-- if debug then
	-- 	vim.print(colors.rgb_to_hex(brightest) == nil);
	-- end

	return colors.rgb_to_hex(brightest);
end

colors.get = function (col_list)
	if not col_list then
		return;
	elseif not vim.islist(col_list) then
		local tmp = {};

		for _, item in pairs(col_list) do
			table.insert(tmp,item);
		end

		col_list = tmp;
	end

	return col_list[1];
end

colors.bg = function ()
	return colors.get({
		colors.get_hl_value(0, "Normal", "bg"),
		colors.get_hl_value(0, "EndOfBuffer", "bg"),
		colors.get_hl_value(0, "EndOfBuffer", "fg"),
	})
end

return colors;
