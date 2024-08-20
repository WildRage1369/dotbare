local Rule = require("nvim-autopairs.rule")
local npairs = require("nvim-autopairs")
local cond = require("nvim-autopairs.conds")
local ts_conds = require("nvim-autopairs.ts-conds")
local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" }, { "|", "|" } }
npairs.setup({
    check_ts = true,
    enable_check_bracket_line = true,
    ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
    fast_wrap = {
        before_key = "b",
        after_key = "a",
        end_key = "e",
    },
})

npairs.add_rules({
    -- add $$ and allow to move past it when closing $
    Rule("$", "$", { "tex", "latex" }):with_move(cond.done),
	Rule("$", "$", "norg"):with_move(cond.done):set_end_pair_length(1),

    -- add \frac{} and move cursor to numerator
    Rule("\\fr", "ac{}", { "tex", "latex", "norg" }):set_end_pair_length(1):with_del(cond.none),
    -- add space to \int
    Rule("\\int", " ", { "tex", "latex", "norg" }):set_end_pair_length(0):with_del(cond.none),
    Rule("\\inf", "ty", { "tex", "latex", "norg" }):set_end_pair_length(0):with_del(cond.none),
    -- replace \ohm with "\Omega "
    Rule("\\ohm", "", { "tex", "latex", "norg" }):set_end_pair_length(0):with_del(cond.none):replace_endpair(function()
        return "<BS><BS><BS><BS>\\Omega "
    end),
    -- replace \rarr with "\rightarrow "
    Rule("\\rarr", "", { "tex", "latex", "norg" })
        :set_end_pair_length(0)
        :with_del(cond.none)
        :replace_endpair(function()
            return "<BS><BS><BS>ightarrow "
        end),
    Rule("\\lap", "mathcal{L}", { "tex", "latex", "norg" })
	:set_end_pair_length(1)
        :with_del(cond.none)
        :replace_endpair(function()
			return "<BS><BS><BS>mathcal{L}\\{}"
        end),

	Rule("\\invlap", "mathcal{L}^{-1}", { "tex", "latex", "norg" })
	:set_end_pair_length(1)
        :with_del(cond.none)
        :replace_endpair(function()
			return "<BS><BS><BS><BS><BS><BS>mathcal{L}^{-1}\\{}"
        end),


    -- converts left/right to \frac{left}{right}
	Rule("$.*[%s$]%S*/%S*[%s%$].*$", "", { "tex", "latex", "norg" })
        :with_pair(ts_conds.is_ts_node({ "inline_math", "inline_formula", "latex", "math" }))
        :set_end_pair_length(0)
        :use_regex(true, " ")
        :with_del(cond.none())
        :replace_endpair(function(opts)
            -- match any char that is not whitespace or '$' any amount of times
            -- followed or prefixed by a /
            left = opts.text:match("[^%s$]+/")
            right = opts.text:match("/[^%s$]+")
            statusL, msgL = pcall(string.len, left)
            statusR, msgR = pcall(string.len, right)

            if not statusL or not statusR then
                return ""
            end
            return ""
                .. string.rep("<BS>", left:len() + right:len())
                .. "\\frac{"
                .. left:match("[^/%s$]+")
                .. "}{"
                .. right:match("[^/%s$]+")
                .. "}"
        end),

    -- add {} to ^ and _ only when in math
    Rule("^", "{}", { "tex", "latex", "norg" })
        :with_pair(ts_conds.is_ts_node({ "inline_math", "inline_formula", "latex", "math" }))
        :set_end_pair_length(1),
    Rule("_", "{}", { "tex", "latex", "norg" })
        :with_pair(ts_conds.is_ts_node({ "inline_formula", "inline_math", "latex", "math" }))
        :set_end_pair_length(1),

    -- add @end to @math and @code only on <CR>
    Rule("%", "%", "norg"),
    Rule("@math", "@end", "norg"):end_wise(cond.done()),
    Rule("@code", "@end", "norg"):end_wise(cond.done()),

    Rule(" ", " ")
        -- Pair will only occur if the conditional function returns true
        :with_pair(function(opts)
            -- We are checking if we are inserting a space in (), [], or {}
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
                brackets[1][1] .. brackets[1][2],
                brackets[2][1] .. brackets[2][2],
                brackets[3][1] .. brackets[3][2],
            }, pair)
        end)
        :with_move(cond.none())
        :with_cr(cond.none())
        -- We only want to delete the pair of spaces when the cursor is as such: ( | )
        :with_del(function(opts)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local context = opts.line:sub(col - 1, col + 2)
            return vim.tbl_contains({
                brackets[1][1] .. "  " .. brackets[1][2],
                brackets[2][1] .. "  " .. brackets[2][2],
                brackets[3][1] .. "  " .. brackets[3][2],
            }, context)
        end),
})
-- For each pair of brackets we will add another rule
for _, bracket in pairs(brackets) do
    npairs.add_rules({
        -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
        Rule(bracket[1] .. " ", " " .. bracket[2])
            :with_pair(cond.none())
            :with_move(function(opts)
                return opts.char == bracket[2]
            end)
            :with_del(cond.none())
            :use_key(bracket[2])
            -- Removes the trailing whitespace that can occur without this
            :replace_map_cr(function(_)
                return "<C-c>2xi<CR><C-c>O"
            end),
    })
end
