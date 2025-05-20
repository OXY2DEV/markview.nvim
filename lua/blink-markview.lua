local source = {};

--- Is this source available?
---@return boolean
function source:is_available()
	if not package.loaded["markview"] then
		--- Plugin not available.
		return false;
	end

	local fts = require("markview.spec").get({ "preview", "filetypes" }, {
		fallback = {},
		ignore_enable = true
	});
	return vim.list_contains(fts, vim.bo.ft);
end

--- Characters that trigger the completion.
---@return string[]
function source:get_trigger_characters()
	return { "[", "!" };
end


--- Completion items.
---@param self table
---@param ctx table
---@param callback function
function source:get_completions(ctx, callback)
	if not package.loaded["markview.spec"] then
		--- Plugin not available.
		return;
	end

	local spec = package.loaded["markview.spec"];

	local before = string.sub(ctx.line, 0, ctx.bounds.start_col);
	local after = string.sub(ctx.line, ctx.bounds.start_col + 1, #ctx.line);

	local comp = {};

	if before:match("^[ %>]+%s*%[%!%a*$") then
		local items = spec.get({ "markdown", "block_quotes" }, { fallback = {} });

		for key, item in pairs(items) do
			if vim.list_contains({ "enable", "wrap", "default" }, key) == false then
				local label = "[!" .. key .. "]" .. " » " .. (item.preview or "");
				local result = key;

				if string.match(after, "^%]") == nil then
					result = result .. "]";
				end

				table.insert(comp, {
					label = label,
					filterText = key,
					sortText = key,

					textEdit = {
						newText = result,

						range = {
							start = { line = ctx.bounds.line_number - 1, character = ctx.bounds.start_col - 1 },
							["end"] = { line = ctx.bounds.line_number - 1, character = ctx.bounds.start_col },
						}
					},

					documentation = {
						kind = "plaintext",
						value = string.format("▌ %s\n▌ Block quote description.", item.preview or "");
					}
				});
			end
		end
	elseif before:match("^[ %>]*[%-%+%*] %[$") then
		local items = spec.get({ "markdown_inline", "checkboxes" }, { fallback = {} });

		for key, item in pairs(items) do
			if vim.list_contains({ "enable", "checked", "unchecked" }, key) == false then
				local label = "[" .. key .. "]" .. " » " .. (item.text or "") .. " ";
				local result = key;

				if string.match(after, "^%]") == nil then
					result = result .. "]";
				end

				table.insert(comp, {
					label = label,
					filterText = key,
					sortText = key,

					textEdit = {
						newText = result,

						range = {
							start = { line = ctx.bounds.line_number - 1, character = ctx.bounds.start_col - 1 },
							["end"] = { line = ctx.bounds.line_number - 1, character = ctx.bounds.start_col },
						}
					},

					documentation = {
						kind = "plaintext",
						value = string.format("◇ List item,\n  %s Checkbox with\n    some text.", item.text or "");
					}
				});
			end
		end
	end

	callback({
		items = comp
	});
end

----------------------------------------------------------------------

--- Create new instance of blink source.
---@return table
source.new = function ()
	return setmetatable({}, { __index = source });
end

return source;
