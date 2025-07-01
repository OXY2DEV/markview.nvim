# markview.nvim

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/repo/markdown-catppuccin_mocha.png">

A hackable `markdown`, `latex`, `typst`, `html`(inline) & `yaml` previewer for Neovim.

## Table of contents

On this page,

- [💡 Commands](#-commands)
- [📻 Autocmds](#-autocmds)
- [🎨 Highlight groups](#-highlight-groups)
    + [Main groups](#main-groups)
    + [Secondary groups](#secondary-groups)

------

Also read,

- [🔩 Configuration](https://github.com/OXY2DEV/markview.nvim/wiki/Configuration)
    + [🌋 Experimental options](https://github.com/OXY2DEV/markview.nvim/wiki/Experimental)
    + [💻 Preview options](https://github.com/OXY2DEV/markview.nvim/wiki/Preview)

    + [📝 Markdown](https://github.com/OXY2DEV/markview.nvim/wiki/Markdown)
    + [💭 Markdown inline](https://github.com/OXY2DEV/markview.nvim/wiki/Markdown-inline)
    + [🧮 LaTeX](https://github.com/OXY2DEV/markview.nvim/wiki/LaTeX)
    + [💻 Typst](https://github.com/OXY2DEV/markview.nvim/wiki/Typst)
    + [🔩 YAML](https://github.com/OXY2DEV/markview.nvim/wiki/YAML)

- [Developer options](https://github.com/OXY2DEV/markview.nvim/wiki/Developer-documentation)

------

For the tinkerers,

- [🔥 Advanced usage](https://github.com/OXY2DEV/markview.nvim/wiki/Advanced-usage)
- [🧩 Presets](https://github.com/OXY2DEV/markview.nvim/wiki/Presets)
- [🧩 Extras](https://github.com/OXY2DEV/markview.nvim/wiki/Extras)

## 💡 Commands

The plugin comes with a single command, `:Markview`. It can be used trigger any of the following sub-commands,

```vim
:Markview Toggle
```

- `Toggle`
  Toggles the preview on all attached buffers! Buffers that have their previews disabled will have it enabled and the ones that have it enabled will be disabled.

- `Enable`
  Enables preview on all attached buffers.

- `Disable`
  Disables preview on all attached buffers.

- `toggle <bufnr>`
  Toggles the plugin on the given buffer(current buffer if not provided).

- `enable <bufnr>`
  Enables preview on the given buffer(current buffer if not provided).

- `Disable <bufnr>`
  Disables preview on the given buffer(current buffer if not provided).

------

- `Start`
  Starts the plugin. Any visited/opened buffers will have the plugin attached to them.

- `Stop`
  Stops the plugin. The plugin won't attach to any new buffers.

>[!CAUTION]
> If you run `:Markview Stop`, open a buffer, run `:Markview Start` and revisit that buffer, the plugin will attach to that buffer!

------

- `attach`
  Attaches the plugin to a buffer.

- `detach`
  Detaches the plugin from a buffer.

>[!NOTE]
> Revisiting a detached buffer will cause it to be attached!

------

- `HybridToggle`
  Toggles hybrid mode globally.

- `HybridEnable`
  Enables hybrid mode globally.

- `HybridDisable`
  Disables hybrid mode globally.

- `hybridToggle <bufnr>`
  Toggles hybrid mode of the given buffer(current buffer if not provided).

- `hybridEnable <bufnr>`
  Enables hybrid mode of the given buffer(current buffer if not provided).

- `hybridDisable <bufnr>`
  Disables hybrid mode of the given buffer(current buffer if not provided).

>[!NOTE]
> These commands won't do anything if `preview.hybrid_modes` aren't set!

------

- `linewiseToggle`
  Toggles `linewise hybrid mode`.

- `linewiseEnable`
  Enables `linewise hybrid mode`.

- `linewiseDisable`
  Disables `linewise hybrid mode`.

>[!NOTE]
> These work `globally`! And require `preview.hybrid_modes` to be set!

------

- `splitOpen <bufnr>`
  Opens the given buffer's(current buffer if not provided) preview in a split window.

- `splitClose`
  Closes any open split-view window.

- `splitToggle`
  Toggles `splitview`.

- `splitRedraw`
  Redraws the splitview window.

>[!IMPORTANT]
> Only **1** splitview window will be open!

------

- `Render`
  Updates the preview of all enabled buffers.

- `Clear`
  Clears the preview of all enabled buffers.

- `render <bufnr>`
  Renders preview in the given buffer(current buffer if not provided).

- `clear <bufnr>`
  Clears the preview of given buffer(current buffer if not provided).

>[!TIP]
> These commands can be used to fix visual glitches in the preview!

>[!NOTE]
> `render` & `clear` can be run on **any buffer**, even if the previews are disabled!

------

- `traceShow`
  Shows the plugin's internal messages in a window.

- `traceExport`
  Exports the plugin's trace into a text file(`trace.txt`).

## 📻 Autocmds

> Also see [preview.callbacks](https://github.com/OXY2DEV/markview.nvim/wiki/Preview#callbacks).

Autocmds will be executed after their corresponding `callback`! Arguments are passed in `event.data`.

```lua
vim.api.nvim_create_autocmd("User", {
	pattern = "MarkviewAttach",
    callback = function (event)
    	vim.print(event.data);
    end
});
```

- MarkviewAttach
  Called when the plugin attaches to a buffer.

  Arguments,
  + `buffer`, the buffer being attached to.
  + `windows`, the windows attached to `buffer`(see `win_findbuf()`).

- MarkviewDetach
  Called when the plugin detaches from a buffer.

  Arguments,
  + `buffer`, the buffer being detached from.
  + `windows`, the windows attached to `buffer`.

------

- MarkviewEnable
  Called when preview is enabled for a buffer.

  Arguments,
  + `buffer`, the buffer that's preview is enabled.
  + `windows`, the windows attached to `buffer`.

- MarkviewDisable
  Called when preview is disabled for a buffer.

  Arguments,
  + `buffer`, the buffer that's preview is disabled.
  + `windows`, the windows attached to `buffer`.

------

- MarkviewSplitviewOpen
  Called when `splitview` is opened.

  Arguments,
  + `source`, the buffer that's preview is being shown.
  + `preview_buffer`, preview buffer.
  + `windows`, preview window.

- MarkviewSplitviewClose
  Called when `splitview` is being closed.

  Arguments,
  + `source`, the buffer that's preview is being shown.
  + `preview_buffer`, preview buffer.
  + `windows`, preview window.

## 🎨 Highlight groups

These highlight groups are created by the plugin,

>[!NOTE]
> The value of these groups are updated when changing the colorscheme!

### Main groups

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

### Secondary groups

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

