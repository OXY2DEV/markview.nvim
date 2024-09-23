local latex = {};
local utils = require("markview.utils");

--- Fixes a highlight group name
---@param hl string?
---@return string?
local set_hl = function (hl)
	if type(hl) ~= "string" then
		return;
	end

	if vim.fn.hlexists("Markview" .. hl) == 1 then
		return "Markview" .. hl;
	elseif vim.fn.hlexists("Markview_" .. hl) == 1 then
		return "Markview_" .. hl;
	else
		return hl;
	end
end

---@type table<string, string> Superscript text
latex.superscripts = {
	["0"] = "⁰",
	["1"] = "¹",
	["2"] = "²",
	["3"] = "³",
	["4"] = "⁴",
	["5"] = "⁵",
	["6"] = "⁶",
	["7"] = "⁷",
	["8"] = "⁸",
	["9"] = "⁹",

	["+"] = "⁺",
	["-"] = "⁻",
	["="] = "⁼",
	["("] = "⁽",
	[")"] = "⁾",

	[" "] = " ",
	["	"] = "	",

	["a"] = "ᵃ",
	["b"] = "ᵇ",
	["c"] = "ᶜ",
	["d"] = "ᵈ",
	["e"] = "ᵉ",
	["f"] = "ᶠ",
	["g"] = "ᵍ",
	["h"] = "ʰ",
	["i"] = "ⁱ",
	["j"] = "ʲ",
	["k"] = "ᵏ",
	["l"] = "ˡ",
	["m"] = "ᵐ",
	["n"] = "ⁿ",
	["o"] = "ᵒ",
	["p"] = "ᵖ",
	["q"] = "ᶣ",
	["r"] = "ʳ",
	["s"] = "ˢ",
	["t"] = "ᵗ",
	["u"] = "ᵘ",
	["v"] = "ᵛ",
	["w"] = "ʷ",
	["x"] = "ˣ",
	["y"] = "ʸ",
	["z"] = "ᶻ",

	["A"] = "ᵃ",
	["B"] = "ᵇ",
	["C"] = "ᶜ",
	["D"] = "ᵈ",
	["E"] = "ᵉ",
	["F"] = "ᶠ",
	["G"] = "ᵍ",
	["H"] = "ʰ",
	["I"] = "ⁱ",
	["J"] = "ʲ",
	["K"] = "ᵏ",
	["L"] = "ˡ",
	["M"] = "ᵐ",
	["N"] = "ⁿ",
	["O"] = "ᵒ",
	["P"] = "ᵖ",
	["Q"] = "ᶿ",
	["R"] = "ʳ",
	["S"] = "ˢ",
	["T"] = "ᵗ",
	["U"] = "ᵘ",
	["V"] = "ᵛ",
	["W"] = "ʷ",
	["X"] = "ˣ",
	["Y"] = "ʸ",
	["Z"] = "ᶻ",
};

---@type table<string, string | fun(buf: integer): string> Latex symbols
latex.symbols = {
	---+
	["year"] = function () return tostring(os.date("*t").year); end,
	["day"] = function () return tostring(os.date("*t").day); end,
	["today"] = function () return os.date("%d %B, %Y") --[[ @as string ]]; end,

	["to"] = "⟶",

	---+ ${class, Function names}
	["arccos"] = "𝚊𝚛𝚌𝚌𝚘𝚜",
	["arcsin"] = "𝚊𝚛𝚌𝚜𝚒𝚗",
	["arctan"] = "𝚊𝚛𝚌𝚝𝚊𝚗",
	["arg"] = "𝚊𝚛𝚐",
	["cos"] = "𝚌𝚘𝚜",
	["csc"] = "𝚌𝚜𝚌",
	["cosh"] = "𝚌𝚘𝚜𝚑",
	["cot"] = "𝚌𝚘𝚝",
	["coth"] = "𝚌𝚘𝚝𝚑",
	["deg"] = "𝚍𝚎𝚐",
	["det"] = "𝚍𝚎𝚝",
	["dim"] = "𝚍𝚒𝚖",
	["exp"] = "𝚎𝚡𝚙",
	["gcd"] = "𝚐𝚌𝚍",
	["hom"] = "𝚑𝚘𝚖",
	["inf"] = "𝚒𝚗𝚏",
	["ker"] = "𝚔𝚎𝚛",
	["lg"] = "𝚕𝚐",
	["lim"] = "𝚕𝚒𝚖",
	["liminf"] = "𝚕𝚒𝚖 𝚒𝚗𝚏",
	["limsup"] = "𝚕𝚒𝚖 𝚜𝚞𝚋",
	["ln"] = "𝚕𝚗",
	["log"] = "𝚕𝚘𝚐",
	["max"] = "𝚖𝚊𝚡",
	["min"] = "𝚖𝚒𝚗",
	["Pr"] = "𝙿𝚛",
	["sec"] = "𝚜𝚎𝚌",
	["sin"] = "𝚜𝚒𝚗",
	["sinh"] = "𝚜𝚒𝚗𝚑",
	["sup"] = "𝚜𝚞𝚙",
	["tan"] = "𝚝𝚊𝚗",
	["tanh"] = "𝚝𝚊𝚗𝚑",
	---_

	["#"] = "#",
	["$"] = "$",
	["%"] = "%",
	["_"] = "_",
	["{"] = "{",
	["}"] = "}",

	["lbrack"] = "[",
	["backslash"] = "\\",
	["rbracket"] = "]",
	["sphat"] = "^",
	["lbrace"] = "{",
	["vert"] = "|",
	["rbrace"] = "}",
	["sptilde"] = "~",

	["cent"] = "¢",
	["pounds"] = "£",
	["yen"] = "¥",

	["spddot"] = "¨",
	["neg"] = "¬",
	["circledR"] = "®",
	["pm"] = "±",
	["Micro"] = "µ",
	["times"] = "×",
	["eth"] = "ð",
	["div"] = "÷",

	["imath"] = "ı",
	["jmath"] = "ȷ",

	["grave"] = " ̀",
	["acute"] = " ́",
	["hat"] = " ̂",
	["tilde"] = " ̃",
	["bar"] = " ̄",
	["overline"] = " ̅",
	["breve"] = " ̆",
	["dot"] = " ̇",
	["ddot"] = " ̈",
	["mathring"] = " ̊",
	["check"] = " ̌",

	["utilde"] = " ̰",
	["underbar"] = " ̱",
	["underline"] = " ̲",

	["not"] = " ̸",

	["Gamma"] = "Γ",
	["Delta"] = "Δ",
	["Theta"] = "Θ",
	["Lambda"] = "Λ",
	["Xi"] = "Ξ",
	["Pi"] = "Π",
	["Sigma"] = "Σ",
	["Upsilon"] = "Υ",
	["Phi"] = "Φ",
	["Psi"] = "Ψ",
	["Omega"] = "Ω",

	["alpha"] = "α",
	["beta"] = "β",
	["gamma"] = "γ",
	["delta"] = "δ",
	["varepsilon"] = "ε",
	["zeta"] = "ζ",
	["eta"] = "η",
	["theta"] = "θ",
	["iota"] = "ι",
	["kappa"] = "κ",
	["lambda"] = "λ",
	["mu"] = "μ",
	["nu"] = "ν",
	["xi"] = "ξ",
	["pi"] = "π",
	["rho"] = "ρ",
	["varsigma"] = "ς",
	["sigma"] = "σ",
	["tau"] = "τ",
	["upsilon"] = "υ",
	["varphi"] = "φ",
	["chi"] = "χ",
	["psi"] = "ψ",
	["omega"] = "ω",
	["varbeta"] = "ϐ",
	["vartheta"] = "ϑ",
	["phi"] = "ϕ",
	["varpi"] = "ϖ",
	["Qoppa"] = "Ϙ",
	["qoppa"] = "ϙ",
	["Stigma"] = "Ϛ",
	["stigma"] = "ϛ",
	["Digamma"] = "Ϝ",
	["digamma"] = "ϝ",
	["Koppa"] = "Ϟ",
	["koppa"] = "ϟ",
	["Sampi"] = "Ϡ",
	["sampi"] = "ϡ",
	["varkappa"] = "ϰ",
	["varrho"] = "ϱ",
	["epsilon"] = "ϵ",
	["backepsilon"] = "϶",
	["Euler"] = "ℇ",

	["|"] = "‖",
	["dagger"] = "†",
	["ddagger"] = "‡",
	["bullet"] = "•",
	["ldots"] = "…",
	["prime"] = "′",
	["second"] = "″",
	["third"] = "‴",
	["fourth"] = "⁗",
	["backprime"] = "‵",
	["cat"] = "⁀",
	["lvec"] = "x⃐",
	["vec"] = "x⃑",
	["LVec"] = "x⃖",
	["Vec"] = "x⃗",
	["dddot"] = "x⃛",
	["ddddot"] = "x⃜",
	["overleftrightarrow"] = "x⃡",
	["underleftarrow"] = "x⃮",
	["underrightarrow"] = "x⃯",

	["lm"] = "ℑ",
	["ell"] = "ℓ",
	["wp"] = "℘",
	["re"] = "ℜ",
	["tcohm"] = "Ω",
	["mho"] = "℧",
	["Angstroem"] = "Å",
	["Finv"] = "Ⅎ",
	["hslash"] = "ℏ",
	["aleph"] = "ℵ",
	["beth"] = "ℶ",
	["gimel"] = "ℷ",
	["daleth"] = "ℸ",
	["Yup"] = "⅄",
	["invamp"] = "⅋",

	["CapitalDifferentialD"] = "ⅅ",
	["DifferentialD"] = "ⅆ",
	["DifferentialE"] = "ⅇ",
	["ComplexI"] = "ⅈ",
	["ComplexJ"] = "ⅉ",

	["mathbb_pi"] = "ℼ",
	["mathbb_Pi"] = "ℿ",
	["mathbb_Sigma"] = "⅀",
	["mathbb_gamma"] = "ℽ",
	["mathbb_Gamma"] = "ℾ",

	["leftarrow"] = "←",
	["uparrow"] = "↑",
	["rightarrow"] = "→",
	["downarrow"] = "↓",
	["leftrightarrow"] = "↔",
	["updownarrow"] = "↕",
	["nwarrow"] = "↖",
	["nearrow"] = "↗",
	["swarrow"] = "↙",
	["searrow"] = "↘",

	["nleftarrow"] = "↚",
	["nrightarrow"] = "↛",
	["twoheadleftarrow"] = "↞",
	["twoheadrightarrow"] = "↠",

	["leftarrowtail"] = "↢",
	["rightarrowtail"] = "↣",

	["mapsfrom"] = "↤",
	["MapsUp"] = "↥",
	["mapsto"] = "↦",
	["MapsDown"] = "↧",

	["hookleftarrow"] = "↩",
	["hookrightarrow"] = "↪",

	["looparrowleft"] = "↫",
	["looparrowright"] = "↬",

	["leftrightsquigarrow"] = "↭",
	["nleftrightarrow"] = "↮",

	["lightning"] = "↯",
	["Lsh"] = "↰",
	["Rsh"] = "↱",
	["dlsh"] = "↲",
	["drsh"] = "↳",

	["curvearrowleft"] = "↶",
	["curvearrowright"] = "↷",

	["circlearrowleft"] = "↺",
	["circlearrowright"] = "↻",

	["leftharpoonup"] = "↼",
	["upharpoonright"] = "↾",
	["upharpoonleft"] = "↿",
	["rightharpoonup"] = "⇀",
	["rightharpoondown"] = "⇁",
	["downharpoonright"] = "⇂",
	["downharpoonleft"] = "⇃",

	["rightleftarrows"] = "⇄",
	["updownarrows"] = "⇅",
	["leftrightarrows"] = "⇆",
	["downuparrows"] = "⇵",

	["leftleftarrows"] = "⇇",
	["upuparrows"] = "⇈",
	["rightrightarrows"] = "⇉",
	["downdownarrows"] = "⇊",

	["leftrightharpoons"] = "⇋",
	["rightleftharpoons"] = "⇌",

	["nLeftarrow"] = "⇍",
	["nLeftrightarrow"] = "⇎",
	["nRightarrow"] = "⇏",

	["Leftarrow"] = "⇐",
	["Uparrow"] = "⇑",
	["Rightarrow"] = "⇒",
	["Downarrow"] = "⇓",

	["Nwarrow"] = "⇖",
	["Nearrow"] = "⇗",
	["Swarrow"] = "⇘",
	["Searrow"] = "⇙",

	["Lleftarrow"] = "⇚",
	["Rrightarrow"] = "⇛",
	["leftsquigarrow"] = "⇜",
	["rightsquigarrow"] = "⇜",

	["dashleftarrow"] = "⇠",
	["dashrightarrow"] = "⇢",

	["LeftArrowBar"] = "⇤",
	["RightArrowBar"] = "⇥",

	["pfun"] = "⇸",
	["ffun"] = "⇻",

	["leftarrowtriangle"] = "⇽",
	["rightarrowtriangle"] = "⇾",
	["leftrightarrowtriangle"] = "⇿",

	["complement"] = "∁",
	["partial"] = "∂",
	["exists"] = "∃",
	["nexists"] = "∄",
	["varnothing"] = "∅",
	["nabla"] = "∇",
	["in"] = "∈",
	["notin"] = "∉",
	["ni"] = "∋",
	["nni"] = "∌",
	["prod"] = "∏",
	["coprod"] = "∐",
	["sum"] = "∑",
	["mp"] = "∓",
	["dotplus"] = "∔",
	["slash"] = "∕",
	["smallsetminus"] = "∖",
	["ast"] = "∗",
	["circ"] = "∘",

	["sqrt"] = "√",
	["sqrt_3"] = "∛",
	["sqrt_4"] = "∜",

	["propto"] = "∝",
	["infty"] = "∞",
	["rightangle"] = "∟",
	["angle"] = "∠",
	["measuredangle"] = "∡",
	["sphericalangle"] = "∢",
	["mid"] = "∣",
	["nmid"] = "∤",
	["parallel"] = "∥",
	["nparallel"] = "∦",
	["wedge"] = "∧",
	["vee"] = "∨",
	["cap"] = "∩",
	["cup"] = "∪",

	["int"] = "∫",
	["iint"] = "∬",
	["iiint"] = "∭",
	["oint"] = "∮",
	["oiint"] = "∯",
	["oiiint"] = "∰",
	["varointclockwise"] = "∲",
	["ointctrclockwise"] = "∳",

	["therefore"] = "∴",
	["because"] = "∵",
	["Proportion"] = "∷",
	["eqcolon"] = "∹",
	["sim"] = "∼",
	["nsim"] = "≁",
	["backsim"] = "∽",
	["AC"] = "∿",
	["wr"] = "≀",
	["eqsim"] = "≂",
	["simeq"] = "≃",
	["nsimeq"] = "≄",
	["cong"] = "≅",
	["ncong"] = "≇",
	["approx"] = "≈",
	["napprox"] = "≉",
	["approxeq"] = "≊",
	["asymp"] = "≍",

	["Bumpeq"] = "≎",
	["bumpeq"] = "≏",

	["doteq"] = "≐",
	["Doteq"] = "≑",
	["fallingdotseq"] = "≒",
	["risingdotseq"] = "≓",
	["coloneq"] = "≔",
	-- ["eqcolon"] = "≕", Name conflict
	["eqcirc"] = "≖",
	["circeq"] = "≗",
	["corresponds"] = "≙",
	["triangleq"] = "≜",
	["neq"] = "≠",
	["equiv"] = "≡",
	["nequiv"] = "≢",

	["leq"] = "≤",
	["geq"] = "≥",
	["leqq"] = "≦",
	["geqq"] = "≧",
	["lneqq"] = "≨",
	["gneqq"] = "≩",
	["ll"] = "≪",
	["gg"] = "≫",
	["between"] = "≬",
	["notasymp"] = "≭",
	["nless"] = "≮",
	["ngtr"] = "≯",
	["nleq"] = "≰",
	["ngeq"] = "≱",
	["lesssim"] = "≲",
	["gtrsim"] = "≳",
	["NotLessTilde"] = "≴",
	["NotGreaterTilde"] = "≵",
	["lessgtr"] = "≶",
	["gtrless"] = "≷",
	["NotGreaterLess"] = "≹",
	["prec"] = "≺",
	["succ"] = "≻",
	["preccurlyeq"] = "≼",
	["succcurlyeq"] = "≽",
	["precsim"] = "≾",
	["succsim"] = "≿",
	["nprec"] = "⊀",
	["nsucc"] = "⊁",

	["subset"] = "⊂",
	["supset"] = "⊃",
	["nsubset"] = "⊄",
	["nsupset"] = "⊅",
	["subseteq"] = "⊆",
	["supseteq"] = "⊇",
	["nsubseteq"] = "⊈",
	["nsupseteq"] = "⊉",
	["subsetneq"] = "⊊",
	["supsetneq"] = "⊋",
	["uplus"] = "⊎",

	["sqsubset"] = "⊏",
	["sqsupset"] = "⊐",
	["sqsubseteq"] = "⊑",
	["sqsupseteq"] = "⊒",
	["sqcap"] = "⊓",
	["sqcup"] = "⊔",

	["oplus"] = "⊕",
	["ominus"] = "⊖",
	["otimes"] = "⊗",
	["oslash"] = "⊘",
	["odot"] = "⊙",

	["circledcirc"] = "⊚",
	["circledast"] = "⊛",
	["circleddash"] = "⊝",

	["boxplus"] = "⊞",
	["boxminus"] = "⊟",
	["boxtimes"] = "⊠",
	["boxdot"] = "⊡",

	["vdash"] = "⊢",
	["dashv"] = "⊣",
	["top"] = "⊤",
	["bot"] = "⊥",
	["models"] = "⊧",
	["vDash"] = "⊨",
	["Vdash"] = "⊩",
	["Vvdash"] = "⊪",
	["VDash"] = "⊫",
	["nvdash"] = "⊬",
	["nvDash"] = "⊭",
	["nVdash"] = "⊮",
	["nVDash"] = "⊯",

	["vartriangleleft"] = "⊲",
	["vartriangleright"] = "⊳",
	["trianglelefteq"] = "⊴",
	["trianglerighteq"] = "⊵",

	["multimapdotbothA"] = "⊶",
	["multimapdotbothB"] = "⊷",
	["multimap"] = "⊸",

	["intercal"] = "⊺",
	["veebar"] = "⊻",
	["barwedge"] = "⊼",
	["bigwedge"] = "⋀",
	["bigvee"] = "⋁",
	["bigcap"] = "⋂",
	["bigcup"] = "⋃",
	["diamond"] = "⋄",
	["cdot"] = "⋅",
	["star"] = "*",
	["divideontimes"] = "⋇",
	["bowtie"] = "⋈",
	["ltimes"] = "⋉",
	["rtimes"] = "⋊",
	["leftthreetimes"] = "⋋",
	["rightthreetimes"] = "⋌",
	["backsimeq"] = "⋍",
	["curlyvee"] = "⋎",
	["curlywedge"] = "⋏",

	["Subset"] = "⋐",
	["Supset"] = "⋑",
	["Cap"] = "⋒",
	["Cup"] = "⋓",
	["pitchfork"] = "⋔",
	["hash"] = "⋕",
	["lessdot"] = "⋖",
	["gtrdot"] = "⋗",
	["lll"] = "⋘",
	["ggg"] = "⋙",
	["lesseqgtr"] = "⋚",
	["gtreqless"] = "⋛",
	["curlyeqprec"] = "⋞",
	["curlyeqsucc"] = "⋟",
	["npreceq"] = "⋠",
	["nsucceq"] = "⋡",
	["nsqsubseteq"] = "⋢",
	["nsqsupseteq"] = "⋣",
	["lnsim"] = "⋦",
	["gnsim"] = "⋧",
	["precnsim"] = "⋨",
	["succnsim"] = "⋩",
	["ntriangleleft"] = "⋪",
	["ntriangleright"] = "⋫",
	["ntrianglelefteq"] = "⋬",
	["ntrianglerighteq"] = "⋭",

	["vdots"] = "⋮",
	["cdots"] = "⋯",
	["iddots"] = "⋰",
	["ddots"] = "⋱",

	["barin"] = "⋶",
	["diameter"] = "⌀",
	["invdiameter"] = "⍉",

	["lceil"] = "⌈",
	["rceil"] = "⌉",
	["lfloor"] = "⌊",
	["rfloor"] = "⌋",
	["invneg"] = "⌐",
	["wasylozenge"] = "⌑",
	["ulcorner"] = "⌜",
	["urcorner"] = "⌝",
	["llcorner"] = "⌞",
	["lrcorner"] = "⌟",
	["frown"] = "⌢",
	["smile"] = "⌣",
	["APLinv"] = "⌹",

	["notslash"] = "⌿",
	["notbackslash"] = "⍀",
	["APLleftarrowbox"] = "⍇",
	["APLrightarrowbox"] = "⍈",
	["APLuparrowbox"] = "⍐",
	["APLdownarrowbox"] = "⍗",
	["APLcomment"] = "⍝",
	["APLinput"] = "⍞",
	["APLlog"] = "⍟",

	["overparen"] = "⏜",
	["underparen"] = "⏝",
	["overbrace"] = "⏞",
	["underbrace"] = "⏟",

	["bigtriangleup"] = "△",
	["blacktriangleup"] = "▴",
	["smalltriangleup"] = "▵",
	["RHD"] = "▶",
	["rhd"] = "▷",
	["blacktriangleright"] = "▸",
	["smalltriangleright"] = "▹",
	["bigtriangledown"] = "▽",
	["blacktriangledown"] = "▾",
	["smalltriangledown"] = "▿",
	["LHD"] = "◀",
	["lhd"] = "◁",
	["blacktriangleleft"] = "◂",
	["smalltriangleleft"] = "◃",
	["Diamondblack"] = "◆",
	["Diamond"] = "◇",
	["lozenge"] = "◊",
	["Circle"] = "○",
	["CIRCLE"] = "●",
	["LEFTcircle"] = "◐",
	["RIGHTcircle"] = "◑",
	["LEFTCIRCLE"] = "◖",
	["RIGHTCIRCLE"] = "◗",
	["boxbar"] = "◫",
	["square"] = "◻",
	["blacksquare"] = "◼",
	["bigstar"] = "★",
	["Sun"] = "☉",
	["Square"] = "☐",
	["CheckedBox"] = "☑",
	["XBox"] = "☒",
	["steaming"] = "☕",
	["pointright"] = "☞",
	["skull"] = "☠",
	["radiation"] = "☢",
	["biohazard"] = "☣",
	["yinyang"] = "☯",
	["frownie"] = "🙁",
	["smiley"] = "🙂",
	["sun"] = "☼",
	["rightmoon"] = "☽",
	["leftmoon"] = "☾",
	["swords"] = "⚔",
	["warning"] = "⚠",
	["pencil"] = "✎",
	["checkmark"] = "✓",
	["ballotx"] = "✗",
	["arrowbullet"] = "➢",

	["perp"] = "⟂",
	["Lbag"] = "⟅",
	["Rbag"] = "⟆",
	["Diamonddot"] = "⟐",
	["multimapinv"] = "⟜",
	["llbracket"] = "⟦",
	["rrbracket"] = "⟧",
	["langle"] = "⟨",
	["rangle"] = "⟩",
	["lang"] = "⟪",
	["rang"] = "⟫",
	["lgroup"] = "⟮",
	["rgroup"] = "⟯",

	["longleftarrow"] = "⟵",
	["longrightarrow"] = "⟶",
	["longleftrightarrow"] = "⟷",
	["Longleftarrow"] = "⟸",
	["Longrightarrow"] = "⟺",
	["longmapsfrom"] = "⟻",
	["longmapsto"] = "⟼",
	["Longmapsfrom"] = "⟽",
	["Longmapsto"] = "⟾",
	["psur"] = "⤀",
	["Mapsfrom"] = "⤆",
	["Mapsto"] = "⤇",
	["UpArrowBar"] = "⤒",
	["DownArrowBar"] = "⤓",
	["pinj"] = "⤔",
	["finj"] = "⤕",
	["bij"] = "⤖",
	["leadsto"] = "⤳",
	["leftrightharpoon"] = "⥊",
	["rightleftharpoon"] = "⥋",
	["leftrightharpoondown"] = "⥐",
	["leftupdownharpoon"] = "⥑",
	["LeftVectorBar"] = "⥒",
	["RightVectorBar"] = "⥓",
	["RightUpVectorBar"] = "⥔",
	["RightDownVectorBar"] = "⥕",
	["DownLeftVectorBar"] = "⥖",
	["DownRightVectorBar"] = "⥗",
	["LeftDownVectorBar"] = "⥙",
	["LeftTeeVector"] = "⥚",
	["RightTeeVector"] = "⥛",
	["RightUpTeeVector"] = "⥜",
	["RightDownTeeVector"] = "⥝",
	["DownLeftTeeVector"] = "⥞",
	["DownRightTeeVector"] = "⥟",
	["LeftUpTeeVector"] = "⥠",
	["LeftDownTeeVector"] = "⥡",
	["leftleftharpoons"] = "⥢",
	["upupharpoons"] = "⥣",
	["rightrightharpoons"] = "⥤",
	["downdownharpoons"] = "⥥",
	["leftbarharpoon"] = "⥪",
	["barleftharpoon"] = "⥫",
	["rightbarharpoon"] = "⥬",
	["barrightharpoon"] = "⥭",
	["updownharpoons"] = "⥮",
	["downupharpoons"] = "⥯",
	["strictfi"] = "⥼",
	["strictif"] = "⥽",
	["VERT"] = "⦀",
	["spot"] = "⦁",
	["Lparen"] = "⦅",
	["Rparen"] = "⦆",
	["limg"] = "⦇",
	["rimg"] = "⦈",
	["lblot"] = "⦉",
	["rblot"] = "⦊",
	["circledless"] = "⧀",
	["circledbslash"] = "⦸",
	["circledgtr"] = "⧁",
	["boxslash"] = "⧄",
	["boxbslash"] = "⧅",
	["boxast"] = "⧆",
	["boxcircle"] = "⧇",
	["boxbox"] = "⧈",
	["LeftTriangleBar"] = "⧏",
	["RightTriangleBar"] = "⧐",
	["multimapboth"] = "⧟",
	["blacklozenge"] = "⧫",
	["setminus"] = "⧵",
	["zhide"] = "⧹",

	["bigodot"] = "⨀",
	["bigoplus"] = "⨁",
	["bigotimes"] = "⨂",
	["biguplus"] = "⨄",
	["bigsqcap"] = "⨅",
	["bigsqcup"] = "⨆",
	["varprod"] = "⨉",
	["iiiint"] = "⨌",
	["fint"] = "⨏",
	["sqint"] = "⨖",
	["Join"] = "⨝",
	["zcmp"] = "⨟",
	["zpipe"] = "⨠",
	["zproject"] = "⨡",
	["fcmp"] = "⨾",
	["amalg"] = "⨿",
	["doublebarwedge"] = "⩞",
	["dsub"] = "⩤",
	["rsub"] = "⩥",
	["Coloneqq"] = "⩴",
	["Equal"] = "⩵",
	["Same"] = "⩶",

	["leqslant"] = "⩽",
	["geqslant"] = "⩾",
	["lessapprox"] = "⪅",
	["gtrapprox"] = "⪆",
	["lneq"] = "⪇",
	["gneq"] = "⪈",
	["lnapprox"] = "⪉",
	["gnapprox"] = "⪊",
	["lesseqqgtr"] = "⪋",
	["gtreqqless"] = "⪌",
	["eqslantless"] = "⪕",
	["eqslantgtr"] = "⪖",
	["NestedLessLess"] = "⪡",
	["NestedGreaterGreater"] = "⪢",
	["leftslice"] = "⪦",
	["rightslice"] = "⪧",
	["preceq"] = "⪯",
	["succeq"] = "⪰",
	["preceqq"] = "⪳",
	["succeqq"] = "⪴",
	["precapprox"] = "⪷",
	["succapprox"] = "⪸",
	["precnapprox"] = "⪹",
	["succnapprox"] = "⪺",
	["llcurly"] = "⪻",
	["ggcurly"] = "⪼",

	["subseteqq"] = "⫅",
	["supseteqq"] = "⫆",
	["subsetneqq"] = "⫋",
	["supsetneqq"] = "⫌",

	["Top"] = "⫪",
	["Bot"] = "⫫",
	["interleave"] = "⫴",
	["biginterleave"] = "⫼",
	["sslash"] = "⫽",

	---+ ${class, Mathematical bold symbols}
	["mathbf_0"] = "𝟎",
	["mathbf_1"] = "𝟏",
	["mathbf_2"] = "𝟐",
	["mathbf_3"] = "𝟑",
	["mathbf_4"] = "𝟒",
	["mathbf_5"] = "𝟓",
	["mathbf_6"] = "𝟔",
	["mathbf_7"] = "𝟕",
	["mathbf_8"] = "𝟖",
	["mathbf_9"] = "𝟗",

	["mathbf_A"] = "𝐀",
	["mathbf_B"] = "𝐁",
	["mathbf_C"] = "𝐂",
	["mathbf_D"] = "𝐃",
	["mathbf_E"] = "𝐄",
	["mathbf_F"] = "𝐅",
	["mathbf_G"] = "𝐆",
	["mathbf_H"] = "𝐇",
	["mathbf_I"] = "𝐈",
	["mathbf_J"] = "𝐉",
	["mathbf_K"] = "𝐊",
	["mathbf_L"] = "𝐋",
	["mathbf_M"] = "𝐌",
	["mathbf_N"] = "𝐍",
	["mathbf_O"] = "𝐎",
	["mathbf_P"] = "𝐏",
	["mathbf_Q"] = "𝐐",
	["mathbf_R"] = "𝐑",
	["mathbf_S"] = "𝐒",
	["mathbf_T"] = "𝐓",
	["mathbf_U"] = "𝐔",
	["mathbf_V"] = "𝐕",
	["mathbf_W"] = "𝐖",
	["mathbf_X"] = "𝐗",
	["mathbf_Y"] = "𝐘",
	["mathbf_Z"] = "𝐙",

	["mathbf_a"] = "𝐚",
	["mathbf_b"] = "𝐛",
	["mathbf_c"] = "𝐜",
	["mathbf_d"] = "𝐝",
	["mathbf_e"] = "𝐞",
	["mathbf_f"] = "𝐟",
	["mathbf_g"] = "𝐠",
	["mathbf_h"] = "𝐡",
	["mathbf_i"] = "𝐢",
	["mathbf_j"] = "𝐣",
	["mathbf_k"] = "𝐤",
	["mathbf_l"] = "𝐥",
	["mathbf_m"] = "𝐦",
	["mathbf_n"] = "𝐧",
	["mathbf_o"] = "𝐨",
	["mathbf_p"] = "𝐩",
	["mathbf_q"] = "𝐪",
	["mathbf_r"] = "𝐫",
	["mathbf_s"] = "𝐬",
	["mathbf_t"] = "𝐭",
	["mathbf_u"] = "𝐮",
	["mathbf_v"] = "𝐯",
	["mathbf_w"] = "𝐰",
	["mathbf_x"] = "𝐱",
	["mathbf_y"] = "𝐲",
	["mathbf_z"] = "𝐳",
	---_

	---+ ${class, Mathematical bold italic symbols}
	["mathbfit_A"] = "𝑨",
	["mathbfit_B"] = "𝑩",
	["mathbfit_C"] = "𝑪",
	["mathbfit_D"] = "𝑫",
	["mathbfit_E"] = "𝑬",
	["mathbfit_F"] = "𝑭",
	["mathbfit_G"] = "𝑮",
	["mathbfit_H"] = "𝑯",
	["mathbfit_I"] = "𝑰",
	["mathbfit_J"] = "𝑱",
	["mathbfit_K"] = "𝑲",
	["mathbfit_L"] = "𝑳",
	["mathbfit_M"] = "𝑴",
	["mathbfit_N"] = "𝑵",
	["mathbfit_O"] = "𝑶",
	["mathbfit_P"] = "𝑷",
	["mathbfit_Q"] = "𝑸",
	["mathbfit_R"] = "𝑹",
	["mathbfit_S"] = "𝑺",
	["mathbfit_T"] = "𝑻",
	["mathbfit_U"] = "𝑼",
	["mathbfit_V"] = "𝑽",
	["mathbfit_W"] = "𝑾",
	["mathbfit_X"] = "𝑿",
	["mathbfit_Y"] = "𝒀",
	["mathbfit_Z"] = "𝒁",

	["mathbfit_a"] = "𝒂",
	["mathbfit_b"] = "𝒃",
	["mathbfit_c"] = "𝒄",
	["mathbfit_d"] = "𝒅",
	["mathbfit_e"] = "𝒆",
	["mathbfit_f"] = "𝒇",
	["mathbfit_g"] = "𝒈",
	["mathbfit_h"] = "𝒉",
	["mathbfit_i"] = "𝒊",
	["mathbfit_j"] = "𝒋",
	["mathbfit_k"] = "𝒌",
	["mathbfit_l"] = "𝒍",
	["mathbfit_m"] = "𝒎",
	["mathbfit_n"] = "𝒏",
	["mathbfit_o"] = "𝒐",
	["mathbfit_p"] = "𝒑",
	["mathbfit_q"] = "𝒒",
	["mathbfit_r"] = "𝒓",
	["mathbfit_s"] = "𝒔",
	["mathbfit_t"] = "𝒕",
	["mathbfit_u"] = "𝒖",
	["mathbfit_v"] = "𝒗",
	["mathbfit_w"] = "𝒘",
	["mathbfit_x"] = "𝒙",
	["mathbfit_y"] = "𝒚",
	["mathbfit_z"] = "𝒛",
	---_

	---+ ${class, Mathematical script symbols}
	["mathcal_A"] = "𝒜",
	["mathcal_B"] = "ℬ",
	["mathcal_C"] = "𝒞",
	["mathcal_D"] = "𝒟",
	["mathcal_E"] = "ℰ",
	["mathcal_F"] = "ℱ",
	["mathcal_G"] = "𝒢",
	["mathcal_H"] = "ℋ",
	["mathcal_I"] = "ℐ",
	["mathcal_J"] = "𝒥",
	["mathcal_K"] = "𝒦",
	["mathcal_L"] = "ℒ",
	["mathcal_M"] = "ℳ",
	["mathcal_N"] = "𝒩",
	["mathcal_O"] = "𝒪",
	["mathcal_P"] = "𝒫",
	["mathcal_Q"] = "𝒬",
	["mathcal_R"] = "ℛ",
	["mathcal_S"] = "𝒮",
	["mathcal_T"] = "𝒯",
	["mathcal_U"] = "𝒰",
	["mathcal_V"] = "𝒱",
	["mathcal_W"] = "𝒲",
	["mathcal_X"] = "𝒳",
	["mathcal_Y"] = "𝒴",
	["mathcal_Z"] = "𝒵",

	["mathcal_a"] = "𝒶",
	["mathcal_b"] = "𝒷",
	["mathcal_c"] = "𝒸",
	["mathcal_d"] = "𝒹",
	["mathcal_e"] = "ℯ",
	["mathcal_f"] = "𝒻",
	["mathcal_g"] = "ℊ",
	["mathcal_h"] = "𝒽",
	["mathcal_i"] = "𝒾",
	["mathcal_j"] = "𝒿",
	["mathcal_k"] = "𝓀",
	["mathcal_l"] = "𝓁",
	["mathcal_m"] = "𝓂",
	["mathcal_n"] = "𝓃",
	["mathcal_o"] = "ℴ",
	["mathcal_p"] = "𝓅",
	["mathcal_q"] = "𝓆",
	["mathcal_r"] = "𝓇",
	["mathcal_s"] = "𝓈",
	["mathcal_t"] = "𝓉",
	["mathcal_u"] = "𝓊",
	["mathcal_v"] = "𝓋",
	["mathcal_w"] = "𝓌",
	["mathcal_x"] = "𝓍",
	["mathcal_y"] = "𝓎",
	["mathcal_z"] = "𝓏",
	---_

	---+ ${class, Mathematical FRAKTUR symbols}
	["mathfrak_A"] = "𝔄",
	["mathfrak_B"] = "𝔅",
	["mathfrak_C"] = "ℭ",
	["mathfrak_D"] = "𝔇",
	["mathfrak_E"] = "𝔈",
	["mathfrak_F"] = "𝔉",
	["mathfrak_G"] = "𝔊",
	["mathfrak_H"] = "ℌ",
	["mathfrak_I"] = "ℑ",
	["mathfrak_J"] = "𝔍",
	["mathfrak_K"] = "𝔎",
	["mathfrak_L"] = "𝔏",
	["mathfrak_M"] = "𝔐",
	["mathfrak_N"] = "𝔑",
	["mathfrak_O"] = "𝔒",
	["mathfrak_P"] = "𝔓",
	["mathfrak_Q"] = "𝔔",
	["mathfrak_R"] = "ℜ",
	["mathfrak_S"] = "𝔖",
	["mathfrak_T"] = "𝔗",
	["mathfrak_U"] = "𝔘",
	["mathfrak_V"] = "𝔙",
	["mathfrak_W"] = "𝔚",
	["mathfrak_X"] = "𝔛",
	["mathfrak_Y"] = "𝔜",
	["mathfrak_Z"] = "ℨ",

	["mathfrak_a"] = "𝔞",
	["mathfrak_b"] = "𝔟",
	["mathfrak_c"] = "𝔠",
	["mathfrak_d"] = "𝔡",
	["mathfrak_e"] = "𝔢",
	["mathfrak_f"] = "𝔣",
	["mathfrak_g"] = "𝔤",
	["mathfrak_h"] = "𝔥",
	["mathfrak_i"] = "𝔦",
	["mathfrak_j"] = "𝔧",
	["mathfrak_k"] = "𝔨",
	["mathfrak_l"] = "𝔩",
	["mathfrak_m"] = "𝔪",
	["mathfrak_n"] = "𝔫",
	["mathfrak_o"] = "𝔬",
	["mathfrak_p"] = "𝔭",
	["mathfrak_q"] = "𝔮",
	["mathfrak_r"] = "𝔯",
	["mathfrak_s"] = "𝔰",
	["mathfrak_t"] = "𝔱",
	["mathfrak_u"] = "𝔲",
	["mathfrak_v"] = "𝔳",
	["mathfrak_w"] = "𝔴",
	["mathfrak_x"] = "𝔵",
	["mathfrak_y"] = "𝔶",
	["mathfrak_z"] = "𝔷",
	---_

	---+ ${class, Mathematical DOUBLE-STRUCK symbols}
	["mathbb_0"] = "𝟘",
	["mathbb_1"] = "𝟙",
	["mathbb_2"] = "𝟚",
	["mathbb_3"] = "𝟛",
	["mathbb_4"] = "𝟜",
	["mathbb_5"] = "𝟝",
	["mathbb_6"] = "𝟞",
	["mathbb_7"] = "𝟟",
	["mathbb_8"] = "𝟠",
	["mathbb_9"] = "𝟡",

	["mathbb_A"] = "𝔸",
	["mathbb_B"] = "𝔹",
	["mathbb_C"] = "ℂ",
	["mathbb_D"] = "𝔻",
	["mathbb_E"] = "𝔼",
	["mathbb_F"] = "𝔽",
	["mathbb_G"] = "𝔾",
	["mathbb_H"] = "ℍ",
	["mathbb_I"] = "𝕀",
	["mathbb_J"] = "𝕁",
	["mathbb_K"] = "𝕂",
	["mathbb_L"] = "𝕃",
	["mathbb_M"] = "𝕄",
	["mathbb_N"] = "ℕ",
	["mathbb_O"] = "𝕆",
	["mathbb_P"] = "ℙ",
	["mathbb_Q"] = "ℚ",
	["mathbb_R"] = "ℝ",
	["mathbb_S"] = "𝕊",
	["mathbb_T"] = "𝕋",
	["mathbb_U"] = "𝕌",
	["mathbb_V"] = "𝕍",
	["mathbb_W"] = "𝕎",
	["mathbb_X"] = "𝕏",
	["mathbb_Y"] = "𝕐",
	["mathbb_Z"] = "ℤ",

	["mathbb_a"] = "𝕒",
	["mathbb_b"] = "𝕓",
	["mathbb_c"] = "𝕔",
	["mathbb_d"] = "𝕕",
	["mathbb_e"] = "𝕖",
	["mathbb_f"] = "𝕗",
	["mathbb_g"] = "𝕘",
	["mathbb_h"] = "𝕙",
	["mathbb_i"] = "𝕚",
	["mathbb_j"] = "𝕛",
	["mathbb_k"] = "𝕜",
	["mathbb_l"] = "𝕝",
	["mathbb_m"] = "𝕞",
	["mathbb_n"] = "𝕟",
	["mathbb_o"] = "𝕠",
	["mathbb_p"] = "𝕡",
	["mathbb_q"] = "𝕢",
	["mathbb_r"] = "𝕣",
	["mathbb_s"] = "𝕤",
	["mathbb_t"] = "𝕥",
	["mathbb_u"] = "𝕦",
	["mathbb_v"] = "𝕧",
	["mathbb_w"] = "𝕨",
	["mathbb_x"] = "𝕩",
	["mathbb_y"] = "𝕪",
	["mathbb_z"] = "𝕫",
	---_

	---+ ${class, Mathematical SANS-SERIF bold symbols}
	["mathsfbf_0"] = "𝟬",
	["mathsfbf_1"] = "𝟭",
	["mathsfbf_2"] = "𝟮",
	["mathsfbf_3"] = "𝟯",
	["mathsfbf_4"] = "𝟰",
	["mathsfbf_5"] = "𝟱",
	["mathsfbf_6"] = "𝟲",
	["mathsfbf_7"] = "𝟳",
	["mathsfbf_8"] = "𝟴",
	["mathsfbf_9"] = "𝟵",

	["mathsfbf_A"] = "𝗔",
	["mathsfbf_B"] = "𝗕",
	["mathsfbf_C"] = "𝗖",
	["mathsfbf_D"] = "𝗗",
	["mathsfbf_E"] = "𝗘",
	["mathsfbf_F"] = "𝗙",
	["mathsfbf_G"] = "𝗚",
	["mathsfbf_H"] = "𝗛",
	["mathsfbf_I"] = "𝗜",
	["mathsfbf_J"] = "𝗝",
	["mathsfbf_K"] = "𝗞",
	["mathsfbf_L"] = "𝗟",
	["mathsfbf_M"] = "𝗠",
	["mathsfbf_N"] = "𝗡",
	["mathsfbf_O"] = "𝗢",
	["mathsfbf_P"] = "𝗣",
	["mathsfbf_Q"] = "𝗤",
	["mathsfbf_R"] = "𝗥",
	["mathsfbf_S"] = "𝗦",
	["mathsfbf_T"] = "𝗧",
	["mathsfbf_U"] = "𝗨",
	["mathsfbf_V"] = "𝗩",
	["mathsfbf_W"] = "𝗪",
	["mathsfbf_X"] = "𝗫",
	["mathsfbf_Y"] = "𝗬",
	["mathsfbf_Z"] = "𝗭",

	["mathsfbf_a"] = "𝗮",
	["mathsfbf_b"] = "𝗯",
	["mathsfbf_c"] = "𝗰",
	["mathsfbf_d"] = "𝗱",
	["mathsfbf_e"] = "𝗲",
	["mathsfbf_f"] = "𝗳",
	["mathsfbf_g"] = "𝗴",
	["mathsfbf_h"] = "𝗵",
	["mathsfbf_i"] = "𝗶",
	["mathsfbf_j"] = "𝗷",
	["mathsfbf_k"] = "𝗸",
	["mathsfbf_l"] = "𝗹",
	["mathsfbf_m"] = "𝗺",
	["mathsfbf_n"] = "𝗻",
	["mathsfbf_o"] = "𝗼",
	["mathsfbf_p"] = "𝗽",
	["mathsfbf_q"] = "𝗾",
	["mathsfbf_r"] = "𝗿",
	["mathsfbf_s"] = "𝘀",
	["mathsfbf_t"] = "𝘁",
	["mathsfbf_u"] = "𝘂",
	["mathsfbf_v"] = "𝘃",
	["mathsfbf_w"] = "𝘄",
	["mathsfbf_x"] = "𝘅",
	["mathsfbf_y"] = "𝘆",
	["mathsfbf_z"] = "𝘇",
	---_

	---+ ${class, Mathematical SANS-SERIF italic symbols}
	["mathsfit_A"] = "𝘈",
	["mathsfit_B"] = "𝘉",
	["mathsfit_C"] = "𝘊",
	["mathsfit_D"] = "𝘋",
	["mathsfit_E"] = "𝘌",
	["mathsfit_F"] = "𝘍",
	["mathsfit_G"] = "𝘎",
	["mathsfit_H"] = "𝘏",
	["mathsfit_I"] = "𝘐",
	["mathsfit_J"] = "𝘑",
	["mathsfit_K"] = "𝘒",
	["mathsfit_L"] = "𝘓",
	["mathsfit_M"] = "𝘔",
	["mathsfit_N"] = "𝘕",
	["mathsfit_O"] = "𝘖",
	["mathsfit_P"] = "𝘗",
	["mathsfit_Q"] = "𝘘",
	["mathsfit_R"] = "𝘙",
	["mathsfit_S"] = "𝘚",
	["mathsfit_T"] = "𝘛",
	["mathsfit_U"] = "𝘜",
	["mathsfit_V"] = "𝘝",
	["mathsfit_W"] = "𝘞",
	["mathsfit_X"] = "𝘟",
	["mathsfit_Y"] = "𝘠",
	["mathsfit_Z"] = "𝘡",

	["mathsfit_a"] = "𝘢",
	["mathsfit_b"] = "𝘣",
	["mathsfit_c"] = "𝘤",
	["mathsfit_d"] = "𝘥",
	["mathsfit_e"] = "𝘦",
	["mathsfit_f"] = "𝘧",
	["mathsfit_g"] = "𝘨",
	["mathsfit_h"] = "𝘩",
	["mathsfit_i"] = "𝘪",
	["mathsfit_j"] = "𝘫",
	["mathsfit_k"] = "𝘬",
	["mathsfit_l"] = "𝘭",
	["mathsfit_m"] = "𝘮",
	["mathsfit_n"] = "𝘯",
	["mathsfit_o"] = "𝘰",
	["mathsfit_p"] = "𝘱",
	["mathsfit_q"] = "𝘲",
	["mathsfit_r"] = "𝘳",
	["mathsfit_s"] = "𝘴",
	["mathsfit_t"] = "𝘵",
	["mathsfit_u"] = "𝘶",
	["mathsfit_v"] = "𝘷",
	["mathsfit_w"] = "𝘸",
	["mathsfit_x"] = "𝘹",
	["mathsfit_y"] = "𝘺",
	["mathsfit_z"] = "𝘻",
	---_

	---+ ${class, Mathematical SANS-SERIF bold italic symbols}
	["mathsfbfit_A"] = "𝘼",
	["mathsfbfit_B"] = "𝘽",
	["mathsfbfit_C"] = "𝘾",
	["mathsfbfit_D"] = "𝘿",
	["mathsfbfit_E"] = "𝙀",
	["mathsfbfit_F"] = "𝙁",
	["mathsfbfit_G"] = "𝙂",
	["mathsfbfit_H"] = "𝙃",
	["mathsfbfit_I"] = "𝙄",
	["mathsfbfit_J"] = "𝙅",
	["mathsfbfit_K"] = "𝙆",
	["mathsfbfit_L"] = "𝙇",
	["mathsfbfit_M"] = "𝙈",
	["mathsfbfit_N"] = "𝙉",
	["mathsfbfit_O"] = "𝙊",
	["mathsfbfit_P"] = "𝙋",
	["mathsfbfit_Q"] = "𝙌",
	["mathsfbfit_R"] = "𝙍",
	["mathsfbfit_S"] = "𝙎",
	["mathsfbfit_T"] = "𝙏",
	["mathsfbfit_U"] = "𝙐",
	["mathsfbfit_V"] = "𝙑",
	["mathsfbfit_W"] = "𝙒",
	["mathsfbfit_X"] = "𝙓",
	["mathsfbfit_Y"] = "𝙔",
	["mathsfbfit_Z"] = "𝙕",

	["mathsfbfit_a"] = "𝙖",
	["mathsfbfit_b"] = "𝙗",
	["mathsfbfit_c"] = "𝙘",
	["mathsfbfit_d"] = "𝙙",
	["mathsfbfit_e"] = "𝙚",
	["mathsfbfit_f"] = "𝙛",
	["mathsfbfit_g"] = "𝙜",
	["mathsfbfit_h"] = "𝙝",
	["mathsfbfit_i"] = "𝙞",
	["mathsfbfit_j"] = "𝙟",
	["mathsfbfit_k"] = "𝙠",
	["mathsfbfit_l"] = "𝙡",
	["mathsfbfit_m"] = "𝙢",
	["mathsfbfit_n"] = "𝙣",
	["mathsfbfit_o"] = "𝙤",
	["mathsfbfit_p"] = "𝙥",
	["mathsfbfit_q"] = "𝙦",
	["mathsfbfit_r"] = "𝙧",
	["mathsfbfit_s"] = "𝙨",
	["mathsfbfit_t"] = "𝙩",
	["mathsfbfit_u"] = "𝙪",
	["mathsfbfit_v"] = "𝙫",
	["mathsfbfit_w"] = "𝙬",
	["mathsfbfit_x"] = "𝙭",
	["mathsfbfit_y"] = "𝙮",
	["mathsfbfit_z"] = "𝙯",
	---_

	---+ ${class, Mathematical mono-space symbols}
	["mathtt_0"] = "𝟶",
	["mathtt_1"] = "𝟷",
	["mathtt_2"] = "𝟸",
	["mathtt_3"] = "𝟹",
	["mathtt_4"] = "𝟺",
	["mathtt_5"] = "𝟻",
	["mathtt_6"] = "𝟼",
	["mathtt_7"] = "𝟽",
	["mathtt_8"] = "𝟾",
	["mathtt_9"] = "𝟿",

	["mathtt_A"] = "𝙰",
	["mathtt_B"] = "𝙱",
	["mathtt_C"] = "𝙲",
	["mathtt_D"] = "𝙳",
	["mathtt_E"] = "𝙴",
	["mathtt_F"] = "𝙵",
	["mathtt_G"] = "𝙶",
	["mathtt_H"] = "𝙷",
	["mathtt_I"] = "𝙸",
	["mathtt_J"] = "𝙹",
	["mathtt_K"] = "𝙺",
	["mathtt_L"] = "𝙻",
	["mathtt_M"] = "𝙼",
	["mathtt_N"] = "𝙽",
	["mathtt_O"] = "𝙾",
	["mathtt_P"] = "𝙿",
	["mathtt_Q"] = "𝚀",
	["mathtt_R"] = "𝚁",
	["mathtt_S"] = "𝚂",
	["mathtt_T"] = "𝚃",
	["mathtt_U"] = "𝚄",
	["mathtt_V"] = "𝚅",
	["mathtt_W"] = "𝚆",
	["mathtt_X"] = "𝚇",
	["mathtt_Y"] = "𝚈",
	["mathtt_Z"] = "𝚉",

	["mathtt_a"] = "𝚊",
	["mathtt_b"] = "𝚋",
	["mathtt_c"] = "𝚌",
	["mathtt_d"] = "𝚍",
	["mathtt_e"] = "𝚎",
	["mathtt_f"] = "𝚏",
	["mathtt_g"] = "𝚐",
	["mathtt_h"] = "𝚑",
	["mathtt_i"] = "𝚒",
	["mathtt_j"] = "𝚓",
	["mathtt_k"] = "𝚔",
	["mathtt_l"] = "𝚕",
	["mathtt_m"] = "𝚖",
	["mathtt_n"] = "𝚗",
	["mathtt_o"] = "𝚘",
	["mathtt_p"] = "𝚙",
	["mathtt_q"] = "𝚚",
	["mathtt_r"] = "𝚛",
	["mathtt_s"] = "𝚜",
	["mathtt_t"] = "𝚝",
	["mathtt_u"] = "𝚞",
	["mathtt_v"] = "𝚟",
	["mathtt_w"] = "𝚠",
	["mathtt_x"] = "𝚡",
	["mathtt_y"] = "𝚢",
	["mathtt_z"] = "𝚣"
	---_
	---_
};

---@type integer? Namespace used to render stuff, initially nil
latex.namespace = nil;

--- Sets the namespace
---@param ns string
latex.set_namespace = function (ns)
	latex.namespace = ns --[[ @as integer ]];
end

--- Renders brackets
---@param buffer integer
---@param content table
---@param user_config markview.latex.brackets
latex.render_brackets = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
		virt_text_pos = "overlay",
		virt_text = {
			user_config.opening[utils.clamp(content.level, 1, #user_config.opening)]
		},

		hl_mode = "combine"
	});
	vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_end, content.col_end - 1, {
		virt_text_pos = "overlay",
		virt_text = {
			user_config.closing[utils.clamp(content.level, 1, #user_config.closing)]
		},

		hl_mode = "combine"
	});

	if not user_config.scope or #user_config.scope == 0 then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
		hl_group = set_hl(user_config.scope[utils.clamp(content.level, 1, #user_config.scope)]),
		end_row = content.row_end,
		end_col = content.col_end
	});
end

--- Renders fractional
---@param buffer integer
---@param content table
---@param user_config markview.conf.latex
latex.render_fractional = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	local cmd = content.command;
	local arg_1 = content.argument_1;

	vim.api.nvim_buf_set_extmark(buffer, latex.namespace, cmd.row_start, cmd.col_start, {
		end_col = cmd.col_end,
		conceal = ""
	});

	vim.api.nvim_buf_set_extmark(buffer, latex.namespace, arg_1.row_end, arg_1.col_end, {
		virt_text_pos = "inline",
		virt_text = {
			{ latex.symbols.div, "Special" }
		},

		hl_mode = "combine"
	});
end

--- Renders superscript text
---@param buffer integer
---@param content table
---@param user_config markview.latex.superscript
latex.render_superscript = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	local numbers = {
		["0"] = "⁰", ["1"] = "¹", ["2"] = "²",
		["3"] = "³", ["4"] = "⁴", ["5"] = "⁵",
		["6"] = "⁶", ["7"] = "⁷", ["8"] = "⁸",
		["9"] = "⁹"
	};

	local internal = content.text;
	local skip = 1;

	if content.text:match("^%^[^{]$") then
		internal = content.text:match("^%^(.+)$")

		if internal:match("^([%s%d]+)$") then
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
				end_col = content.col_start + 1,
				conceal = ""
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
				virt_text_pos = "inline",
				virt_text = { { "^(", set_hl(user_config.hl) } },

				end_col = content.col_start + 1,
				conceal = "",

				hl_mode = "combine"
			});
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_end, content.col_end, {
				virt_text_pos = "inline",
				virt_text = { { ")", set_hl(user_config.hl) } },

				hl_mode = "combine"
			});
		end
	elseif content.text:match("^%^%{(.+)%}$") and user_config.conceal_brackets ~= false then
		skip = 2;
		internal = content.text:match("^%^%{(.+)%}$")

		if internal:match("^([%s%d]+)$") then
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
				end_col = content.col_start + 2,
				conceal = ""
			});
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_end, content.col_end - 1, {
				end_col = content.col_end,
				conceal = ""
			});
		elseif content.special_syntax then
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
				virt_text_pos = "inline",
				virt_text = { { " " } },

				end_col = content.col_start + 2,
				conceal = "",

				hl_mode = "combine"
			});
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_end, content.col_end - 1, {
				end_col = content.col_end,
				conceal = ""
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
				virt_text_pos = "inline",
				virt_text = { { "^(", set_hl(user_config.hl) } },

				end_col = content.col_start + 2,
				conceal = "",

				hl_mode = "combine"
			});
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_end, content.col_end - 1, {
				virt_text_pos = "inline",
				virt_text = { { ")", set_hl(user_config.hl) } },

				end_col = content.col_end,
				conceal = "",

				hl_mode = "combine"
			});
		end
	end

	if internal:match("^([%d%s]+)$") then
		local _v = {};

		for num in internal:gmatch(".") do
			table.insert(_v, {
				numbers[num] or num,
				set_hl(user_config.hl)
			});
		end

		vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start + skip, {
			virt_text_pos = "overlay",
			virt_text = _v,

			hl_mode = "combine"
		});
	elseif user_config.hl then
		vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start + 1, {
			hl_group = set_hl(user_config.hl),

			end_col = content.col_end,
			hl_mode = "combine"
		});
	end
end

--- Renders subscript text
---@param buffer integer
---@param content table
---@param user_config markview.latex.subscript
latex.render_subscript = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	local numbers = {
		["0"] = "₀", ["1"] = "₁", ["2"] = "₂",
		["3"] = "₃", ["4"] = "₄", ["5"] = "₅",
		["6"] = "₆", ["7"] = "₇", ["8"] = "₈",
		["9"] = "₉"
	};

	local internal = content.text;
	local skip = 1;

	if content.text:match("^%_[^{]$") then
		internal = content.text:match("^%_(.+)$")

		if internal:match("^([%s%d]+)$") then
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
				end_col = content.col_start + 1,
				conceal = ""
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
				virt_text_pos = "inline",
				virt_text = { { "_(", set_hl(user_config.hl) } },

				end_col = content.col_start + 1,
				conceal = "",

				hl_mode = "combine"
			});
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_end, content.col_end, {
				virt_text_pos = "inline",
				virt_text = { { ")", set_hl(user_config.hl) } },

				hl_mode = "combine"
			});
		end
	elseif content.text:match("^%_%{(.+)%}$") and user_config.conceal_brackets ~= false then
		skip = 2;
		internal = content.text:match("^%_%{(.+)%}$")

		if internal:match("^([%s%d]+)$") then
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
				end_col = content.col_start + 2,
				conceal = ""
			});
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_end, content.col_end - 1, {
				end_col = content.col_end,
				conceal = ""
			});
		elseif content.special_syntax then
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
				virt_text_pos = "inline",
				virt_text = { { " " } },

				end_col = content.col_start + 2,
				conceal = "",

				hl_mode = "combine"
			});
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_end, content.col_end - 1, {
				end_col = content.col_end,
				conceal = ""
			});
		else
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
				virt_text_pos = "inline",
				virt_text = { { "_(", set_hl(user_config.hl) } },

				end_col = content.col_start + 2,
				conceal = "",

				hl_mode = "combine"
			});
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_end, content.col_end - 1, {
				virt_text_pos = "inline",
				virt_text = { { ")", set_hl(user_config.hl) } },

				end_col = content.col_end,
				conceal = "",

				hl_mode = "combine"
			});
		end
	end

	if internal:match("^([%d%s]+)$") then
		local _v = {};

		for num in internal:gmatch(".") do
			table.insert(_v, {
				numbers[num] or num,
				set_hl(user_config.hl)
			});
		end

		vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start + skip, {
			virt_text_pos = "overlay",
			virt_text = _v,

			hl_mode = "combine"
		});
	elseif user_config.hl then
		vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start + 1, {
			hl_group = set_hl(user_config.hl),

			end_col = content.col_end,
			hl_mode = "combine"
		});
	end
end

--- Renders symbols
---@param buffer integer
---@param content table
---@param user_config markview.conf.latex
latex.render_symbol = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	elseif not content.text then
		return;
	end

	local symbol_conf = user_config.symbols;

	if not symbol_conf or symbol_conf.enable == false then
		return;
	end

	local get = function (val)
		if pcall(val, buffer) then
			return val(buffer);
		end

		return val;
	end

	local get_hl = function (val)
		if not symbol_conf.groups or not val then
			return set_hl(symbol_conf.hl);
		end

		for _, group in ipairs(symbol_conf.groups) do
			if vim.islist(group.match) and vim.list_contains(group.match, val) then
				return set_hl(group.hl);
			elseif pcall(group.match --[[ @as function ]], val) and group.match(val) == true then
				return set_hl(group.hl);
			end
		end

		return set_hl(symbol_conf.hl);
	end

	local _t = get(latex.symbols[content.text]);

	if not _t then
		return;
	end

	local hl = get_hl(content.text);

	if content.inside and user_config[content.inside] and user_config[content.inside].hl then
		hl = user_config[content.inside].hl;
	end

	vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
		virt_text_pos = "inline",
		virt_text = {
			{ _t, set_hl(hl) }
		},

		hl_mode = "combine",
		end_col = content.col_end,
		conceal = ""
	});
end

--- Renders mathbb symbols
---@param buffer integer
---@param content table
---@param user_config markview.latex.symbols
latex.render_font = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	elseif not content.text then
		return;
	end

	local get = function (val)
		if pcall(val, buffer) then
			return val(buffer);
		end

		return val;
	end

	local col = content.col_start + vim.fn.strchars(content.font) + 2;

	vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
		end_col = col - 1,
		conceal = ""
	});

	content.text = content.text:gsub("[{}]", "|");
	for m in content.text:gmatch("\\(%a+)") do
		content.text = content.text:gsub("\\(%a+)", string.rep("|", vim.fn.strchars(m) + 1))
	end

	for letter in content.text:gmatch(".") do
		if latex.symbols[content.font .. "_" .. letter] then
			vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, col, {
				virt_text_pos = "overlay",
				virt_text = { { get(latex.symbols[content.font .. "_" .. letter]) } },

				hl_mode = "combine"
			});
		end

		col = col + 1;
	end
end

--- Renders fractional
---@param buffer integer
---@param content table
---@param user_config markview.conf.latex
latex.render_root = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
		virt_text_pos = "inline",
		virt_text = {
			{ latex.symbols.sqrt, "Special" }
		},

		end_col = content.col_start + 5,
		conceal = ""
	});
end

--- Renders fractional
---@param buffer integer
---@param content table
---@param user_config { enable: boolean }
latex.render_inline = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
		end_col = content.col_start + #"$",
		conceal = ""
	});
	vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_end, content.col_end - #"$", {
		end_col = content.col_end,
		conceal = ""
	});
end

--- Renders fractional
---@param buffer integer
---@param content table
---@param user_config markview.latex.block
latex.render_block = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
		end_col = content.col_start + 2,

		line_hl_group = set_hl(user_config.hl),
		conceal = ""
	});
	vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_end - 1, content.col_end - 2, {
		virt_text_pos = "right_align",
		virt_text = {
			user_config.text or { " Latex ", "Comment" }
		},

		end_col = content.col_end,
		conceal = "",

		line_hl_group = set_hl(user_config.hl),
		hl_mode = "combine"
	});

	for l = content.row_start + 1, (content.row_end - 1) - 1, 1 do
		vim.api.nvim_buf_set_extmark(buffer, latex.namespace, l, content.col_start, {
			virt_text_pos = "inline",
			virt_text = {
				{ string.rep(" ", user_config.pad_amount or 3) }
			},

			line_hl_group = set_hl(user_config.hl),
			end_row = l,
		});
	end
end

--- Renders latex
---@param render_type string
---@param buffer integer
---@param content table
---@param config_table markview.configuration
latex.render = function (render_type, buffer, content, config_table)
	if not config_table or not config_table.latex then
		return;
	elseif config_table.latex and config_table.latex.enable == false then
		return;
	end

	---@type markview.conf.latex
	local conf = config_table.latex;

	if conf.symbols and type(conf.symbols.overwrite) == "table" then
		for name, symbol in pairs(conf.symbols.overwrite) do
			latex.symbols[name] = symbol;
		end
	end

	if render_type == "latex_inline" then
		pcall(latex.render_inline, buffer, content, conf.inline)
	elseif render_type == "latex_block" then
		pcall(latex.render_block, buffer, content, conf.block)
	elseif render_type == "latex_bracket" then
		pcall(latex.render_brackets, buffer, content, conf.brackets)
	elseif render_type == "latex_fractional" then
		pcall(latex.render_fractional, buffer, content, conf)
	elseif render_type == "latex_superscript" then
		pcall(latex.render_superscript, buffer, content, conf.superscript)
	elseif render_type == "latex_subscript" then
		pcall(latex.render_subscript, buffer, content, conf.subscript)
	elseif render_type == "latex_font" then
		pcall(latex.render_font, buffer, content, conf.symbols)
	elseif render_type == "latex_symbol" then
		pcall(latex.render_symbol, buffer, content, conf)
	elseif render_type == "latex_root" then
		pcall(latex.render_root, buffer, content, conf)
	end
end

return latex;
