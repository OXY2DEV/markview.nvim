---@meta

---------------------------------------------------------------
--- For the init.lua file
---------------------------------------------------------------

--- Definition for the table passed into setup()
---@class markview.config.user
---
--- List of custom highlight groups
---@field highlight_groups table[]?
---
--- List of filetypes where the plugin will be active
---@field filetypes string[]
---
--- List of buffer types to ignore
---@field buf_ignore string[]?
--- 
--- List of modes where the plugin will be active
---@field modes string[]?
---
--- List of modes where both raw & preview is shown
---@field hybrid_modes string[]?
---
--- Max number of lines in a file to do full rendering
---@field max_length number?
---
--- Number of lines to render on partial render mode
---@field render_range number?
---
--- Callbacks for plugin states
---@field callbacks markview.config.callbacks?
---
--- Table for heading configuration
---@field headings markview.render_config.headings?
---
--- Table for code block configuration
---@field code_blocks markview.render_config.code_blocks?
---
--- Table for block quotes configuration
---@field block_quotes markview.render_config.block_quotes?
---
--- Table for horizontal rule configuration
---@field horizontal_rules markview.render_config.hrs?
---
--- Table for hyperlink configuration
---@field links markview.render_config.links?
---
--- Table for inline codes configuration
---@field inline_codes markview.render_config.inline_codes?
---
--- Table for list item configuration
---@field list_items markview.render_config.list_items?
---
--- Table for list item configuration
---@field checkboxes markview.render_config.checkboxes?
---
--- Table for table configuration
---@field tables markview.render_config.tables?


--- Definition for the complete configuration table
---@class markview.config
---
--- List of custom highlight groups
---@field highlight_groups table[]?
---
--- List of filetypes where the plugin will be active
---@field filetypes string[]
---
--- List of buffer types to ignore
---@field buf_ignore string[]?
--- 
--- List of modes where the plugin will be active
---@field modes string[]
---
--- List of modes where both raw & preview is shown
---@field hybrid_modes string[]?
---
--- Max number of lines in a file to do full rendering
---@field max_length number?
---
--- Number of lines to render on partial render mode
---@field render_range number?
---
--- Options for various plugins states
---@field callbacks markview.config.callbacks
---
--- Table for heading configuration
---@field headings markview.render_config.headings
---
--- Table for code block configuration
---@field code_blocks markview.render_config.code_blocks
---
--- Table for block quotes configuration
---@field block_quotes markview.render_config.block_quotes
---
--- Table for horizontal rule configuration
---@field horizontal_rules markview.render_config.hrs
---
--- Table for hyperlink configuration
---@field links markview.render_config.links
---
--- Table for inline code configuration
---@field inline_codes markview.render_config.inline_codes
---
--- Table for list item configuration
---@field list_items markview.render_config.list_items
---
--- Table for checkbox configuration
---@field checkboxes markview.render_config.checkboxes
---
--- Table for table configuration
---@field tables markview.render_config.tables


--- Definition for the plugin callbacks
---@class markview.config.callbacks
---
---@field on_enable function?
---
---@field on_disable function?
---
---@field on_mode_change function?

---------------------------------------------------------------
--- For rendering things
---------------------------------------------------------------


--- Definition for the configuration table for the custom headings
---@class markview.render_config.headings
---
--- Enable/Disable stylized headings
---@field enable boolean?
---
--- Fallback textoff value
---@field textoff? number
---
--- Number of characters to shift per heading level
---@field shift_width number?
---
---@field heading_1 markview.render_config.headings.h?
---@field heading_2 markview.render_config.headings.h?
---@field heading_3 markview.render_config.headings.h?
---@field heading_4 markview.render_config.headings.h?
---@field heading_5 markview.render_config.headings.h?
---@field heading_6 markview.render_config.headings.h?


--- Definition for the individual heading configuration table
---@class markview.render_config.headings.h
---
--- Name of the style to use
---@field style string
---
--- Alignment for label styled headings
---@field align? string
---
--- Default highlight group used by the rest of the options
--- Used for highlighting the line when the style is "simple"
---@field hl string?
---
--- Character added before the heading name to separate heading levels
---@field shift_char string?
---
--- Highlight group for shift_char
---@field shift_hl string?
---
--- Sets the character to use as the sign, preferably 2 characters
---@field sign string?
---
--- The highlight group for the sign, inherits from hl if nil
---@field sign_hl string?
---
--- The icon to use for the heading
---@field icon string?
---
--- Highlight group for the icon
---@field icon_hl string?
---
--- Custom text for the heading. The heading text is used when nil
---@field text string?
---
--- Highlight group for the heading text, inherits from icon_hl
---@field text_hl string?
---
--- Used bu the "label" style to add text before the left padding
---@field corner_left string?
---
--- Highlight group for the left corner
---@field corner_left_hl string?
---
--- Used bu the "label" style to add text after the right padding
---@field corner_right string?
---
--- Highlight group for the right corner
---@field corner_right_hl string?
---
--- Used bu the "label" style to add text before the heading text
---@field padding_left string?
---
--- Highlight group for the left padding
---@field padding_left_hl string?
---
--- Used bu the "label" style to add text after the heading text
---@field padding_right string?
---
--- Highlight group for the left padding
---@field padding_right_hl string?
---
--- Character for underline on setext headings
---@field line string?
---
--- Highlight group for underline, when nil hl is used
---@field line_hl string?



--- Definition for the configuration table for the custom code blocks
---@class markview.render_config.code_blocks
---
--- Enable/Disable custom code blocks
---@field enable boolean?
---
--- Name of the style to use
---@field style string
---
--- Used for disabling icons on language view
---@field icons boolean?
---
--- Default highlight group used by the rest of the options
--- Used for highlighting the lines when the style is "simple"
---@field hl string?
---
--- Highlight group for the info string
---@field info_hl string?
---
--- The minimum number of columns to take(without the paddings)
---@field min_width number
---
--- Character to use as padding for the code blocks
---@field pad_char string?
---
--- Number of characters to use for the left and right padding
---@field pad_amount number?
---
--- List of tuples to map the identifier for the code block to
--- an actual language name. E.g. cpp » c++
---
--- The first value is what will be matched and the second value
--- is what will be used
---@field language_names [string, string][]?
---
--- Highlight group to color the language name. When nil uses the
--- icon's highlight group
---@field name_hl string?
---
--- The direction where the language name & icon is shown in the
--- "language" style
---@field language_direction string?
---
--- "virt_text_pos" value for the top & bottom border
---@field position string?
---
--- Enable/Disable the code block sign
---@field sign boolean?
---
--- The highlight group for the signs. When nil, the icon's highlight
--- group is used
---@field sign_hl string?


--- Definition for the configuration table for the custom block quotes
---@class markview.render_config.block_quotes
---
--- Enable/Disable custom block quotes
---@field enable boolean?
---
--- Default configuration for block quotes and unsupported callouts
---@field default { border: string | string[], border_hl: string | string[] }
---
--- List of configuration for various callouts
---@field callouts markview.render_config.block_quotes.callouts[]?


--- Definition for the configuration table for various callouts
---@class markview.render_config.block_quotes.callouts
---
--- String to match to detect the callout, this is not case-sensitive
---@field match_string string|string[]
---
--- The text to show for the callout
---@field callout_preview string
---
---@field callout_preview_hl string?
--- Highlight group for callout_preview
---
--- Adds support for custom titles(when available)
--- Custom title are colored using callout_preview_hl
---@field custom_title boolean?
---
--- Icon to use for custom title
---@field custom_icon string?
---
--- Border for the callout
---@field border string | string[]
---
--- Highlight group for border
---@field border_hl string | string[]


--- Definition for the configuration table for the custom horizontal rules
---@class markview.render_config.hrs
---
--- Enable/Disable custom block quotes
---@field enable boolean?
---
--- Parts used to make the horizontal rule
---@field parts markview.render_config.hr.parts[]


--- Configuration table for the parts of the horizontal rule
---@class markview.render_config.hr.parts
---
--- The type name for the part
---@field type string
---
--- The number of times to repeat "text" 
---@field repeat_amount (number | function)?
---
--- The direction for the gradient
---@field direction string?
---
--- The text used to construct the part
--- It's directly used if style is "text"
---@field text (string | string[])?
---
--- Highlight group for text
---@field hl (string | string[])?


--- Configuration table for custom hyperlinks & image links
---@class markview.render_config.links
---
--- Enable/Disable custom hyperlink
---@field enable boolean?
---
---@field hyperlinks markview.render_config.links.hyperlink
---
---@field images markview.render_config.links.link
---
---@field emails markview.render_config.links.link


--- Configuration table for various link types
---@class markview.render_config.links.hyperlink
---
---@field custom? markview.render_config.links.link[]
---
--- Default highlight group for the various parts
---@field hl string?
---
--- The icon to use for the heading
---@field icon string?
---
--- Highlight group for the icon
---@field icon_hl string?
---
--- Used bu the "label" style to add text before the left padding
---@field corner_left string?
---
--- Highlight group for the left corner
---@field corner_left_hl string?
---
--- Used bu the "label" style to add text after the right padding
---@field corner_right string?
---
--- Highlight group for the right corner
---@field corner_right_hl string?
---
--- Used bu the "label" style to add text before the heading text
---@field padding_left string?
---
--- Highlight group for the left padding
---@field padding_left_hl string?
---
--- Used bu the "label" style to add text after the heading text
---@field padding_right string?
---
--- Highlight group for the left padding
---@field padding_right_hl string?


--- Configuration table for various link types
---@class markview.render_config.links.link
---
--- Only for custom hyperlinks. Match string
---@field match? string
---
--- Default highlight group for the various parts
---@field hl string?
---
--- The icon to use for the heading
---@field icon string?
---
--- Highlight group for the icon
---@field icon_hl string?
---
--- Used bu the "label" style to add text before the left padding
---@field corner_left string?
---
--- Highlight group for the left corner
---@field corner_left_hl string?
---
--- Used bu the "label" style to add text after the right padding
---@field corner_right string?
---
--- Highlight group for the right corner
---@field corner_right_hl string?
---
--- Used bu the "label" style to add text before the heading text
---@field padding_left string?
---
--- Highlight group for the left padding
---@field padding_left_hl string?
---
--- Used bu the "label" style to add text after the heading text
---@field padding_right string?
---
--- Highlight group for the left padding
---@field padding_right_hl string?


--- Configuration table for custom inline codes
---@class markview.render_config.inline_codes
---
--- Enable/Disable custom inline codes
---@field enable boolean?
---
--- Default highlight group for the various parts
---@field hl string?
---
--- Used bu the "label" style to add text before the left padding
---@field corner_left string?
---
--- Highlight group for the left corner
---@field corner_left_hl string?
---
--- Used bu the "label" style to add text after the right padding
---@field corner_right string?
---
--- Highlight group for the right corner
---@field corner_right_hl string?
---
--- Used bu the "label" style to add text before the heading text
---@field padding_left string?
---
--- Highlight group for the left padding
---@field padding_left_hl string?
---
--- Used bu the "label" style to add text after the heading text
---@field padding_right string?
---
--- Highlight group for the left padding
---@field padding_right_hl string?


--- Configuration table for the custom list items
---@class markview.render_config.list_items
---
--- Enable/Disable custom list items
---@field enable boolean?
---
--- Indent size of list items
---@field indent_size number?
---
--- Number of characters to shift per level
---@field shift_width number?
---
--- Configuration for the + list item
---@field marker_plus markview.render_config.list_items.item?
---
--- Configuration for the - list item
---@field marker_minus markview.render_config.list_items.item?
---
--- Configuration for the * list item
---@field marker_star markview.render_config.list_items.item?
---
--- Configuration for the . list item
---@field marker_dot markview.render_config.list_items.item?


--- Configuration table for various list items
---@class markview.render_config.list_items.item
---
--- Enable/Disable indent based padding for lists
---@field add_padding boolean?
---
--- Custom marker for list item
---@field text string?
---
--- Highlight group for text
---@field hl string?


--- Configuration table for custom checkbox
---@class markview.render_config.checkboxes
---
--- Enable/Disable custom checkbox
---@field enable boolean?
---
--- Configuration table for the checked state
---@field checked markview.render_config.checkbox.state
---
--- Configuration table for the pending state
---@field pending markview.render_config.checkbox.state
---
--- Configuration table for the unchecked state
---@field unchecked markview.render_config.checkbox.state
---
--- Configuration table for the unchecked state
---@field custom markview.render_config.checkbox.state[]?


--- Configuration table for the checkbox state
---@class markview.render_config.checkbox.state
---
--- The text inside [] checkboxes to match
---@field match string?
---
--- Text to use as the custom checkbox
---@field text string
---
--- Highlight group for text
---@field hl string?


--- Configuration table for custom tables
---@class markview.render_config.tables
---
--- Enable/Disable custom table
---@field enable boolean?
---
--- Enable/Disable the usage of virtual lines for the top/bottom border
---@field use_virt_lines boolean?
---
--- Enable/Disable the usage of the top & bottom border
---@field block_decorator boolean?
---
--- List of various parts for the table
---@field text string[]
---
--- List of highlight groups for text
---@field hl string[]
