# Presets

Presets are configuration recipes that you can use without the hassle of
writing large configuration tables.

`markview.nvim` comes with the following presets,

- Checkboxes, `presets.checkboxes`
  - nerd
  - legacy
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

## Presets: Checkboxes

https://github.com/OXY2DEV/markview.nvim/blob/images/Wiki/presets_checkboxes.gif

Currently available presets,
- nerd
- legacy

Usage,

```lua
local presets = require("markview.presets").checkboxes;

require("markview").setup({
    checkboxes = presets.nerd
});
```

## Presets: Headings

https://github.com/OXY2DEV/markview.nvim/blob/images/Wiki/presets_headings.gif

Currently available presets,
- glow
- glow_center
- slanted
- arrowed
- simple
- marker

Usage,

```lua
local presets = require("markview.presets").headings;

require("markview").setup({
    headings = presets.simple
});
```

## Presets: Horizontal rules

https://github.com/OXY2DEV/markview.nvim/blob/images/Wiki/presets_hrs.gif

Currently available presets,
- thin
- thick
- double
- dashed
- dotted
- solid
- arrowed

Usage,

```lua
local presets = require("markview.presets").horizontal_rules;

require("markview").setup({
    headings = presets.thin
});
```

