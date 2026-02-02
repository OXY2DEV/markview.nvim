--[[
Basic renderer for `asciidoc`. Used to convert regular strings to preview strings.

Used for width calculations.
]]
local adoc_str = {};

local utils = require("markview.utils");
local spec = require("markview.spec");

adoc_str.buffer = -1;

---@param match string
adoc_str.bold = function (match)
	---|fS

	---@type markview.config.asciidoc_inline.bolds?
	local config = spec.get({
		"asciidoc_inline", "bolds"
	}, {
		eval_args = {
			adoc_str.buffer, {
				class = "asciidoc_inline_bold",
				delimiters = string.match(match, "^%*%*") and { "**", "**" } or { "*", "*" },

				text = { match },
				range = {
					row_start = -1,
					col_start = -1,

					row_end = -1,
					col_end = -1,
				}
			} --[[@as markview.parsed.asciidoc_inline.bolds]]
		}
	});

	if not config then
		return { match };
	else
		local removed = string.gsub(match, "^%*+", ""):gsub("%*+$", "");
		return { removed };
	end

	---|fE
end

---@param match string
adoc_str.italic = function (match)
	---|fS

	---@type markview.config.asciidoc_inline.italics?
	local config = spec.get({
		"asciidoc_inline", "italics"
	}, {
		eval_args = {
			adoc_str.buffer, {
				class = "asciidoc_inline_italic",
				delimiters = string.match(match, "^__") and { "__", "__" } or { "_", "_" },

				text = { match },
				range = {
					row_start = -1,
					col_start = -1,

					row_end = -1,
					col_end = -1,
				}
			} --[[@as markview.parsed.asciidoc_inline.italics]]
		}
	});

	if not config then
		return { match };
	else
		local removed = string.gsub(match, "^[%*_]+", ""):gsub("[%*_]+$", "");
		return { removed };
	end

	---|fE
end

---@param match string
adoc_str.monospace = function (match)
	---|fS

	local delimiter = string.match(match, "^`+");

	---@type markview.config.asciidoc_inline.monospaces?
	local config = spec.get({
		"asciidoc_inline", "monospaces"
	}, {
		eval_args = {
			adoc_str.buffer, {
				class = "asciidoc_inline_monospace",
				delimiters = { delimiter, delimiter },

				text = { match },
				range = {
					row_start = -1,
					col_start = -1,

					row_end = -1,
					col_end = -1,
				}
			} --[[@as markview.parsed.asciidoc_inline.monospaces]]
		}
	});

	if not config then
		return { match };
	else
		local removed = string.gsub(match, "^`+", ""):gsub("`+$", "");
		local output = {};

		if config.corner_left then table.insert(output, { config.corner_left, config.corner_left_hl or config.hl }) end
		if config.padding_left then table.insert(output, { config.padding_left, config.padding_left_hl or config.hl }) end
		if config.icon then table.insert(output, { config.icon, config.icon_hl or config.hl }) end

		table.insert(output, { removed, config.hl });

		if config.padding_right then table.insert(output, { config.padding_right, config.padding_right_hl or config.hl }) end
		if config.corner_right then table.insert(output, { config.corner_right, config.corner_right_hl or config.hl }) end

		return output;
	end

	---|fE
end

---@param match string
adoc_str.highlight = function (match)
	---|fS

	local delimiter = string.match(match, "#+");

	---@type markview.config.asciidoc_inline.highlights?
	local main_config = spec.get({ "asciidoc_inline", "highlights" }, { fallback = nil });

	if not main_config then
		return { match };
	end

	---@type markview.parsed.asciidoc_inline.highlights
	local item = {
		class = "asciidoc_inline_highlight",
		delimiters = { delimiter, delimiter },

		text = { match },
		range = {
			row_start = -1,
			col_start = -1,

			row_end = -1,
			col_end = -1,
		}
	};

	if not main_config then
		return;
	end

	---@type markview.config.__inline?
	local config = utils.match(
		main_config,
		table.concat(item.text, "\n"),
		{
			eval_args = { adoc_str.buffer, item }
		}
	);

	if not config then
		return { match };
	else
		local removed = string.gsub(match, "^.-#+", ""):gsub("#+$", "");
		local output = {};

		if config.corner_left then table.insert(output, { config.corner_left, config.corner_left_hl or config.hl }) end
		if config.padding_left then table.insert(output, { config.padding_left, config.padding_left_hl or config.hl }) end
		if config.icon then table.insert(output, { config.icon, config.icon_hl or config.hl }) end

		table.insert(output, { removed, config.hl });

		if config.padding_right then table.insert(output, { config.padding_right, config.padding_right_hl or config.hl }) end
		if config.corner_right then table.insert(output, { config.corner_right, config.corner_right_hl or config.hl }) end

		return output;
	end

	---|fE
end

---@param char string
adoc_str.char = function (char)
	return { char };
end

---@param match string
adoc_str.labeled_url = function (match)
	---|fS

	local link, label = string.match(match, "([^%[]-)%[([^%]]*)%]");

	---@type markview.config.asciidoc_inline.uris?
	local main_config = spec.get({ "asciidoc_inline", "uris" }, { fallback = nil });

	if not main_config then
		return { match };
	end

	---@type markview.parsed.asciidoc_inline.labeled_uris
	local item = {
		class = "asciidoc_inline_labeled_uri",
		destination = link or "",

		text = { match },
		range = {
			row_start = -1,
			col_start = -1,

			label_col_start = #(link or "") + 1,
			label_col_end = #match - 1,

			row_end = -1,
			col_end = -1,
		}
	};

	if not main_config then
		return;
	end

	---@type markview.config.asciidoc_inline.uris.opts?
	local config = utils.match(
		main_config,
		item.destination or "",
		{
			eval_args = { adoc_str.buffer, item }
		}
	);

	if not config then
		return { match };
	else
		local output = {};

		if config.corner_left then table.insert(output, { config.corner_left, config.corner_left_hl or config.hl }) end
		if config.padding_left then table.insert(output, { config.padding_left, config.padding_left_hl or config.hl }) end
		if config.icon then table.insert(output, { config.icon, config.icon_hl or config.hl }) end

		table.insert(output, { label or "", config.hl });

		if config.padding_right then table.insert(output, { config.padding_right, config.padding_right_hl or config.hl }) end
		if config.corner_right then table.insert(output, { config.corner_right, config.corner_right_hl or config.hl }) end

		return output;
	end

	---|fE
end

---@param match string
adoc_str.url = function (match)
	---|fS

	local inner = string.gsub(match, "^['\"]", ""):gsub("[^'\"]$", "");
	local delimiter = string.match(match, "^['\"]");

	---@type markview.config.asciidoc_inline.uris?
	local main_config = spec.get({ "asciidoc_inline", "uris" }, { fallback = nil });

	if not main_config then
		return { match };
	end

	---@type markview.parsed.asciidoc_inline.uris
	local item = {
		class = "asciidoc_inline_uri",
		delimiters = delimiter and { delimiter, delimiter } or nil,
		destination = inner,

		text = { match },
		range = {
			row_start = -1,
			col_start = -1,

			row_end = -1,
			col_end = -1,
		}
	};

	if not main_config then
		return;
	end

	---@type markview.config.asciidoc_inline.uris.opts?
	local config = utils.match(
		main_config,
		item.destination or "",
		{
			eval_args = { adoc_str.buffer, item }
		}
	);

	if not config then
		return { match };
	else
		local output = {};

		if config.corner_left then table.insert(output, { config.corner_left, config.corner_left_hl or config.hl }) end
		if config.padding_left then table.insert(output, { config.padding_left, config.padding_left_hl or config.hl }) end
		if config.icon then table.insert(output, { config.icon, config.icon_hl or config.hl }) end

		table.insert(output, { inner, config.hl });

		if config.padding_right then table.insert(output, { config.padding_right, config.padding_right_hl or config.hl }) end
		if config.corner_right then table.insert(output, { config.corner_right, config.corner_right_hl or config.hl }) end

		return output;
	end

	---|fE
end

---@param buffer integer
---@param text string
---@param base_hl string
---@return [ string, string ][]
adoc_str.tostring = function (buffer, text, base_hl)
	---|fS

	local lpeg = vim.lpeg;
	adoc_str.buffer = buffer;

	local strong_content = lpeg.P("\\*") + ( 1 - lpeg.P("*") );
	local strong = lpeg.C( lpeg.P("*") * strong_content^1 * lpeg.P("*") ) / adoc_str.bold;
	local ustrong = lpeg.C( lpeg.P("**") * strong_content^1 * lpeg.P("**") ) / adoc_str.bold;

	local italic_content = lpeg.P("\\_") + ( 1 - lpeg.P("_") );
	local italic = lpeg.C( lpeg.P("_") * italic_content^1 * lpeg.P("_") ) / adoc_str.italic;
	local uitalic = lpeg.C( lpeg.P("__") * italic_content^1 * lpeg.P("__") ) / adoc_str.italic;

	local mono_content = lpeg.P("\\`") + ( 1 - lpeg.P("`") );
	local mono = lpeg.C( lpeg.P("`")^1 * mono_content^1 * lpeg.P("`")^1 ) / adoc_str.monospace;

	local hl_content = lpeg.P("\\#") + ( 1 - lpeg.P("##") );
	local hl = lpeg.C( lpeg.P("##") * hl_content^1 * lpeg.P("##") ) / adoc_str.highlight;
	local role_content = 1 - lpeg.P("]");
	local chl = lpeg.C( lpeg.P("[") * role_content^1 * lpeg.P("]") * lpeg.P("##") * hl_content^1 * lpeg.P("##") ) / adoc_str.highlight;

	local url_header = lpeg.P("http") + lpeg.P("www");
	local url_char = 1 - lpeg.S(" \t[");
	local url_label_char = 1 - lpeg.P("]");
	local labeled_url = lpeg.C( url_header * url_char^1 * "[" * url_label_char^0 * "]" ) / adoc_str.labeled_url;
	local url = lpeg.C(url_header * url_char^1 ) / adoc_str.url;

	local any = lpeg.C( lpeg.P(1) ) / adoc_str.char;
	local token = labeled_url + url + ustrong + strong + uitalic + italic + mono + chl + hl + any;

	local inline = lpeg.Ct( token^0 );
	local result = {};

	for _, item in ipairs(lpeg.match(inline, text or "")) do
		local last = result[#result];
		item[2] = item[2] or base_hl;

		if (not item[2] or item[2] == base_hl) and last and (not last[2] or last[2] == base_hl) then
			last[1] = last[1] .. item[1];
		else
			if type(item[1]) == "table" then
				result = vim.list_extend(result, item);
			else
				table.insert(result, item)
			end
		end
	end

	return result;

	---|fE
end

return adoc_str;
