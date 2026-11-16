# Table wrapping and scroll regressions

Requires Neovim 0.11+ and Python 3 with `pynvim`. The tests launch isolated Neovim
processes; the document supplied below is read without saving any changes.

```sh
python3 test/run.py
python3 test/run.py --document /path/to/avm_roadcal_report_analyze.md \
  --user-config /path/to/init.lua
```

The full run checks single-window wheel-up from EOF before wheel-down, immediate
and settled viewport positions, both split windows, text refresh, CJK wrap edges,
width changes, partial source slices, alignment opt-out, foreign namespaces,
buffer cleanup, and independent edit timers. Passing the user configuration
also exercises its real plugins/options in the single-window regression.

## Rendering ownership

- `table_wrap.layout()` computes cell chunks, source-row groups, and display
  heights without changing text or creating extmarks.
- `table_state` holds private per-buffer layouts and releases them on clear or
  buffer wipeout. Repeated rendering replaces a layout at the same source row.
- `table_wrap_rows` paints a single-window table in its own namespace after
  inline rendering. Source rows remain addressable for native cursor scrolling.
- `splitview_tables` expands layouts into the disposable preview buffer and
  returns the source-to-preview boundary map. The expanded buffer is rendered
  once; no temporary concealed table is needed.
- `splitview_align` owns padding and viewport mapping. Closing the preview
  removes padding and highlights. Disabling alignment retains the row map.

Source text is never expanded. Inline Markdown is converted to plain preview
text inside wrapped cells. Original short-table and custom renderers still run.
If the same source buffer appears in windows with incompatible widths/wrapping
options, wrapping falls back to the original renderer: buffer-local extmarks
cannot represent two different native screen layouts safely.
