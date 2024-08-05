# Makrview.nvim

An experimental markdown previewer for Neovim.

## Basic html tag support

Markview.nvim supports some simple `html`.

For example,

- Bold:       <b>Example text</b>
- Strong:     <strong>Example text</strong>
- Underline:  <u>Example text</u>
- Italic:     <i>Example text</i>
- Emphasize:  <emphasize>Example text</emphasize>
- Marked:     <marked>Example text</marked>

These tags can also be used inside of your <u><i>Normal</i></u> text.

## Html entity support

Markview.nvim has basic support of `html entites`.

 &larr; &darr; &uarr; &rarr;

 &ang; &equiv; &int; &ge; &le; &gt; &lt; &infin; &isin; &empty;
 &frac12; &frac14; &frac34;

And a lot more symbols are also supported.

## Supported in tables

| Using tags in tables           | Using entites in tables   |
|:------------------------------:|---------------------------|
|     <u>Single</u> tag usage    | Single entity(&larr;)     |
| <u>Multi <b>tag</b></u> usage  | &ang; &frac34;            |
|                               =|=                          |
| You can also use both together:  <u>Underline</u> & &rang; |

>[!Note]
> Html support is exclusive to tables! Other block elements
> will render them as raw text.











<!--
    vim:nospell:cmdheight=0:
-->
