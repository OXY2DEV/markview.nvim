--- Completion source for `markview.nvim`.
local source = {};

--- Is this source available?
---@return boolean
function source:is_available()
	local fts = require("markview.spec").get({ "preview", "filetypes" }, { fallback = {}  });
	return vim.list_contains(fts, vim.bo.ft);
end

--- Source name.
---@return string
function source:get_debug_name()
	return "markview-cmp";
end

--- Characters that trigger the completion.
---@return string[]
function source:get_trigger_characters()
	return { "[", "!" }
end

--- Completion items.
---@param self table
---@param params table
---@param callback function
function source:complete(params, callback)
	local spec = require("markview.spec");

	local before = params.context.cursor_before_line or "";
	local after = params.context.cursor_after_line or "";

	local comp = {};

	if vim.bo.ft ~= "markdown" then
		goto not_md;
	end

	if before:match("^[ %>]+%s*%[%!%a*$") then
		---+${func, Callout completion}
		local items = spec.get({ "markdown", "block_quotes" }, { fallback = {} });

		for key, item in pairs(items) do
			if vim.list_contains({ "enable", "wrap", "default" }, key) == false then
				local label = "[!" .. key;
				local desc = {
					string.format("▌ %s",
						item.preview
					),
					"▌ Block quote description."
				};

				if after ~= "]" then
					label = label .. "]";
				end

				local result = label;
				label = label .. " » " .. item.preview;

				table.insert(comp, {
					label = label,
					word = result,

					detail = table.concat(desc, "\n")
				});
			end
		end
		---_
	elseif before:match("^[ %>]*[%-%+%*] %[$") then
		---+${func, Checkbox state completion}
		local items = spec.get({ "markdown_inline", "checkboxes" }, { fallback = {} });

		for key, item in pairs(items) do
			if vim.list_contains({ "enable", "checked", "unchecked" }, key) == false then
				local label = "[" .. key;
				local desc = {
					"◇ List item,",
					string.format("  %s Checkbox with",
						item.text
					),
					"    some text."
				};

				if after ~= "]" then
					label = label .. "] ";
				end

				local result = label;
				label = label .. " » " .. item.text;

				table.insert(comp, {
					label = label,
					word = result,

					detail = table.concat(desc, "\n")
				});
			end
		end
		---_
	else
		return;
	end

	::not_md::

	callback(comp);
end

return source
