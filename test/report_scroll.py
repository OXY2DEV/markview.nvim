"""python3 test/report_scroll.py /path/to/avm_roadcal_report_analyze.md

Exercise the supplied real document with wheel events, through every table in
both directions, then verify that ignored cursor events do not cancel edits.
Requires pynvim; never writes the document.
"""
from pathlib import Path
import sys

import pynvim

root = Path(__file__).resolve().parents[1]
document = Path(sys.argv[1]).resolve()
original = document.read_bytes()
source = original.decode().splitlines()

for columns, rows in ((160, 40), (120, 30)):
    n = pynvim.attach("child", argv=["nvim", "--embed", "-u", "NONE", "-n"])
    try:
        n.ui_attach(columns, rows, rgb=True)
        n.exec_lua("""
            vim.opt.rtp:append(...)
            vim.o.mouse='a'; vim.o.scrolloff=10
            vim.wo.wrap=true; vim.wo.linebreak=true
            require('markview').setup({preview={debounce=25,ignore_buftypes={}}})
            require('markview.autocmds').setup()
        """, str(root))
        n.current.buffer[:] = source
        n.command("setfiletype markdown")
        n.exec_lua("require('markview.actions').attach(vim.api.nvim_get_current_buf()); require('markview.actions').splitOpen(); vim.wait(100)")
        windows = n.exec_lua("local s=require('markview.state'); return {vim.fn.win_findbuf(s.get_splitview_source())[1],s.get_splitview_window({},false)}")
        buffers = [n.api.win_get_buf(w) for w in windows]
        assert n.api.buf_line_count(buffers[1]) > len(source), "Tables were not expanded"
        assert not n.exec_lua("return require('markview.state').buf_attached(...)", buffers[1])

        def offset(win):
            return n.exec_lua("""
                local w=...; local v=vim.api.nvim_win_call(w,vim.fn.winsaveview)
                local h=vim.api.nvim_win_text_height(w,{start_row=0,start_vcol=0,end_row=v.topline-1,end_vcol=0}).all-v.topfill
                if v.skipcol>0 then h=h+vim.api.nvim_win_text_height(w,{start_row=v.topline-1,start_vcol=0,end_row=v.topline-1,end_vcol=v.skipcol}).all end
                return h
            """, win)

        for driver in (0, 1):
            n.api.set_current_win(windows[driver])
            for w in windows:
                n.api.win_set_cursor(w, (1, 0))
                n.exec_lua("vim.api.nvim_win_call(...,function() vim.fn.winrestview({topline=1,topfill=0,skipcol=0}) end)", w)
            n.exec_lua("require('markview.actions').splitview_cursor(); vim.wait(50)")
            col = 20 if driver == 0 else columns - 20
            frames = set()
            for direction in ("down", "up"):
                for tick in range(600):
                    before = offset(windows[driver])
                    n.api.input_mouse("wheel", direction, "", 0, 15, col)
                    n.exec_lua("vim.wait(15)")
                    after = offset(windows[driver])
                    if after == before:
                        if direction == "down":
                            bottom = n.exec_lua("return vim.api.nvim_win_call(...,function() return vim.fn.line('w$') end)", windows[driver])
                            assert bottom >= n.api.buf_line_count(buffers[driver]) - 1, ("stalled before EOF", driver, tick, bottom)
                        else:
                            assert after == 0, ("stalled before BOF", driver, tick, after)
                        break
                    assert (after > before) == (direction == "down"), (direction, before, after)
                    if driver == 0:
                        # Neovim may round a wrapped list/paragraph boundary by
                        # one screen row; object heights are checked separately.
                        assert abs(after - offset(windows[1])) <= 1, ("preview clamped", tick, after, offset(windows[1]))
                    if tick % 5 == 0:
                        frame = n.exec_lua("""
                            local col=...; local t={}
                            for r=1,10 do local s=''; for c=col,col+30 do s=s..vim.fn.screenstring(r,c) end; t[#t+1]=s end
                            return table.concat(t,'|')
                        """, columns // 2 + 2)
                        frames.add(frame)
                else:
                    raise AssertionError("Wheel scrolling failed to reach document boundary")
            assert len(frames) > 10, ("screen not repainting", len(frames))
            assert n.api.buf_get_lines(buffers[0], 0, -1, False) == source
            print(f"report {columns}x{rows}, {'source' if driver == 0 else 'preview'} wheel: full down/up passed", flush=True)

        # Previously CursorMoved/preview events stopped this pending timer.
        n.api.set_current_win(windows[0])
        n.api.buf_set_lines(buffers[0], 0, 0, False, ["UPDATED_MARKER"])
        n.exec_lua("""
            local source,preview=...
            local a=require('markview.autocmds')
            a.cursor({buf=source,event='TextChanged'})
            assert(a.cursor_timer(source):is_active(),'TextChanged did not schedule a refresh')
            a.cursor({buf=source,event='CursorMoved'})
            a.cursor({buf=preview,event='CursorMoved'})
            assert(a.cursor_timer(source):is_active(),'Ignored events cancelled the refresh')
            vim.wait(100)
        """, buffers[0], buffers[1])
        assert "UPDATED_MARKER" in n.api.buf_get_lines(buffers[1], 0, 5, False), "Edited text not refreshed"
        assert document.read_bytes() == original
    finally:
        try:
            n.command("qa!")
        except (EOFError, OSError):
            pass
        n.close()
print("report edit refresh: passed; document bytes unchanged")
