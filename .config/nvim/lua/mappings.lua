function map_key(mde, lhs, rhs, dsc, nw, loud)
    loud = loud or true
    nw = nw or false
    dsc = dsc or ""
    -- vim.keymap.set(mde, lhs, rhs, { desc = dsc, nowait = nw, noremap = true, silent = loud })
    require("which-key").register({
        [lhs] = { rhs, dsc },
    }, { mode = mde, nowait = nw, silent = loud })
end

-- map_key("n", "<Space>", "")
vim.g.mapleader = " " -- 'vim.g' sets global variables
vim.keymap.set("n", "<MouseMove>", require("hover").hover_mouse, { desc = "hover.nvim (mouse)" })
vim.keymap.set("i", "<MouseMove>", require("hover").hover_mouse, { desc = "hover.nvim (mouse)" })
vim.o.mousemoveevent = true
map_key("n", "<leader>ns", require("hover").hover_switch("next"), "hover.nvim (next source)")

-- map_key("n", "", "", "")
-- map_key("n", "", vim.lsp.buf.code_action, "LSP Code Actions")
-- map_key("n", "", vim.lsp.buf.rename, "LSP Rename")
-- map_key("n", "", vim.lsp.buf.references, "LSP Refrences")
-- map_key("n", "", vim.diagnostic.goto_next, "LSP go to next error")
map_key(
    "n",
    "<leader>fm",
    ":lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>",
    "[MINI] Open mini.files at buffer location"
)
map_key(
    "n",
    "<leader>fo",
    ":lua require('conform').format({ async = true, lsp_fallback = true, bufnr = 0})<CR>",
    "[CONFORM] Format buffer"
)

map_key("n", "<Tab>", "<Plug>(cokeline-focus-next)", "Next buffer")
map_key("n", "<S-Tab>", "<Plug>(cokeline-focus-prev)", "Previous buffer")

map_key("i", "<C-<BS>>", "<ESC>caw", "Delete word behind cursor", true)
map_key("i", "kl", "<ESC>:w<CR>", "Exist insert mode and write", true)
map_key("i", "jk", "<ESC>", "Exist insert mode", true)
map_key("i", "<C-Right>", "<C-O>e<Right>")
map_key("i", "<C-s>", "<ESC>:w<CR>a")
map_key("i", "<C-Left>", "<C-O>b")
map_key("i", "<Down>", "<C-o>gj")
map_key("i", "<Up>", "<C-o>gk")

map_key(
    "n",
    "<leader>pp",
    ":lua require('nabla').toggle_virt({autogen=true, silent=true})<CR>",
    "[Nabla] Toggle nabla.nvim"
)
map_key("n", "<leader>po", ":lua require('nabla').popup({border='rounded'})<CR>", "[Nabla] Show nabla.nvim popup")
-- map_key("n", "<leader>rs", ":%s/<c-r><c-w>/<c-r><c-w>/gc<c-f>$F/i", "Replace symbol under cursor")
map_key("n", "<leader>gr", ":Telescope current_buffer_fuzzy_find<CR>", "Delete fold")
map_key("n", "<leader>toc", ":Neorg toc<CR>", "[NEORG] Open Neorg Table of Contents")
map_key("n", "<leader>tw", "<cmd>set wrap!<CR>", "Toggle Wrap")
map_key("n", "<leader>is", "zg", "Ignore spelling error")
map_key("n", "<leader>x", "<cmd>bd<CR>", "Close tab")
map_key("n", "<leader>hd", "zd", "Delete fold")
map_key("n", "<leader>hm", "zf%", "Make fold")

local tele = require("telescope.builtin")
map_key("n", "<leader>c", ":Tele neoclip<CR>", "[Telescope] Open clipboard history")
map_key("n", "<leader>ff", tele.find_files, "[Telescope] List files in CWD")
map_key("n", "<leader>fg", tele.live_grep, "[Telescope] Live search for a string in CWD")
map_key("n", "<leader>fb", tele.current_buffer_fuzzy_find, "[Telescope] Fuzzy find in current buffer")
map_key("n", "<leader>s", tele.spell_suggest, "[Telescope] List Spelling suggestions")
map_key("n", "<leader>of", tele.oldfiles, "[Telescope] List file history")

map_key("n", "<C-s>", ":w<CR>")
map_key("n", "=a", "gg=G``", "Format all")
map_key("n", "<Down>", "gj")
map_key("n", "<Up>", "gk")
map_key("n", "<C-Right>", "e")
map_key("n", "<C-Left>", "b")

map_key("t", "jk", "<C-\\><C-n>", "", true)
