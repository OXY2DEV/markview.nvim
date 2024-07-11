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

		vim.wo.conceallevel = 2;
		vim.wo.concealcursor = "n";

		markview.renderer.clear(buffer);
		markview.renderer.render(buffer, parsed_content, markview.configuration)

		for _, window in ipairs(windows) do
			markview.keymaps.init(buffer, window, parsed_content, markview.configuration);
		end
        markview.configuration.on_enable()
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
				vim.wo[window].conceallevel = 2;
				vim.wo[window].concealcursor = "n";

				markview.keymaps.init(buffer, window, parsed_content, markview.configuration);
			end
            markview.configuration.on_enable()
		else
			for _, window in ipairs(windows) do
				if markview.configuration.restore_conceallevel == true then
					vim.wo[window].conceallevel = markview.global_options.conceallevel;
				else
					vim.wo[window].conceallevel = 0;
				end

				if markview.configuration.restore_concealcursor == true then
					vim.wo[window].concealcursor = markview.global_options.concealcursor;
				end
			end

			markview.renderer.clear(buffer);
            markview.configuration.on_disable()
		end
	end
});


