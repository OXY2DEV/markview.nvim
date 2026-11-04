"""Integration/UI check: python3 test/splitview_align.py (requires pynvim)."""
from pathlib import Path

import pynvim

root = Path(__file__).resolve().parents[1]
nvim = pynvim.attach("child", argv=["nvim", "--embed", "-u", "NONE", "-n"])
try:
    nvim.ui_attach(160, 100, rgb=True)
    nvim.exec_lua("vim.opt.rtp:append(...); vim.wo.wrap=true; vim.wo.linebreak=true", str(root))
    table = (root / "test/wrapped_tables.md").read_text().splitlines()
    source = ["START", ""] + table + ["", "AFTER_TABLE", "", "```lua", "print('hello')", "```", "", "AFTER_CODE", ""]
    source += ["> " + "인용문 words " * 20, "", "AFTER_QUOTE", "", "paragraph words " * 25, "", "AFTER_PARAGRAPH", ""]
    source += table + ["", "AFTER_SECOND_TABLE", ""] + [f"tail {i}" for i in range(40)]
    nvim.current.buffer[:] = source
    nvim.command("setfiletype markdown")
    nvim.exec_lua("require('markview.actions').splitOpen()")
    windows = nvim.exec_lua("local s=require('markview.state'); return {vim.fn.win_findbuf(s.get_splitview_source())[1],s.get_splitview_window({},false)}")
    buffers = nvim.exec_lua("local s=require('markview.state'); return {s.get_splitview_source(),s.get_splitview_buffer()}")

    def check_boundaries():
        nvim.command("redraw!")
        for index, line in enumerate(source):
            if line.startswith("AFTER_"):
                rows = nvim.exec_lua("local wins,row=...; local map=require('markview.splitview_align').layout.mapping; return {vim.fn.screenpos(wins[1],row,1).row,vim.fn.screenpos(wins[2],map[row-1]+1,1).row}", windows, index + 1)
                assert rows[0] > 0 and rows[0] == rows[1], (line, rows)
        assert nvim.api.buf_get_lines(buffers[0], 0, -1, False) == source

    check_boundaries()
    assert nvim.exec_lua("local b=...; return #vim.api.nvim_buf_get_extmarks(b,require('markview.splitview_align').ns,0,-1,{})", buffers[0]) > 0
    # Unequal windows can make the source taller; padding must work both ways.
    nvim.api.win_set_width(windows[0], 45)
    nvim.exec_lua("require('markview.actions').splitview_render()")
    check_boundaries()
    assert nvim.exec_lua("local b=...; return #vim.api.nvim_buf_get_extmarks(b,require('markview.splitview_align').ns,0,-1,{})", buffers[1]) > 0

    # Scroll from inside a concealed table: the next object must still align.
    nvim.exec_lua("local w=...; vim.api.nvim_win_set_cursor(w,{6,0}); vim.api.nvim_win_call(w,function() vim.fn.winrestview({topline=5,topfill=0,skipcol=0}) end); require('markview.actions').splitview_cursor()", windows[0])
    nvim.command("redraw!")
    rows = nvim.exec_lua("local w=...; local map=require('markview.splitview_align').layout.mapping; return {vim.fn.screenpos(w[1],9,1).row,vim.fn.screenpos(w[2],map[8]+1,1).row}", windows)
    assert rows[0] > 0 and rows[0] == rows[1], rows

    # Edit the source and redraw repeatedly: no accumulated filler.
    nvim.api.buf_set_lines(buffers[0], 0, 0, False, ["new line"])
    source.insert(0, "new line")
    nvim.exec_lua("require('markview.actions').splitview_render()")
    nvim.exec_lua("require('markview.actions').splitview_render()")
    nvim.api.win_set_cursor(windows[0], (1, 0))
    nvim.exec_lua("require('markview.actions').splitview_cursor()")
    check_boundaries()

    nvim.exec_lua("require('markview.actions').splitClose()")
    assert nvim.exec_lua("local b=...; return #vim.api.nvim_buf_get_extmarks(b,require('markview.splitview_align').ns,0,-1,{})", buffers[0]) == 0
    assert nvim.api.buf_get_lines(buffers[0], 0, -1, False) == source

    # EOF tables have real, scrollable preview rows without an extra sentinel.
    nvim.api.buf_set_lines(buffers[0], 0, -1, False, table)
    nvim.exec_lua("require('markview.actions').splitOpen()")
    nvim.exec_lua("require('markview.actions').splitview_render()")
    nvim.command("redraw!")
    assert nvim.api.buf_get_lines(buffers[0], 0, -1, False) == table
    assert nvim.exec_lua("return vim.api.nvim_buf_line_count(require('markview.state').get_splitview_buffer())") > len(table)
    assert nvim.exec_lua("local s=require('markview.state'); return vim.api.nvim_buf_get_lines(s.get_splitview_buffer(),-2,-1,false)[1]:sub(1,3)") == '╰'
    nvim.exec_lua("require('markview.actions').splitClose()")
    print("splitview alignment: passed (objects, unequal widths, scrolling, edits, cleanup, EOF)")
finally:
    try:
        nvim.command("qa!")
    except (EOFError, OSError):
        pass
    nvim.close()
