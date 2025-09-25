--- Configuration specification file
--- for `markview.nvim`.
---
--- It has the following tasks,
---    • Maintain backwards compatibility
---    • Check for issues with config
local spec = {};
local health = require("markview.health");

---@type markview.config
spec.default = {
	experimental = {
		check_rtp = true,
		check_rtp_message = true,

		date_formats = {
			"^%d%d%d%d%-%d%d%-%d%d$",      --- YYYY-MM-DD
			"^%d%d%-%d%d%-%d%d%d%d$",      --- DD-MM-YYYY, MM-DD-YYYY
			"^%d%d%-%d%d%-%d%d$",          --- DD-MM-YY, MM-DD-YY, YY-MM-DD

			"^%d%d%d%d%/%d%d%/%d%d$",      --- YYYY/MM/DD
			"^%d%d%/%d%d%/%d%d%d%d$",      --- DD/MM/YYYY, MM/DD/YYYY

			"^%d%d%d%d%.%d%d%.%d%d$",      --- YYYY.MM.DD
			"^%d%d%.%d%d%.%d%d%d%d$",      --- DD.MM.YYYY, MM.DD.YYYY

			"^%d%d %a+ %d%d%d%d$",         --- DD Month YYYY
			"^%a+ %d%d %d%d%d%d$",         --- Month DD, YYYY
			"^%d%d%d%d %a+ %d%d$",         --- YYYY Month DD

			"^%a+%, %a+ %d%d%, %d%d%d%d$", --- Day, Month DD, YYYY
		},

		date_time_formats = {
			"^%a%a%a %a%a%a %d%d %d%d%:%d%d%:%d%d ... %d%d%d%d$", --- UNIX date time
			"^%d%d%d%d%-%d%d%-%d%dT%d%d%:%d%d%:%d%dZ$",           --- ISO 8601
		},

		prefer_nvim = false,
		file_open_command = "tabnew",

		list_empty_line_tolerance = 3,

		read_chunk_size = 1024,


		linewise_ignore_org_indent = false
	};

	highlight_groups = {},

	preview = {
		enable = true,
		enable_hybrid_mode = true,

		callbacks = {
			on_attach = function (_, wins)
				--- Initial state for attached buffers.
				---@type string
				local attach_state = spec.get({ "preview", "enable" }, { fallback = true, ignore_enable = true });

				if attach_state == false then
					--- Attached buffers will not have their previews
					--- enabled.
					--- So, don't set options.
					return;
				end

				for _, win in ipairs(wins) do
					--- Preferred conceal level should
					--- be 3.
					vim.wo[win].conceallevel = 3;
				end
			end,

			on_detach = function (_, wins)
				for _, win in ipairs(wins) do
					--- Only set `conceallevel`.
					--- `concealcursor` will be
					--- set via `on_hybrid_disable`.
					vim.wo[win].conceallevel = 0;
				end
			end,

			on_enable = function (_, wins)
				--- Initial state for attached buffers.
				---@type string
				local attach_state = spec.get({ "preview", "enable" }, { fallback = true, ignore_enable = true });

				if attach_state == false then
					-- If the window's aren't initially
					-- attached, we need to set the 
					-- 'concealcursor' too.

					---@type string[]
					local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
					---@type string[]
					local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });

					local concealcursor = "";

					for _, mode in ipairs(preview_modes) do
						if vim.list_contains(hybrid_modes, mode) == false and vim.list_contains({ "n", "v", "i", "c" }, mode) then
							concealcursor = concealcursor .. mode;
						end
					end

					for _, win in ipairs(wins) do
						vim.wo[win].conceallevel = 3;
						vim.wo[win].concealcursor = concealcursor;
					end
				else
					for _, win in ipairs(wins) do
						vim.wo[win].conceallevel = 3;
					end
				end
			end,

			on_disable = function (_, wins)
				for _, win in ipairs(wins) do
					vim.wo[win].conceallevel = 0;
				end
			end,

			on_hybrid_enable = function (_, wins)
				---@type string[]
				local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
				---@type string[]
				local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });

				local concealcursor = "";

				for _, mode in ipairs(preview_modes) do
					if vim.list_contains(hybrid_modes, mode) == false and vim.list_contains({ "n", "v", "i", "c" }, mode) then
						concealcursor = concealcursor .. mode;
					end
				end

				for _, win in ipairs(wins) do
					vim.wo[win].concealcursor = concealcursor;
				end
			end,

			on_hybrid_disable = function (_, wins)
				---@type string[]
				local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
				local concealcursor = "";

				for _, mode in ipairs(preview_modes) do
					if vim.list_contains({ "n", "v", "i", "c" }, mode) then
						concealcursor = concealcursor .. mode;
					end
				end

				for _, win in ipairs(wins) do
					vim.wo[win].concealcursor = concealcursor;
				end
			end,

			on_mode_change = function (_, wins, current_mode)
				---@type string[]
				local preview_modes = spec.get({ "preview", "modes" }, { fallback = {}, ignore_enable = true });
				---@type string[]
				local hybrid_modes = spec.get({ "preview", "hybrid_modes" }, { fallback = {}, ignore_enable = true });

				local concealcursor = "";

				for _, mode in ipairs(preview_modes) do
					if vim.list_contains(hybrid_modes, mode) == false and vim.list_contains({ "n", "v", "i", "c" }, mode) then
						concealcursor = concealcursor .. mode;
					end
				end

				for _, win in ipairs(wins) do
					if vim.list_contains(preview_modes, current_mode) then
						vim.wo[win].conceallevel = 3;
						vim.wo[win].concealcursor = concealcursor;
					else
						vim.wo[win].conceallevel = 0;
						vim.wo[win].concealcursor = "";
					end
				end
			end,

			on_splitview_open = function (_, _, win)
				vim.wo[win].conceallevel = 3;
				vim.wo[win].concealcursor = "n";
			end
		},

		map_gx = true,

		debounce = 150,
		icon_provider = "internal",

		filetypes = { "markdown", "quarto", "rmd", "typst" },
		ignore_buftypes = { "nofile" },
		raw_previews = {},

		modes = { "n", "no", "c" },
		hybrid_modes = {},

		linewise_hybrid_mode = false,
		max_buf_lines = 1000,

		draw_range = { 2 * vim.o.lines, 2 * vim.o.lines },
		edit_range = { 0, 0 },

		splitview_winopts = {
			split = "right"
		},
	},

	renderers = {},

	--
	-- markdown = {
	-- },
	-- markdown_inline = {
	-- },
	-- html = {
	-- },
	-- latex = {
	-- },
	-- typst = {
	-- },
	-- yaml = {
	-- }
};

---@type string[] Properties that should be sourced *externally*.
spec.__external_config = {
	"html",
	"markdown",
	"markdown_inline",
	"latex",
	"typst",
	"yaml",
};

spec.config = vim.deepcopy(spec.default);
spec.tmp_config = nil;

spec.fixup = {
	["buf_ignore"] = function (value)
		health.notify("deprecation", {
			option = "buf_ignore",
			alter = "preview → ignore_buftypes"
		});

		if vim.islist(value) == false then
			return {};
		end

		return {
			preview = {
				ignore_buftypes = value;
			}
		};
	end,
	["callbacks"] = function (value)
		health.notify("deprecation", {
			option = "callbacks",
			alter = "preview → callbacks"
		});

		if type(value) ~= "table" then
			return {};
		end

		return {
			preview = {
				callbacks = value;
			}
		};
	end,
	["debounce"] = function (value)
		health.notify("deprecation", {
			option = "debounce",
			alter = "preview → debounce"
		});

		if type(value) ~= "number" then
			return {};
		end

		return {
			preview = {
				debounce = value;
			}
		};
	end,
	["filetypes"] = function (value)
		health.notify("deprecation", {
			option = "filetypes",
			alter = "preview → filetypes"
		});

		if vim.islist(value) == false then
			return {};
		end

		return {
			preview = {
				filetypes = value;
			}
		};
	end,
	["hybrid_modes"] = function (value)
		health.notify("deprecation", {
			option = "hybrid_modes",
			alter = "preview → hybrid_modes"
		});

		if vim.islist(value) == false then
			return {};
		end

		return {
			preview = {
				hybrid_modes = value;
			}
		};
	end,
	["ignore_nodes"] = function (_)
		health.notify("deprecation", {
			option = "ignore_nodes",
			alter = "preview → ignore_previews"
		});

		return {};
	end,
	["initial_state"] = function (value)
		health.notify("deprecation", {
			option = "initial_state",
			alter = "preview → enable"
		});

		if type(value) ~= "boolean" then
			return {};
		else
			return {
				preview = {
					enable = value
				}
			};
		end
	end,
	["max_file_length"] = function (value)
		health.notify("deprecation", {
			option = "max_file_length",
			alter = "preview → max_buf_lines"
		});

		if type(value) ~= "integer" then
			return {};
		else
			return {
				preview = {
					max_buf_lines = value
				}
			};
		end
	end,
	["modes"] = function (value)
		health.notify("deprecation", {
			option = "modes",
			alter = "preview → modes"
		});

		if vim.islist(value) == false then
			return {};
		end

		return {
			preview = {
				modes = value;
			}
		};
	end,
	["render_distance"] = function (value)
		health.notify("deprecation", {
			option = "render_distance",
			alter = "preview → draw_range"
		});

		if vim.islist(value) == false or #value ~= 2 then
			return {};
		elseif type(value) == "number" then
			health.notify("type", {
				option = "preview → draw_range",
				uses = "[ integer, integer ]",
				got = type(value)
			});

			return {
				preview = {
					draw_range = { value, value }
				}
			};
		end

		return {};
	end,
	["split_conf"] = function (value)
		health.notify("deprecation", {
			option = "split_conf",
			alter = "preview → splitview_winopts"
		});

		if type(value) ~= "table" then
			health.notify("type", {
				option = "preview → splitview_winopts",
				uses = "table",
				got = type(value)
			});

			return {};
		end

		return {
			preview = {
				splitview_winopts = value;
			}
		};
	end,

	["injections"] = function ()
		health.notify("deprecation", {
			option = "injections",
			tip = {
				{ "See ", "Normal" },
				{ " :h markview-advanced ", "DiagnosticVirtualTextHint" }
			}
		});

		return {};
	end,


	["block_quotes"] = function (config)
		local _o = {
			markdown = {
				block_quotes = {};
			}
		};

		--- Handles old callout definitions.
		---@param callouts table[]
		local handle_callouts = function (callouts)
			health.notify("deprecation", {
				option = "markdown → block_quotes → callouts",
				tip = {
					{ "Create a callout using the " },
					{ " match_string ", "DiagnosticVirtualTextInfo" },
					{ " as the key inside " },
					{ " markdown → block_quotes ", "DiagnosticVirtualTextHint" },
					{ "." },
				}
			});

			for _, callout in ipairs(callouts) do
				if callout.match_string then
					_o.markdown.block_quotes[callout.match_string] = {
						border = callout.border,
						border_hl = callout.border_hl,

						hl = callout.hl,

						icon = callout.icon,
						icon_hl = callout.icon_hl,

						preview = callout.preview,
						preview_hl = callout.preview_hl,

						title = callout.title,
					};
				end
			end
		end

		for key, value in pairs(config) do
			if key == "callouts" then
				if vim.islist(value) then
					handle_callouts(value);
				end
			else
				_o.markdown.block_quotes[key] = value;
			end
		end

		return _o;
	end,
	["code_blocks"] = function (config)
		local _o = {
			preview = {},
			markdown = {
				code_blocks = {}
			}
		};

		for key, value in pairs(config) do
			if key == "icon" then
				health.notify("deprecation", {
					option = "code_blocks → icon",
					alter = "preview → icon_provider"
				});

				_o.preview.icon_provider = value;
			elseif key == "language_names" then
				health.notify("deprecation", {
					option = "code_blocks → language_names"
				});
			elseif key == "hl" then
				health.notify("deprecation", {
					option = "code_blocks → hl",
					alter = "code_blocks → border_hl"
				});

				_o.markdown.code_blocks.border_hl = value;
			elseif key == "style" then
				if value == "minimal" then
					health.notify("type", {
						option = "markdown → code_blocks → style",
						uses = '"simple" | "block"',
						got = '"minimal"'
					});

					_o.markdown.code_blocks.style = "block";
				else
					_o.markdown.code_blocks.style = value;
				end
			else
				_o.markdown.code_blocks[key] = value;
			end
		end

		return _o;
	end,
	["headings"] = function (value)
		health.notify("deprecation", {
			option = "headings",
			alter = "markdown → headings"
		});

		return {
			markdown = {
				headings = value
			}
		};
	end,
	["horizontal_rules"] = function (value)
		health.notify("deprecation", {
			option = "horizontal_rules",
			alter = "markdown → horizontal_rules"
		});

		return {
			markdown = {
				horizontal_rules = value
			}
		};
	end,
	["list_items"] = function (value)
		health.notify("deprecation", {
			option = "list_items",
			alter = "markdown → list_items"
		});

		return {
			markdown = {
				list_items = value
			}
		};
	end,
	["tables"] = function (config)
		local _o = {
			markdown = {
				tables = {}
			}
		};

		health.notify("deprecation", {
			option = "tables",
			alter = "markdown → tables"
		});

		for k, v in pairs(config) do
			if k == "parts" and vim.islist(v) then
				--- Legacy option spec
			elseif k == "hl" and vim.islist(v) then
				--- Legacy option spec
			elseif k == "col_min_width" then
				health.notify("deprecation", {
					option = "markdown → tables → col_min_width"
				});
			else
				_o.markdown.tables[k] = v;
			end
		end

		return _o;
	end,

	["inline_codes"] = function (value)
		return {
			markdown_inline = {
				inline_codes = value
			}
		};
	end,
	["checkboxes"] = function (config)
		local _o = {
			markdown_inline = {
				checkboxes = {}
			}
		};

		for k, v in pairs(config) do
			if k == "custom" then
				if vim.islist(v) == false then
					goto invalid_type;
				end

				for _, entry in ipairs(v) do
					if entry.match_string then
						_o.markdown_inline.checkboxes[entry.match_string] = {
							text = entry.text,
							hl = entry.hl,

							scope_hl = entry.scope_hl
						};
					end
				end

				::invalid_type::
			else
				_o.markdown_inline.checkboxes[k] = v;
			end
		end

		return _o;
	end,
	["links"] = function (config)
		local _o = {
			markdown_inline = {}
		};

		--- Handles link config tables.
		---@param opt string
		---@param val table
		local function handle_link (opt, val)
			local _l = {
				default = {}
			};

			for k, v in pairs(val) do
				if k == "icon" then
					_l.default[k] = v;
				elseif k == "hl" then
					_l.default[k] = v;
				elseif k == "custom" then
					if vim.islist(v) == false then
						goto invalid_type;
					end

					for _, entry in ipairs(v) do
						if entry.match_string then
							_l[entry.match_string] = {
								text = entry.text,
								hl = entry.hl
							};
						end
					end

					::invalid_type::
				elseif k ~= "__emoji_link_compatability" then
					_l[k] = v;
				end
			end

			_o.markdown_inline[opt] = _l;
		end

		for k, v in pairs(config) do
			if vim.list_contains({ "hyperlinks", "images", "emails", "internals" }, k) then
				if k == "internals" then
					handle_link("internal_links", v);
				else
					handle_link(k, v);
				end
			end
		end

		return _o;
	end,
	["footnotes"] = function (config)
		local _o = {
			markdown_inline = {
				footnotes = {}
			}
		};

		--- Handles link config tables.
		---@param opt string
		---@param val table
		local function handle_link (opt, val)
			local _l = {
				default = {}
			};

			for k, v in pairs(val) do
				if k == "icon" then
					_l.default[k] = v;
				elseif k == "hl" then
					_l.default[k] = v;
				elseif k == "custom" then
					if vim.islist(v) == false then
						goto invalid_type;
					end

					for _, entry in ipairs(v) do
						if entry.match_string then
							_l[entry.match_string] = {
								text = entry.text,
								hl = entry.hl
							};
						end
					end

					::invalid_type::
				elseif k ~= "use_unicode" then
					_l[k] = v;
				end
			end

			_o.markdown_inline[opt] = _l;
		end

		handle_link("footnotes", config);
		return _o;
	end,

	["html"] = function (value)
		if value.entities then
			health.notify("deprecation", {
				option = "html → entities",
				alter = "markdown_inline → entities"
			});
		end

		return {
			markdown_inline = {
				entities = value.entities
			},
			html = {
				container_elements = value.container_elements,
				headings = value.headings,
				void_elements = value.void_elements
			}
		};
	end,

	["latex"] = function (config)
		local _o = {
			latex = {}
		};

		for k, v in pairs(config) do
			if k == "brackets" then
				health.notify("deprecation", {
					option = "latex → brackets",
					alter = "latex → parenthesis"
				});

				_o.latex.parenthesis = v;
			elseif k == "block" then
				health.notify("deprecation", {
					option = "latex → block",
					alter = "latex → blocks"
				});

				_o.latex.blocks = v;
			elseif k == "inline" then
				health.notify("deprecation", {
					option = "latex → inline",
					alter = "latex → inlines"
				});

				_o.latex.inlines = v;
			elseif k == "operators" then
				health.notify("deprecation", {
					option = "latex → operators",
					alter = "latex → commands"
				});

				local _c = {};

				for _, entry in ipairs(v) do
					_c[entry.match_string] = {
						-- TODO, here
					};
				end

				_o.latex.commands = _c;
			elseif k == "symbols" then
				if v.overwrite then
					health.notify("deprecation", {
						option = "latex → symbols → overwrite"
					});
				end

				if v.groups then
					health.notify("deprecation", {
						option = "latex → symbols → groups",
						tip = {
							{ " latex → symbols → hl ", "DiagnosticVirtualTextInfo" },
							{ " can be a " },
							{ " fun(buffer, item): string? ", "DiagnosticVirtualTextHint" },
							{ "." },
						}
					});
				end

				_o.latex.symbols = {
					enable = v.enable,
					hl = v.hl
				};
			elseif k == "subscript" then
				health.notify("deprecation", {
					option = "latex → subscript",
					alter = "latex → subscripts"
				});

				_o.latex.subscripts = v;
			elseif k == "superscript" then
				health.notify("deprecation", {
					option = "latex → superscript",
					alter = "latex → superscripts"
				});

				_o.latex.superscripts = v;
			end
		end

		return _o;
	end,

	["preview"] = function (config)
		local _o = {
			previews = {}
		};

		for k, v in pairs(config) do
			if k == "ignore_previews" then
				health.notify("deprecation", {
					option = "preview → ignore_previews",
					alter = "preview → raw_previews"
				});

				_o.preview.raw_previews = v;
			else
				_o.preview[k] = v;
			end
		end

		return _o;
	end,
};

--- Tries to fix deprecated config spec
---@param config table?
---@return table
spec.fix_config = function (config)
	if type(config) ~= "table" then
		return {};
	end

	--- Table containing valid options.
	local main = {
		renderers = config.renderers,
		highlight_groups = config.highlight_groups,

		preview = config.preview,
		experimental = config.experimental,

		html = config.html,
		latex = config.latex,
		markdown = config.markdown,
		markdown_inline = config.markdown_inline,
		typst = config.typst,
		yaml = config.yaml,
	};

	--- Table containing the fixed version of
	--- deprecated options.
	local fixed = {};

	for k, v in pairs(config) do
		if spec.fixup[k] then
			local _f, _r = pcall(spec.fixup[k], v);

			if _f == true then
				fixed = vim.tbl_deep_extend("force", fixed, _r);
			end
		end
	end

	if vim.tbl_isempty(fixed) == false then
		health.fixed_config = fixed;
	end

	return vim.tbl_deep_extend("force", main, fixed);
end

--- Setup function for markview.
---@param config markview.config?
spec.setup = function (config)
	config = spec.fix_config(config);
	spec.config = vim.tbl_deep_extend("force", spec.config, config);
end

--- Function to retrieve configuration options
--- from a config table.
---@param keys ( string | integer )[]
---@param opts markview.spec.get_opts
---@return any
spec.get = function (keys, opts)
	--- In case the values are correctly provided..
	keys = keys or {};
	opts = opts or {};

	--- Turns a dynamic value into
	--- a static value.
	---@param val any | fun(...): any
	---@param args any[]?
	---@return any
	local function to_static(val, args)
		if type(val) ~= "function" then
			return val;
		end

		args = args or {};

		if pcall(val, unpack(args)) then
			return val(unpack(args));
		else
			return nil;
		end
	end

	---@param index integer | string
	---@return any
	local function get_arg(index)
		if type(opts.args) ~= "table" then
			return {};
		elseif opts.args.__is_arg_list == true then
			return opts.args[index];
		else
			return opts.args;
		end
	end

	--- Temporarily store the value.
	---
	--- Use `deepcopy()` as we may need to
	--- modify this value.
	---@type any
	local val;

	if type(opts.source) == "table" or type(opts.source) == "function" then
		-- Custom config source provided.
		val = opts.source;
	elseif spec.tmp_config then
		if vim.list_contains(spec.__external_config, keys[1]) then
			local could_load, loaded = pcall(require, "markview.config." .. keys[1]);

			if
				could_load and type(loaded) == "table" and
				#vim.tbl_keys(loaded) ~= #vim.tbl_keys(spec.tmp_config[keys[1]] or {})
			then
				spec.tmp_config[keys[1]] = vim.tbl_deep_extend(
					"keep",
					spec.tmp_config[keys[1]] or {},
					loaded
				);
			end
		end

		val = spec.tmp_config;
	elseif spec.config then
		if vim.list_contains(spec.__external_config, keys[1]) then
			local could_load, loaded = pcall(require, "markview.config." .. keys[1]);

			if
				could_load and type(loaded) == "table" and
				#vim.tbl_keys(loaded) ~= #vim.tbl_keys(spec.config[keys[1]] or {})
			then
				spec.config[keys[1]] = vim.tbl_deep_extend(
					"keep",
					spec.config[keys[1]] or {},
					loaded
				);
			end
		end

		val = spec.config;
	else
		val = {};
	end

	--- Turn the main value into a static value.
	--- [ In case a function was provided as the source. ]
	val = to_static(val, get_arg("init"));

	if type(val) ~= "table" then
		--- The source isn't a table.
		return opts.fallback;
	end

	for k, key in ipairs(keys) do
		if k ~= #keys then
			val = to_static(val[key], val.args);

			if type(val) ~= "table" then
				return opts.fallback;
			elseif opts.ignore_enable ~= true and val.enable == false then
				return opts.fallback;
			end
		else
			--- Do not evaluate the final
			--- value.
			---
			--- It should be evaluated using
			--- `eval_args`.
			val = val[key];
		end
	end

	if vim.islist(opts.eval_args) == true and type(val) == "table" then
		local _e = {};
		local eval = opts.eval or vim.tbl_keys(val);
		local ignore = opts.eval_ignore or {};

		for k, v in pairs(val) do
			if type(v) ~= "function" then
				--- A silly attempt at reducing
				--- wasted time due to extra
				--- logic.
				_e[k] = v;
			elseif vim.list_contains(ignore, k) == false then
				if vim.list_contains(eval, k) then
					_e[k] = to_static(v, opts.eval_args);
				else
					_e[k] = v;
				end
			else
				_e[k] = v;
			end
		end

		val = _e;
	elseif vim.islist(opts.eval_args) == true and type(val) == "function" then
		val = to_static(val, opts.eval_args);
	end

	if val == nil and opts.fallback then
		return opts.fallback;
	elseif type(val) == "table" and ( opts.ignore_enable ~= true and val.enable == false ) then
		return opts.fallback;
	else
		return val;
	end
end

return spec;
-- vim:foldmethod=indent
