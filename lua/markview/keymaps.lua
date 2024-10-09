local keymaps = {};

---@type table[] A list `parsed contents` containing different types of links
keymaps.views = {};
keymaps.on_bufs = {};

keymaps.create_command = function (buffer)
	vim.api.nvim_buf_create_user_command(buffer, "MarkOpen", function ()
		local buf_links = keymaps.views[buffer] or {};
		local cursor = vim.api.nvim_win_get_cursor(0);

		--- Iterate over all the available links
		for _, link in ipairs(buf_links) do
			--- Cursor isn't on the line of the link
			if link.row_start + 1 ~= cursor[1] then
				goto continue;
			end

			--- Cursor isn't on the column range of the link
			if cursor[2] < link.col_start or cursor[2] > link.col_end then
				goto continue;
			end

			--- Modify the address and open it in `vim.ui.open()`
			local cmd, err = vim.ui.open(vim.fn.fnamemodify(link.address, ":~"))

			if err then
				vim.notify("[ Markview.nvim ] : Failed to open: " .. link.address, vim.diagnostic.severity.WARN)
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
			vim.notify("[ Markview.nvim ] : Failed to open: " .. vim.fn.expand("<cfile>"), vim.diagnostic.severity.WARN)
		end

		if def_cmd then
			def_cmd:wait();
		end
	end, {})
end

keymaps.createKeymap = function (buffer)
	vim.api.nvim_buf_set_keymap(buffer, "n", "gx", "<CMD>MarkOpen<CR>", {
		desc = "Opens the link under cursor"
	})
end

--- Initializes the keymaps
---@param buffer integer
---@param parsed_content table
---@param config_table table?
keymaps.init = function (buffer, parsed_content, config_table)
	if parsed_content ~= nil then
		keymaps.views[buffer] = {};
	end

	for _, content in ipairs(parsed_content --[[@as table]]) do
		if content.type:match("^link_") then
			table.insert(keymaps.views[buffer], content);
		end
	end

	if not vim.list_contains(keymaps.on_bufs, buffer) then
		keymaps.createKeymap(buffer);
		keymaps.create_command(buffer);

		table.insert(keymaps.on_bufs, buffer)
	end
end

return keymaps;
