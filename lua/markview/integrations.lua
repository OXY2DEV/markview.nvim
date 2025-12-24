local integrations = {};

integrations.register_blink_source = function ()
	---|fS

	local blink = package.loaded["blink.cmp"];

	if vim.g.markview_blink_loaded == true or blink == nil then
		return;
	end

	local add_provider = blink.add_source_provider or blink.add_provider;

	local blink_config = require("blink.cmp.config");
	local filetypes = require("markview.spec").get({ "preview", "filetypes" }, {
		fallback = {},
		ignore_enable = true
	});

	--- Dynamic filetype.
	---@param filetype string
	---@param config table | fun(): table See |blink-cmp-config-sources|.
	local function handle_filetype(filetype, config)
		---|fS

		if type(config) == "table" and vim.islist(config) then
			---@cast config table
			if vim.list_contains(config, "markview") then
				-- `markview` is already used as a source.
				return;
			end

			-- If the config sources is a list we extend the list of sources.
			blink_config.sources.per_filetype[filetype] = vim.list_extend(config, { "markview" });
		else
			---@cast config fun(): table

			-- If it's a function we wrap it in
			-- *another* function.
			blink_config.sources.per_filetype[filetype] = function (...)
				local can_exec, result = pcall(config, ...);

				if can_exec and vim.islist(result) and not vim.list_contains(result, "markview") then
					return vim.list_extend(result, { "markview" });
				elseif can_exec == false then
					-- Emit errors in the original function.
					error(result);
				else
					return { "markview" };
				end
			end
		end

		---|fE
	end

	add_provider("markview", {
		name = "markview",
		module = "blink-markview",

		should_show_items = function ()
			return vim.tbl_contains(filetypes, vim.o.filetype);
		end
	});

	for _, filetype in ipairs(filetypes) do
		if blink_config then
			-- Use `filetype` sources if available, see #459
			handle_filetype(filetype, blink_config.sources.per_filetype[filetype] or blink_config.sources.default)
		else
			pcall(blink.add_filetype_source, filetype, "markview");
		end
	end

	vim.g.markview_blink_loaded = true;
	require("markview.health").print({
		message = {
			{ "Registered integration: ", "Comment" },
			{ " blink.cmp ", "DiagnosticVirtualLinesHint" }
		}
	});

	---|fE
end

integrations.register_cmp_source = function ()
	---|fS

	local cmp = package.loaded["cmp"];

	if vim.g.markview_cmp_loaded == true or cmp == nil then
		return;
	end

	cmp.register_source("cmp-markview", require("cmp-markview"));

	local sources = cmp.get_config().sources or {};
	local filetypes = require("markview.spec").get({ "preview", "filetypes" }, {
		fallback = {},
		ignore_enable = true
	});

    ---|fS "feat: Modify nvim-cmp sources"
	cmp.setup.filetype(filetypes, {
		sources = vim.list_extend(sources, {
			{
				name = "cmp-markview",
				keyword_length = 1,
				options = {}
			}
		})
	});
    ---|fE

	vim.g.markview_cmp_loaded = true;
	require("markview.health").print({
		message = {
			{ "Registered integration: ", "Comment" },
			{ " nvim-cmp ", "DiagnosticVirtualLinesHint" }
		}
	});

	---|fE
end

integrations.setup = function ()
	integrations.register_blink_source();
	integrations.register_cmp_source();
end

return integrations;
