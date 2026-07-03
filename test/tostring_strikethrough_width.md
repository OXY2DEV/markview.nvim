; Strikethrough markers in tables — tostring column width
Strikethrough delimiters (`~~text~~`) are concealed by the renderer, so the
column-width calculation in `renderers/markdown/tostring.lua` must strip them
too. If it doesn't, each `~~` pair adds 2 characters (4 per `~~text~~` span) to
the computed width, so the calculated width is larger than what is drawn and the
right border drifts to the right.
Open this file and check that every right border lines up. The strikethrough
rows should align exactly with the plain control rows below them.
### Single strikethrough span
| Case                     | Example              |
|--------------------------|----------------------|
| Strikethrough word       | ~~gone~~ text        |
| Strikethrough phrase     | ~~all of this~~ here |
| Plain (control, same len)| xxxxxxx text         |
| Plain (control)          | just normal text     |
### Multiple spans in one cell
| Case                    | Example                    |
|-------------------------|----------------------------|
| Two spans               | ~~one~~ and ~~two~~ done   |
| Span at end of cell     | keep ~~this dropped~~      |
| Plain (control)         | one     and two     done   |
### Strikethrough mixed with other emphasis
| Case                       | Example                  |
|----------------------------|--------------------------|
| Strike + bold             | ~~old~~ **new**          |
| Strike + italic           | ~~old~~ *new*            |
| Strike + code             | ~~old~~ `new()`          |
| Plain (control)           | old     new              |
### Escaped tildes stay literal (not strikethrough)
| Case                  | Example            |
|-----------------------|--------------------|
| Escaped tilde pair    | a \~\~literal\~\~ b |
| Single tilde (approx) | about ~5 items     |
| Plain (control)       | just normal text   |
