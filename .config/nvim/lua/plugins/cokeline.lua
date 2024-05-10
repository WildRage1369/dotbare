local get_hex = require('cokeline/utils').get_hex
vim.cmd([[highlight TabLineFill guibg=#TRANSPARENT]])

local cmpnents = {
		sep_left = {
			text = " ",
			fg = function(buffer)
				if buffer.is_focused then
					return get_hex('Normal', 'fg')
				else
					return get_hex('ColorColumn', 'bg')
				end
			end,

			bg = function(buffer)
				if buffer.is_focused then
					return get_hex('Normal', 'bg')
				else
					return get_hex('ColorColumn', 'fg')
				end
			end,
		},
        icon = {
            text = function(buffer)
                if buffer.diagnostics.errors == 0 and buffer.diagnostics.warnings == 0 then
					return buffer.devicon.icon
                else
					return ""
                end
            end,
            fg = function(buffer)
                return buffer.devicon.color
            end,
        },
        err = {
            text = function(buffer)
                if buffer.diagnostics.errors ~= 0 then
                    return "" .. buffer.diagnostics.errors .. " "
                else
                    return ""
                end
            end,
            fg = "#eb2121",
        },
		warn = {
            text = function(buffer)
                if buffer.diagnostics.warnings ~= 0 then
                    return "" .. buffer.diagnostics.warnings .. " "
                else
                    return ""
                end
            end,
            fg = "#40a7d8",
        },
        prefix = {
            text = function(buffer)
                return buffer.unique_prefix
            end,
            italic = true,
			truncation = { direction = 'left'}
        },
        filename = {
            text = function(buffer)
                return buffer.filename
            end,
            bold = true,
            italic = true,
			truncation = { direction = 'middle'}
        },
		modified = {
            text = function(buffer)
                if buffer.is_modified then
					return "[+]"
				else
					return ""
				end
            end,
			truncation = { direction = 'middle'}
        },
		sep_right = {
			text = "",
			fg = function(buffer)
				if buffer.is_focused then
					return get_hex('Normal', 'fg')
				else
					return get_hex('ColorColumn', 'bg')
				end
			end,

			bg = function(buffer)
				if buffer.is_focused then
					return get_hex('Normal', 'bg')
				else
					return get_hex('ColorColumn', 'fg')
				end
			end,
			truncation = { priority = 1}
		},
    }

require("cokeline").setup({
    buffers = {
        focus_on_delete = "prev",
    },
    rendering = {
        max_buffer_width = 30,
    },
	fill_hl = 'none',
    components = {
		cmpnents.sep_left,
		cmpnents.icon,
		cmpnents.err,
		cmpnents.warn,
		cmpnents.modified,
		cmpnents.prefix,
		cmpnents.filename,
		cmpnents.sep_right,
	}
})
