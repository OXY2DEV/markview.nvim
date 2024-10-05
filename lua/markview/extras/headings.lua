local headings = {};

--- Gets the heading under the cursor
---@return boolean
---@return string?
---@return table?
headings.get = function ()
	local node = vim.treesitter.get_node();

	while node:parent() do
		if vim.list_contains({
			"atx_heading",
			"setext_heading"
		}, node:type()) then
			return true, node:type(), node;
		end

		node = node:parent();
	end

	return false, nil, nil;
end

---@class heading_control
---@field increase fun(node: table): nil
---@field decrease fun(node: table): nil
headings.atx = {
	increase = function (node)
		local text = vim.treesitter.get_node_text(node, vim.api.nvim_get_current_buf());
		local markers = text:match("^([#]+)");
		local range = { node:range() }

		if #markers >= 6 then
			return;
		end

		text = text:gsub("^" .. markers, markers .. "#");

		vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), range[1], range[3], false, {
			text
		});
	end,
	decrease = function (node)
		local text = vim.treesitter.get_node_text(node, vim.api.nvim_get_current_buf());
		local markers = text:match("^([#]+)");
		local range = { node:range() }

		if #markers == 1 then
			return;
		end

		text = text:gsub("^" .. markers, vim.fn.strcharpart(markers, 0, vim.fn.strchars(markers) - 1));

		vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), range[1], range[3], false, {
			text
		});
	end,
};

---@type heading_control
headings.setext = {
	increase = function (node)
		local marker = node:named_child(1);

		if not marker then
			return;
		end

		local text = vim.treesitter.get_node_text(marker, vim.api.nvim_get_current_buf());
		local range = { marker:range() };

		if text:match("^([-]+)$") then
			return;
		end

		text = text:gsub("%=","%-");

		vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), range[1], range[3] + 1, false, {
			text
		});
	end,
	decrease = function (node)
		local marker = node:named_child(1);

		if not marker then
			return;
		end

		local text = vim.treesitter.get_node_text(marker, vim.api.nvim_get_current_buf());
		local range = { marker:range() };

		if text:match("^([=]+)$") then
			return;
		end

		text = text:gsub("%-","%=");

		vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), range[1], range[3] + 1, false, {
			text
		});
	end
}

--- Increases heading level
headings.increase = function ()
	local isHeading, nodeType, node = headings.get();

	if isHeading == false then
		return;
	end

	if nodeType == "atx_heading" then
		headings.atx.increase(node --[[ @as table ]]);
	else
		headings.setext.increase(node --[[ @as table ]]);
	end
end

--- Decreases heading level
headings.decrease = function ()
	local isHeading, nodeType, node = headings.get();

	if isHeading == false then
		return;
	end

	if nodeType == "atx_heading" then
		headings.atx.decrease(node --[[ @as table ]]);
	else
		headings.setext.decrease(node --[[ @as table ]]);
	end
end

headings.setup = function ()
	vim.api.nvim_create_user_command("HeadingIncrease", function ()
		headings.increase();
	end, {
		desc = "Increases heading level"
	});

	vim.api.nvim_create_user_command("HeadingDecrease", function ()
		headings.decrease()
	end, {
		desc = "Decreases heading level"
	});
end

return headings;
