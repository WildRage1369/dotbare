require("conform").setup({
    formatters_by_ft = {
        c = { "clang_format" },
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettier" },
        html = { "djlint" },
        css = { "stylelint" },
		rust = { "rustfmt" }
    },
    formatters = {
        clangformat = {
            prepend_args = { "-style='{BasedOnStyle: google, IndentWidth: 4, ColumnLimit: 80, AllowShortIfStatementsOnASingleLine: Always, AllowShortBlocksOnASingleLine: Always,}'" },
        },
        astyle = { prepend_args = { "--style=attach" } },
        stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" } },
        prettier = { prepend_args = { "--use-tabs" } },
		stylelint = { prepend_args = { "--config=/home/maxine/.config/.stylelintrc.json" }}
    },
})
