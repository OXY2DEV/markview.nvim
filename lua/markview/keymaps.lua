local keymaps = {};

keymaps.views = {};
keymaps.on_bufs = {};

keymaps.createKeymap = function (buffer)
	vim.api.nvim_buf_set_keymap(buffer, "n", "gx", "", {
		desc = "gx patch for Markview.nvim",
		callback = function ()
			local buf_links = keymaps.views[buffer];
			local cursor = vim.api.nvim_win_get_cursor(0);

			for _, link in ipairs(buf_links) do
				if link.row_start + 1 ~= cursor[1] then
					goto continue;
				end

				if cursor[2] < link.col_start or cursor[2] > link.col_end then
					goto continue;
				end

				local cmd, err = vim.ui.open(vim.fn.fnamemodify(link.address, ":~"))

				if err then
					vim.print("[ Markview.nvim ] : Failed to open: " .. link.address)
					break;
				end

				if cmd then
					cmd:wait();
					break;
				end


			    ::continue::
			end

			local def_cmd, def_err = vim.ui.open(vim.fn.expand("<cfile>"))

			if def_err then
				vim.print("[ Markview.nvim ] : Failed to open: " .. vim.fn.expand("<cfile>"))
			end

			if def_cmd then
				def_cmd:wait();
			end
		end,
	})
end

keymaps.init = function (buffer, parsed_content, config_table)
	if parsed_content ~= nil then
		keymaps.views[buffer] = {};
	end

	for _, content in ipairs(parsed_content) do
		if content.type == "link" then
			table.insert(keymaps.views[buffer], content);
		elseif content.type == "image" then
			table.insert(keymaps.views[buffer], content);
		end
	end

	if not vim.list_contains(keymaps.on_bufs, buffer) then
		keymaps.createKeymap(buffer);

		table.insert(keymaps.on_bufs, buffer)
	end
end

return keymaps;
