; Long links in table cells — right border shifts off when `wrap` is on

When a table cell contains a link (`[text](url)`) or image, the renderer conceals
the `](https://…)` portion, so the *visible* cell is only as wide as the label
plus the link icon (e.g. `󰌷 label`). The column-width calculation in
`renderers/markdown/tostring.lua` correctly measures this concealed width and
stores it in `col_widths`.

However, with `wrap` enabled the table renderer runs a "is this table too wide to
bother rendering?" guard. That guard summed the RAW column widths (`vim_width`),
which include the *unconcealed* URL — often 90+ columns for a real link. A single
long-URL cell therefore made the estimated table width exceed the window and the
renderer bailed out completely (`return`), drawing NO padding and NO borders for
the whole table. The visible `|` characters are then just the raw trailing pipes
of each source line, landing at wildly different columns per row, so the right
border appears shifted far off — and the longer the URL, the further it drifts.

Fix: base the width guard on `col_widths` (the visible, post-conceal widths)
instead of `vim_width` (the raw widths). Long-URL tables whose concealed width
fits the window then render with correct padding and aligned borders.

To reproduce, open this file (its modeline enables `wrap`) in a window that is
comfortably wider than the *concealed* table but narrower than the *raw* table
(the long URLs are much wider than the visible cells). Move the cursor OFF the
table so the URLs conceal. Every right border of column 2 must line up in a
single straight vertical column; the short-URL and long-URL rows must agree.

### Long hyperlink URLs (primary repro)

| Kind        | Link                                                                                             |
|-------------|--------------------------------------------------------------------------------------------------|
| Hyperlink   | [Neovim API reference](https://neovim.io/doc/user/api.html#nvim_buf_set_extmark()-full-details)  |
| Image       | ![screenshot](https://raw.githubusercontent.com/nvim-treesitter/playground/master/screenshot.png) |
| Bold + link | **[bold link with long URL](https://spec.commonmark.org/0.31.2/#emphasis-and-strong-emphasis)**  |
| Short (ctl) | [ref](https://a.co)                                                                              |
| Plain (ctl) | no link here                                                                                     |

### Mixed short/long links (borders must still align)

| Name   | Reference                                                                                  |
|--------|--------------------------------------------------------------------------------------------|
| short  | [a](https://a.co)                                                                          |
| medium | [docs](https://example.com/some/moderately/long/path/to/a/page.html)                       |
| long   | [spec](https://spec.commonmark.org/0.31.2/#emphasis-and-strong-emphasis-combined-with-links) |

<!-- vim: set wrap: -->
