require("mason-lspconfig").setup_handlers({
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler (optional)
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        require("lspconfig")[server_name].setup({
            capabilities = capabilities,
        })
    end,

    ["lua_ls"] = function()
        require("lspconfig").lua_ls.setup({
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
        require("lspconfig").zls.setup({
            settings = { zls = { warn_style = true } },
        })
    end,

	["pyright"] = function()
		require("lspconfig").pyright.setup({
			settings = { pyright = {
				reportPossiblyUnboundVariable = false,
				reportUnboundVariable = false,
			} }
		})
	end,
})
