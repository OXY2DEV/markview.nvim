local health = {};

local ts_available, treesitter_parsers = pcall(require, "nvim-treesitter.parsers");

local devicons_loaded = pcall(require, "nvim-web-devicons");
local mini_loaded = pcall(require, "mini.icons");

--- Checks if a parser is available or not
---@param parser_name string
---@return boolean
local function parser_installed(parser_name)
	return (ts_available and treesitter_parsers.has_parser(parser_name)) or pcall(vim.treesitter.query.get, parser_name, "highlights")
end

health.check = function ()
	local ver = vim.version();

	vim.health.start("Checking essentials:")

	if vim.fn.has("nvim-0.10.0") == 1 then
		vim.health.ok("Neovim version: " .. string.format("`%d.%d.%d`", ver.major, ver.minor, ver.patch));
	else
		vim.health.error("Unsupported neovim version. Minimum requirement `0.10.1`, found: " .. string.format("`%d.%d.%d`", ver.major, ver.minor, ver.patch));
	end

	if ts_available then
		vim.health.ok("`nvim-treesitter/nvim-treesitter` found!")
	else
		vim.health.warn("`nvim-treesitter/nvim-treesitter` wasn't found! Ignore this if you manually installed the parsers!")
	end

	vim.health.start("Checking parsers:")

	for _, parser in ipairs({ "markdown", "markdown_inline", "html", "latex" }) do
		if parser_installed(parser) then
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
