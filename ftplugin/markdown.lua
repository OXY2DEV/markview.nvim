local markview = require("markview");

-- Check for requirements
if vim.fn.has("nvim-0.10") == 0 then
	vim.print("[ markview.nvim ] : Thie plugin is only available on version 0.10.0 and higher!");
	return;
elseif not vim.treesitter.query.get("markdown", "highlights") then
	vim.print("[ markview.nvim ] : Treesitter parser for 'markdown' wasn't found!");
	return;
elseif not vim.treesitter.query.get("markdown_inline", "highlights") then
	vim.print("[ markview.nvim ] : Treesitter parser for 'markdown_inline' wasn't found!");
	return;
end

if vim.islist(markview.configuration.buf_ignore) and vim.list_contains(markview.configuration.buf_ignore, vim.bo.buftype) then
	return
end

local markview_augroup = vim.api.nvim_create_augroup("markview_buf_" .. vim.api.nvim_get_current_buf(), { clear = true });

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	buffer = vim.api.nvim_get_current_buf(),
	group = markview_augroup,

	callback = function (event)
		local buffer = event.buf;

		local parsed_content = markview.parser.init(buffer);

		markview.global_options = {
			conceallevel = vim.o.conceallevel,
			concealcursor = vim.o.concealcursor
		}

		vim.wo.conceallevel = 2;
		vim.wo.concealcursor = "n";

		markview.renderer.clear(buffer);
		markview.renderer.render(buffer, parsed_content, markview.configuration)
	end
});

vim.api.nvim_create_autocmd({ "ModeChanged" }, {
	buffer = vim.api.nvim_get_current_buf(),
	group = markview_augroup,

	callback = function (event)
		local buffer = event.buf;
		local mode = vim.api.nvim_get_mode().mode;

		if vim.islist(markview.configuration.modes) and vim.list_contains(markview.configuration.modes, mode) then
			local parsed_content = markview.parser.init(buffer);

			vim.wo.conceallevel = 2;
			vim.wo.concealcursor = "n";

			markview.renderer.clear(buffer);
			markview.renderer.render(buffer, parsed_content, markview.configuration)
		else
			if markview.configuration.restore_conceallevel == true then
				vim.wo.conceallevel = markview.global_options.conceallevel;
			else
				vim.wo.conceallevel = 0;
			end

			if markview.configuration.restore_concealcursor == true then
				vim.wo.concealcursor = markview.global_options.concealcursor;
			end

			markview.renderer.clear(buffer);
		end
	end
});


