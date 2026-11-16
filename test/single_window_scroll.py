"""Single-window wheel regression, starting at EOF (requires pynvim).

python3 test/single_window_scroll.py /path/to/report.md
python3 test/single_window_scroll.py /path/to/report.md --user-config /path/to/init.lua
"""
import argparse
from pathlib import Path

import pynvim

args = argparse.ArgumentParser()
args.add_argument("document", type=Path)
args.add_argument("--user-config", type=Path)
options = args.parse_args()
document = options.document.resolve()
original = document.read_bytes()
source = original.decode().splitlines()
root = Path(__file__).resolve().parents[1]

for columns, rows in ((120, 30), (80, 24)):
    n = pynvim.attach("child", argv=["nvim", "--embed", "-n", "-u", str(options.user_config or "NONE")])
    try:
        n.ui_attach(columns, rows, rgb=True)
        if options.user_config:
            n.exec_lua("vim.wait(1000)")
            n.command("edit " + n.funcs.fnameescape(str(document)))
            n.exec_lua("vim.wait(300)")
        else:
            n.exec_lua("""
                vim.opt.rtp:append(...)
                vim.o.mouse='a'; vim.o.scrolloff=10; vim.wo.signcolumn='yes'
                vim.wo.wrap=true; vim.wo.linebreak=true
                require('markview').setup({preview={ignore_buftypes={}}})
                require('markview.autocmds').setup()
            """, str(root))
            n.current.buffer[:] = source
            n.command("setfiletype markdown")
            n.exec_lua("require('markview.actions').attach(vim.api.nvim_get_current_buf()); vim.wait(100)")
        assert n.exec_lua("return require('markview.state').get_splitview_source()") is None
        assert n.exec_lua("return #require('markview.renderers.markdown.table_state').get(0)") > 0
        assert not n.exec_lua("local ns=require('markview.renderers.markdown.table_wrap_rows').ns; for _,m in ipairs(vim.api.nvim_buf_get_extmarks(0,ns,0,-1,{details=true})) do if m[4].conceal_lines then return true end end; return false"), "Single-window tables still hide all source anchors"

        def offset():
            return n.exec_lua("""
                local v=vim.fn.winsaveview()
                local h=vim.api.nvim_win_text_height(0,{start_row=0,start_vcol=0,end_row=v.topline-1,end_vcol=0}).all-v.topfill
                if v.skipcol>0 then h=h+vim.api.nvim_win_text_height(0,{start_row=v.topline-1,start_vcol=0,end_row=v.topline-1,end_vcol=v.skipcol}).all end
                return h
            """)

        n.command("normal! G")
        n.exec_lua("vim.wait(300)")
        for direction in ("up", "down"):
            ticks = 0
            for tick in range(1000):
                before = offset()
                n.api.input_mouse("wheel", direction, "", 0, 12, 20)
                n.exec_lua("vim.wait(5)")
                immediate = offset()
                n.exec_lua("vim.wait(40)")
                settled = offset()
                assert settled == immediate, ("delayed snapback", tick, immediate, settled)
                if settled == before:
                    if direction == "up":
                        assert settled == 0, ("stuck scrolling up", tick, settled, n.funcs.winsaveview())
                    else:
                        assert n.funcs.line("w$") == len(source), ("stuck before EOF", tick, settled)
                    break
                assert (settled < before) == (direction == "up"), ("viewport bounced", direction, tick, before, settled, n.funcs.winsaveview())
                ticks += 1
            else:
                raise AssertionError("Scrolling did not reach the document boundary")
            print(f"single window {columns}x{rows}: {direction}, {ticks} wheel events, no bounce", flush=True)
        assert n.current.buffer[:] == source
        assert document.read_bytes() == original
    finally:
        try:
            n.command("qa!")
        except (EOFError, OSError):
            pass
        n.close()
