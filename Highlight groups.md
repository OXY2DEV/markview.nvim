<!--markdoc
    {
        "generic": {
            "filename": "../doc/markview.nvim-hl.txt",
            "force_write": true,
            "header": {
                "desc": "🎨 Highlight groups for `markview`",
                "tag": "markview.nvim-hl.txt"
            }
        },
        "markdown": {
            "list_items": {
                "marker_minus": "◆",
                "marker_plus": "◇"
            }
        }
    }
-->
<!--markdoc_ignore_start-->
## 🎨 Highlight groups
<!--markdoc_ignore_end-->

These highlight groups are created by the plugin,

>[!NOTE]
> The value of these groups are updated when changing the colorscheme!

### 🎨 Primary groups

These groups will be updated to match the colorscheme whenever the `ColorScheme` update is detected,

- `MarkviewPalette0`, has a background & foreground.
- `MarkviewPalette0Fg`, only the foreground
- `MarkviewPalette0Bg`, only the background.
- `MarkviewPalette0Sign`, background of the sign column(`LineNr`) & foreground.

- `MarkviewPalette1`
- `MarkviewPalette1Fg`
- `MarkviewPalette1Bg`
- `MarkviewPalette1Sign`

- `MarkviewPalette2`
- `MarkviewPalette2Fg`
- `MarkviewPalette2Bg`
- `MarkviewPalette2Sign`

- `MarkviewPalette3`
- `MarkviewPalette3Fg`
- `MarkviewPalette3Bg`
- `MarkviewPalette3Sign`

- `MarkviewPalette4`
- `MarkviewPalette4Fg`
- `MarkviewPalette4Bg`
- `MarkviewPalette4Sign`

- `MarkviewPalette5`
- `MarkviewPalette5Fg`
- `MarkviewPalette5Bg`
- `MarkviewPalette5Sign`

- `MarkviewPalette6`
- `MarkviewPalette6Fg`
- `MarkviewPalette6Bg`
- `MarkviewPalette6Sign`

- `MarkviewCode`.
- `MarkviewCodeInfo`.
- `MarkviewCodeFg`.
- `MarkviewInlineCode`.

>[!NOTE]
> These groups are meant to create a gradient!

- `MarkviewGradient0`
- `MarkviewGradient1`
- `MarkviewGradient2`
- `MarkviewGradient3`
- `MarkviewGradient4`
- `MarkviewGradient5`
- `MarkviewGradient6`
- `MarkviewGradient7`
- `MarkviewGradient8`
- `MarkviewGradient9`

### 🎨 Secondary groups

These are typically linked to one of the above group,

- `MarkviewBlockQuoteDefault`, links to `MarkviewPalette0Fg`.
- `MarkviewBlockQuoteError`, links to `MarkviewPalette1Fg`.
- `MarkviewBlockQuoteNote`, links to `MarkviewPalette5Fg`.
- `MarkviewBlockQuoteOk`, links to `MarkviewPalette4Fg`.
- `MarkviewBlockQuoteSpecial`, links to `MarkviewPalette3Fg`.
- `MarkviewBlockQuoteWarn`, links to `MarkviewPalette2Fg`.

- `MarkviewCheckboxCancelled`, links to `MarkviewPalette0Fg`.
- `MarkviewCheckboxChecked`, links to `MarkviewPalette4Fg`.
- `MarkviewCheckboxPending`, links to `MarkviewPalette2Fg`.
- `MarkviewCheckboxProgress`, links to `MarkviewPalette6Fg`.
- `MarkviewCheckboxUnchecked`, links to `MarkviewPalette1Fg`.
- `MarkviewCheckboxStriked`, links to `MarkviewPalette0Fg`[^1].

- `MarkviewIcon0`, links to `MarkviewPalette0Fg`[^2].
- `MarkviewIcon1`, links to `MarkviewPalette1Fg`[^2].
- `MarkviewIcon2`, links to `MarkviewPalette2Fg`[^2].
- `MarkviewIcon3`, links to `MarkviewPalette3Fg`[^2].
- `MarkviewIcon4`, links to `MarkviewPalette4Fg`[^2].
- `MarkviewIcon5`, links to `MarkviewPalette5Fg`[^2].
- `MarkviewIcon6`, links to `MarkviewPalette6Fg`[^2].

- `MarkviewHeading1`, links to `MarkviewPalette1`.
- `MarkviewHeading2`, links to `MarkviewPalette2`.
- `MarkviewHeading3`, links to `MarkviewPalette3`.
- `MarkviewHeading4`, links to `MarkviewPalette4`.
- `MarkviewHeading5`, links to `MarkviewPalette5`.
- `MarkviewHeading6`, links to `MarkviewPalette6`.

- `MarkviewHeading1Sign`, links to `MarkviewPalette1Sign`.
- `MarkviewHeading2Sign`, links to `MarkviewPalette2Sign`.
- `MarkviewHeading3Sign`, links to `MarkviewPalette3Sign`.
- `MarkviewHeading4Sign`, links to `MarkviewPalette4Sign`.
- `MarkviewHeading5Sign`, links to `MarkviewPalette5Sign`.
- `MarkviewHeading6Sign`, links to `MarkviewPalette6Sign`.

- `MarkviewHyperlink`, links to `@markup.link.label.markdown_inline`.
- `MarkviewImage`, links to `@markup.link.label.markdown_inline`.
- `MarkviewEmail`, links to `@markup.link.url.markdown_inline`.

- `MarkviewSubscript`, links to `MarkviewPalette3Fg`.
- `MarkviewSuperscript`, links to `MarkviewPalette6Fg`.

- `MarkviewListItemMinus`, links to `MarkviewPalette2Fg`.
- `MarkviewListItemPlus`, links to `MarkviewPalette4Fg`.
- `MarkviewListItemStar`, links to `MarkviewPalette6Fg`.

- `MarkviewTableHeader`, links to `@markup.heading.markdown`.
- `MarkviewTableBorder`, links to `MarkviewPalette5Fg`.
- `MarkviewTableAlignLeft`, links to `@markup.heading.markdown`.
- `MarkviewTableAlignCenter`, links to `@markup.heading.markdown`.
- `MarkviewTableAlignRight`, links to `@markup.heading.markdown`.

[^1]: The value of the linked group is used **literally**. So, manually changing the link group wouldn't work for this.
[^2]: The value of `MarkviewCode` is used for the background. So, changing either of the linked group wouldn't affect these.
