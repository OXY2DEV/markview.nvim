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
	callback = function (event)
		markview.commands.attach(event.buf)
	end
});

--- Autocmd for detaching from a buffer
vim.api.nvim_create_autocmd("User", {
	pattern = "MarkviewDetach",
	callback = function (event)
		markview.commands.detach(event.buf)
	end
});

--- Autocmd for attaching to a buffer
vim.api.nvim_create_autocmd({ "BufAdd", "BufEnter" }, {
	group = markview.augroup,
	callback = function (event)
		local spec = require("markview.spec");
		local buffer = event.buf or vim.api.nvim_get_current_buf();
		local bt, ft = vim.bo[buffer].buftype, vim.bo[buffer].filetype;

		if
			spec.get({ "enable" }) ~= false and
			vim.list_contains(
				spec.get({ "preview", "filetypes" }) or {},
				ft
			) and
			not vim.list_contains(
				spec.get({ "preview", "buf_ignore" }) or {},
				bt
			)
		then
			vim.uv.new_timer():start(0, 0, vim.schedule_wrap(function ()
				markview.commands.attach(event.buf);
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
			local spec = require("markview.spec");

			local preview_modes = spec.get({ "preview", "modes" });
			local mode = vim.api.nvim_get_mode().mode;

			local call = spec.get({ "preview", "callbacks", "on_mode_change" });

			if markview.state.enable == false then
				return;
			elseif not preview_modes then
				return;
			end

			for buf, state in ipairs(markview.state.buffer_states) do
				---+${func, Buffer redrawing}
				renderer.clear(buf);
				if state == false then goto continue; end

				if vim.list_contains(preview_modes, mode) then
					markview.draw(buf);
				else
					renderer.clear(buf, {}, 0, -1);
				end

				if
					call and
					pcall(call, buf, vim.fn.win_findbuf(buf), mode)
				then
					call(
						buf,
						vim.fn.win_findbuf(buf),
						mode
					)
				end

				::continue::
				---_
			end
		end))
	end
});

vim.api.nvim_create_user_command(
	"Markview",
	require("markview").exec,
	{
		desc = "Main command for `markview.nvim`. Toggles preview by default.",
		nargs = "*", bang = true,
		complete = markview.completion
	}
);







vim.api.nvim_create_autocmd({ "Colorscheme" }, {
	group = markview.augroup,
	callback = function ()
		require("markview.highlights").create(require("markview.spec").get({ "highlight_groups" }));
	end
});
vim.api.nvim_set_keymap("n", "gx", "", {
	callback = require("markview.links").open
})
vim.api.nvim_set_keymap("n", "M", "", {
	callback = require("markview.extras.lsp_hover").hover
})


