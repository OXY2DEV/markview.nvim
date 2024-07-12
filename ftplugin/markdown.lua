local markview = require("markview");
local ts_available, treesitter_parsers = pcall(require, "nvim-treesitter.parsers");
local function parser_installed(parser)
	return (ts_available and treesitter_parsers.has_parser(parser)) or
		(vim.treesitter.query.get(parser, "highlights"))
end

-- Check for requirements
if vim.fn.has("nvim-0.10") == 0 then
	vim.print("[ markview.nvim ] : Thie plugin is only available on version 0.10.0 and higher!");
	return;
elseif not parser_installed("markdown") then
	vim.print("[ markview.nvim ] : Treesitter parser for 'markdown' wasn't found!");
	return;
elseif not parser_installed("markdown_inline") then
	vim.print("[ markview.nvim ] : Treesitter parser for 'markdown_inline' wasn't found!");
	return;
end

if vim.islist(markview.configuration.buf_ignore) and vim.list_contains(markview.configuration.buf_ignore, vim.bo.buftype) then
	return
end

if vim.islist(markview.configuration.highlight_groups) then
	markview.add_hls(markview.configuration.highlight_groups)
end

local markview_augroup = vim.api.nvim_create_augroup("markview_buf_" .. vim.api.nvim_get_current_buf(), { clear = true });
local options = markview.configuration.options;

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	buffer = vim.api.nvim_get_current_buf(),
	group = markview_augroup,

	callback = function (event)
		local buffer = event.buf;
		local windows = markview.find_attached_wins(event.buf);

		if not vim.list_contains(markview.attached_buffers, buffer) then
			table.insert(markview.attached_buffers, buffer);
			markview.attached_windows = vim.list_extend(markview.attached_windows, windows)
		end

		if markview.state.enable == false then
			return;
		end

		if markview.state.buf_states[buffer] == false then
			return;
		end

		markview.state.buf_states[buffer] = true;

		if vim.tbl_isempty(markview.global_options) then
			markview.global_options = {
				conceallevel = vim.o.conceallevel,
				concealcursor = vim.o.concealcursor
			}
		end

		local parsed_content = markview.parser.init(buffer);

		markview.renderer.clear(buffer);
		markview.renderer.render(buffer, parsed_content, markview.configuration)

		for _, window in ipairs(windows) do
			vim.wo[window].conceallevel = type(options.on_enable) == "table" and options.on_enable.conceallevel or 2;
			vim.wo[window].concealcursor = type(options.on_enable) == "table" and options.on_enable.concealcursor or "n";

			markview.keymaps.init(buffer, window, parsed_content, markview.configuration);
		end
	end
});

-- ISSUE: Work in progress
vim.api.nvim_create_autocmd({ "ModeChanged", "TextChanged" }, {
	buffer = vim.api.nvim_get_current_buf(),
	group = markview_augroup,

	callback = function (event)
		local buffer = event.buf;
		local windows = markview.find_attached_wins(event.buf);

		local mode = vim.api.nvim_get_mode().mode;

		if markview.state.enable == false then
			return;
		end

		if markview.state.buf_states[buffer] == false then
			return;
		end

		if vim.islist(markview.configuration.modes) and vim.list_contains(markview.configuration.modes, mode) then
			local parsed_content = markview.parser.init(buffer);

			markview.renderer.clear(buffer);
			markview.renderer.render(buffer, parsed_content, markview.configuration);

			for _, window in ipairs(windows) do
				vim.wo[window].conceallevel = type(options.on_enable) == "table" and options.on_enable.conceallevel or 2;
				vim.wo[window].concealcursor = type(options.on_enable) == "table" and options.on_enable.concealcursor or "n";

				markview.keymaps.init(buffer, window, parsed_content, markview.configuration);
			end
		else
			for _, window in ipairs(windows) do
				vim.wo[window].conceallevel = type(options.on_disable) == "table" and options.on_disable.conceallevel or markview.global_options.conceallevel;
				vim.wo[window].concealcursor = type(options.on_disable) == "table" and options.on_disable.concealcursor or markview.global_options.concealcursor;
			end

			markview.renderer.clear(buffer);
		end
	end
});


