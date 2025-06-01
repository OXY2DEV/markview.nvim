local health = {};

--- Logs for health check
---@type markview.health.log[]
health.log = {};

health.ns = vim.api.nvim_create_namespace("markview/health");
health.buffer = nil;
health.window = nil;

--- Fixed version of deprecated options.
health.fixed_config = nil;

health.child_indent = 0;

--- Increases indent level of child messages.
health.__child_indent_in = function ()
	health.child_indent = health.child_indent + 1;
end

--- Decreases indent level of child messages.
health.__child_indent_de = function ()
	health.child_indent = math.max(0, health.child_indent - 1);
end

--- Fancy print()
---@param handler string | nil
---@param opts markview.notify.opts
health.notify = function (handler, opts)
	--- Wrapper for tostring()
	---@param value string | [ string, string? ][]
	---@return string
	local function to_string(value)
		if vim.islist(value --[[ @as table ]]) == false then
			return tostring(value);
		end

		local _t = "";

		for _, item in ipairs(value --[[ @as table ]]) do
			if type(item[1]) == "string" then
				if type(item[2]) == "string" and item[2]:match("VirtualText") then
					_t = _t .. item[1]:gsub("^%s", "{"):gsub("%s$", "}");
				else
					_t = _t .. item[1];
				end
			end
		end

		return _t;
	end

	if handler == "deprecation" then
		---@cast opts markview.notify.deprecation

		local chunks = {
			{ "  markview.nvim ", "MarkviewPalette1" },
			{ ": ", "@comment" },
			{ string.format(" %s ", opts.option), "DiagnosticVirtualTextError" },
			{ " is deprecated. ", "@comment" },
		};

		if opts.alter then
			chunks = vim.list_extend(chunks, {
				{ "Use ", "@comment" },
				{ string.format(" %s ", opts.alter), "DiagnosticVirtualTextHint" },
				{ " instead.", "@comment" },
			});
		end

		if vim.islist(opts.tip --[[ @as table ]]) then
			chunks = vim.list_extend(chunks, {
				{ "\n" },
				{ "  Tip: ", "DiagnosticVirtualTextWarn" },
				{ " " },
			});
			chunks = vim.list_extend(chunks, opts.tip --[[ @as table ]]);
		end

		---  markview.nvim :  foo  is deprecated. Use  bar  instead.
		vim.api.nvim_echo(chunks, true, {});

		table.insert(health.log, {
			kind = "deprecation",
			name = opts.option,
			ignore = opts.ignore,

			alternative = opts.alter,
			tip = opts.tip and to_string(opts.tip) or nil
		});
	elseif handler == "type" then
		---@cast opts markview.notify.type_mismatch

		local article_1 = "a ";
		local article_2 = "a ";

		if string.match(opts.uses, "^[aeiou]") then
			article_1 = "an ";
		elseif string.match(opts.uses, "^%A") then
			article_1 = "";
		end

		if string.match(opts.got, "^[aeiou]") then
			article_2 = "an ";
		elseif string.match(opts.got, "^%A") then
			article_2 = "";
		end

		---  markview.nvim :  foo  is a  bar , not a  baz .
		vim.api.nvim_echo({
			{ "  markview.nvim ", "MarkviewPalette3" },
			{ ": ", "@comment" },
			{ string.format(" %s ", opts.option), "DiagnosticVirtualTextInfo" },
			{ " is " .. article_1, "@comment" },
			{ string.format(" %s ", opts.uses), "DiagnosticVirtualTextHint" },
			{ ", not " .. article_2, "@comment" },
			{ string.format(" %s ", opts.got), "DiagnosticVirtualTextError" },
			{ ".", "@comment" }
		}, true, {});

		table.insert(health.log, {
			kind = "type_error",
			option = opts.option,

			requires = opts.uses,
			received = opts.got
		});
	elseif handler == "hl" then
		---@cast opts markview.notify.hl

		local text = vim.split(
			vim.inspect(opts.value) or "",
			"\n",
			{ trimempty = true }
		);
		local lines = { { "\n" } };

		for l, line in ipairs(text) do
			lines = vim.list_extend(lines, {
				{ string.format("% " .. #text .. "d ", l), "LineNr" },
				{ line, "@comment" },

				{ "\n" },
			});
		end

		vim.api.nvim_echo(vim.list_extend({
			{ "  markview.nvim ", "MarkviewPalette5" },
			{ ": ", "@comment" },
			{ "Failed to set ", "@comment" },
			{ string.format(" %s ", opts.group), "DiagnosticVirtualTextInfo" },
			{ ",", "@comment" }
		}, lines), true, {});

		table.insert(health.log, {
			kind = "hl",

			group = opts.group,
			value = opts.value,

			message = opts.message
		});
	elseif handler == "trace" then
		---@cast opts markview.notify.trace

		local config = {
			{ "", "DiagnosticOk" },
			{ "", "DiagnosticWarn" },
			{ "", "DiagnosticOk" },

			{ "", "DiagnosticError" },
			{ "", "DiagnosticInfo" },

			{ " ", "DiagnosticHint" },
			{ " ", "DiagnosticWarn" },

			{ " ", "DiagnosticOk" },
			{ " ", "DiagnosticError" },
		};

		local icon, hl = config[opts.level or 5][1], config[opts.level or 5][2];
		local indent = string.rep("  ", opts.indent or health.child_indent or 0);

		local notif;

		if vim.islist(opts.message --[[ @as table ]]) then
			notif = vim.list_extend({
				{ string.format("%s%s ", indent, icon), hl },
				{ os.date("%H:%m"), "Comment" },
				{ " │ ", "@comment" },
			}, opts.message --[[ @as table ]]);
		else
			notif = {
				{ string.format("%s%s ", indent, icon), hl },
				{ os.date("%H:%m"), "Comment" },
				{ " │ ", "Comment" },
				{ opts.message or "", hl }
			};
		end

		if vim.g.__mkv_dev == true then
			vim.api.nvim_echo(notif, true, { verbose = true });
		end

		if opts.child_indent then
			health.child_indent = opts.child_indent;
		end

		table.insert(health.log, {
			kind = "trace",
			ignore = true,
			indent = opts.indent or health.child_indent,

			timestamp = os.date("%k:%M:%S"),
			message = to_string(opts.message),
			notification = notif or {},
			level = opts.level
		})
	else
		---@cast opts { message: [ string, string? ][] }

		vim.api.nvim_echo(
			vim.list_extend(
				{
					{ "  markview.nvim ", "MarkviewPalette6" },
					{ ": ", "@comment" },
				},
				opts.message
			),
			true,
			{}
		);
	end
end

--- Sets up the buffer & window for trace-view
local function trace_view_setup ()
	if not health.buffer then
		health.buffer = vim.api.nvim_create_buf(false, true);

		vim.api.nvim_create_autocmd({ "BufLeave" }, {
			buffer = health.buffer,
			callback = function ()
				pcall(vim.api.nvim_win_close, health.window, true);
			end
		});
	elseif vim.api.nvim_buf_is_valid(health.buffer) == false then
		health.buffer = vim.api.nvim_create_buf(false, true);

		vim.api.nvim_create_autocmd({ "BufLeave" }, {
			buffer = health.buffer,
			callback = function ()
				pcall(vim.api.nvim_win_close, health.window, true);
			end
		});
	end

	local w = math.floor(vim.o.columns * 0.75);
	local h = math.floor(vim.o.lines * 0.5);

	if not health.window then
		health.window = vim.api.nvim_open_win(health.buffer, true, {
			relative = "editor",

			row = math.ceil((vim.o.lines - h) / 2),
			col = math.ceil((vim.o.columns - w) / 2),

			width = w,
			height = h,

			style = "minimal",
		});
	elseif vim.api.nvim_win_is_valid(health.window) == false then
		health.window = vim.api.nvim_open_win(health.buffer, true, {
			relative = "editor",

			row = math.ceil((vim.o.lines - h) / 2),
			col = math.ceil((vim.o.columns - w) / 2),

			width = w,
			height = h,

			style = "minimal"
		});
	else
		vim.api.nvim_win_set_config(health.window, {
			relative = "editor",

			row = math.ceil((vim.o.lines - h) / 2),
			col = math.ceil((vim.o.columns - w) / 2),

			width = w,
			height = h
		});
	end

	vim.wo[health.window].cursorline = true;
	vim.wo[health.window].statuscolumn = " ";
	vim.wo[health.window].wrap = true;

	vim.api.nvim_buf_set_keymap(health.buffer, "n", "q", "", {
		callback = function ()
			pcall(vim.api.nvim_win_close, health.window, true);
		end
	});
end

--- Creates a new entry inside the trace-view buffer.
---@param l integer
local function create_entry(l)
	if not health.log[l] then
		return;
	end

	local highlights = {};
	local text = "";

	for _, entry in ipairs(health.log[l].notification or {}) do
		local before = #text;
		text = text .. entry[1];

		if entry[2] then
			table.insert(highlights, { before, #text, entry[2] });
		end
	end

	vim.api.nvim_buf_set_lines(health.buffer, -1, -1, false, { text });
	local lnum = vim.api.nvim_buf_line_count(health.buffer) - 1;

	for _, hl in ipairs(highlights) do
		vim.api.nvim_buf_set_extmark(health.buffer, health.ns, lnum, hl[1], {
			end_col = hl[2],
			hl_group = hl[3]
		});
	end
end

--- Opens trace-view window.
health.trace_open = function (from, to)
	trace_view_setup();
	vim.api.nvim_win_set_config(health.window, {
		border = {
			---@diagnostic disable: assign-type-mismatch
			{ "╭", "MarkviewPalette7Fg" },
			{ "─", "MarkviewPalette7Fg" },
			{ "╮", "MarkviewPalette7Fg" },
			{ "│", "MarkviewPalette7Fg" },
			{ "╯", "MarkviewPalette7Fg" },
			{ "─", "MarkviewPalette7Fg" },
			{ "╰", "MarkviewPalette7Fg" },
			{ "│", "MarkviewPalette7Fg" },
			---@diagnostic enable: assign-type-mismatch
		},

		title = {
			(type(from) == "number" and type(to) == "number") and {
				string.format("  Markview: Traceback(%s-%s) ", from, to), "MarkviewPalette7"
			} or {
				"  Markview: Traceback ", "MarkviewPalette7"
			}
		},
		title_pos = "right",

		footer = {
			{ " " },
			{ "[q]", "MarkviewPalette5" },
			{ "uit, ", "Comment" },
			{ "[r]", "MarkviewPalette5" },
			{ "eload, ", "Comment" },
			{ "[E]", "MarkviewPalette5" },
			{ "xport ", "Comment" },
		},
		footer_pos = "right",
	});

	vim.bo[health.buffer].modifiable = true;
	vim.api.nvim_buf_set_lines(health.buffer, 0, -1, false, {});

	local logs = health.log;

	if type(from) == "number" and type(to) == "number" then
		logs = vim.list_slice(health.log, from - 1, to - 1);
	end

	for l, log in ipairs(logs) do
		if log.kind ~= "trace" then
			goto continue
		end

		create_entry(l);

		::continue::
	end

	vim.api.nvim_buf_set_lines(health.buffer, 0, 1, false, {});
	vim.bo[health.buffer].modifiable = false;

	vim.api.nvim_buf_set_keymap(health.buffer, "n", "r", "", {
		callback = function ()
			vim.bo[health.buffer].modifiable = true;
			vim.api.nvim_buf_set_lines(health.buffer, 0, -1, false, {});

			for l, log in ipairs(health.log) do
				if log.kind ~= "trace" then
					goto continue
				end

				create_entry(l);

				::continue::
			end

			vim.api.nvim_buf_set_lines(health.buffer, 0, 1, false, {});
			vim.bo[health.buffer].modifiable = false;
		end
	});
	vim.api.nvim_buf_set_keymap(health.buffer, "n", "E", "<CMD>Markview traceExport<CR>", {
		callback = function ()
			health.notify("msg", {
				message = {
					{ "Exported logs to " },
					{ " trace.txt ", "DiagnosticVirtualTextHint" },
					{ "."}
				}
			});
			vim.cmd("Markview traceExport");
		end
	});
end

--- Holds icons for different filetypes.
---@type { [string]: string }
health.supported_languages = {
	["html"] = " ",
	["latex"] = " ",
	["markdown"] = "󰍔 ",
	["markdown_inline"] = "󰍔 ",
	["typst"] = " ",
	["yaml"] = "󰬠 "
}

--- Health check function.
health.check = function ()
	local symbols = require("markview.symbols");
	local utils = require("markview.utils");

	local ver = vim.version();

	------------------------------------------------------------------------------------------ 

	vim.health.start("💻 Neovim:")

	if vim.fn.has("nvim-0.10.1") == 1 then
		vim.health.ok(
			"Version: " .. string.format( "`%d.%d.%d`", ver.major, ver.minor, ver.patch )
		);
	elseif ver.major == 0 and ver.minor == 10 and ver.patch == 0 then
		vim.health.warn(
			"Version(may experience bugs): " .. string.format( "`%d.%d.%d`", ver.major, ver.minor, ver.patch )
		);
	else
		vim.health.error(
			"Version(unsupported): " .. string.format( "`%d.%d.%d`", ver.major, ver.minor, ver.patch ) .. " <= 0.10.1"
		);
	end

	------------------------------------------------------------------------------------------ 

	vim.health.start("💡 Parsers:")

	if pcall(require, "nvim-treesitter") then
		vim.health.ok("`nvim-treesitter/nvim-treesitter` found.");
	else
		vim.health.warn("`nvim-treesitter/nvim-treesitter` wasn't found.");
	end

	for parser, icon in pairs(health.supported_languages) do
		if utils.parser_installed(parser) then
			vim.health.ok("`" .. icon .. parser .. "`" .. " parser was found.");
		else
			vim.health.warn("`" .. icon .. parser .. "`" .. " parser wasn't found.");
		end
	end

	---------------------------------------------------------------------------------------- 

	vim.health.start("✨ Icon providers:");

	if pcall(require, "nvim-web-devicons") then
		vim.health.ok("`nvim-tree/nvim-web-devicons` found.");
	else
		vim.health.info("`nvim-tree/nvim-web-devicons` not found.");
	end

	if pcall(require, "mini.icons") then
		vim.health.ok("`echasnovski/mini.icons` found.");
	else
		vim.health.info("`echasnovski/mini.icons` not found.");
	end

	------------------------------------------------------------------------------------------ 

	vim.health.start("🚧 Configuration:");
	local errors = false;

	for _, entry in ipairs(health.log) do
		if entry.kind == "trace" or entry.ignore == true then
			goto continue;
		end

		errors = true;

		if entry.kind == "deprecation" then
			local text = string.format("`%s` is deprecated!", entry.name);

			if entry.alternative then
				text = text .. string.format(" Use `%s` instead.", entry.alternative);
			end

			vim.health.warn(text);

			if entry.tip then
				vim.health.info(string.format("Tip: %s", entry.tip));
			end
		elseif entry.kind == "type_error" then
			vim.health.warn(string.format("%s expects `%s`, not `%s`.", entry.option, entry.requires, entry.received));
		elseif entry.kind == "hl" then
			vim.health.warn(string.format("Failed to set highlight: `%s`. Error: %s.", entry.group, entry.message));
		end

	    ::continue::
	end


	if health.fixed_config then
		vim.health.info("A patched version of your config is available below:\n" .. vim.inspect(health.fixed_config));
	elseif errors == false then
		vim.health.ok("No errors found!")
	end

	------------------------------------------------------------------------------------------ 

	vim.health.start("💬 Symbols:")
	vim.health.info("📖 If any of the symbols aren't showing up then your font doesn't support it! You may want to `update your font`!");

	vim.health.start("📐 LaTeX math symbols:");

	for _ = 1, 5 do
		local keys = vim.tbl_keys(symbols.entries);
		local key  = keys[math.floor(math.random() * #keys)];

		vim.health.info( string.format("%-40s", "`" .. key .. "`" ) .. symbols.entries[key])
	end

	vim.health.start("📐 Typst math symbols:");

	for _ = 1, 5 do
		local keys = vim.tbl_keys(symbols.typst_entries);
		local key  = keys[math.floor(math.random() * #keys)];

		vim.health.info( string.format("%-40s", "`" .. key .. "`" ) .. symbols.typst_entries[key])
	end

	vim.health.start("🔤 Text styles:");

	vim.health.info("`Subscript`         " .. symbols.tostring("subscripts", "ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz 0123456789 + () ="));
	vim.health.info("`Superscript`       " .. symbols.tostring("superscripts", "ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz 0123456789 + () ="));

	vim.health.start("🔢 Math fonts:");

	for font, _ in pairs(symbols.fonts) do
		vim.health.info(string.format("%-20s" , "`" .. font .. "`") .. symbols.tostring(font, "ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz 0123456789"));
	end
end

return health;
--- vim:foldmethod=indent:
