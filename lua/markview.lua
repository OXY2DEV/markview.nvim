local markview = {};
local parser = require("markview/parser");
local renderer = require("markview/renderer");

---@type number[] list of windows where the options have been set
markview.options_set = {};

--- Setup function for markview.nvim
---
---@param user_config markview_config?
markview.setup = function (user_config)
	---@type markview_config
	renderer.config = vim.tbl_deep_extend("keep", user_config or {}, renderer.config);

	local version = vim.version();
	local ts_available, treesitter_parsers = pcall(require, "nvim-treesitter.parsers");

	-- Fix: version checking issue fixed
	if type(version) ~= "table" then
		vim.print("[markview.nvim] : vim.version() returned unexpected value")
		return;
	elseif vim.version.ge({ version.major, version.minor, version.patch }, { 0, 10, 0 }) == false then
		vim.print("[markview.nvim] : Neovim version 0.10.0 or higher required")
		return;
	elseif ts_available == false then
		vim.print("[markview.nvim] : `nvim-treesitter` isn't available")
		return;
	elseif treesitter_parsers.has_parser("markdown") == false then
		vim.print("[markview.nvim] : `markdown` parser isn't available")
		return;
	elseif treesitter_parsers.has_parser("markdown_inline") == false then
		vim.print("[markview.nvim] : `markdown_inline` parser isn't available")
		return;
	end

	if renderer.config.highlight_groups ~= false then
		renderer.add_hls(renderer.config.highlight_groups);
	end

	-- When a markdown file is opened in a window run the parser on it
	-- and render things
	vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		pattern = "*.md",
		callback = function (event)
			local windows = vim.api.nvim_list_wins();
			renderer.clear(event.buf);

			-- Check for windows that have this buffer and set the necessary options in them
			for _, window in ipairs(windows) do
				local buf = vim.api.nvim_win_get_buf(window);

				-- Do not set options if the options are already set
				if vim.list_contains(markview.options_set, window) == false and buf == event.buf then
					vim.wo[window].conceallevel = 2;
					vim.wo[window].concealcursor = "nc";

					table.insert(markview.options_set, window);
				end
			end

			vim.cmd.syntax("match markdownCode /`[^`]\\+`/ conceal")
			parser.init(event.buf);
			renderer.render(event.buf);
		end
	})

	vim.api.nvim_create_autocmd({ "ModeChanged" }, {
		callback = function (event)
			local mode = vim.api.nvim_get_mode().mode;

			if vim.bo.filetype ~= "markdown" then
				return;
			end

			if vim.tbl_contains(renderer.config.modes or {}, mode) then
 				vim.cmd.syntax("match markdownCode /`[^`]\\+`/ conceal")
 				vim.wo.conceallevel = 2;
 				vim.wo.concealcursor = "nc";

				renderer.clear(event.buf)

 				parser.init(event.buf);
 				renderer.render(event.buf);
			else
				vim.cmd("syntax clear markdownCode")
				vim.wo.conceallevel = 0;
				vim.wo.concealcursor = "nc";

				renderer.clear(event.buf)
			end
		end
	})

end

return markview;
