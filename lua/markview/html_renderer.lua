local html = {};

html.namespace = nil;

---@type table<string, string> HTML entities lookup table
html.entities = {
	---+ ${class, HTML entities lookup table}
    Aacute = "Á",
    aacute = "á",
    Acirc = "Â",
    acirc = "â",
    acute = "´",
    AElig = "Æ",
    aelig = "æ",
    Agrave = "À",
    agrave = "à",
    alefsym = "ℵ",
    Alpha = "Α",
    alpha = "α",
    amp = "&",
    ["and"] = "∧",
    ang = "∠",
    Aring = "Å",
    aring = "å",
    asymp = "≈",
    Atilde = "Ã",
    atilde = "ã",
    Auml = "Ä",
    auml = "ä",
    bdquo = "„",
    Beta = "Β",
    beta = "β",
    brvbar = "¦",
    bull = "•",
    cap = "∩",
    Ccedil = "Ç",
    ccedil = "ç",
    cedil = "¸",
    cent = "¢",
    Chi = "Χ",
    chi = "χ",
    circ = "ˆ",
    clubs = "♣",
    congc = "≅",
    copy = "©",
    crarr = "↵",
    cup = "∪",
    curren = "¤",
    Dagger = "‡",
    dagger = "†",
    dArr = "⇓",
    darr = "↓",
    deg = "°",
    Delta = "Δ",
    delta = "δ",
    diams = "♦",
    divide = "÷",
    Eacute = "É",
    eacute = "é",
    Ecirc = "Ê",
    ecirc = "ê",
    Egrave = "È",
    egrave = "è",
    empty = "∅",
    Epsilon = "Ε",
    epsilon = "ε",
    equiv = "≡",
    Eta = "Η",
    eta = "η",
    ETH = "Ð",
    eth = "ð",
    Euml = "Ë",
    euml = "ë",
    euro = "€",
    exists = "∃",
    fnof = "ƒ",
    forall = "∀",
    frac12 = "½",
    frac14 = "¼",
    frac34 = "¾",
    frasl = "⁄",
    Gamma = "Γ",
    gamma = "γ",
    ge = "≥",
    gt = ">",
    harr = "↔",
    hArr = "⇔",
    hearts = "♥",
    hellip = "…",
    Iacute = "Í",
    iacute = "í",
    Icirc = "Î",
    icirc = "î",
    iexcl = "¡",
    Igrave = "Ì",
    igrave = "ì",
    image = "ℑ",
    infin = "∞",
    int = "∫",
    Iota = "Ι",
    iota = "ι",
    iquest = "¿",
    isin = "∈",
    Iuml = "Ï",
    iuml = "ï",
    Kappa = "Κ",
    kappa = "κ",
    Lambda = "Λ",
    lambda = "λ",
    lang = "⟨",
    laquo = "«",
    lArr = "⇐",
    larr = "←",
    lceil = "⌈",
    ldquo = "“",
    le = "≤",
    lfloor = "⌊",
    lowast = "∗",
    loz = "◊",
    -- lrm = "‎",
    lsaquo = "‹",
    lsquo = "‘",
    lt = "<",
    macr = "¯",
    mdash = "—",
    micro = "µ",
    middot = "·",
    minus = "−",
    Mu = "Μ",
    mu = "μ",
    nabla = "∇",
    nbsp = " ",
    ndash = "–",
    ne = "≠",
    ni = "∋",
    ["not"] = "¬",
    notin = "∉",
    nsub = "⊄",
    Ntilde = "Ñ",
    ntilde = "ñ",
    Nu = "Ν",
    nu = "ν",
    Oacute = "Ó",
    oacute = "ó",
    Ocirc = "Ô",
    ocirc = "ô",
    OElig = "Œ",
    oelig = "œ",
    Ograve = "Ò",
    ograve = "ò",
    Omeg = "Ω",
    omega = "ω",
    Omicron = "Ο",
    omicron = "ο",
    oline = "‾",
    ["or"] = "∨",
    Oslash = "Ø",
    oslash = "ø",
    Otilde = "Õ",
    otilde = "õ",
    Ouml = "Ö",
    ouml = "ö",
    para = "¶",
    part = "∂",
    permil = "‰",
    perp = "⊥",
    Phi = "Φ",
    phi = "φ",
    Pi = "Π",
    pi = "π",
    piv = "ϖ",
    plusmn = "±",
    pound = "£",
    Prime = "″",
    prime = "′",
    prod = "∏",
    prop = "∝",
    Psi = "Ψ",
    psi = "ψ",
    quot = "\"",
    radic = "√",
    rang = "⟩",
    raquo = "»",
    rArr = "⇒",
    rarr = "→",
    rceil = "⌉",
    rdquo = "”",
    real = "ℜ",
    reg = "®",
    rflo = "⌋",
    Rho = "Ρ",
    rho = "ρ",
    -- rlm = "‏",
    rsaquo = "›",
    rsquo = "’",
    sbquo = "‚",
    Scaron = "Š",
    scaron = "š",
    sdot = "⋅",
    sect = "§",
    shy = "­",
    Sigma = "Σ",
    sigma = "σ",
    sigmaf = "ς",
    sim = "∼",
    spades = "♠",
    sub = "⊂",
    sube = "⊆",
    sum = "∑",
    sup = "⊃",
    sup1 = "¹",
    sup2 = "²",
    sup3 = "³",
    supe = "⊇",
    szlig = "ß",
    Tau = "Τ",
    tau = "τ",
    there4 = "∴",
    Theta = "Θ",
    theta = "θ",
    thetasym = "ϑ",
    thinsp = " ",
    THORN = "Þ",
    thorn = "þ",
    tilde = "˜",
    times = "×",
    trade = "™",
    Uacute = "Ú",
    uacute = "ú",
    uArr = "⇑",
    uarr = "↑",
    Ucirc = "Û",
    ucirc = "û",
    Ugrave = "Ù",
    ugrave = "ù",
    uml = "¨",
    upsih = "ϒ",
    Upsilon = "Υ",
    upsilon = "υ",
    Uuml = "Ü",
    uuml = "ü",
    weierp = "℘",
    Xi = "Ξ",
    xi = "ξ",
    Yacute = "Ý",
    yacute = "ý",
    yen = "¥",
    yuml = "ÿ",
    Yuml = "Ÿ",
    Zeta = "Ζ",
    zeta = "ζ",
    -- zwj = "‍",
    -- zwnj = "‌"
	---_
}

--- Gets an HTML entity & it's character width
---@param string string
---@return string
html.get_entity = function (string)
	return html.entities[string];
end
--- Sets the namespace
---@param ns integer
html.set_namespace = function (ns)
	html.namespace = ns;
end

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

--- Renders HTML tags
---@param buffer integer
---@param content table
---@param user_config markview.html.tags
html.render_inline = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	local html_conf = user_config.default or {};

	if user_config.configs[string.lower(content.tag)] then
		html_conf = user_config.configs[string.lower(content.tag)];
	end

	if html_conf.conceal ~= false then
		vim.api.nvim_buf_set_extmark(buffer, html.namespace, content.row_start, content.start_tag_col_start, {
			end_col = content.start_tag_col_end,
			conceal = ""
		});
		vim.api.nvim_buf_set_extmark(buffer, html.namespace, content.row_start, content.end_tag_col_start, {
			end_col = content.end_tag_col_end,
			conceal = ""
		});
	end

	if html_conf.hl then
		vim.api.nvim_buf_add_highlight(buffer, html.namespace, html_conf.hl, content.row_start, content.start_tag_col_end, content.end_tag_col_start);
	end
end

--- Renders HTML entities
---@param buffer integer
---@param content table
---@param user_config markview.html.entities
html.render_entities = function (buffer, content, user_config)
	if not user_config or user_config.enable == false then
		return;
	end

	local filtered_entity = content.text:gsub("[&;]", "");
	local entity = html.get_entity(filtered_entity);


	if not entity then
		return;
	end

	vim.api.nvim_buf_set_extmark(buffer, html.namespace, content.row_start, content.col_start, {
		virt_text_pos = "inline",
		virt_text = {
			{ entity, set_hl(user_config.hl) }
		},

		end_col = content.col_end,
		conceal = ""
	});
end

--- Renders latex
---@param render_type string
---@param buffer integer
---@param content table
---@param config_table markview.configuration
html.render = function (render_type, buffer, content, config_table)
	if not config_table or not config_table.html then
		return;
	elseif config_table.html and config_table.html.enable == false then
		return;
	end

	---@type markview.conf.html
	local conf = config_table.html;

	if render_type == "html_inline" then
		pcall(html.render_inline, buffer, content, conf.tags);
	elseif render_type == "html_entity" then
		pcall(html.render_entities, buffer, content, conf.entities);
	end
end

return html;
