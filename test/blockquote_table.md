; Tables inside blockquotes — parser continuation prefix
A table nested in a blockquote has a `> ` (block continuation) prefix on every
line. `get_node_text()` only strips the node's `col_start` from the *first*
line, so lines 2+ keep the `> `. The lpeg row parser in
`parsers/markdown.lua` then fails silently on those lines, leaving the
separator and data rows unrendered (only the header shows, or the table renders
empty/broken).
Open this file: every table below should render fully — header, separator, and
all data rows — with borders aligned. The blockquoted tables should look like
the plain control table, just indented under the quote marker.
### Control: table not in a blockquote
| Name  | Role     |
|-------|----------|
| Alice | Engineer |
| Bob   | Designer |
### Table inside a blockquote
> Some quoted intro text.
>
> | Name  | Role     |
> |-------|----------|
> | Alice | Engineer |
> | Bob   | Designer |
>
> Trailing quoted text after the table.
### Table inside a nested blockquote
> Outer quote.
>
> > | Key   | Value |
> > |-------|-------|
> > | alpha | 1     |
> > | beta  | 2     |
### Blockquote table with alignment markers
> | Left | Center | Right |
> |:-----|:------:|------:|
> | a    | b      | c     |
> | dd   | ee     | ff    |
