--- Creates a configuration table for a LaTeX command.
---@param name string Command name(Text to show).
---@param text_pos? "overlay" | "inline" `virt_text_pos` extmark options.
---@param cmd_conceal? integer Characters to conceal.
---@param cmd_hl? string Highlight group for the command.
---@return markview.config.latex.commands.opts
local operator = function (name, text_pos, cmd_conceal, cmd_hl)
	return {
		condition = function (item)
			return #item.args == 1;
		end,

		on_command = function (item)
			local symbols = require("markview.symbols");

			return {
				end_col = item.range[2] + (cmd_conceal or 1),
				conceal = "",

				virt_text_pos = text_pos or "overlay",
				virt_text = {
					{ symbols.tostring("default", name), cmd_hl or "@keyword.function" }
				},

				hl_mode = "combine"
			}
		end,

		on_args = {
			{
				on_before = function (item)
					return {
						end_col = item.range[2] + 1,

						virt_text_pos = "overlay",
						virt_text = {
							{ "(", "@punctuation.bracket" }
						},

						hl_mode = "combine"
					}
				end,

				after_offset = function (range)
					return { range[1], range[2], range[3], range[4] - 1 };
				end,

				on_after = function (item)
					return {
						end_col = item.range[4],

						virt_text_pos = "overlay",
						virt_text = {
							{ ")", "@punctuation.bracket" }
						},

						hl_mode = "combine"
					}
				end
			}
		}
	};
end

return {
	enable = true,

	blocks = {
		enable = true,

		hl = "MarkviewCode",
		pad_char = " ",
		pad_amount = 3,

		text = "  LaTeX ",
		text_hl = "MarkviewCodeInfo"
	},

	commands = {
		enable = true,

		["boxed"] = {
			condition = function (item)
				return #item.args == 1;
			end,
			on_command = {
				conceal = ""
			},

			on_args = {
				{
					on_before = function (item)
						return {
							end_col = item.range[2] + 1,
							conceal = "",

							virt_text_pos = "inline",
							virt_text = {
								{ " ", "MarkviewPalette4Fg" },
								{ "[", "@punctuation.bracket.latex" }
							},

							hl_mode = "combine"
						}
					end,

					after_offset = function (range)
						return { range[1], range[2], range[3], range[4] - 1 };
					end,
					on_after = function (item)
						return {
							end_col = item.range[4],
							conceal = "",

							virt_text_pos = "inline",
							virt_text = {
								{ "]", "@punctuation.bracket" }
							},

							hl_mode = "combine"
						}
					end
				}
			}
		},
		["frac"] = {
			condition = function (item)
				return #item.args == 2;
			end,
			on_command = {
				conceal = ""
			},

			on_args = {
				{
					on_before = function (item)
						return {
							end_col = item.range[2] + 1,
							conceal = "",

							virt_text_pos = "inline",
							virt_text = {
								{ "(", "@punctuation.bracket" }
							},

							hl_mode = "combine"
						}
					end,

					after_offset = function (range)
						return { range[1], range[2], range[3], range[4] - 1 };
					end,
					on_after = function (item)
						return {
							end_col = item.range[4],
							conceal = "",

							virt_text_pos = "inline",
							virt_text = {
								{ ")", "@punctuation.bracket" },
								{ " ÷ ", "@keyword.function" }
							},

							hl_mode = "combine"
						}
					end
				},
				{
					on_before = function (item)
						return {
							end_col = item.range[2] + 1,
							conceal = "",

							virt_text_pos = "inline",
							virt_text = {
								{ "(", "@punctuation.bracket" }
							},

							hl_mode = "combine"
						}
					end,

					after_offset = function (range)
						return { range[1], range[2], range[3], range[4] - 1 };
					end,
					on_after = function (item)
						return {
							end_col = item.range[4],
							conceal = "",

							virt_text_pos = "inline",
							virt_text = {
								{ ")", "@punctuation.bracket" },
							},

							hl_mode = "combine"
						}
					end
				},
			}
		},

		["vec"] = {
			condition = function (item)
				return #item.args == 1;
			end,
			on_command = {
				conceal = ""
			},

			on_args = {
				{
					on_before = function (item)
						return {
							end_col = item.range[2] + 1,
							conceal = "",

							virt_text_pos = "inline",
							virt_text = {
								{ "󱈥 ", "MarkviewPalette2Fg" },
								{ "(", "@punctuation.bracket.latex" }
							},

							hl_mode = "combine"
						}
					end,

					after_offset = function (range)
						return { range[1], range[2], range[3], range[4] - 1 };
					end,
					on_after = function (item)
						return {
							end_col = item.range[4],
							conceal = "",

							virt_text_pos = "inline",
							virt_text = {
								{ ")", "@punctuation.bracket" }
							},

							hl_mode = "combine"
						}
					end
				}
			}
		},

		["sin"] = operator("sin"),
		["cos"] = operator("cos"),
		["tan"] = operator("tan"),

		["sinh"] = operator("sinh"),
		["cosh"] = operator("cosh"),
		["tanh"] = operator("tanh"),

		["csc"] = operator("csc"),
		["sec"] = operator("sec"),
		["cot"] = operator("cot"),

		["csch"] = operator("csch"),
		["sech"] = operator("sech"),
		["coth"] = operator("coth"),

		["arcsin"] = operator("arcsin"),
		["arccos"] = operator("arccos"),
		["arctan"] = operator("arctan"),

		["arg"] = operator("arg"),
		["deg"] = operator("deg"),
		["det"] = operator("det"),
		["dim"] = operator("dim"),
		["exp"] = operator("exp"),
		["gcd"] = operator("gcd"),
		["hom"] = operator("hom"),
		["inf"] = operator("inf"),
		["ker"] = operator("ker"),
		["lg"] = operator("lg"),

		["lim"] = operator("lim"),
		["liminf"] = operator("lim inf", "inline", 7),
		["limsup"] = operator("lim sup", "inline", 7),

		["ln"] = operator("ln"),
		["log"] = operator("log"),
		["min"] = operator("min"),
		["max"] = operator("max"),
		["Pr"] = operator("Pr"),
		["sup"] = operator("sup"),

		---@diagnostic disable:assign-type-mismatch
		["sqrt"] = function ()
			local symbols = require("markview.symbols");
			return operator(symbols.entries.sqrt, "inline", 5);
		end,
		["lvert"] = function ()
			local symbols = require("markview.symbols");
			return operator(symbols.entries.vert, "inline", 6);
		end,
		["lVert"] = function ()
			local symbols = require("markview.symbols");
			return operator(symbols.entries.Vert, "inline", 6);
		end,
		---@diagnostic enable:assign-type-mismatch
	},

	escapes = {
		enable = true
	},

	fonts = {
		enable = true,

		default = {
			enable = true,
			hl = "MarkviewSpecial"
		},

		mathbf = { enable = true },
		mathbfit = { enable = true },
		mathcal = { enable = true },
		mathbfscr = { enable = true },
		mathfrak = { enable = true },
		mathbb = { enable = true },
		mathbffrak = { enable = true },
		mathsf = { enable = true },
		mathsfbf = { enable = true },
		mathsfit = { enable = true },
		mathsfbfit = { enable = true },
		mathtt = { enable = true },
		mathrm = { enable = true },
	},

	inlines = {
		enable = true,

		padding_left = " ",
		padding_right = " ",

		hl = "MarkviewInlineCode"
	},

	parenthesis = {
		enable = true,
	},

	subscripts = {
		enable = true,

		hl = "MarkviewSubscript"
	},

	superscripts = {
		enable = true,

		hl = "MarkviewSuperscript"
	},

	symbols = {
		enable = true,

		hl = "MarkviewComment"
	},

	texts = {
		enable = true
	},
};
