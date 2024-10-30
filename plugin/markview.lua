local markview = require("markview");

--- Patch for the broken (fenced_code_block) concealment
vim.treesitter.query.add_directive("conceal-patch!", function (match, _, bufnr, predicate, metadata)
	local id = predicate[2];
	local node = match[id];

	local r_s, c_s, r_e, c_e = node:range();
	local line = vim.api.nvim_buf_get_lines(bufnr, r_s, r_s + 1, true)[1];

	if not line then
		return;
	elseif not metadata[id] then
		metadata[id] = { range = {} };
	end

	line = line:sub(c_s + 1, #line);
	local spaces = line:match("^(%s*)%S"):len();

	metadata[id].range[1] = r_s;
	metadata[id].range[2] = c_s + spaces;
	metadata[id].range[3] = r_e;
	metadata[id].range[4] = c_e;

	metadata[id].conceal = "";
end)

--- Autocmd for attaching to a buffer
vim.api.nvim_create_autocmd("User", {
	pattern = "MarkviewAttach",
	callback = markview.attach
});

--- Autocmd for detaching from a buffer
vim.api.nvim_create_autocmd("User", {
	pattern = "MarkviewDetach",
	callback = markview.detach
});

--- Autocmd for attaching to a buffer
vim.api.nvim_create_autocmd({ "BufAdd", "BufEnter" }, {
	group = markview.augroup,
	callback = function (event)
		local spec = require("markview.spec");
		local buffer = event.buf or vim.api.nvim_get_current_buf();
		local bt, ft = vim.bo[buffer].buftype, vim.bo[buffer].filetype;

		if spec.get("enable") ~= false and
			vim.list_contains(markview.get_config("filetypes", {}), ft) and
			not vim.list_contains(markview.get_config("buf_ignore", {}), bt)
		then
			vim.uv.new_timer():start(5, 0, vim.schedule_wrap(function ()
				markview.attach(event);
			end));
		end
	end
});

local md_debounce = vim.uv.new_timer();

vim.api.nvim_create_autocmd({ "ModeChanged" }, {
	group = markview.group,
	callback = function ()
		local renderer = require("markview.renderer");

		md_debounce:stop();
		md_debounce:start(5, 0, vim.schedule_wrap(function ()
			local mode = vim.api.nvim_get_mode().mode;
			local func = require("markview.spec").get("preview", "callbacks", "on_mode_change");


			if markview.state.enable == false or
				not vim.list_contains(markview.get_config("modes", { "n" }), mode)
			then
				for buf, _ in ipairs(markview.cache) do
					renderer.clear(buf);

					if
						func and
						pcall(func, buf, vim.fn.win_findbuf(buf), mode)
					then
						func(
							buf,
							vim.fn.win_findbuf(buf),
							mode
						)
					end
				end
			elseif markview.state.enable == true and
				vim.list_contains(markview.get_config("modes", { "n" }), mode)
			then
				for buf, _ in ipairs(markview.cache) do
					if markview.state.buf_states[buf] == false then
						renderer.clear(buf);
						goto continue;
					end

					markview.draw(buf);
				    ::continue::

					if
						func and
						pcall(func, buf, vim.fn.win_findbuf(buf), mode)
					then
						func(
							buf,
							vim.fn.win_findbuf(buf),
							mode
						)
					end
				end
			end
		end))
	end
});

vim.api.nvim_create_user_command("Markview", function (cmd)
	local renderer = require("markview.renderer");
	local spec = require("markview.spec");

	local fargs = cmd.fargs;
	local commands = {
		"attach", "detach",
		"toggle", "enable", "disable",
		"splitToggle"
	};

	if #fargs == 0 then
		if markview.state.enable == false then
			markview.state.enable = true;

			for buf, _ in ipairs(markview.cache) do
				markview.draw(buf)

				if
					spec.get("preview", "callbacks", "on_attach") and
					pcall(spec.get("preview", "callbacks", "on_attach") --[[ @as function ]], buf, vim.fn.win_findbuf(buf))
				then
					spec.get("preview", "callbacks", "on_attach")(buf, vim.fn.win_findbuf(buf));
				end
			end
		else
			markview.state.enable = false;

			for buf, _ in ipairs(markview.cache) do
				renderer.clear(buf);

				if
					spec.get("preview", "callbacks", "on_detach") and
					pcall(spec.get("preview", "callbacks", "on_detach") --[[ @as function ]], buf, vim.fn.win_findbuf(buf))
				then
					spec.get("preview", "callbacks", "on_detach")(buf, vim.fn.win_findbuf(buf));
				end
			end
		end
	elseif vim.list_contains(commands, fargs[1]) then
		local buf = tonumber(fargs[2]) or vim.api.nvim_get_current_buf();

		if fargs[1] == "attach" then
			markview.attach({ buf = tonumber(fargs[2]) or vim.api.nvim_get_current_buf() })
		elseif fargs[1] == "detach" then
			markview.detach({ buf = tonumber(fargs[2]) or vim.api.nvim_get_current_buf() })
		elseif fargs[1] == "toggle" then
			if markview.state.buf_states[buf] == true then
				markview.state.buf_states[buf] = false;
			else
				markview.state.buf_states[buf] = true;
			end
		elseif fargs[1] == "splitToggle" or fargs[1] == "split" then
			if markview.state.split_source then
				local is_in_current_tab = vim.api.nvim_win_get_tabpage(markview.state.split_window) == vim.api.nvim_get_current_tabpage();

				markview.splitview_close();

				if is_in_current_tab == false then
					markview.splitview_open(buf);
				end
			else
				markview.splitview_open(buf);
			end
		end
	end
end, {
	desc = "Main command for `markview.nvim`. Toggles preview by default.",
	nargs = "*",
	complete = function (arg_lead, cmdline, cursor_pos)
		return { "A", "B" }
	end
})

