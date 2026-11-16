"""Lifecycle and ownership regressions: python3 test/review_lifecycle.py"""
from pathlib import Path

import pynvim

root = Path(__file__).resolve().parents[1]
n = pynvim.attach("child", argv=["nvim", "--embed", "-u", "NONE", "-n"])
try:
    n.ui_attach(120, 80, rgb=True)
    n.exec_lua("vim.opt.rtp:append(...);vim.wo.wrap=true;vim.wo.linebreak=true;vim.wo.signcolumn='yes'", str(root))
    fixture = (root / "test/wrapped_tables.md").read_text().splitlines()
    n.current.buffer[:] = fixture
    n.command("setfiletype markdown")
    n.exec_lua("""
        local ns=vim.api.nvim_create_namespace('markview/review-external')
        vim.api.nvim_buf_set_extmark(0,ns,2,0,{hl_group='Normal'})
        require('markview.actions').render(0,{enable=true,hybrid_mode=false})
        assert(#vim.api.nvim_buf_get_extmarks(0,ns,0,-1,{})==1,'Foreign namespace cleared')
        assert(#require('markview.renderers.markdown.table_state').get(0)==1)
        require('markview.renderer').render(0,require('markview.parser').content)
        assert(#require('markview.renderers.markdown.table_state').get(0)==1,'Duplicate layout')
        require('markview.actions').clear(0)
        assert(#require('markview.renderers.markdown.table_state').get(0)==0)
        assert(#vim.api.nvim_buf_get_extmarks(0,require('markview.renderers.markdown.table_wrap_rows').ns,0,-1,{})==0)
        assert(#vim.api.nvim_buf_get_extmarks(0,ns,0,-1,{})==1,'Clear leaked outside owned namespaces')
    """)
    # Wipe a rendered buffer: private plans must not retain its text/layouts.
    old = n.current.buffer.number
    n.exec_lua("require('markview.actions').render(0,{enable=true,hybrid_mode=false})")
    n.command("enew!")
    n.api.buf_delete(old, {"force": True})
    assert n.exec_lua("return #require('markview.renderers.markdown.table_state').get(...)", old) == 0

    # Separate debounce timers, stale scheduled work, disabled state, wipeout.
    n.exec_lua("""
        local a=require('markview.autocmds')
        local actions=require('markview.actions')
        local state=require('markview.state')
        a.setup()
        local b1,b2=vim.api.nvim_create_buf(true,false),vim.api.nvim_create_buf(true,false)
        state.attach(b1,{enable=true,hybrid_mode=false})
        state.attach(b2,{enable=true,hybrid_mode=false})
        local original=actions.render
        local called={}
        actions.render=function(b) called[b]=(called[b] or 0)+1 end
        a.cursor({buf=b1,event='TextChanged'})
        a.cursor({buf=b2,event='TextChanged'})
        a.cursor({buf=b2,event='CursorMoved'})
        assert(a.cursor_timer(b1):is_active() and a.cursor_timer(b2):is_active())
        vim.wait(200)
        assert(called[b1]==1 and called[b2]==1,'One buffer cancelled another buffer refresh')
        a.cursor({buf=b1,event='TextChanged'})
        state.enable(false)
        vim.wait(200)
        assert(called[b1]==1,'Disabled preview was redrawn by stale work')
        state.enable(true)
        a.cursor({buf=b1,event='TextChanged'})
        local timer=a.cursor_timer(b1)
        vim.api.nvim_buf_delete(b1,{force=true})
        vim.wait(200)
        assert(timer:is_closing(),'Wiped buffer retained its debounce timer')
        assert(called[b1]==1,'Wiped buffer was redrawn')
        actions.render=original
        vim.api.nvim_buf_delete(b2,{force=true})
    """)

    # Force the partial-render branch with a nonzero source origin.
    source = [f"prefix {i}" for i in range(50)] + [""] + fixture + [""] + [f"suffix {i}" for i in range(50)]
    n.current.buffer[:] = source
    n.command("setfiletype markdown")
    n.api.win_set_cursor(n.current.window, (53, 0))
    n.exec_lua("""
        require('markview.spec').setup({preview={max_buf_lines=25}})
        require('markview.actions').attach(vim.api.nvim_get_current_buf())
        require('markview.actions').splitOpen()
        local a=require('markview.splitview_align')
        local l=a.layout
        assert(l.source_first>0,'Expected a bounded source slice')
        local row=l.mapping[57-l.source_first]
        assert(vim.api.nvim_buf_get_lines(l.preview_buf,row,row+1,false)[1]=='suffix 0','Wrong row after expanded table')
        local c=a.cursor(l.preview_buf,{53,99999})
        local text=vim.api.nvim_buf_get_lines(l.preview_buf,c[1]-1,c[1],false)[1]
        assert(c[2]<=#text,'Mapped cursor column exceeded cell row')
        require('markview.spec').setup({preview={splitview_align=false}})
        require('markview.actions').splitview_render()
        l=a.layout
        assert(l.sync==false)
        assert(a.cursor(l.preview_buf,{58,0})[1]==l.mapping[57-l.source_first]+1,'Disabling padding broke row mapping')
        local pre=l.preview_buf
        require('markview.actions').splitClose()
        assert(#vim.api.nvim_buf_get_extmarks(pre,require('markview.splitview_tables').ns,0,-1,{})==0,'Split highlights survived close')
    """)
    assert n.current.buffer[:] == source
    # A file reload updates the preview, without painting the editing buffer.
    n.exec_lua("require('markview.actions').splitOpen()")
    source[54] = source[54].replace("카메라마다", "재로딩검증")
    n.api.buf_set_lines(n.current.buffer, 54, 55, False, [source[54]])
    n.exec_lua("""
        local state=require('markview.state')
        local src=state.get_splitview_source()
        require('markview.autocmds').file_changed({buf=src})
        local lines=vim.api.nvim_buf_get_lines(state.get_splitview_buffer(),0,-1,false)
        assert(table.concat(lines):find('재로딩검증',1,true),'Reload left the preview stale')
        assert(#require('markview.renderers.markdown.table_state').get(src)==0,'Reload painted the editing buffer')
        require('markview.actions').splitClose()
    """)
    # Buffer-local overlays must not be reused at a different window width.
    n.command("vsplit")
    other = n.current.window
    n.api.win_set_width(other, 35)
    n.exec_lua("""
        require('markview.spec').setup({preview={max_buf_lines=1000}})
        require('markview.actions').render(0,{enable=true,hybrid_mode=false})
        assert(#require('markview.renderers.markdown.table_state').get(0)==0,'Unsafe shared-window overlays')
        assert(#vim.api.nvim_buf_get_extmarks(0,require('markview.renderers.markdown.table_wrap_rows').ns,0,-1,{})==0)
    """)
    assert n.current.buffer[:] == source
    n.api.win_close(other, True)
    n.exec_lua("""
        local spec=require('markview.spec')
        local called=0
        spec.setup({renderers={markdown_table=function() called=called+1 end}})
        require('markview.actions').splitOpen()
        local s=require('markview.state')
        assert(called>0,'Custom table renderer was bypassed')
        assert(vim.api.nvim_buf_line_count(s.get_splitview_buffer())==vim.api.nvim_buf_line_count(s.get_splitview_source()),'Custom table was materialized')
        require('markview.actions').splitClose()
        spec.config.renderers.markdown_table=nil
        local hidden=vim.api.nvim_create_buf(true,false)
        require('markview.state').set_splitview_source(hidden)
        require('markview.actions').splitview_render()
        assert(require('markview.state').get_splitview_source()==nil,'Hidden source left stale split state')
        require('markview.actions').splitview_cursor()
        vim.api.nvim_buf_delete(hidden,{force=true})
    """)
    print("review regressions: ownership/cleanup, independent timers, disabled/wiped buffers, partial slices, row maps, reloads, incompatible windows, custom renderers, hidden source")
finally:
    try:
        n.command("qa!")
    except (EOFError, OSError):
        pass
    n.close()
