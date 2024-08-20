function map_key(mde, lhs, rhs, dsc, nw, loud)
    loud = loud or true
    nw = nw or false
    dsc = dsc or ""
    require("which-key").add({
        lhs,
        rhs,
        desc = dsc,
        mode = mde,
        nowait = nw,
        silent = loud,
    })
end

vim.g.mapleader = " " -- 'vim.g' sets global variables
vim.o.mousemoveevent = true

-- map_key("n", "<LHS>", "<RHS>", "Desc")
-- map_key("n", "", "", "")
map_key(
    "n",
    "<leader>fm",
    "<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>",
    "[MINI] Open mini.files at buffer location"
)
map_key(
    "n",
    "<leader>fo",
    "<Cmd>lua require('conform').format({ async = true, lsp_fallback = true, bufnr = 0})<CR>",
    "[CONFORM] Format buffer"
)

-- Cokeline keybinds
map_key("n", "<Tab>", "<Plug>(cokeline-focus-next)", "Next buffer")
map_key("n", "<S-Tab>", "<Plug>(cokeline-focus-prev)", "Previous buffer")

-- DAP/GDB keybinds
local dap = require("dap")
map_key("n", "<leader>db", dap.toggle_breakpoint, "DAP Toggle Breakpoint on current line")
map_key("n", "<leader>dl", dap.run_last, "DAP Run Last")
map_key("n", "<leader>dr", dap.run, "DAP Run")
map_key("n", "<leader>dc", dap.continue, "DAP Continue")
map_key("n", "<leader>da", dap.restart, "DAP restart")
map_key("n", "<leader>dj", dap.step_into, "DAP Step Into")
map_key("n", "<leader>dn", dap.step_over, "DAP Step Over")
map_key("n", "<leader>dk", dap.step_out, "DAP Step Out")
map_key("n", "<leader>dt", dap.terminate, "DAP Terminate")
map_key("n", "<leader>de", require("dapui").eval, "DAPUi Evaluate Word Under Cursor")
map_key("v", "<leader>de", require("dapui").eval, "DAPUi Evaluate Word Under Cursor")
map_key("n", "<leader>du", require("dapui").toggle, "DAPUi Toggle")

-- LSP-saga keybinds
map_key("n", "<leader>lo", "<Cmd>Lspsaga outline<CR>", "Show LSP Outline")
map_key("n", "<leader>ld", "<Cmd>Lspsaga peek_definition<CR>", "LSP Peek Definition")
map_key("n", "<leader>lr", "<Cmd>Lspsaga rename<CR>", "LSP Rename")
map_key("n", "<leader>lf", "<Cmd>Lspsaga finder<CR>", "LSP Refrences")
map_key("n", "<leader>la", "<Cmd>Lspsaga code_action<CR>", "LSP Code Actions")
map_key("n", "gd", "<Cmd>Lspsaga goto_definition<CR>", "LSP Go To Definition")
map_key("n", "[e", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", "Previous Error")
map_key("n", "]e", "<Cmd>Lspsaga diagnostic_jump_next<CR>", "Next Error")

-- Telescope keybinds
local tele = require("telescope.builtin")
map_key("n", "<leader>c", "<Cmd>Tele neoclip<CR>", "[Telescope] Open clipboard history")
map_key("n", "<leader>gr", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", "Current buffer fuzzy find")
map_key("n", "<leader>ff", tele.find_files, "[Telescope] List files in CWD")
map_key("n", "<leader>fg", tele.live_grep, "[Telescope] Live search for a string in CWD")
map_key("n", "<leader>fb", tele.current_buffer_fuzzy_find, "[Telescope] Fuzzy find in current buffer")
map_key("n", "<leader>s", tele.spell_suggest, "[Telescope] List Spelling suggestions")
map_key("n", "<leader>of", tele.oldfiles, "[Telescope] List file history")

-- Misc keybinds for Insert and Normal mode
map_key(
    "n",
    "<leader>pp",
    "<Cmd>lua require('nabla').toggle_virt({autogen=true, silent=true})<CR>",
    "[Nabla] Toggle nabla.nvim"
)
map_key("i", "<C-<BS>>", "<ESC>caw", "Delete word behind cursor", true)
map_key("i", "jk", "<Cmd>w<CR>", "Exist insert mode and write", true)
map_key("i", "<C-s>", "<Cmd>w<CR>")
map_key("i", "<PageUp>", "<C-O>25<C-u>")
map_key("i", "<PageDown>", "<C-O>25<C-d>")

map_key("n", "<PageUp>", "25<C-u>")
map_key("n", "<PageDown>", "25<C-d>")
map_key("n", "=a", "gg=G``", "Format all") -- =a mapping to run = on all lines of text
map_key("n", "<S-J>", "<Cmd>Noice dismiss<CR>", "Dismiss notifications")
map_key("n", "<C-s>", "<Cmd>w<CR>")

map_key("n", "<leader>lg", "<Cmd>LazyGit<CR>")
map_key("n", "<leader>po", "<Cmd>lua require('nabla').popup({border='rounded'})<CR>", "[Nabla] Show nabla.nvim popup")
map_key("n", "<leader>toc", "<Cmd>Neorg toc<CR>", "[NEORG] Open Neorg Table of Contents")
map_key("n", "<leader>tw", require("wrapping").toggle_wrap_mode, "Toggle Wrap")
map_key("n", "<leader>is", "zg", "Ignore spelling error")
map_key("n", "<leader>x", "<cmd>bp|bd #<CR>", "Close tab")
map_key("n", "<leader>nl", "o<esc>o", "Insert 2 new lines and go to insert mode on the 2nd line")

-- mappings to make moving the screen easier in normal and insert mode
map_key("n", "<C-k>", function()
    require("cinnamon").scroll("20<C-y>")
end)
map_key("n", "<C-j>", function()
    require("cinnamon").scroll("20<C-e>")
end)
-- map_key("n", "<C-K>", function() require("cinnamon").scroll("25<C-y>") end)
-- map_key("n", "<C-J>", function() require("cinnamon").scroll("25<C-e>") end)
map_key("i", "<C-k>", function()
    require("cinnamon").scroll("20<C-y>")
end)
map_key("i", "<C-j>", function()
    require("cinnamon").scroll("20<C-e>")
end)
-- map_key("i", "<C-K>", function() require("cinnamon").scroll("25<C-y>") end)
-- map_key("i", "<C-J>", function() require("cinnamon").scroll("25<C-e>") end)

map_key("n", "W", "<C-w>") -- mapping to make window managment easier inside of nvim
require("leap").create_default_mappings()
