--------------- Language Servers Configuration ---------------

require'lspconfig'.vimls.setup{}
require'lspconfig'.clangd.setup{}
require'lspconfig'.pyright.setup{}
require'lspconfig'.sumneko_lua.setup{}

local installer = require("nvim-lsp-installer")

installer.settings {
	ui = {
		icons = {
			server_installed   = "»",
			server_pending     = "«",
			server_uninstalled = "×"
		}
	},
	keymaps = {
		toggle_server_expand = "<CR>",
		install_server = "i",
		update_server = "o",
		uninstall_server = "u",
	}
}
