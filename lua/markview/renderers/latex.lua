local latex = {};

local utils = require("markview.utils");
local languages = require("markview.languages");
local entities = require("markview.entities");

local devicons_loaded, devicons = pcall(require, "nvim-web-devicons");
local mini_loaded, MiniIcons = pcall(require, "mini.icons");

local function tbl_clamp(value, index)
	if vim.islist(value) == false then
		return value;
	elseif index > #value then
		return value[#value];
	end

	return value[index];
end

latex.ns = vim.api.nvim_create_namespace("markview/latex");

latex.custom_config = function (config, value)
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

latex.bracket = function (buffer, item)
	-- vim.print(item)
end

latex.render = function (buffer, content)
	for _, item in ipairs(content or {}) do
		-- pcall(latex[item.class:gsub("^latex_", "")], buffer, item);
		-- latex[item.class:gsub("^latex_", "")](buffer, item);
	end
end

return latex;
