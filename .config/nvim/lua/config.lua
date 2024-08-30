local autocmd = vim.api.nvim_create_autocmd

function string.isIn(strMatch, strTable)
    for _, v in ipairs(strTable) do
        if v == strMatch then
            return true
        end
    end
end

-- These are here to ensure mason.nvim is loaded before mason-lspconfig
vim.cmd([[packadd mason.nvim]])
vim.cmd([[packadd mason-lspconfig.nvim]])

-- Run config for nvim-dap
--dofile("~/.config/nvim/lua/plugins/nvim-dap.lua")

-- vim settings
vim.wo.wrap = false
vim.wo.breakindent = true
vim.wo.number = true
vim.wo.linebreak = true
vim.wo.foldmethod = "indent"
vim.wo.foldlevel = 3
vim.opt.conceallevel = 2
vim.opt.concealcursor = "nc"
vim.opt.undofile = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.o.expandtab = true
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.termguicolors = true
vim.cmd([[set clipboard+=unnamedplus]])
vim.cmd([[set whichwrap+=<,>,[,] ]])
vim.wo.breakindentopt = "shift:4"

-- noice settings
vim.g.lazy_redraw = true

-- Rainbow Brackets Settings
-- local rainbow_delimiters = require 'rainbow-delimiters'
-- vim.g.rainbow_delimiters = {
-- 	strategy = {
--         [''] = rainbow_delimiters.strategy['global'],
--     },
--     blacklist = {'as'},
--     highlight = {
--         "RainbowDelimiterGreen",
--         "RainbowDelimiterBlue",
--         "RainbowDelimiterViolet",
--         "RainbowDelimiterRed",
--         "RainbowDelimiterOrange",
--         "RainbowDelimiterYellow",
--         "RainbowDelimiterCyan",
--     },
-- 	log = {
-- 		level = vim.log.levels.DEBUG,
-- 	}
-- }
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

-- Headline Settings
vim.cmd([[highlight Headline1 guibg=#1e2718 gui=bold]])
vim.cmd([[highlight Headline2 guibg=#271C18 gui=italic]])
vim.cmd([[highlight Headline3 guibg=#TRANSPARENT]])
vim.cmd([[highlight Headline4 guibg=#TRANSPARENT]])
vim.cmd([[highlight Headline5vnoremenu guibg=NONE]])

-- Right click menu settings
vim.opt.pumblend = 20
vim.cmd.aunmenu([[PopUp.How-to\ disable\ mouse]])
vim.cmd.anoremenu([[PopUp.Code\ Actions]], [[<Cmd>Lspsaga code_action<CR>]])
vim.cmd.anoremenu([[PopUp.Rename]], [[<Cmd>Lspsaga rename<CR>]])
vim.cmd.anoremenu([[PopUp.References]], [[<Cmd>Lspsaga finder<CR>]])

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

autocmd("FileType", {
    pattern = "md,txt,norg",
    command = "setlocal spell",
    desc = "Set spell on for text files",
})
autocmd("FileType", {
    pattern = "norg",
    command = "lua vim.b.miniindentscope_disable = true",
    desc = "Disable mini.indentscope for norg files",
})

-- ofirgall/tmux-window-name setup
local uv = vim.loop

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.env.TMUX_PLUGIN_MANAGER_PATH then
            uv.spawn(vim.env.TMUX_PLUGIN_MANAGER_PATH .. "/tmux-window-name/scripts/rename_session_windows.py", {})
        end
    end,
})

-- custom command to compile a Neorg file to PDF through md and html
vim.api.nvim_create_user_command("CompileNeorgPDF", function(input)
    vim.api.nvim_command(":Neorg export to-file ~/Temporary/tmp.md")
    vim.api.nvim_command(
        ": ! pandoc -s -f markdown+lists_without_preceding_blankline "
            .. "--pdf-engine=xelatex "
            -- .. "--pdf-engine=lualatex "
            .. "-V geometry:'margin=1in, a4paper, nohead=true, textheight=10in' "
            .. "-V margin-top=0pt ~/Temporary/tmp.md -o "
            .. input.fargs[1]
        -- .. " -H ~/Documents/prepend.txt --pdf-engine=context"
    )
    vim.api.nvim_command("! firefox " .. input.fargs[1])
end, { nargs = 1, complete = "file" })

-- begin other setup
require("luasnip.loaders.from_vscode").lazy_load()

-- begin nvim-dap, nvim-dap-ui, and nvim-dap-virtual-text setup

vim.cmd([[packadd nvim-dap]])
local dap = require("dap")
dap.adapters.gdb = {
    type = "executable",
    command = "gdb",
    args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
}

dap.configurations.c = {
    {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
    },
}

dap.configurations.cpp = {
    {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
    },
}

require("nvim-dap-virtual-text").setup({
    enabled = true,
    all_refrences = true,
})

local dapui = require("dapui")
dapui.setup({
    layouts = {
        {
            elements = {
                {
                    id = "stacks",
                    size = 0.20,
                },
                {
                    id = "breakpoints",
                    size = 0.30,
                },
                {
                    id = "scopes",
                    size = 0.50,
                },
            },
            position = "left",
            size = 40,
        },
        {
            elements = {
                {
                    id = "repl",
                    size = 0.33,
                },
                {
                    id = "console",
                    size = 0.33,
                },
                {
                    id = "watches",
                    size = 0.33,
                },
            },
            position = "bottom",
            size = 10,
        },
    },
    mappings = {
        repl = "p",
        remove = "r",
    },
})
dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end
