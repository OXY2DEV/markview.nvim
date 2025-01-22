# 🔥 Advanced usage

## 📂 Header folding

1. Create a new file `~/.config/nvim/queries/markdown/folds.scm`.

2. Add these lines to that file,

```query
; Folds a section of the document
; that starts with a heading.
((section
    (atx_heading)) @fold
    (#trim! @fold))

; (#trim!) is used to prevent empty
; lines at the end of the section
; from being folded.
```

3. To enable folding using tree-sitter **only for markdown**, you can use `ftplugin/`.
   You can do either of these 2 things.

> If you don't need anything fancy, you can add this to `~/.config/nvim/ftplugin/markdown.lua`,

```lua
--- Removes the ••• part.
vim.o.fillchars = "fold: ";

vim.o.foldmethod = "expr";
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()";

--- Disables fold text.
vim.o.foldtext = "";
```

> If you prefer using a custom `foldtext` then you can use this instead.

```lua
---@type integer Current buffer.
local buffer = vim.api.nvim_get_current_buf();

local got_spec, spec = pcall(require, "markview.spec");
local got_util, utils = pcall(require, "markview.utils");

if got_spec == false then
	--- Markview most likely not loaded.
	--- no point in going forward.
	return;
elseif got_util == false then
	--- Same as above.
	return;
end

--- Fold text creator.
---@return string
_G.heading_foldtext = function ()
	--- Start & end of the current fold.
	--- Note: These are 1-indexed!
	---@type integer, integer
	local from, to = vim.v.foldstart, vim.v.foldend;

	--- Starting line
	---@type string
	local line = vim.api.nvim_buf_get_lines(0, from - 1, from, false)[1];

	if line:match("^[%s%>]*%#+") == nil then
		--- Fold didn't start on a heading.
		return vim.fn.foldtext();
	end

	--- Heading configuration table.
	---@type markdown.headings?
	local main_config = spec.get({ "markdown", "headings" }, { fallback = nil });

	if not main_config then
		--- Headings are disabled.
		return vim.fn.foldtext();
	end

	--- Indentation, markers & the content of a heading.
	---@type string, string, string
	local indent, marker, content = line:match("^([%s%>]*)(%#+)(.*)$");
	--- Heading level.
    ---@type integer
	local level = marker:len();

	---@type headings.atx
	local config = spec.get({ "heading_" .. level }, {
		source = main_config,
		fallback = nil,

        --- This part isn't needed unless the user
        --- does something with these parameters.
		eval_args = {
			buffer,
			{
				class = "markdown_atx_heading",
				marker = marker,

				text = { marker .. content },
				range = {
					row_start = from - 1,
					row_end = from,

					col_start = #indent,
					col_end = #line
				}
			}
		}
	});

    --- Amount of spaces to add per heading level.
    ---@type integer
	local shift_width = spec.get({ "shift_width" }, { source = main_config, fallback = 0 });

	if not config then
        --- Config not found.
		return vim.fn.foldtext();
	elseif config.style == "simple" then
		return {
			{ marker .. content, utils.set_hl(config.hl) },

			{
				string.format(" 󰘖 %d", to - from),
				utils.set_hl(string.format("Palette%dFg", 7 - level))
			}
		};
	elseif config.style == "label" then
		--- We won't implement alignment for the sake
		--- of keeping things simple.

		local shift = string.rep(" ", level * #shift_width);

		return {
			{ shift, utils.set_hl(config.hl) },
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },
			{ config.icon or "", utils.set_hl(config.padding_left_hl or config.hl) },
			{ content:gsub("^%s", ""), utils.set_hl(config.hl) },
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) },

			{
				string.format(" 󰘖 %d", to - from),
				utils.set_hl(string.format("Palette%dFg", 7 - level))
			}
		};
	elseif config.style == "icon" then
		local shift = string.rep(" ", level * shift_width);

		return {
			{ shift, utils.set_hl(config.hl) },
			{ config.icon or "", utils.set_hl(config.padding_left_hl or config.hl) },
			{ content:gsub("^%s", ""), utils.set_hl(config.hl) },

			{
				string.format(" 󰘖 %d", to - from),
				utils.set_hl(string.format("Palette%dFg", 7 - level))
			}
		};
	end
end

vim.o.fillchars = "fold: ";

vim.o.foldmethod = "expr";
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()";

vim.o.foldtext = "v:lua.heading_foldtext()"
```

------

Also available in vimdoc, `:h markview.nvim-advanced`

