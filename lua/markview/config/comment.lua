---@type markview.config.comment
return {
	enable = true,

	autolinks = {
		enable = true,

		default = {
			icon = "󰋽 ",
			hl = "MarkviewPalette6",
		},

		---|fS

		--NOTE(@OXY2DEV): Github sites.

		["github%.com/[%a%d%-%_%.]+%/?$"] = {
			--- github.com/<user>
			icon = " ",
			hl = "MarkviewPalette0Fg",

			text = function (_, item)
				return string.match(item.label, "github%.com/([%a%d%-%_%.]+)%/?$");
			end
		},
		["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/?$"] = {
			--- github.com/<user>/<repo>
			icon = "󰳐 ",
			hl = "MarkviewPalette0Fg",

			text = function (_, item)
				return string.match(item.label, "github%.com/([%a%d%-%_%.]+/[%a%d%-%_%.]+)%/?$");
			end
		},
		["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/tree/[%a%d%-%_%.]+%/?$"] = {
			--- github.com/<user>/<repo>/tree/<branch>
			icon = " ",
			hl = "MarkviewPalette0Fg",

			text = function (_, item)
				local repo, branch = string.match(item.label, "github%.com/([%a%d%-%_%.]+/[%a%d%-%_%.]+)/tree/([%a%d%-%_%.]+)%/?$");
				return repo .. " at " .. branch;
			end
		},
		["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+/commits/[%a%d%-%_%.]+%/?$"] = {
			--- github.com/<user>/<repo>/commits/<branch>
			icon = " ",
			hl = "MarkviewPalette0Fg",

			text = function (_, item)
				return string.match(item.label, "github%.com/([%a%d%-%_%.]+/[%a%d%-%_%.]+/commits/[%a%d%-%_%.]+)%/?$");
			end
		},

		["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/releases$"] = {
			--- github.com/<user>/<repo>/releases
			icon = " ",
			hl = "MarkviewPalette0Fg",

			text = function (_, item)
				return "Releases • " .. string.match(item.label, "github%.com/([%a%d%-%_%.]+/[%a%d%-%_%.]+)%/releases$");
			end
		},
		["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/tags$"] = {
			--- github.com/<user>/<repo>/tags
			icon = " ",
			hl = "MarkviewPalette0Fg",

			text = function (_, item)
				return "Tags • " .. string.match(item.label, "github%.com/([%a%d%-%_%.]+/[%a%d%-%_%.]+)%/tags$");
			end
		},
		["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/issues$"] = {
			--- github.com/<user>/<repo>/issues
			icon = " ",
			hl = "MarkviewPalette0Fg",

			text = function (_, item)
				return "Issues • " .. string.match(item.label, "github%.com/([%a%d%-%_%.]+/[%a%d%-%_%.]+)%/issues$");
			end
		},
		["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/pulls$"] = {
			--- github.com/<user>/<repo>/pulls
			icon = " ",
			hl = "MarkviewPalette0Fg",

			text = function (_, item)
				return "Pull requests • " .. string.match(item.label, "github%.com/([%a%d%-%_%.]+/[%a%d%-%_%.]+)%/pulls$");
			end
		},

		["github%.com/[%a%d%-%_%.]+/[%a%d%-%_%.]+%/wiki$"] = {
			--- github.com/<user>/<repo>/wiki
			icon = " ",
			hl = "MarkviewPalette0Fg",

			text = function (_, item)
				return "Wiki • " .. string.match(item.label, "github%.com/([%a%d%-%_%.]+/[%a%d%-%_%.]+)%/wiki$");
			end
		},

		--- NOTE(@OXY2DEV): Commonly used sites by programmers.

		["developer%.mozilla%.org"] = {
			priority = -9999,

			icon = "󰖟 ",
			hl = "MarkviewPalette5Fg"
		},

		["w3schools%.com"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette4Fg"
		},

		["stackoverflow%.com"] = {
			priority = -9999,

			icon = "󰓌 ",
			hl = "MarkviewPalette2Fg"
		},

		["reddit%.com"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette2Fg"
		},

		["github%.com"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette6Fg"
		},

		["gitlab%.com"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette2Fg"
		},

		["dev%.to"] = {
			priority = -9999,

			icon = "󱁴 ",
			hl = "MarkviewPalette0Fg"
		},

		["codepen%.io"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette6Fg"
		},

		["replit%.com"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette2Fg"
		},

		["jsfiddle%.net"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette5Fg"
		},

		["npmjs%.com"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette0Fg"
		},

		["pypi%.org"] = {
			priority = -9999,

			icon = "󰆦 ",
			hl = "MarkviewPalette0Fg"
		},

		["mvnrepository%.com"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette1Fg"
		},

		["medium%.com"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette6Fg"
		},

		["linkedin%.com"] = {
			priority = -9999,

			icon = "󰌻 ",
			hl = "MarkviewPalette5Fg"
		},

		["news%.ycombinator%.com"] = {
			priority = -9999,

			icon = " ",
			hl = "MarkviewPalette2Fg"
		},

		["neovim%.io/doc/user/.*#%_?.*$"] = {
			icon = " ",
			hl = "MarkviewPalette4Fg",

			text = function (_, item)
				local file, tag = string.match(item.label, "neovim%.io/doc/user/(.*)#%_?(.*)$");
				--- The actual website seems to show
				--- _ in the site name so, we won't
				--- be replacing `_`s with ` `s.
				file = string.gsub(file, "%.html$", "");

				return string.format("%s(%s) - Neovim docs", utils.normalize_str(file), tag);
			end
		},
		["neovim%.io/doc/user/.*$"] = {
			icon = " ",
			hl = "MarkviewPalette4Fg",

			text = function (_, item)
				local file = string.match(item.label, "neovim%.io/doc/user/(.*)$");
				file = string.gsub(file, "%.html$", "");

				return string.format("%s - Neovim docs", utils.normalize_str(file));
			end
		},

		["github%.com/vim/vim"] = {
			priority = -100,

			icon = " ",
			hl = "MarkviewPalette4Fg",
		},

		["github%.com/neovim/neovim"] = {
			priority = -100,

			icon = " ",
			hl = "MarkviewPalette4Fg",
		},

		["vim%.org"] = {
			icon = " ",
			hl = "MarkviewPalette4Fg",
		},

		["luals%.github%.io/wiki/?.*$"] = {
			icon = " ",
			hl = "MarkviewPalette5Fg",

			-- text = function (_, item)
			-- 	if string.match(item.label, "luals%.github%.io/wiki/(.-)/#(.+)$") then
			-- 		local page_mappings = {
			-- 			annotations = {
			-- 				["as"] = "@as",
			-- 				["alias"] = "@alias",
			-- 				["async"] = "@async",
			-- 				["cast"] = "@cast",
			-- 				["class"] = "@class",
			-- 				["deprecated"] = "@deprecated",
			-- 				["diagnostic"] = "@diagnostic",
			-- 				["enum"] = "@enum",
			-- 				["field"] = "@field",
			-- 				["generic"] = "@generic",
			-- 				["meta"] = "@meta",
			-- 				["module"] = "@module",
			-- 				["nodiscard"] = "@nodiscard",
			-- 				["operator"] = "@operator",
			-- 				["overload"] = "@overload",
			-- 				["package"] = "@package",
			-- 				["param"] = "@param",
			-- 				["see"] = "@see",
			-- 				["source"] = "@source",
			-- 				["type"] = "@type",
			-- 				["vaarg"] = "@vaarg",
			-- 				["version"] = "@version"
			-- 			}
			-- 		};
			--
			-- 		local page, section = string.match(item.label, "luals%.github%.io/wiki/(.-)/#(.+)$");
			--
			-- 		if page_mappings[page] and page_mappings[page][section] then
			-- 			section = page_mappings[page][section];
			-- 		else
			-- 			section = utils.normalize_str(string.gsub(section, "%-", " "));
			-- 		end
			--
			-- 		return string.format("%s(%s) | Lua Language Server", utils.normalize_str(page), section);
			-- 	elseif string.match(item.label, "") then
			-- 		local page = string.match(item.label, "luals%.github%.io/wiki/(.-)/?$");
			--
			-- 		return string.format("%s | Lua Language Server", utils.normalize_str(page));
			-- 	else
			-- 		return item.label;
			-- 	end
			-- end
		},

		---|fE
	},

	code_blocks = {
		enable = true,

		border_hl = "MarkviewCode",
		info_hl = "MarkviewCodeInfo",

		label_direction = "right",
		label_hl = nil,

		min_width = 60,
		pad_amount = 2,
		pad_char = " ",

		default = {
			block_hl = "MarkviewCode",
			pad_hl = "MarkviewCode"
		},

		["diff"] = {
			block_hl = function (_, line)
				if line:match("^%+") then
					return "MarkviewPalette4";
				elseif line:match("^%-") then
					return "MarkviewPalette1";
				else
					return "MarkviewCode";
				end
			end,
			pad_hl = "MarkviewCode"
		},

		style = "block",
		sign = true,
	},

	inline_codes = {
		padding_left = " ",
		padding_right = " ",

		hl = "MarkviewInlineCode",
	},

	issues = {
		enable = true,

		default = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰋽 ",

			hl = "MarkviewPalette6",
		},
	},

	mentions = {
		enable = true,

		default = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰋽 ",

			hl = "MarkviewPalette6",
		},
	},

	taglinks = {
		enable = true,

		default = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰋽 ",

			hl = "MarkviewPalette6",
		},
	},

	tasks = {
		enable = true,

		default = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰄰 ",

			hl = "MarkviewPalette1",
		},

		["^feat"] = {
			padding_left = " ",
			padding_right = " ",

			icon = "󱕅 ",

			hl = "MarkviewPalette7",
		},

		praise = {
			padding_left = " ",
			padding_right = " ",

			icon = "󱥋 ",

			hl = "MarkviewPalette3",
		},

		["^suggest"] = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰣖 ",

			hl = "MarkviewPalette2",
		},

		thought = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰧑 ",

			hl = "MarkviewPalette0",
		},

		note = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰠮 ",

			hl = "MarkviewPalette5",
		},

		["^info"] = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰋼 ",

			hl = "MarkviewPalette0",
		},

		xxx = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰓽 ",

			hl = "MarkviewPalette0",
		},

		["^nit"] = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰩰 ",

			hl = "MarkviewPalette6",
		},

		["^warn"] = {
			padding_left = " ",
			padding_right = " ",

			icon = " ",

			hl = "MarkviewPalette3",
		},

		fix = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰁨 ",

			hl = "MarkviewPalette7",
		},

		hack = {
			padding_left = " ",
			padding_right = " ",

			icon = "󱍔 ",

			hl = "MarkviewPalette1",
		},

		typo = {
			padding_left = " ",
			padding_right = " ",

			icon = " ",

			hl = "MarkviewPalette0",
		},

		wip = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰦖 ",

			hl = "MarkviewPalette2",
		},

		issue = {
			padding_left = " ",
			padding_right = " ",

			icon = " ",

			hl = "MarkviewPalette1",
		},

		["error"] = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰅙 ",

			hl = "MarkviewPalette1",
		},

		fixme = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰶯 ",

			hl = "MarkviewPalette4",
		},

		deprecated = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰩆 ",

			hl = "MarkviewPalette1",
		},
	},

	urls = {
		enable = true,

		default = {
			padding_left = " ",
			padding_right = " ",

			icon = "󰋽 ",

			hl = "MarkviewPalette6",
		},
	},
};
