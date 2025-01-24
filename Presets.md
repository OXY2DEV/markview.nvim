# 🧩 Presets

Pre-defined configurations to take inspiration from.

## 🔩 Usage

```lua
local presets = require("markview.presets");

require("markview").setup({
    markdown = {
        headings = presets.headings.glow
    }
});

--- You can again call `setup()` to modify
--- the options without changing the preset.
require("markview").setup({
    markdown = {
        headings = { shift_width = 1 }
    }
});
```

## 🔖 Heading presets

### 📚 Use:

```lua
local presets = require("markview.presets").headings;

require("markview").setup({
    markdown = {
        headings = presets.glow
    }
});
```

### 🌟 Showcase:

- glow

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/presets-headings.glow.png">

- glow_center

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/presets-headings.glow_center.png">

- slanted

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/presets-headings.slanted.png">

- arrowed

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/presets-headings.arrowed.png">

- simple

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/presets-headings.simple.png">

- marker

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/presets-headings.marker.png">

## 🔖 Horizontal rules presets

### 📚 Use:

```lua
local presets = require("markview.horizontal_rules").horizontal_rules;

require("markview").setup({
    markdown = {
        horizontal_rules = presets.arrowed
    }
});
```

### 🌟 Showcase:

- thin

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/presets-hr.thin.png">

- thick

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/presets-hr.thick.png">

- double

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/presets-hr.double.png">

- dashed

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/presets-hr.dashed.png">

- dotted

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/presets-hr.dotted.png">

- solid

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/presets-hr.solid.png">

- arrowed

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/presets-hr.arrowed.png">

## 🔖 Tables presets

### 📚 Use:

```lua
local presets = require("markview.presets").tables;

require("markview").setup({
    markdown = {
        tables = presets.none
    }
});
```

### 🌟 Showcase:

- none

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/presets-tables.none.png">

- single

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/presets-tables.single.png">

- double

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/presets-tables.double.png">

- rounded

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/presets-tables.rounded.png">

- solid

<img src="https://github.com/OXY2DEV/markview.nvim/blob/images/v25/wiki/presets-tables.solid.png">

------

Also available in vimdoc, `:h markview.nvim-presets`.

