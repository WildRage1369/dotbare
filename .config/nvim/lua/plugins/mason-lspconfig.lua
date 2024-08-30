local capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
)

require'lspconfig'.glsl_analyzer.setup{}
require("mason-lspconfig").setup_handlers({
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.

    function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup({
            capabilities = capabilities,
        })
    end,

    ["lua_ls"] = function()
        require("lspconfig").lua_ls.setup({
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                        disable = { "lowercase-global" },
                    },
                },
            },
        })
    end,
    ["zls"] = function()
        require("lspconfig")["zls"].setup({
            capabilities = capabilities,
            settings = { zls = {
                warn_style = true,
                zig_exe_path = nil
            } },
            -- cmd = {"/home/maxine/Software/zls"}
        })
    end,

    ["pyright"] = function()
        require("lspconfig").pyright.setup({
            capabilities = capabilities,
            settings = {
                pyright = {
                    reportPossiblyUnboundVariable = false,
                    reportUnboundVariable = false,
                },
            },
        })
    end,
})
