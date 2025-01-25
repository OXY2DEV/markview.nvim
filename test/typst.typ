; Codes

#{
    let a = [from]
    let b = [*world*]
    [hello ]
    a + [ the ] + b
}

Inline: #{ a + [ the ] +
b }

; Escaped characters

\$ \# \& \. \|

; Headings

= Heading 1

== Heading 1

=== Heading 1

==== Heading 1

===== Heading 1

====== Heading 1

; Labels

This text has a <label>

; List items

- Item 1
+ Item 2
1. Item 3
  + Nest 1
  + Nest 2
  + Nest 3

; Math blocks

$
1 + 2 = 3
$

; Math spans

Some math inside a line, $1 + 2 = 3$.

; Raw blocks

```c
printf("Hello world!")
```

```html
<p>Hello world!</p>
```

```js
console.log("Hello world!");
```

```lua
vim.print("Hello world!");
```

```md
Hello *world!*
```

```py
print("Hello world!");
```

```ts
console.log("Hello world!");
```

```typ
Hello _world!_
```

; Reference links

@label

; Subscripts

$
a_{2+3}
$

; Superscripts

$
b^{4+5}
$

; Symbols

$
paren.l.double bracket.t shell.b fence.l
arrow.l.r.long
$

; Term

/ Term: Some term

; Urls

https://www.neovim.org

