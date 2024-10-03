# Presets

Presets are configuration recipes that you can use without the hassle of
writing large configuration tables.

`markview.nvim` comes with the following presets,

- Checkboxes, `presets.checkboxes`
  - nerd
  - nerd_alt
- Headings, `presets.headings`
  - glow
  - glow_center
  - slanted
  - arrow
  - simple
  - marker
- Horizontal rules, `presets.horizontal_rules`
  - thin
  - thick
  - double
  - dashed
  - dotted
  - solid
  - arrowed

Using presets is very simple, just `require()` the presets file and use it
like so,

```lua
local presets = require("markview.presets");

require("markview").setup({
    checkboxes = presets.checkboxes.nerd
});
```

