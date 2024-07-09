local colors = {};

colors.clamp = function (val, min, max)
	return math.min(math.max(val, min), max)
end

colors.num_to_hex = function (num)
	if num == 0 then
		return "#000000";
	elseif num ~= nil then
		return string.format("#%x", num);
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
	local r = string.format("%x", tbl.r)
	local g = string.format("%x", tbl.g)
	local b = string.format("%x", tbl.b)

	local _o = "#";

	for _, color in ipairs({ r, g, b }) do
		if #color == 1 then
			_o = _o .. "0" .. color
		elseif #color == 2 then
			_o = _o .. color;
		end
	end

	return _o;
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
	local start, finish;

	if type(from) == "table" then
		start = from;
	elseif type(from) == "string" then
		start = colors.hex_to_rgb(from);
	end

	if type(to) == "table" then
		finish = to;
	elseif type(to) == "string" then
		finish = colors.hex_to_rgb(to);
	end

	local _r = (finish.r - start.r) / (steps - 1);
	local _g = (finish.g - start.g) / (steps - 1);
	local _b = (finish.b - start.b) / (steps - 1);

	local _t = {};

	for s = 0, (steps - 1) do
		local r = start.r + (s * _r);
		local g = start.r + (s * _g);
		local b = start.r + (s * _b);

		table.insert(_t, {
			group_name = (name_prefix or "") .. tostring(s + 1),
			value = {
				fg = colors.rgb_to_hex({ r = r, g = g, b = b })
			}
		})
	end

	table.insert(_t, {
		group_name = (name_prefix or "") .. tostring(steps),
		value = {
			fg = colors.rgb_to_hex(finish)
		}
	})

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
