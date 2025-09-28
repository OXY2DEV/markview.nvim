--[[
`markview.nvim` source for `blink.cmp`.

Usage,

```lua
{
	"saghen/blink.cmp",
	opts = {
		sources = {
			default = { "foo" },
			providers = {
				foo = {
					name = "Markview",
					module = "blink-markview",
				}
			}
		}
	}
}
```
]]
local source = {};

--- Is this source available?
---@return boolean
function source:enabled()
	if not package.loaded["markview"] then
		-- Plugin *not* loaded(for some reason).
		return false;
	end

	---@type string[] Supported `filetypes`.
	local filetypes = require("markview.spec").get({ "preview", "filetypes" }, {
		fallback = {},
		ignore_enable = true
	});

	return vim.list_contains(filetypes, vim.bo.ft);
end

--- Characters that trigger the completion.
---@return string[]
function source:get_trigger_characters()
	--[[
		`[` => Checkbox completion.
		`!` => Block quote completion.
	]]
	return { "[", "!" };
end


--- Completion items.
---@param self table
---@param ctx table
---@param callback function
function source:get_completions(ctx, callback)
	if not package.loaded["markview.spec"] then
		return;
	end

	local spec = package.loaded["markview.spec"];

	local before = string.sub(ctx.line, 1, ctx.bounds.start_col - 1);
	local after = string.sub(ctx.line, ctx.bounds.start_col);

	---@type lsp.CompletionItem[] Completion items.
	local output = {};

	local function comelete_block_quote ()
		---|fS

		local items = spec.get({ "markdown", "block_quotes" }, { fallback = {} });

		---@type string[] Sorted list of `callouts`.
		local keys = vim.tbl_keys(items);
		table.sort(keys);

		---@type integer Characters after the `cursor` that will be edited.
		local offset_a = vim.fn.strchars(
			string.match(after, "%w*%]") or string.match(after, "[A-Z]*")
		);

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
				kind = require("blink.cmp.types").CompletionItemKind.Text,

				filterText = key,
				sortText = key,

				textEdit = {
					newText = key .. "]",

					range = {
						start = {
							line = ctx.bounds.line_number - 1,
							character = ctx.bounds.start_col - 1
						},
						["end"] = {
							line = ctx.bounds.line_number - 1,
							character = ctx.bounds.start_col + (offset_a - 1)
						},
					}
				},

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

		---@type integer Characters after the `cursor` that will be edited.
		local offset_a = vim.fn.strchars(
			string.match(after, "%w%]") or string.match(after, "%S?")
		);

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
				kind = require("blink.cmp.types").CompletionItemKind.Text,

				filterText = key,
				sortText = key,

				textEdit = {
					newText = text .. "]",

					range = {
						start = {
							line = ctx.bounds.line_number - 1,
							character = ctx.bounds.start_col - 1
						},
						["end"] = {
							line = ctx.bounds.line_number - 1,
							character = ctx.bounds.start_col + (offset_a - 1)
						},
					}
				},

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

	if before:match("^[ %>]+%[%!") then
		comelete_block_quote();
	elseif before:match("^[ %>]*[%-%+%*] %[$") then
		comelete_checkbox();
	end

	callback({
		items = output
	});
end

----------------------------------------------------------------------

--- Create new instance of blink source.
---@return table
source.new = function ()
	return setmetatable({}, { __index = source });
end

return source;
