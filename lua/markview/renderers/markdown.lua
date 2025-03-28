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

--- Holds nodes for post-process effects.
---@type table[]
markdown.cache = {};

local concat = function (list)
	for i, item in ipairs(list) do
		list[i] = utils.escape_string(item);
	end

	return table.concat(list);
end

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
	---+${func}
	local decorations = 0;

	--- Checks if syntax exists in {str}.
	---@return boolean
	local function has_syntax ()
		---+${lua, Conditions}
		if str:match("`(.-)`") then
			return true;
		elseif str:match("\\([%\\%*%_%{%}%[%]%(%)%#%+%-%.%!%%<%>$])") then
			return true;
		elseif str:match("([%*]+)(.-)([%*]+)") then
			return true;
		elseif str:match("%~%~(.-)%~%~") then
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
		---_

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
		---+${custom, Handle inline codes}
		if not codes or codes.enable == false then
			str = str:gsub(
				concat({
					"`",
					utils.escape_string(inline_code),
					"`"
				}),
				concat({ content })
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
		---_
	end

	for escaped in str:gmatch("\\([%\\%*%_%{%}%[%]%(%)%#%+%-%.%!%%<%>$])") do
		if not esc then
			break;
		end

		str = str:gsub(concat({ "\\", escaped }), " ", 1);
	end

	for latex in str:gmatch("%$([^%$]*)%$") do
		---+${custom, Handle LaTeX blocks}
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
		---_
	end

	for str_b, content, str_a in str:gmatch("([%*]+)(.-)([%*]+)") do
		---+${custom, Handle italics & bold text}
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
		---_
	end

	for striked in str:gmatch("%~%~(.-)%~%~") do
		---+${custom, Handle strike-through text}
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
		---_
	end

	for entity in str:gmatch("%&([%d%a%#]+);") do
		---+${custom, Handle entities}
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
		---_
	end

	for emoji in str:gmatch(":([%a%d%_%+%-]+):") do
		---+${lua, Handles emoji shorthands}
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
		---_
	end

	for highlight in str:gmatch("%=%=(.-)%=%=") do
		---+${custom, Handle highlighted text}
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
		---_
	end

	for ref in str:gmatch("%!%[%[([^%]]+)%]%]") do
		---+${custom, Handle embed files & block references}
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
		---_
	end

	for ref in str:gmatch("%[%[%#%^([^%]]+)%]%]") do
		---+${custom, Handle block references}
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
		---_
	end

	for link in str:gmatch("%[%[([^%]]+)%]%]") do
		---+${custom, Handle internal links}
		if not int then
			str = str:gsub(
				concat({
					"[[",
					link,
					"]]"
				}),
				concat({
					" ",
					string.rep("X", vim.fn.strdisplaywidth(alias or link)),
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
		---_
	end

	for link, p_s, address, p_e in str:gmatch("%!%[([^%]]*)%]([%(%[])([^%)]*)([%)%]])") do
		---+${custom, Handle image links}
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
		---_
	end

	for link in str:gmatch("%!%[([^%]]*)%]") do
		---+${custom, Handle image links without address}
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
				address,
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
		---_
	end

	for link, p_s, address, p_e in str:gmatch("%[([^%]]*)%]([%(%[])([^%)]*)([%)%]])") do
		---+${custom, Handle hyperlinks}
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
		---_
	end

	for link in str:gmatch("%[([^%]]+)%]") do
		---+${custom, Handle shortcut links}
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
		---_
	end

	for address, domain in str:gmatch("%<([^%s%@]-)@(%S+)%>") do
		---+${custom, Handle emails}
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
		---_
	end

	for address in str:gmatch("%<(%S+)%>") do
		---+${custom, Handle uri autolinks}
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
		---_
	end

	return str, decorations;
	---_
end

--- Applies text transformation based on the **filetype**.
---
--- Uses for getting the output text of filetypes that contain
--- special syntaxes(e.g. JSON, Markdown).
markdown.get_visual_text = {
	---+${class}
	["Markdown"] = function (str)
		---+${lua}

		str = str:gsub("\\%`", " ");

		for inline_code in str:gmatch("`(.-)`") do
			---+${custom, Handle inline codes}
			str = str:gsub(concat({
				"`",
				inline_code,
				"`"
			}), inline_code);
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

			str = str:gsub(str_b .. content .. str_a, string.rep("X", vim.fn.strdisplaywidth(content)))

			::continue::
			---_
		end

		for striked in str:gmatch("%~%~(.-)%~%~") do
			---+${custom, Handle strike-through text}
			str = str:gsub(concat({
				"~~",
				striked,
				"~~"
			}), concat({
				string.rep("X", vim.fn.strdisplaywidth(striked))
			}));
			---_
		end

		for escaped in str:gmatch("\\([%\\%*%_%{%}%[%]%(%)%#%+%-%.%!%%<%>$])") do
			str = str:gsub(concat({
				"\\",
				escaped
			}), " ");
		end

		for link, m1, address, m2 in str:gmatch("%!%[([^%)]*)%]([%(%[])([^%)]*)([%)%]])") do
			---+${custom, Handle image links}
			str = str:gsub(concat({
				"![",
				link,
				"]",
				m1,
				address,
				m2
			}), link);
			---_
		end

		for link in str:gmatch("%!%[([^%)]*)%]") do
			---+${custom, Handle image links without address}
			str = str:gsub(concat({
				"![",
				link,
				"]",
			}), concat({
				string.rep("X", vim.fn.strdisplaywidth(link))
			}))
			---_
		end

		for link, m1, address, m2 in str:gmatch("%[([^%)]*)%]([%(%[])([^%)]*)([%)%]])") do
			---+${custom, Handle hyperlinks}
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
			---_
		end

		for link in str:gmatch("%[([^%)]+)%]") do
			---+${custom, Handle shortcut links}
			str = str:gsub(concat({
				"[",
				link,
				"]",
			}), concat({
				string.rep("X", vim.fn.strdisplaywidth(link)),
			}))
			---_
		end

		return str;
		---_
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
	---_
};

---@type integer Namespace for markdown.
markdown.ns = vim.api.nvim_create_namespace("markview/markdown");

--- Renders atx headings.
---@param buffer integer
---@param item __markdown.atx
markdown.atx_heading = function (buffer, item)
	---+${func, Renders ATX headings}

	---@type markdown.headings?
	local main_config = spec.get({ "markdown", "headings" }, { fallback = nil, eval_args = { buffer, item } });

	if not main_config then
		return;
	elseif not spec.get({ "heading_" .. #item.marker }, { source = main_config, eval_args = { buffer, item } }) then
		return;
	end

	---@type headings.atx
	local config = spec.get({ "heading_" .. #item.marker }, { source = main_config, eval_args = { buffer, item } });
	local shift_width = spec.get({ "shift_width" }, { source = main_config, fallback = 1, eval_args = { buffer, item } });

	local range = item.range;

	if config.style == "simple" then
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			line_hl_group = utils.set_hl(config.hl)
		});
	elseif config.style == "label" then
		local space = "";

		if config.align then
			local win = vim.fn.win_findbuf(buffer)[1];
			local res = markdown.output(item.text[1], buffer):gsub("^#+%s", "");

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
				space = string.rep(" ", math.max(0, math.floor((w_wid - wid) / 2)));
			elseif config.align == "right" then
				space = string.rep(" ", w_wid - wid);
			end
		else
			space = string.rep(" ", #item.marker * shift_width);
		end

		--- DO NOT USE `hl_mode = "combine"`
		--- It causes color bleeding.
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + #item.marker + (#item.text[1] > #item.marker and 1 or 0),
			conceal = "",
			sign_text = config.sign,
			sign_hl_group = utils.set_hl(config.sign_hl),
			virt_text_pos = "inline",
			virt_text = {
				{ space },
				{ config.corner_left or "", utils.set_hl(config.corner_left_hl or config.hl) },
				{ config.padding_left or "", utils.set_hl(config.padding_left_hl or config.hl) },

				{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) },
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
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + #item.marker + (#item.text[1] > #item.marker and 1 or 0),
			conceal = "",
			sign_text = config.sign,
			sign_hl_group = utils.set_hl(config.sign_hl),
			virt_text_pos = "inline",
			virt_text = {
				{ string.rep(" ", #item.marker * shift_width) },
				{ config.icon or "", utils.set_hl(config.icon_hl or config.hl) },
			},
			line_hl_group = utils.set_hl(config.hl),

			hl_mode = "combine"
		});
	end
	---_
end

--- Renders block quotes, callouts & alerts.
---@param buffer integer
---@param item __markdown.block_quotes
markdown.block_quote = function (buffer, item)
	---+${func, Renders Block quotes & Callouts/Alerts}

	---@type markdown.block_quotes?
	local main_config = spec.get({ "markdown", "block_quotes" }, { fallback = nil, eval_args = { buffer, item } });
	local range = item.range;

	if
		not main_config or
		not main_config.default
	then
		return;
	end

	---@type block_quotes.opts
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
					{ config.icon, utils.set_hl(config.icon_hl or config.hl) }
				},

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
			right_gravity = false,
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
		local l_index = l - (range.row_start) + 1;

		local line = item.text[l_index];
		local line_len = #line;

		if line:match("^%>") then
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, l, range.col_start, {
				undo_restore = false, invalidate = true,
				right_gravity = false,

				end_col = range.col_start + math.min(1, line_len),
				conceal = "",

				virt_text_pos = "inline",
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
				right_gravity = false,

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

	if main_config.wrap == true and vim.wo[win].wrap == true then
		--- When `wrap` is enabled, run post-processing effects.
		table.insert(markdown.cache, item);
	end
	---_
end

--- Renders [ ], [x] & [X].
---@param buffer integer
---@param item __inline.checkboxes
markdown.checkbox = function (buffer, item)
	--- Wrapper for the inline checkbox renderer function.
	--- Used for [ ] & [X] checkboxes.
	inline.checkbox(buffer, item)
end

--- Renders fenced code blocks.
---@param buffer integer
---@param item __markdown.code_blocks
markdown.code_block = function (buffer, item)
	---+${func, Renders Code blocks}

	---@type markdown.code_blocks_static?
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
		---+${lua}
		if item.info_string == nil then
			return range.col_start + #delims[1];
		elseif item.info_string:match("^%{[^%}]+%}%s?") then
			--- Info string: {lang}
			local _to = item.info_string:match("^%{[^%}]+%}%s?"):len();
			return info_range[2] + _to;
		else
			--- Info string: ```lang`
			local _to = item.info_string:match("^%S+%s?"):len();
			return info_range[2] + _to;
		end
		---_
	end

	--- Gets highlight configuration for a line.
	---@param line string
	---@return code_blocks.opts_static
	local function get_line_config(line)
		---+${lua}

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
		---_
	end

	--- Renders simple style code blocks.
	local function render_simple()
		---+${lua}

		local conceal_to = lang_conceal_to();

		if config.label_direction == nil or config.label_direction == "left" then
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start, {
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
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start, {
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
				end_col = #item.text[1],

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

				line_hl_group = utils.set_hl(line_config.block_hl)
			});
		end

		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end - 1, (range.col_start + #item.text[#item.text]) - #delims[2], {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + #item.text[#item.text],
			conceal = "",

			line_hl_group = utils.set_hl(config.border_hl)
		});
		---_
	end

	--- Renders block style code blocks.
	local function render_block ()
		---+${lua}

		local pad_amount = config.pad_amount or 0;
		local block_width = config.min_width or 60;

		local line_widths = {};

		--- Get maximum length of the lines within the code block
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
		local conceal_to = lang_conceal_to();

		--- Render top
		if config.label_direction == nil or config.label_direction == "left" then
			---+${Left aligned label}
			local avail_top  = block_width - (label_width + 2);

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start, {
				undo_restore = false, invalidate = true,

				end_col = conceal_to,
				conceal = "",

				sign_text = config.sign == true and decorations.sign or nil,
				sign_hl_group = utils.set_hl(config.sign_hl or decorations.sign_hl),

				virt_text_pos = "inline",
				virt_text = { label }
			});

			if not item.info_string then
				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + #delims[1], {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(config.pad_char or " ", math.max(0, block_width - label_width)),
							utils.set_hl(config.border_hl)
						}
					}
				});
				goto no_info;
			end

			local relative_y = conceal_to - info_range[2];
			local info_width = #item.info_string - relative_y;

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, info_range[1], info_range[2], {
				undo_restore = false, invalidate = true,

				end_row = info_range[3],
				end_col = range.col_start + #item.text[1],

				hl_group = utils.set_hl(config.info_hl or config.border_hl)
			});

			if info_width >= avail_top then
				--- Exceeds.
				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, conceal_to + avail_top, {
					undo_restore = false, invalidate = true,

					end_col = info_range[4],
					conceal = "",

					virt_text_pos = "inline",
					virt_text = {
						{ "…", utils.set_hl(config.info_hl or config.border_hl) },
						{ " ", utils.set_hl(config.border_hl) }
					}
				});
			else
				local spaces = math.max(0, avail_top - info_width + 2);

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + #item.text[1], {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(config.pad_char or " ", spaces),
							utils.set_hl(config.border_hl)
						}
					}
				});
			end

			::no_info::
			---_
		else
			---+${Right aligned label}
			local avail_top  = math.max(block_width - (label_width + 3));

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start, {
				undo_restore = false, invalidate = true,

				end_col = conceal_to,
				conceal = "",

				sign_text = config.sign == true and decorations.sign or nil,
				sign_hl_group = utils.set_hl(config.sign_hl or decorations.sign_hl),

				virt_text_pos = "inline",
				virt_text = {
					{
						" ",
						utils.set_hl(config.border_hl)
					}
				}
			});

			if not item.info_string then
				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + #delims[1], {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(config.pad_char or " ", avail_top + 2),
							utils.set_hl(config.border_hl)
						},
						label
					}
				});
				goto no_info;
			end

			local relative_y = conceal_to - info_range[2];
			local info_width = #item.info_string - relative_y;

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, info_range[1], info_range[2], {
				undo_restore = false, invalidate = true,

				end_row = info_range[3],
				end_col = range.col_start + #item.text[1],

				hl_group = utils.set_hl(config.info_hl or config.border_hl)
			});

			if info_width >= avail_top then
				--- Exceeds.
				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, conceal_to + avail_top, {
					undo_restore = false, invalidate = true,

					end_col = info_range[4],
					conceal = "",

					virt_text_pos = "inline",
					virt_text = {
						{ "…", utils.set_hl(config.info_hl or config.border_hl) },
						{ " ", utils.set_hl(config.border_hl) },
						label
					}
				});
			else
				local spaces = math.max(0, avail_top - info_width + 2);

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + #item.text[1], {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(config.pad_char or " ", spaces),
							utils.set_hl(config.border_hl)
						},
						label
					}
				});
			end

			::no_info::
			---_
		end

		--- Line padding
		for l, width in ipairs(line_widths) do
			---+${lua}

			local line = item.text[l + 1];
			local line_config = get_line_config(line);

			if width ~= 0 then
				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + l, line ~= "" and range.col_start or 0, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(" ", pad_amount),
							utils.set_hl(line_config.pad_hl)
						}
					},
				});

				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + l, range.col_start + #line, {
					undo_restore = false, invalidate = true,

					virt_text_pos = "inline",
					virt_text = {
						{
							string.rep(" ", math.max(0, block_width - (( 2 * pad_amount) + width))),
							utils.set_hl(line_config.block_hl)
						},
						{
							string.rep(" ", pad_amount),
							utils.set_hl(line_config.pad_hl)
						}
					},
				});

				--- Background
				vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + l, range.col_start, {
					undo_restore = false, invalidate = true,
					end_col = range.col_start + #line,

					hl_group = utils.set_hl(line_config.block_hl)
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
							utils.set_hl(line_config.pad_hl)
						},
						{
							string.rep(" ", math.max(0, block_width - (2 * pad_amount))),
							utils.set_hl(line_config.block_hl)
						},
						{
							string.rep(" ", pad_amount),
							utils.set_hl(line_config.pad_hl)
						},
					},
				});
			end
			---_
		end

		--- Render bottom
		if item.text[#item.text] ~= "" then
			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end - 1, (range.col_start + #item.text[#item.text]) - #delims[2], {
				undo_restore = false, invalidate = true,
				end_col = range.col_start + #item.text[#item.text],
				conceal = ""
			});

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_end - 1, range.col_start + #item.text[#item.text], {
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
		---_
	end

	if config.style == "simple" or ( vim.o.wrap == true or vim.wo[win].wrap == true ) then
		render_simple();
	elseif config.style == "block" then
		render_block()
	end
	---_
end

--- Renders horizontal rules/line breaks.
---@param buffer integer
---@param item __markdown.horizontal_rules
markdown.hr = function (buffer, item)
	---+${func, Horizontal rules}

	---@type markdown.horizontal_rules?
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
	---_
end

--- Renders reference link definitions.
---@param buffer integer
---@param item __markdown.reference_definitions
markdown.link_ref_definition = function (buffer, item)
	---+${func}

	---@type markdown.reference_definitions?
	local main_config = spec.get({ "markdown", "reference_definitions" }, { fallback = nil });
	local range = item.range;

	if not main_config then
		return;
	end

	---@type config.inline_generic_static?
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

	---+${class}
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
	--_
	---_
end

--- Renders list items
---@param buffer integer
---@param item __markdown.list_items
markdown.list_item = function (buffer, item)
	---+${func, Renders List items}

	---@type markdown.list_items_static?
	local main_config = spec.get({ "markdown", "list_items" }, {
		fallback = nil,
		eval_args = { buffer, item }
	});
	local range = item.range;

	if not main_config then
		return;
	end

	---@type list_items.ordered | list_items.unordered
	local config;
	local shift_width, indent_size = main_config.shift_width or 1, main_config.indent_size or 1;

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
			local from, to = range.col_start, range.col_start + item.indent;

			if item.text[l + 1]:len() < to then
				to = from;
			end

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
	---@return checkboxes.opts?
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

		local _state = utils.escape_string(state) or "";
		return utils.match(checkboxes, "^" .. _state .. "$", { default = false, ignore_keys = { "checked", "unchecked", "enable" }, eval_args = chk_args });
	end

	local checkbox = get_state(item.checkbox);

	if checkbox and config.conceal_on_checkboxes == true then
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start + item.indent, {
			undo_restore = false, invalidate = true,
			end_col = range.col_start + (item.indent + #item.marker + 1),
			conceal = ""
		});

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
	elseif item.marker:match("[%+%-%*]") then
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
	if main_config.wrap == true and vim.wo[win].wrap == true then
		--- When `wrap` is enabled, run post-processing effects.
		table.insert(markdown.cache, item);
	end
	---_
end

--- Renders metadatas.
---@param buffer integer
---@param item __markdown.metadata_minus
markdown.metadata_minus = function (buffer, item)
	---+${func, Renders YAML metadata blocks}

	---@type markdown.metadata_minus_static?
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

	if not config.hl then return; end

	vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + 1, 0, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end - 1,

		line_hl_group = utils.set_hl(config.hl)
	});
	---_
end

--- Renders + metadatas.
---@param buffer integer
---@param item __markdown.metadata_plus
markdown.metadata_plus = function (buffer, item)
	---+${func, Renders TOML metadata blocks}

	---@type markdown.metadata_plus_static?
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

	if not config.hl then return; end

	vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + 1, 0, {
		undo_restore = false, invalidate = true,
		end_row = range.row_end - 1,

		line_hl_group = utils.set_hl(config.hl)
	});
	---_
end

--- Render org mode like section indentations.
---@param buffer integer
---@param item __markdown.sections
markdown.section = function (buffer, item)
	---+${lua}

	---@type markdown.headings?
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

	for l = range.row_start + 1, range.row_end do
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, l, 0, {
			undo_restore = false, invalidate = true,

			virt_text_pos = "inline",
			virt_text = {
				{ string.rep(shift_char, math.max(0, shift_width * (item.level - 1))) }
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

	if main_config.org_indent_wrap == true and vim.wo[win].wrap == true then
		--- When `wrap` is enabled, run post-processing effects.
		table.insert(markdown.cache, item);
	end
	---_
end

--- Renders setext headings.
---@param buffer integer
---@param item __markdown.setext
markdown.setext_heading = function (buffer, item)
	---+${func, Renders Setext headings}

	---@type markdown.headings?
	local main_config = spec.get({ "markdown", "headings" }, { fallback = nil, eval_args = { buffer, item } });
	local lvl = item.marker:match("%=") and 1 or 2;

	if not main_config then
		return;
	elseif not spec.get({ "setext_" .. lvl }, { source = main_config }) then
		return;
	end

	---@type headings.setext
	local config = spec.get({ "setext_" .. lvl }, { source = main_config });
	local range = item.range;

	if config.style == "simple" then
		vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start, range.col_start, {
			undo_restore = false, invalidate = true,
			sign_text = config.sign,
			sign_hl_group = utils.set_hl(config.sign_hl),
			end_row = range.row_end,
			end_col = range.col_end,
			line_hl_group = utils.set_hl(config.hl)
		});
	elseif config.style == "decorated" then
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
	---_
end

--- Renders tables.
---@param buffer integer
---@param item __markdown.tables
markdown.table = function (buffer, item)
	---+${func, Renders Tables}

	---@type markdown.tables_static?
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

	---+${custom, Get the width of the column(s)}

	---@type integer Current column number.
	local c = 1;

	markdown.__new_config();

	---+${custom, Calculate heading column widths}
	for _, col in ipairs(item.header) do
		if col.class == "column" then
			local o, dec = markdown.output(col.text, buffer);

			o = vim.fn.strdisplaywidth(o);
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
	---_

	---+${custom, Calculate separator column widths}
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
	---_

	---+${custom, Calculate various row's column widths}
	for r, row in ipairs(item.rows) do
		c = 1;
		table.insert(visible_texts.rows, {})

		for _, col in ipairs(row) do
			if col.class == "column" then
				local o, dec = markdown.output(col.text, buffer);

				o = vim.fn.strdisplaywidth(o);
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
	---_
	---_

	if is_wrapped == true then
		---+${lua}

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

		---_
	end

	---@type tables.parts
	local parts = config.parts;
	---@type tables.parts
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
						{ border, utils.set_hl(border_hl) }
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
			---_
		elseif part.class == "missing_seperator" then
			---+${custom, Handle missing last |}
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
			---_
		elseif part.class == "column" then
			---+${custom, Handle columns of text inside the header}
			local visible_width = visible_texts.header[c];
			local column_width  = col_widths[c];

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
			---_
		end
	end

	c = 1;

	for s, sep in ipairs(item.separator) do
		local x = range.row_start + 1;
		local y = range.col_start + sep.col_start;

		if sep.class == "separator" then
			---+${custom, Handle | in the header}

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
					{ border, utils.set_hl(border_hl) }
				},

				hl_mode = "combine"
			})
			---_
		elseif sep.class == "missing_seperator" then
			---+${custom, Handle missing last |}
			local border, border_hl = get_border("separator", s == 1 and 1 or 3);

			vim.api.nvim_buf_set_extmark(buffer, markdown.ns, x, y, {
				undo_restore = false, invalidate = true,
				virt_text_pos = "inline",
				virt_text = {
					is_wrapped == true and { "|", "@punctuation.special.markdown" } or { border, utils.set_hl(border_hl) }
				},

				right_gravity = s ~= 1,
				hl_mode = "combine"
			});
			---_
		elseif sep.class == "column" then
			local border, border_hl = get_border("separator", 2);
			local align, align_hl;

			local width = vim.fn.strdisplaywidth(sep.text);
			local left = col_widths[c] - width;

			if is_wrapped == true then
				---+${lua, Wrapping enabled}
				if left > 0 then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, x, (range.col_start + sep.col_end) - 2, {
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
				---_
			elseif item.alignments[c] == "default" then
				---+${custom, Normal columns}
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
				---_
			elseif item.alignments[c] == "left" then
				---+${custom, Left aligned columns}
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
				---_
			elseif item.alignments[c] == "right" then
				---+${custom, Right aligned columns}
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
				---_
			elseif item.alignments[c] == "center" then
				---+${custom, Center aligned columns}
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
				---_
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
				---+${custom, Handle | in the header}
				local border, border_hl = get_border("row", 2);

				if s == 1 then
					border, border_hl = get_border("row", 1);
				elseif s == #item.separator then
					border, border_hl = get_border("row", 3);
				end

				if is_wrapped == false then
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + 1 + r, range.col_start + part.col_start, {
						undo_restore = false, invalidate = true,
						end_col = range.col_start + part.col_end,
						conceal = "",

						virt_text_pos = "inline",
						virt_text = {
							{ border, utils.set_hl(border_hl) }
						},

						hl_mode = "combine"
					})
				end
				---_
			elseif part.class == "missing_seperator" then
				---+${custom, Handle missing last |}
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
				---_
			elseif part.class == "column" then
				---+${custom, Handle columns of text inside the header}
				local visible_width = visible_texts.rows[r][c];
				local column_width  = col_widths[c];

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
						{ border, utils.set_hl(border_hl) }
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
			---_
		elseif part.class == "missing_seperator" then
			---+${custom, Handle missing last |}
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
			---_
		elseif part.class == "column" then
			---+${custom, Handle columns of text inside the last row}
			local visible_width = visible_texts.rows[#visible_texts.rows][c];
			local column_width  = col_widths[c];

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
			---_
		end
	end
	---_
end


 -----------------------------------------------------------------------------------------


--- Places where the list items were wrapped.
---@type { [integer]: integer[] }
markdown.__list_wraps = {};

local get_extmark = function (buffer, lnum, col)
	local extmarks = vim.api.nvim_buf_get_extmarks(buffer, markdown.ns, { lnum, col }, { lnum, col + 1 }, {
		details = true,
		type = "virt_text"
	});

	return extmarks[1];
end

local register_wrap = function (lnum, col)
	if vim.islist(markdown.__list_wraps[lnum]) == false then
		markdown.__list_wraps[lnum] = {};
	end

	table.insert(markdown.__list_wraps[lnum], col);
end

local has_wrap = function (lnum, col)
	if vim.islist(markdown.__list_wraps[lnum]) == false then
		return false;
	else
		return vim.list_contains(markdown.__list_wraps[lnum], col);
	end
end

--- Renders wrapped block quotes, callouts & alerts.
---@param buffer integer
---@param item __markdown.block_quotes
markdown.__block_quote = function (buffer, item)
	---+${func, Post renderer for wrapped block quotes}

	---@type markdown.block_quotes?
	local main_config = spec.get({ "markdown", "block_quotes" }, { fallback = nil });
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

	local config;

	if item.callout then
		---@type block_quotes.opts
		config = spec.get(
			{ string.lower(item.callout) },
			{ source = main_config, eval_args = { buffer, item } }
		) or spec.get(
			{ string.upper(item.callout) },
			{ source = main_config, eval_args = { buffer, item } }
		) or spec.get(
			{ item.callout },
			{ source = main_config, eval_args = { buffer, item } }
		);
	else
		---@type block_quotes.opts
		config = spec.get({ "default" }, { source = main_config, eval_args = { buffer, item } });
	end

	local win = utils.buf_getwin(buffer);

	local width = vim.api.nvim_win_get_width(win);
	local textoff = vim.fn.getwininfo(win)[1].textoff;
	local winx = vim.api.nvim_win_get_position(win)[2];

	for l = range.row_start, range.row_end - 1, 1  do
		local l_index = (l - range.row_start) + 1;

		local line = item.text[l_index];
		local start = false;

		if vim.fn.strdisplaywidth(line) <= width - textoff then
			-- Lines that are too short should be skipped.
			goto skip_line;
		end

		for c = 1, vim.fn.strdisplaywidth(line) do
			--- `l` should be 1-indexed.
			---@type integer
			local x = vim.fn.screenpos(win, l + 1, c).col - (winx + textoff);

			if x == 1 then
				if start == false then
					start = true;
					goto continue;
				end

				local extmark = get_extmark(buffer, l, c - 1);
				register_wrap(l, c - 1);

				if extmark ~= nil then
					local id = extmark[1];
					local virt_text = extmark[4].virt_text;

					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, l, c - 1, {
						id = id,

						undo_restore = false, invalidate = true,
						right_gravity = false,

						virt_text_pos = "inline",
						virt_text = vim.list_extend(virt_text, {
							{ string.rep(" ", item.__nested and 0 or range.col_start) },
							{
								tbl_clamp(config.border, l_index),
								utils.set_hl(tbl_clamp(config.border_hl, l_index) or config.hl)
							},
							{ " " }
						}),

						hl_mode = "combine",
					});
				else
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, l, c - 1, {
						undo_restore = false, invalidate = true,
						right_gravity = false,

						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", item.__nested and 0 or range.col_start) },
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

		    ::continue::
		end

		::skip_line::
	end
	---_
end

--- Renders wrapped block quotes, callouts & alerts.
---@param buffer integer
---@param item __markdown.list_items
markdown.__list_item = function (buffer, item)
	---+${lua}

	---@type markdown.list_items?
	local main_config = spec.get({ "markdown", "list_items" }, { fallback = nil });
	local range = item.range;

	if not main_config then
		return;
	end

	---@type list_items.ordered | list_items.unordered
	local config;
	local shift_width, indent_size = main_config.shift_width or 1, main_config.indent_size or 1;

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
	---@return checkboxes.opts?
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
		pad_width = pad_width + vim.fn.strdisplaywidth(checkbox.text);
	else
		pad_width = pad_width + vim.fn.strdisplaywidth(item.marker) + 1;
	end

	local win = utils.buf_getwin(buffer);

	local width = vim.api.nvim_win_get_width(win);
	local textoff = vim.fn.getwininfo(win)[1].textoff;
	local winx = vim.api.nvim_win_get_position(win)[2];

	for _, l in ipairs(item.candidates) do
		local line = item.text[l + 1];
		local start = false;

		if vim.fn.strdisplaywidth(line) <= width - textoff then
			-- Lines that are too short should be skipped.
			goto skip_line;
		end

		for c = 1, vim.fn.strdisplaywidth(line) do
			--- `l` should be 1-indexed.
			---@type integer
			local x = vim.fn.screenpos(win, range.row_start + l + 1, c).col - (winx + textoff);

			if x == 1 then
				if start == false then
					start = true;
					goto continue;
				end

				local extmark = get_extmark(buffer, range.row_start + l, c - 1);
				local has_space = has_wrap(range.row_start + l, c - 1);
				-- register_wrap(range.row_start + l, c - 1);

				if extmark ~= nil then
					local id = extmark[1];
					local virt_text = extmark[4].virt_text;

					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + l, c - 1, {
						id = id,

						undo_restore = false, invalidate = true,
						right_gravity = false,

						virt_text_pos = "inline",
						virt_text = vim.list_extend(virt_text, {
							{ string.rep(" ", has_space and pad_width - 1 or pad_width) }
						}),

						hl_mode = "combine",
					});
				else
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, range.row_start + l, c - 1, {
						undo_restore = false, invalidate = true,
						right_gravity = false,

						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(" ", math.max(0, has_space and pad_width - 1 or pad_width)) }
						},

						hl_mode = "combine",
					});
				end
			end

		    ::continue::
		end

		::skip_line::
	end
	---_
end

--- Renders wrapped block quotes, callouts & alerts.
---@param buffer integer
---@param item __markdown.sections
markdown.__section = function (buffer, item)
	---+${lua}

	---@type markdown.headings?
	local main_config = spec.get({ "markdown", "headings" }, { fallback = nil, eval_args = { buffer, item } });

	if main_config == nil then
		return;
	elseif main_config.org_indent ~= true then
		--- Org indent mode disabled.
		return;
	end

	local shift_width = main_config.org_shift_width or main_config.shift_width or 0;
	local shift_char = main_config.org_shift_char or " ";

	local win = utils.buf_getwin(buffer);

	local width = vim.api.nvim_win_get_width(win);
	local textoff = vim.fn.getwininfo(win)[1].textoff;
	local winx = vim.api.nvim_win_get_position(win)[2];

	local range = item.range;

	for l = range.row_start, range.row_end, 1  do
		local l_index = (l - range.row_start) + 1;

		local line = item.text[l_index];
		local start = false;

		if vim.fn.strdisplaywidth(line) <= width - textoff then
			-- Lines that are too short should be skipped.
			goto skip_line;
		end

		for c = 1, vim.fn.strdisplaywidth(line) do
			--- `l` should be 1-indexed.
			---@type integer
			local x = vim.fn.screenpos(win, l + 1, c).col - (winx + textoff);

			if x == 1 then
				if start == false then
					start = true;
					goto continue;
				end

				local extmark = get_extmark(buffer, l, c - 1);
				register_wrap(l, c - 1);

				if extmark ~= nil then
					local id = extmark[1];
					local virt_text = extmark[4].virt_text;

					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, l, c - 1, {
						id = id,

						undo_restore = false, invalidate = true,
						right_gravity = false,

						virt_text_pos = "inline",
						virt_text = vim.list_extend(virt_text, {
							{ string.rep(shift_char, math.max(0, shift_width * (item.level - 1))) }
						}),

						hl_mode = "combine",
					});
				else
					vim.api.nvim_buf_set_extmark(buffer, markdown.ns, l, c - 1, {
						undo_restore = false, invalidate = true,
						right_gravity = false,

						virt_text_pos = "inline",
						virt_text = {
							{ string.rep(shift_char, math.max(0, shift_width * (item.level - 1))) }
						},

						hl_mode = "combine",
					});
				end
				-- vim.api.nvim_buf_set_extmark(buffer, markdown.ns, l, c - 1, {
				-- 	undo_restore = false, invalidate = true,
				-- 	right_gravity = false,
				--
				-- 	virt_text_pos = "inline",
				-- 	virt_text = {
				-- 		{ string.rep(shift_char, shift_width * (item.level - 1)) }
				-- 	},
				--
				-- 	hl_mode = "combine",
				-- });
			end

		    ::continue::
		end

		::skip_line::
	end
	---_
end

 -----------------------------------------------------------------------------------------


--- Renders markdown preview.
---@param buffer integer
---@param content table
---@return table
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
			require("markview.health").notify("trace", {
				level = 4,
				message = {
					{ " r/markdown.lua: ", "DiagnosticVirtualTextInfo" },
					{ " " },
					{ err, "DiagnosticError" }
				}
			});
		end
	end

	return { markdown = markdown.cache };
end

--- Post-process effect renderer.
---@param buffer integer
---@param content table
markdown.post_render = function (buffer, content)
	markdown.__list_wraps = {};

	local custom = spec.get({ "renderers" }, { fallback = {} });

	for _, item in ipairs(content or {}) do
		local success, err;

		if custom[item.class] then
			success, err = pcall(custom["__" .. item.class], markdown.ns, buffer, item);
		else
			success, err = pcall(markdown["__" .. item.class:gsub("^markdown_", "")], buffer, item);
		end

		if success == false then
			require("markview.health").notify("trace", {
				level = 4,
				message = {
					{ " r/markdown.lua: ", "DiagnosticVirtualTextInfo" },
					{ string.format(" %s ", item.class), "DiagnosticVirtualTextHint" },
					{ " " },
					{ err, "DiagnosticError" }
				}
			});
		end
	end
end


------------------------------------------------------------------------------------------

--- Clears markdown previews.
---@param buffer integer
---@param from integer?
---@param to integer?
markdown.clear = function (buffer, from, to)
	vim.api.nvim_buf_clear_namespace(buffer, markdown.ns, from or 0, to or -1);
end

return markdown;
