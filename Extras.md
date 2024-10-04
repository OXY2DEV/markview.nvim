# Extra modules

## Heading level changer

Changes the heading level. Works with setext headings too!

Usage:

```lua
--- Increases heading level
require("markview.extras.headings").increase();

--- Decreases heading level
require("markview.extras.headings").decrease();
```

You can also make the module create commands for easy use.

```lua
require("markview.extras.headings").setup();
```

The module comes with 2 commands.

```vim
" Increases heading level
:HeadingIncrease

" Decreases heading level
:HeadingDecrease
```

## Checkbox state toggle

Toggles checkboxes and changes their states.

>[!Tip]
> This module can also be used with visual mode!

```lua
require("markview.extras.checkboxes").setup({
    --- When true, list item markers will
    --- be removed.
    remove_markers = true,

    --- If false, running the command on
    --- visual mode doesn't change the
    --- mode.
    exit = true,

    default_marker = "-",
    default_state = "X",

    --- A list of states
    states = {
        { " ", "X" },
        { "-", "o", "~" }
    }
});
```

You can then use this via the commands.

```vim
" Toggles checkboxes.
" Optional parameters,
"   {p_1}, When true, Also removes list item markers
"   {p_2}, When true, Exits visual mode
:CheckboxToggle {p_1} {p_2}

" Goes to next checkbox state.
" Optional parameters,
"   {p_1}, When true, Allows scrolling past the last item
"   in the set.
:CheckboxNext {p_1}

" Goes to previous checkbox state.
" Optional parameters,
"   {p_1}, When true, Allows scrolling past the first item
"   in the set.
:CheckboxPrev {p_1}

" Goes to next state set.
" Optional parameters,
"   {p_1}, When true, Allows scrolling past the last set.
:CheckboxNextSet {p_1}

" Goes to previous checkbox state.
" Optional parameters,
"   {p_1}, When true, Allows scrolling past the first set.
:CheckboxPrevSet {p_1}
```

## Code blocks editor

Create & edit code block in a floating window!

```lua
require("markview.extras.editor").setup({
    --- The minimum & maximum window width
    --- If the value is smaller than 1 then
    --- it is used as a % value.
    ---@type [ number, number ]
    width = { 10, 0.75 },

    --- The minimum & maximum window height
    ---@type [ number, number ]
    height = { 3, 0.75 },

    --- Delay(in ms) for window resizing
    --- when typing.
    ---@type integer
    debounce = 50,

    --- Callback function to run on
    --- the floating window.
    ---@type fun(buf:integer, win:integer): nil
    callback = function (buf, win)
    end
});
```

This will create 2 new commands.

```vim
" Creates a new code block
:CodeCreate

" Edits a code block
:CodeEdit
```

>[!Note]
> When **creating** a code block you can hit `<tab>` & `<S-tab>` in normal mode to change the start & end delimiter of the code block.

