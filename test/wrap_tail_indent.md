<!--
  Manual checks for the wrap indent fixes (`wrap.fine_wrap()` and the
  `WinResized`/`VimResized` re-render).

  Run it from a checkout of this plugin,

  ```sh
  nvim -u test/minimal_init.lua test/wrap_tail_indent.md
  ```

  `test/minimal_init.lua` enables `wrap`/`linebreak`/`breakindent` & the
  hybrid mode settings, so you only have to,

  1. Narrow the window to ~40 columns (`:vertical resize 40`).
  2. Put the cursor on the last line, so the lines above it render.
  3. Check that no continuation row ends with a stray border(`-`) & that
     the indent never splits the last word(`... quote- d`).
  4. Widen back to ~100 columns. No indent may stay behind mid-line.

  Every quoted/list line is padded to its stated byte length(36 & 46 are
  the text widths of a 40 & 50 column window, so all of them wrap).
-->

# Wrap indent checks

## Block quotes

> case A: 72 bytes, a trailing space. lorem ipsum dolor sit amet consec 

> case B: 72 bytes, no trailing space. lorem ipsum dolor sit amet consec

> case C: 73 bytes, wraps one character onto the last row. lorem ipsum do

> case D: 86 bytes, wraps one character onto the last row. lorem ipsum dolor sit ametx

## List items

- case E: 86 bytes, list item. lorem ipsum dolor sit amet consectetur adipiscing elit 

  - case F: 90 bytes, nested list item. lorem ipsum dolor sit amet consectetur adipiscing 

- [ ] case G: 88 bytes, checkbox item. lorem ipsum dolor sit amet consectetur adipiscing

## Controls (must render exactly as before)

# A heading that is long enough to wrap in a narrow window

Plain paragraph, wrapped by Neovim itself, no indent is added here: lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua

| column a | column b | column c |
|---|---|---|
| lorem ipsum dolor sit am | x | y |

```lua
local x = 1 -- lorem ipsum dolor sit amet consectetur a
```

---

> case H: 71 bytes, no trailing space. lorem ipsum dolor sit amet conse
