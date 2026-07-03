; Concealed link/image URLs and soft-wrap — ghost underlines
The concealing extmark for a link/image hides the `](https://…)` portion, which
can span hundreds of bytes. When that hidden text is long enough to soft-wrap,
Neovim creates phantom screen rows for it. With `hl_mode = "combine"` on the
conceal extmark, the virtual-text highlight (e.g. the link underline) bleeds
across every concealed byte and paints those phantom rows, producing "ghost"
underlines/highlights on otherwise-empty wrapped rows.
To reproduce, open this file with `:setlocal wrap` in a NARROW window (e.g.
40–60 columns) so the long URLs would wrap if they weren't concealed. With the
fix, no stray underline/highlight should appear below the visible link labels;
the concealed URL must not leave a colored trail on wrapped rows.
### Long hyperlink URLs (primary repro)
- [Neovim API reference](https://neovim.io/doc/user/api.html#nvim_buf_set_extmark()-nvim_buf_del_extmark()-nvim_buf_get_extmarks()-and-related-extmark-functions)
- [CommonMark emphasis rules](https://spec.commonmark.org/0.31.2/#emphasis-and-strong-emphasis-combined-with-links-and-images)
- [short link for control](https://example.com)
### Long image URLs
- ![treesitter playground screenshot](https://raw.githubusercontent.com/nvim-treesitter/playground/master/assets/screenshot-with-custom-queries-and-hl-groups.png)
- ![short image control](https://example.com/icon.svg)
### Links inside table cells (conceal + wrap in narrow columns)
| Kind        | With long URL                                                                                          |
|-------------|--------------------------------------------------------------------------------------------------------|
| Hyperlink   | [Neovim API reference](https://neovim.io/doc/user/api.html#nvim_buf_set_extmark()-full-details)         |
| Image       | ![screenshot](https://raw.githubusercontent.com/nvim-treesitter/playground/master/assets/screenshot.png) |
| Bold + link | **[bold link with long URL](https://spec.commonmark.org/0.31.2/#emphasis-and-strong-emphasis)**         |
| Short (ctl) | [ref](https://a.co)                                                                                     |
### Multiple concealed links on one wrapping line
This paragraph has [first link](https://neovim.io/doc/user/api.html#first-very-long-anchor-for-wrapping) and [second link](https://neovim.io/doc/user/lua.html#second-very-long-anchor-for-wrapping) and [third link](https://neovim.io/doc/user/options.html#third-very-long-anchor) all on one line so their concealed URLs force soft-wrap.

<!-- vim: set wrap linebreak: -->
