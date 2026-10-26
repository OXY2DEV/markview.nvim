--[[
	Minimal init for smoke testing this plugin from a checkout(no `lazy.nvim`),

	```sh
	nvim -u test/minimal_init.lua test/wrap_tail_indent.md
	```

	It only enables the plugin, the wrap related options & the preview/hybrid
	mode settings the wrapping issues are reported with.
]]

local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h");

vim.opt.runtimepath:prepend(root);

vim.opt.number = true;
vim.opt.termguicolors = true;
vim.opt.laststatus = 3;

-- Text wrapping, as reported.
vim.opt.wrap = true;
vim.opt.linebreak = true;
vim.opt.breakindent = true;

require("markview").setup({
	preview = {
		hybrid_modes = { "n", "no", "c" },
		linewise_hybrid_mode = true,
	},
});
