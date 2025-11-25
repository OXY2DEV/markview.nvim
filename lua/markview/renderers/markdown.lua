local markdown = {};
local inline = require("markview.renderers.markdown_inline");

local spec = require("markview.spec");
local utils = require("markview.utils");

local filetypes = require("markview.filetypes");
local entities = require("markview.entities");
local symbols = require("markview.symbols");

--- Forces the {index} to be between 1 & the length of {value}.
---@param value any | any[]
---@param index integer
---@return any
local function tbl_clamp(value, index)
	if vim.islist(value) == false then
		return value;
	elseif index > #value then
		return value[#value];
	end

	return value[index];
end

---@param list string[]
---@return string
local concat = function (list)
	for i, item in ipairs(list) do
		list[i] = vim.pesc(item);
	end

	return table.concat(list);
end

--- Holds nodes for post-process effects.
---@type table[]
markdown.cache = {};

--- Cached configuration to increase performance.
markdown.__inline_config = {
	codes = spec.get({ "markdown_inline", "inline_codes"},      { fallback = nil }),
	hyper = spec.get({ "markdown_inline", "hyperlinks" },       { fallback = nil }),
	image = spec.get({ "markdown_inline", "images" },           { fallback = nil }),
	email = spec.get({ "markdown_inline", "emails" },           { fallback = nil }),
	embed = spec.get({ "markdown_inline", "embed_files" },      { fallback = nil }),
	blref = spec.get({ "markdown_inline", "block_references" }, { fallback = nil }),
	int   = spec.get({ "markdown_inline", "internal_links" },   { fallback = nil }),
	uri   = spec.get({ "markdown_inline", "uri_autolinks" },    { fallback = nil }),
	esc   = spec.get({ "markdown_inline", "escapes" },          { fallback = nil }),
	ent   = spec.get({ "markdown_inline", "entities" },         { fallback = nil }),
	emo   = spec.get({ "markdown_inline", "emoji_shorthands" }, { fallback = nil }),
	hls   = spec.get({ "markdown_inline", "highlights" },       { fallback = nil }),
};

--- Reloads cached configuration.
markdown.__new_config = function ()
	markdown.__inline_config = {
		codes = spec.get({ "markdown_inline", "inline_codes"},      { fallback = nil }),
		hyper = spec.get({ "markdown_inline", "hyperlinks" },       { fallback = nil }),
		image = spec.get({ "markdown_inline", "images" },           { fallback = nil }),
		email = spec.get({ "markdown_inline", "emails" },           { fallback = nil }),
		embed = spec.get({ "markdown_inline", "embed_files" },      { fallback = nil }),
		blref = spec.get({ "markdown_inline", "block_references" }, { fallback = nil }),
		int   = spec.get({ "markdown_inline", "internal_links" },   { fallback = nil }),
		uri   = spec.get({ "markdown_inline", "uri_autolinks" },    { fallback = nil }),
		esc   = spec.get({ "markdown_inline", "escapes" },          { fallback = nil }),
		ent   = spec.get({ "markdown_inline", "entities" },         { fallback = nil }),
		emo   = spec.get({ "markdown_inline", "emoji_shorthands" }, { fallback = nil }),
		hls   = spec.get({ "markdown_inline", "highlights" },       { fallback = nil }),
	};
end

--- Gets the preview text from a string containing markdown
--- syntax.
---
--- >[!NOTE]
--- > This is slower than `tree-sitter` and is less accurate.
--- > Use only when there are no alternatives.
---@param str string
---@return string
---@return integer
markdown.output = function (str, buffer)
	local decorations = 0;

	--- Checks if syntax exists in {str}.
	---@return boolean
	local function has_syntax ()
		if str:match("`(.-)`") then
			return true;
		elseif str:match("\\([%\\%*%_%{%}%[%]%(%)%#%+%-%.%!%%<%>$])") then
			return true;
		elseif str:match("([%*]+)(.-)([%*]+)") then
			return true;
		elseif str:match("%_(.-)%_") then
			return true;
		elseif str:match("%~%~(.-)%~%~") or str:match("%~(.-)%~") then
			return true;
		elseif str:match("%&([%d%a%#]+);") then
			return true;
		elseif str:match(":([%a%d%_%+%-]+):") then
			return true;
		elseif str:match("%=%=(.-)%=%=") then
			return true;
		elseif str:match("%!%[%[([^%]]+)%]%]") then
			return true;
		elseif str:match("%[%[%#%^([^%]]+)%]%]") then
			return true;
		elseif str:match("%[%[([^%]]+)%]%]") then
			return true;
		elseif str:match("%!%[([^%]]*)%]([%(%[])([^%)]*)([%)%]])") then
			return true;
		elseif str:match("%!%[([^%]]*)%]") then
			return true;
		elseif str:match("%[([^%]]*)%]([%(%[])([^%)]*)([%)%]])") then
			return true;
		elseif str:match("%[([^%]]+)%]") then
			return true;
		elseif str:match("%<([^%s%@]-)@(%S+)%>") then
			return true;
		elseif str:match("%<(%S+)%>") then
			return true;
		end

		return false;
	end

	--- If no syntax items are found and no highlight exits
	if has_syntax() == false then
		return str, decorations;
	end

	--- Inline codes config
	local codes = markdown.__inline_config.codes;
	local hyper = markdown.__inline_config.hyper;
	local image = markdown.__inline_config.image;
	local email = markdown.__inline_config.email;
	local embed = markdown.__inline_config.embed;
	local blref = markdown.__inline_config.blref;
	local int   = markdown.__inline_config.int;
	local uri   = markdown.__inline_config.url;
	local esc   = markdown.__inline_config.esc;
	local ent   = markdown.__inline_config.ent;
	local emo   = markdown.__inline_config.emo;
	local hls   = markdown.__inline_config.hls;


	str = str:gsub("\\%`", " ");

	for inline_code in str:gmatch("`(.-)`") do
		if not codes or codes.enable == false then
			str = str:gsub(
				concat({
					"`",
					vim.pesc(inline_code),
					"`"
				}),
				concat({
					inline_code
				})
			);
		else
			local _codes = spec.get({}, {
				source = codes,
				fallback = {},
				eval_args = {
					buffer,
					{
						class = "inline_code_span",
						text = string.format("`%s`", inline_code)
					}
				}
			});

			str = str:gsub(
				concat({
					"`",
					inline_code,
					"`"
				}),
				concat({
					_codes.corner_left or "",
					_codes.padding_left or "",
					string.rep("X", vim.fn.strdisplaywidth(inline_code)),
					_codes.padding_right or "",
					_codes.corner_left or ""
				})
			);

			decorations = decorations + vim.fn.strdisplaywidth(table.concat({
				_codes.corner_left or "",
				_codes.padding_left or "",
				_codes.padding_right or "",
				_codes.corner_left or ""
			}));
		end
	end

	for escaped in str:gmatch("\\([%\\%*%_%{%}%[%]%(%)%#%+%-%.%!%%<%>$])") do
		if not esc then
			break;
		end

		str = str:gsub(concat({ "\\", escaped }), " ", 1);
	end

	for latex in str:gmatch("%$([^%$]*)%$") do
		str = str:gsub(
			concat({
				"$",
				latex,
				"$"
			}),
			concat({
				"$",
				string.rep("X", vim.fn.strdisplaywidth(latex)),
				"$"
			}),
			1
		);
	end

	for str_b, content, str_a in str:gmatch("([%*]+)(.-)([%*]+)") do
		if content == "" then
			goto continue;
		elseif #str_b ~= #str_a then
			local min = math.min(#str_b, #str_a);
			str_b = str_b:sub(0, min);
			str_a = str_a:sub(0, min);
		end

		str = str:gsub(
			concat({
				str_b,
				content,
				str_a
			}),
			content,
			1
		);

	    ::continue::
	end

	for italic in str:gmatch("%_(.-)%_") do
		str = str:gsub(
			concat({
				"_",
				italic,
				"_"
			}),
			concat({
				italic
			}),
			1
		);
	end

	for striked in str:gmatch("%~%~(.-)%~%~") do
		str = str:gsub(
			concat({
				"~~",
				striked,
				"~~"
			}),
			concat({
				striked
			}),
			1
		);
	end

	-- NOTE: Do this after checking `~~text~~` to prevent
	-- mismatches.
	--
	-- See #378
	for striked in str:gmatch("%~(.-)%~") do
		str = str:gsub(
			concat({
				"~",
				striked,
				"~"
			}),
			concat({
				striked
			}),
			1
		);
	end

	for entity in str:gmatch("%&([%d%a%#]+);") do
		if not emo then
			break;
		elseif not entities.get(entity:gsub("%#", "")) then
			goto continue;
		end

		str = str:gsub(
			concat({
				"&",
				entity,
				";"
			}),
			concat({
				entities.get(entity:gsub("%#", ""))
			})
		);

	    ::continue::
	end

	for emoji in str:gmatch(":([%a%d%_%+%-]+):") do
		if not ent then
			break;
		elseif not symbols.shorthands[emoji] then
			goto continue;
		end

		str = str:gsub(
			concat({
				":",
				emoji,
				":"
			}),
			concat({
				symbols.shorthands[emoji]
			})
		);

		::continue::
	end

	for highlight in str:gmatch("%=%=(.-)%=%=") do
		if not hls then goto continue; end

		local _hls = utils.match(
			hls,
			highlight,
			{
				fallback = {},
				eval_args = {
					buffer,
					{
						class = "inline_highlight",
						text = highlight
					}
				}
			}
		);

		str = str:gsub(
			concat({
				"==",
				highlight,
				"=="
			}),
			concat({
				_hls.corner_left or "",
				_hls.padding_left or "",
				_hls.icon or "",
				string.rep("X", vim.fn.strdisplaywidth(highlight)),
				_hls.padding_right or "",
				_hls.corner_left or ""
			})
		);

		decorations = decorations + vim.fn.strdisplaywidth(table.concat({
			_hls.corner_left or "",
			_hls.padding_left or "",
			_hls.icon or "",
			_hls.padding_right or "",
			_hls.corner_left or ""
		}));

		::continue::
	end

	for ref in str:gmatch("%!%[%[([^%]]+)%]%]") do
		if ref:match("%#%^(.+)") and blref then
			local _blref = utils.match(
				blref,
				ref,
				{
					fallback = {},
					eval_args = {
						buffer,
						{
							class = "inline_link_block_ref",
							text = string.format("![[%s]]", ref),

							label = ref:match("%#%^(.+)$")
						}
					}
				}
			);

			str = str:gsub(
				concat({
					"![[",
					ref,
					"]]"
				}),
				concat({
					_blref.corner_left or "",
					_blref.padding_left or "",
					_blref.icon or "",
					string.rep("X", vim.fn.strdisplaywidth(ref)),
					_blref.padding_right or "",
					_blref.corner_right or ""
				})
			);

			decorations = decorations + vim.fn.strdisplaywidth(table.concat({
				_blref.corner_left or "",
				_blref.padding_left or "",
				_blref.icon or "",
				_blref.padding_right or "",
				_blref.corner_right or ""
			}));
		elseif embed then
			local _embed = utils.match(
				embed,
				ref,
				{
					fallback = {},
					eval_args = {
						buffer,
						{
							class = "inline_link_embed_file",
							text = string.format("![[%s]]", ref),

							label = ref
						}
					}
				}
			);

			str = str:gsub(
				concat({
					"![[",
					ref,
					"]]"
				}), concat({
					_embed.corner_left or "",
					_embed.padding_left or "",
					_embed.icon or "",
					string.rep("X", vim.fn.strdisplaywidth(ref)),
					_embed.padding_right or "",
					_embed.corner_right or ""
				})
			);

			decorations = decorations + vim.fn.strdisplaywidth(table.concat({
				_embed.corner_left or "",
				_embed.padding_left or "",
				_embed.icon or "",
				_embed.padding_right or "",
				_embed.corner_right or ""
			}));
		end
	end

	for ref in str:gmatch("%[%[%#%^([^%]]+)%]%]") do
		if not blref then goto continue; end

		local _blref = utils.match(
			blref,
			ref,
			{
				fallback = {},
				eval_args = {
					buffer,
					{
						class = "inline_link_block_ref",
						text = string.format("[[%s]]", ref),

						label = ref:match("%#%^(.+)$")
					}
				}
			}
		);

		str = str:gsub(
			concat({
				"[[#^",
				ref,
				"]]"
			}),
			concat({
				_blref.corner_left or "",
				_blref.padding_left or "",
				_blref.icon or "",
					string.rep("X", vim.fn.strdisplaywidth(ref)),
				_blref.padding_right or "",
				_blref.corner_right or ""
			})
		);

		decorations = decorations + vim.fn.strdisplaywidth(table.concat({
			_blref.corner_left or "",
			_blref.padding_left or "",
			_blref.icon or "",
			_blref.padding_right or "",
			_blref.corner_right or ""
		}));

		::continue::
	end

	for link in str:gmatch("%[%[([^%]]+)%]%]") do
		if not int then
			str = str:gsub(
				concat({
					"[[",
					link,
					"]]"
				}),
				concat({
					" ",
					string.rep("X", vim.fn.strdisplaywidth(link)),
					" "
				})
			);
		else
			local alias = link:match("%|(.+)$");
			local _int = utils.match(
				int,
				link,
				{
					fallback = {},
					eval_args = {
						buffer,
						{
							class = "inline_link_internal",
							text = string.format("[[%s]]", link),

							label = link,
							alias = alias
						}
					}
				}
			);

			str = str:gsub(
				concat({
					"[[",
					link,
					"]]"
				}),
				concat({
					_int.corner_left or "",
					_int.padding_left or "",
					_int.icon or "",
					string.rep("X", vim.fn.strdisplaywidth(alias or link)),
					_int.padding_right or "",
					_int.corner_right or ""
				})
			);

			decorations = decorations + vim.fn.strdisplaywidth(table.concat({
				_int.corner_left or "",
				_int.padding_left or "",
				_int.icon or "",
				_int.padding_right or "",
				_int.corner_right or ""
			}));
		end
	end

	for link, p_s, address, p_e in str:gmatch("%!%[([^%]]*)%]([%(%[])([^%)]*)([%)%]])") do
		if not image then
			str = str:gsub(
				concat({
					"![",
					link,
					"]",
					address
				}),
				concat({ link })
			);
		else
			local _image = utils.match(
				image,
				address,
				{
					fallback = {},
					eval_args = {
						buffer,
						{
							class = "inline_link_image",
							text = string.format("![%s]%s%s%s", link, p_s, address, p_e),

							label = address,
							description = link
						}
					}
				}
			);

			str = str:gsub(
				concat({
					"![",
					link,
					"]",
					p_s,
					address,
					p_e
				}),
				concat({
					_image.corner_left or "",
					_image.padding_left or "",
					_image.icon or "",
					string.rep("X", vim.fn.strdisplaywidth(link)),
					_image.padding_right or "",
					_image.corner_right or ""
				})
			);

			decorations = decorations + vim.fn.strdisplaywidth(table.concat({
				_image.corner_left or "",
				_image.padding_left or "",
				_image.icon or "",
				_image.padding_right or "",
				_image.corner_right or ""
			}));
		end
	end

	for link in str:gmatch("%!%[([^%]]*)%]") do
		if not image then
			str = str:gsub(
				concat({
					"![",
					link,
					"]",
				}),
				concat({
					string.rep("X", vim.fn.strdisplaywidth(link)),
				})
			);
		else
			local _image = utils.match(
				image,
				"",
				{
					fallback = {},
					eval_args = {
						buffer,
						{
							class = "inline_link_image",
							text = string.format("![%s]", link),

							label = nil,
							description = link
						}
					}
				}
			);

			str = str:gsub(
				concat({
					"![",
					link,
					"]",
				}), concat({
					_image.corner_left or "",
					_image.padding_left or "",
					_image.icon or "",
					string.rep("X", vim.fn.strdisplaywidth(link)),
					_image.padding_right or "",
					_image.corner_right or ""
				})
			);

			decorations = decorations + vim.fn.strdisplaywidth(table.concat({
				_image.corner_left or "",
				_image.padding_left or "",
				_image.icon or "",
				_image.padding_right or "",
				_image.corner_right or ""
			}));
		end
	end

	for link, p_s, address, p_e in str:gmatch("%[([^%]]*)%]([%(%[])([^%)]*)([%)%]])") do
		if not hyper then
			str = str:gsub(
				concat({
					"[",
					link,
					"]",
					address
				}),
				concat({
					string.rep("X", vim.fn.strdisplaywidth(link)),
				})
			);
		else
			local _hyper = utils.match(
				hyper,
				address,
				{
					fallback = {},
					eval_args = {
						buffer,
						{
							class = "inline_link_hyperlink",
							text = string.format("[%s]%s%s%s", link, p_s, address, p_e),

							label = address,
							description = link
						}
					}
				}
			);

			str = str:gsub(
				concat({
					"[",
					link,
					"]",
					p_s,
					address,
					p_e
				}), concat({
					_hyper.corner_left or "",
					_hyper.padding_left or "",
					_hyper.icon or "",
					string.rep("X", vim.fn.strdisplaywidth(link)),
					_hyper.padding_right or "",
					_hyper.corner_right or ""
				})
			);

			decorations = decorations + vim.fn.strdisplaywidth(table.concat({
				_hyper.corner_left or "",
				_hyper.padding_left or "",
				_hyper.icon or "",
				_hyper.padding_right or "",
				_hyper.corner_right or ""
			}));
		end
	end

	for link in str:gmatch("%[([^%]]+)%]") do
		if not hyper then
			str = str:gsub(
				concat({
					"[",
					link,
					"]",
				}),
				concat({
					string.rep("X", link:len())
				})
			);
		else
			local _hyper = utils.match(
				hyper,
				link,
				{
					fallback = {},
					eval_args = {
						buffer,
						{
							class = "inline_link_shortcut",
							text = string.format("[%s]", link),

							label = link
						}
					}
				}
			);

			str = str:gsub(
				concat({
					"[",
					link,
					"]",
				}), concat({
					_hyper.corner_left or "",
					_hyper.padding_left or "",
					_hyper.icon or "",
					string.rep("X", link:len()),
					_hyper.padding_right or "",
					_hyper.corner_right or ""
				})
			);

			decorations = decorations + vim.fn.strdisplaywidth(table.concat({
				_hyper.corner_left or "",
				_hyper.padding_left or "",
				_hyper.icon or "",
				_hyper.padding_right or "",
				_hyper.corner_right or ""
			}));
		end
	end

	for address, domain in str:gmatch("%<([^%s%@]-)@(%S+)%>") do
		if not email then
			break;
		end

		local _email = utils.match(
			email,
			string.format("%s@%s", address, domain),
			{
				fallback = {},
				eval_args = {
					buffer,
					{
						class = "inline_link_email",
						text = string.format("<%s@%s>", address, domain),

						label = string.format("%s@%s", address, domain)
					}
				}
			}
		);

		str = str:gsub(
			concat({
				"<",
				address,
				"@",
				domain,
				">"
			}),
			concat({
				_email.corner_left or "",
				_email.padding_left or "",
				_email.icon or "",
				string.rep("X", address:len()),
				"Y",
				string.rep("X", domain:len()),
				_email.padding_right or "",
				_email.corner_left or ""
			})
		);

		decorations = decorations + vim.fn.strdisplaywidth(table.concat({
			_email.corner_left or "",
			_email.padding_left or "",
			_email.icon or "",
			_email.padding_right or "",
			_email.corner_left or ""
		}));
	end

	for address in str:gmatch("%<(%S+)%>") do
		if not uri then
			break;
		elseif not address:match("^ht") and not address:match("%:%/%/") then
			goto continue;
		end

		local _uri = utils.match(
			uri,
			address,
			{
				fallback = {},
				eval_args = {
					buffer,
					{
						class = "inline_link_uri_autolink",
						text = string.format("<%s>", address),

						label = address
					}
				}
			}
		);

		str = str:gsub(
			concat({
				"<",
				address,
				">"
			}), concat({
				_uri.corner_left or "",
				_uri.padding_left or "",
				_uri.icon or "",
				string.rep("X", address:len()),
				_uri.padding_right or "",
				_uri.corner_left or ""
			})
		);

		decorations = decorations + vim.fn.strdisplaywidth(table.concat({
			_uri.corner_left or "",
			_uri.padding_left or "",
			_uri.icon or "",
			_uri.padding_right or "",
			_uri.corner_left or ""
		}));

	    ::continue::
	end

	return str, decorations;
end

--- Applies text transformation based on the **filetype**.
---
--- Uses for getting the output text of filetypes that contain
--- special syntaxes(e.g. JSON, Markdown).
markdown.get_visual_text = {
	["Markdown"] = function (str)
		str = str:gsub("\\%`", " ");

		for inline_code in str:gmatch("`(.-)`") do
			str = str:gsub(concat({
				"`",
				inline_code,
				"`"
			}), inline_code);
		end

		for str_b, content, str_a in str:gmatch("([*]+)(.-)([*]+)") do
			if content == "" then
				goto continue;
			elseif #str_b ~= #str_a then
				local min = math.min(#str_b, #str_a);
				str_b = str_b:sub(0, min);
				str_a = str_a:sub(0, min);
			end

			str_b = vim.pesc(str_b);
			content = vim.pesc(content);
			str_a = vim.pesc(str_a);

			str = str:gsub(str_b .. content .. str_a, string.rep("X", vim.fn.strdisplaywidth(content)))

			::continue::
		end

		for striked in str:gmatch("%~%~(.-)%~%~") do
			str = str:gsub(concat({
				"~~",
				striked,
				"~~"
			}), concat({
				string.rep("X", vim.fn.strdisplaywidth(striked))
			}));
		end

		-- NOTE: Do this after checking `~~text~~` to prevent
		-- mismatches.
		--
		-- See #378
		for striked in str:gmatch("%~(.-)%~") do
			str = str:gsub(concat({
				"~",
				striked,
				"~"
			}), concat({
				string.rep("X", vim.fn.strdisplaywidth(striked))
			}));
		end

		for escaped in str:gmatch("\\([%\\%*%_%{%}%[%]%(%)%#%+%-%.%!%%<%>$])") do
			str = str:gsub(concat({
				"\\",
				escaped
			}), " ");
		end

		for link, m1, address, m2 in str:gmatch("%!%[([^%)]*)%]([%(%[])([^%)]*)([%)%]])") do
			str = str:gsub(concat({
				"![",
				link,
				"]",
				m1,
				address,
				m2
			}), link);
		end

		for link in str:gmatch("%!%[([^%)]*)%]") do
			str = str:gsub(concat({
				"![",
				link,
				"]",
			}), concat({
				string.rep("X", vim.fn.strdisplaywidth(link))
			}))
		end

		for link, m1, address, m2 in str:gmatch("%[([^%)]*)%]([%(%[])([^%)]*)([%)%]])") do
			str = str:gsub(concat({
				"[",
				link,
				"]",
				m1,
				address,
				m2
			}),
				string.rep("X", vim.fn.strdisplaywidth(link))
			);
		end

		for link in str:gmatch("%[([^%)]+)%]") do
			str = str:gsub(concat({
				"[",
				link,
				"]",
			}), concat({
				string.rep("X", vim.fn.strdisplaywidth(link)),
			}))
		end

		return str;
	end,
	["JSON"] = function (str)
		return str:gsub('"', "");
	end,

	--- Gets the visual text from the source text.
	---@param self table
	---@param ft string?
	---@param line string
	---@return string
	init = function (self, ft, line)
		if ft == nil or self[ft] == nil then
			--- Filetype isn't available or
			--- transformation not available.
			return line;
		elseif pcall(self[ft], line) == false then
			--- Text transformation failed!
			return line;
		end

		return self[ft](line);
	end
};

---@type integer Namespace for markdown.
markdown.ns = vim.api.nvim_create_namespace("markview/markdown");

--- Renders atx headings.
---@param buffer integer
---@param item markview.parsed.markdown.atx_headings
markdown.atx_heading = function (buffer, item)
	---@type markview.config.markdown.headings?
	local main_config = spec.get({ "markdown", "headings" }, { fallback = nil, eval_args = { buffer, item } });

	if not main_config then
		return;
	elseif not spec.get({ "heading_" .. #item.marker }, { source = main_config, eval_args = { buffer, item } }) then
		return;
	end

	---@type markview.config.markdown.headings.atx
	local config = spec.get({ "heading_" .. #item.marker }, { source = main_config, eval_args = { buffer, item } });
	local shift_width = spec.get({ "shift_width" }, { source = main_config, fallback = 1, eval_args = { buffer, item } });

	local range = item.range;
	local got_icon, icon = pcall(
		string.format,

		config.icon or "",
		unpack(item.levels or {})
	);

	-- In case there is a problem with the `format string` in `config.icon`
	-- we should show an error instead.
	if got_icon == false then
		icon = "[INVALID_FORMAT_STRING]: `" .. tostring(config.icon) .. "` ";
		config.icon_hl = "@comment";
	end

	if config.style == "simple" then
		---@cast config markview.config.markdown.headings.atx.simple

		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			line_hl_group = utils.set_hl(config.hl)
		});
	elseif config.style == "label" then
		---@cast config markview.config.markdown.headings.atx.label

		local space = "";
		local win = vim.fn.win_findbuf(buffer)[1];

		if win and config.align then
			local res = markdown.output(item.text[1], buffer):gsub("^#+%s", "");

			local wid = vim.fn.strdisplaywidth(table.concat({
				config.corner_left or "",
				config.padding_left or "",

				icon,
				res,

				config.padding_right or "",
				config.corner_right or "",
			}));

			local w_wid = vim.api.nvim_win_get_width(win or 0) - vim.fn.getwininfo(win or 0)[1].textoff;

			if config.align == "left" then
				space = "";
			elseif config.align == "center" then
				space = string.rep(" ", math.max(0, math.floor((w_wid - wid) / 2)));
			elseif config.align == "right" then
				space = string.rep(" ", w_wid - wid);
			end
		else
			space = string.rep(" ", (#item.marker - 1) * shift_width);
		end

		--- DO NOT USE `hl_mode = "combine"`
		--- It causes color bleeding.
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + #item.marker + (#item.text[1] > #item.marker and 1 or 0),
			conceal = "",
			sign_text = config.sign and tostring(config.sign) or nil,
			sign_hl_group = utils.set_hl(config.sign_hl),
			virt_text_pos = "inline",
			virt_text = {
				{ space },
				{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
				{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

				{ icon, utils.set_hl(config.icon_hl or config.hl) },
			}
		});

		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_row = range.row_start,
			end_col = range.col_start + #(item.text[1] or ""),
			hl_group = utils.set_hl(config.hl)
		});

		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + #(item.text[1] or ""), {
			undo_restore = false, invalidate = true,
			conceal = "",
			virt_text_pos = "inline",
			virt_text = {
				{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
				{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
			}
		});
	elseif config.style == "icon" then
		---@cast config markview.config.markdown.headings.atx.icon

		utils.set_extmark(buffer, markdown.ns, range.row_start, range.col_start, {
			-- Remove `#+%s*` amount of characters.
			end_col = range.col_start + #item.marker + (#item.text[1] > #item.marker and 1 or 0),
			conceal = "",

			sign_text = tostring(config.sign or ""),
			sign_hl_group = utils.set_hl(config.sign_hl),

			virt_text = {
				{ string.rep(" ", (#item.marker - 1) * shift_width) },
				{ icon, config.icon_hl or config.hl },
			},
			line_hl_group = utils.set_hl(config.hl),
		});
	end
end

--- Renders block quotes, callouts & alerts.
---@param buffer integer
---@param item markview.parsed.markdown.block_quotes
markdown.block_quote = function (buffer, item)
	---@type markview.config.markdown.block_quotes?
	local main_config = spec.get({ "markdown", "block_quotes" }, { fallback = nil, eval_args = { buffer, item } });
	local range = item.range;

	if
		not main_config or
		not main_config.default
	then
		return;
	end

	---@type markview.config.markdown.block_quotes.opts
	local config;

	if item.callout then
		config = spec.get(
			{ string.lower(item.callout) },
			{ source = main_config, eval_args = { buffer, item } }
		) or spec.get(
			{ string.upper(item.callout) },
			{ source = main_config, eval_args = { buffer, item } }
		) or spec.get(
			{ item.callout },
			{ source = main_config, eval_args = { buffer, item } }
		) or spec.get(
			{ "default" },
			{ source = main_config, eval_args = { buffer, item } }
		);

		---@type markview.config.markdown.block_quotes.opts
		local default = spec.get({ "default" }, { source = main_config, eval_args = { buffer, item } });

		-- Inherit undefined option values from `default`.
		config = vim.tbl_deep_extend("force", default, config);
	else
		config = spec.get({ "default" }, { source = main_config, eval_args = { buffer, item } });
	end

	if item.callout then
		if item.title and config.title == true then
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.callout_start, {
				end_col = range.callout_end,
				conceal = "",
				undo_restore = false, invalidate = true,
				virt_text_pos = "inline",
				virt_text = {
					{ " " },
					{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
				},

				right_gravity = true,
				hl_mode = "combine",
			});

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.title_start, {
				end_col = range.title_end,
				undo_restore = false, invalidate = true,
				hl_group = utils.set_hl(config.hl),

				hl_mode = "combine",
			});
		elseif config.preview then
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.callout_start, {
				end_col = range.callout_end,
				conceal = "",
				undo_restore = false, invalidate = true,
				virt_text_pos = "inline",
				virt_text = {
					{ " " },
					{ config.preview, utils.set_hl(config.preview_hl or config.hl) }
				},

				right_gravity = true,
				hl_mode = "combine",
			});
		end
	end

	for l = range.row_start, range.row_end - 1, 1  do
		local l_index = l - (range.row_start) + 1;

		local line = item.text[l_index];
		local line_len = #line;

		if line:match("^%>") then
			--[[
				NOTE: Using `conceal` with `virt_text_pos = "inline"` results in issues with text wrapping.

				This happens because we are doubling the border size by using `conceal`.

				TODO: This may need to be reviewed later.
			]]
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, l, range.col_start, {
				undo_restore = false, invalidate = true,
				right_gravity = true,

				end_col = range.col_start + math.min(1, line_len),

				virt_text_pos = "overlay",
				virt_text = {
					{
						tbl_clamp(config.border, l_index),
						utils.set_hl(tbl_clamp(config.border_hl, l_index) or config.hl)
					}
				},

				hl_mode = "combine",
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, l, range.col_start, {
				undo_restore = false, invalidate = true,
				right_gravity = true,

				virt_text_pos = "inline",
				virt_text = {
					{
						tbl_clamp(config.border, l_index),
						utils.set_hl(tbl_clamp(config.border_hl, l_index) or config.hl)
					},
					{ " " }
				},

				hl_mode = "combine",
			});
		end
	end

	---@type integer, integer Start & end fold level.
	local foldlevel_s, foldlevel_e;

	vim.api.nvim_buf_call(buffer, function ()
		foldlevel_s = vim.fn.foldlevel(range.row_start + 1);
		foldlevel_e = vim.fn.foldlevel(range.row_end + 1);
	end)

	if foldlevel_s ~= 0 or foldlevel_e ~= 0 then
		--- Text was folded.
		return;
	end

	--- TODO: Feat
	local win = utils.buf_getwin(buffer);

	if win and main_config.wrap == true and vim.wo[win].wrap == true then
		--- When `wrap` is enabled, run post-processing effects.
		table.insert(markdown.cache, item);
	end
end

--- Renders [ ], [x] & [X].
---@param buffer integer
---@param item markview.parsed.markdown.checkboxes
markdown.checkbox = function (buffer, item)
	--- Wrapper for the inline checkbox renderer function.
	--- Used for [ ] & [X] checkboxes.
	inline.checkbox(buffer, item)
end

--- Renders fenced code blocks.
---@param buffer integer
---@param item markview.parsed.markdown.code_blocks
markdown.code_block = function (buffer, item)
	---@type markview.config.markdown.code_blocks?
	local config = spec.get({ "markdown", "code_blocks" }, { fallback = nil, eval_args = { buffer, item } });

	local delims = item.delimiters;
	local range = item.range;

	local info_range = range.info_string or {};

	if not config then
		return;
	end

	local decorations = filetypes.get(item.language);
	local label = { string.format(" %s%s ", decorations.icon, decorations.name), config.label_hl or decorations.icon_hl };
	local win = utils.buf_getwin(buffer);

	--- Column end for concealing code block language string.
	---@return integer
	local function lang_conceal_to ()
		if item.info_string == nil then
			return range.start_delim[4];
		else
			local _to = item.info_string:match("^%S+%s*"):len();
			return (range.info_string and range.info_string[2] or range.start_delim[4]) + _to;
		end
	end

	--- Gets highlight configuration for a line.
	---@param line string
	---@return markview.config.markdown.code_blocks.opts
	local function get_line_config(line)
		local line_conf = utils.match(config, item.language, {
			eval_args = { buffer, line },
			def_fallback = {
				block_hl = config.border_hl,
				pad_hl = config.border_hl
			},
			fallback = {
				block_hl = config.border_hl,
				pad_hl = config.border_hl
			}
		});

		return line_conf;
	end

	--[[ *Basic* rendering of `code blocks`. ]]
	local function render_simple()
		---|fS

		---@cast config markview.config.markdown.code_blocks.simple

		local conceal_from = range.start_delim[2] + #string.match(item.delimiters[1], "^%s*");
		local conceal_to = lang_conceal_to();

		if config.label_direction == nil or config.label_direction == "left" then
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, conceal_from, {
				undo_restore = false, invalidate = true,

				end_col = conceal_to,
				conceal = "",

				sign_text = config.sign == true and decorations.sign or nil,
				sign_hl_group = utils.set_hl(config.sign_hl or decorations.sign_hl),

				virt_text_pos = "inline",
				virt_text = { label },

				line_hl_group = utils.set_hl(config.border_hl)
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, conceal_from, {
				undo_restore = false, invalidate = true,

				end_col = conceal_to,
				conceal = "",

				sign_text = config.sign == true and decorations.sign or nil,
				sign_hl_group = utils.set_hl(config.sign_hl or decorations.sign_hl),

				virt_text_pos = "right_align",
				virt_text = { label },

				line_hl_group = utils.set_hl(config.border_hl)
			});
		end

		if item.info_string then
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, info_range[1], info_range[2], {
				undo_restore = false, invalidate = true,

				end_row = info_range[3],
				end_col = info_range[4],

				hl_group = utils.set_hl(config.info_hl or config.border_hl)
			});
		end

		--- Background
		for l = range.row_start + 1, range.row_end - 2 do
			local line = item.text[(l - range.row_start) + 1];
			local line_config = get_line_config(line);

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, l, 0, {
				undo_restore = false, invalidate = true,
				end_row = l,

				line_hl_group = utils.set_hl(line_config.block_hl --[[ @as string ]])
			});
		end

		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end - 1, (range.col_start + #item.text[#item.text]) - #delims[2], {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + #item.text[#item.text],
			conceal = "",

			line_hl_group = utils.set_hl(config.border_hl)
		});

		---|fE
	end

	--- Renders block style code blocks.
	local function render_block ()
		---|fS

		---@cast config markview.config.markdown.code_blocks.block

		---|fS "chunk: Calculate various widths"

		local pad_amount = config.pad_amount or 0;
		local block_width = config.min_width or 60;

		local pad_char = config.pad_char or " ";

		---@type integer[] Visual width of lines.
		local line_widths = {};

		for l, line in ipairs(item.text) do
			local final = markdown.get_visual_text:init(decorations.name, line);

			if l ~= 1 and l ~= #item.text then
				table.insert(line_widths, vim.fn.strdisplaywidth(final));

				if vim.fn.strdisplaywidth(final) > (block_width - (2 * pad_amount)) then
					block_width = vim.fn.strdisplaywidth(final) + (2 * pad_amount);
				end
			end
		end

		local label_width = utils.virt_len({ label });
		---|fE

		local delim_conceal_from = range.start_delim[2] + #string.match(item.delimiters[1], "^%s*");
		local conceal_to = lang_conceal_to();

		---|fS "chunk: Top border"

		local visible_info = string.sub(item.text[1], (conceal_to + 1) - range.col_start);
		local left_padding = visible_info ~= "" and 1 or pad_amount;

		local pad_width = vim.fn.strdisplaywidth(
			string.rep(pad_char, left_padding)
		);

		-- Hide the leading `backticks`s.
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, delim_conceal_from, {
			undo_restore = false, invalidate = true,

			end_col = conceal_to,
			conceal = ""
		});

		if config.label_direction == "right" then
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, delim_conceal_from, {
				virt_text_pos = "inline",
				virt_text = {
					{
						string.rep(" " or pad_char, left_padding),
						utils.set_hl(config.border_hl)
					}
				}
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + #item.text[1], {
				virt_text_pos = "inline",
				virt_text = {
					{
						string.rep(" " or pad_char, left_padding),
						utils.set_hl(config.border_hl)
					}
				}
			});
		end

		---|fS "chunk: Prettify info"

		if visible_info then
			local visible_size = vim.fn.strdisplaywidth(visible_info);

			if (pad_amount + visible_size + label_width) >= block_width then
				-- Calculating where to wrap from,
				-- 1. Start of the of the block = End of delimiter(`conceal_to`) - Start of the block(`range.col_start`).
				-- 2. Space for the info string = Width of block(`block_width`) - Width of label(`label_width`) - Width of padding(`pad_width`).
				local conceal_from = (conceal_to - range.col_start) + (block_width - (label_width + pad_width));

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, conceal_from, {
					end_col = #item.text[1],
					conceal = ""
				});
			else
				-- Calculating the amount of spacing to add,
				-- 1. Used space = Visible text width(`visible_size`) + label width(`label_width`) + padding size(`pad_width`).
				-- 2. Total block width - Used space
				local spacing = block_width - (visible_size + label_width + pad_width);

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + #item.text[1], {
					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(pad_char, spacing),
							utils.set_hl(config.border_hl)
						},
					}
				});
			end

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, conceal_to, {
				end_col = range.col_start + #item.text[1],
				hl_group = utils.set_hl(config.info_hl),
				hl_mode = "combine"
			});
		else
			-- Calculating the amount of spacing to add,
			-- 1. Used space = label width(`label_width`) + padding size(`pad_width`).
			-- 2. Total block width - Used space
			local spacing = block_width - (label_width + pad_width);

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + #item.text[1], {
				virt_text_pos = "inline",
				virt_text = {
					{
						string.rep(pad_char, spacing),
						utils.set_hl(config.border_hl)
					},
				}
			});
		end

		---|fE

		---|fS "chunk: Place label"

		local top_border = {
		};

		if config.label_direction == "right" then
			top_border.col_start = range.start_delim[2] + #item.text[1];
		else
			top_border.col_start = range.start_delim[4];
		end

		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, top_border.col_start, {
			virt_text_pos = "inline",
			virt_text = { label }
		});

		---|fE

		---|fE

		--- Line padding
		for l, width in ipairs(line_widths) do
			local line = item.text[l + 1];
			local line_config = get_line_config(line);

			if width ~= 0 then
				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + l, line ~= "" and range.col_start or 0, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(" ", pad_amount),
							utils.set_hl(line_config.pad_hl --[[ @as string ]])
						}
					},
				});

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + l, range.col_start + #line, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(" ", math.max(0, block_width - (( 2 * pad_amount) + width))),
							utils.set_hl(line_config.block_hl --[[ @as string ]])
						},
						{
							string.rep(" ", pad_amount),
							utils.set_hl(line_config.pad_hl --[[ @as string ]])
						}
					},
				});

				--- Background
				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + l, range.col_start, {
					undo_restore = false, invalidate = true,
					end_col = range.col_start + #line,

					hl_group = utils.set_hl(line_config.block_hl --[[ @as string ]])
				});
			else
				local buf_line = vim.api.nvim_buf_get_lines(buffer, range.row_start + l, range.row_start + l + 1, false)[1];

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + l, #buf_line, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(" ", math.max(0, range.col_start - #buf_line))
						},
						{
							string.rep(" ", pad_amount),
							utils.set_hl(line_config.pad_hl --[[ @as string ]])
						},
						{
							string.rep(" ", math.max(0, block_width - (2 * pad_amount))),
							utils.set_hl(line_config.block_hl --[[ @as string ]])
						},
						{
							string.rep(" ", pad_amount),
							utils.set_hl(line_config.pad_hl --[[ @as string ]])
						},
					},
				});
			end
		end

		--- Render bottom
		if item.delimiters[2] then
			local end_delim_conceal_from = range.end_delim[2] + #string.match(item.delimiters[2], "^%s*");

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end - 1, end_delim_conceal_from, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + #item.text[#item.text],
				conceal = ""
			});

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end - 1, end_delim_conceal_from, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{
						string.rep(" ", block_width),
						utils.set_hl(config.border_hl)
					}
				}
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end - 1, range.col_start, {
				undo_restore = false, invalidate = true,

				virt_text_pos = "inline",
				virt_text = {
					{
						string.rep(" ", block_width),
						utils.set_hl(config.border_hl)
					}
				}
			});
		end

		---|fE
	end

	if not win or config.style == "simple" or ( vim.o.wrap == true or vim.wo[win].wrap == true ) then
		render_simple();
	elseif config.style == "block" then
		render_block()
	end
end

--- Renders fenced code blocks.
---@param buffer integer
---@param item markview.parsed.markdown.indented_code_blocks
markdown.indented_code_block = function (buffer, item)
	---@type markview.config.markdown.code_blocks?
	local config = spec.get({ "markdown", "code_blocks" }, { fallback = nil, eval_args = { buffer, item } });

	local range = item.range;

	if not config then
		return;
	end

	--- Gets highlight configuration for a line.
	---@param line string
	---@return markview.config.markdown.code_blocks.opts
	local function get_line_config(line)
		local line_conf = utils.match(config, "indent", {
			eval_args = { buffer, line },
			def_fallback = {
				block_hl = config.border_hl,
				pad_hl = config.border_hl
			},
			fallback = {
				block_hl = config.border_hl,
				pad_hl = config.border_hl
			}
		});

		return line_conf;
	end

	local decorations = filetypes.get("indented");
	local label = { string.format(" %s%s ", decorations.icon, decorations.name), config.label_hl or decorations.icon_hl };

	--[[ *Basic* rendering of `code blocks`. ]]
	local function render_simple()
		---|fS

		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,

			sign_text = config.sign == true and decorations.sign or nil,
			sign_hl_group = utils.set_hl(config.sign_hl or decorations.sign_hl),

			virt_text_pos = "right_align",
			virt_text = { label },
		});

		--- Background
		for l = range.row_start, range.row_end - 1 do
			local line_config = config.default;

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, l, 0, {
				undo_restore = false, invalidate = true,
				end_row = l,

				line_hl_group = utils.set_hl(line_config.block_hl --[[ @as string ]])
			});
		end

		---|fE
	end

	--[[ Renders **block style** `code block`s. ]]
	local function render_block ()
		---|fS

		---@cast config markview.config.markdown.code_blocks.block

		---|fS "chunk: Calculate various widths"

		local text = vim.api.nvim_buf_get_lines(buffer, range.row_start, range.row_end, false);

		local pad_amount = config.pad_amount --[[@as integer]] or 0;
		local block_width = config.min_width --[[@as integer]] or 60;

		local pad_char = config.pad_char --[[@as string]] or " ";
		local label_width = utils.virt_len({ label });

		local pad_width = vim.fn.strdisplaywidth(
			string.rep(pad_char, pad_amount)
		);

		---@type integer[] Visual width of lines.
		local line_widths = {};

		for l, _ in ipairs(item.text) do
			local final = string.sub(text[l], range.space_end);
			local w = vim.fn.strdisplaywidth(final)

			table.insert(line_widths, w);

			if l == 1 then
				if (pad_amount + w + label_width) > block_width then
					block_width = pad_amount + w + label_width;
				end
			else
				if (pad_amount + w + pad_amount) > block_width then
					block_width = pad_amount + w + pad_amount;
				end
			end
		end

		---|fE

		for l = range.row_start, range.row_end - 1 do
			local row = (l + 1) - range.row_start;

			local line = item.text[row];
			local width = line_widths[row];

			local line_config = get_line_config(line);

			local line_size = #text[row];

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, l, math.min(line_size, range.col_start), {
				undo_restore = false, invalidate = true,
				end_col = line_size > range.space_end and range.space_end or line_size,

				conceal = "",
				virt_text_pos = "inline",
				virt_text = {
					{
						string.rep(" ", range.col_start - line_size)
					},
					{
						string.rep(pad_char, pad_amount),
						utils.set_hl(line_config.pad_hl --[[ @as string ]])
					}
				}
			});

			if line_size >= range.space_end then
				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, l, range.space_end, {
					undo_restore = false, invalidate = true,
					end_col = line_size,

					hl_group = line_config.block_hl --[[ @as string ]]
				});
			end


			if l == range.row_start then
				local extra_space = block_width - (pad_width + width + label_width);

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, l, math.min(line_size, range.col_start + #line), {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(pad_char, extra_space),
							utils.set_hl(line_config.block_hl --[[ @as string ]])
						},
						label
					}
				});
			else
				local extra_space = block_width - (pad_width + width + pad_width) - (width == 0 and 1 or 0);

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, l, math.min(line_size, range.col_start + #line), {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(pad_char, extra_space),
							utils.set_hl(line_config.block_hl --[[ @as string ]])
						},
						{
							string.rep(pad_char, pad_amount),
							utils.set_hl(line_config.pad_hl --[[ @as string ]])
						}
					}
				});
			end
		end

		---|fE
	end

	---@type integer Window containing `buffer`.
	local win = utils.buf_getwin(buffer);

	if not win or config.style == "simple" or ( vim.o.wrap == true or vim.wo[win].wrap == true ) then
		render_simple();
	elseif config.style == "block" then
		render_block()
	end
end

--- Renders horizontal rules/line breaks.
---@param buffer integer
---@param item markview.parsed.markdown.hr
markdown.hr = function (buffer, item)
	---@type markview.config.markdown.hr?
	local config = spec.get({ "markdown", "horizontal_rules" }, { fallback = nil, eval_args = { buffer, item } });
	local range = item.range;

	if not config then
		return;
	end

	local virt_text = {};
	local function val(opt, index, wrap)
		if vim.islist(opt) == false then
			return opt;
		elseif #opt < index then
			if wrap == true then
				local mod = index % #opt;
				return mod == 0 and opt[#opt] or opt[mod];
			else
				return opt[#opt];
			end
		elseif index < 0 then
			return opt[1];
		end

		return opt[index];
	end

	for _, part in ipairs(config.parts) do
		if part.type == "text" then
			table.insert(virt_text, { part.text, utils.set_hl(part.hl --[[ @as string ]]) });
		elseif part.type == "repeating" then
			local rep     = spec.get({ "repeat_amount" }, { source = part, fallback = 1, eval_args = { buffer, item } });
			local hl_rep  = spec.get({ "repeat_hl" }, { source = part, fallback = false, eval_args = { buffer, item } });
			local txt_rep = spec.get({ "repeat_text" }, { source = part, fallback = false, eval_args = { buffer, item } });

			for r = 1, rep, 1 do
				if part.direction == "right" then
					table.insert(virt_text, {
						val(part.text, (rep - r) + 1, txt_rep),
						val(part.hl, (rep - r) + 1, hl_rep)
					});
				else
					table.insert(virt_text, {
						val(part.text, r, txt_rep),
						val(part.hl, r, hl_rep)
					});
				end
			end
		end
	end

	vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, 0, {
		undo_restore = false, invalidate = true,
		virt_text_pos = "overlay",
		virt_text = virt_text,

		hl_mode = "combine"
	});
end

--- Renders reference link definitions.
---@param buffer integer
---@param item markview.parsed.markdown.reference_definitions
markdown.link_ref_definition = function (buffer, item)
	---@type markview.config.markdown.ref_def?
	local main_config = spec.get({ "markdown", "reference_definitions" }, { fallback = nil });
	local range = item.range;

	if not main_config then
		return;
	end

	---@type markview.config.__inline
	local config = utils.match(
		main_config,
		item.description or "",
		{
			eval_args = { buffer, item }
		}
	);

	if not config then
		return;
	end

	local r_label = range.label;

	vim.api.nvim_buf_set_extmark(buffer, markdown.ns, r_label[1], r_label[2], {
		undo_restore = false, invalidate = true,
		end_col = r_label[2] + 1,
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
			{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

			{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) }
		},

		hl_mode = "combine"
	});

	vim.api.nvim_buf_set_extmark(buffer, markdown.ns, r_label[1], r_label[2], {
		undo_restore = false, invalidate = true,
		end_row = r_label[3],
		end_col = r_label[4],
		hl_group = utils.set_hl(config.hl)
	});

	vim.api.nvim_buf_set_extmark(buffer, markdown.ns, r_label[3], r_label[4] - 1, {
		undo_restore = false, invalidate = true,
		end_row = r_label[3],
		end_col = r_label[4],
		conceal = "",

		virt_text_pos = "inline",
		virt_text = {
			{ config.padding_right or "", utils.set_hl(config.padding_right_hl or config.hl) },
			{ config.corner_right or "", utils.set_hl(config.corner_right_hl or config.hl) }
		},

		hl_mode = "combine"
	});
end

--- Renders list items
---@param buffer integer
---@param item markview.parsed.markdown.list_items
markdown.list_item = function (buffer, item)
	---@type markview.config.markdown.list_items?
	local main_config = spec.get({ "markdown", "list_items" }, {
		fallback = nil,
		eval_args = { buffer, item }
	});
	local range = item.range;

	if not main_config then
		return;
	end

	---@type markview.config.markdown.list_items.ordered | markview.config.markdown.list_items.unordered
	local config;

	local shift_width = type(main_config.shift_width) == "number" and main_config.shift_width or 1;
	local indent_size = type(main_config.indent_size) == "number" and main_config.indent_size or 1;

	---@cast indent_size integer
	---@cast shift_width integer

	if item.marker == "-" then
		config = spec.get({ "marker_minus" }, {
			source = main_config,
			eval_args = { buffer, item }
		});
	elseif item.marker == "+" then
		config = spec.get({ "marker_plus" }, {
			source = main_config,
			eval_args = { buffer, item }
		});
	elseif item.marker == "*" then
		config = spec.get({ "marker_star" }, {
			source = main_config,
			eval_args = { buffer, item }
		});
	elseif item.marker:match("%d+%.") then
		config = spec.get({ "marker_dot" }, {
			source = main_config,
			eval_args = { buffer, item }
		});
	elseif item.marker:match("%d+%)") then
		config = spec.get({ "marker_parenthesis" }, {
			source = main_config,
			eval_args = { buffer, item }
		});
	end

	if not config then
		return;
	end

	if config.add_padding == true then
		for _, l in ipairs(item.candidates) do
			local from, to = math.min(range.col_start, item.text[l + 1]:len()), math.min(range.col_start + item.indent, item.text[l + 1]:len());

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + l, from, {
				undo_restore = false, invalidate = true,
				end_col = to,
				conceal = "",
				right_gravity = false,

				virt_text_pos = "inline",
				virt_text = {
					{ string.rep(" ", math.max(0, (math.ceil(item.indent / math.max(1, indent_size)) + 1) * shift_width)) }
				}
			});
		end
	end

	--- Evaluation arguments for checkboxes.
	--- Used for turning function values into static values.
	local chk_args = {
		buffer,
		{
			class = "inline_checkbox",

			text = item.checkbox,
			range = nil
		}
	};

	--- Gets checkbox state
	---@param state string?
	---@return markview.config.markdown_inline.checkboxes.opts?
	local function get_state (state)
		local checkboxes = spec.get({ "markdown_inline", "checkboxes" }, { fallback = nil });

		if state == nil or checkboxes == nil then
			return;
		end

		if state == "x" or state == "X" then
			return spec.get({ "checked" }, { source = checkboxes, eval_args = chk_args });
		elseif state == " " then
			return spec.get({ "unchecked" }, { source = checkboxes, eval_args = chk_args });
		end

		local _state = vim.pesc(state);
		return utils.match(checkboxes, "^" .. _state .. "$", { default = false, ignore_keys = { "checked", "unchecked", "enable" }, eval_args = chk_args });
	end

	local checkbox = get_state(item.checkbox);

	if checkbox then
		if config.conceal_on_checkboxes == true then
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + item.indent, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + (item.indent + #item.marker + 1),

				conceal = ""
			});
		end

		if not checkbox.scope_hl then
			goto exit;
		end

		for l, line in ipairs(item.text) do
			if l == 1 then
				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + (item.indent + #item.marker + 5), {
					undo_restore = false, invalidate = true,
					end_col = #item.text[1],

					hl_group = utils.set_hl(checkbox.scope_hl)
				});
			elseif line ~= "" then
				local spaces = line:match("^([%>%s]*)");

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + (l - 1), #spaces, {
					undo_restore = false, invalidate = true,
					end_col = #item.text[l],

					hl_group = utils.set_hl(checkbox.scope_hl)
				});
			end
		end
	elseif config.text and config.text ~= "" then
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + item.indent, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + (item.indent + #item.marker),
			conceal = "",

			virt_text_pos = "inline",
			virt_text = {
				{ config.text, utils.set_hl(config.hl) }
			},

			hl_mode = "combine"
		});
	end

	::exit::

	---@type integer, integer Start & end fold level.
	local foldlevel_s, foldlevel_e;

	vim.api.nvim_buf_call(buffer, function ()
		foldlevel_s = vim.fn.foldlevel(range.row_start + 1);
		foldlevel_e = vim.fn.foldlevel(range.row_end + 1);
	end)

	if foldlevel_s ~= 0 or foldlevel_e ~= 0 then
		--- Text was folded.
		return;
	end

	local win = utils.buf_getwin(buffer);

	--- BUG, Post-processing effects become inaccurate when
	--- list items are inside block quotes.
	if win and main_config.wrap == true and vim.wo[win].wrap == true then
		--- When `wrap` is enabled, run post-processing effects.
		table.insert(markdown.cache, item);
	end
end

--- Renders metadatas.
---@param buffer integer
---@param item markview.parsed.markdown.metadata_minus
markdown.metadata_minus = function (buffer, item)
	---@type markview.config.markdown.metadata?
	local config = spec.get({ "markdown", "metadata_minus" }, { fallback = nil, eval_args = { buffer, item } });
	local range = item.range;

	if not config then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, 0, {
		undo_restore = false, invalidate = true,
		end_col = #item.text[1],
		conceal = "",

		virt_text_pos = "overlay",
		virt_text = config.border_top and {
			{
				string.rep(
					config.border_top,
					vim.api.nvim_win_get_width(
						utils.buf_getwin(buffer)
					)
				),
				utils.set_hl(config.border_top_hl or config.border_hl or config.hl)
			}
		} or nil
	});

	vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end - 1, 0, {
		undo_restore = false, invalidate = true,
		end_col = #item.text[#item.text],
		conceal = "",

		virt_text_pos = "overlay",
		virt_text = config.border_bottom and {
			{
				string.rep(
					config.border_bottom,
					vim.api.nvim_win_get_width(
						utils.buf_getwin(buffer)
					)
				),
				utils.set_hl(config.border_bottom_hl or config.border_hl or config.hl)
			}
		} or nil
	});

	for r = range.row_start + 1, range.row_end - 2, 1 do
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, r, 0, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ "   ", utils.set_hl(config.hl) }
			},

			right_gravity = false,
			line_hl_group = utils.set_hl(config.hl)
		});
	end
end

--- Renders + metadatas.
---@param buffer integer
---@param item markview.parsed.markdown.metadata_plus
markdown.metadata_plus = function (buffer, item)
	---@type markview.config.markdown.metadata?
	local config = spec.get({ "markdown", "metadata_plus" }, { fallback = nil, eval_args = { buffer, item } });
	local range = item.range;

	if not config then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, 0, {
		undo_restore = false, invalidate = true,
		end_col = #item.text[1],
		conceal = "",

		virt_text_pos = "overlay",
		virt_text = config.border_top and {
			{
				string.rep(
					config.border_top,
					vim.api.nvim_win_get_width(
						utils.buf_getwin(buffer)
					)
				),
				utils.set_hl(config.border_top_hl or config.border_hl or config.hl)
			}
		} or nil
	});

	vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end - 1, 0, {
		undo_restore = false, invalidate = true,
		end_col = #item.text[#item.text],
		conceal = "",

		virt_text_pos = "overlay",
		virt_text = config.border_bottom and {
			{
				string.rep(
					config.border_bottom,
					vim.api.nvim_win_get_width(
						utils.buf_getwin(buffer)
					)
				),
				utils.set_hl(config.border_bottom_hl or config.border_hl or config.hl)
			}
		} or nil
	});

	for r = range.row_start + 1, range.row_end - 1, 1 do
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, r, 0, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ "   ", utils.set_hl(config.hl) }
			},

			line_hl_group = utils.set_hl(config.hl)
		});
	end
end

--- Render org mode like section indentations.
---@param buffer integer
---@param item markview.parsed.markdown.sections
markdown.section = function (buffer, item)
	---@type markview.config.markdown.headings?
	local main_config = spec.get({ "markdown", "headings" }, { fallback = nil, eval_args = { buffer, item } });

	if main_config == nil then
		return;
	elseif main_config.org_indent ~= true then
		--- Org indent mode disabled.
		return;
	end

	local shift_width = main_config.org_shift_width or main_config.shift_width or 0;
	local shift_char = main_config.org_shift_char or " ";

	local range = item.range;

	for l = range.row_start + 1, range.org_end do
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, l, 0, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{
					string.rep(
						shift_char,
						math.max(
							0,
							shift_width * (item.level - 1)
						)
					)
				}
			},

			right_gravity = false,
			hl_mode = "combine"
		});
	end

	---@type integer, integer Start & end fold level.
	local foldlevel_s, foldlevel_e;

	vim.api.nvim_buf_call(buffer, function ()
		foldlevel_s = vim.fn.foldlevel(range.row_start + 1);
		foldlevel_e = vim.fn.foldlevel(range.row_end + 1);
	end)

	if foldlevel_s ~= 0 or foldlevel_e ~= 0 then
		--- Text was folded.
		return;
	end

	local win = utils.buf_getwin(buffer);

	if win and main_config.org_indent_wrap == true and vim.wo[win].wrap == true then
		--- When `wrap` is enabled, run post-processing effects.
		table.insert(markdown.cache, item);
	end
end

--- Renders setext headings.
---@param buffer integer
---@param item markview.parsed.markdown.setext_headings
markdown.setext_heading = function (buffer, item)
	---@type markview.config.markdown.headings?
	local main_config = spec.get({ "markdown", "headings" }, { fallback = nil, eval_args = { buffer, item } });
	local lvl = item.marker:match("%=") and 1 or 2;

	local shift_width = spec.get({ "shift_width" }, { source = main_config, fallback = 1, eval_args = { buffer, item } });

	if not main_config then
		return;
	elseif not spec.get({ "setext_" .. lvl }, { source = main_config }) then
		return;
	end

	---@type markview.config.markdown.headings.setext
	local config = spec.get({ "setext_" .. lvl }, { source = main_config });
	local range = item.range;

	if config.style == "simple" then
		---@cast config markview.config.markdown.headings.setext.simple

		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,

			sign_text = config.sign,
			sign_hl_group = utils.set_hl(config.sign_hl),

			end_row = range.row_end,
			end_col = range.col_end,

			line_hl_group = utils.set_hl(config.hl)
		});
	elseif config.style == "decorated" then
		---@cast config markview.config.markdown.headings.setext.decorated

		if config.icon then
			for l = 1, (range.row_end - range.row_start) - 1 do
				local line = item.text[l];

				if
					math.floor((range.row_end - range.row_start) / 2) == 0 or
					l == math.floor((range.row_end - range.row_start) / 2)
				then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + (l - 1), math.min(#line, range.col_start), {
						undo_restore = false, invalidate = true,

						sign_text = config.sign,
						sign_hl_group = utils.set_hl(config.sign_hl),

						line_hl_group = utils.set_hl(config.hl),

						virt_text_pos = "inline",
						virt_text = {
							{
								string.rep(" ", shift_width * (lvl - 1)),
								utils.set_hl(config.hl)
							},
							{
								config.icon,
								utils.set_hl(config.icon_hl or config.hl)
							}
						},

						hl_mode = "combine",
					});
				else
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + (l - 1), math.min(#line, range.col_start), {
						undo_restore = false, invalidate = true,

						line_hl_group = utils.set_hl(config.hl),

						virt_text_pos = "inline",
						virt_text = {
							{
								string.rep(" ", shift_width * (lvl - 1)),
								utils.set_hl(config.hl)
							},
							{
								string.rep(" ", vim.fn.strdisplaywidth(config.icon)),
								utils.set_hl(config.icon_hl or config.hl)
							}
						},

						hl_mode = "combine",
					});
				end
			end
		end

		if config.border then
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end - 1, range.col_start, {
				undo_restore = false, invalidate = true,
				end_row = range.row_end - 1,
				end_col = range.col_end,
				line_hl_group = utils.set_hl(config.hl),
				virt_text_pos = "overlay",
				virt_text = {
					{
						string.rep(config.border, vim.o.columns),
						utils.set_hl(config.border_hl or config.hl)
					}
				},

				hl_mode = "combine",
			});
		end
	end
end

--- Renders tables.
---@param buffer integer
---@param item markview.parsed.markdown.tables
markdown.table = function (buffer, item)
	---@type markview.config.markdown.tables?
	local config = spec.get({ "markdown", "tables" }, { fallback = nil, eval_args = { buffer, item } });
	local range = item.range;

	local is_wrapped = false;

	if not config then
		return;
	else
		local win = utils.buf_getwin(buffer);

		if type(win) ~= "number" then
			--- Window doesn't exist.
			return;
		elseif vim.wo[win].wrap == true then
			--- BUG, wrap breaks table rendering.
			is_wrapped = true;
		end

		local left_col;

		vim.api.nvim_win_call(win, function ()
			--- TODO, Find a more performant way to
			--- get this value.
			left_col = vim.fn.winsaveview().leftcol;
		end)

		if type(left_col) == "number" and left_col > range.col_start then
			return;
		end
	end

	---@type boolean
	local strict = config.strict ~= nil and config.strict or true;

	if item.has_alignment_markers == false then
		-- Disable strict mode if no alignment
		-- markers are found.
		strict = false;
	end

	---@type integer[] Visible column widths(may be inaccurate).
	local col_widths = {};

	--- Holds text for the different table cells.
	---
	---@type { header: string[], rows: string[][] }
	local visible_texts = {
		header = {},
		rows = {}
	};

	---@type integer[] Invisible width used for text wrapping in Neovim.
	local vim_width = {};

	---@type integer Current column number.
	local c = 1;

	markdown.__new_config();

	for _, col in ipairs(item.header) do
		if col.class == "column" then
			local _o, dec = markdown.output(col.text, buffer);
			local o = vim.fn.strdisplaywidth(_o);

			table.insert(visible_texts.header, o);

			if not col_widths[c] or col_widths[c] < o then
				col_widths[c] = o;
			end

			local vim_col_width = vim.fn.strdisplaywidth(col.text) + (dec or 0);

			if not vim_width[c] then
				vim_width[c] = vim_col_width;
			elseif vim_col_width > vim_width[c] then
				vim_width[c] = vim_col_width;
			end

			c = c + 1;
		end
	end

	c = 1;

	for _, col in ipairs(item.separator) do
		if col.class == "column" then
			local o = vim.fn.strdisplaywidth(col.text);

			if not col_widths[c] or col_widths[c] < o then
				col_widths[c] = o;
			end

			local vim_col_width = vim.fn.strdisplaywidth(col.text);

			if not vim_width[c] then
				vim_width[c] = vim_col_width;
			elseif vim_col_width > vim_width[c] then
				vim_width[c] = vim_col_width;
			end

			c = c + 1;
		end
	end

	for r, row in ipairs(item.rows) do
		c = 1;
		table.insert(visible_texts.rows, {})

		for _, col in ipairs(row) do
			if col.class == "column" then
				local _o, dec = markdown.output(col.text, buffer);
				local o = vim.fn.strdisplaywidth(_o);

				table.insert(visible_texts.rows[r], o);

				if not col_widths[c] or col_widths[c] < o then
					col_widths[c] = o;
				end

				local vim_col_width = vim.fn.strdisplaywidth(col.text) + (dec or 0);

				if not vim_width[c] then
					vim_width[c] = vim_col_width;
				elseif vim_col_width > vim_width[c] then
					vim_width[c] = vim_col_width;
				end

				c = c + 1;
			end
		end
	end

	if is_wrapped == true then
		local win = utils.buf_getwin(buffer);
		local width = vim.api.nvim_win_get_width(win);

		local table_width = 1;

		for _, col in ipairs(vim_width) do
			table_width = table_width + 1 + col;
		end

		if table_width >= width * 0.9 then
			--- Most likely the text was wrapped somewhere.
			--- TODO, Check if a more accurate(& faster) method exists or not.
			return;
		end
	end

	---@type markview.config.markdown.tables.parts
	local parts = config.parts;
	---@type markview.config.markdown.tables.parts
	local hls = config.hl;

	local function get_border(from, index)
		if not parts or not parts[from] then
			return "", nil;
		end

		local hl;

		if hls and hls[from] then
			hl = hls[from][index];
		end

		return parts[from][index], utils.set_hl(hl);
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
			local border, border_hl = get_border("header", 2);
			local top, top_hl = get_border("top", 4);

			if p == 1 then
				border, border_hl = get_border("header", 1);
				top, top_hl = get_border("top", 1);
			elseif p == #item.header then
				border, border_hl = get_border("header", 3);
				top, top_hl = get_border("top", 3);
			end

			table.insert(tmp, {
				top,
				is_wrapped and "@punctuation.special.markdown" or utils.set_hl(top_hl)
			});

			if is_wrapped == false then
				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + part.col_start, {
					undo_restore = false, invalidate = true,
					end_col = range.col_start + part.col_end,
					conceal = "",

					virt_text_pos = "inline",
					virt_text = {
						{ border, border_hl }
					},

					hl_mode = "combine"
				})
			end


			if p == #item.header and config.block_decorator == true then
				local prev_line = range.row_start == 0 and 0 or #vim.api.nvim_buf_get_lines(buffer, range.row_start - 1, range.row_start, false)[1];

				if config.use_virt_lines == true then
					table.insert(tmp, 1, { string.rep(" ", range.col_start) });
				elseif range.row_start > 0 and prev_line < range.col_start then
					table.insert(tmp, 1, { string.rep(" ", math.max(0, range.col_start - prev_line)) });
				end

				if config.use_virt_lines == true then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start, {
						undo_restore = false, invalidate = true,
						virt_lines_above = true,
						virt_lines = { tmp },

						hl_mode = "combine"
					})
				elseif item.top_border == true and range.row_start > 0 then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start - 1, math.min(range.col_start, prev_line), {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = tmp,

						hl_mode = "combine"
					})
				end
			end
		elseif part.class == "missing_seperator" then
			local border, border_hl = get_border("header", p == 1 and 1 or 3);
			local top, top_hl = get_border("top", p == 1 and 1 or 3);

			table.insert(tmp, {
				top,
				is_wrapped and "@punctuation.special.markdown" or utils.set_hl(top_hl)
			});

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + part.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + part.col_end,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{
						border,
						is_wrapped and "@punctuation.special.markdown" or utils.set_hl(border_hl)
					}
				},

				right_gravity = p ~= 1,
				hl_mode = "combine"
			})

			if p == #item.header and config.block_decorator == true then
				local prev_line = range.row_start == 0 and 0 or #vim.api.nvim_buf_get_lines(buffer, range.row_start - 1, range.row_start, false)[1];

				if config.use_virt_lines == true then
					table.insert(tmp, 1, {
						string.rep(" ", range.col_start)
					});
				elseif range.row_start > 0 and prev_line < range.col_start then
					table.insert(tmp, 1, {
						string.rep(" ", math.max(0, range.col_start - prev_line))
					});
				end

				if config.use_virt_lines == true then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start, {
						undo_restore = false, invalidate = true,
						virt_lines_above = true,
						virt_lines = { tmp },

						hl_mode = "combine"
					})
				elseif range.row_start > 0 and item.top_border == true then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start - 1, math.min(prev_line, range.col_start), {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = tmp,

						hl_mode = "combine"
					})
				end
			end
		elseif part.class == "column" then
			local visible_width = visible_texts.header[c];
			local column_width  = col_widths[c];

			if strict then
				local before = string.match(part.text, "^%s*");
				local after = string.match(part.text, "%s*$");

				if #before > 1 then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + part.col_start + 1, {
						undo_restore = false, invalidate = true,
						end_col = range.col_start + part.col_start + #before,
						conceal = ""
					});

					visible_width = visible_width - (#before - 1);
				end

				if #after > 1 then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + part.col_end - #after, {
						undo_restore = false, invalidate = true,
						end_col = range.col_start + part.col_end - 1,
						conceal = ""
					});

					visible_width = visible_width - (#after - 1);
				end
			end

			local top, top_hl = get_border("top", 2);

			table.insert(tmp, {
				string.rep(top, column_width),
				is_wrapped and "@punctuation.special.markdown" or utils.set_hl(top_hl)
			});

			if visible_width < column_width then
				if item.alignments[c] == "default" or item.alignments[c] == "left" then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + part.col_end, {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", math.max(0, column_width - visible_width)) }
						},

						hl_mode = "combine"
					});
				elseif item.alignments[c] == "right" then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + part.col_start, {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", math.max(0, column_width - visible_width)) }
						},

						hl_mode = "combine"
					});
				else
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + part.col_start, {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", math.ceil((column_width - visible_width) / 2)) }
						},

						hl_mode = "combine"
					});
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + part.col_end, {
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
		end
	end

	c = 1;

	for s, sep in ipairs(item.separator) do
		local x = range.row_start + 1;
		local y = range.col_start + sep.col_start;

		if sep.class == "separator" then
			if is_wrapped == true then
				goto continue;
			end

			local border, border_hl = get_border("separator", 4);

			if s == 1 then
				border, border_hl = get_border("separator", 1);
			elseif s == #item.separator then
				border, border_hl = get_border("separator", 3);
			end

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, x, y, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + sep.col_end,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ border, border_hl }
				},

				hl_mode = "combine"
			})
		elseif sep.class == "missing_seperator" then
			local border, border_hl = get_border("separator", s == 1 and 1 or 3);

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, x, y, {
				undo_restore = false, invalidate = true,
				virt_text_pos = "inline",
				virt_text = {
					is_wrapped == true and { "|", "@punctuation.special.markdown" } or { border, border_hl }
				},

				right_gravity = s ~= 1,
				hl_mode = "combine"
			});
		elseif sep.class == "column" then
			local border, border_hl = get_border("separator", 2);
			local align, align_hl;

			local width = vim.fn.strdisplaywidth(sep.text);
			local left = col_widths[c] - width;

			if is_wrapped == true then
				if left > 0 then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, x, (range.col_start + sep.col_end) - 1, {
						undo_restore = false, invalidate = true,

						virt_text_pos = "inline",
						virt_text = {
							{
								string.rep("-", left),
								"@punctuation.special.markdown"
							}
						},

						hl_mode = "combine"
					});
				end
			elseif item.alignments[c] == "default" then
				if left > 0 then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, x, y, {
						undo_restore = false, invalidate = true,
						end_col = range.col_start + sep.col_end,

						virt_text_pos = "overlay",
						virt_text = {
							{
								string.rep(border, width),
								utils.set_hl(border_hl)
							},
						},

						hl_mode = "combine"
					});

					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, x, range.col_start + sep.col_end, {
						undo_restore = false, invalidate = true,

						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(border, left), utils.set_hl(border_hl) },
						},

						hl_mode = "combine"
					});
				else
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, x, y, {
						undo_restore = false, invalidate = true,
						end_col = range.col_start + sep.col_end,

						virt_text_pos = "overlay",
						virt_text = {
							{
								string.rep(border, width),
								utils.set_hl(border_hl)
							}
						},

						hl_mode = "combine"
					});
				end
			elseif item.alignments[c] == "left" then
				align = parts.align_left or "";
				align_hl = hls.align_left;

				if left > 0 then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, x, y, {
						undo_restore = false, invalidate = true,
						end_col = range.col_start + sep.col_end,

						virt_text_pos = "overlay",
						virt_text = {
							{ align, utils.set_hl(align_hl) },
							{
								string.rep(border, width - 1),
								utils.set_hl(border_hl)
							},
						},

						hl_mode = "combine"
					});

					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, x, range.col_start + sep.col_end, {
						undo_restore = false, invalidate = true,

						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(border, left), utils.set_hl(border_hl) },
						},

						hl_mode = "combine"
					});
				else
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, x, y, {
						undo_restore = false, invalidate = true,
						end_col = range.col_start + sep.col_end,

						virt_text_pos = "overlay",
						virt_text = {
							{ align, utils.set_hl(align_hl) },
							{
								string.rep(border, width - 1),
								utils.set_hl(border_hl)
							}
						},

						hl_mode = "combine"
					});
				end
			elseif item.alignments[c] == "right" then
				align = parts.align_right or "";
				align_hl = hls.align_right;

				if left > 0 then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, x, y, {
						undo_restore = false, invalidate = true,
						end_col = range.col_start + sep.col_end,

						virt_text_pos = "overlay",
						virt_text = {
							{
								string.rep(border, width),
								utils.set_hl(border_hl)
							},
						},

						hl_mode = "combine"
					});

					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, x, range.col_start + sep.col_end, {
						undo_restore = false, invalidate = true,

						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(border, left - 1), utils.set_hl(border_hl) },
							{ align, utils.set_hl(align_hl) }
						},

						hl_mode = "combine"
					});
				else
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, x, y, {
						undo_restore = false, invalidate = true,
						end_col = range.col_start + sep.col_end,

						virt_text_pos = "overlay",
						virt_text = {
							{
								string.rep(border, math.max(0, width - 1)),
								utils.set_hl(border_hl)
							},
							{ align, utils.set_hl(align_hl) }
						},

						hl_mode = "combine"
					});
				end
			elseif item.alignments[c] == "center" then
				align = parts.align_center or { "", "" };
				align_hl = hls.align_center or {};

				if left > 0 then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, x, y, {
						undo_restore = false, invalidate = true,
						end_col = range.col_start + sep.col_end,

						virt_text_pos = "overlay",
						virt_text = {
							{ align[1], utils.set_hl(align_hl[1]) },
							{
								string.rep(border, math.max(0, width - 1)),
								utils.set_hl(border_hl)
							},
						},

						hl_mode = "combine"
					});

					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, x, range.col_start + sep.col_end, {
						undo_restore = false, invalidate = true,

						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(border, math.max(0, left - 1)), utils.set_hl(border_hl) },
							{ align[2], utils.set_hl(align_hl[2]) }
						},

						hl_mode = "combine"
					});
				else
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, x, y, {
						undo_restore = false, invalidate = true,
						end_col = range.col_start + sep.col_end,

						virt_text_pos = "overlay",
						virt_text = {
							{ align[1], utils.set_hl(align_hl[1]) },
							{
								string.rep(border, math.max(0, width - 2)),
								utils.set_hl(border_hl)
							},
							{ align[2], utils.set_hl(align_hl[2]) },
						},

						hl_mode = "combine"
					});
				end
			end

			c = c + 1;
		end

		::continue::
	end

	for r, row in ipairs(item.rows) do
		if r == #item.rows then
			break;
		end

		c = 1;

		for _, part in ipairs(row) do
			if part.class == "separator" then
				local border, border_hl = get_border("row", 2);

				if r == 1 then
					border, border_hl = get_border("row", 1);
				elseif r == #item.separator then
					border, border_hl = get_border("row", 3);
				end

				if is_wrapped == false then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + 1 + r, range.col_start + part.col_start, {
						undo_restore = false, invalidate = true,
						end_col = range.col_start + part.col_end,
						conceal = "",

						virt_text_pos = "inline",
						virt_text = {
							{ border, border_hl }
						},

						hl_mode = "combine"
					})
				end
			elseif part.class == "missing_seperator" then
				local border, border_hl = get_border("row", r == 1 and 1 or 3);

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + 1 + r, range.col_start + part.col_start, {
					undo_restore = false, invalidate = true,
					virt_text_pos = "inline",
					virt_text = {
						is_wrapped and {
							"|",
							"@punctuation.special.markdown"
						} or {
							border,
							utils.set_hl(border_hl)
						}
					},

					right_gravity = r ~= 1,
					hl_mode = "combine"
				})
			elseif part.class == "column" then
				local visible_width = visible_texts.rows[r][c];
				local column_width  = col_widths[c];

				if strict then
					local before = string.match(part.text, "^%s*");
					local after = string.match(part.text, "%s*$");

					if #before > 1 then
						vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + (r + 1), range.col_start + part.col_start + 1, {
							undo_restore = false, invalidate = true,
							end_col = range.col_start + part.col_start + #before,
							conceal = ""
						});

						visible_width = visible_width - (#before - 1);
					end

					if #after > 1 then
						vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + (r + 1), range.col_start + part.col_end - #after, {
							undo_restore = false, invalidate = true,
							end_col = range.col_start + part.col_end - 1,
							conceal = ""
						});

						visible_width = visible_width - (#after - 1);
					end
				end

				if visible_width < column_width then
					if item.alignments[c] == "default" or item.alignments[c] == "left" then
						vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + (r + 1), range.col_start + part.col_end, {
							undo_restore = false, invalidate = true,
							virt_text_pos = "inline",
							virt_text = {
								{ string.rep(" ", math.max(0, column_width - visible_width)) }
							},

							right_gravity = false,
							hl_mode = "combine"
						});
					elseif item.alignments[c] == "right" then
						vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + (r + 1), range.col_start + part.col_start, {
							undo_restore = false, invalidate = true,
							virt_text_pos = "inline",
							virt_text = {
								{ string.rep(" ", math.max(0, column_width - visible_width)) }
							},

							right_gravity = false,
							hl_mode = "combine"
						});
					else
						vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + (r + 1), range.col_start + part.col_start, {
							undo_restore = false, invalidate = true,
							virt_text_pos = "inline",
							virt_text = {
								{ string.rep(" ", math.max(0, math.ceil((column_width - visible_width) / 2))) }
							},

							right_gravity = true,
							hl_mode = "combine"
						});
						vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + (r + 1), range.col_start + part.col_end, {
							undo_restore = false, invalidate = true,
							virt_text_pos = "inline",
							virt_text = {
								{ string.rep(" ", math.max(0, math.floor((column_width - visible_width) / 2))) }
							},

							right_gravity = false,
							hl_mode = "combine"
						});
					end
				end

				c = c + 1;
			end
		end
	end

	c = 1;
	tmp = {};

	for p, part in ipairs(item.rows[#item.rows] or {}) do
		if part.class == "separator" then
			local border, border_hl = get_border("row", 2);
			local bottom, bottom_hl = bottom_part(4);

			if p == 1 then
				border, border_hl = get_border("row", 1);
				bottom, bottom_hl = bottom_part(1);
			elseif p == #item.header then
				border, border_hl = get_border("row", 3);
				bottom, bottom_hl = bottom_part(3);
			end

			table.insert(tmp, {
				bottom,
				is_wrapped and "@punctuation.special.markdown" or utils.set_hl(bottom_hl)
			});

			if is_wrapped == false then
				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end - 1, range.col_start + part.col_start, {
					undo_restore = false, invalidate = true,
					end_col = range.col_start + part.col_end,
					conceal = "",

					virt_text_pos = "inline",
					virt_text = {
						{ border, border_hl }
					},

					hl_mode = "combine"
				});
			end

			if p == #item.header and config.block_decorator == true then
				local next_line = range.row_end == vim.api.nvim_buf_line_count(buffer) and 0 or #vim.api.nvim_buf_get_lines(buffer, range.row_end, range.row_end + 1, false)[1];

				if config.use_virt_lines == true then
					table.insert(tmp, 1, { string.rep(" ", range.col_start) });
				elseif next_line < vim.api.nvim_buf_line_count(buffer) and  next_line < range.col_start then
					table.insert(tmp, 1, { string.rep(" ", math.max(0, range.col_start - next_line)) });
				end

				if config.use_virt_lines == true then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end, math.min(next_line, range.col_start), {
						virt_lines_above = true,
						virt_lines = { tmp },

						hl_mode = "combine"
					})
				elseif range.row_end <= vim.api.nvim_buf_line_count(buffer) and item.bottom_border == true then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end, math.min(next_line, range.col_start), {
						virt_text_pos = "inline",
						virt_text = tmp,

						hl_mode = "combine"
					})
				end
			end
		elseif part.class == "missing_seperator" then
			local border, border_hl = get_border("row", p == 1 and 1 or 3);
			local bottom, bottom_hl = bottom_part(p == 1 and 1 or 3);

			table.insert(tmp, {
				bottom,
				is_wrapped == true and "@punctuation.special.markdown" or utils.set_hl(bottom_hl)
			});

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end - 1, range.col_start + part.col_start, {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + part.col_end,
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					is_wrapped and {
						"|",
						"@punctuation.special.markdown"
					} or {
						border,
						utils.set_hl(border_hl)
					}
				},

				right_gravity = p ~= 1,
				hl_mode = "combine"
			})

			if p == #item.header and config.block_decorator == true then
				local next_line = range.row_end == vim.api.nvim_buf_line_count(buffer) and 0 or #vim.api.nvim_buf_get_lines(buffer, range.row_end, range.row_end + 1, false)[1];

				if config.use_virt_lines == true then
					table.insert(tmp, 1, { string.rep(" ", range.col_start) });
				elseif next_line < vim.api.nvim_buf_line_count(buffer) and next_line < range.col_start then
					table.insert(tmp, 1, { string.rep(" ", math.max(0, range.col_start - next_line)) });
				end

				if config.use_virt_lines == true then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end, math.min(next_line, range.col_start), {
						virt_lines_above = true,
						virt_lines = { tmp },

						hl_mode = "combine"
					})
				elseif range.row_end <= vim.api.nvim_buf_line_count(buffer) and item.bottom_border == true then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end, math.min(next_line, range.col_start), {
						virt_text_pos = "inline",
						virt_text = tmp,

						hl_mode = "combine"
					})
				end
			end
		elseif part.class == "column" then
			local visible_width = visible_texts.rows[#visible_texts.rows][c];
			local column_width  = col_widths[c];

			if strict then
				local before = string.match(part.text, "^%s*");
				local after = string.match(part.text, "%s*$");

				if #before > 1 then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end - 1, range.col_start + part.col_start + 1, {
						undo_restore = false, invalidate = true,
						end_col = range.col_start + part.col_start + #before,
						conceal = ""
					});

					visible_width = visible_width - (#before - 1);
				end

				if #after > 1 then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end - 1, range.col_start + part.col_end - #after, {
						undo_restore = false, invalidate = true,
						end_col = range.col_start + part.col_end - 1,
						conceal = ""
					});

					visible_width = visible_width - (#after - 1);
				end
			end

			local bottom, bottom_hl = bottom_part(2);

			table.insert(tmp, {
				string.rep(bottom, column_width),
				is_wrapped and "@punctuation.special.markdown" or utils.set_hl(bottom_hl)
			});

			if visible_width < column_width then
				if item.alignments[c] == "default" or item.alignments[c] == "left" then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end - 1, range.col_start + part.col_end, {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", math.max(0, column_width - visible_width)) }
						},

						right_gravity = false,
						hl_mode = "combine"
					});
				elseif item.alignments[c] == "right" then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end - 1, range.col_start + part.col_start, {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", math.max(0, column_width - visible_width)) }
						},

						right_gravity = false,
						hl_mode = "combine"
					});
				else
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end - 1, range.col_start + part.col_start, {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", math.max(0, math.ceil((column_width - visible_width) / 2))) }
						},

						right_gravity = true,
						hl_mode = "combine"
					});
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end - 1, range.col_start + part.col_end, {
						undo_restore = false, invalidate = true,
						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", math.max(0, math.floor((column_width - visible_width) / 2))) }
						},

						right_gravity = false,
						hl_mode = "combine"
					});
				end
			end

			c = c + 1;
		end
	end
end


 -----------------------------------------------------------------------------------------


--- Renders wrapped block quotes, callouts & alerts.
---@param buffer integer
---@param item markview.parsed.markdown.block_quotes
markdown.__block_quote = function (buffer, item)
	---@type markview.config.markdown.block_quotes?
	local main_config = spec.get({ "markdown", "block_quotes" }, { fallback = nil });

	if not main_config then
		return;
	end

	---@type string[]
	local keys = vim.tbl_keys(main_config);
	local range = item.range;

	if main_config == nil or not main_config.default then
		return;
	elseif
		item.callout and
		not vim.list_contains(keys, string.lower(item.callout)) and
		not vim.list_contains(keys, string.upper(item.callout)) and
		not vim.list_contains(keys, item.callout)
	then
		return;
	end

	---@type markview.config.markdown.block_quotes.opts
	local config = spec.get({ "default" }, { source = main_config, eval_args = { buffer, item } });

	if item.callout then
		config = vim.tbl_extend("force", config, spec.get(
			{ string.lower(item.callout) },
			{ source = main_config, eval_args = { buffer, item } }
		) or spec.get(
			{ string.upper(item.callout) },
			{ source = main_config, eval_args = { buffer, item } }
		) or spec.get(
			{ item.callout },
			{ source = main_config, eval_args = { buffer, item } }
		));
	end

	for l = range.row_start, range.row_end - 1, 1  do
		local l_index = (l - range.row_start) + 1;

		require("markview.wrap").wrap_indent(buffer, { row = l }, {
			{ string.rep(" ", item.__nested and 0 or range.col_start) },
			{
				tbl_clamp(config.border, l_index),
				utils.set_hl(tbl_clamp(config.border_hl, l_index) or config.hl)
			},
			{ " " }
		});
	end
end

--- Renders wrapped block quotes, callouts & alerts.
---@param buffer integer
---@param item markview.parsed.markdown.list_items
markdown.__list_item = function (buffer, item)
	---@type markview.config.markdown.list_items?
	local main_config = spec.get({ "markdown", "list_items" }, {
		fallback = nil,
		eval_args = { buffer, item }
	});
	local range = item.range;

	if not main_config then
		return;
	end

	---@type markview.config.markdown.list_items.ordered | markview.config.markdown.list_items.unordered
	local config;

	local shift_width = type(main_config.shift_width) == "number" and main_config.shift_width or 1;
	local indent_size = type(main_config.indent_size) == "number" and main_config.indent_size or 1;

	---@cast indent_size integer
	---@cast shift_width integer

	if item.marker == "-" then
		config = spec.get({ "marker_minus" }, {
			source = main_config,
			eval_args = { buffer, item }
		});
	elseif item.marker == "+" then
		config = spec.get({ "marker_plus" }, {
			source = main_config,
			eval_args = { buffer, item }
		});
	elseif item.marker == "*" then
		config = spec.get({ "marker_star" }, {
			source = main_config,
			eval_args = { buffer, item }
		});
	elseif item.marker:match("%d+%.") then
		config = spec.get({ "marker_dot" }, {
			source = main_config,
			eval_args = { buffer, item }
		});
	elseif item.marker:match("%d+%)") then
		config = spec.get({ "marker_parenthesis" }, {
			source = main_config,
			eval_args = { buffer, item }
		});
	end

	if config == nil then
		return;
	end

	--- Evaluation arguments for checkboxes.
	--- Used for turning function values into static values.
	local chk_args = {
		buffer,
		{
			class = "inline_checkbox",

			text = item.checkbox,
			range = nil
		}
	};

	--- Gets checkbox state
	---@param state string?
	---@return markview.config.markdown_inline.checkboxes.opts?
	local function get_state (state)
		local checkboxes = spec.get({ "markdown_inline", "checkboxes" }, { fallback = nil });

		if state == nil or checkboxes == nil then
			return;
		end

		if state == "x" or state == "X" then
			return spec.get({ "checked" }, { source = checkboxes, eval_args = chk_args });
		elseif state == " " then
			return spec.get({ "unchecked" }, { source = checkboxes, eval_args = chk_args });
		end

		return utils.match(checkboxes, state, { eval_args = chk_args });
	end

	local checkbox = get_state(item.checkbox);
	local pad_width = (math.floor(item.indent / indent_size) + 1) * shift_width;

	if config.conceal_on_checkboxes == true and checkbox and checkbox.text then
		pad_width = pad_width + vim.fn.strdisplaywidth(checkbox.text) + 1;
	else
		pad_width = pad_width + vim.fn.strdisplaywidth(item.marker) + 1;
	end

	---@type integer Number of spaces to add to `odd-spaced` list items.
	local extra = 0;

	if config.conceal_on_checkboxes == true and checkbox and checkbox.text then
		extra = indent_size + 1 - vim.fn.strdisplaywidth(checkbox.text);
	else
		extra = indent_size + 1 - vim.fn.strdisplaywidth(item.marker);
	end

	for _, l in ipairs(item.candidates) do
		require("markview.wrap").wrap_indent(buffer, {
			row = range.row_start + l
		}, {
			{ string.rep(" ", (item.__nested or item.indent % indent_size == 0) and 0 or extra) },
			{ string.rep(" ", range.col_start + pad_width) }
		});
	end
end

--- Renders wrapped block quotes, callouts & alerts.
---@param buffer integer
---@param item markview.parsed.markdown.sections
markdown.__section = function (buffer, item)
	---@type markview.config.markdown.headings?
	local main_config = spec.get({ "markdown", "headings" }, { fallback = nil, eval_args = { buffer, item } });
	local range = item.range;

	if main_config == nil then
		return;
	elseif main_config.org_indent ~= true then
		--- Org indent mode disabled.
		return;
	end

	local shift_width = main_config.org_shift_width or main_config.shift_width or 0;
	local shift_char = tostring(item.level) or main_config.org_shift_char or " ";

	for l = range.row_start, (range.org_end or range.row_end) - 1, 1 do
		require("markview.wrap").wrap_indent(buffer, {
			row = l
		}, {
			{
				string.rep(" " or shift_char,
					math.max(
						0,
						shift_width * (item.level - 1)
					)
				)
			}
		});
	end
end

 -----------------------------------------------------------------------------------------


--- Renders markdown preview.
---@param buffer integer
---@param content markview.parsed.markdown[]
---@return markview.parsed
markdown.render = function (buffer, content)
	markdown.cache = {};

	local custom = spec.get({ "renderers" }, { fallback = {} });

	for _, item in ipairs(content or {}) do
		local success, err;

		if custom[item.class] then
			success, err = pcall(custom[item.class], buffer, item);
		else
			success, err = pcall(markdown[item.class:gsub("^markdown_", "")], buffer, item);
		end

		if success == false then
			require("markview.health").print({
				kind = "ERR",

				from = "renderers/markdown.lua",
				fn = "render() -> " .. item.class,

				message = {
					{ tostring(err), "DiagnosticError" }
				}
			});
		end
	end

	return { markdown = markdown.cache };
end

--- Post-process effect renderer.
---@param buffer integer
---@param content markview.parsed.markdown[]
markdown.post_render = function (buffer, content)
	local custom = spec.get({ "renderers" }, { fallback = {} });
	vim.g.markview_sign_width = require("markview.wrap").sign_width(buffer, markdown.ns);

	for _, item in ipairs(content or {}) do
		local success, err;

		if custom[item.class] then
			success, err = pcall(custom["__" .. item.class], markdown.ns, buffer, item);
		else
			success, err = pcall(markdown["__" .. item.class:gsub("^markdown_", "")], buffer, item);
		end

		if success == false then
			require("markview.health").print({
				kind = "ERR",

				from = "renderers/markdown.lua",
				fn = "post_render() -> " .. item.class,

				message = {
					{ tostring(err), "DiagnosticError" }
				}
			});
		end
	end

	require("markview.wrap").render(buffer, markdown.ns);
end


------------------------------------------------------------------------------------------

--- Clears markdown previews.
---@param buffer integer
---@param from integer?
---@param to integer?
---@param hybrid_mode boolean
markdown.clear = function (buffer, from, to, hybrid_mode)
	---@type boolean
	local experimental = spec.get({ "experimental", "linewise_ignore_org_indent" }, { fallback = false });

	if not experimental or not hybrid_mode then
		vim.api.nvim_buf_clear_namespace(buffer, markdown.ns, from or 0, to or -1);
		return;
	end

	--- Extmarks in this range.
	local exts = vim.api.nvim_buf_get_extmarks(buffer, markdown.ns, { from or 0, 0 }, { to and (to - 1) or -1, -1 }, { type = "virt_text" });

	for _, ext in ipairs(exts) do
		local _ext = vim.api.nvim_buf_get_extmark_by_id(buffer, markdown.ns, ext[1], { details = true });

		local col = _ext[2];
		local detail = _ext[3];

		if detail then
			local pos = detail.virt_text_pos;
			local virt_text = detail.virt_text;

			local conceal = detail.conceal;

			if
				col == 0 and virt_text and ( not conceal and pos == "inline" ) and -- Check if it's a space/border type extmark.
				#virt_text == 1 and string.match(virt_text[1][1], "^%s+$") -- Check if it's an org indent border.
			then
				goto ignore;
			end
		end

		vim.api.nvim_buf_del_extmark(buffer, markdown.ns, ext[1]);

		::ignore::
	end
end

return markdown;
