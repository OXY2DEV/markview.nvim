local health = {};

local utils = require("markview.utils")

health.check = function()
	local ver = vim.version()

	local devicons_loaded = pcall(require, "nvim-web-devicons")
	local mini_loaded = pcall(require, "mini.icons")

	vim.health.start("Checking essentials:")

	if vim.fn.has("nvim-0.10.1") == 1 then
		vim.health.ok("Neovim version: " .. string.format("`%d.%d.%d`", ver.major, ver.minor, ver.patch));
	elseif ver.major == 0 and ver.minor == 10 and ver.patch == 0 then
		vim.health.warn("Neovim version(may experience errors): " .. string.format("`%d.%d.%d`", ver.major, ver.minor, ver.patch));
	else
		vim.health.error("Unsupported neovim version. Minimum requirement `0.10.1`, found: " .. string.format("`%d.%d.%d`", ver.major, ver.minor, ver.patch));
	end

	local ts_available, _ = pcall(require, "nvim-treesitter.parsers")

	if ts_available then
		vim.health.ok("`nvim-treesitter/nvim-treesitter` found!")
	else
		vim.health.warn("`nvim-treesitter/nvim-treesitter` wasn't found! Ignore this if you manually installed the parsers!")
	end

	vim.health.start("Checking parsers:")

	for _, parser in ipairs({ "markdown", "markdown_inline", "html", "latex" }) do
		if utils.parser_installed(parser) then
			vim.health.ok("`" .. parser .. "` " .. "was found!");
		else
			vim.health.warn("`" .. parser .. "` " .. "wasn't found.");
		end
	end

	vim.health.start("Checking icon providers:");

	if devicons_loaded then
		vim.health.ok("`nvim-tree/nvim-web-devicons` found!");
	elseif mini_loaded then
		vim.health.ok("`echasnovski/mini.icons` found!");
	else
		vim.health.warn("External icon providers weren't found! Using internal icon providers instead.")
	end
end

return health;
