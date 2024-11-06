local yaml = {};

local spec = require("markview.spec");
local utils = require("markview.utils");

yaml.cache = {};

local get_config = function (...)
	local _c = spec.get("yaml", ...);

	if not _c or _c.enable == false then
		return;
	end

	return _c;
end

yaml.__ns = {
	__call = function (self, key)
		return self[key] or self.default;
	end
}

yaml.ns = {
	default = vim.api.nvim_create_namespace("markview/yaml"),
};
setmetatable(yaml.ns, yaml.__ns)

yaml.set_ns = function ()
	local ns_pref = get_config("use_seperate_ns");
	if not ns_pref then ns_pref = true; end

	local available = vim.api.nvim_get_namespaces();
	local ns_list = {
		["properties"] = "markview/yaml/properties",
	};

	if ns_pref == true then
		for ns, name in pairs(ns_list) do
			if vim.list_contains(available, ns) == false then
				yaml.ns[ns] = vim.api.nvim_create_namespace(name);
			end
		end
	end
end

yaml.property = function (buffer, item)
	local config = get_config("properties");
	local range = item.range;

	if not config then
		return;
	elseif not config.text or not config.text[item.type] then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, yaml.ns("properties"), range.row_start, range.col_start, {
		virt_text_pos = "inline",
		virt_text = {
			{
				config.text[item.type],
				utils.set_hl(config.hl and config.hl[item.type] or nil)
			}
		}
	});

	for l = range.row_start + 1, range.row_end do
		vim.api.nvim_buf_set_extmark(buffer, yaml.ns("properties"), l, math.min(range.col_start, #item.text[(l - range.row_start) + 1]), {
			virt_text_pos = "inline",
			virt_text = {
				{ string.rep(" ", vim.fn.strdisplaywidth(config.text[item.type])) }
			}
		});
	end
end

yaml.render = function (buffer, content)
	yaml.cache = {};

	for _, item in ipairs(content or {}) do
		pcall(yaml[item.class:gsub("^yaml_", "")], buffer, item);
		-- yaml[item.class:gsub("^yaml_", "")](buffer, item);
	end
end

yaml.clear = function (buffer, ignore_ns, from, to)
	for name, ns in pairs(yaml.ns) do
		if ignore_ns and vim.list_contains(ignore_ns, name) == false then
			vim.api.nvim_buf_clear_namespace(buffer, ns, from or 0, to or -1);
		end
	end
end

return yaml;
