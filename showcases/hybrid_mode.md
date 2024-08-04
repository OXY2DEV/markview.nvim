# Markview.nvim

An experimental markdown previewer for Neovim.

Hybrid mode:
A way to preview & edit at the same time
---

It is now possible to see previews as you type.

It works for all kinds of elements such as `inline codes`,
*italic*, **bold** etc.

It also works for block elements.

```lua
vim.print("Hello world");
```

>[!Tip]
> It can also work on nested elements.
>
> ```vim
> set scrolloff=0
> ```

It even works on list items,
- Item 1
- Item 2
  - Nested 1
  - Nested 2

---

<!---
    vim:nospell:tw=78:siso=0:cmdheight=0:
-->
