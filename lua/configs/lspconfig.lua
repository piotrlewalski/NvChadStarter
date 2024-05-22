-- EXAMPLE 
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
--local servers = { "html", "cssls", "clangd", "tsserver", "prettier" }
local servers = { "html", "cssls", "clangd", "tsserver", "efm" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- typescript
--lspconfig.tsserver.setup {
--  on_attach = on_attach,
--  on_init = on_init,
--  capabilities = capabilities,
--}
local languages = require("efmls-configs.defaults").languages()
local efmls_config = {
	filetypes = vim.tbl_keys(languages),
	settings = {
		rootMarkers = { ".git/" },
		languages = languages,
	},
	init_options = {
		documentFormatting = true,
		documentRangeFormatting = true,
		codeAction = false,
		hover = false,
		documentSymbol = false,
		completion = false,
    inlayHints = false,
	},
}
----languages["lua"] = nil
lspconfig.efm.setup(vim.tbl_extend("force", efmls_config, {
}))
