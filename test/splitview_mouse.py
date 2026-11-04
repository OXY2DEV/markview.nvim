"""Real wheel-event regression: python3 test/splitview_mouse.py (pynvim)."""
from pathlib import Path

import pynvim

root = Path(__file__).resolve().parents[1]
nvim = pynvim.attach("child", argv=["nvim", "--embed", "-u", "NONE", "-n"])
try:
    nvim.ui_attach(160, 28, rgb=True)
    nvim.exec_lua("""
        vim.opt.rtp:append(...)
        vim.o.mouse = 'a'; vim.o.scrolloff = 10
        vim.wo.wrap = true; vim.wo.linebreak = true
        require('markview').setup({preview={debounce=25,ignore_buftypes={}}})
        require('markview.autocmds').setup()
    """, str(root))
    source = ["Before", ""] + (root / "test/wrapped_tables.md").read_text().splitlines()
    source += ["", "AFTER TABLE", ""] + [f"tail {i}" for i in range(120)]
    nvim.current.buffer[:] = source
    nvim.command("setfiletype markdown")
    nvim.exec_lua("require('markview.actions').attach(vim.api.nvim_get_current_buf()); require('markview.actions').splitOpen(); vim.wait(100)")
    windows = nvim.exec_lua("local s=require('markview.state'); return {vim.fn.win_findbuf(s.get_splitview_source())[1],s.get_splitview_window({},false)}")
    source_buffer = nvim.api.win_get_buf(windows[0])

    def offset(win):
        return nvim.exec_lua("""
            local w=...
            local v=vim.api.nvim_win_call(w,vim.fn.winsaveview)
            return vim.api.nvim_win_text_height(w,{start_row=0,start_vcol=0,end_row=v.topline-1,end_vcol=0}).all-v.topfill
        """, win)

    def wheel(direction, col):
        nvim.api.input_mouse("wheel", direction, "", 0, 10, col)
        nvim.exec_lua("vim.wait(70)")

    # Move the preview cursor well away from the source cursor first.
    nvim.api.set_current_win(windows[1])
    for _ in range(6):
        before = offset(windows[1])
        wheel("down", 110)
        assert offset(windows[1]) > before, "Preview wheel was undone"

    # Wheel over an inactive source does not emit its usual CursorMoved event.
    # WinScrolled must update the preview cursor as well as its viewport.
    for _ in range(8):
        before = offset(windows[0])
        wheel("down", 20)
        assert offset(windows[0]) > before, "Source wheel made no progress"
        assert offset(windows[0]) == offset(windows[1]), "Preview viewport clamped to its stale cursor"
    for _ in range(4):
        before = offset(windows[0])
        wheel("up", 20)
        assert offset(windows[0]) < before, "Source wheel-up made no progress"
        assert offset(windows[0]) == offset(windows[1]), "Wheel-up lost alignment"
    assert nvim.api.get_current_win().handle == windows[1], "Synchronization changed focus"

    # Rebuilding filler must retain a viewport starting inside virtual blanks.
    nvim.api.set_current_win(windows[0])
    nvim.exec_lua("""
        local w=...
        vim.api.nvim_win_set_cursor(w,{15,0})
        vim.api.nvim_win_call(w,function() vim.fn.winrestview({topline=8,topfill=3,skipcol=0}) end)
        require('markview.actions').splitview_cursor()
    """, windows[0])
    nvim.command("redraw!")
    before = offset(windows[0])
    nvim.exec_lua("require('markview.actions').splitview_render(); vim.wait(100)")
    assert offset(windows[0]) == before, "Rerender discarded topfill"
    assert offset(windows[1]) == before, "Rerender broke synchronization"
    assert nvim.api.buf_get_lines(source_buffer, 0, -1, False) == source
    print("mouse scrolling: passed (real wheel up/down, inactive source, preview focus, filler redraw)")
finally:
    try:
        nvim.command("qa!")
    except (EOFError, OSError):
        pass
    nvim.close()
