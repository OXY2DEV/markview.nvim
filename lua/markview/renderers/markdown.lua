local markdown = {};
local inline = require("markview.renderers.markdown_inline");

local spec = require("markview.spec");
local utils = require("markview.utils");
local languages = require("markview.languages");
local entities = require("markview.entities");

local devicons_loaded, devicons = pcall(require, "nvim-web-devicons");
local mini_loaded, MiniIcons = pcall(require, "mini.icons");

local function tbl_clamp(value, index)
	if vim.islist(value) == false then
		return value;
	elseif index > #value then
		return value[#value];
	end

	return value[index];
end

local get_config = function (opt)
	return spec.get("markdown", opt);
end

markdown.custom_config = function (config, value)
	if not config.custom or not value then
		return config;
	end

	for _, custom in ipairs(config.custom) do
		if custom.match_string and value:match(custom.match_string) then
			return vim.tbl_deep_extend("force", config, custom);
		end
	end

	return config;
end

markdown.get_icon = function (icons, ft)
	if type(icons) ~= "string" or icons == "" then
		return "", "Normal";
	end

	if icons == "devicons" and devicons_loaded then
		return devicons.get_icon(nil, ft, { default = true })
	elseif icons == "mini" and mini_loaded then
		return MiniIcons.get("extension", ft);
	elseif icons == "internal" then
		return languages.get_icon(ft);
	end

	return "󰡯", "Normal";
end

markdown.output = function (str)
	local function config(opt)
		local conf = spec.get("markdown_inline");

		if not conf or conf.enable == false then
			return;
		elseif not conf[opt] or conf[opt].enable == false then
			return;
		end

		return conf[opt];
	end

	local concat = function (list, test)
		for i, item in ipairs(list) do
			list[i] = utils.escape_string(item);
		end

		return table.concat(list);
	end

	--- Inline codes config
	local codes = config("inline_codes");
	local hyper = config("hyperlinks");
	local image = config("images");
	local email = config("emails");
	local embed = config("embed_files");
	local blref = config("block_references");
	local int = config("internal_links");
	local uri = config("uri_autolinks");
	local esc = config("escapes");
	local ent = config("entities");

	for escaped in str:gmatch("\\(%$)") do
		if not esc then
			break;
		end

		str = str:gsub(concat({
			"\\",
			escaped
		}), " ");
	end

	for latex in str:gmatch("%$([^%$]*)%$") do
		---+${custom, Handle LaTeX blocks}
		str = str:gsub(concat({
			"$",
			latex,
			"$"
		}), concat({
			"$",
			utils.escape_string(latex):gsub(".", " "),
			"$"
		}));
		---_
	end

	for escaped in str:gmatch("\\(.)") do
		if not esc then
			break;
		end

		str = str:gsub(concat({
			"\\",
			escaped
		}), " ");
	end

	for inline_code in str:gmatch("`(.-)`") do
		---+${custom, Handle inline codes}
		if not codes or codes.enable == false then
			str = str:gsub(concat({
				"`",
				inline_code,
				"`"
			}), concat({ content }));
		else
			str = str:gsub(concat({
				"`",
				inline_code,
				"`"
			}), concat({
				codes.corner_left or "",
				codes.padding_left or "",
				inline_code:gsub(".", " "),
				codes.padding_right or "",
				codes.corner_left or ""
			}));
		end
		---_
	end

	for ref in str:gmatch("%!%[%[([^%]]+)%]%]") do
		---+${custom, Handle embed files & block references}
		if ref:match("%#%^(.+)") and blref then
			local _blref = markdown.custom_config(blref, ref);

			str = str:gsub(concat({
				"![[",
				ref,
				"]]"
			}), concat({
				_blref.corner_left or "",
				_blref.padding_left or "",
				_blref.icon or "",
				ref:gsub(".", "X"),
				_blref.padding_right or "",
				_blref.corner_right or ""
			}));
		elseif embed then
			local _embed = markdown.custom_config(embed, ref);

			str = str:gsub(concat({
				"![[",
				ref,
				"]]"
			}), concat({
				_embed.corner_left or "",
				_embed.padding_left or "",
				_embed.icon or "",
				ref:gsub(".", "X"),
				_embed.padding_right or "",
				_embed.corner_right or ""
			}));
		end
		---_
	end

	for link in str:gmatch("%[%[([^%]]+)%]%]") do
		---+${custom, Handle internal links}
		if not int then
			str = str:gsub(concat({
				"[[",
				link,
				"]]"
			}), concat({
				"0",
				(alias or link):gsub(".", "X"),
				"0"
			}));
		else
			local alias = link:match("%|(.+)$");
			local _int = markdown.custom_config(int, address);

			str = str:gsub(concat({
				"[[",
				link,
				"]]"
			}), concat({
				_int.corner_left or "",
				_int.padding_left or "",
				_int.icon or "",
				(alias or link):gsub(".", "X"),
				_int.padding_right or "",
				_int.corner_right or ""
			}));
		end
		---_
	end

	for link, address in str:gmatch("%!%[([^%)]*)%]([%(%[][^%)]*[%)%]])") do
		---+${custom, Handle image links}
		if not image then
			str = str:gsub(concat({
				"![",
				link,
				"]",
				address,
			}), concat({ link }))
		else
			local _image = markdown.custom_config(image, address:gsub("[%[%]%(%)]", ""));

			str = str:gsub(concat({
				"![",
				link,
				"]",
				address
			}), concat({
				_image.corner_left or "",
				_image.padding_left or "",
				_image.icon or "",
				utils.escape_string(link):gsub("[^%[%]]", "X"),
				_image.padding_right or "",
				_image.corner_right or ""
			}))
		end
		---_
	end

	for link in str:gmatch("%!%[([^%)]*)%]") do
		---+${custom, Handle image links without address}
		if not image then
			str = str:gsub(concat({
				"![",
				link,
				"]",
			}), concat({ link }))
		else
			local _t = link:gsub(".", function (h)
				if h == "["  or h == "]" then
					return h;
				end

				return "X";
			end);

			str = str:gsub(concat({
				"![",
				link,
				"]",
			}), concat({
				image.corner_left or "",
				image.padding_left or "",
				image.icon or "",
				_t,
				image.padding_right or "",
				image.corner_right or ""
			}))
		end
		---_
	end

	for link, address in str:gmatch("%[([^%)]*)%]([%(%[][^%)]*[%)%]])") do
		---+${custom, Handle hyperlinks}
		if not hyper then
			str = str:gsub(concat({
				"[",
				link,
				"]",
				address
			}), concat({ link }))
		else
			local _hyper = markdown.custom_config(hyper, address:gsub("[%[%]%(%)]", ""));

			str = str:gsub(concat({
				"[",
				link,
				"]",
				address
			}), concat({
				_hyper.corner_left or "",
				_hyper.padding_left or "",
				_hyper.icon or "",
				utils.escape_string(link):gsub("[^%[%]]", "X"),
				_hyper.padding_right or "",
				_hyper.corner_right or ""
			}));
		end
		---_
	end

	for link in str:gmatch("%[([^%)]+)%]") do
		---+${custom, Handle shortcut links}
		if not hyper then
			str = str:gsub(concat({
				"[",
				link,
				"]",
			}), concat({ link }))
		else
			str = str:gsub(concat({
				"[",
				link,
				"]",
			}), concat({
				hyper.corner_left or "",
				hyper.padding_left or "",
				hyper.icon or "",
				utils.escape_string(link):gsub("[^%[%]]", "X"),
				hyper.padding_right or "",
				hyper.corner_right or ""
			}));
		end
		---_
	end

	for address, domain in str:gmatch("%<([^%s%@]-)@(%S+)%>") do
		---+${custom, Handle emails}
		if not email then
			break;
		end

		local _email = markdown.custom_config(email, address .. "@" .. domain);

		str = str:gsub("%<" .. address .. "%@" .. domain .. "%>", concat({
			_email.corner_left or "",
			_email.padding_left or "",
			_email.icon or "",
			utils.escape_string(address):gsub(".", "X"),
			"Y",
			utils.escape_string(domain):gsub(".", "X"),
			_email.padding_right or "",
			_email.corner_left or ""
		}));
		---_
	end

	for address in str:gmatch("%<(%S+)%>") do
		---+${custom, Handle uri autolinks}
		if not uri then
			break;
		elseif not address:match("^ht") and not address:match("%:%/%/") then
			goto continue;
		end

		local _uri = markdown.custom_config(uri, address);

		str = str:gsub(concat({
			"<",
			address,
			">"
		}), concat({
			_uri.corner_left or "",
			_uri.padding_left or "",
			_uri.icon or "",
			utils.escape_string(address):gsub(".", "X"),
			_uri.padding_right or "",
			_uri.corner_left or ""
		}));

	    ::continue::
		---_
	end

	for str_b, content, str_a in str:gmatch("([*]+)(.-)([*]+)") do
		---+${custom, Handle italics & bold text}
		if content == "" then
			goto continue;
		elseif #str_b ~= #str_a then
			local min = math.min(#str_b, #str_a);
			str_b = str_b:sub(0, min);
			str_a = str_a:sub(0, min);
		end

		str_b = utils.escape_string(str_b);
		content = utils.escape_string(content);
		str_a = utils.escape_string(str_a);

		str = str:gsub(str_b .. content .. str_a, content);

	    ::continue::
		---_
	end

	for striked in str:gmatch("%~%~(.-)%~%~") do
		---+${custom, Handle strike-through text}
		str = str:gsub(concat({
			"~~",
			striked,
			"~~"
		}), concat({ striked }));
		---_
	end

	for entity in str:gmatch("%&([%d%a%#]+);") do
		---+${custom, Handle entities}
		if not ent then
			break;
		elseif not entities.get(entity:gsub("%#", "")) then
			goto continue;
		end

		str = str:gsub(concat({
			"&",
			entity,
			";"
		}), concat({
			entities.get(entity:gsub("%#", ""))
		}));

	    ::continue::
		---_
	end

	return str;
end

markdown.concealed = function (str)
	for code in str:gmatch("`(.-)`") do
		str = str:gsub("`" .. utils.escape_string(code) .. "`", string.rep("X", vim.fn.strchars(code)));
	end

	for str_b, content, str_a in str:gmatch("([*]+)(.-)([*]+)") do
		if content == "" then
			goto continue
		elseif #str_b ~= #str_a then
			local min = math.min(#str_b, #str_a);
			str_b = str_b:sub(0, min);
			str_a = str_a:sub(0, min);
		end

		str_b = utils.escape_string(str_b);
		content = utils.escape_string(content);
		str_a = utils.escape_string(str_a);

		str = str:gsub(str_b .. content .. str_a, content);

	    ::continue::
	end

	for link in str:gmatch("%[(.-)%]") do
		str = str:gsub("%[" .. utils.escape_string(link) .. "%]", utils.escape_string(link));
	end

	return str;
end

markdown.__ns = {
	__call = function (self, key)
		return self[key] or self.default;
	end
}

markdown.ns = {
	default = vim.api.nvim_create_namespace("markview/markdown"),
};
setmetatable(markdown.ns, markdown.__ns)

markdown.set_ns = function ()
	local ns_pref = get_config("use_seperate_ns");
	if not ns_pref then ns_pref = true; end

	local available = vim.api.nvim_get_namespaces();
	local ns_list = {
		["block_quotes"] = "markview/markdown/block_quotes",
		["code_blocks"] = "markview/markdown/code_blocks",
		["list_items"] = "markview/markdown/list_items",
		["metadatas"] = "markview/markdown/metadatas",
		["headings"] = "markview/markdown/headings",
		["tables"] = "markview/markdown/tables",
	};

	if ns_pref == true then
		for ns, name in pairs(ns_list) do
			if vim.list_contains(available, ns) == false then
				markdown.ns[ns] = vim.api.nvim_create_namespace(name);
			end
		end
	end
end

markdown.atx_heading = function (buffer, item)
	---+${func, Renders ATX headings}
	local config = get_config("headings");

	if not config then
		return;
	elseif not config["heading_" .. #item.marker] then
		return;
	end

	local range = item.range;
	config = config["heading_" .. #item.marker];

	if config.style == "simple" then
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns("headings"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			line_hl_group = utils.set_hl(config.hl)
		});
	elseif config.style == "label" then
		local space = "";

		if config.align then
			local win = vim.fn.win_findbuf(buffer)[1];
			local res = markdown.output(item.text[1]):gsub("^#+%s", "");

			local wid = vim.fn.strdisplaywidth(table.concat({
				config.corner_left or "",
				config.padding_left or "",

				config.icon or "",
				res,

				config.padding_right or "",
				config.corner_right or "",
			}));

			local w_wid = vim.api.nvim_win_get_width(win or 0) - vim.fn.getwininfo(win or 0)[1].textoff;

			if config.align == "left" then
				space = "";
			elseif config.align == "center" then
				space = string.rep(" ", math.floor((w_wid - wid) / 2));
			elseif config.align == "right" then
				space = string.rep(" ", w_wid - wid);
			end
		else
				space = string.rep(" ", #item.marker * (get_config("headings").shift_width or 1));
		end

		vim.api.nvim_buf_set_extmark(buffer, markdown.ns("headings"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + #item.marker + 1,
			conceal = "",
			sign_text = config.sign,
			sign_hl_group = utils.set_hl(config.sign_hl),
			virt_text_pos = "inline",
			virt_text = {
				{ space },
				{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
				{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

				{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) },
			},

			hl_mode = "combine"
		});

		vim.api.nvim_buf_set_extmark(buffer, markdown.ns("headings"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_row = range.row_end,
			end_col = range.col_end,
			hl_group = utils.set_hl(config.hl)
		});

		vim.api.nvim_buf_set_extmark(buffer, markdown.ns("headings"), range.row_start, range.col_end, {
			undo_restore = false, invalidate = true,
			conceal = "",
			virt_text_pos = "inline",
			virt_text = {
				{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) },
				{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) }
			},

			hl_mode = "combine"
		});
	elseif config.style == "icon" then
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns("headings"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + #item.marker + 1,
			conceal = "",
			sign_text = config.sign,
			sign_hl_group = utils.set_hl(config.sign_hl),
			virt_text_pos = "inline",
			virt_text = {
				{ string.rep(" ", #item.marker * (get_config("headings").shift_width or 1)) },
				{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) },
			},
			line_hl_group = utils.set_hl(config.hl),

			hl_mode = "combine"
		});
	end
	---_
end

markdown.block_quote = function (buffer, item)
	---+${func, Renders Block quotes & Callouts/Alerts}
	local config = get_config("block_quotes");
	local range = item.range;

	if not config then
		return;
	end

	config = config.default or {};

	for _, callout in ipairs(get_config("block_quotes").callouts or {}) do
		if item.callout and callout.match_string:lower() == item.callout:lower() then
			config = callout;
			break;
		end
	end

	if item.callout then
		if item.title and config.title == true then
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("block_quotes"), range.row_start, range.callout_start, {
				end_col = range.callout_end,
				conceal = "",
				undo_restore = false, invalidate = true,
				virt_text_pos = "inline",
				virt_text = {
					{ " " },
					{ config.icon, utils.set_hl(config.icon_hl or config.hl) }
				},

				hl_mode = "combine",
			});

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("block_quotes"), range.row_start, range.title_start, {
				end_col = range.title_end,
				undo_restore = false, invalidate = true,
				hl_group = utils.set_hl(config.hl),

				hl_mode = "combine",
			});
		elseif config.preview then
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("block_quotes"), range.row_start, range.callout_start, {
				end_col = range.callout_end,
				conceal = "",
				undo_restore = false, invalidate = true,
				virt_text_pos = "inline",
				virt_text = {
					{ " " },
					{ config.preview, utils.set_hl(config.preview_hl or config.hl) }
				},

				hl_mode = "combine",
			});
		end
	end

	for l = range.row_start, range.row_end - 1, 1  do
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns("block_quotes"), l, range.col_start, {
			end_col = math.min(range.col_start + 1, #item.text[(l - range.row_start) + 1]),
			conceal = "",
			undo_restore = false, invalidate = true,
			virt_text_pos = "inline",
			virt_text = {
				{ tbl_clamp(config.border, (l - range.row_start) + 1), utils.set_hl(tbl_clamp(config.border_hl or config.hl, (l - range.row_start) + 1)) }
			},

			hl_mode = "combine",
		});
	end
	---_
end

markdown.checkbox = function (buffer, item)
	--- Wrapper for the inline checkbox renderer function
	inline.checkbox(buffer, item)
end

markdown.code_block = function (buffer, item)
	---+${func, Renders Code blocks}
	local config = get_config("code_blocks");
	local range = item.range;

	if not config then
		return;
	end

	local ft = languages.get_ft(item.language);
	local icon, hl, sign_hl = markdown.get_icon(config.icons, ft);

	local sign = (config.icon or icon);
	sign_hl = utils.set_hl(config.sign_hl or sign_hl)

	if icon and not icon:match("(%s)$") then
		icon = " " .. icon .. " ";
	elseif not icon then
		icon = "";
	end

	local lang_name;

	--- In case the user changes the name ALWAYS prioritize
	--- user-defined names over the default ones.
	if config.language_names ~= nil then
		--- It may be faster to use {key: value} instead,
		--- TODO: Use key value pairs instead.
		for match, replace in pairs(config.language_names) do
			if ft == match then
				lang_name = replace;
				goto nameFound;
			end
		end
	end

	lang_name = languages.get_name(ft)

	::nameFound::

	if config.style == "simple" then
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start, range.col_start, {
			end_col = range.col_start + item.text[1]:len(),
			conceal = "",
		});

		if config.language_direction == nil or config.language_direction == "left" then
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start, range.col_start, {
				end_col = range.end_col,
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ " ", utils.set_hl(config.hl) },
					{ icon, utils.set_hl(hl or config.hl) },
					{ lang_name .. " ", utils.set_hl(config.language_hl or hl or config.hl) },
				},

				line_hl_group = utils.set_hl(config.info_hl or config.hl),

				sign_text = config.sign == true and sign or nil,
				sign_hl_group = utils.set_hl(config.sign_hl or sign_hl or hl),
			});
		elseif config.language_direction == "right" then
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start, range.col_start + vim.fn.strchars(range.info_string), {
				undo_restore = false, invalidate = true,

				virt_text_pos = "right_align",
				virt_text = {
					{ " ", utils.set_hl(config.hl) },
					{ icon, utils.set_hl(hl or config.hl) },
					{ lang_name, utils.set_hl(config.language_hl or hl or config.hl) },
					{ " ", utils.set_hl(config.hl) },
				},

				line_hl_group = utils.set_hl(config.info_hl or config.hl),

				sign_text = config.sign == true and sign or nil,
				sign_hl_group = utils.set_hl(config.sign_hl or sign_hl or hl)
			});
		end


		--- NOTE: Don't highlight extra line after the closing ```
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start + 1, range.col_start, {
			line_hl_group = utils.set_hl(config.hl),
			end_row = range.row_end - 1, end_col = range.col_end
		});

		vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_end - 1, range.col_start, {
			end_col = range.col_start + #item.text[#item.text],
			conceal = "",
			undo_restore = false, invalidate = true
		});
	elseif config.style == "block" then
		local pad_amount = config.pad_amount or 0;
		local block_width = config.min_width - (2 * pad_amount);

		--- Get maximum length of the lines within the code block
		for l, line in ipairs(item.text) do
			if (l ~= 1 and l ~= #item.text) and vim.fn.strdisplaywidth(line) > block_width then
				block_width = vim.fn.strdisplaywidth(line);
			end
		end

		local preview = utils.virt_len({
			{ icon, utils.set_hl(hl or config.hl) },
			{ lang_name, utils.set_hl(config.language_hl or hl or config.hl) },
		});

		if config.language_direction == nil or config.language_direction == "left" then
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start, range.col_start, {
				end_col = range.col_start + range.lang_end,
				conceal = "",
				undo_restore = false, invalidate = true,
			});
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start, range.col_start + range.lang_end, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ config.pad_char or " ", utils.set_hl(config.hl) },
					{ icon, utils.set_hl(hl or config.hl) },
					{ lang_name, utils.set_hl(config.language_hl or hl or config.hl) },
				},

				sign_text = config.sign == true and sign or nil,
				sign_hl_group = utils.set_hl(config.sign_hl or sign_hl or hl),
			});

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start, range.col_start, {
				end_col = range.col_start + item.text[1]:len(),
				hl_group = utils.set_hl(config.info_hl or config.hl),
				undo_restore = false, invalidate = true,
			});

			if item.info_string then
				if (preview + vim.fn.strdisplaywidth(item.info_string)) >= block_width then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start, (range.col_start + range.info_start) + 1 + (block_width - (pad_amount + preview)), {
						end_col = range.col_start + item.text[1]:len(),
						conceal = "",
						undo_restore = false, invalidate = true,
					});
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start, range.col_start + item.text[1]:len(), {
						undo_restore = false, invalidate = true,

						virt_text_pos = "inline",
						virt_text = {
							{ "…", utils.set_hl(config.hl) },
							{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
							{ string.rep(config.pad_char or " ", pad_amount - 1), utils.set_hl(config.hl) }
						},
					});
				else
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start, range.col_start + range.info_end, {
						undo_restore = false, invalidate = true,

						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(config.pad_char or " ", (block_width - (preview + 1 + #item.info_string))), utils.set_hl(config.hl) },
							{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
							{ string.rep(config.pad_char or " ", pad_amount - 1), utils.set_hl(config.hl) }
						},
					});
				end
			else
				vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start, range.col_start, {
					undo_restore = false, invalidate = true,
					end_col = range.col_start + item.text[1]:len(),
					conceal = "",
				});

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start, range.col_start + item.text[1]:len(), {
					undo_restore = false, invalidate = true,
					virt_text_pos = "inline",
					virt_text = {
						{ string.rep(config.pad_char or " ", block_width - (1 + preview)), utils.set_hl(config.hl) },
						{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
						{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
					}
				});
			end
		elseif config.language_direction == "right" then
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start, range.col_start, {
				end_col = range.col_start + (range.info_start or range.lang_end),
				conceal = "",
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) }
				},

				sign_text = config.sign == true and sign or nil,
				sign_hl_group = utils.set_hl(config.sign_hl or sign_hl or hl),
			});

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start, range.col_start, {
				end_col = range.col_start + item.text[1]:len(),
				hl_group = utils.set_hl(config.info_hl or config.hl),
				undo_restore = false, invalidate = true,
			});

			if item.info_string then
				if (preview + 1 + vim.fn.strdisplaywidth(item.info_string)) >= block_width then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start, (range.col_start + range.info_start) + 1 + (block_width - (pad_amount + preview)), {
						undo_restore = false, invalidate = true,
						end_col = range.col_start + item.text[1]:len(),
						conceal = "",
					});

					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start, range.col_start + range.info_end, {
						undo_restore = false, invalidate = true,

						virt_text_pos = "inline",
						virt_text = {
							{ "…", utils.set_hl(config.info_hl or config.hl) },
							{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
							{ icon, utils.set_hl(hl or config.hl) },
							{ lang_name, utils.set_hl(config.language_hl or hl or config.hl) },
							{ config.pad_char or " ", utils.set_hl(config.hl) },
						},
					});
				else
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start, range.col_start + range.info_end, {
						undo_restore = false, invalidate = true,

						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(config.pad_char or " ", pad_amount + (block_width - (preview + 1 + #item.info_string))), utils.set_hl(config.hl) },
							{ icon, utils.set_hl(hl or config.hl) },
							{ lang_name, utils.set_hl(config.language_hl or hl or config.hl) },
							{ config.pad_char or " ", utils.set_hl(config.hl) },
						},
					});
				end
			else
				vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start, range.col_start, {
					undo_restore = false, invalidate = true,
					end_col = range.col_start + item.text[1]:len(),
					conceal = "",
				});

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_start, range.col_start + item.text[1]:len(), {
					undo_restore = false, invalidate = true,
					virt_text_pos = "inline",
					virt_text = {
						{ string.rep(config.pad_char or " ", block_width - (1 + preview)), utils.set_hl(config.hl) },
						{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
						{ icon, utils.set_hl(hl or config.hl) },
						{ lang_name, utils.set_hl(config.language_hl or hl or config.hl) },
						{ config.pad_char or " ", utils.set_hl(config.hl) },
					}
				});
			end
		end

		vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_end - 1, range.col_start, {
			end_col = range.col_start + #item.text[#item.text],
			conceal = "",
			undo_restore = false, invalidate = true
		});
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), range.row_end - 1, range.col_start + #item.text[#item.text], {
			undo_restore = false, invalidate = true,
			virt_text_pos = "inline",
			virt_text = {
				{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) },
				{ string.rep(config.pad_char or " ", block_width), utils.set_hl(config.hl) },
				{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) }
			}
		});

		for l = range.row_start + 1, range.row_end - 2, 1 do
			local line = item.text[(l + 1) - range.row_start];
			local final = line;

			if ft == "md" then
				final = markdown.concealed(line);
			end

			--- Left padding
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), l, range.col_start, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) }
				},
			});

			--- Right padding
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), l, range.col_start + #line, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(config.pad_char or " ", block_width - vim.fn.strdisplaywidth(final)), utils.set_hl(config.hl) },
					{ string.rep(config.pad_char or " ", pad_amount), utils.set_hl(config.hl) }
				},
			});

			--- Background color
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("code_blocks"), l, range.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + #line,
				hl_group = utils.set_hl(config.hl)
			});
		end
	end
	---_
end

markdown.list_item = function (buffer, item)
	---+${func, Renders List items}
	local config = get_config("list_items");
	local checkbox;
	local range = item.range;

	if not config then
		return;
	end

	if not item.checkbox or not spec.get("markdown_inline", "checkboxes") then
		goto continue;
	elseif spec.get("markdown_inline", "checkboxes", "enable") == false then
		goto continue;
	end

	if item.checkbox == "X" or item.checkbox == "x" then
		checkbox = spec.get("markdown_inline", "checkboxes", "checked");
	elseif item.checkbox == " " then
		checkbox = spec.get("markdown_inline", "checkboxes", "unchecked");
	else
		---@diagnostic disable-next-line
		for _, conf in ipairs(spec.get("markdown_inline", "checkboxes", "custom") or {}) do
			if conf.match_string == item.checkbox then
				checkbox = conf;
				break;
			end
		end
	end

	::continue::

	local shift_width, indent_size = config.shift_width, config.indent_size;

	if item.marker == "-" then
		config = config.marker_minus;
	elseif item.marker == "+" then
		config = config.marker_plus;
	elseif item.marker == "*" then
		config = config.marker_star;
	elseif item.marker:match("%d+%.") then
		config = config.marker_dot;
	elseif item.marker:match("%d+%)") then
		config = config.marker_parenthasis;
	end

	if not config then
		return;
	end

	if config.add_padding then
		for _, l in ipairs(item.candidates) do
			local from, to = range.col_start, range.col_start + item.indent;

			if item.text[l + 1]:len() < to then
				to = from;
			end

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("list_items"), range.row_start + l, from, {
				undo_restore = false, invalidate = true,
				end_col = to,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(" ", (math.floor(item.indent / indent_size) + 1) * shift_width) }
				}
			});
		end
	end

	if checkbox and config.conceal_on_checkboxes == true then
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns("list_items"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + (item.indent + #item.marker + 1),
			conceal = ""
		});

		if not checkbox.scope_hl then
			return;
		end

		for l, line in ipairs(item.text) do
			if l == 1 then
				vim.api.nvim_buf_set_extmark(buffer, markdown.ns("list_items"), range.row_start, range.col_start + (item.indent + #item.marker + 5), {
					undo_restore = false, invalidate = true,
					end_col = #item.text[1],

					hl_group = utils.set_hl(checkbox.scope_hl)
				});
			elseif line ~= "" then
				local spaces = line:match("^([%>%s]*)");

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns("list_items"), range.row_start + (l - 1), #spaces, {
					undo_restore = false, invalidate = true,
					end_col = #item.text[l],

					hl_group = utils.set_hl(checkbox.scope_hl)
				});
			end
		end
	elseif item.marker:match("[%+%-%*]") then
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns("list_items"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + (item.indent + 1),
			conceal = "",

			virt_text_pos = "inline",
			virt_text = {
				{ config.text, utils.set_hl(config.hl) }
			},

			hl_mode = "combine"
		});
	end
	---_
end

markdown.metadata_minus = function (buffer, item)
	---+${Renders, Renders YAML metadata blocks}
	local config = get_config("metadata_minus");
	local range = item.range;

	if not config then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, markdown.ns("metadatas"), range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end - 1,
		end_col = #item.text[#item.text],
		conceal = "|",

		line_hl_group = utils.set_hl(config.hl)
	});
	---_
end

markdown.metadata_plus = function (buffer, item)
	---+${func, Renders TOML metadata blocks}
	local config = get_config("metadata_minus");
	local range = item.range;

	if not config then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, markdown.ns("metadatas"), range.row_start, range.col_start, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end - 1,
		end_col = #item.text[#item.text],
		conceal = "|",

		line_hl_group = utils.set_hl(config.hl)
	});
	---_
end

markdown.setext_heading = function (buffer, item)
	---+${func, Renders Setext headings}
	local config = get_config("headings");
	local lvl = item.marker:match("%=") and 1 or 2;

	if not config then
		return;
	elseif not config["setext_" .. lvl] then
		return;
	end

	local range = item.range;
	config = config["setext_" .. lvl];

	if config.style == "simple" then
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns("headings"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_row = range.row_end,
			end_col = range.col_end,
			line_hl_group = utils.set_hl(config.hl)
		});
	elseif config.style == "decorated" then
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns("headings"), range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_row = range.row_end - 1,
			end_col = range.col_end,
			line_hl_group = utils.set_hl(config.hl)
		});

		if config.border then
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("headings"), range.row_end - 1, range.col_start, {
				undo_restore = false, invalidate = true,
				end_row = range.row_end - 1,
				end_col = range.col_end,
				line_hl_group = utils.set_hl(config.hl),
				virt_text_pos = "overlay",
				virt_text = {
					{
						string.rep(config.border or config.line, vim.o.columns),
						utils.set_hl(config.border_hl or config.line_hl or config.hl)
					}
				},

				hl_mode = "combine",
			});
		end
	end
	---_
end

markdown.table = function (buffer, item)
	---+${func, Renders Tables}
	local config = get_config("tables");
	local range = item.range;

	if not config then
		return;
	end

	local col_widths = {};
	local visible_texts = {
		header = {},
		rows = {}
	};

	---+${custom, Get the width of the column(s)}
	local c = 1;

	---+${custom, Calculate heading column widths}
	for _, col in ipairs(item.header) do
		if col.class == "column" then
			local o = markdown.output(col.text);
			table.insert(visible_texts.header, o);
			o = vim.fn.strdisplaywidth(o);

			if not col_widths[c] or col_widths[c] < o then
				col_widths[c] = o;
			end

			c = c + 1;
		end
	end
	---_

	---+${custom, Calculate separator column widths}
	c = 1;

	for _, col in ipairs(item.separator) do
		if col.class == "column" then
			local o = vim.fn.strdisplaywidth(col.text);

			if not col_widths[c] or col_widths[c] < o then
				col_widths[c] = o;
			end

			c = c + 1;
		end
	end
	---_

	---+${custom, Calculate various row's column widths}
	for r, row in ipairs(item.rows) do
		c = 1;
		table.insert(visible_texts.rows, {})

		for _, col in ipairs(row) do
			if col.class == "column" then
				local o = markdown.output(col.text);
				table.insert(visible_texts.rows[r], o);
				o = vim.fn.strdisplaywidth(o);

				if not col_widths[c] or col_widths[c] < o then
					col_widths[c] = o;
				end

				c = c + 1;
			end
		end
	end
	---_
	---_

	local parts = config.parts;
	local hls = config.hl;

	local function get_border(from, index)
		if not parts or not parts[from] then
			return "", nil;
		end

		local hl;

		if hls and hls[from] then
			hl = hls[from][index];
		end

		return parts[from][index], hl;
	end

	local function bottom_part (index)
		if config.block_decorator == true and
			config.use_virt_lines == false and
			item.border_overlap == true
		then
			return get_border("overlap", index)
		end

		return get_border("bottom", index)
	end

	c = 1;
	local tmp = {};

	for p, part in ipairs(item.header) do
		if part.class == "separator" then
			---+${custom, Handle | in the header}
			local border, border_hl = get_border("header", 2);
			local top, top_hl = get_border("top", 4);

			if p == 1 then
				border, border_hl = get_border("header", 1);
				top, top_hl = get_border("top", 1);
			elseif p == #item.header then
				border, border_hl = get_border("header", 3);
				top, top_hl = get_border("top", 3);
			end

			table.insert(tmp, { top, utils.set_hl(top_hl) });

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start, range.col_start + part.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + part.col_end,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ border, utils.set_hl(border_hl) }
				},

				hl_mode = "combine"
			})

			if p == #item.header and config.block_decorator == true then
				local prev_line = range.row_start == 0 and 0 or #vim.api.nvim_buf_get_lines(buffer, range.row_start - 1, range.row_start, false)[1];

				if config.use_virt_lines == true then
					table.insert(tmp, 1, { string.rep(" ", range.col_start) });
				elseif range.row_start > 0 and prev_line < range.col_start then
					table.insert(tmp, 1, { string.rep(" ", range.col_start - prev_line) });
				end

				if config.use_virt_lines == true then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start, range.col_start, {
						undo_restore = false, invalidate = true,
						virt_lines_above = true,
						virt_lines = { tmp },

						hl_mode = "combine"
					})
				elseif item.top_border == true and range.row_start > 0 then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start - 1, math.min(range.col_start, prev_line), {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = tmp,

						hl_mode = "combine"
					})
				end
			end
			---_
		elseif part.class == "missing_seperator" then
			---+${custom, Handle missing last |}
			local border, border_hl = get_border("header", 3);
			local top, top_hl = get_border("top", 3);

			table.insert(tmp, { top, utils.set_hl(top_hl) });

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start, range.col_start + part.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + part.col_end,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ border, utils.set_hl(border_hl) }
				},

				hl_mode = "combine"
			})

			if p == #item.header and config.block_decorator == true then
				local prev_line = range.row_start == 0 and 0 or #vim.api.nvim_buf_get_lines(buffer, range.row_start - 1, range.row_start, false)[1];

				if config.use_virt_lines == true then
					table.insert(tmp, 1, { string.rep(" ", range.col_start) });
				elseif range.row_start > 0 and prev_line < range.col_start then
					table.insert(tmp, 1, { string.rep(" ", range.col_start - prev_line) });
				end

				if config.use_virt_lines == true then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start, range.col_start, {
						undo_restore = false, invalidate = true,
						virt_lines_above = true,
						virt_lines = { tmp },

						hl_mode = "combine"
					})
				elseif range.row_start > 0 and item.top_border == true then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start - 1, math.min(prev_line, range.col_start), {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = tmp,

						hl_mode = "combine"
					})
				end
			end
			---_
		elseif part.class == "column" then
			---+${custom, Handle columns of text inside the header}
			local visible_width = vim.fn.strdisplaywidth(visible_texts.header[c]);
			local column_width  = col_widths[c];

			local top, top_hl = get_border("top", 2);

			table.insert(tmp, { string.rep(top, column_width), utils.set_hl(top_hl) });

			if visible_width < column_width then
				if item.alignments[c] == "default" or item.alignments[c] == "left" then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start, range.col_start + part.col_end, {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", column_width - visible_width) }
						},

						hl_mode = "combine"
					});
				elseif item.alignments[c] == "right" then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start, range.col_start + part.col_start, {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", column_width - visible_width) }
						},

						hl_mode = "combine"
					});
				else
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start, range.col_start + part.col_start, {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", math.ceil((column_width - visible_width) / 2)) }
						},

						hl_mode = "combine"
					});
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start, range.col_start + part.col_end, {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", math.floor((column_width - visible_width) / 2)) }
						},

						hl_mode = "combine"
					});
				end
			end

			c = c + 1;
			---_
		end
	end

	c = 1;

	for s, sep in ipairs(item.separator) do
		if sep.class == "separator" then
			---+${custom, Handle | in the header}
			local border, border_hl = get_border("separator", 4);

			if s == 1 then
				border, border_hl = get_border("separator", 1);
			elseif s == #item.separator then
				border, border_hl = get_border("separator", 3);
			end

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start + 1, range.col_start + sep.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + sep.col_end,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ border, utils.set_hl(border_hl) }
				},

				hl_mode = "combine"
			})
			---_
		elseif sep.class == "missing_seperator" then
			---+${custom, Handle missing last |}
			local border, border_hl = get_border("separator", 3);

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start + 1, range.col_start + sep.col_start, {
				undo_restore = false, invalidate = true,
				virt_text_pos = "inline",
				virt_text = {
					{ border, utils.set_hl(border_hl) }
				},

				hl_mode = "combine"
			})
			---_
		elseif sep.class == "column" then
			local border, border_hl = get_border("separator", 2);
			local align, align_hl;

			if item.alignments[c] == "default" then
				---+${custom, Normal columns}
				vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start + 1, range.col_start + sep.col_start, {
					undo_restore = false, invalidate = true,
					end_col = range.col_start + sep.col_end,
					conceal = "",

					virt_text_pos = "inline",
					virt_text = {
						{ string.rep(border, col_widths[c]), utils.set_hl(border_hl) }
					},

					hl_mode = "combine"
				})
				---_
			elseif item.alignments[c] == "left" then
				---+${custom, Left aligned columns}
				align = parts.align_left or "";
				align_hl = hls.align_left;

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start + 1, range.col_start + sep.col_start, {
					undo_restore = false, invalidate = true,
					end_col = range.col_start + sep.col_end,
					conceal = "",
					virt_text_pos = "inline",

					virt_text = {
						{ align, utils.set_hl(align_hl) },
						{ string.rep(border, col_widths[c] - vim.fn.strdisplaywidth(align)), utils.set_hl(border_hl) }
					},

					hl_mode = "combine"
				})
				---_
			elseif item.alignments[c] == "right" then
				---+${custom, Right aligned columns}
				align = parts.align_right or "";
				align_hl = hls.align_right;

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start + 1, range.col_start + sep.col_start, {
					undo_restore = false, invalidate = true,
					end_col = range.col_start + sep.col_end,
					conceal = "",
					virt_text_pos = "inline",

					virt_text = {
						{ string.rep(border, col_widths[c] - vim.fn.strdisplaywidth(align)), utils.set_hl(border_hl) },
						{ align, utils.set_hl(align_hl) }
					},

					hl_mode = "combine"
				})
				---_
			elseif item.alignments[c] == "center" then
				---+${custom, Center aligned columns}
				align = parts.align_center or { "", "" };
				align_hl = hls.align_center or {};

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start + 1, range.col_start + sep.col_start, {
				undo_restore = false, invalidate = true,
					undo_restore = false, invalidate = true,
					end_col = range.col_start + sep.col_end,
					conceal = "",
					virt_text_pos = "inline",

					virt_text = {
						{ align[1], utils.set_hl(align_hl[1]) },
						{ string.rep(border, col_widths[c] - vim.fn.strdisplaywidth(table.concat(align))), utils.set_hl(border_hl) },
						{ align[2], utils.set_hl(align_hl[2]) }
					},

					hl_mode = "combine"
				})
				---_
			end

			c = c + 1;
		end
	end

	for r, row in ipairs(item.rows) do
		if r == #item.rows then
			break;
		end

		c = 1;

		for _, part in ipairs(row) do
			if part.class == "separator" then
				---+${custom, Handle | in the header}
				local border, border_hl = get_border("row", 2);

				if s == 1 then
					border, border_hl = get_border("row", 1);
				elseif s == #item.separator then
					border, border_hl = get_border("row", 3);
				end

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start + 1 + r, range.col_start + part.col_start, {
					undo_restore = false, invalidate = true,
					end_col = range.col_start + part.col_end,
					conceal = "",

					virt_text_pos = "inline",
					virt_text = {
						{ border, utils.set_hl(border_hl) }
					},

					hl_mode = "combine"
				})
				---_
			elseif part.class == "missing_seperator" then
				---+${custom, Handle missing last |}
				local border, border_hl = get_border("row", 3);

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start + 1 + r, range.col_start + part.col_start, {
					undo_restore = false, invalidate = true,
					virt_text_pos = "inline",
					virt_text = {
						{ border, utils.set_hl(border_hl) }
					},

					hl_mode = "combine"
				})
				---_
			elseif part.class == "column" then
				---+${custom, Handle columns of text inside the header}
				local visible_width = vim.fn.strdisplaywidth(visible_texts.rows[r][c]);
				local column_width  = col_widths[c];

				if visible_width < column_width then
					if item.alignments[c] == "default" or item.alignments[c] == "left" then
						vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start + (r + 1), range.col_start + part.col_end, {
							undo_restore = false, invalidate = true,
							virt_text_pos = "inline",
							virt_text = {
								{ string.rep(" ", column_width - visible_width) }
							},

							hl_mode = "combine"
						});
					elseif item.alignments[c] == "right" then
						vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start + (r + 1), range.col_start + part.col_start, {
							undo_restore = false, invalidate = true,
							virt_text_pos = "inline",
							virt_text = {
								{ string.rep(" ", column_width - visible_width) }
							},

							hl_mode = "combine"
						});
					else
						vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start + (r + 1), range.col_start + part.col_start, {
							undo_restore = false, invalidate = true,
							virt_text_pos = "inline",
							virt_text = {
								{ string.rep(" ", math.ceil((column_width - visible_width) / 2)) }
							},

							hl_mode = "combine"
						});
						vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start + (r + 1), range.col_start + part.col_end, {
							undo_restore = false, invalidate = true,
							virt_text_pos = "inline",
							virt_text = {
								{ string.rep(" ", math.floor((column_width - visible_width) / 2)) }
							},

							hl_mode = "combine"
						});
					end
				end

				c = c + 1;
				---_
			end
		end
	end

	c = 1;
	tmp = {};

	for p, part in ipairs(item.rows[#item.rows] or {}) do
		if part.class == "separator" then
			---+${custom, Handle | in the header}
			local border, border_hl = get_border("row", 2);
			local bottom, bottom_hl = bottom_part(4);

			if p == 1 then
				border, border_hl = get_border("row", 1);
				bottom, bottom_hl = bottom_part(1);
			elseif p == #item.header then
				border, border_hl = get_border("row", 3);
				bottom, bottom_hl = bottom_part(3);
			end

			table.insert(tmp, { bottom, utils.set_hl(bottom_hl) });

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_end - 1, range.col_start + part.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + part.col_end,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ border, utils.set_hl(border_hl) }
				},

				hl_mode = "combine"
			});

			if p == #item.header and config.block_decorator == true then
				local next_line = range.row_end == vim.api.nvim_buf_line_count(buffer) and 0 or #vim.api.nvim_buf_get_lines(buffer, range.row_end, range.row_end + 1, false)[1];

				if config.use_virt_lines == true then
					table.insert(tmp, 1, { string.rep(" ", range.col_start) });
				elseif next_line < vim.api.nvim_buf_line_count(buffer) and  next_line < range.col_start then
					table.insert(tmp, 1, { string.rep(" ", range.col_start - next_line) });
				end

				if config.use_virt_lines == true then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_end, math.min(next_line, range.col_start), {
						virt_lines_above = true,
						virt_lines = { tmp },

						hl_mode = "combine"
					})
				elseif range.row_end <= vim.api.nvim_buf_line_count(buffer) and item.bottom_border == true then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_end, math.min(next_line, range.col_start), {
						virt_text_pos = "inline",
						virt_text = tmp,

						hl_mode = "combine"
					})
				end
			end
			---_
		elseif part.class == "missing_seperator" then
			---+${custom, Handle missing last |}
			local border, border_hl = get_border("row", 3);
			local bottom, bottom_hl = bottom_part(3);

			table.insert(tmp, { bottom, utils.set_hl(bottom_hl) });

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_end - 1, range.col_start + part.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + part.col_end,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ border, utils.set_hl(border_hl) }
				},

				hl_mode = "combine"
			})

			if p == #item.header and config.block_decorator == true then
				local next_line = range.row_end == vim.api.nvim_buf_line_count(buffer) and 0 or #vim.api.nvim_buf_get_lines(buffer, range.row_end, range.row_end + 1, false)[1];

				if config.use_virt_lines == true then
					table.insert(tmp, 1, { string.rep(" ", range.col_start) });
				elseif next_line < vim.api.nvim_buf_line_count(buffer) and next_line < range.col_start then
					table.insert(tmp, 1, { string.rep(" ", range.col_start - next_line) });
				end

				if config.use_virt_lines == true then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_end, math.min(next_line, range.col_start), {
						virt_lines_above = true,
						virt_lines = { tmp },

						hl_mode = "combine"
					})
				elseif range.row_end <= vim.api.nvim_buf_line_count(buffer) and item.bottom_border == true then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_end, math.min(next_line, range.col_start), {
						virt_text_pos = "inline",
						virt_text = tmp,

						hl_mode = "combine"
					})
				end
			end
			---_
		elseif part.class == "column" then
			---+${custom, Handle columns of text inside the last row}
			local visible_width = vim.fn.strdisplaywidth(visible_texts.rows[#visible_texts.rows][c]);
			local column_width  = col_widths[c];

			local bottom, bottom_hl = bottom_part(2);

			table.insert(tmp, { string.rep(bottom, column_width), utils.set_hl(bottom_hl) });

			if visible_width < column_width then
				if item.alignments[c] == "default" or item.alignments[c] == "left" then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_end - 1, range.col_start + part.col_end, {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", column_width - visible_width) }
						},

						hl_mode = "combine"
					});
				elseif item.alignments[c] == "right" then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_end - 1, range.col_start + part.col_start, {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", column_width - visible_width) }
						},

						hl_mode = "combine"
					});
				else
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_end - 1, range.col_start + part.col_start, {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", math.ceil((column_width - visible_width) / 2)) }
						},

						hl_mode = "combine"
					});
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_end - 1, range.col_start + part.col_end, {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", math.floor((column_width - visible_width) / 2)) }
						},

						hl_mode = "combine"
					});
				end
			end

			c = c + 1;
			---_
		end
	end
end

markdown.hr = function (buffer, item)
	local config = get_config("horizontal_rules");
	local range = item.range;

	if not config then
		return;
	end

	local virt_text = {};
	local function val(opt, index)
		if vim.islist(opt) == false then
			return opt;
		elseif #opt < index then
			return opt[#opt];
		elseif 0 > index then
			return opt[1];
		end

		return opt[index];
	end

	for _, part in ipairs(config.parts) do
		if part.type == "text" then
			table.insert(virt_text, { part.text, utils.set_hl(part.hl) });
		elseif part.type == "repeating" then
			local rep = 0;

			if pcall(part.repeat_amount, buffer) then
				rep = part.repeat_amount(buffer);
			elseif type(part.repeat_amount) == "number" then
				rep = part.repeat_amount;
			end

			for r = 1, rep, 1 do
				if part.direction == "right" then
					table.insert(virt_text, {
						val(part.text, (rep - r) + 1),
						val(part.hl, (rep - r) + 1)
					});
				else
					table.insert(virt_text, {
						val(part.text, r),
						val(part.hl, r)
					});
				end
			end
		end
	end

	vim.api.nvim_buf_set_extmark(buffer, markdown.ns("tables"), range.row_start, 0, {
		undo_restore = false, invalidate = true,
		virt_text_pos = "overlay",
		virt_text = virt_text,

		hl_mode = "combine"
	});
	---_
end

markdown.render = function (buffer, content)
	markdown.set_ns()

	for _, item in ipairs(content or {}) do
		-- pcall(markdown[item.class:gsub("^markdown_", "")], buffer, item);
		markdown[item.class:gsub("^markdown_", "")](buffer, item);
	end
end

markdown.clear = function (buffer, ignore_ns, from, to)
	for name, ns in pairs(markdown.ns) do
		if ignore_ns and vim.list_contains(ignore_ns, name) == false then
			vim.api.nvim_buf_clear_namespace(buffer, ns, from or 0, to or -1);
		end
	end
end

return markdown;
