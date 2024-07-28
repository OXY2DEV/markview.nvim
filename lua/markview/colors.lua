local colors = {};

colors.clamp = function (val, min, max)
	return math.min(math.max(val, min), max)
end

colors.lerp = function (x, y, t)
	return x + ((y - x) * t);
end

colors.num_to_hex = function (num)
	if num == 0 then
		return "#000000";
	elseif num ~= nil then
		return string.format("#%06X", num);
	end
end

colors.num_to_rgb = function (num)
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
	local hl = vim.api.nvim_get_hl(ns_id, { name = hl_group, link = false });

	if value == "fg" then
		return colors.num_to_hex(hl.fg)
	elseif value == "bg" then
		return colors.num_to_hex(hl.bg)
	elseif value == "sp" then
		return colors.num_to_hex(hl.sp)
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
	elseif type(color_1) == "string" then
		c_1 = colors.hex_to_rgb(color_1);
	end

	if type(color_2) == "table" then
		c_2 = color_2;
	elseif type(color_2) == "string" then
		c_2 = colors.hex_to_rgb(color_2);
	end

	if not c_1 or not c_2 then
		return;
	end

	local _r = colors.clamp((c_1.r * per_1) + (c_2.r * per_2), 1, 255);
	local _g = colors.clamp((c_1.g * per_1) + (c_2.g * per_2), 1, 255);
	local _b = colors.clamp((c_1.b * per_1) + (c_2.b * per_2), 1, 255);

	return colors.rgb_to_hex({ r = _r, g = _g, b = _b });
end

return colors;
