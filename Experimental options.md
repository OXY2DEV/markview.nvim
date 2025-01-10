# 🚨 Experimental options

Options that are still under development or don't affect core functionalities of `markview`.

```lua
---@class config.experimental
---
---@field file_open_command string Command used to open files inside Neovim.
---@field read_chunk_size integer Number of `bytes` to check before opening a link. Used for detecting when to open files inside Neovim.
---
---@field list_empty_line_tolerance integer Maximum number of empty lines that can stay between text of a list item.
---
---@field date_formats? string[] String formats for detecting date in YAML.
---@field date_time_formats? string[] String formats for detecting date & time in YAML
M.experimental = {
    file_open_command = "tabnew",
    read_chunk_size = 1000,

    list_empty_line_tolerance = 3,

    date_formats = { "%d%d-%d%d-%d%d%d%d" },
    date_time_formats = { "%d%d-%d%d-%d%d%d%d %d%d:%d%d [ap]?m" }
};
```

---

### file_open_command

- Type: `string`
- Dynamic: **true**
- Default: "tabnew"

Command used for opening links inside Neovim.

### read_chunk_size

- Type: `integer`
- Dynamic: **true**
- Default: 1000

>[!IMPORTANT]
> This isn't used if `text_filetypes` is set.

Number of **bytes** to check to determine if a file is a text file or not when opening links.

If the file is a text file, it will be opened inside `Neovim`.

### list_empty_line_tolerance

- Type: `integer`
- Dynamic: **true**
- Default: 3

Number of empty lines a list item can have between it's lines. Useful when adding text directly under a list.

```txt
TSNode │  Indentation  ┃            List                ┃
 range │     range     ┃            Item                ┃

   ╎           ║         - This is a list item.
   ╎           ║          It has some text inside it.
   ╎           ║         
   ╎           ║         
   ╎           ║          This line will be considered
   ╎           ║          part of the list.
   ╎                     
   ╎                     
   ╎                     
   ╎                      This line won't be considered
   ╎                      part of the list.
```

### date_formats

- Type: `string[]`
- Dynamic: **false**

List of `lua patterns` for detecting dates in YAML.

### date_time_formats

- Type: `string[]`
- Dynamic: **false**

List of `lua patterns` for detecting date & time in YAML.

