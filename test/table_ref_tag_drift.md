; Tags/refs in table cells — right-border drift
A `#`-prefixed token in a table cell (`#foo`, `#bug`, `#51`, `#107`) is parsed
as an Obsidian-style tag. The tag renderer conceals the leading `#` and injects
`padding_left` + `padding_right` (and, if configured, `corner`/`icon`) as inline
virtual text. That decoration changes the rendered cell width, but the table's
column-width calculation is computed via `renderers/markdown/tostring.lua`, which
has NO tag handler — it measures the raw cell text (`#foo` = 4 columns) and is
blind to the conceal + padding. The mismatch drifts the cell's right border
(about +1 per tag cell with the default padding; more if an icon is configured).

This is NOT limited to numeric refs: `#foo` drifts exactly like `#51`. The cause
is the missing tag-width accounting in `tostring`, not whether the tag body is
numeric.

Fix: teach `tostring` about tags so the computed column width matches what the
renderer draws (conceal the `#`, add the paddings).

Open this file with hybrid/preview mode and check every right border lines up.
Each tag cell must align with the plain control cell of equal rendered width.

### Non-numeric tags drift too (primary repro)

| Ref  | Note          | Plain |
|------|---------------|-------|
| #foo | word ref      | XXXX  |
| #bug | word tag      | XXXX  |
| #wip | word tag      | XXXX  |
| Xctl | plain control | XXXX  |

### Numeric refs drift the same way

| Ref  | Note          | Plain |
|------|---------------|-------|
| #51  | first ref     | XXX   |
| #107 | second ref    | XXXX  |
| #26  | third ref     | XXX   |
| #1   | single digit  | XX    |
| Xctl | plain control | XXXX  |

### Varied tag bodies (digits, letters, _ and -)

| Kind             | Value    |
|------------------|----------|
| Word tag         | #bug     |
| Version tag      | #v2      |
| Mixed (digits+)  | #123abc  |
| Underscore       | #wip_now |
| Hyphen           | #in-prog |
| Numeric only     | #123     |

### Mixed content — refs and tags side by side

| When     | Ref  | Tag    | Cancel   |
|----------|------|--------|----------|
| 11:38:13 | #51  | #bug   | 14:54:27 |
| 06:34:40 | #107 | #v2    | 07:51:34 |
| 08:28:44 | #26  | #wip   | 08:30:15 |

<!-- vim: set nowrap: -->
