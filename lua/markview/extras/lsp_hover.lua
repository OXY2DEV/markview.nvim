--- Custom LSP hover function
--- using `markview.nvim`.
local hover = {};
local markdown = require("markview.renderers.markdown");

hover.buf = nil;
hover.win = nil;

hover.hover = function ()
	if
		hover.buf and
		vim.api.nvim_buf_is_valid(hover.buf) == false
	then
		hover.buf = nil;
	end

	if
		hover.win and
		vim.api.nvim_win_is_valid(hover.win)
	then
		vim.api.nvim_set_current_win(hover.win);
		return;
	else
		hover.win = nil;
	end

	local params = vim.lsp.util.make_position_params();

	vim.lsp.buf_request(
		0,
		"textDocument/hover",
		params,
		function(err, result, _, _)
			if err or not result then
				return;
			end

			local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents);
			local width = 0;

			for _, line in ipairs(lines) do
				local _l = markdown.output(line);

				if vim.fn.strdisplaywidth(_l) > width then
					width = vim.fn.strdisplaywidth(_l);
				end
			end

			hover.buf, hover.win = vim.lsp.util.open_floating_preview(
				lines,
				"markdown",
				{
					wrap = false,
					width = width + 6,
					max_width = math.floor(vim.o.columns * 0.8)
				}
			);


			vim.wo[hover.win].signcolumn = "no";
			vim.wo[hover.win].statuscolumn = "";
			vim.wo[hover.win].number = false;
			vim.wo[hover.win].relativenumber = false;
			vim.wo[hover.win].numberwidth = 1;

			vim.api.nvim_win_set_config(hover.win, {
				border = "rounded"
			})

			vim.uv.new_timer():start(0, 0, vim.schedule_wrap(
				function ()
					require("markview").attach({ buf = hover.buf })
				end
			));
		end
	);
end

return hover;
