--- Completion source for `markview.nvim`.
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

--- Source name.
---@return string
function source:get_debug_name()
	return "markview-cmp";
end

--- Characters that trigger the completion.
---@return string[]
function source:get_trigger_characters()
	return { "[", "!" };
end

--- Completion items.
---@param self table
---@param params table
---@param callback function
function source:complete(params, callback)
	local spec = require("markview.spec");

	local before = params.context.cursor_before_line or "";
	local after = params.context.cursor_after_line or "";

	---@type lsp.CompletionItem[] Completion items.
	local output = {};

	local function comelete_block_quote ()
		---|fS

		local items = spec.get({ "markdown", "block_quotes" }, { fallback = {} });

		---@type string[] Sorted list of `callouts`.
		local keys = vim.tbl_keys(items);
		table.sort(keys);

		for _, key in pairs(keys) do
			if key == "enable" or key == "wrap" or key == "default" then
				goto continue;
			end

			---@type markview.config.markdown.block_quotes.opts
			local value = items[key] or {};

			table.insert(output, {
				label = string.format(
					"[!%s] -> %s",

					key,
					value.preview or items.default.preview
				),
				kind = require("cmp.types.lsp").CompletionItemKind.Text,

				word = key .. (string.match(after, "^%S*%]") and "" or "]"),

				filterText = key,
				sortText = key,

				documentation = {
					kind = "markdown",
					value = string.format(
						"```\n%s %s \n%s Block quote description.\n```",

						value.border or items.default.border,
						value.preview or items.default.preview,
						value.border or items.default.border
					);
				}
			});

			::continue::
		end

		---|fE
	end

	local function comelete_checkbox ()
		---|fS

		local items = spec.get({ "markdown_inline", "checkboxes" }, { fallback = {} });

		---@type string[] Sorted list of `callouts`.
		local keys = vim.tbl_keys(items);
		table.sort(keys);

		for _, key in pairs(keys) do
			if key == "enable" then
				goto continue;
			end

			---@type markview.config.markdown_inline.checkboxes.opts
			local value = items[key] or {};

			local text = key;

			if key == "checked" then
				text = "X";
			elseif key == "unchecked" then
				text = " ";
			end

			table.insert(output, {
				label = string.format(
					"[%s] -> %s %s",

					text,
					value.text or items.default.text,
					key
				),
				kind = require("cmp.types.lsp").CompletionItemKind.Text,

				word = key .. (string.match(after, "^.?%]") and "" or "]"),

				filterText = key,
				sortText = key,

				documentation = {
					kind = "markdown",
					value = string.format(
						"```\n  ◇ List item,\n  %s Checkbox with\n    some text.\n```",

						value.text or items.default.text
					);
				}
			});

			::continue::
		end

		---|fE
	end

	if before:match("^[ %>]+%s*%[%!%a*$") then
		comelete_block_quote()
	elseif before:match("^[ %>]*[%-%+%*] %[$") then
		comelete_checkbox();
	end

    -- callback must /always/ be called.
	return callback(output)
end

return source
