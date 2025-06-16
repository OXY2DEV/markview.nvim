local inline = {};

local spec = require("markview.spec");
local utils = require("markview.utils");

inline.decoration_size = 0;
inline.conceal_size = 0;
inline.string_size = 0;

local function width (...)
	local W = 0;

	for _, item in pairs({ ... }) do
		if type(item) == "string" then
			W = W + vim.fn.strdisplaywidth(item);
		end
	end

	return W;
end

inline.highlights = function (str, _, lines)
	---@type markview.config.markdown_inline.highlights?
	local main_config = spec.get({ "markdown_inline", "highlights" }, { fallback = nil });

	if not main_config then return; end

	---@type markview.config.__inline?
	local config = utils.match(
		main_config,
		table.concat(lines, "\n"),
		{
			eval_args = { str, {} } -- TODO
		}
	);

	if config == nil then
		return;
	end

	for _, line in ipairs(lines) do
		local _line = line;
		_line = _line:gsub("%`.-%`", function (s)
			return string.rep("Y", vim.fn.strchars(s));
		end);

		for highlight in _line:gmatch("%=%=[^=]+%=%=") do
			-- ==hi== >> hi
			inline.conceal_size = inline.conceal_size + 4;
			local decor_size = width(config.corner_left, config.padding_left, config.icon, config.padding_right, config.corner_right);

			inline.decoration_size = inline.decoration_size + decor_size;
			inline.string_size = inline.string_size - (2 + 2) + decor_size;

			_line = _line:gsub(utils.escape_string(highlight), function (s)
				return string.rep("X", vim.fn.strchars(s));
			end, 1);
		end
	end
end

inline.emojis = function (_, _, lines)
	local config = spec.get({ "markdown_inline", "emoji_shorthands" }, { fallback = nil });
	local symbols = require("markview.symbols");

	if not config then
		return;
	end

	for _, line in ipairs(lines) do
		local _line = line;
		_line = _line:gsub("%`.-%`", function (s)
			return string.rep("Y", vim.fn.strchars(s));
		end);

		for emoji in _line:gmatch("%:[%a%d%_%+%-]+%:") do
				vim.print(emoji)
			if symbols.shorthands[emoji:gsub(":", "")] then
				-- :+1: >> 👍
				inline.conceal_size = inline.conceal_size + #emoji;
				inline.decoration_size = inline.decoration_size + width(symbols.shorthands[emoji:gsub(":", "")]);
				inline.string_size = inline.string_size - #emoji + width(symbols.shorthands[emoji:gsub(":", "")]);
			end

			_line = _line:gsub(utils.escape_string(emoji), function (s)
				return string.rep("X", vim.fn.strchars(s));
			end, 1);
		end
	end
end

inline.email = function (str, _, lines)
	---@type markview.config.markdown_inline.emails?
	local main_config = spec.get({ "markdown_inline", "emails" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type markview.config.__inline
	local config = utils.match(
		main_config,
		string.sub(lines[1], 2, #lines[1] - 1),
		{
			eval_args = { str, {} }
		}
	);

	-- <email@mail.com> >> E email@mail.com
	inline.conceal_size = inline.conceal_size + 2;
	local decor_size = width(config.corner_left, config.padding_left, config.icon, config.padding_right, config.corner_right);

	inline.decoration_size = inline.decoration_size + decor_size;
	inline.string_size = inline.string_size - (1 + 1) + decor_size;
end

inline.image = function (str, TSNode, lines)
	if lines[1]:match("^%!%[%[") and lines[1]:match("%]%]$") then
		inline.embed_file(str, TSNode, lines);
		return;
	end

	---@type markview.config.markdown_inline.emails?
	local main_config = spec.get({ "markdown_inline", "emails" }, { fallback = nil });

	if not main_config then
		return;
	end

	local link_desc;

	for child in TSNode:iter_children() do
		if child:type() == "link_label" or child:type() == "link_destination" then
			link_desc = vim.treesitter.get_node_text(child, str):gsub("[%[%]%(%)]", "");
		end
	end

	---@type markview.config.__inline
	local config = utils.match(
		main_config,
		link_desc,
		{
			eval_args = { str, {} }
		}
	);

	-- ![image](link) >> I image
	inline.conceal_size = inline.conceal_size + 3 + 2 + #link_desc;
	local decor_size = width(config.corner_left, config.padding_left, config.icon, config.padding_right, config.corner_right);

	inline.decoration_size = inline.decoration_size + decor_size;
	inline.string_size = inline.string_size - (3 + 2 + #link_desc) + decor_size;
end

inline.hyperlink = function (str, TSNode, _)
	local link_desc;

	for child in TSNode:iter_children() do
		if child:type() == "link_label" or child:type() == "link_destination" then
			link_desc = vim.treesitter.get_node_text(child, str):gsub("[%[%]%(%)]", "");
		end
	end

	---@type markview.config.markdown_inline.images?
	local main_config = spec.get({ "markdown_inline", "hyperlinks" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type markview.config.__inline
	local config = utils.match(
		main_config,
		link_desc,
		{
			eval_args = { str, {} }
		}
	);

	-- [description](link) >> D description
	inline.conceal_size = inline.conceal_size + 2 + 2 + #link_desc;
	local decor_size = width(config.corner_left, config.padding_left, config.icon, config.padding_right, config.corner_right);

	inline.decoration_size = inline.decoration_size + decor_size;
	inline.string_size = inline.string_size - (2 + 2 + #link_desc) + decor_size;
end

inline.reference_link = inline.hyperlink;

inline.footnote = function (str, _, lines)
	local label = table.concat(lines, ""):gsub("^%[%^", ""):gsub("%]$", "");

	---@type markview.config.markdown_inline.footnotes?
	local main_config = spec.get({ "markdown_inline", "footnotes" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type markview.config.__inline
	local config = utils.match(
		main_config,
		label,
		{
			eval_args = { str, {} }
		}
	);

	-- [^One] >> O One
	inline.conceal_size = inline.conceal_size + 2 + 1;
	local decor_size = width(config.corner_left, config.padding_left, config.icon, config.padding_right, config.corner_right);

	inline.decoration_size = inline.decoration_size + decor_size;
	inline.string_size = inline.string_size - (2 + 1) + decor_size;
end

inline.shortcut_link = function (str, TSNode, lines, range)
	local s_line = str;
	local e_line = str;

	local before = s_line:sub(0, range.col_start);
	local after  = e_line:sub(range.col_end);

	if lines[1]:match("^%[%^") then
		--- Footnote
		return;
	elseif before:match("^[%s%>]*[%+%-%*]%s+$") and lines[1]:match("^%[.%]$") then
		--- Checkbox
		return;
	elseif before:match("^[%s%>]*%d+[%.%)]%s+$") and lines[1]:match("^%[.%]$") then
		--- Checkbox (ordered list item)
		return;
	elseif before:match("%>%s*$") then
		--- Callout
		return;
	elseif before:match("%!%[$") and after:match("^%]") then
		--- Embed file
		return;
	elseif before:match("%[$") and after:match("^%]") then
		if range.row_start ~= range.row_end then
			goto invalid_link;
		end

		---@cast range markview.parsed.markdown_inline.internal_links.range

		lines[1]     = "[" .. lines[1];
		lines[#lines] = lines[#lines] .. "]";

		range.col_start = range.col_start - 1;
		range.col_end   = range.col_end + 1;

		--- Obsidian internal link
		inline.internal_link(str, TSNode, lines);
		return;
	end

	::invalid_link::

	---@cast range markview.parsed.markdown_inline.hyperlinks.range

	local link_label;

	for child in TSNode:iter_children() do
		if child:type() == "link_text" then
			link_label = vim.treesitter.get_node_text(child, str):gsub("[%[%]%(%)]", "");
			range.label = { child:range() };
		end
	end

	---@type markview.config.markdown_inline.hyperlinks?
	local main_config = spec.get({ "markdown_inline", "hyperlinks" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type markview.config.__inline
	local config = utils.match(
		main_config,
		link_label,
		{
			eval_args = { str, {} }
		}
	);

	-- [short] >> S short
	inline.conceal_size = inline.conceal_size + 1 + 1;
	local decor_size = width(config.corner_left, config.padding_left, config.icon, config.padding_right, config.corner_right);

	inline.decoration_size = inline.decoration_size + decor_size;
	inline.string_size = inline.string_size - (1 + 1) + decor_size;
end

inline.uri_autolink = function (str, _, lines)
	local label = lines[1]:sub(2, #lines[1] - 1);

	---@type markview.config.markdown_inline.uri_autolinks?
	local main_config = spec.get({ "markdown_inline", "uri_autolinks" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type markview.config.__inline
	local config = utils.match(
		main_config,
		label,
		{
			eval_args = { str, {} }
		}
	);

	-- <link.com> >> L link.com
	inline.conceal_size = inline.conceal_size + 1 + 1;
	local decor_size = width(config.corner_left, config.padding_left, config.icon, config.padding_right, config.corner_right);

	inline.decoration_size = inline.decoration_size + decor_size;
	inline.string_size = inline.string_size - (1 + 1) + decor_size;
end

inline.code_span = function (str, _, _)
	---@type markview.config.__inline?
	local config = spec.get({ "markdown_inline", "inline_codes" }, { fallback = nil, eval_args = { str, {} } });

	if not config then
		return;
	end

	-- `code` >> code
	inline.conceal_size = inline.conceal_size + 1 + 1;
	local decor_size = width(config.corner_left, config.padding_left, config.icon, config.padding_right, config.corner_right);

	inline.decoration_size = inline.decoration_size + decor_size;
	inline.string_size = inline.string_size - (1 + 1) + decor_size;
end

inline.entity = function (_, _, lines)
	local name = lines[1]:gsub("[^%a%d]", "");
	local entities = require("markview.entities");

	local config = spec.get({ "markdown_inline", "entities" }, { fallback = nil });

	if not config then
		return;
	elseif not entities.get(name) then
		return;
	end

	-- &gamma; >> 𝛄
	inline.conceal_size = inline.conceal_size + #lines[1];
	local decor_size = width(entities.get(name));

	inline.decoration_size = inline.decoration_size + decor_size;
	inline.string_size = inline.string_size - #lines[1] + decor_size;
end

inline.escaped = function ()
	---@type { enable: boolean }?
	local config = spec.get({ "markdown_inline", "escapes" }, { fallback = nil });

	if not config then
		return;
	end

	-- \\ >> \
	inline.conceal_size = inline.conceal_size + 1;
	inline.string_size = inline.string_size - 1;
end

inline.emph = function ()
	-- * >> 
	inline.conceal_size = inline.conceal_size + 1;
	inline.string_size = inline.string_size - 1;
end

------------------------------------------------------------------------------

inline.embed_file = function (str, _, lines)
	if lines[1]:match("%#%^(.+)%]%]$") then
		local file, block = lines[1]:match("^%!%[%[(.*)%#%^(.+)%]%]$");

		if file == "" then
			file = nil;
		end

		---@type markview.config.markdown_inline.block_refs?
		local main_config = spec.get({ "markdown_inline", "block_references" }, { fallback = nil });

		if not main_config then
			return;
		end

		---@type markview.config.__inline
		local config = utils.match(
			main_config,
			string.format("%s#^%s", file, block),
			{
				eval_args = { str, {} }
			}
		);

		inline.conceal_size = inline.conceal_size + (3 + 2);
		local decor_size = width(config.corner_left, config.padding_left, config.icon, config.padding_right, config.corner_right);

		inline.decoration_size = inline.decoration_size + decor_size;
		inline.string_size = inline.string_size - (3 + 2) + decor_size;
	else
		local label = lines[1]:match("%[%[([^%[+])%]%]");

		---@type markview.config.markdown_inline.embed_files?
		local main_config = spec.get({ "markdown_inline", "embed_files" }, { fallback = nil });

		if not main_config then
			return;
		end

		---@type markview.config.__inline
		local config = utils.match(
			main_config,
			label,
			{
				eval_args = { str, {} }
			}
		);

		inline.conceal_size = inline.conceal_size + (2 + 2);
		local decor_size = width(config.corner_left, config.padding_left, config.icon, config.padding_right, config.corner_right);

		inline.decoration_size = inline.decoration_size + decor_size;
		inline.string_size = inline.string_size - (2 + 2) + decor_size;
	end
end

inline.internal_link = function (str, _, lines)
	if string.match(lines[1], "%#%^.+$") ~= nil then
		local file, block = lines[1]:match("^%[%[(.*)%#%^(.+)$");

		if file == "" then
			file = nil;
		end

		---@type markview.config.markdown_inline.block_refs?
		local main_config = spec.get({ "markdown_inline", "block_references" }, { fallback = nil });

		if not main_config then
			return;
		end

		---@type markview.config.__inline
		local config = utils.match(
			main_config,
			string.format("%s#^%s", file, block),
			{
				eval_args = { str, {} }
			}
		);

		inline.conceal_size = inline.conceal_size + (2 + 2);
		local decor_size = width(config.corner_left, config.padding_left, config.icon, config.padding_right, config.corner_right);

		inline.decoration_size = inline.decoration_size + decor_size;
		inline.string_size = inline.string_size - (2 + 2) + decor_size;
	else
		local label = lines[1]:match("^%[%[(.+)%]%]");
		local alias_start, alias_end, alias = lines[1]:find("%|([^%|]+)%]%]$");

		---@type markview.config.markdown_inline.internal_links?
		local main_config = spec.get({ "markdown_inline", "internal_links" }, { fallback = nil });

		if not main_config then
			return;
		end

		---@type markview.config.__inline
		local config = utils.match(
			main_config,
			label,
			{
				eval_args = { str, {} }
			}
		);

		-- [[txt|abc]] >> T txt
		inline.conceal_size = inline.conceal_size + (2 + 2);
		local decor_size = width(config.corner_left, config.padding_left, config.icon, config.padding_right, config.corner_right);

		inline.decoration_size = inline.decoration_size + decor_size;
		inline.string_size = inline.string_size - (2 + 2) + decor_size;

		if alias_start and alias_end then
			-- +1 for |
			inline.conceal_size = inline.conceal_size + (width(label) - width(alias));
			inline.string_size = inline.string_size - (width(label) - width(alias));
		end
	end
end

------------------------------------------------------------------------------

--- Inline markdown parser.
---@param str string
---@param TSTree table
---@param from integer?
---@param to integer?
---@return integer
---@return integer
---@return integer
inline.parse = function (str, TSTree, from, to)
	inline.decoration_size = 0;
	inline.conceal_size = 0;
	inline.string_size = vim.fn.strdisplaywidth(str);

	local scanned_queries = vim.treesitter.query.parse("markdown_inline", [[
		((inline) @markdown_inline.highlights
			(#match? @markdown_inline.highlights "\\=\\=.+\\=\\="))

		((inline) @markdown_inline.emojis
			(#match? @markdown_inline.emojis "\\:.+\\:"))

		((email_autolink) @markdown_inline.email)

		((image) @markdown_inline.image)

		([
			(inline_link)
			(collapsed_reference_link)] @markdown_inline.hyperlink)

		((full_reference_link
			(link_text)
			(link_label)) @markdown_inline.reference_link)

		((shortcut_link
			(link_text) @footnote.text
			(#match? @footnote.text "^\\^")) @markdown_inline.footnote)

		((shortcut_link) @markdown_inline.shortcut_link)

		((uri_autolink) @markdown_inline.uri_autolink)

		((code_span) @markdown_inline.code_span)

		([
			(entity_reference)
			(numeric_character_reference)] @markdown_inline.entity)

		((backslash_escape) @markdown_inline.escaped)

		((emphasis_delimiter) @markdown_inline.emph)
	]]);

	for capture_id, capture_node, _, _ in scanned_queries:iter_captures(TSTree:root(), str, from, to) do
		local capture_name = scanned_queries.captures[capture_id];

		if not capture_name:match("^markdown_inline") then
			goto continue;
		end

		---@type string?
		local capture_text = vim.treesitter.get_node_text(capture_node, str);
		local r_start, c_start, r_end, c_end = capture_node:range();

		if capture_text == nil then
			goto continue;
		end

		--- Doesn't end with a newline. Add it.
		if not capture_text:match("\n$") then
			capture_text = capture_text .. "\n";
		end

		local lines = vim.split(capture_text, "\n", { trimempty = true });

		---@type boolean, string
		local success, error = pcall(
			inline[capture_name:gsub("^markdown_inline%.", "")],
			str,
			capture_node,
			lines,

			{
				row_start = r_start,
				col_start = c_start,

				row_end = r_end,
				col_end = c_end
			}
		);

		if success == false then
			require("markview.health").notify("trace", {
				level = 4,
				message = error
			});
		end

	   ::continue::
	end

	return inline.conceal_size, inline.decoration_size, inline.string_size;
end

return inline;
