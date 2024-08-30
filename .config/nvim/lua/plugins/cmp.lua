local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require("cmp")

vim.cmd([[packadd luasnip]])
vim.cmd([[packadd lspkind.nvim]])
vim.cmd([[packadd supermaven-nvim]])

local luasnip = require("luasnip")
local lspkind = require("lspkind")
local compare = require("cmp.config.compare")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

lspkind.init({ symbol_map = { Supermaven = "" } })

local source_mapping = {
    buffer = "[Buf]",
    nvim_lsp = "[LSP]",
    nvim_lua = "[Lua]",
    supermaven = "[SM]",
    path = "[Path]",
    latex_symbols = "[LaTeX]",
}
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    -- experimental = {ghost_text = true},
    sorting = {
        priority_weight = 2,
        comparators = {
            compare.locality,
            compare.recently_used,
            compare.score,
            compare.offset,
            compare.order,
        },
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = "symbol" })
            vim_item.menu = source_mapping[entry.source.name]
            local maxwidth = 80
            vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)
            return vim_item
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<Down>"] = cmp.mapping(function(fallback)
            cmp.close()
            fallback()
        end, { "i" }),
        ["<Up>"] = cmp.mapping(function(fallback)
            cmp.close()
            fallback()
        end, { "i" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping({
            i = function(fallback)
                if cmp.visible() and cmp.get_active_entry() then
                    if luasnip.expandable() then
                        luasnip.expand()
                    -- elseif suggestion.has_suggestion() then
                    --     suggestion.on_accept_suggestion()
                    else
                        cmp.confirm({
                            behavior = cmp.ConfirmBehavior.Replace,
                            select = true,
                        })
                    end
                    -- cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                else
                    fallback()
                end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "supermaven" },
        { name = "buffer" },
        { name = "async_path" },
        { name = "neorg" },
        {
            name = "latex_symbols",
            option = {
                strategy = 2, -- latex: show and insert the *command*
            },
        },
    }, {
        name = "buffer",
    }),
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline({
        ["<cr>"] = {
            c = cmp.mapping.confirm({ select = false }),
        },
    }),
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
    matching = { disallow_symbol_nonprefix_matching = false },
})

cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
