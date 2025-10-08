---
author: "OXY2DEV"
---


; Block quotes


> A regular block quote.
> It spans across multiple lines.
>
> It also contains an empty line.

>[!ABSTRACT]

>[!SUMMARY]

>[!TLDR]

>[!TODO]

>[!INFO]

>[!SUCCESS]

>[!CHECK]

>[!DONE]

>[!QUESTION]

>[!HELP]

>[!FAQ]

>[!FAILURE]

>[!FAIL]

>[!MISSING]

>[!DANGER]

>[!ERROR]

>[!BUG]

>[!EXAMPLE]

>[!QUOTE]

>[!CITE]

>[!HINT]

>[!ATTENTION]


>[!NOTE]

>[!TIP]

>[!IMPORTANT]

>[!WARNING]

>[!CAUTION]


>[!ABSTRACT]
>
> >[!SUCCESS] Custom title
> >
> > >[!QUESTION]
> > >
> > > >[!FAILURE] Custom title
> > > >


; Code block

    Some text.
    Even more text!

```c Info string
printf("Hello world!")
```

```html A very long info string that will not fit here! And to be absolutely sure I will add a few more words.
<p>Hello world!</p>
```

``` sh
ls -la
```

```js
console.log("Hello world!");
```

```lua
vim.print("Hello world!");
```

```markdown
Hello *world!*
```

```py
print("Hello world!");
```

```ts
console.log("Hello world!");
```

```typst
Hello _world!_
```


; Headings


# Heading 1

## Heading 2

### Heading 3

#### Heading 4

##### Heading 5

###### Heading 6


Setext 1
========

Setext 2
--------


; Horizontal rules


---

; Reference definitions

[Test]: www.neovim.org

; List items


- Item 1
+ Item 2
* Item 3
    - Nest 1
    + Nest 2
    * Nest 3
        1. Nest 4
        2. Nest 5
    * [X] Nest 6
    + [-] Nest 7
    - [/] Nest 8


; Tables


| Normal | Left | Center | Right
|--------|:-----|:------:| --: |
| 1 | 2 | 3 | 4 |
| **Bold** | *italic* | ***Bold italic*** | `Inline code` |
| [Shortcut] | [Link](reddit.com) | ![Image](test.svg) | [[Internal]] |



