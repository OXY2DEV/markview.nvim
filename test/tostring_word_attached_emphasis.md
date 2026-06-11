; Word-attached emphasis in tables — tostring column width

Emphasis markers glued to a word (`x**bold**`, `I**'ll**`) are concealed by the
renderer per CommonMark flanking rules, so the column-width calculation in
`renderers/markdown/tostring.lua` must account for them too. If it doesn't, the
calculated width is larger than what is drawn and the right border drifts.

Open this file and check that every right border lines up.

### Bold glued to a word

| Case                          | Example              |
|-------------------------------|----------------------|
| Before a letter               | x**bold** end        |
| Before punctuation            | I**'ll finish** soon |
| Before punctuation            | I**'d be** here      |
| After a word + space (normal) | a **bold** b         |
| Plain (control)               | just normal text     |

### Italic glued to a word

| Case                       | Example   |
|----------------------------|-----------|
| Italic before punctuation  | I*'ll* go |
| Intra-word italic          | 2*3*4 ok  |
| Plain italic (control)     | a *it* b  |

### Underscore stays literal (no intra-word emphasis)

| Case             | Example              |
|------------------|----------------------|
| snake_case       | a snake_case_id here |
| Plain (control)  | just normal text     |

### Conditionals cheat sheet (real-world)

| Type  | Example                                                     |
|-------|-------------------------------------------------------------|
| 1st   | If you **help** me, I**'ll finish** sooner.                 |
| Mixed | If I **had studied** medicine, I**'d be** a doctor **now**. |
| Mixed | If I **weren't** so shy, I**'d have spoken** up yesterday.  |
