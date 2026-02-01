---@diagnostic disable: undefined-field

local renderer = {};
local health = require("markview.health");

---@type markview.parsed
renderer.cache = {};

renderer.__filter_cache = {
	config = nil,
	result = nil
};

---@type markview.renderer.option_maps
renderer.option_maps = {
	---|fS

	asciidoc = {
		admonitions = { "asciidoc_admonition", "asciidoc_admonition_block" },
		delimited_blocks = { "asciidoc_admonition", "asciidoc_delimited_block" },
		document_attribute = { "asciidoc_document_attribute" },
		document_title = { "asciidoc_document_title" },
		horizontal_rules = { "asciidoc_hr" },
		images = { "asciidoc_image" },
		keycode = { "asciidoc_keycode" },
		list_item = { "asciidoc_list_item" },
		literal_block = { "asciidoc_literal_block" },
		section_title = { "asciidoc_section_title" },
		toc = { "asciidoc_toc" },
	},
	asciidoc_inline = {
		bold = { "asciidoc_inline_bold" },
		highlight = { "asciidoc_inline_highlight" },
		italic = { "asciidoc_inline_italic" },
		labeled_uri = { "asciidoc_inline_labeled_uri" },
		monospace = { "asciidoc_inline_monospace" },
		uri = { "asciidoc_inline_uri" },
	},
	comment = {
		autolinks = { "comment_autolink" },
		code_blocks = { "comment_code_block" },
		inline_codes = { "comment_inline_code" },
		issues = { "comment_issue" },
		mentions = { "comment_mention" },
		taglinks = { "comment_taglink" },
		task_scopes = { "comment_task_scope" },
		tasks = { "comment_task" },
		urls = { "comment_url" },
	},
	html = {
		container_elements = { "html_container_element" },
		headings = { "html_heading" },
		void_elements = { "html_void_element" },
	},
	latex = {
		blocks = { "latex_block" },
		commands = { "latex_command" },
		escapes = { "latex_escaped" },
		fonts = { "latex_font" },
		inlines = { "latex_inline" },
		parenthesis = { "latex_parenthesis" },
		subscripts = { "latex_subscript" },
		superscripts = { "latex_superscript" },
		symbols = { "latex_symbol" },
		text = { "latex_text" },
	},
	markdown = {
		block_quotes = { "markdown_block_quote" },
		checkboxes = { "markdown_checkbox" },
		code_blocks = { "markdown_code_block" },
		headings = { "markdown_atx_heading", "markdown_setext_heading" },
		horizontal_rules = { "markdown_hr" },
		list_items = { "markdown_list_item" },
		metadata_minus = { "markdown_metadata_minus" },
		metadata_plus = { "markdown_metadata_plus" },
		reference_definitions = { "markdown_link_ref_definition" },
		tables = { "markdown_table" },
	},
	markdown_inline = {
		block_references = { "inline_link_block_ref" },
		checkboxes = { "inline_checkbox" },
		emails = { "inline_link_email" },
		embed_files = { "inline_embed_files" },
		entities = { "inline_entity" },
		escapes = { "inline_escaped" },
		footnotes = { "inline_footnote" },
		highlights = { "inline_highlight" },
		hyperlinks = { "inline_link_hyperlink", "inline_link_shortcut" },
		images = { "inline_link_image" },
		inline_codes = { "inline_code_span" },
		internal_links = { "inline_link_internal" },
		uri_autolinks = { "inline_link_uri_autolink" },
	},
	typst = {
		code_blocks = { "typst_code_block" },
		code_spans = { "typst_code_span" },
		escapes = { "typst_escaped" },
		headings = { "typst_heading" },
		labels = { "typst_label" },
		list_items = { "typst_list_item" },
		math_blocks = { "typst_math_blocks" },
		math_spans = { "typst_math_spans" },
		raw_blocks = { "typst_raw_block" },
		raw_spans = { "typst_raw_span" },
		reference_links = { "typst_link_ref" },
		subscripts = { "typst_subscript" },
		superscripts = { "typst_superscript" },
		symbols = { "typst_symbol" },
		terms = { "typst_terms" },
		url_links = { "typst_link_url" },
	},
	yaml = {
		properties = { "yaml_property" },
	}

	---|fE
};


--[[
Creates a list of node classes that should be shown as *raw text*.

Algorithm,

1. Apply negation/exclusion rules.
2. Apply inclusion rules.

Example,

```
Rule: { !e, !b }

a b c d e f <-- !e
a b c d • f <-- !b
a • c d • f
```

>[!IMPORTANT]
> Filters such as `{ "!tables", "atx_headings" }` are considered **invalid**.
> 
> A valid filter should contain only `exclusion` or `inclusion` rules.
]]
---@param filter? markview.config.preview.raw
---@return markview.renderer.option_map
local _filter = function (filter)
	---|fS

	filter = filter or require("markview.spec").get({ "preview", "raw_previews" }, { fallback = {}, ignore_enable = true });

	local valid = {};

	for language --[[@as string]], map --[[@as string[] ]] in pairs(renderer.option_maps) do
		local lang_filter = filter[language] or {};
		local has_inclusions = false;

		for _, rule in ipairs(lang_filter) do
			if string.match(rule, "^[^!]") then
				has_inclusions = true;
				break;
			else
			end
		end

		local kinds = vim.tbl_filter(function (item)
			for _, rule in ipairs(lang_filter) do
				if string.match(rule, "^!") and string.match(rule, "^!(.+)") == item then
					return false;
				end
			end

			return true;
		end, vim.tbl_keys(map));

		if has_inclusions then
			kinds = vim.tbl_filter(function (item)
				for _, rule in ipairs(lang_filter) do
					if rule == item then
						return true;
					end
				end

				return false;
			end, kinds);
		end

		local nodes = {};

		for _, kind in ipairs(kinds) do
			nodes = vim.list_extend(nodes, map[kind] or {});
		end

		valid[language] = nodes;
	end

	return valid;

	---|fE
end

--- Range modifiers for various node type.
--- Used to fix ranges of specific block nodes.
---@type { [string]: fun(range: markview.parsed.range): markview.parsed.range }
renderer.range_modifiers = {
	---|fS

	markdown_atx_heading = function (range)
		local _r = vim.deepcopy(range)
		_r.row_end = _r.row_end - 1;

		return _r;
	end,
	markdown_setext_heading = function (range)
		local _r = vim.deepcopy(range)
		_r.row_end = _r.row_end - 1;

		return _r;
	end,
	markdown_code_block = function (range)
		local _r = vim.deepcopy(range)
		_r.row_end = _r.row_end - 1;

		return _r;
	end,
	markdown_block_quote = function (range)
		local _r = vim.deepcopy(range)
		_r.row_end = _r.row_end - 1;

		return _r;
	end,
	markdown_hr = function (range)
		local _r = vim.deepcopy(range)
		_r.row_end = _r.row_end - 1;

		return _r;
	end,
	markdown_list_item = function (range)
		local _r = vim.deepcopy(range)
		_r.row_end = _r.row_end - 1;

		return _r;
	end,
	markdown_metadata_minus = function (range)
		local _r = vim.deepcopy(range)
		_r.row_end = _r.row_end - 1;

		return _r;
	end,
	markdown_metadata_plus = function (range)
		local _r = vim.deepcopy(range)
		_r.row_end = _r.row_end - 1;

		return _r;
	end,
	markdown_table = function (range)
		local _r = vim.deepcopy(range)
		_r.row_end = _r.row_end - 1;

		return _r;
	end

	---|fE
};

--- Fixes node ranges for `hybrid mode`.
---@param class string
---@param range markview.parsed.range
---@return markview.parsed.range
renderer.fix_range = function (class, range)
	if renderer.range_modifiers[class] == nil then
		return range;
	end

	return renderer.range_modifiers[class](range);
end

--- Filters provided content.
--- [Used for hybrid mode]
---@param content table
---@param filter? markview.config.preview.raw
---@param clear [ integer, integer ]
---@return table
renderer.filter = function (content, filter, clear)
	---|fS

	--- Checks if `pos` is inside of `range`.
	---@param range markview.parsed.range
	---@param pos [ integer, integer ]
	---@return boolean
	local within = function (range, pos)
		---|fS

		if type(range) ~= "table" then
			return false;
		elseif type(range.row_start) ~= "number" or type(range.row_end) ~= "number" then
			return false;
		elseif vim.islist(pos) == false then
			return false;
		elseif type(pos[1]) ~= "number" or type(pos[2]) ~= "number" then
			return false;
		elseif pos[1] >= range.row_start and pos[2] <= range.row_end then
			return true;
		end

		return false;

		---|fE
	end

	---@type [ integer, integer ] Range to clear.
	local clear_range = vim.deepcopy(clear);

	--- Updates the range to clear.
	---@param new [ integer, integer ]
	local range_update = function (new)
		if new[1] <= clear_range[1] and new[2] >= clear_range[2] then
			clear_range[1] = new[1];
			clear_range[2] = new[2];
		end
	end

	--- Node filters.
	---@type markview.config.preview.raw
	local result_filters = _filter(filter);

	---@type { [string]: table }
	local indexes = {};

	-- Create a range to clear.
	for lang, items in pairs(content) do
		---|fS

		--- Filter for this language.
		---@type string[]?
		local lang_filter = result_filters[lang];

		if lang_filter == nil then
			goto continue;
		end

		indexes[lang] = {};

		for n, node in ipairs(items) do
			if vim.list_contains(lang_filter, node.class) then
				local range = renderer.fix_range(node.class, node.range);
				table.insert(indexes[lang], { n, range, node.class });

				if within(node.range, clear_range) == true then
					range_update({ range.row_start, range.row_end });
				end
			end
		end

		::continue::

		---|fE
	end

	-- Remove the nodes inside the `clear_range`.
	for lang, references in pairs(indexes) do
		---|fS

		--- Amount of nodes removed in this language.
		--- Used for offsetting the index for later nodes.
		local removed = 0;

		for _, ref in ipairs(references) do
			local range = ref[2];

			if range.row_start >= clear_range[1] and range.row_end <= clear_range[2] then
				table.remove(content[lang], ref[1] - removed);
				removed = removed + 1;
			end
		end

		---|fE
	end

	return content;

	---|fE
end

--- Renders things
---@param buffer integer
---@param parsed_content markview.parsed
renderer.render = function (buffer, parsed_content)
	---|fS

	local _renderers = {
		asciidoc = require("markview.renderers.asciidoc"),
		asciidoc_inline = require("markview.renderers.asciidoc_inline"),
		comment = require("markview.renderers.comment"),
		html = require("markview.renderers.html"),
		markdown = require("markview.renderers.markdown"),
		markdown_inline = require("markview.renderers.markdown_inline"),
		latex = require("markview.renderers.latex"),
		yaml = require("markview.renderers.yaml"),
		typst = require("markview.renderers.typst"),
	};

	renderer.cache = {};

	---@type table<integer, boolean>
	local heading_ranges = {};

	for _, entry in ipairs(parsed_content.markdown or {}) do
		if entry.class == "markdown_atx_heading" or entry.class == "markdown_setext_heading" then
			for r = entry.range.row_start, entry.range.row_end, 1 do
				heading_ranges[r] = true;
			end
		end
	end

	---|fS, "chore, Announce start of rendering"

	---@type integer
	local start = vim.uv.hrtime();

	health.print({
		from = "renderer.lua",
		fn = "render()",

		message = string.format("Rendering: %d", buffer),
		nest = true
	});

	---|fE

	for lang, content in pairs(parsed_content) do
		---@cast lang string
		---@cast content
		---| markview.parsed.html[]
		---| markview.parsed.html[]
		---| markview.parsed.latex[]
		---| markview.parsed.markdown[]
		---| markview.parsed.markdown_inline[]
		---| markview.parsed.typst[]
		---| markview.parsed.yaml[]

		if _renderers[lang] then
			local c = _renderers[lang].render(buffer, content, lang == "markdown_inline" and heading_ranges or nil);
			renderer.cache = vim.tbl_extend("force", renderer.cache, c or {});
		end
	end

	---|fS "chore: Announce end of main render"

	local post = vim.uv.hrtime();

	health.print({
		from = "renderer.lua",
		fn = "render()",

		message = string.format("Render(main): %dms", (post - start) / 1e6)
	});

	---|fE

	for lang, content in pairs(renderer.cache) do
		if _renderers[lang] then
			_renderers[lang].post_render(buffer, content);
		end
	end

	---|fS "chore: Announce end of rendering"
	local now = vim.uv.hrtime();

	health.print({
		from = "renderer.lua",
		fn = "render()",

		message = string.format("Render(post): %dms", (now - post) / 1e6)
	});
	health.print({
		from = "renderer.lua",
		fn = "render()",

		message = string.format("Rendering total(%d): %dms", buffer, (now - start) / 1e6),
		back = true
	});

	---|fE

	---|fE
end

--- Clears rendered content.
---@param buffer integer
---@param from? integer
---@param to? integer
---@param hybrid_mode? boolean
renderer.clear = function (buffer, from, to, hybrid_mode)
	---|fS

	local _renderers = {
		asciidoc = require("markview.renderers.asciidoc"),
		asciidoc_inline = require("markview.renderers.asciidoc_inline"),
		comment = require("markview.renderers.comment");
		html = require("markview.renderers.html");
		markdown = require("markview.renderers.markdown");
		markdown_inline = require("markview.renderers.markdown_inline");
		latex = require("markview.renderers.latex");
		yaml = require("markview.renderers.yaml");
		typst = require("markview.renderers.typst");
	};

	local langs = vim.tbl_keys(_renderers);
	local start = vim.uv.hrtime();

	---|fS "chore: Announce start of clearing"

	health.print({
		from = "renderer.lua",
		fn = "clear()",

		message = string.format("Clearing: %d", buffer),
		nest = true
	});

	---|fE

	for _, lang in ipairs(langs) do
		if _renderers[lang] then
			_renderers[lang].clear(buffer, from, to, hybrid_mode);
		end
	end

	---|fS "chore: Announce end of clearing"

	local now = vim.uv.hrtime();

	health.print({
		from = "renderer.lua",
		fn = "clear()",

		message = string.format("Clearing total(%d): %dms", buffer, (now - start) / 1e6),
		back = true
	});

	---|fE

	---|fE
end

--- Gets the range a list of contents occupy.
---@param content table[]
---@return integer
---@return integer
renderer.get_range = function (content)
	---|fS

	local from, to = nil, nil;
	local ignore_nodes = {
		markdown = { "markdown_section" }
	}

	for lang, lang_items in pairs(content) do
		for _, item in ipairs(lang_items) do
			if vim.list_contains(ignore_nodes[lang] or {}, item.class) then
				goto continue;
			end

			local range = renderer.fix_range(item.class, vim.deepcopy(item.range));

			if not from or range.row_start < from then
				from = range.row_start;
			end

			if not to or range.row_end > to then
				to = range.row_end;
			end

		    ::continue::
		end
	end

	return from, to;

	---|fE
end

return renderer;
