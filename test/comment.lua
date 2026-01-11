--[[
feat(@OXY2DEV): Tree-sitter parser for `Conventional comments`.

A `tree-sitter` parser for **conventional comments** that supports a subset of `markdown`.
It can be used as an injected language for other parsers(e.g. for comments).

The parser currently supports,

    • **Bold**
    • *Italic*
    • `Code`
    • 'Quoted_text'
    • "Double quoted text"
    • @mentions
    • issues/reference#52
    • https://example.com
    • |help-section|

```lua
print("Hello, world!");
```

With support for *common comment topics* such as,

todo: Some task.
FIXME: Fix some *issues*.

NOTE(grammar, @OXY2DEV): Add features to grammar.

Author: @OXY2DEV
]]
local a = 1;
