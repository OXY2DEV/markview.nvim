# 💻 Custom renderers

You can create your own renderers if you don't like the default ones.

```lua
require("markview").setup({
    renderers = {
        --- Custom renderer for YAML properties.
        ---@param ns integer Namespace to use for extmarks.
        ---@param buffer integer Buffer where 
        ---@param item table The parsed version of a node.
        yaml_property = function (ns, buffer, item)
            --- Do custom stuff.
        end
    }
});
```

>[!WARNING]
> A lot of items don't match their option names. E.g. `inline_link_hyperlink` & `inline_link_shortcut` are both configured via `hyperlinks`.

You can find the definitions for various items in `definitions/parsers/`.

>[!TIP]
> I highly recommend checking out the default renderers in `lua/markview/renderers` first.

Currently supported syntax items are,

- `html`
    + `html_container_element`
    + `html_heading`
    + `html_void_element`

- `latex`
    + `latex_block`
    + `latex_command`
    + `latex_escaped`
    + `latex_font`
    + `latex_inline`
    + `latex_parenthesis`
    + `latex_subscript`
    + `latex_superscript`
    + `latex_symbol`
    + `latex_text`
    + `latex_word`(used for applying text styles to a word)

- `markdown`
    + `markdown_atx_heading`
    + `markdown_block_quote`
    + `markdown_checkbox`(for `[x]`, `[X]`, `[ ]`)
    + `markdown_code_block`(for **fenced** code blocks)
    + `markdown_indented_code_block`(for **indented** code block)
    + `markdown_hr`(horizontal rule)
    + `markdown_link_ref_definition`
    + `markdown_list_item`
    + `markdown_metadata_minus`
    + `markdown_metadata_plus`
    + `markdown_section`(for Org-mode like heading indentation)
    + `markdown_setext_heading`
    + `markdown_table`

- `markdown_inline`
    + `inline_checkbox`
    + `inline_code_span`(inline codes)
    + `inline_entity`(HTML entity reference)
    + `inline_escaped`
    + `inline_footnote`
    + `inline_highlight`(PKM-like highlighted text)
    + `inline_emoji`(emoji shorthands)
    + `inline_link_block_ref`(obsidian's block reference link)
    + `inline_link_embed_file`(obsidian's embed file link)
    + `inline_link_email`
    + `inline_link_hyperlink`
    + `inline_link_image`
    + `inline_link_internal`(obsidian's internal links)
    + `inline_link_shortcut`(shortcut link)
    + `inline_link_uri_autolink`

- `typst`
    + `typst_code_block`
    + `typst_code_span`
    + `typst_emphasis`(used internally)
    + `typst_escaped`
    + `typst_heading`
    + `typst_label`
    + `typst_list_item`
    + `typst_link_ref`(reference link)
    + `typst_link_url`(URL links)
    + `typst_math_block`
    + `typst_math_span`
    + `typst_raw_block`
    + `typst_raw_span`
    + `typst_strong`(used internally)
    + `typst_subscript`
    + `typst_superscript`
    + `typst_symbol`
    + `typst_term`
    + `typst_text`(used for applying text styles to a word)

- `yaml`
    + `yaml_property`

------

Also available in vimdoc, `:h markview.nvim-renderers`

