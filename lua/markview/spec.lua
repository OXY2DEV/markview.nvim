--- Configuration specification file
--- for `markview.nvim`.
---
--- It has the following tasks,
---    • Check for issues with config
local spec = {};

---@type markview.config
spec.default = {
	experimental = {
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

		draw_range = { 1 * vim.o.lines, 1 * vim.o.lines },
		edit_range = { 0, 0 },

		splitview_winopts = {
			split = "right"
		},
	},

	renderers = {},
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

---@param config markview.config?
spec.tmp_setup = function (config)
	spec.tmp_config = config;
end

spec.tmp_reset = function ()
	spec.tmp_config = nil;
end

--- Setup function for markview.
---@param config markview.config?
spec.setup = function (config)
	spec.config = vim.tbl_deep_extend("force", spec.config, config or {});
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

		local ok, res = pcall(val, unpack(args or {}));
		return ok and res or nil;
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
