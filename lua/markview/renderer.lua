local renderer = {};
local devicons_loaded, devicons = pcall(require, "nvim-web-devicons");
local mini_loaded, MiniIcons = pcall(require, "mini.icons");

--- Checks if a parser is available or not
---@param parser_name string
---@return boolean
local function parser_installed(parser_name)
	return (ts_available and treesitter_parsers.has_parser(parser_name)) or pcall(vim.treesitter.query.get, parser_name, "highlights")
end

local utils = require("markview.utils");
local languages = require("markview.languages");
local latex_renderer = require("markview.latex_renderer");
local html_renderer = require("markview.html_renderer");
local typst_renderer = require("markview.typst_renderer");

local md = require("markview.renderers.markdown")
local inl = require("markview.renderers.markdown_inline")

--- Gets the icon from the language
---@param language string
---@param config_table markview.conf.code_blocks
---@return string Icon
---@return string? Highlight group
---@return string? Sign Highlight group
renderer.get_icon = function (language, config_table)
	if type(config_table.icons) ~= "string" or config_table.icons == "" then
		return "", "Normal";
	end

	if config_table.icons == "devicons" and devicons_loaded then
		return devicons.get_icon(nil, language, { default = true })
	elseif config_table.icons == "mini" and mini_loaded then
		local icon, hl = MiniIcons.get("extension", language);
		return icon, hl;
	elseif config_table.icons == "internal" then
		return languages.get_icon(language);
	end

	return "󰡯", "Normal";
end

local tbl_map = function (value)
	if not vim.islist(value) then
		return value;
	end

	local _o = {
		top = {},
		header = {},
		separator = {},
		row = {},
		bottom = {},

		align_left = nil,
		align_right = nil,
		align_center = {}
	};

	-- / - \ v
	-- > | < +
	-- \ _ / ^
	-- ' ' l r

	for p, part in ipairs(value) do
		if vim.list_contains({ 1, 2, 3, 4 }, p) then
			_o.top[p] = part;

			if p == 2 then
				_o.separator[2] = part;
			end
		elseif p == 5 then
			_o.separator[1] = part;
		elseif p == 6 then
			_o.header[1] = part;
			_o.header[2] = part;
			_o.header[3] = part;

			_o.row[1] = part;
			_o.row[2] = part;
			_o.row[3] = part;
		elseif p == 7 then
			_o.separator[3] = part;
		elseif p == 8 then
			_o.separator[4] = part;
		elseif vim.list_contains({ 9, 10, 11, 12 }, p) then
			_o.bottom[p - 8] = part;
		elseif vim.list_contains({ 13, 14 }, p) then
			_o.align_right[p - 12] = part;
		elseif p == 15 then
			_o.align_left = part;
		else
			_o.align_right = part;
		end
	end

	_o.overlap = _o.separator;
	return _o;
end

renderer.get_link_icon = function (config, text, icon)
	--- Pattern to detect emojis
	local emoji_pattern = "[\227\128\128-\227\128\191\226\128\147-\226\128\154\240\159\152\128-\240\159\152\191\240\160\128\128-\240\191\191\194\128-\244\143\191\191]";

	if config.__emoji_link_compatability ~= false and text:match("^" .. emoji_pattern) then
		return "";
	else
		return icon;
	end
end

--- Returns a value with the specified index from entry
--- If index is nil then return the last value
--- If entry isn't a table then return it
---
---@param entry any
---@param index number
---@return any
local tbl_clamp = function (entry, index)
	if type(entry) ~= "table" then
		return entry;
	end

	if index <= #entry then
		return entry[index];
	end

	return entry[#entry];
end

--- Gets the configuration of a link
---@param conf markview.links.config
---@param text string
---@return any
local get_link_conf = function (conf, text)
	if not conf.custom then
		return conf;
	end

	local _t = conf;

	for _, tbl in ipairs(conf.custom) do
		--- This will be removed in the next update
		---@diagnostic disable-next-line
		if tbl.match and string.match(text, tbl.match) then
			_t = vim.tbl_extend("force", _t, tbl);
		elseif tbl.match_string and string.match(text, tbl.match_string) then
			_t = vim.tbl_extend("force", _t, tbl);
		end
	end

	return _t;
end

local set_hl = function (hl)
	if type(hl) ~= "string" then
		return;
	end

	if vim.fn.hlexists("Markview" .. hl) == 1 then
		return "Markview" .. hl;
	elseif vim.fn.hlexists("Markview_" .. hl) == 1 then
		return "Markview_" .. hl;
	else
		return hl;
	end
end

--- Checks if table border exists on a line
---@param extmark table
---@param config markview.conf.tables
---@return boolean
local isTableBorder = function (extmark, config)
	if not extmark or (not config or config.enable == false) then
		return false;
	end

	local hl = config.parts.bottom;

	for i, v in ipairs(hl) do
		hl[i] = set_hl(v);
	end

	for _, item in ipairs(extmark[4].virt_text) do
		if vim.list_contains(hl, item[1]) then
			return true;
		end
	end

	return false;
end

-- NOTE: Table cells with list chars in a link or image are overindented
local sub_indent_chars = function(text)
	return text:gsub("[+-*]", " ")
end

local display_width = function (text, config)
	local d_width = vim.fn.strdisplaywidth(text);
	local inl_conf = config.inline_codes;

	local final_string = sub_indent_chars(text);

	---@type markview.links.config?
	local lnk_conf = config.links ~= nil and config.links.hyperlinks or nil;
	---@type markview.links.config?
	local int_lnk_conf = config.links ~= nil and config.links.internal_links or nil;
	---@type markview.links.config?
	local img_conf = config.links ~= nil and config.links.images or nil;
	---@type markview.links.config?
	local email_conf = config.links ~= nil and config.links.emails or nil;


	local html_conf = config.html;

	--- Without inline parser inline these syntaxes shouldn't occur
	if not parser_installed("markdown_inline") then
		goto noMdInline;
	end

	for escaped_char in final_string:gmatch("\\([\\%.%*%_%{%}%[%]%<%>%(%)%#%+%-%`%!%|%$])") do
		if config.escaped ~= nil and config.escaped.enable ~= false then
			final_string = final_string:gsub("\\" .. escaped_char, " ");
			d_width = d_width - 1;
		else
			final_string = final_string:gsub("\\" .. escaped_char, "  ");
		end
	end

	for inline_code in final_string:gmatch("`([^`]+)`") do
		d_width = d_width - (vim.fn.strdisplaywidth("`" .. inline_code .. "`"));

		if inl_conf ~= nil and inl_conf.enable ~= false then
			d_width = d_width + vim.fn.strdisplaywidth(table.concat({
				inl_conf.corner_left or "",
				inl_conf.padding_left or "",

				inline_code or "",

				inl_conf.padding_right or "",
				inl_conf.corner_right or ""
			}));

			local escaped = inline_code:gsub("%p", "%%%1");

			final_string = final_string:gsub("`" .. escaped .. "`", table.concat({
				inl_conf.corner_left or "",
				inl_conf.padding_left or "",

				inline_code:gsub(".", "|"),

				inl_conf.padding_right or "",
				inl_conf.corner_right or ""
			}));
		end
	end

	--- Image link(normal)
	for link, address in final_string:gmatch("!%[([^%]]+)%]%(([^%)]+)%)") do
		d_width = d_width - vim.fn.strdisplaywidth("![" .. "](" .. address .. ")");

		if not img_conf or img_conf.enable == false then
			final_string = final_string:gsub("!%[" .. link .. "%]%(" .. address .. "%)", link);
			goto continue;
		end

		local _c = get_link_conf(img_conf, link);

		d_width = d_width + vim.fn.strdisplaywidth(table.concat({
			_c.corner_left or "",
			_c.padding_left or "",
			renderer.get_link_icon(img_conf, link, _c.icon or ""),
			_c.padding_right or "",
			_c.corner_right or ""
		}));

		final_string = final_string:gsub("!%[" .. link .. "%]%(" .. address .. "%)", table.concat({
			_c.corner_left or "",
			_c.padding_left or "",
			renderer.get_link_icon(img_conf, link, _c.icon or ""),
			link,
			_c.padding_right or "",
			_c.corner_right or ""
		}));

		::continue::
	end

	-- Image link: labels
	for link, address in final_string:gmatch("!%[([^%]]+)%]%[([^%)]+)%]") do
		if not img_conf or img_conf.enable == false then
			d_width = d_width - vim.fn.strdisplaywidth("![]");
			final_string = final_string:gsub("!%[" .. link .. "%]%[" .. address .. "%]", link .. "|" .. address .. "|");

			goto continue;
		end

		d_width = d_width - vim.fn.strdisplaywidth("![" .. "][" .. address .. "]");

		local _c = get_link_conf(img_conf, link);

		d_width = d_width + vim.fn.strdisplaywidth(table.concat({
			_c.corner_left or "",
			_c.padding_left or "",
			renderer.get_link_icon(img_conf, link, _c.icon or ""),
			_c.padding_right or "",
			_c.corner_right or ""
		}));

		final_string = final_string:gsub("!%[" .. link .. "%]%[" .. address .. "%]", table.concat({
			_c.corner_left or "",
			_c.padding_left or "",
			renderer.get_link_icon(img_conf, link, _c.icon or ""),
			link,
			_c.padding_right or "",
			_c.corner_right or ""
		}));

		::continue::
	end

	--- Internal links
	--- Alias isn't supported by the parser!
	for link in final_string:gmatch("%[%[(.-)%]%]") do
		d_width = d_width - vim.fn.strdisplaywidth("[[" .. "]]");

		local alias = link:match("^.-|(.+)$")

		if not int_lnk_conf or int_lnk_conf.enable == false then
			final_string = final_string:gsub("%[" .. link .. "%]", "");
			goto continue;
		end

		local cnf = alias and get_link_conf(int_lnk_conf, alias) or int_lnk_conf;

		d_width = d_width + vim.fn.strdisplaywidth(table.concat({
			cnf.corner_left or "",
			cnf.padding_left or "",
			renderer.get_link_icon(int_lnk_conf, link, cnf.icon or ""),
			cnf.padding_right or "",
			cnf.corner_right or ""
		}));

		final_string = final_string:gsub("%[%[" .. link .. "%]%]", table.concat({
			cnf.corner_left or "",
			cnf.padding_left or "",
			renderer.get_link_icon(int_lnk_conf, link, cnf.icon or ""),
			alias or link,
			cnf.padding_right or "",
			cnf.corner_right or ""
		}));

		::continue::
	end

	-- Hyperlinks: normal
	for link, address in final_string:gmatch("%[([^%]]+)%]%(([^%)]+)%)") do
		d_width = d_width - vim.fn.strdisplaywidth("[" .. "](" .. address .. ")");

		if not lnk_conf or lnk_conf.enable == false then
			final_string = final_string:gsub("%[" .. link .. "%]%(" .. address .. "%)", link);
			goto continue;
		end

		local cnf = get_link_conf(lnk_conf, address);

		d_width = d_width + vim.fn.strdisplaywidth(table.concat({
			cnf.corner_left or "",
			cnf.padding_left or "",
			renderer.get_link_icon(lnk_conf, link, cnf.icon or ""),
			cnf.padding_right or "",
			cnf.corner_right or ""
		}));

		final_string = final_string:gsub("%[" .. link .. "%]%(" .. address .. "%)", table.concat({
			cnf.corner_left or "",
			cnf.padding_left or "",
			renderer.get_link_icon(lnk_conf, link, cnf.icon or ""),
			link,
			cnf.padding_right or "",
			cnf.corner_right or ""
		}));

		::continue::
	end

	-- Hyperlink: full_reference_link
	for link, address in final_string:gmatch("%[(.-)%]%[(.-)%]") do
		d_width = d_width - vim.fn.strdisplaywidth("[" .. "][" .. address .. "]");

		if not lnk_conf or lnk_conf.enable == false then
			final_string = final_string:gsub("%[" .. link .. "%]%[" .. address .. "%]", link);
			goto continue;
		end

		local cnf = get_link_conf(lnk_conf, address);

		d_width = d_width + vim.fn.strdisplaywidth(table.concat({
			cnf.corner_left or "",
			cnf.padding_left or "",
			renderer.get_link_icon(lnk_conf, link, cnf.icon or ""),
			cnf.padding_right or "",
			cnf.corner_right or ""
		}));

		final_string = final_string:gsub("%[" .. link .. "%]%[" .. address .. "%]", table.concat({
			cnf.corner_left or "",
			cnf.padding_left or "",
			renderer.get_link_icon(lnk_conf, link, cnf.icon or ""),
			link,
			cnf.padding_right or "",
			cnf.corner_right or ""
		}));

		::continue::
	end

	for pattern in final_string:gmatch("%[([^%]]+)%]") do
		d_width = d_width - 3;
		final_string = final_string:gsub( "[" .. pattern .. "]", pattern);
	end

	for str_a, internal, str_b in final_string:gmatch("([*]+)([^*]+)([*]+)") do
		local min_signs = vim.fn.strdisplaywidth(str_a) > vim.fn.strdisplaywidth(str_b) and vim.fn.strdisplaywidth(str_a) or vim.fn.strdisplaywidth(str_b);

		local start_pos, _ = final_string:find("([*]+)[^*]+([*]+)");

		local c_before = final_string:sub(start_pos - 1, start_pos - 1);

		-- Needs more flexibility
		if c_before == "[" or c_before == "`" then
			goto invalid
		end

		for s = 1, min_signs do
			local a = str_a:sub(s, s);
			local b = str_b:reverse():sub(s, s);

			if a == b then
				d_width = d_width - 2;

				final_string = final_string:gsub(a .. internal .. b, internal);
			end
		end

		::invalid::
	end

	for username, domain, tdl in final_string:gmatch("<([%w._%+-]+)@([%w.-]+)%.([%w.-]+)>") do
		if not email_conf or email_conf.enable == false then
			break;
		end

		d_width = d_width - vim.fn.strdisplaywidth("<" .. ">");

		local _e = get_link_conf(email_conf, username .. "@" .. domain .. "." .. tdl);

		d_width = d_width + vim.fn.strdisplaywidth(table.concat({
			_e.corner_left or "",
			_e.padding_left or "",
			_e.icon or "",
			_e.padding_right or "",
			_e.corner_right or ""
		}));

		final_string = final_string:gsub("<" .. username .. "@" .. domain .. "." .. tdl .. ">", table.concat({
			_e.corner_left or "",
			_e.padding_left or "",
			_e.icon or "",

			username, "@", domain, ".", tdl,

			_e.padding_right or "",
			_e.corner_right or ""
		}));
	end

	::noMdInline::

	--- Without HTML parser these syntaxes shouldn't occur
	if not parser_installed("html") then
		return d_width, vim.fn.strdisplaywidth(text), final_string;
	end

	for entity_name, semicolon in final_string:gmatch("&([%a%d]+)(;?)") do
		if not html_conf or html_conf.enable == false then
			break;
		elseif not html_conf.entities or html_conf.entities.enable == false then
			break;
		end

		local entity = html_renderer.get_entity(entity_name);

		if not entity then
			goto invalid;
		end

		if semicolon then
			final_string = final_string:gsub("&" .. entity_name .. ";", entity);

			d_width = d_width - vim.fn.strdisplaywidth("&" .. entity_name .. ";");
			d_width = d_width + vim.fn.strdisplaywidth(entity);
		else
			final_string = final_string:gsub("&" .. entity_name, entity);

			d_width = d_width - vim.fn.strdisplaywidth("&" .. entity_name);
			d_width = d_width + vim.fn.strdisplaywidth(entity);
		end

		::invalid::
	end

	return d_width, vim.fn.strdisplaywidth(text), final_string;
end


--- Renderer for table headers
---@param buffer integer
---@param content table
---@param config_table markview.configuration
local table_header = function (buffer, content, config_table)
	local tbl_conf = config_table.tables;

	if not tbl_conf.parts or (not tbl_conf.parts.header or not tbl_conf.parts.top) then
		return;
	end

	local top = tbl_conf.parts.top;
	local header = tbl_conf.parts.header;

	local top_hl = tbl_conf.hls.top;
	local header_hl = tbl_conf.hls.header;

	local row_start = content.__r_start or content.row_start;
	local col_start = content.col_start;

	local curr_col = 0;
	local curr_tbl_col = 1;

	local virt_txt = {};

	local above_line = vim.api.nvim_buf_get_lines(buffer, row_start - 1, row_start, false);
	local start_line = vim.api.nvim_buf_get_lines(buffer, row_start, row_start + 1, false);

	--- If a table border is on the current line
	--- we should get it here
	local current = vim.api.nvim_buf_get_extmarks(buffer,
		renderer.namespace,
		{ row_start, math.min(col_start, #start_line[1]) },
		{ row_start, math.min(col_start, #start_line[1]) - 1 },
		{ details = true }
	)[1];

	-- If there's a table border already on the line
	-- delete it
	if above_line[1] then
		local prev = vim.api.nvim_buf_get_extmarks(buffer,
			renderer.namespace,
			{ row_start - 1, math.min(col_start, #above_line[1]) },
			{ row_start - 1, math.min(col_start, #above_line[1]) - 1 },
			{ details = true }
		)[1];

		-- If there's a table border already on the previous line
		-- delete it
		if isTableBorder(prev, tbl_conf) then
			vim.api.nvim_buf_del_extmark(buffer, renderer.namespace, prev[1]);

			if tbl_conf.use_virt_lines == false then
				top = tbl_conf.parts.overlap or tbl_conf.parts.separator;
				top_hl = tbl_conf.hls.overlap or tbl_conf.hls.separator;
			end
		-- If there's a table border already on the current line
		-- delete it
		elseif isTableBorder(current, tbl_conf) then
			vim.api.nvim_buf_del_extmark(buffer, renderer.namespace, current[1]);
		end
	end

	if content.content_positions and content.content_positions[1] then
		col_start = content.content_positions[1].col_start;
	end

	for index, col in ipairs(content.rows[1]) do
		if index == 1 then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start, col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ header[1], set_hl(top_hl[1]) }
				},

				end_col = col_start + 1,
				conceal = ""
			});

			table.insert(virt_txt, { top[1], set_hl(top_hl[1]) })
			curr_col = curr_col + 1
		elseif index == #content.rows[1] then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start, col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ header[3], set_hl(header_hl[3]) }
				},

				end_col = col_start + curr_col + 1,
				conceal = ""
			});

			table.insert(virt_txt, { top[3], set_hl(top_hl[3]) })

			if tbl_conf.block_decorator ~= false and config_table.tables.use_virt_lines == true then
				-- Add extra spaces to match the tables position
				if content.content_positions and content.content_positions[1] then
					table.insert(virt_txt, 1, { string.rep(" ", content.content_positions[1].col_start) })
				end

				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start, 0, {
					virt_lines_above = true,
					virt_lines = {
						virt_txt
					}
				});
			elseif tbl_conf.block_decorator ~= false and row_start > 0 then
				if not above_line[1] then
					goto noAboveLine;
				elseif isTableBorder(current, tbl_conf) then
					goto noAboveLine;
				end

				if vim.fn.strchars(above_line[1]) < col_start then
					table.insert(virt_txt, 1, { string.rep(" ", col_start - vim.fn.strchars(above_line[1])) })
				end

				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start - 1, math.min(col_start, #above_line[1]), {
					virt_text_pos = "inline",
					virt_text = virt_txt
				});

				::noAboveLine::
			end

			curr_col = curr_col + 1
		elseif col == "|" then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start, col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ header[2], set_hl(header_hl[2]) }
				},

				end_col = col_start + curr_col + 1,
				conceal = ""
			});

			table.insert(virt_txt, { top[4], set_hl(top_hl[4]) })
			curr_col = curr_col + 1
		else
			local width, actual_width = display_width(col, config_table);
			local align = content.content_alignments[curr_tbl_col];

			-- Extracted width of separator
			local tbl_col_width = math.max(content.col_widths[curr_tbl_col], tbl_conf.col_min_width or 0);

			-- The column number of headers must match the 
			-- column number of separators
			--
			-- No need to add unnecessary condition
			if tbl_col_width then
				actual_width = math.min(math.max(actual_width, tbl_col_width), tbl_col_width);
			end

			if width < actual_width then
				if align == "left" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start, col_start + curr_col + #col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", (actual_width - width)) }
						}
					});
				elseif align == "right" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start, col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", (actual_width - width)) }
						}
					});
				else
					local before, after = math.floor((actual_width - width) / 2), math.ceil((actual_width - width) / 2);

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start, col_start + curr_col + #col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", after) }
						}
					});

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start, col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", before) }
						}
					});
				end
			end

			table.insert(virt_txt, { string.rep(top[2], actual_width), set_hl(top_hl[2]) })
			curr_col = curr_col + #col;
			curr_tbl_col = curr_tbl_col + 1;
		end
	end
end

--- Renderer for table separator
---@param buffer integer
---@param content table
---@param user_config markview.configuration
---@param r_num integer
local table_seperator = function (buffer, content, user_config, r_num)
	local tbl_conf = user_config.tables;

	if not tbl_conf.parts or not tbl_conf.parts.separator then
		return;
	end

	local separator = tbl_conf.parts.separator;
	local align_left = tbl_conf.parts.align_left;
	local align_right = tbl_conf.parts.align_right;
	local align_center = tbl_conf.parts.align_center;

	local separator_hl = tbl_conf.hls.separator;
	local align_left_hl = tbl_conf.hls.align_left;
	local align_right_hl = tbl_conf.hls.align_right;
	local align_center_hl = tbl_conf.hls.align_center;

	local row_start = content.__r_start or content.row_start;
	local col_start = content.col_start;

	local curr_col = 0;
	local curr_tbl_col = 1;

	if content.content_positions and content.content_positions[r_num] then
		col_start = content.content_positions[r_num].col_start;
	end

	for index, col in ipairs(content.rows[r_num]) do
		if index == 1 then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + (r_num - 1), col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ separator[1], set_hl(separator_hl[1]) }
				},

				end_col = col_start + 1,
				conceal = ""
			});

			curr_col = curr_col + 1;
		elseif index == #content.rows[1] then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + (r_num - 1), col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ separator[3], set_hl(separator_hl[3]) }
				},

				end_col = col_start + curr_col + 1,
				conceal = ""
			});

			curr_col = curr_col + 1;
		elseif col == "|" then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + (r_num - 1), col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ separator[4], set_hl(separator_hl[4]) }
				},

				end_col = col_start + curr_col + 1,
				conceal = ""
			});

			curr_col = curr_col + 1;
		else
			local align = content.content_alignments[curr_tbl_col];
			local tbl_col_width = math.max(content.col_widths[curr_tbl_col], tbl_conf.col_min_width or 0);

			if col:match(":") then
				if align == "left" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + (r_num - 1), col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ align_left, set_hl(align_left_hl) },
							{ string.rep(separator[2], tbl_col_width - 1), set_hl(separator_hl[2]) }
						},

						end_col = col_start + curr_col + vim.fn.strchars(col) + 1,
						conceal = ""
					});
				elseif align == "right" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + (r_num - 1), col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(separator[2], tbl_col_width - 1), set_hl(separator_hl[2]) },
							{ align_right, set_hl(align_right_hl) }
						},

						end_col = col_start + curr_col + vim.fn.strchars(col) + 1,
						conceal = ""
					});
				elseif align == "center" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + (r_num - 1), col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ align_center[1], set_hl(align_center_hl[1]) },
							{ string.rep(separator[2], tbl_col_width - 2), set_hl(separator_hl[2]) },
							{ align_center[2], set_hl(align_center_hl[2]) }
						},

						end_col = col_start + curr_col + vim.fn.strchars(col) + 1,
						conceal = ""
					});
				end
			else
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + (r_num - 1), col_start + curr_col, {
					virt_text_pos = "inline",
					virt_text = {
						{ string.rep(separator[2], tbl_col_width), set_hl(separator_hl[4]) }
					},

					end_col = col_start + curr_col + vim.fn.strchars(col) + 1,
					conceal = ""
				});
			end

			curr_col = curr_col + vim.fn.strchars(col);
			curr_tbl_col = curr_tbl_col + 1;
		end
	end
end

--- Renderer for table footers
---@param buffer integer
---@param content table
---@param config_table markview.configuration
local table_footer = function (buffer, content, config_table)
	local tbl_conf = config_table.tables;

	if not tbl_conf.parts or (not tbl_conf.parts.row or not tbl_conf.parts.bottom) then
		return;
	end

	local row = tbl_conf.parts.row;
	local bottom = tbl_conf.parts.bottom;

	local row_hl = tbl_conf.hls.row;
	local bottom_hl = tbl_conf.hls.bottom;

	local row_end = content.__r_end or content.row_end;
	local col_start = content.col_start;

	local curr_col = 0;
	local curr_tbl_col = 1;

	local virt_txt = {};

	if content.content_positions and content.content_positions[#content.content_positions] then
		col_start = content.content_positions[#content.content_positions].col_start;
	end

	for index, col in ipairs(content.rows[#content.rows]) do
		if index == 1 then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_end - 1, col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ row[1], set_hl(row_hl[1]) }
				},

				end_col = col_start + 1,
				conceal = ""
			});

			table.insert(virt_txt, { bottom[1], set_hl(bottom_hl[1]) })
			curr_col = curr_col + 1
		elseif index == #content.rows[#content.rows] then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_end - 1, col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ row[2], set_hl(row_hl[2]) }
				},

				end_col = col_start + curr_col + 1,
				conceal = ""
			});

			table.insert(virt_txt, { bottom[3], set_hl(bottom_hl[3]) })

			if tbl_conf.block_decorator ~= false and config_table.tables.use_virt_lines == true then
				if content.content_positions and content.content_positions[#content.content_positions] then
					table.insert(virt_txt, 1, { string.rep(" ", content.content_positions[#content.content_positions].col_start) })
				end

				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_end - 1, 0, {
					virt_lines_above = false,
					virt_lines = {
						virt_txt
					}
				});
			elseif tbl_conf.block_decorator ~= false and content.row_start < vim.api.nvim_buf_line_count(buffer) then
				local below_line = vim.api.nvim_buf_get_lines(buffer, row_end, row_end + 1, false);

				if not below_line[1] then
					goto noBelowLine;
				end

				if vim.fn.strchars(below_line[1]) < col_start then
					table.insert(virt_txt, 1, { string.rep(" ", col_start - vim.fn.strchars(below_line[1])) })
				end

				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_end, math.min(col_start, #below_line[1]), {
					virt_text_pos = "inline",
					virt_text = virt_txt
				});

				::noBelowLine::
			end

			curr_col = curr_col + 1
		elseif col == "|" then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_end - 1, col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ row[2], set_hl(row_hl[2]) }
				},

				end_col = col_start + curr_col + 1,
				conceal = ""
			});

			table.insert(virt_txt, { bottom[4], set_hl(bottom_hl[4]) })
			curr_col = curr_col + 1
		else
			local width, actual_width = display_width(col, config_table);
			local align = content.content_alignments[curr_tbl_col];

			-- Extracted width of separator
			local tbl_col_width = math.max(content.col_widths[curr_tbl_col], tbl_conf.col_min_width or 0);

			if #content.rows[#content.rows] == #content.rows[2] and tbl_col_width then
				actual_width = math.min(math.max(actual_width, tbl_col_width), tbl_col_width);
			end

			if width < actual_width then
				if align == "left" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_end - 1, col_start + curr_col + #col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", (actual_width - width)) }
						}
					});
				elseif align == "right" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_end - 1, col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", (actual_width - width)) }
						}
					});
				else
					local before, after = math.floor((actual_width - width) / 2), math.ceil((actual_width - width) / 2);

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_end - 1, col_start + curr_col + #col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", after) }
						}
					});

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_end - 1, col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", before) }
						}
					});
				end
			end

			table.insert(virt_txt, { string.rep(bottom[2], actual_width), set_hl(bottom_hl[2]) })
			curr_col = curr_col + #col;
			curr_tbl_col = curr_tbl_col + 1;
		end
	end
end

--- Renderer for table contents
---@param buffer integer
---@param content table
---@param config_table markview.configuration
---@param r_num integer
local table_content = function (buffer, content, config_table, r_num)
	local tbl_conf = config_table.tables;

	if not tbl_conf.parts or (not tbl_conf.parts.row or not tbl_conf.parts.bottom) then
		return;
	end

	local row = tbl_conf.parts.row;
	local row_hl = tbl_conf.hls.row;

	local row_start = content.__r_start or content.row_start;
	local col_start = content.col_start;

	local curr_col = 0;
	local curr_tbl_col = 1;

	if content.content_positions and content.content_positions[r_num] then
		col_start = content.content_positions[r_num].col_start;
	end

	for index, col in ipairs(content.rows[r_num]) do
		if index == 1 then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + r_num - 1, col_start, {
				virt_text_pos = "inline",
				virt_text = {
					{ row[1], set_hl(row_hl[1]) }
				},

				end_col = col_start + 1,
				conceal = ""
			});

			curr_col = curr_col + 1
		elseif index == #content.rows[1] then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + r_num - 1, col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ row[3], set_hl(row_hl[3]) }
				},

				end_col = col_start + curr_col + 1,
				conceal = ""
			});

			curr_col = curr_col + 1
		elseif col == "|" then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + r_num - 1, col_start + curr_col, {
				virt_text_pos = "inline",
				virt_text = {
					{ row[2], set_hl(row_hl[2]) }
				},

				end_col = col_start + curr_col + 1,
				conceal = ""
			});

			curr_col = curr_col + 1
		else
			local width, actual_width = display_width(col, config_table);
			local align = content.content_alignments[curr_tbl_col];

			-- Extracted width of separator
			local tbl_col_width = math.max(content.col_widths[curr_tbl_col], tbl_conf.col_min_width or 0);

			if #content.rows[r_num] == #content.rows[2] and tbl_col_width then
				actual_width = math.min(math.max(actual_width, tbl_col_width), tbl_col_width);
			end

			if width < actual_width then
				if align == "left" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + r_num - 1, col_start + curr_col + #col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", (actual_width - width)) }
						}
					});
				elseif align == "right" then
					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + r_num - 1, col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", (actual_width - width)) }
						}
					});
				else
					local before, after = math.floor((actual_width - width) / 2), math.ceil((actual_width - width) / 2);

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + r_num - 1, col_start + curr_col + #col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", after) }
						}
					});

					vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, row_start + r_num - 1, col_start + curr_col, {
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", before) }
						}
					});
				end
			end

			curr_col = curr_col + #col;
			curr_tbl_col = curr_tbl_col + 1;
		end
	end
end

renderer.namespace = vim.api.nvim_create_namespace("markview");
latex_renderer.namespace = renderer.namespace;
html_renderer.namespace = renderer.namespace;
typst_renderer.namespace = renderer.namespace;

renderer.views = {};

--- Renderer for custom headings
---@param buffer number
---@param content any
---@param config markview.conf.headings
renderer.render_headings = function (buffer, content, config)
	if not config or config.enable == false then
		return;
	end

	---@type (markview.h.simple | markview.h.label | markview.h.icon)
	local conf = config["heading_" .. content.level] or {};
	local shift = config.shift_width or vim.bo[buffer].shiftwidth;

	-- Do not proceed if config doesn't exist for a heading
	if not conf then
		return;
	end

	if conf.style == "simple" then
		-- Adds a simple background
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			undo_restore = false, invalidate = true,

			line_hl_group = set_hl(conf.hl),

			hl_mode = "combine"
		});
	elseif conf.style == "label" then
		local conceal_start = string.match(content.line, "^[#]+(%s)");
		local line_length = #content.line;

		local spaces = shift * (content.level - 1);

		if conf.align then
			if conf.align == "left" then
				spaces = 0;
			elseif conf.align == "center" then
				local win = utils.find_attached_wins(buffer)[1] or vim.api.nvim_get_current_win();
				local textoff = config.textoff or vim.fn.getwininfo(win)[1].textoff;

				local w = vim.api.nvim_win_get_width(win) - textoff;

				local t = vim.fn.strdisplaywidth(table.concat({
					conf.corner_left or "",
					conf.padding_left or "",
					conf.icon or "",

					content.title,

					conf.padding_right or "",
					conf.corner_right or "",
				}));

				spaces = math.floor((w - t) / 2);
			else
				local win = utils.find_attached_wins(buffer)[1] or vim.api.nvim_get_current_win();
				local textoff = config.textoff or vim.fn.getwininfo(win)[1].textoff;

				local w = vim.api.nvim_win_get_width(win) - textoff;

				local t = vim.fn.strdisplaywidth(table.concat({
					conf.corner_left or "",
					conf.padding_left or "",
					conf.icon or "",

					content.title,

					conf.padding_right or "",
					conf.corner_right or "",
				}));

				spaces = w - t;
			end
		end

		-- Heading rules
		-- 1. Must start at the first column
		-- 2. Must have 1 space between the marker and the title
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ string.rep(" ", spaces) },

				{ conf.corner_left or "", set_hl(conf.corner_left_hl) or set_hl(conf.hl) },
				{ conf.padding_left or "", set_hl(conf.padding_left_hl) or set_hl(conf.hl) },
				{ conf.icon or "", set_hl(conf.icon_hl) or set_hl(conf.hl) }
			},

			sign_text = conf.sign, sign_hl_group = set_hl(conf.sign_hl),
			hl_mode = "combine",

			end_col = content.level + vim.fn.strchars(conceal_start),
			conceal = ""
		});

		vim.api.nvim_buf_add_highlight(buffer, renderer.namespace, set_hl(conf.hl), content.row_start, 0, line_length);

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, line_length, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "overlay",
			virt_text = {
				{ conf.padding_right or "", set_hl(conf.padding_right_hl) or set_hl(conf.hl) },
				{ conf.corner_right or "", set_hl(conf.corner_right_hl) or set_hl(conf.hl) }
			},

			hl_mode = "combine"
		});
	elseif conf.style == "icon" then
		local conceal_start = string.match(content.line, "^[#]+(%s*)");

		-- Heading rules
		-- 1. Must start at the first column
		-- 2. Must have 1 space between the marker and the title
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ string.rep(conf.shift_char or " ", shift * (content.level - 1)), set_hl(conf.shift_hl) },

				{ conf.icon or "", set_hl(conf.icon_hl) or set_hl(conf.hl) },
			},

			sign_text = conf.sign, sign_hl_group = set_hl(conf.sign_hl),
			line_hl_group = set_hl(conf.hl),
			hl_mode = "combine",

			end_col = content.level + vim.fn.strchars(conceal_start),
			conceal = ""
		});
	end
end

--- Renders setext headings
---@param buffer integer
---@param content table
---@param config markview.conf.headings
renderer.render_headings_s = function (buffer, content, config)
	if not config or config.enable == false then
		return;
	end

	---@type markview.h.decorated | markview.h.simple
	local conf = content.marker:match("=") and config["setext_1"] or config["setext_2"];

	-- Do not proceed if setext headings don't have configuration
	if not conf then
		return;
	end

	if conf.style == "simple" then
		-- Adds a simple background

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			undo_restore = false, invalidate = true,

			line_hl_group = set_hl(conf.hl),

			hl_mode = "combine",
			end_row = content.row_end - 1
		});
	elseif conf.style == "decorated" or conf.style == "github" then
		local mid = math.floor((content.row_end - content.row_start - 2) / 2);

		for i = 0, (content.row_end - content.row_start) - 1 do
			if i == mid then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + i, content.col_start, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{ conf.icon or "", set_hl(conf.icon_hl or conf.hl) }
					},

					sign_text = conf.sign, sign_hl_group = set_hl(conf.sign_hl),
					line_hl_group = set_hl(conf.hl),
					hl_mode = "combine",
				});
			elseif i < (content.row_end - content.row_start) - 1 then
				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + i, content.col_start, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{ string.rep(" ", vim.fn.strchars(conf.icon or "")), set_hl(conf.hl) }
					},

					line_hl_group = set_hl(conf.hl),
					hl_mode = "combine",
				});
			else
				local line = content.marker:match("=") and (conf.border or conf.line or "=") or (conf.border or conf.line or "-");

				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + i, content.col_start, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "overlay",
					virt_text = {
						{ string.rep(line, vim.o.columns), set_hl(conf.border_hl or conf.line_hl or conf.hl) }
					},

					line_hl_group = set_hl(conf.hl),
					hl_mode = "combine",
				});
			end
		end
	end
end

--- Renderer for custom code blocks
---@param buffer number
---@param content any
---@param config_table markview.conf.code_blocks
renderer.render_code_blocks = function (buffer, content, config_table)
	if not config_table or config_table.enable == false then
		return;
	end

	local language = languages.get_ft(content.language);
	local icon, hl, sign_hl = renderer.get_icon(language, config_table);
	local sign = icon;

	icon = icon or "";

	if icon ~= "" and not icon:match("(%s)$") then
		icon = icon .. " ";
	end

	icon = " " .. icon;

	local languageName;

	if config_table.language_names ~= nil then
		for match, replace in pairs(config_table.language_names) do
			if language == match then
				languageName = replace;
				goto nameFound;
			end
		end
	end

	languageName = languages.get_name(language)
	::nameFound::

	if config_table.style == "simple" then
		if config_table.language_direction == nil or config_table.language_direction == "left" then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ icon, set_hl(hl or config_table.hl) },
					{ languageName .. " ", set_hl(config_table.language_hl or hl or config_table.hl) },
				},

				line_hl_group = set_hl(config_table.info_hl or config_table.hl),

				sign_text = config_table.sign == true and sign or nil,
				sign_hl_group = set_hl(config_table.sign_hl or sign_hl or hl),
			});
		elseif config_table.language_direction == "right" then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + vim.fn.strchars(content.info_string), {
				undo_restore = false, invalidate = true,

				virt_text_pos = "right_align",
				virt_text = {
					{ " ", set_hl(config_table.hl) },
					{ icon, set_hl(hl or config_table.hl) },
					{ languageName .. " ", set_hl(config_table.language_hl or hl or config_table.hl) },
					{ " ", set_hl(config_table.hl) },
				},

				line_hl_group = set_hl(config_table.info_hl or config_table.hl),

				sign_text = config_table.sign == true and sign or nil,
				sign_hl_group = set_hl(config_table.sign_hl or sign_hl or hl)
			});
		end

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + 1, content.col_start, {
			line_hl_group = set_hl(config_table.hl),

			-- NOTE: The node actually ends in the next line after the code block
			end_row = content.row_end - 1, end_col = content.col_end
		});
	elseif config_table.style == "minimal" or config_table.style == "block" or config_table.style == "language" then
		local block_length = content.largest_line;

		if type(config_table.min_width) == "number" and config_table.min_width > block_length then
			block_length = config_table.min_width
		end

		local lang_width = vim.fn.strchars(icon .. languageName .. " ");

		if config_table.language_direction == nil or config_table.language_direction == "left" then
			local rendered_info = vim.fn.strcharpart(content.block_info or "", 0, block_length - lang_width + ((config_table.pad_amount or 1) * 2) - 4);

			if content.block_info ~= "" and vim.fn.strchars(content.block_info) > (block_length - lang_width - ((content.pad_amount or 1) * 2)) then
				rendered_info = rendered_info .. "...";
			end

			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
				undo_restore = false, invalidate = true,

				end_col = content.col_start + vim.fn.strchars(content.info_string),
				conceal = ""
			});

			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + vim.fn.strlen(content.language), {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ icon, set_hl(hl or config_table.hl) },
					{ languageName .. " ", set_hl(config_table.language_hl or hl or config_table.hl) },
					{ string.rep(config_table.pad_char or " ", block_length - lang_width - 1 - vim.fn.strchars(rendered_info) + ((config_table.pad_amount or 1) * 2)), set_hl(config_table.hl) },
					{ rendered_info, set_hl(config_table.info_hl or config_table.hl) },
					{ config_table.pad_char or " ", set_hl(config_table.hl) },
				},

				sign_text = config_table.sign == true and sign or nil,
				sign_hl_group = set_hl(config_table.sign_hl or sign_hl or hl),
			});
		elseif config_table.language_direction == "right" then
			local rendered_info = vim.fn.strcharpart(content.block_info or "", 0, block_length - lang_width + ((config_table.pad_amount or 1) * 2) - 4);

			if content.block_info ~= "" and vim.fn.strchars(content.block_info) > (block_length - lang_width - ((content.pad_amount or 1) * 2)) then
				rendered_info = rendered_info .. "...";
			end

			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
				undo_restore = false, invalidate = true,

				end_col = content.col_start + vim.fn.strchars(content.info_string),
				conceal = ""
			});

			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + vim.fn.strchars(content.info_string), {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ rendered_info, set_hl(config_table.info_hl or config_table.hl) },
					{ string.rep(config_table.pad_char or " ", block_length - lang_width - vim.fn.strchars(rendered_info) + ((config_table.pad_amount or 1) * 2)), set_hl(config_table.hl) },
					{ icon, set_hl(hl or config_table.hl) },
					{ languageName .. " ", set_hl(config_table.language_hl or hl or config_table.hl) },
				},

				sign_text = config_table.sign == true and sign or nil,
				sign_hl_group = set_hl(config_table.sign_hl or sign_hl or hl)
			});
		end

		-- The text on the final line
		-- We need to get the tail section to see if it contains ``` 
		local block_end_line = vim.api.nvim_buf_get_lines(buffer, content.row_end - 1, content.row_end, false)[1];

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end - 1, vim.fn.strchars(block_end_line or ""), {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ string.rep(config_table.pad_char or " ", (block_length) + ((config_table.pad_amount or 1) * 2)), set_hl(config_table.hl) },
			},

			hl_mode = "combine",
		});

		-- NOTE: The last line with ``` doesn't need this so we don't add it to that line
		for line, text in ipairs(content.lines) do
			-- NOTE: Nested code blocks have a different start position
			local length = content.line_lengths[line] - content.col_start;
			local position = #text;

			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + line, math.min(content.col_start, position), {
				undo_restore = false, invalidate = true,

				hl_group = set_hl(config_table.hl),

				end_row = content.row_start + line,
				end_col = #text,
			});

			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + line, position, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config_table.pad_char or " ", block_length - math.max(0, length)), set_hl(config_table.hl) },
					{ string.rep(config_table.pad_char or " ", config_table.pad_amount or 1), set_hl(config_table.hl) }
				}
			})

			-- NOTE: If the line is smaller than the start position of the code block then subtract it
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + line, length < 0 and content.col_start + length or content.col_start, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config_table.pad_char or " ", text == "" and content.col_start or 0) },
					{ string.rep(config_table.pad_char or " ", config_table.pad_amount or 1), set_hl(config_table.hl) }
				}
			})
		end
	end
end

--- Renderer for the custom block quotes
---@param buffer integer
---@param content table
---@param config_table markview.conf.block_quotes
renderer.render_block_quotes = function (buffer, content, config_table)
	local qt_config;

	if not config_table or config_table.enable == false then
		return;
	end

	if content.callout ~= nil then
		for _, callout in ipairs(config_table.callouts) do
			if type(callout.match_string) == "string" and string.upper(callout.match_string --[[@as string]]) == content.callout:upper() then
				qt_config = callout;
			elseif vim.islist(callout.match_string) then
				for _, alias in ipairs(callout.match_string --[[@as string[] ]]) do
					if type(alias) == "string" and alias:upper() == content.callout:upper() then
						qt_config = callout;
					end
				end
			end
		end

		if qt_config == nil then
			qt_config = config_table.default;
		end
	else
		qt_config = config_table.default;
	end

	-- Config for a block quote is not available
	if not qt_config then
		return;
	end

	local list_clamp = function (val, index)
		if not vim.islist(val) then
			return set_hl(val);
		end

		return set_hl(val[math.min(#val, index)]);
	end

	if (qt_config.title == true or qt_config.custom_title) and content.title ~= "" then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ tbl_clamp(qt_config.border, 1), list_clamp(qt_config.hl or qt_config.border_hl, 1) },
				{ " " },
				{ qt_config.icon or qt_config.custom_icon, list_clamp(qt_config.preview_hl or qt_config.callout_preview_hl or qt_config.hl, 1) },
			},

			end_col = content.col_start + vim.fn.strdisplaywidth(">[!" .. content.callout .. "]"),
			conceal = ""
		});

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			hl_group = list_clamp(qt_config.hl or qt_config.preview_hl or qt_config.callout_preview_hl or qt_config.hl, 1),
			end_col = #content.lines[1],
		});
	elseif qt_config.preview ~= nil or qt_config.callout_preview ~= nil then
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ tbl_clamp(qt_config.border, 1), list_clamp(qt_config.hl or qt_config.border_hl, 1) },
				{ " " },
				{ qt_config.preview or qt_config.callout_preview, list_clamp(qt_config.preview_hl or qt_config.hl or qt_config.callout_preview_hl, 1) },
			},

			end_col = content.line_width,
			conceal = ""
		});
	else
		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ tbl_clamp(qt_config.border, 1), list_clamp(qt_config.hl or qt_config.border_hl, 1) },
			},

			end_col = content.col_start + vim.fn.strchars(tbl_clamp(qt_config.border or "", 1)),
			conceal = ""
		});
	end

	for line = 1, content.row_end - content.row_start - 1 do
		local end_col = content.col_start;

		-- NOTE: If the line is smaller than the border then use the lines width
		if vim.fn.strchars(tbl_clamp(qt_config.border, 1)) > vim.fn.strchars(content.lines[line]) then
			end_col = end_col + vim.fn.strchars(content.lines[line])
		else
			end_col = end_col + vim.fn.strchars(tbl_clamp(qt_config.border, 1));
		end

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start + line, content.col_start, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ tbl_clamp(qt_config.border, line + 1), list_clamp(qt_config.hl or qt_config.border_hl, line + 1) }
			},

			end_col = end_col,
			conceal = "",

			hl_mode = "combine"
		});
	end
end

--- Renders custom horizontal rules
---@param buffer integer
---@param content table
---@param config_table markview.conf.hrs
renderer.render_horizontal_rules = function (buffer, content, config_table)
	local virt_text = {};

	if not config_table or config_table.enable == false then
		return;
	end

	for _, part in ipairs(config_table.parts or {}) do
		if part.type == "repeating" then
			local repeat_time = 0;

			if type(part.repeat_amount) == "function" and pcall(part.repeat_amount --[[@as function]], buffer) then
				repeat_time = part.repeat_amount(buffer);
			elseif type(part.repeat_amount) == "number" then
				repeat_time = part.repeat_amount --[[@as number]];
			end

			if part.direction == "left" or part.direction == nil then
				for r = 1, repeat_time do
					table.insert(virt_text, {
						tbl_clamp(part.text or "─", r),
						set_hl(tbl_clamp(part.hl, r))
					})
				end
			else
				for r = 1, repeat_time do
					table.insert(virt_text, {
						-- NOTE: The value can't be 0
						tbl_clamp(part.text or "─", (repeat_time - r) + 1),
						set_hl(tbl_clamp(part.hl, (repeat_time - r) + 1))
					})
				end
			end

		elseif part.type == "text" then
			table.insert(virt_text, {
				part.text, set_hl(part.hl)
			})
		end
	end

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
		virt_text_pos = "overlay",
		virt_text = virt_text,

		end_col = vim.fn.strchars(content.text),
		conceal = ""
	});
end

--- Renderer for custom links
---@param buffer integer
---@param content table
---@param config_table markview.conf.links
renderer.render_links = function (buffer, content, config_table)
	if not config_table or config_table.enable == false then
		return;
	elseif config_table and config_table.hyperlinks and config_table.hyperlinks.enable == false then
		return;
	end

	local lnk_conf = config_table.hyperlinks;

	for _, conf in ipairs(config_table.hyperlinks.custom or {}) do
		--- TODO, Remove this in the next update
		---@diagnostic disable-next-line
		if conf.match and string.match(content.address or "", conf.match) then
			lnk_conf = vim.tbl_extend("force", lnk_conf or {}, conf);
			break;
		elseif conf.match_string and string.match(content.address or "", conf.match_string) then
			lnk_conf = vim.tbl_extend("force", lnk_conf or {}, conf);
			break;
		end
	end

	-- Do not render links with no config
	if not lnk_conf then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + 1, {
		virt_text_pos = "inline",
		virt_text = {
			{ lnk_conf.corner_left or "", set_hl(lnk_conf.corner_left_hl) or set_hl(lnk_conf.hl) },
			{ lnk_conf.padding_left or "", set_hl(lnk_conf.padding_left_hl) or set_hl(lnk_conf.hl) },
			{ renderer.get_link_icon(lnk_conf, content.text, lnk_conf.icon or ""), set_hl(lnk_conf.icon_hl) or set_hl(lnk_conf.hl) },
		},

		end_col = content.col_start,
		conceal = ""
	});

	vim.api.nvim_buf_add_highlight(buffer, renderer.namespace, set_hl(lnk_conf.hl) or "", content.row_start, content.col_start, content.col_end);

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end, content.col_end, {
		virt_text_pos = "inline",
		virt_text = {
			{ lnk_conf.padding_right or "", set_hl(lnk_conf.padding_right_hl) or set_hl(lnk_conf.hl) },
			{ lnk_conf.corner_right or "", set_hl(lnk_conf.corner_right_hl) or set_hl(lnk_conf.hl) },
		},

		end_col = content.col_start,
		conceal = ""
	});
end

--- Renderer for custom links
---@param buffer integer
---@param content table
---@param config_table markview.conf.links
renderer.render_internal_links = function (buffer, content, config_table)
	if not config_table or config_table.enable == false then
		return;
	elseif config_table and config_table.internal_links and config_table.internal_links.enable == false then
		return;
	end

	local lnk_conf = config_table.internal_links;

	for _, conf in ipairs(config_table.internal_links.custom or {}) do
		--- TODO, Remove this in the next update
		---@diagnostic disable-next-line
		if conf.match and string.match(content.alias or "", conf.match) then
			lnk_conf = vim.tbl_extend("force", lnk_conf or {}, conf);
			break;
		elseif conf.match_string and string.match(content.alias or "", conf.match_string) then
			lnk_conf = vim.tbl_extend("force", lnk_conf or {}, conf);
			break;
		end
	end

	-- Do not render links with no config
	if not lnk_conf then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start - 1, {
		virt_text_pos = "inline",
		virt_text = {
			{ lnk_conf.corner_left or "", set_hl(lnk_conf.corner_left_hl) or set_hl(lnk_conf.hl) },
			{ lnk_conf.padding_left or "", set_hl(lnk_conf.padding_left_hl) or set_hl(lnk_conf.hl) },
			{ renderer.get_link_icon(lnk_conf, content.text, lnk_conf.icon or ""), set_hl(lnk_conf.icon_hl) or set_hl(lnk_conf.hl) },
		},

		end_col = content.alias and (content.col_end - (#content.alias + 1)) or (content.col_start + 1),
		conceal = ""
	});

	vim.api.nvim_buf_add_highlight(buffer, renderer.namespace, set_hl(lnk_conf.hl) or "", content.row_start, content.col_start, content.col_end);

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end, content.col_end - 1, {
		virt_text_pos = "inline",
		virt_text = {
			{ lnk_conf.padding_right or "", set_hl(lnk_conf.padding_right_hl) or set_hl(lnk_conf.hl) },
			{ lnk_conf.corner_right or "", set_hl(lnk_conf.corner_right_hl) or set_hl(lnk_conf.hl) },
		},

		end_col = content.col_end + 1,
		conceal = ""
	});
end
--- Renderer for custom emails
---@param buffer integer
---@param content table
---@param config_table markview.conf.links
renderer.render_email_links = function (buffer, content, config_table)
	if not config_table or config_table.enable == false then
		return;
	elseif config_table and config_table.emails and config_table.emails.enable == false then
		return;
	end

	local email_conf = config_table.emails;

	for _, conf in ipairs(config_table.emails.custom or {}) do
		--- TODO, Remove this in the next update
		---@diagnostic disable-next-line
		if conf.match and string.match(content.address or "", conf.match) then
			email_conf = vim.tbl_extend("force", email_conf or {}, conf);
			break;
		elseif conf.match_string and string.match(content.address or "", conf.match_string) then
			email_conf = vim.tbl_extend("force", email_conf or {}, conf);
			break;
		end
	end

	if not email_conf then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
		virt_text_pos = "inline",
		virt_text = {
			{ email_conf.corner_left or "", set_hl(email_conf.corner_left_hl) or set_hl(email_conf.hl) },
			{ email_conf.padding_left or "", set_hl(email_conf.padding_left_hl) or set_hl(email_conf.hl) },
			{ email_conf.icon or "", set_hl(email_conf.icon_hl) or set_hl(email_conf.hl) },
		},

		end_col = content.col_start + 1,
		conceal = ""
	});

	vim.api.nvim_buf_add_highlight(buffer, renderer.namespace, set_hl(email_conf.hl) or "", content.row_start, content.col_start, content.col_end);

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end, content.col_end - 1, {
		virt_text_pos = "inline",
		virt_text = {
			{ email_conf.padding_right or "", set_hl(email_conf.padding_right_hl) or set_hl(email_conf.hl) },
			{ email_conf.corner_right or "", set_hl(email_conf.corner_right_hl) or set_hl(email_conf.hl) },
		},

		end_col = content.col_end,
		conceal = ""
	});
end

--- Renderer for custom image links
---@param buffer number
---@param content any
---@param config_table markview.conf.links
renderer.render_img_links = function (buffer, content, config_table)
	if not config_table or config_table.enable == false then
		return;
	elseif config_table and config_table.images and config_table.images.enable == false then
		return;
	end

	local img_conf = config_table.images;

	for _, conf in ipairs(config_table.images.custom or {}) do
		--- TODO, Remove this in the next update
		---@diagnostic disable-next-line
		if conf.match and string.match(content.address or "", conf.match) then
			img_conf = vim.tbl_extend("force", img_conf or {}, conf);
			break;
		elseif conf.match_string and string.match(content.address or "", conf.match_string) then
			img_conf = vim.tbl_extend("force", img_conf or {}, conf);
			break;
		end
	end


	if not img_conf then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + 1, {
		virt_text_pos = "inline",
		virt_text = {
			{ img_conf.corner_left or "", set_hl(img_conf.corner_left_hl) or set_hl(img_conf.hl) },
			{ img_conf.padding_left or "", set_hl(img_conf.padding_left_hl) or set_hl(img_conf.hl) },
			{ renderer.get_link_icon(img_conf, content.text, img_conf.icon or ""), set_hl(img_conf.icon_hl) or set_hl(img_conf.hl) },
		},

		end_col = content.col_start,
		conceal = ""
	});

	vim.api.nvim_buf_add_highlight(buffer, renderer.namespace, set_hl(img_conf.hl) or "", content.row_start, content.col_start, content.col_end);

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_end, content.col_end - vim.fn.strchars(content.address), {
		virt_text_pos = "inline",
		virt_text = {
			{ img_conf.padding_right or "", set_hl(img_conf.padding_right_hl) or set_hl(img_conf.hl) },
			{ img_conf.corner_right or "", set_hl(img_conf.corner_right_hl) or set_hl(img_conf.hl) },
		},

		end_col = content.col_end,
		conceal = ""
	});
end

--- Renderer for custom inline codes
---@param buffer integer
---@param content table
---@param config_table markview.conf.inline_codes
renderer.render_inline_codes = function (buffer, content, config_table)
	if not config_table or config_table.enable == false then
		return;
	end

	-- NOTE: The ` are hidden by default
	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start + 1, {
		virt_text_pos = "inline",
		virt_text = {
			{ config_table.corner_left or "", set_hl(config_table.corner_left_hl) or set_hl(config_table.hl) },
			{ config_table.padding_left or "", set_hl(config_table.padding_left_hl) or set_hl(config_table.hl) },
		},
	});

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
		hl_group = set_hl(config_table.hl),
		end_col = content.col_end
	});


	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_end - 1, {
		virt_text_pos = "inline",
		virt_text = {
			{ config_table.padding_right or "", set_hl(config_table.padding_right_hl) or set_hl(config_table.hl) },
			{ config_table.corner_right or "", set_hl(config_table.corner_right_hl) or set_hl(config_table.hl) },
		},
	});
end

--- Renderer for custom image links
---@param buffer integer
---@param content table
---@param config_table markview.conf.list_items
renderer.render_lists = function (buffer, content, config_table)
	if not config_table or config_table.enable == false then
		return;
	end

	local ls_conf = {};

	if string.match(content.marker_symbol, "-") then
		ls_conf = config_table.marker_minus or {};
	elseif string.match(content.marker_symbol, "+") then
		ls_conf = config_table.marker_plus or {};
	elseif string.match(content.marker_symbol, "*") then
		ls_conf = config_table.marker_star or {};
	elseif string.match(content.marker_symbol, "[%.]") then
		ls_conf = config_table.marker_dot or {};
	elseif string.match(content.marker_symbol, "[%)]") then
		ls_conf = config_table.marker_parenthesis or {};
	end

	-- Do not render list types with no configuration
	if not ls_conf then
		return;
	end

	local use_text = ls_conf.text or content.marker_symbol;

	if ls_conf.add_padding == true then
		local shift = config_table.shift_width or vim.bo[buffer].shiftwidth;

		for l, line in ipairs(content.list_lines) do
			local line_num = content.row_start + (l - 1);
			local before = content.spaces[l] or 0;

			if vim.list_contains(content.list_candidates, l) and l == 1 then
				local conceal_end = content.col_start + vim.fn.strchars(content.marker_symbol) - 1;
				local offset = 0;

				if content.marker_symbol:match("^%d+") then
					conceal_end = (content.starts[l] or 0) + vim.fn.strchars(content.list_lines[1]:match("^%s*"));
					use_text = "";
				end

				if content.is_checkbox == true then
					conceal_end = content.col_start + vim.fn.strchars(content.marker_symbol);
					use_text = "";
				end

				local level = math.floor(before / (config_table.indent_size or 2)) + 1;

				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, line_num, content.starts[l] or 0, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{ string.rep(" ", (level * shift) - offset) },
						{ vim.trim(use_text), set_hl(ls_conf.hl) or "Special" }
					},

					end_col = conceal_end,
					conceal = ""
				})
			elseif vim.list_contains(content.list_candidates, l) then
				local line_len = vim.fn.strchars(line);

				local level = math.floor(before / (config_table.indent_size or 2)) + 1;

				vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, line_num, content.starts[l] or 0, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{ string.rep(" ", level * shift) },
						{ string.rep(" ", content.align_spaces[l] or 0) },
					},

					end_col = line_len < before and line_len + (content.align_spaces[l] or 0) or before + (content.align_spaces[l] or 0),
					conceal = ""
				})
			end
		end
	else
		local start = content.starts[1] or 0;
		local before = content.spaces[1] or 0;

		if content.is_checkbox == true then
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, start + before, {
				undo_restore = false, invalidate = true,

				end_col = start + before + vim.fn.strdisplaywidth(content.marker_symbol),
				conceal = ""
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, start + before, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "overlay",
				virt_text = {
					{ vim.trim(use_text), set_hl(ls_conf.hl) or "Special" }
				}
			});
		end
	end
end

--- Renderer for custom checkbox
---@param buffer number
---@param content any
---@param config_table markview.conf.checkboxes
renderer.render_checkboxes = function (buffer, content, config_table)
	if not config_table or config_table.enable == false then
		return;
	end

	local chk_config = {};

	if content.state == "complete" then
		chk_config = config_table.checked;
	elseif content.state == "incomplete" then
		chk_config = config_table.unchecked;
	elseif vim.islist(config_table.custom) then
		for _, config in ipairs(config_table.custom) do
			---@diagnostic disable-next-line
			if content.state == config.match then
				chk_config = config;
			elseif content.state == config.match_string then
				chk_config = config;
			end
		end
	end

	if not chk_config or type(chk_config.text) ~= "string" then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
		undo_restore = false, invalidate = true,

		virt_text_pos = "inline",
		virt_text = {
			{ chk_config.text, set_hl(chk_config.hl) }
		},

		end_col = content.col_end,
		conceal = "",

		hl_mode = "combine"
	});

	if not chk_config.scope_hl or not content.list_item then
		return;
	end

	for l = content.list_item.row_start, content.list_item.row_end - 1 do
		local col_start = content.col_start;

		if l == content.list_item.row_start then
			col_start = content.col_end + 1;
		end

		vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, l, col_start, {
			undo_restore = false, invalidate = true,

			end_col = #content.list_item.list_lines[l - content.list_item.row_start + 1],

			hl_group = chk_config.scope_hl,
		});
	end
end

--- Renderer for custom table
---@param buffer number
---@param content any
---@param user_config markview.configuration
renderer.render_tables = function (buffer, content, user_config)
	if not user_config.tables or user_config.tables.enable == false then
		return;
	end

	user_config.tables.parts = tbl_map(user_config.tables.parts or user_config.tables.text);
	user_config.tables.hls = tbl_map(user_config.tables.hls or user_config.tables.hl);

	for row_number, _ in ipairs(content.rows) do
		if content.row_type[row_number] == "header" then
			pcall(table_header, buffer, content, user_config);
		elseif content.row_type[row_number] == "separator" then
			pcall(table_seperator, buffer, content, user_config, row_number)
		elseif content.row_type[row_number] == "content" and row_number == #content.rows then
			pcall(table_footer, buffer, content, user_config)
		else
			pcall(table_content, buffer, content, user_config, row_number)
		end
	end
end

--- Renders escaped characters
---@param buffer integer
---@param content table
---@param user_config { enable: boolean }
renderer.render_escaped = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
		end_col = content.col_start + #"\\",
		conceal = ""
	});
end

--- Footnote renderer
---@param buffer integer
---@param content table 
---@param user_config markview.conf.footnotes
renderer.render_footnotes = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	local _o = content.text:match("%^(.+)$");

	if user_config.superscript ~= false and _o:match("^([%s%a%d%(%)%+%-%=]+)$") then
		local tmp = "";

		for letter in _o:gmatch(".") do
			tmp = tmp .. latex_renderer.superscripts[letter];
		end

		_o = tmp;
	end

	vim.api.nvim_buf_set_extmark(buffer, renderer.namespace, content.row_start, content.col_start, {
		virt_text_pos = "inline",
		virt_text = {
			{ _o, set_hl(user_config.hl) }
		},

		end_col = content.col_end,
		conceal = ""
	});
end

--- Renders things
---@param buffer integer
---@param parsed_content table[]
---@param config_table markview.configuration
---@param conceal_start? integer
---@param conceal_stop? integer
renderer.render = function (buffer, parsed_content, config_table, conceal_start, conceal_stop)
	-- vim.print(parsed_content)
	inl.render(buffer, parsed_content.markdown_inline, config_table)
	md.render(buffer, parsed_content.markdown, config_table)
end

--- Clears a namespace within the range in a buffer
---@param buffer integer
---@param from? integer
---@param to? integer
renderer.clear = function (buffer, from, to)
	if vim.api.nvim_buf_is_valid(buffer) == false then
		return;
	end

	vim.api.nvim_buf_clear_namespace(buffer, md.ns, from or 0, to or -1)
	vim.api.nvim_buf_clear_namespace(buffer, inl.ns, from or 0, to or -1)
	vim.api.nvim_buf_clear_namespace(buffer, renderer.namespace, from or 0, to or -1)
end

renderer.get_content_range = function (parsed_content)
	local max_range = { nil, nil };

	for _, content in ipairs(parsed_content) do
		if not max_range[1] or (content.row_start) < max_range[1] then
			max_range[1] = content.row_start;
		end

		if not max_range[2] or (content.row_end) > max_range[2] then
			max_range[2] = content.row_end;
		end
	end

	if not max_range[1] or not max_range[2] then
		return;
	end

	if max_range[1] == max_range[2] then
		max_range[2] = max_range[2] + 1;
	end

	return max_range;
end

return renderer;
