--[[
Basic renderer for `markdown`. Used to convert regular strings to preview strings.

Used for width calculations.

>[!IMPORTANT]
> This returns a different value type(**string**) from `asciidoc.tostring()`(returning **[ string, string? ][]**).
]]
local md_str = {};

local function eval(tbl, ignore, ...)
	---|fS

	if type(tbl) ~= "table" then
		return tbl;
	end

	local _e = {};

	for k, v in pairs(tbl) do
		if ignore and vim.list_contains(ignore, k) then
			goto continue;
		end

		if type(v) == "function" then
			local could_eval, evaled = pcall(v, ...);

			if could_eval then
				_e[k] = evaled;
			end
		else
			_e[k] = v;
		end

		::continue::
	end

	return _e;

	---|fE
end

--[[
We use cache values as it removes the config lookup step.` 
This module is designed to be *fast* & *frequently used*.
]]
md_str.cached_config = nil;

md_str.update_cache = function ()
	---|fS

	local spec = require("markview.spec");

	md_str.cached_config = {
		block_references = spec.get({ "markdown_inline", "block_references" }, { fallback = nil }),
		emails = spec.get({ "markdown_inline", "emails" }, { fallback = nil }),
		embed_files = spec.get({ "markdown_inline", "embed_files" }, { fallback = nil }),
		emoji_shorthands   = spec.get({ "markdown_inline", "emoji_shorthands" }, { fallback = nil }),
		entities = spec.get({ "markdown_inline", "entities" }, { fallback = nil }),
		escapes = spec.get({ "markdown_inline", "escapes" }, { fallback = nil }),
		highlights = spec.get({ "markdown_inline", "highlights" }, { fallback = nil }),
		hyperlinks = spec.get({ "markdown_inline", "hyperlinks" }, { fallback = nil }),
		images = spec.get({ "markdown_inline", "images" }, { fallback = nil }),
		inline_codes = spec.get({ "markdown_inline", "inline_codes"}, { fallback = nil }),
		footnotes = spec.get({ "markdown_inline", "footnotes" }, { fallback = nil }),
		internal_links = spec.get({ "markdown_inline", "internal_links" }, { fallback = nil }),
		uri_autolinks = spec.get({ "markdown_inline", "uri_autolinks" }, { fallback = nil }),
	};

	---|fE
end

md_str.buffer = -1;

---@param match string
---@return string
md_str.autolink = function (match)
	---|fS

	local removed = string.gsub(match, "^%<", ""):gsub("%>$", "");

	if md_str.cached_config and md_str.cached_config.uri_autolinks then
		---@type markview.config.markdown_inline.emails.opts
		local config = require("markview.utils").match(md_str.cached_config.uri_autolinks, removed, {
			eval_args = {
				md_str.buffer,
				{
					class = "inline_link_uri_autolink",
					text = { match },

					label = removed,
					address = nil,
				}
			}
		});

		return table.concat({
			config.corner_left or "",
			config.padding_left or "",

			config.icon or "",
			md_str.tostring(md_str.buffer, removed, false),

			config.padding_right or "",
			config.corner_right or "",
		}, "");
	else
		return md_str.tostring(md_str.buffer, removed, false);
	end

	---|fE
end

---@param match string
---@return string
md_str.block_ref = function (match)
	---|fS

	local removed = string.gsub(match, "^%!%[%[", ""):gsub("%]%]$", "");
	local file, block = string.match(removed, "^(.*)%#%^(.-)$");

	if md_str.cached_config and md_str.cached_config.block_references then
		---@type markview.config.markdown_inline.emails.opts
		local config = require("markview.utils").match(md_str.cached_config.block_references, removed, {
			eval_args = {
				md_str.buffer,
				{
					class = "inline_link_block_ref",
					text = { match },

					file = file,
					block = block,
					label = removed,
				}
			}
		});

		return table.concat({
			config.corner_left or "",
			config.padding_left or "",

			config.icon or "",
			md_str.tostring(md_str.buffer, removed, false),

			config.padding_right or "",
			config.corner_right or "",
		}, "");
	else
		return removed;
	end

	---|fE
end

---@param match string
---@return string
md_str.bold = function (match)
	---|fS

	if string.match(match, "%s+%*%*$") or string.match(match, "%s+%_%_$") then
		return match;
	end

	local removed;

	if string.match(match, "%*$") then
		removed = string.gsub(match, "^%*%*", ""):gsub("%*%*$", "");
	else
		removed = string.gsub(match, "^%_%_", ""):gsub("%_%_$", "");
	end

	return md_str.tostring(md_str.buffer, removed, false);

	---|fE
end

---@param match string
---@return string
md_str.bold_italic = function (match)
	---|fS

	if string.match(match, "%s+%*+$") or string.match(match, "%s+%_+$") then
		return match;
	end

	local r;

	if string.match(match, "%*$") then
		local be, af = string.match(match, "^%*+"), string.match(match, "%*+$");
		r = math.min(be and #be or 0, af and #af or 0);
	else
		local be, af = string.match(match, "^%_+"), string.match(match, "%_+$");
		r = math.min(be and #be or 0, af and #af or 0);
	end

	local removed = vim.fn.strpart(match, r, vim.fn.strchars(match) - (r + r));
	return md_str.tostring(md_str.buffer, removed, false);

	---|fE
end

---@param match string
---@return string
md_str.embed = function (match)
	---|fS

	local removed = string.gsub(match, "^%!%[%[", ""):gsub("%]%]$", "");

	if md_str.cached_config and md_str.cached_config.embed_files then
		---@type markview.config.markdown_inline.emails.opts
		local config = require("markview.utils").match(md_str.cached_config.embed_files, removed, {
			eval_args = {
				md_str.buffer,
				{
					class = "inline_link_embed_file",
					text = { match },

					label = removed,
				}
			}
		});

		return table.concat({
			config.corner_left or "",
			config.padding_left or "",

			config.icon or "",
			md_str.tostring(md_str.buffer, removed, false),

			config.padding_right or "",
			config.corner_right or "",
		}, "");
	else
		return removed;
	end

	---|fE
end

---@param match string
---@return string
md_str.emoji = function (match)
	---|fS

	if not md_str.cached_config or not md_str.cached_config.emoji_shorthands then
		return match;
	end

	local removed = string.gsub(match, "^:", ""):gsub(":$", "");

	--- Resolve to the actual Unicode emoji so that
	--- strdisplaywidth() returns the correct on-screen
	--- width (typically 2) instead of the shortcode name
	--- length (e.g. "rocket" = 6).
	local symbols = require("markview.symbols");
	if symbols.shorthands and symbols.shorthands[removed] then
		return symbols.shorthands[removed];
	end

	return removed;

	---|fE
end

---@param match string
---@return string
md_str.entity = function (match)
	---|fS

	if not md_str.cached_config or not md_str.cached_config.entities then
		return match;
	end

	local removed = string.gsub(match, "^&#?", ""):gsub(";$", "");
	return require("markview.entities").get(removed) or match;

	---|fE
end

---@param match string
---@return string
md_str.internal = function (match)
	---|fS

	local removed = string.gsub(match, "^%[%[", ""):gsub("%]%]$", "");
	local alias = string.match(removed, "%|(.-)$");

	if md_str.cached_config and md_str.cached_config.internal_links then
		---@type markview.config.markdown_inline.emails.opts
		local config = require("markview.utils").match(md_str.cached_config.internal_links, removed, {
			eval_args = {
				md_str.buffer,
				{
					class = "inline_link_internal",
					text = { match },

					label = removed,
					alias = alias,
				}
			}
		});

		return table.concat({
			config.corner_left or "",
			config.padding_left or "",

			config.icon or "",
			md_str.tostring(md_str.buffer, removed, false),

			config.padding_right or "",
			config.corner_right or "",
		}, "");
	else
		return removed;
	end

	---|fE
end

---@param match string
---@return string
md_str.footnote = function (match)
	---|fS

	local label = string.gsub(match, "^%[%^", ""):gsub("%]$", "");

	if md_str.cached_config and md_str.cached_config.footnotes then
		---@type markview.config.__inline?
		local config = require("markview.utils").match(md_str.cached_config.footnotes, label, {
			eval_args = {
				md_str.buffer,
				{
					class = "inline_footnote",
					text = { match },

					label = label,
				}
			}
		});

		if config then
			return table.concat({
				config.corner_left or "",
				config.padding_left or "",

				config.icon or "",
				label,

				config.padding_right or "",
				config.corner_right or "",
			}, "");
		end
	end

	return label;

	---|fE
end

---@param match string
---@return string
md_str.escape = function (match)
	local char = string.match(match, "\\(.)");
	return char;
end

---@param match string
---@return string
md_str.italic = function (match)
	---|fS

	if string.match(match, "%s+%*$") then
		return match;
	end

	local removed;

	if string.match(match, "%*$") then
		removed = string.gsub(match, "^%*", ""):gsub("%*$", "");
	else
		removed = string.gsub(match, "^%_", ""):gsub("%_$", "");
	end

	return md_str.tostring(md_str.buffer, removed, false);

	---|fE
end

---@param match string
---@return string
md_str.code = function (match)
	---|fS

	local removed = string.gsub(match, "^%`+", ""):gsub("%`+$", "");

	if md_str.cached_config and md_str.cached_config.inline_codes then
		---@type markview.config.markdown_inline.inline_codes
		local config = eval(md_str.cached_config.inline_codes, {}, md_str.buffer, {
			class = "inline_code_span",
			text = { match },
		});

		return table.concat({
			config.corner_left or "",
			config.padding_left or "",

			config.icon or "",
			removed,

			config.padding_right or "",
			config.corner_right or "",
		}, "");
	else
		return removed;
	end

	---|fE
end

---@param match string
---@return string
md_str.email = function (match)
	---|fS

	local removed = string.gsub(match, "^%<", ""):gsub("%>$", "");

	if md_str.cached_config and md_str.cached_config.emails then
		---@type markview.config.markdown_inline.emails.opts
		local config = require("markview.utils").match(md_str.cached_config.emails, removed, {
			eval_args = {
				md_str.buffer,
				{
					class = "inline_link_email",
					text = { match },

					label = removed,
				}
			}
		});

		return table.concat({
			config.corner_left or "",
			config.padding_left or "",

			config.icon or "",
			removed,

			config.padding_right or "",
			config.corner_right or "",
		}, "");
	else
		return removed;
	end

	---|fE
end

---@param match string
---@return string
md_str.highlight = function (match)
	---|fS

	local removed = string.gsub(match, "^%=%=", ""):gsub("%=%=$", "");

	if md_str.cached_config and md_str.cached_config.highlights then
		---@type markview.config.markdown_inline.emails.opts
		local config = require("markview.utils").match(md_str.cached_config.highlights, removed, {
			eval_args = {
				md_str.buffer,
				{
					class = "inline_highlight",
					text = { match },
				}
			}
		});

		return table.concat({
			config.corner_left or "",
			config.padding_left or "",

			config.icon or "",
			md_str.tostring(md_str.buffer, removed, false),

			config.padding_right or "",
			config.corner_right or "",
		}, "");
	else
		return removed;
	end

	---|fE
end

---@param match string
---@return string
md_str.hyperlink_no_src = function (match)
	---|fS

	local removed = string.gsub(match, "^%[", ""):gsub("%]$", "");

	if md_str.cached_config and md_str.cached_config.hyperlinks then
		---@type markview.config.markdown_inline.hyperlinks.opts
		local config = require("markview.utils").match(md_str.cached_config.hyperlinks, removed, {
			eval_args = {
				md_str.buffer,
				{
					class = "inline_link_hyperlink",
					text = { match },

					label = removed,
					description = nil
				}
			}
		});

		return table.concat({
			config.corner_left or "",
			config.padding_left or "",

			config.icon or "",
			md_str.tostring(md_str.buffer, removed, false),

			config.padding_right or "",
			config.corner_right or "",
		}, "");
	else
		return removed;
	end

	---|fE
end

---@param match string
---@return string
md_str.hyperlink_src = function (match)
	---|fS

	local removed = string.gsub(match, "^%[", ""):gsub("%]%(.-%)$", "");
	local address = string.match(match, "%((.-)%)$");

	if md_str.cached_config and md_str.cached_config.hyperlinks then
		---@type markview.config.markdown_inline.hyperlinks.opts
		local config = require("markview.utils").match(md_str.cached_config.hyperlinks, address, {
			eval_args = {
				md_str.buffer,
				{
					class = "inline_link_hyperlink",
					text = { match },

					label = removed,
					description = address
				}
			}
		});

		return table.concat({
			config.corner_left or "",
			config.padding_left or "",

			config.icon or "",
			md_str.tostring(md_str.buffer, removed, false),

			config.padding_right or "",
			config.corner_right or "",
		}, "");
	else
		return removed;
	end

	---|fE
end

---@param match string
---@return string
md_str.img_no_src = function (match)
	---|fS

	local removed = string.gsub(match, "^%!%[", ""):gsub("%]$", "");

	if md_str.cached_config and md_str.cached_config.images then
		---@type markview.config.markdown_inline.images.opts
		local config = require("markview.utils").match(md_str.cached_config.images, removed, {
			eval_args = {
				md_str.buffer,
				{
					class = "inline_link_image",
					text = { match },

					label = removed,
					description = nil
				}
			}
		});

		return table.concat({
			config.corner_left or "",
			config.padding_left or "",

			config.icon or "",
			md_str.tostring(md_str.buffer, removed, false),

			config.padding_right or "",
			config.corner_right or "",
		}, "");
	else
		return removed;
	end

	---|fE
end

md_str.img_src = function (match)
	---|fS

	local removed = string.gsub(match, "^%!%[", ""):gsub("%]%(.-%)$", "");
	local address = string.match(match, "%((.-)%)$");

	if md_str.cached_config and md_str.cached_config.images then
		---@type markview.config.markdown_inline.images.opts
		local config = require("markview.utils").match(md_str.cached_config.images, address, {
			eval_args = {
				md_str.buffer,
				{
					class = "inline_link_image",
					text = { match },

					label = removed,
					description = address
				}
			}
		});

		return table.concat({
			config.corner_left or "",
			config.padding_left or "",

			config.icon or "",
			md_str.tostring(md_str.buffer, removed, false),

			config.padding_right or "",
			config.corner_right or "",
		}, "");
	else
		return removed;
	end

	---|fE
end

--[[
NOTE: Pre-compiling patterns can save *a lot* of time

Especially on mobile.
]]
---|fS "feat: Pre-compile pattern"

local lpeg = vim.lpeg;

local at_start = lpeg.P(function (_, i) return i == 1; end);
local after_sp = lpeg.B(lpeg.S(" \t"));
local at_valid = (at_start + after_sp);

local s_italic_content = lpeg.P("\\*") + ( 1 - lpeg.P("*") );
local u_italic_content = lpeg.P("\\_") + ( 1 - lpeg.P("_") );
local s_italic = lpeg.C( lpeg.P("*") * s_italic_content^1 * lpeg.P("*") ) / md_str.italic;
local u_italic = lpeg.C( lpeg.P("_") * u_italic_content^1 * lpeg.P("_") ) / md_str.italic;
local italic = at_valid * (s_italic + u_italic);

local s_bold_content = lpeg.P("\\*") + ( 1 - lpeg.P("*") );
local u_bold_content = lpeg.P("\\_") + ( 1 - lpeg.P("_") );
local s_bold = lpeg.C( lpeg.P("**") * s_bold_content^1 * lpeg.P("**") ) / md_str.bold;
local u_bold = lpeg.C( lpeg.P("__") * u_bold_content^1 * lpeg.P("__") ) / md_str.bold;
local bold = at_valid * (s_bold + u_bold);

local s_bold_italic_content = lpeg.P("\\*") + ( 1 - lpeg.P("*") );
local u_bold_italic_content = lpeg.P("\\_") + ( 1 - lpeg.P("_") );
local s_bold_italic = lpeg.C( lpeg.P("*")^3 * s_bold_italic_content^1 * lpeg.P("*")^3 ) / md_str.bold_italic;
local u_bold_italic = lpeg.C( lpeg.P("_")^3 * u_bold_italic_content^1 * lpeg.P("_")^3 ) / md_str.bold_italic;
local bold_italic = s_bold_italic + u_bold_italic;

local code_content = lpeg.P("\\`") + ( 1 - lpeg.P("`") );
local code = lpeg.C( at_valid * lpeg.P("`")^1 * code_content^1 * lpeg.P("`")^1 ) / md_str.code;

local footnote_label_char = lpeg.R("09", "az", "AZ") + lpeg.S("-_.");
local footnote = lpeg.C( lpeg.P("[^") * footnote_label_char^1 * lpeg.P("]") ) / md_str.footnote;

local hyperlink_content = lpeg.P("\\]") + ( 1 - lpeg.P("]") );
local hyperlink_no_src = lpeg.C( lpeg.P("[") * hyperlink_content^0 * lpeg.P("]") ) / md_str.hyperlink_no_src;
-- Supports balanced parentheses in URLs per CommonMark spec §6.7:
-- https://spec.commonmark.org/0.31.2/#link-destination
local src_content = lpeg.P{
	"src";
	src = lpeg.P("\\)") + (lpeg.P("(") * lpeg.V("src")^0 * lpeg.P(")")) + ( 1 - lpeg.S(") \t") );
};
local hyperlink_src = lpeg.C( lpeg.P("[") * hyperlink_content^0 * lpeg.P("](") * src_content^0 * lpeg.P(")") ) / md_str.hyperlink_src;
local hyperlink = hyperlink_src + hyperlink_no_src;

local img_content = lpeg.P("\\]") + ( 1 - lpeg.P("]") );
local img_no_src = lpeg.C( lpeg.P("![") * img_content^0 * lpeg.P("]") ) / md_str.img_no_src;
local img_src = lpeg.C( lpeg.P("![") * img_content^0 * lpeg.P("](") * src_content^0 * lpeg.P(")") ) / md_str.img_src;
local img = img_src + img_no_src;

local email_be = lpeg.P("\\@") + ( 1 - lpeg.P("@") );
local email_af = lpeg.P("\\>") + ( 1 - lpeg.P(">") );
local email = lpeg.C( lpeg.P("<") * email_be^1 * lpeg.P("@") * email_af^1 * lpeg.P(">") ) / md_str.email;

local auto_content = lpeg.P("\\>") + ( 1 - lpeg.P(">") );
local auto = lpeg.C( lpeg.P("<") * auto_content^1 * lpeg.P(">") ) / md_str.autolink;

local block_be = lpeg.P("\\]") + ( 1 - lpeg.P("#") );
local block_af = lpeg.P("\\]") + ( 1 - lpeg.P("]]") );
local block_ref = lpeg.C( lpeg.P("![[") * block_be^0 * lpeg.P("#^") * block_af^1 * lpeg.P("]]") ) / md_str.block_ref;

local embed_content = lpeg.P("\\]") + ( 1 - lpeg.P("]]") );
local embed = lpeg.C( lpeg.P("![[") * embed_content^1 * lpeg.P("]]") ) / md_str.embed;

local internal = lpeg.C( lpeg.P("[[") * embed_content^1 * lpeg.P("]]") ) / md_str.internal;

local escape = lpeg.C( lpeg.P("\\") * lpeg.P(1) ) / md_str.escape;

local entity_char = lpeg.R("09", "az", "AZ");
local entity = lpeg.C( ( lpeg.P("&#") + lpeg.P("&") ) * entity_char^1 * lpeg.P(";") ) / md_str.entity;

local emoji_char = lpeg.R("09", "az", "AZ") + lpeg.S("_+-");
local emoji = lpeg.C( lpeg.P(":") * emoji_char^1 * lpeg.P(":") ) / md_str.emoji;

local hl_content = lpeg.P("\\=") + ( 1 - lpeg.P("=") );
local hl = lpeg.C( lpeg.P("==") * hl_content^1 * lpeg.P("==") ) / md_str.highlight;

local any = lpeg.P(1);

local token = escape +
	emoji + entity +
	hl + block_ref + embed + internal +
	email + auto +
	footnote + img + hyperlink +
	code +
	bold_italic + bold + italic +
	any;
local inline = lpeg.Cs( token^0 );

---|fE

---@param buffer integer
---@param text string
---@param update_cache? boolean Update config cache?
---@return string
md_str.tostring = function (buffer, text, update_cache)
	---|fS

	if update_cache == true or not md_str.cached_config then
		md_str.update_cache()
	end

	md_str.buffer = buffer;
	return lpeg.match(inline, text or "");

	---|fE
end

return md_str;
