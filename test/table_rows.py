"""Check every drawn row, including CJK wrap boundaries: python3 test/table_rows.py"""
from pathlib import Path

import pynvim

root = Path(__file__).resolve().parents[1]
source = (root / "test/wrapped_tables.md").read_text().splitlines()
for columns in (60, 80):
    for wrap in (True, False):
        for linebreak in (True, False):
            n = pynvim.attach("child", argv=["nvim", "--embed", "-u", "NONE", "-n"])
            try:
                n.ui_attach(columns, 80, rgb=True)
                n.exec_lua("""
                    vim.opt.rtp:append(...)
                    vim.wo.signcolumn='yes'
                    vim.wo.conceallevel=3; vim.wo.concealcursor='nc'
                """, str(root))
                n.current.buffer[:] = source
                n.command("setfiletype markdown")
                n.exec_lua("vim.wo.wrap,vim.wo.linebreak=...; require('markview.actions').render(0,{enable=true,hybrid_mode=false})", wrap, linebreak)
                n.command("redraw!")
                actual = n.exec_lua("""
                    local t={}
                    for r=1,70 do
                        local s=''
                        for c=1,vim.o.columns do s=s..vim.fn.screenstring(r,c) end
                        t[#t+1]=vim.trim(s)
                    end
                    return t
                """)
                expected = n.exec_lua("""
                    local t={}
                    for _,plan in ipairs(require('markview.renderers.markdown.table_state').get(0)) do
                        for _,row in ipairs(plan.rows) do
                            for _,chunks in ipairs(row) do
                                local s=''
                                for _,chunk in ipairs(chunks) do s=s..chunk[1] end
                                t[#t+1]=vim.trim(s)
                            end
                        end
                    end
                    return t
                """)
                index = 0
                for row in expected:
                    index = actual.index(row, index) + 1
                assert n.current.buffer[:] == source
            finally:
                try:
                    n.command("qa!")
                except (EOFError, OSError):
                    pass
                n.close()
print("single-window table rows: all cells visible in order (CJK, wrap/nowrap, linebreak, 60/80 columns)")
