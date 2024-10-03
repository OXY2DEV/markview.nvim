# Links

![Links](https://github.com/OXY2DEV/markview.nvim/blob/images/Wiki/links.jpg)

```lua
links = {
    enable = true,

    --- Configuration for normal links
    hyperlinks = {
        enable = true,

        --- When true, link texts that start with an emoji
        --- won't have an icon in front of them.
        ---@type boolean
        __emoji_link_compatability = true,

        --- Icon to show.
        ---@type string?
        icon = "󰌷 ",

        --- Highlight group for the "icon".
        ---@type string?
        hl = "MarkviewHyperlink",

        --- Configuration for custom links.
        custom = {
            {
                --- Pattern of the address.
                ---@type string
                match_string = "stackoverflow%.com",

                --- Icon to show.
                ---@type string?
                icon = " ",

                --- Highlight group for the icon
                ---@type string?
                hl = nil
            },
            { match_string = "stackexchange%.com", icon = " " },
        }
    },

    images = {
        enable = true,

        --- When true, link texts that start with an emoji
        --- won't have an icon in front of them.
        ---@type boolean
        __emoji_link_compatability = true,

        --- Icon to show.
        ---@type string?
        icon = "󰥶 ",

        --- Highlight group for the "icon".
        ---@type string?
        hl = "MarkviewImageLink",

        --- Configuration for custom image links.
        custom = {
            {
                --- Pattern of the address.
                ---@type string
                match_string = "%.svg$",

                --- Icon to show.
                ---@type string?
                icon = "󰜡 ",

                --- Highlight group for the icon
                ---@type string?
                hl = nil
            },
        }
    },

    emails = {
        enable = true,

        --- Icon to show.
        ---@type string?
        icon = " ",

        --- Highlight group for the "icon".
        ---@type string?
        hl = "MarkviewEmail"

        --- Configuration for custom emails
        custom = {}
    },

    internal_links = {
        enable = true,

        --- When true, link texts that start with an emoji
        --- won't have an icon in front of them.
        __emoji_link_compatability = true,

        --- Icon to show.
        ---@type string?
        icon = " ",

        --- Highlight group for the "icon".
        ---@type string?
        hl = "MarkviewHyperlink",

        --- Configuration for custom internal links
        custom = {}
    }
}
```

