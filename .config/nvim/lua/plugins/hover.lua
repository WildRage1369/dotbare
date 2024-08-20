require("hover").setup({
	   init = function()
	       require("hover.providers.lsp")
		   require('hover.providers.diagnostic')
		   require('hover.providers.fold_preview')
	   end,
	title = false,
	preview_opts = { border = "none" },
	mouse_delay = 500,
})
