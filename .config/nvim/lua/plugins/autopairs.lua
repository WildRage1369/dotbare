local Rule = require("nvim-autopairs.rule")
local npairs = require("nvim-autopairs")
local ts_conds = require("nvim-autopairs.ts-conds")
npairs.setup({
	check_ts = true,
	enable_check_bracket_line = true,
	ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
})
npairs.add_rules({
	Rule("$$", "$$", { "tex", "latex", "norg" }),
	Rule("$", "$", { "tex", "latex", "norg" }),
	Rule("^", "{}", { "tex", "latex", "norg" })
		:with_pair(ts_conds.is_ts_node({ "inline_math", "inline_formula" }))
		:set_end_pair_length(1),
	Rule("_", "{}", { "tex", "latex", "norg" })
		:with_pair(ts_conds.is_ts_node({ "inline_formula", "inline_math" }))
		:set_end_pair_length(1),
	Rule("@math", "@end", "norg"),
	Rule("@code", "@end", "norg"),
}) 
