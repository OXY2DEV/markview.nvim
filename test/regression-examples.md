# Regression Testing Examples

Instructions: Open this file with `set wrap` enabled. Walk through each
numbered section matching the regression matrix.

---

## 1 — Concealed content: table with long URLs renders

The table below has long URLs that get concealed. It should still render
as a proper table (borders, padding, alignment) — not fall back to raw text.

| Feature | Status | Docs |
|---------|--------|------|
| **Bold** | ✅ Done | [spec](https://spec.commonmark.org/0.31.2/#emphasis-and-strong-emphasis-with-asterisks-and-underscores-rule-1-through-17) |
| `code` | ⚠️ Partial | [GFM](https://github.github.com/gfm/#strikethrough-extension-with-tildes-and-double-tildes-for-del-elements) |
| Nested lists | 🔧 WIP | [deep](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#nested-lists-ordered-and-unordered-mixing-indentation-levels) |

---

## 2 — Wrap continuation lines show table borders

Shrink the window width until the table above wraps. Continuation lines
should show `│...│` table borders — not raw text leaking through.

(Use the same table from §1 above. Narrow the window to ~60 columns.)

---

## 3 — Strikethrough doesn't inflate column widths

The `~~Strikethrough~~` column should be the same visual width as the text
without the `~~` markers. Compare column widths with and without.

| Style | Example | Notes |
|-------|---------|-------|
| Plain | hello | baseline |
| ~~Strikethrough~~ | ~~deleted~~ | width should match "deleted" |
| **Bold** | **strong** | width should match "strong" |

---

## 4 — Table borders use MarkviewTable* highlights

All table borders (`│`, `─`, `┼`, `╭`, `╮`, etc.) should use `MarkviewTableBorder`
or `MarkviewTableHeader` highlight groups — not treesitter `@punctuation.special`.

Inspect the borders of this table:

| A | B |
|---|---|
| 1 | 2 |

---

## 5 — Right border on first screen row of wrapping lines

When a table row wraps, the **first** screen row of that wrapped line should
still have a right border `│` at the correct position.

(Use the long-URL table from §1. Shrink window until rows wrap. Check the
right edge of the first screen row of each wrapping line.)

---

## 6 — Top/bottom border indent for nested tables (list context)

The table below is inside an ordered list. The top and bottom borders should
be indented to align with the table content — not flush-left.

1. Here is an item with a nested table:

   | Key | Val |
   |-----|-----|
   | `x` | 42  |
   | `y` | 99  |

2. Another list item.

And a deeper nesting:

1. Level 1
   - Level 2
     1. Level 3 table:

        | A | B | C |
        |---|---|---|
        | 1 | 2 | 3 |

     2. Back to list.

---

## 7 — Separator decorations stable in hybrid mode

Move your cursor in and out of the table below. The separator row decorations
(`─`, `╶`, `┼`) should **not** swap order when the cursor enters/leaves.

| Left | Center | Right |
|:-----|:------:|------:|
| aaa | bbb | ccc |
| ddd | eee | fff |

Also test with cursor on this heading, then move into the table above.

---

## 8 — Tables inside blockquotes render fully

The table inside this blockquote should render the separator row AND all
data rows — not just the header.

> | Name | Value |
> |------|-------|
> | alpha | 1 |
> | beta | 2 |
> | gamma | 3 |

Nested blockquote:

> > | X | Y |
> > |---|---|
> > | a | b |

---

## 9 — Simple table renders correctly (nowrap)

Set `nowrap`. This simple table should render with proper borders.

| One |
|-----|
| 1   |

And a wider one:

| Col A | Col B | Col C | Col D |
|-------|-------|-------|-------|
| foo | bar | baz | qux |
| alpha | beta | gamma | delta |

---

## 10 — Alignment markers render correctly

Each column should show the correct alignment decoration in the separator row.

| Default | Left | Center | Right |
|---------|:-----|:------:|------:|
| none | left | center | right |
| aaa | bbb | ccc | ddd |

---

## 11 — Blockquote borders alongside table borders

Both the blockquote border (`▋`) and table borders (`│`) should be visible
side by side.

> | Animal | Sound |
> |--------|-------|
> | Cat | Meow |
> | Dog | Woof |

---

## 12 — Hybrid mode: cursor-line un-renders/re-renders cleanly

Move your cursor row-by-row through this table. Each row should un-render
when the cursor is on it (showing raw markdown) and re-render when the
cursor leaves.

| Language | Typing | Speed |
|----------|--------|-------|
| Lua | dynamic | fast |
| Rust | static | fast |
| Python | dynamic | moderate |
| C | static | very fast |

---

## 13 — Code blocks inside lists render correctly

The code block below is nested inside a list. It should render with proper
syntax highlighting and code-block decorations.

1. **First item**
   - Sub-item with code:

     ```lua
     local M = {}
     function M.setup(opts)
       return vim.tbl_deep_extend("force", {}, opts or {})
     end
     return M
     ```

   - Another sub-item

2. **Second item**

---

## 14 — Headings, horizontal rules, inline formatting unaffected

### This is an H3

#### This is an H4

##### This is an H5

---

Inline formatting: **bold**, *italic*, ***bold-italic***, `inline code`,
~~strikethrough~~, and [a link](https://example.com).

A horizontal rule below:

---

And another:

***

---

## End of regression examples

Replace ☐ with ✅ or ❌ in `test/regression-matrix.md` as you test each case.
