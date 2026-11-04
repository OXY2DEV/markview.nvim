-- Keep every source row addressable in a single-window preview. Paint the
-- row's native wrapped screen lines, then add only its remaining visual rows.
-- Concealing a whole table removes every cursor anchor and traps wheel-up.
local M = { ns = vim.api.nvim_create_namespace("markview/table-rows") };
local state = require("markview.renderers.markdown.table_state");

-- Only these renderers own inline markup in Markdown cells. Never clear
-- alignment padding or third-party namespaces just because of their name.
local cell_namespaces = { "markview/markdown", "markview/inline", "markview/html", "markview/latex" };

function M.finish(buffer)
	local plans = state.get(buffer);
	if #plans == 0 then return; end
	local win = require("markview.utils").buf_getwin(buffer);
	if not win or not vim.api.nvim_win_is_valid(win) then return; end
	local ns = M.ns;
	local namespaces = vim.api.nvim_get_namespaces();
	vim.api.nvim_win_call(win, function()
		for _, plan in ipairs(plans) do
			-- Inline markup has already been converted into the table's cells.
			-- Remove its separate decorations before measuring source wrapping.
			vim.api.nvim_buf_clear_namespace(buffer, ns, plan.first, plan.last);
			for _, name in ipairs(cell_namespaces) do
				local namespace = namespaces[name];
				if namespace then
					vim.api.nvim_buf_clear_namespace(buffer, namespace, plan.first, plan.last);
				end
			end
			for i, lines in ipairs(plan.rows) do
				local row = plan.first + i - 1;
				local text = vim.api.nvim_buf_get_lines(buffer, row, row + 1, false)[1];
				vim.api.nvim_buf_set_extmark(buffer, ns, row, 0, {
					end_row = row, end_col = #text, conceal = "", priority = 10000,
					undo_restore = false, invalidate = true,
				});
				local measured = vim.api.nvim_win_text_height(win, {
					start_row = row, start_vcol = 0, end_row = row,
				});
				local native = math.max(1, measured.all - measured.fill);
				local chars = vim.fn.strchars(text, 1);
				local previous = 0;
				for screen = 1, native do
					local col = 0;
					if screen > 1 then
						local left, right = previous + 1, chars - 1;
						while left < right do
							local mid = math.floor((left + right) / 2);
							local byte = vim.fn.byteidx(text, mid);
							local vcol = vim.fn.virtcol({ row + 1, byte + 1 }, true)[1];
							local h = vim.api.nvim_win_text_height(win, {
								start_row = row, start_vcol = 0, end_row = row, end_vcol = vcol,
							}).all;
							if h >= screen then right = mid; else left = mid + 1; end
						end
						-- A concealed wide character at the wrap edge can emit
						-- overlay text before Neovim advances to the next screen
						-- row. Anchor just after that character (or at EOL).
						previous, col = left, vim.fn.byteidx(text, math.min(chars, left + 1));
					end
					vim.api.nvim_buf_set_extmark(buffer, ns, row, math.max(0, col), {
						virt_text = lines[screen] or plan.blank,
						virt_text_win_col = 0, priority = 10001, hl_mode = "replace",
						undo_restore = false, invalidate = true,
					});
				end
				if #lines > native then
					vim.api.nvim_buf_set_extmark(buffer, ns, row, 0, {
						virt_lines = vim.list_slice(lines, native + 1),
						undo_restore = false, invalidate = true,
					});
				end
			end
		end
	end);
end

function M.clear(buffer, first, last)
	state.clear(buffer, first, last);
	vim.api.nvim_buf_clear_namespace(buffer, M.ns, first or 0, last or -1);
end

return M;
