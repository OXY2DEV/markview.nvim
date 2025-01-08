local languages = {};

--- Table for icon & sign highlight group
---@type { [string]: string[]} }
languages.hls = {
	default   = { "MarkviewIcon5", "MarkviewIcon5Sign" },

	["c"]     = { "MarkviewIcon5", "MarkviewIcon5Sign" },
	["cpp"]   = { "MarkviewIcon5", "MarkviewIcon5Sign" },
	["java"]  = { "MarkviewIcon1", "MarkviewIcon1Sign" },
	["py"]    = { "MarkviewIcon2", "MarkviewIcon2Sign" },
	["js"]    = { "MarkviewIcon3", "MarkviewIcon3Sign" },
	["ts"]    = { "MarkviewIcon5", "MarkviewIcon5Sign" },
	["rb"]    = { "MarkviewIcon1", "MarkviewIcon1Sign" },
	["php"]   = { "MarkviewIcon6", "MarkviewIcon6Sign" },
	["cs"]    = { "MarkviewIcon5", "MarkviewIcon5Sign" },
	["swift"] = { "MarkviewIcon2", "MarkviewIcon2Sign" },
	["kt"]    = { "MarkviewIcon6", "MarkviewIcon6Sign" },
	["go"]    = { "MarkviewIcon5", "MarkviewIcon5Sign" },
	["rs"]    = { "MarkviewIcon2", "MarkviewIcon2Sign" },
	["r"]     = { "MarkviewIcon5", "MarkviewIcon5Sign" },
	["pl"]    = { "MarkviewIcon5", "MarkviewIcon5Sign" },
	["lua"]   = { "MarkviewIcon5", "MarkviewIcon5Sign" },
	["sh"]    = { "MarkviewIcon4", "MarkviewIcon4Sign" },
	["bash"]  = { "MarkviewIcon4", "MarkviewIcon4Sign" },
	["ps1"]   = { "MarkviewIcon6", "MarkviewIcon6Sign" },
	["scala"] = { "MarkviewIcon1", "MarkviewIcon1Sign" },
	["hs"]    = { "MarkviewIcon6", "MarkviewIcon6Sign" },
	["jl"]    = { "MarkviewIcon5", "MarkviewIcon5Sign" },
	["clj"]   = { "MarkviewIcon4", "MarkviewIcon4Sign" },
	["dart"]  = { "MarkviewIcon5", "MarkviewIcon5Sign" },
	["grrovy"]= { "MarkviewIcon6", "MarkviewIcon6Sign" },
	["erl"]   = { "MarkviewIcon1", "MarkviewIcon1Sign" },
	["ex"]    = { "MarkviewIcon6", "MarkviewIcon6Sign" },
	["elm"]   = { "MarkviewIcon5", "MarkviewIcon5Sign" },
	["f90"]   = { "MarkviewIcon6", "MarkviewIcon6Sign" },
	["ml"]    = { "MarkviewIcon2", "MarkviewIcon2Sign" },
	["sql"]   = { "MarkviewIcon5", "MarkviewIcon5Sign" },
	["p"]     = { "MarkviewIcon6", "MarkviewIcon6Sign" },
	["nim"]   = { "MarkviewIcon3", "MarkviewIcon3Sign" },
	["coffee"]= { "MarkviewIcon2", "MarkviewIcon2Sign" },
	["fs"]    = { "MarkviewIcon5", "MarkviewIcon5Sign" },
	["hx"]    = { "MarkviewIcon2", "MarkviewIcon2Sign" },
	["asp"]   = { "MarkviewIcon6", "MarkviewIcon6Sign" },
	["cl"]    = { "MarkviewIcon4", "MarkviewIcon4Sign" },
	["gd"]    = { "MarkviewIcon5", "MarkviewIcon5Sign" },
	["glsl"]  = { "MarkviewIcon4", "MarkviewIcon4Sign" },
	["h"]     = { "MarkviewIcon6", "MarkviewIcon6Sign" },
	["hpp"]   = { "MarkviewIcon6", "MarkviewIcon6Sign" },
	["hrl"]   = { "MarkviewIcon6", "MarkviewIcon6Sign" },
	["mjs"]   = { "MarkviewIcon4", "MarkviewIcon4Sign" },
	["md"]    = { "MarkviewIcon6", "MarkviewIcon6Sign" },
	["styl"]  = { "MarkviewIcon4", "MarkviewIcon4Sign" },
	["toml"]  = { "MarkviewIcon1", "MarkviewIcon1Sign" },
	["vim"]   = { "MarkviewIcon4", "MarkviewIcon4Sign" },
	["wxs"]   = { "MarkviewIcon3", "MarkviewIcon3Sign" },
	["yaml"]  = { "MarkviewIcon6", "MarkviewIcon6Sign" },
	["zsh"]   = { "MarkviewIcon4", "MarkviewIcon4Sign" },
	["exs"]   = { "MarkviewIcon6", "MarkviewIcon6Sign" },
	["fnl"]   = { "MarkviewIcon3", "MarkviewIcon3Sign" },
	["gsl"]   = { "MarkviewIcon4", "MarkviewIcon4Sign" },
	["gs"]    = { "MarkviewIcon5", "MarkviewIcon5Sign" },
	["scss"]  = { "MarkviewIcon2", "MarkviewIcon2Sign" },
	["zig"]   = { "MarkviewIcon3", "MarkviewIcon3Sign" },
	["html"]  = { "MarkviewIcon1", "MarkviewIcon1Sign" },
	["css"]   = { "MarkviewIcon5", "MarkviewIcon5Sign" },
};

--- Icons table for various filetypes
---@type { [string]: string }
languages.icons = {
	default = "󰈮 ",

	["c"] = " ",
	["cpp"] = " ",
    ["java"] = " ",
    ["py"] = " ",
    ["js"] = " ",
    ["ts"] = " ",
    ["rb"] = " ",
    ["php"] = " ",
    ["cs"] = " ",
    ["swift"] = " ",
    ["kt"] = " ",
    ["go"] = " ",
    ["rs"] = " ",
    ["r"] = "󰟔 ",
    ["pl"] = " ",
    ["lua"] = " ",
    ["sh"] = " ",
    ["bash"] = " ",
    ["ps1"] = "󰨊 ",
    ["scala"] = " ",
    ["hs"] = "󰲒 ",
    ["jl"] = " ",
    ["clj"] = " ",
    ["dart"] = " ",
    ["groovy"] = " ",
    ["erl"] = " ",
    ["ex"] = "",
    ["elm"] = " ",
    ["f90"] = "󱈚 ",
    ["ml"] = " ",
    ["sql"] = " ",
    ["p"] = " ",
    ["nim"] = " ",
    ["coffee"] = " ",
    ["fs"] = " ",
    ["hx"] = " ",
    ["asp"] = "󰪮 ",
    ["cl"] = " ",
    ["gd"] = " ",
    ["glsl"] = "󱓙 ",
    ["h"] = " ",
    ["hpp"] = " ",
    ["hrl"] = " ",
    ["mjs"] = "󰎙 ",
    ["md"] = " ",
    ["styl"] = " ",
    ["toml"] = " ",
    ["vim"] = " ",
    ["wxs"] = " ",
    ["yaml"] = " ",
    ["zsh"] = " ",
    ["exs"] = " ",
    ["fnl"] = " ",
    ["gsl"] = "󰿦 ",
    ["gs"] = "󰊭 ",
    ["scss"] = " ",
    ["zig"] = " ",
	["text"] = "󰗊 ",
	["htmx"] = " ",
	["json"] = "󰅩 ",
	["html"] = " ",
	["css"] = " "
};

---@type table<string, string> Language name to filetype mapping
languages.reverse_map = {
    ["c"] = "c",
    ["c_plus_plus"] = "cpp",
    ["java"] = "java",
    ["python"] = "py",
    ["javascript"] = "js",
    ["typescript"] = "ts",
    ["ruby"] = "rb",
    ["php"] = "php",
    ["c_sharp"] = "cs",
    ["swift"] = "swift",
    ["kotlin"] = "kt",
    ["go"] = "go",
    ["rust"] = "rs",
    ["r"] = "r",
    ["perl"] = "pl",
    ["lua"] = "lua",
    ["shell"] = "sh",
    ["powershell"] = "ps1",
    ["scala"] = "scala",
    ["haskell"] = "hs",
    ["visual_basic"] = "vb",
    ["julia"] = "jl",
    ["clojure"] = "clj",
    ["dart"] = "dart",
    ["groovy"] = "groovy",
    ["matlab"] = "m",
    ["erlang"] = "erl",
    ["elixir"] = "ex",
    ["elm"] = "elm",
    ["fortran"] = "f90",
    ["ocaml"] = "ml",
    ["verilog"] = "v",
    ["vhdl"] = "vhd",
    ["sql"] = "sql",
    ["ada"] = "adb",
    ["prolog"] = "p",
    ["tcl"] = "tcl",
    ["scheme"] = "scm",
    ["nim"] = "nim",
    ["awk"] = "awk",
    ["coffeescript"] = "coffee",
    ["f_sharp"] = "fs",
    ["pascal"] = "pas",
    ["haxe"] = "hx",
    ["haxe_shader_language"] = "hxsl",
    ["haxe_project"] = "hxproj",
    ["xquery"] = "x",
    ["idl"] = "idp",
    ["interface_definition_language"] = "idl",
    ["asp"] = "asp",
    ["lisp"] = "lsp",
    ["common_lisp"] = "cl",
    ["opencl"] = "cl",
    ["d"] = "d",
    ["gdscript"] = "gd",
    ["glsl"] = "glsl",
    ["c_header"] = "h",
    ["c_plus_plus_header"] = "hpp",
    ["erlang_header"] = "hrl",
    ["lisp_identifier"] = "lid",
    ["node_js_es_module"] = "mjs",
    ["markdown"] = "md",
    ["n"] = "n",
    ["processing"] = "pde",
    ["qml"] = "qml",
    ["red"] = "red",
    ["reason"] = "re",
    ["racket"] = "rkt",
    ["supercollider"] = "sc",
    ["solidity"] = "sol",
    ["smalltalk"] = "st",
    ["stylus"] = "styl",
    ["scheme_source"] = "sx",
    ["isabelle"] = "thy",
    ["toml"] = "toml",
    ["vala"] = "vala",
    ["vala_api"] = "vapi",
    ["vimscript"] = "vim",
    ["wix"] = "wxs",
    ["xslt"] = "xt",
    ["yaml"] = "yaml",
    ["zcml"] = "zcml",
    ["zenscript"] = "zs",
    ["zsh"] = "zsh",
    ["basic"] = "bas",
    ["batch"] = "bat",
    ["blitzmax"] = "bmx",
    ["boo"] = "boo",
    ["bluespec_systemverilog"] = "bsv",
    ["c2hs"] = "chs",
    ["clips"] = "clp",
    ["batch_script"] = "cmd",
    ["cobol"] = "cob",
    ["cobol_legacy"] = "cbl",
    ["camal"] = "cma",
    ["crmscript"] = "crm",
    ["eiffel"] = "e",
    ["eagle"] = "ea",
    ["emberscript"] = "em",
    ["elixir_script"] = "exs",
    ["f"] = "f",
    ["fennel"] = "fnl",
    ["g"] = "g",
    ["gds"] = "gd",
    ["gsl"] = "glf",
    ["google_apps_script"] = "gs",
    ["hcl"] = "hcl",
    ["haxe_project_file"] = "hxproj",
    ["agda"] = "lagda",
    ["lean"] = "lean",
    ["lassoscript"] = "ls",
    ["lasso"] = "lss",
    ["maxscript"] = "mc",
    ["mumps"] = "mu",
    ["myghty"] = "myt",
    ["runoff"] = "rno",
    ["sass"] = "scss",
    ["smarty"] = "tpl",
    ["ur"] = "ur",
    ["vbscript"] = "vbproj",
    ["wolfram"] = "wlk",
    ["xpl"] = "xpl",
    ["xquery_file"] = "xqy",
    ["xs"] = "xs",
    ["txt"] = "text",
};

---@type table<string, string> Filetype to language name mapping
languages.patterns = {
    ["c"] = "C",
    ["cpp"] = "C++",
    ["java"] = "Java",
    ["py"] = "Python",
    ["js"] = "JavaScript",
    ["ts"] = "TypeScript",
    ["rb"] = "Ruby",
    ["php"] = "PHP",
    ["cs"] = "C#",
    ["swift"] = "Swift",
    ["kt"] = "Kotlin",
    ["go"] = "Go",
    ["rs"] = "Rust",
    ["r"] = "R",
    ["pl"] = "Perl",
    ["lua"] = "Lua",
    ["sh"] = "Shell",
    ["ps1"] = "PowerShell",
    ["scala"] = "Scala",
    ["hs"] = "Haskell",
    ["vb"] = "Visual Basic",
    ["jl"] = "Julia",
    ["clj"] = "Clojure",
    ["dart"] = "Dart",
    ["groovy"] = "Groovy",
    ["m"] = "MATLAB",
    ["erl"] = "Erlang",
    ["ex"] = "Elixir",
    ["elm"] = "Elm",
    ["f90"] = "Fortran",
    ["ml"] = "OCaml",
    ["v"] = "Verilog",
    ["vhd"] = "VHDL",
    ["sql"] = "SQL",
    ["adb"] = "Ada",
    ["p"] = "Prolog",
    ["tcl"] = "Tcl",
    ["scm"] = "Scheme",
    ["nim"] = "Nim",
    ["awk"] = "AWK",
    ["coffee"] = "CoffeeScript",
    ["fs"] = "F#",
    ["pas"] = "Pascal",
    ["hx"] = "Haxe",
    ["hxsl"] = "Haxe Shader Language",
    ["hxproj"] = "Haxe Project",
    ["x"] = "XQuery",
    ["idp"] = "IDL",
    ["idl"] = "Interface Definition Language",
    ["ada"] = "Ada",
    ["asp"] = "ASP",
    ["lsp"] = "Lisp",
    ["cl"] = "Common Lisp",
    ["d"] = "D",
    ["g"] = "G",
    ["gd"] = "GDScript",
    ["glsl"] = "GLSL",
    ["h"] = "Header",
    ["hpp"] = "Header",
    ["hrl"] = "Header",
    ["lid"] = "Lisp Identifier",
    ["mjs"] = "Node.js ES Module",
    ["md"] = "Markdown",
    ["n"] = "N",
    ["pde"] = "Processing",
    ["qml"] = "QML",
    ["red"] = "Red",
    ["re"] = "Reason",
    ["rkt"] = "Racket",
    ["sc"] = "SuperCollider",
    ["sol"] = "Solidity",
    ["st"] = "Smalltalk",
    ["styl"] = "Stylus",
    ["sx"] = "Scheme Source",
    ["thy"] = "Isabelle",
    ["toml"] = "TOML",
    ["vala"] = "Vala",
    ["vapi"] = "Vala API",
    ["vim"] = "Vimscript",
    ["wxs"] = "WiX",
    ["xt"] = "XSLT",
    ["yaml"] = "YAML",
    ["yml"] = "YAML",
    ["zcml"] = "ZCML",
    ["zs"] = "ZenScript",
    ["zsh"] = "Zsh",
    ["bas"] = "BASIC",
    ["bat"] = "Batch",
    ["bmx"] = "BlitzMax",
    ["boo"] = "Boo",
    ["bsv"] = "Bluespec SystemVerilog",
    ["chs"] = "C2HS",
    ["clp"] = "CLIPS",
    ["cmd"] = "Batch script",
    ["cob"] = "COBOL",
    ["cbl"] = "COBOL",
    ["cma"] = "CAMAL",
    ["crm"] = "CrmScript",
    ["e"] = "Eiffel",
    ["ea"] = "Eagle",
    ["em"] = "EmberScript",
    ["exs"] = "Elixir",
    ["f"] = "F",
    ["fnl"] = "Fennel",
    ["glf"] = "GSL",
    ["gs"] = "Google Apps Script",
    ["hcl"] = "HCL",
    ["lagda"] = "Agda",
    ["lean"] = "Lean",
    ["ls"] = "LassoScript",
    ["lss"] = "Lasso",
    ["mc"] = "MAXScript",
    ["mu"] = "MUMPS",
    ["myt"] = "Myghty",
    ["rno"] = "RUNOFF",
    ["scss"] = "Sass",
    ["tpl"] = "Smarty",
    ["ur"] = "Ur",
    ["vbproj"] = "VBScript",
    ["wlk"] = "Wolfram",
    ["xpl"] = "XPL",
    ["xqy"] = "XQuery",
    ["xquery"] = "XQuery",
    ["xs"] = "XS",
    ["z"] = "Z",
	["css"] = "CSS",
	["html"] = "HTML"
};

--- Known language info string patterns
---@type string[]
languages.info_patterns = {
	-- {{ lang }} params
	"%{%{([^%}]*)%}%}%s*(.*)$",
	-- Myst code blocks (code, code-block, code-cell) with language
	-- https://mystmd.org/guide/code#code-blocks
	"%{code%S*%}%s*(%S+)$",
	-- Other {}-wrapped directive with unknown processing
	"%{([^%}]*)%}%s*(.*)$",
	-- Language string and additional info
	-- https://spec.commonmark.org/0.31.2/#example-143
	"(%S-)%s+(.*)$",
	-- Language string without additional info or no language
	-- https://spec.commonmark.org/0.31.2/#example-143
	"(%S*)%s*$",
}

--- Known code-block fences
---@type string[]
languages.fences = {"`", "~"}

--- Gets the language name from a string
---@param name string
---@return string
languages.get_name = function (name)
	if not name or name == "" then
		return "Unknown";
	elseif languages.patterns[name] then
		return languages.patterns[name];
	end

	local _u = string.gsub(name, "^%l", string.upper);
	return _u;
end

--- Gets the filetype from a string
---@param name string
---@return string
languages.get_ft = function (name)
	if not name or name == "" then
		return "Unknown";
	elseif languages.reverse_map[name] then
		return languages.reverse_map[name];
	else
		return name;
	end
end

--- Gets an icon from a filetype
---@param ft string
---@return string # The icon
---@return string # The icon's hl
---@return string # The sign's hl
languages.get_icon = function (ft)
	---@diagnostic disable-next-line
	local hl, sign = unpack(languages.hls[ft] or languages.hls.default);

	return languages.icons[ft] or languages.icons.default, hl, sign;
end

--- Extract fenced code block header
---@param line string
---@return string|nil fence the matched fence string
---@return string info the matched info string
languages.get_fence = function(line)
	for _, char in pairs(languages.fences) do
		--- Match any supported fence, optionnaly indented or quoted
		local fence, info = line:match("^>*%s*(" .. string.rep(char, 3) .. "+)%s*(.-)%s*$");
		if fence ~= nil then
			return fence, info;
		end
	end
	return nil, ""
end

--- Extract language and parameters from an infostring
---@param info string the info string to parse
---@return string language the extracted language
---@return string|nil # Some optional extra data
languages.info = function (info)
	for _, pattern in pairs(languages.info_patterns) do
		local lang, extra = info:match(pattern);
		if lang then
			return lang, extra;
		end
	end
end

return languages;
