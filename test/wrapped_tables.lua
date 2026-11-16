-- Run from the repository: nvim --headless -u NONE -l test/wrapped_tables.lua
vim.opt.rtp:append(vim.fn.getcwd());
local parser = require("markview.parsers.markdown");
local renderer = require("markview.renderers.markdown");
local wrapper = require("markview.renderers.markdown.table_wrap");
local config = require("markview.spec").get({ "markdown", "tables" });

local function parse(lines)
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines);
	parser.content = {};
	parser.sorted = {};
	parser.table(nil, nil, lines, { row_start = 0, row_end = #lines, col_start = 0, col_end = 0 });
	return parser.content[1];
end

local function preview()
 local result = {};
 for _, plan in ipairs(require("markview.renderers.markdown.table_state").get(0)) do
  for _, chunks in ipairs(plan.lines) do
   local line = "";
   for _, chunk in ipairs(chunks) do line = line .. chunk[1]; end
   table.insert(result, line);
  end
 end
 return result;
end

local original = vim.fn.readfile("test/wrapped_tables.md");
for _, columns in ipairs({ 40, 80, 120 }) do
	for _, wrap in ipairs({ false, true }) do
		renderer.clear(0);
		vim.o.columns = columns;
		vim.cmd("redraw");
		vim.wo.wrap = wrap;
		local item = parse(original);
		renderer.table(0, item);
		local lines = preview();
		assert(#lines > #original, "Wide table must span additional screen rows");
		local expected_width = vim.fn.strdisplaywidth(lines[1]);
		for _, line in ipairs(lines) do
			assert(vim.fn.strdisplaywidth(line) == expected_width, "Borders must align");
			assert(expected_width < vim.api.nvim_win_get_width(0), "Preview must fit the window");
		end
		local expected, actual = { "", "", "" }, { "", "", "" };
		for _, row in ipairs(vim.list_extend({ item.header }, item.rows)) do
			local c = 0;
			for _, cell in ipairs(row) do
				if cell.class == "column" then
					c = c + 1;
					expected[c] = expected[c] .. cell.text:gsub("%s", "");
				end
			end
		end
		for _, plan in ipairs(require("markview.renderers.markdown.table_state").get(0)) do
			for _, chunks in ipairs(plan.lines) do
				if chunks[2][1] == "│" then
					for c = 1, 3 do actual[c] = actual[c] .. chunks[c * 2 + 1][1]:gsub("%s", ""); end
				end
			end
		end
		assert(vim.deep_equal(expected, actual), "Cell text was lost, reordered, or moved between columns");
		assert(vim.deep_equal(original, vim.api.nvim_buf_get_lines(0, 0, -1, false)), "Source changed");
		renderer.clear(0, 0, #original, true);
		assert(#preview() == 0, "Hybrid clear must release table layouts");
	end
end

renderer.clear(0);
local short = parse({ "| A | B |", "|---|---|", "| x | y |" });
assert(not wrapper.layout(0, short, config, { 3, 3 }), "Short table should use original renderer");
local disabled = vim.deepcopy(config);
disabled.wrap = false;
assert(not wrapper.layout(0, short, disabled, { 500, 500 }), "wrap=false must opt out");

local unicode = parse({ "| A | B |", "|:---:|---:|", "| " .. string.rep("한😀é", 30) .. " | 끝 |" });
vim.o.columns = 40;
vim.cmd("redraw");
renderer.table(0, unicode);
for _, line in ipairs(preview()) do
	assert(vim.fn.strdisplaywidth(line) < vim.api.nvim_win_get_width(0), "Unbroken Unicode text must fit");
end
renderer.clear(0);
print("wrapped tables: passed (CJK, Unicode, widths, wrap/nowrap, source, hybrid clear, opt-out)");
