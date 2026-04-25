Here's a stress test for your markdown renderer:

---

### Feature Matrix


| Feature | Status | Docs |
|---------|--------|------|
| **Bold** & *Italic* | ✅ Done | [spec](https://spec.commonmark.org/0.31.2/#emphasis-and-strong-emphasis-with-asterisks-and-underscores-rule-1-through-17) |
| ~~Strikethrough~~ | ⚠️ Partial | [GFM](https://github.github.com/gfm/#strikethrough-extension-with-tildes-and-double-tildes-for-del-elements) |
| `inline code` | ✅ Done | [ref](https://spec.commonmark.org/0.31.2/#code-spans-backtick-strings-and-their-matching-rules-for-inline-code) |
| Nested lists | 🔧 WIP | [deep](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#nested-lists-ordered-and-unordered-mixing-indentation-levels) |

### Inline Conceal Torture

| Kind | Example | With long URL |
|------|---------|---------------|
| Hyperlink | [short](https://example.com) | [Neovim API reference](https://neovim.io/doc/user/api.html#nvim_buf_set_extmark()-nvim_buf_del_extmark()-nvim_buf_get_extmarks()-and-related-extmark-functions) |
| Image | ![icon](https://example.com/icon.svg) | ![screenshot of the full treesitter playground](https://raw.githubusercontent.com/nvim-treesitter/playground/master/assets/screenshot-with-custom-queries-and-hl-groups.png) |
| URI autolink | <https://example.com> | <https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-8.29.1.tgz#very-long-anchor> |
| Email autolink | <user@example.com> | <very-long-username-for-testing-purposes@extremely-long-subdomain.mail.example.co.uk> |
| Inline code | `short` | `vim.api.nvim_buf_set_extmark(buffer, ns, row, col, opts)` |
| Highlight | ==marked== | ==this is a rather long highlighted span that should test wrapping== |
| Entity | &amp; and &lt; | &amp; &lt; &gt; &rarr; &larr; &hearts; &infin; &mdash; |
| Escaped | \* not bold \* | \* \[ \] \( \) \` \~ \\ \# \! |
| Emoji | :rocket: launch | :tada: :sparkles: :rocket: :fire: :bug: :memo: :bulb: :wrench: |
| Footnote | see [^1] | see [^long-descriptive-footnote-name-that-tests-width] |
| Bold + link | **[bold link](https://example.com)** | **[bold link with long URL](https://spec.commonmark.org/0.31.2/#emphasis-and-strong-emphasis-combined-with-links-and-images)** |
| Code + link | `code` then [link](https://a.co) | `vim.api.nvim_buf_set_extmark()` then [docs](https://neovim.io/doc/user/api.html#nvim_buf_set_extmark()-full-details) |
| Multi-conceal | **bold** `code` *italic* [lnk](https://x.co) | **bold** `code` *ital* ==hl== [lnk](https://neovim.io/doc/user/api.html#multi-conceal-stress-test-row) :rocket: |

[^1]: A short footnote.
[^long-descriptive-footnote-name-that-tests-width]: This footnote has a very long reference label to test how concealment handles it in table cells.

### Alignment Torture

| Left | Center | Right | Mixed |
|:-----|:------:|------:|-------|
| `vim.api` | **strong** | 42 | [API](https://neovim.io/doc/user/api.html#nvim_buf_set_lines()-nvim_buf_get_lines()-and-other-buffer-manipulation-functions) |
| `vim.lsp` | *emphasis* | 3.14 | [LSP](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_completion_resolve_and_other_request_types) |
| `vim.treesitter` | ***both*** | 0xDEAD | [TS](https://tree-sitter.github.io/tree-sitter/using-parsers/queries/pattern-matching-with-predicates-and-anchors#the-match-predicate) |

### Nested Structures

1. **First level**
   - Bullet with `code` and [a link](https://example.com)
   - Another bullet
     1. Ordered inside unordered
     2. With a table inside:

        | Key | Val |
        |-----|-----|
        | `a` | 1   |

     3. Back to the list
   - > A blockquote inside a list item
     > spanning multiple lines
2. **Second level** — with a long code block:

   ````lua
   local M = {}
   -- nested code fences should survive
   function M.setup(opts)
     opts = vim.tbl_deep_extend("force", {
       enabled = true,
       style = { bold = true, italic = false },
     }, opts or {})
     return opts
   end
   return M
   ````

3. ***Third*** with a task list:
   - [x] Completed task
   - [ ] Pending task
   - [ ] Another one

### Inline Chaos

This paragraph has **bold**, *italic*, ***bold-italic***, `inline code`, ~~deleted~~, and [a very descriptively titled link](https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-8.29.1.tgz#some-very-long-anchor-fragment-that-keeps-going-and-going-forever) all in one sentence.

### Fenced Blocks Parade

````python
# Python
def f(x: int) -> dict[str, list[int]]:
    return {"result": [i**2 for i in range(x)]}
````

````bash
# Shell with pipes
cat /proc/cpuinfo | grep -i "model name" | head -1 | awk -F: '{print $2}'
````

````json
{
  "nested": { "deep": { "value": [1, 2, 3] } },
  "escaped": "quotes \"inside\" strings"
}
````

### Horizontal Rules vs. Table Edges

---

| Single col |
|------------|
| lonely     |

---

> ### Blockquote with heading
> And a table:
>
> | A | B |
> |---|---|
> | 1 | 2 |
>
> And some `code` too.

### Math-ish (if supported)

Euler: $e^{i\pi} + 1 = 0$

$$
\sum_{n=1}^{\infty} \frac{1}{n^2} = \frac{\pi^2}{6}
$$

---
