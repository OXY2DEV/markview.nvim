local markview = {};
local parser = require("markview/parser");
local renderer = require("markview/renderer");

markview.setup = function ()
	vim.api.nvim_create_autocmd({ "ModeChanged", "BufEnter" }, {
		pattern = "*",
		callback = function (event)
			if vim.bo[event.buf].filetype ~= "markdown" then
				return;
			end

			if vim.api.nvim_get_mode().mode == "n" then
				parser.init(event.buf);
				renderer.render(event.buf);
			else
				renderer.clear(event.buf);
			end
		end
	})
end

return markview;
