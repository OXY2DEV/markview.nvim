# 🌋 Experimental options

>[!TIP]
> Type definitions are available in [definitions/experimental.lua]().

Options that don't belong in other groups or needs to be tested are added here,

```lua
---@type markview.config.experimental
experimental = {
    date_formats = {
        "^%d%d%d%d%-%d%d%-%d%d$",      --- YYYY-MM-DD
        "^%d%d%-%d%d%-%d%d%d%d$",      --- DD-MM-YYYY, MM-DD-YYYY
        "^%d%d%-%d%d%-%d%d$",          --- DD-MM-YY, MM-DD-YY, YY-MM-DD

        "^%d%d%d%d%/%d%d%/%d%d$",      --- YYYY/MM/DD
        "^%d%d%/%d%d%/%d%d%d%d$",      --- DD/MM/YYYY, MM/DD/YYYY

        "^%d%d%d%d%.%d%d%.%d%d$",      --- YYYY.MM.DD
        "^%d%d%.%d%d%.%d%d%d%d$",      --- DD.MM.YYYY, MM.DD.YYYY

        "^%d%d %a+ %d%d%d%d$",         --- DD Month YYYY
        "^%a+ %d%d %d%d%d%d$",         --- Month DD, YYYY
        "^%d%d%d%d %a+ %d%d$",         --- YYYY Month DD

        "^%a+%, %a+ %d%d%, %d%d%d%d$", --- Day, Month DD, YYYY
    },

    date_time_formats = {
        "^%a%a%a %a%a%a %d%d %d%d%:%d%d%:%d%d ... %d%d%d%d$", --- UNIX date time
        "^%d%d%d%d%-%d%d%-%d%dT%d%d%:%d%d%:%d%dZ$",           --- ISO 8601
    },

    prefer_nvim = false,
    file_open_command = "tabnew",

    list_empty_line_tolerance = 3,

    read_chunk_size = 1024,
}
```

## date_formats

- type: `string[]`
  [default value]()

Attributes,

- `YAML` preview.

A list of `lua patterns` to detect date strings in YAML.

## date_time_formats

- type: `string[]`
  [default value]()

Attributes,

- `YAML` preview.

A list of `lua patterns` to detect date & time strings in YAML.

## prefer_nvim

- type: `boolean`
  default: `false`

Attributes,

- `gx`, see [map_gx]().

Whether to prefer `Neovim` for opening text files.

## file_open_command

- type: `boolean`
  default: `tabnew`

Attributes,

- `gx`, see [map_gx]().

Command used for opening text files in Neovim(it will used as `<command> + file_name`.

## list_empty_line_tolerance

- type: `integer`
  default: `3`

Attributes,

- `markdown` preview, see [list_items]().

Maximum number of repeating empty lines a list item can have inside it.

>[!NOTE]
> The markdown parser will consider any number of lines(before another node) part of the list.
> This is meant to prevent indentation issues caused by this.

## read_chunk_size

- type: `integer`
  default: `1024`

Attributes,

- `gx`, see [map_gx]().

Number of `bytes` to read from a link's file to check if it's a text file.

>[!NOTE]
> This has no effect if [prefer_nvim](#-prefer_nvim) is set to `false`.

