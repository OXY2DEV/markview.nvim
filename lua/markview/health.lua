local health = {};

health.depth = 0;

---@type table[]
health.history = {};
health.log = {};

--- Print log messages.
---@param msg table
health.print = function (msg)
	msg.depth = health.depth;

	if msg.nest then
		health.depth = health.depth + 1;
	elseif msg.back then
		health.depth = health.depth - 1;
	end

	if msg.kind == "skip" then
		return;
	end

	msg.kind = msg.kind or "log";
	msg.show = msg.show == true;

	table.insert(health.history, msg);

	if msg.kind == "hl" then
		---|fS "feat: Show highlight group errors"

		local text = vim.split(
			vim.inspect(msg.value) or "",
			"\n",
			{ trimempty = true }
		);
		local lines = { { "\n" } };

		for l, line in ipairs(text) do
			lines = vim.list_extend(lines, {
				{ string.format("%" .. #text .. "d ", l), "LineNr" },
				{ line, "@comment" },

				{ "\n" },
			});
		end

		vim.api.nvim_echo(vim.list_extend({
			{ " 󰏘 markview.nvim ", "DiagnosticVirtualTextError" },
			{ ": ", "@comment" },
			{ "Failed to set ", "@comment" },
			{ string.format(" %s ", msg.name ), "DiagnosticVirtualTextHint" },
			{ ",", "@comment" }
		}, lines), true, {});

		---|fE
	elseif msg.show then
		vim.api.nvim_echo(
			type(msg.message) == "string" and { { msg.message, "@comment" } } or msg.message,
			true,
			{}
		)
	end
end

health.buffer = nil;
health.window = nil;

health.ns = vim.api.nvim_create_namespace("markview.health");

health.view_setup = function ()
	if not health.buffer or vim.api.nvim_buf_is_valid(health.buffer) == false then
		health.buffer = vim.api.nvim_create_buf(false, true);

		vim.api.nvim_create_autocmd({ "BufLeave" }, {
			buffer = health.buffer,
			callback = function ()
				pcall(vim.api.nvim_win_close, health.window, true);
			end
		});
	end

	if not health.window or vim.api.nvim_win_is_valid(health.window) == false then
		health.window = vim.api.nvim_open_win(health.buffer, true, {
			height = 10,
			split = "below"
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

health.virt_text = function (depth, text)
	local indent = string.rep("  ", depth);

	if type(text) == "string" then
		return indent .. text, {
			{
				from = 0, to = #(indent .. text),
				group = "@comment"
			}
		};
	end

	local hl = {};
	local col = #indent;

	local buf_text = indent;

	for _, piece in ipairs(text) do
		buf_text = buf_text .. (piece[1] or "");

		if piece[2] then
			table.insert(hl, {
				from = col, to = col + #(piece[1] or ""),
				group = piece[2]
			});
		end

		col = col + #(piece[1] or "");
	end

	return buf_text, hl;
end

health.view = function ()
	health.view_setup();

	local lines = {};
	local hls = {};

	for _, entry in ipairs(health.history) do
		local txt, hl = health.virt_text(entry.depth, entry.message);

		table.insert(lines, txt);
		table.insert(hls, hl);
	end

	vim.api.nvim_buf_set_lines(health.buffer, 0, -1, false, lines);

	for e, entry in ipairs(health.history) do
		for _, hl in ipairs(hls[e]) do
			vim.api.nvim_buf_set_extmark(health.buffer, health.ns, e - 1, hl.from, {
				end_col = hl.to,
				hl_group = hl.group
			});
		end

		local virt_text = {};

		if entry.from then
			table.insert(virt_text, { " ", "Constant" })
			table.insert(virt_text, { entry.from, "Constant" })
		end

		if entry.fn then
			if #virt_text > 0 then
				table.insert(virt_text, { " => " })
			end

			table.insert(virt_text, { "󰡱 ", "Function" })
			table.insert(virt_text, { entry.fn, "Function" })
		end

		vim.api.nvim_buf_set_extmark(health.buffer, health.ns, e - 1, 0, {
			virt_text_pos = "right_align",
			virt_text = virt_text
		});
	end
end

health.export = function ()
	local function center (text, w)
		local B = math.floor((w - vim.fn.strdisplaywidth(text)) / 2);
		local A = math.ceil((w - vim.fn.strdisplaywidth(text)) / 2);

		return string.rep(" ", B) .. text .. string.rep(" ", A);
	end

	local context = {};
	local WC = 0;

	for _, item in ipairs(health.history) do
		local text = (item.from and (item.from .. " => ") or "") .. (item.fn and item.fn or "fn()");
		table.insert(context, text)

		WC = math.max(WC, vim.fn.strdisplaywidth(text));
	end

	local lines = {};

	for i, item in ipairs(health.history) do
		local text = health.virt_text(item.depth, item.message);

		table.insert(
			lines,
			string.upper(item.kind) ..
			" | " ..
			center(context[i], WC) ..
			" | " ..
			text
		);
	end

	local trace_file = io.open("markview_log.txt", "w");

	if not trace_file then
		return;
	end

	trace_file:write(table.concat(lines, "\n"));
	trace_file:close();

	vim.print("Exported logs to `markview_log.txt`!")
end

------------------------------------------------------------------------------

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

	vim.health.start("📂 Runtime path:")

	if _G.__mkv_has_rtp_error == true then
		vim.health.error(
			"Runtime: `nvim-treesitter` is loaded before `markview.nvim`! It is recommened to change their load order!"
		);

		vim.health.info(
			"NOTE: This can lead to incorrect `tree-sitter` query files being loaded, syntax highlighting may look odd!"
		);
	else
		vim.health.ok(
			"Runtime: `nvim-treesitter` isn't loaded before `markview.nvim`."
		);

		vim.health.info(
			"NOTE: If you have changed the directory name of `nvim-treesitter` or `markview.nvim`, the result will be inaccurate!"
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
