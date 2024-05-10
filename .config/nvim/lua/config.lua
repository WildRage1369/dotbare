local autocmd = vim.api.nvim_create_autocmd

-- These are here to ensure mason.nvim is loaded before mason-lspconfig
require("rocks").packadd("mason.nvim")
require("rocks").packadd("mason-lspconfig")

-- vim settings
vim.wo.wrap = false
vim.wo.breakindent = true
vim.wo.number = true
vim.wo.linebreak = true
vim.wo.relativenumber = true
vim.wo.foldmethod = "indent"
vim.wo.foldlevel = 3
vim.opt.conceallevel = 2
vim.opt.concealcursor = "nc"
vim.opt.shiftwidth = 4
vim.opt.undofile = true
vim.opt.tabstop = 4
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.termguicolors = true
vim.cmd([[set clipboard+=unnamedplus]])
vim.cmd([[set whichwrap+=<,>,[,] ]])
vim.wo.breakindentopt = "shift:4"

-- Rainbow Brackets Settings
vim.g.rainbow_delimiters = {
    blacklist = {},
    highlight = {
        "RainbowDelimiterGreen",
        "RainbowDelimiterBlue",
        "RainbowDelimiterViolet",
        "RainbowDelimiterRed",
        "RainbowDelimiterOrange",
        "RainbowDelimiterYellow",
        "RainbowDelimiterCyan",
    },
}

-- Headline Settings
vim.cmd([[highlight Headline1 guibg=#1e2718 gui=bold]])
vim.cmd([[highlight Headline2 guibg=#271C18 gui=italic]])
vim.cmd([[highlight Headline3 guibg=#TRANSPARENT]])
vim.cmd([[highlight Headline4 guibg=#TRANSPARENT]])
vim.cmd([[highlight Headline5vnoremenu guibg=NONE]])

-- Right click menu settings

-- vim.api.nvim_ui_set_option("Code Actions", vim.lsp.buf.code_action())
vim.opt.pumblend = 20
vim.cmd.aunmenu([[PopUp.How-to\ disable\ mouse]])
-- vim.cmd.aunmenu([[PopUp.-1-]])
vim.cmd.anoremenu([[PopUp.Code\ actions]], [[<Cmd>lua vim.lsp.buf.code_action()<CR>]])
vim.cmd.anoremenu([[PopUp.Rename]], [[<Cmd>lua vim.lsp.buf.rename()<CR>]])
vim.cmd.anoremenu([[PopUp.References]], [[<Cmd>lua vim.lsp.buf.references()<CR>]])

-- Make sure that gruvbox is setup before applying it
require("gruvbox").setup({
    transparent_mode = true,
    contrast = "hard",
    overrides = { Folded = { bold = true, bg = "none", fg = "#d5c4a1" } },
})
vim.cmd("colorscheme gruvbox")

-- resize vim windows when the terminal window is resized
autocmd("VimResized", {
    pattern = "*",
    command = "tabdo wincmd =",
})

-- Set spell and wrap on for text files, otherwise set nospell and nowrap
autocmd("FileType", {
    pattern = "*",
    desc = "Set spell and wrap on for text files, otherwise set nospell and nowrap",
    callback = function(ev)
        local ext = ev.file:match("%..+")
        if ext == ".txt" or ext == ".norg" or ext == ".md" then
            vim.api.nvim_command("set wrap spell")
        else
            vim.api.nvim_command("set nowrap nospell")
        end
    end,
})

-- custom command to compile a Neorg file to PDF through md and html
vim.api.nvim_create_user_command("CompileNeorgPDF", function(input)
    vim.api.nvim_command(":Neorg export to-file ~/Temporary/tmp.md")
    vim.api.nvim_command(
        ": ! pandoc -s -f markdown+lists_without_preceding_blankline -V geometry:margin=1in -V geometry:a4paper -V geometry:nohead=true -V margin-top=0pt -V geometry:textheight=10in ~/Temporary/tmp.md -o "
            .. input.fargs[1]
        -- .. " -H ~/Documents/prepend.txt --pdf-engine=context"
    )
    vim.api.nvim_command("! firefox " .. input.fargs[1])
end, { nargs = 1, complete = "file" })

-- begin other setup
require("luasnip.loaders.from_vscode").lazy_load()
-- require("telescope").load_extension("lsp_handlers")
