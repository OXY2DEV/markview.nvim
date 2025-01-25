---@meta

--- HTML related stuff
local M = {};

-- [ Markview | HTML ] --------------------------------------------------------------------

--- Configuration table for HTML preview.
---@class config.html
---
---@field enable boolean
---
---@field container_elements html.container_elements | fun(): html.container_elements
---@field headings html.headings | fun(): html.headings
---@field void_elements html.void_elements | fun(): html.void_elements
M.html = {
	---+${lua}

	container_elements = {
		---+${lua}

		enable = true,

		---+${lua, Various inline elements used in markdown}

		["^b$"] = {
			on_opening_tag = { conceal = "" },
			on_node = { hl_group = "Bold" },
			on_closing_tag = { conceal = "" },
		},
		["^code$"] = {
			on_opening_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { " ", "MarkviewInlineCode" } } },
			on_node = { hl_group = "MarkviewInlineCode" },
			on_closing_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { " ", "MarkviewInlineCode" } } },
		},
		["^em$"] = {
			on_opening_tag = { conceal = "" },
			on_node = { hl_group = "@text.emphasis" },
			on_closing_tag = { conceal = "" },
		},
		["^i$"] = {
			on_opening_tag = { conceal = "" },
			on_node = { hl_group = "Italic" },
			on_closing_tag = { conceal = "" },
		},
		["^mark$"] = {
			on_opening_tag = { conceal = "" },
			on_node = { hl_group = "MarkviewPalette1" },
			on_closing_tag = { conceal = "" },
		},
		["^strong$"] = {
			on_opening_tag = { conceal = "" },
			on_node = { hl_group = "@text.strong" },
			on_closing_tag = { conceal = "" },
		},
		["^sub$"] = {
			on_opening_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "↓[", "MarkviewSubscript" } } },
			on_node = { hl_group = "MarkviewSubscript" },
			on_closing_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "]", "MarkviewSubscript" } } },
		},
		["^sup$"] = {
			on_opening_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "↑[", "MarkviewSuperscript" } } },
			on_node = { hl_group = "MarkviewSuperscript" },
			on_closing_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "]", "MarkviewSuperscript" } } },
		},
		["^u$"] = {
			on_opening_tag = { conceal = "" },
			on_node = { hl_group = "Underlined" },
			on_closing_tag = { conceal = "" },
		},

		---_
		---_
	},

	headings = {
		---+${lua}

		enable = true,

		heading_1 = {
			hl_group = "MarkviewPalette1Bg"
		},
		heading_2 = {
			hl_group = "MarkviewPalette2Bg"
		},
		heading_3 = {
			hl_group = "MarkviewPalette3Bg"
		},
		heading_4 = {
			hl_group = "MarkviewPalette4Bg"
		},
		heading_5 = {
			hl_group = "MarkviewPalette5Bg"
		},
		heading_6 = {
			hl_group = "MarkviewPalette6Bg"
		},

		---_
	},

	void_elements = {
		---+${lua}

		enable = true,

		---+${lua, Various void elements used in markdown}

		["^hr$"] = {
			on_node = {
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ "─", "MarkviewGradient2" },
					{ "─", "MarkviewGradient3" },
					{ "─", "MarkviewGradient4" },
					{ "─", "MarkviewGradient5" },
					{ " ◉ ", "MarkviewGradient9" },
					{ "─", "MarkviewGradient5" },
					{ "─", "MarkviewGradient4" },
					{ "─", "MarkviewGradient3" },
					{ "─", "MarkviewGradient2" },
				}
			}
		},
		["^br$"] = {
			on_node = {
				conceal = "",

				virt_text_pos = "inline",
				virt_text = {
					{ "󱞦", "Comment" },
				}
			}
		},

		---_

		---_
	}

	---_
};

-- [ Markview | HTML • Static ] -----------------------------------------------------------

--- Static configuration table for HTML preview.
---@class config.html_static
---
---@field enable boolean
---
--- Configuration for container elements.
---@field container_elements html.container_elements
---  Configuration for headings(e.g. `<h1>`).
---@field headings html.headings
--- Configuration for void elements.
---@field void_elements html.void_elements

-- [ HTML | Container elements ] ----------------------------------------------------------

--- HTML <container></container> element config.
---@class html.container_elements
---
---@field enable boolean
---@field [string] container_elements.opts | fun(buffer: integer, item: __html.container_elements): container_elements.opts
M.html_container_elements = {
    ---+${lua}

    enable = true,

    ---+${lua, Various inline elements used in markdown}

    ["^b$"] = {
        on_opening_tag = { conceal = "" },
        on_node = { hl_group = "Bold" },
        on_closing_tag = { conceal = "" },
    },
    ["^code$"] = {
        on_opening_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { " ", "MarkviewInlineCode" } } },
        on_node = { hl_group = "MarkviewInlineCode" },
        on_closing_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { " ", "MarkviewInlineCode" } } },
    },
    ["^em$"] = {
        on_opening_tag = { conceal = "" },
        on_node = { hl_group = "@text.emphasis" },
        on_closing_tag = { conceal = "" },
    },
    ["^i$"] = {
        on_opening_tag = { conceal = "" },
        on_node = { hl_group = "Italic" },
        on_closing_tag = { conceal = "" },
    },
    ["^mark$"] = {
        on_opening_tag = { conceal = "" },
        on_node = { hl_group = "MarkviewPalette1" },
        on_closing_tag = { conceal = "" },
    },
    ["^strong$"] = {
        on_opening_tag = { conceal = "" },
        on_node = { hl_group = "@text.strong" },
        on_closing_tag = { conceal = "" },
    },
    ["^sub$"] = {
        on_opening_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "↓[", "MarkviewSubscript" } } },
        on_node = { hl_group = "MarkviewSubscript" },
        on_closing_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "]", "MarkviewSubscript" } } },
    },
    ["^sup$"] = {
        on_opening_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "↑[", "MarkviewSuperscript" } } },
        on_node = { hl_group = "MarkviewSuperscript" },
        on_closing_tag = { conceal = "", hl_mode = "combine", virt_text_pos = "inline", virt_text = { { "]", "MarkviewSuperscript" } } },
    },
    ["^u$"] = {
        on_opening_tag = { conceal = "" },
        on_node = { hl_group = "Underlined" },
        on_closing_tag = { conceal = "" },
    },

    ---_
    ---_
};

-- [ HTML | Container elements • Static ] ----------------------------------------------------------

--- Static configuration for container elements.
---@class html.container_elements_static
---
---@field enable boolean Enables container element rendering.
---@field [string] container_elements.opts Configuration for <string></string>.
M.html_container_elements = {};

-- [ HTML | Container elements > Type definitions ] ---------------------------------------

--- Configuration table for a specific container element.
---@class container_elements.opts
---
---@field closing_tag_offset? fun(range: integer[]): integer[] Modifies the closing </tag>'s range.
---@field node_offset? fun(range: integer[]): integer[] Modifies the element's range.
---@field on_closing_tag? config.extmark | fun(tag: table): config.extmark Extmark configuration to use on the closing </tag>.
---@field on_node? config.extmark | fun(tag: table): config.extmark Extmark configuration to use on the element.
---@field on_opening_tag? config.extmark | fun(tag: table): config.extmark Extmark configuration to use on the opening <tag>.
---@field opening_tag_offset? fun(range: integer[]): integer[] Modifies the opening <tag>'s range.
M.html_container_elements_opts = {
	opening_tag_offset = function (range)
		range[2] = range[2] + 1;
		range[3] = range[3] - 1;

		return range;
	end,
	on_opening_tag = function ()
		return { hl_mode = "combine", hl_group = "Special" }
	end
};

-- [ HTML | Container elements > Parameters ] ---------------------------------------------

--- Parsed version of an HTML container element.
---@class __html.container_elements
---
---@field class "html_container_element"
---
---@field opening_tag __container.data Table containing information regarding the opening tag.
---@field closing_tag __container.data Table containing information regarding the closing tag.
---
---@field name string Tag name(in lowercase).
---
---@field text string[] Text of this node.
---@field range node.range Range of this node.
M.__html_container_elements = {
	class = "html_container_element",
	name = "p",
	text = {
		"<p>",
		"text</p>"
	},

	opening_tag = {
		text = "<p>",
		range = { 0, 0, 0, 3 }
	},
	closing_tag = {
		text = "</p>",
		range = { 1, 5, 1, 8 }
	},

	range = {
		row_start = 0,
		row_end = 1,
		col_start = 0,
		col_end = 8
	}
};

--- Container element segment data.
---@class __container.data
---
---@field text string Text inside this segment.
---@field range integer[] Range of this segment(Result of `{ TSNode:range() }`).
M.__conteiner_segment_opts = {
	text = "<p>",
	range = { 0, 0, 0, 3 }
};


-- [ HTML | Headings ] --------------------------------------------------------------------

--- HTML heading config.
---@class html.headings
---
---@field enable boolean
---@field [string] config.extmark | fun(buffer: integer, item: __html.headings): config.extmark
M.html_headings = {
	---+${lua}

	enable = true,

	heading_1 = {
		hl_group = "MarkviewPalette1Bg"
	},
	heading_2 = {
		hl_group = "MarkviewPalette2Bg"
	},
	heading_3 = {
		hl_group = "MarkviewPalette3Bg"
	},
	heading_4 = {
		hl_group = "MarkviewPalette4Bg"
	},
	heading_5 = {
		hl_group = "MarkviewPalette5Bg"
	},
	heading_6 = {
		hl_group = "MarkviewPalette6Bg"
	},

	---_
};

-- [ HTML | Headings • Static ] -----------------------------------------------------------

--- HTML heading config.
---@class html.headings_static
---
---@field enable boolean Enables heading rendering.
---@field [string] config.extmark Configuration for <h[n]></h[n]>.
M.html_headings = {
	enable = true,
	heading_1 = { fg = "#1e1e2e" }
};

-- [ HTML | Headings > Parameters ] --------------------------------------------------------

---@class __html.headings
---
---@field class "html_heading"
---@field level integer Heading level.
---@field range node.range
---@field text string[]
M.__html_headings = {
	class = "html_heading",
	level = 1,
	text = {
		"<h1>",
		"heading text",
		"</h1>"
	},
	range = {
		row_start = 0,
		col_start = 0,
		row_end = 2,
		col_end = 5
	}
};

-- [ HTML | Void elements ] ---------------------------------------------------------------

--- HTML <void> element config.
---@class html.void_elements
---
---@field enable boolean
---@field [string] void_elements.opts | fun(buffer: integer, item: __html.void_elements): void_elements.opts
M.html_void_elements = {
	enable = true,
	bold = {
		node_offset = function (range)
			return range;
		end,
		on_node = function ()
			return { fg = "#1e1e2e", bg = "#cdd6f4" }
		end
	}
};

-- [ HTML | Void elements • Static ] ------------------------------------------------------

--- Static configuration for void elements..
---@class html.void_elements
---
---@field enable boolean Enables void element rendering.
---@field [string] void_elements.opts Configuration for <string>.
M.html_void_elements = {
	enable = true,
	bold = {
		node_offset = function (range)
			return range;
		end,
		on_node = function ()
			return { fg = "#1e1e2e", bg = "#cdd6f4" }
		end
	}
};

-- [ HTML | Void elements > Type definition ] --------------------------------------------

--- Configuration table for a specific void element.
---@class void_elements.opts
---
---@field node_offset? fun(range: integer[]): table
---@field on_node config.extmark | fun(tag: __html.void_elements): config.extmark
M.html_void_elements_opts = {
	node_offset = function (range)
		return range;
	end,
	on_node = function ()
		return { fg = "#1e1e2e", bg = "#cdd6f4" }
	end
};

-- [ HTML | Void elements > Parameters ] --------------------------------------------------

--- Parsed version of a void element.
---@class __html.void_elements
---
---@field class "html_void_element"
---
---@field name string Element name(always in lowercase).
---
---@field text string[]
---@field range node.range
M.__html_void_elements = {
	class = "html_void_element",
	name = "img",
	text = {
		"<img src = './markview.jpg'>"
	},
	range = {
		row_start = 0,
		row_end = 0,
		col_start = 0,
		col_end = 27
	}
};

return M;
