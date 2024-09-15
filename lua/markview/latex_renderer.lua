local latex = {};
local utils = require("markview.utils");

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

latex.symbols = {
	["lim"] = "lim",
	["alpha"] = "α",
	["beta"] = "β",
	["gamma"] = "γ",
	["delta"] = "δ",
	["epsilon"] = "ϵ",
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
	["sigma"] = "σ",
	["tau"] = "τ",
	["upsilon"] = "υ",
	["phi"] = "ϕ",
	["chi"] = "χ",
	["psi"] = "ψ",
	["omega"] = "ω",

	["Gamma"] = "Γ",
	["Delta"] = "Δ",
	["Theta"] = "Θ",
	["Lambda"] = "Λ",
	["Xi"] = "Ξ",
	["Pi"] = "Π",
	["Sigma"] = "Σ",
	["Epsilon"] = "Υ",
	["Phi"] = "Φ",
	["Psi"] = "Ψ",
	["Omega"] = "Ω",

	["equiv"] = "≡",
	["times"] = "×",
	["div"] = "÷",
	["neq"] = "≠",
	["approx"] = "≈",
	["leq"] = "≤",
	["geq"] = "≥",
	["infty"] = "∞",
	["partial"] = "∂",
	["nabla"] = "∇",
	["int"] = "∫",
	["sum"] = "∑",
	["prod"] = "∏",
	["sqrt"] = "√",

	["to"] = "→",
	["rightarrow"] = "→",
	["leftarrow"] = "←",
	["Rightarrow"] = "⇒",
	["Leftarrow"] = "⇐",
	["iff"] = "⟺",

	["forall"] = "∀",
	["exists"] = "∃",
	["neg"] = "¬",
	["wedge"] = "∧",
	["vee"] = "∨",
	["cup"] = "∪",
	["cap"] = "∩",
	["setminus"] = "∖",
	["emptyset"] = "∅",

	["subset"] = "⊂",
	["subseteq"] = "⊆",
	["supset"] = "⊃",
	["supseteq"] = "⊇",
	["in"] = "∈",
	["notin"] = "∉",
	["perp"] = "⊥",
	["parallel"] = "∥",

	["dots"] = "…",
	["ldots"] = "…",
	["cdots"] = "⋯",
	["vdots"] = "⋮",
	["ddots"] = "⋱",
	["cdot"] = "⋅",
	["angle"] = "∠",
	["measuredangle"] = "∡",

	["circ"] = "∘",
	["bullet"] = "∙",
	["dagger"] = "†",
	["ddagger"] = "‡",

	["ell"] = "ℓ",
	["Re"] = "ℜ",
	["Im"] = "ℑ",
	["aleph"] = "ℵ",
	["beth"] = "ℶ",
	["gimel"] = "ℷ",
	["daleth"] = "ℸ",
};

latex.namespace = nil;

latex.set_namespace = function (ns)
	latex.namespace = ns;
end

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

	if content.isBracketed == true then
		vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
			end_col = content.col_start + 2,
			conceal = ""
		});
		vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_end, content.col_end - 1, {
			end_col = content.col_end,
			conceal = ""
		});

		local _v = {};

		for num in content.text:gmatch("%d") do
			table.insert(_v, {
				numbers[num]
			});
		end

		vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start + 2, {
			virt_text_pos = "overlay",
			virt_text = _v,

			hl_mode = "combine"
		});
	else
		vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
			end_col = content.col_start + 1,
			conceal = ""
		});
		vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_end, content.col_end - 1, {
			end_col = content.col_end,
			conceal = ""
		});

		vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start + 1, {
			virt_text_pos = "overlay",
			virt_text = {
				{ numbers[content.text] }
			},

			hl_mode = "combine"
		});
	end
end

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

	if content.isBracketed == true then
		vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
			end_col = content.col_start + 2,
			conceal = ""
		});
		vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_end, content.col_end - 1, {
			end_col = content.col_end,
			conceal = ""
		});

		local _v = {};

		for num in content.text:gmatch("%d") do
			table.insert(_v, {
				numbers[num]
			});
		end

		vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start + 2, {
			virt_text_pos = "overlay",
			virt_text = _v,

			hl_mode = "combine"
		});
	else
		vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
			end_col = content.col_start + 1,
			conceal = ""
		});
		vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_end, content.col_end - 1, {
			end_col = content.col_end,
			conceal = ""
		});

		vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start + 1, {
			virt_text_pos = "overlay",
			virt_text = {
				{ numbers[content.text] }
			},

			hl_mode = "combine"
		});
	end
end

latex.render_symbol = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	elseif not content.text then
		return;
	end

	local _t = nil

	if user_config.custom and user_config.custom[content.text] then
		_t = user_config.custom[content.text]
	elseif latex.symbols[content.text] then
		_t = latex.symbols[content.text]
	end

	if not _t then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
		virt_text_pos = "inline",
		virt_text = {
			{ _t, set_hl(user_config.hl) }
		},

		end_col = content.col_end,
		conceal = ""
	});
end

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

latex.render_inline = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
		end_col = content.col_start + 1,
		conceal = ""
	});
	vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_end, content.col_end - 1, {
		end_col = content.col_end,
		conceal = ""
	});
end

latex.render_block = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_start, content.col_start, {
		end_col = content.col_start + 2,

		line_hl_group = set_hl(user_config.hl),
		conceal = ""
	});
	vim.api.nvim_buf_set_extmark(buffer, latex.namespace, content.row_end, content.col_end - 2, {
		virt_text_pos = "right_align",
		virt_text = {
			user_config.text or { " Latex ", "Comment" }
		},

		end_col = content.col_end,
		conceal = "",

		line_hl_group = set_hl(user_config.hl),
		hl_mode = "combine"
	});

	for l = content.row_start + 1, content.row_end - 1, 1 do
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

latex.render = function (render_type, buffer, content, config_table)
	if not config_table or not config_table.latex then
		return;
	elseif config_table.latex and config_table.latex.enable == false then
		return;
	end

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
		pcall(latex.render_superscript, buffer, content, conf)
	elseif render_type == "latex_subscript" then
		pcall(latex.render_subscript, buffer, content, conf)
	elseif render_type == "latex_symbol" then
		pcall(latex.render_symbol, buffer, content, conf.symbols)
	elseif render_type == "latex_root" then
		pcall(latex.render_root, buffer, content, conf)
	end
end

return latex;
