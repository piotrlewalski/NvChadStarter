--local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
--local servers = { "html", "cssls", "clangd", "tsserver", "prettier" }
local servers = { "html", "cssls", "clangd", "tsserver", "efm" }

--copied from NVChad to comment out some mappings
local custom_on_attach = function(client, bufnr)
  local map = vim.keymap.set
  local conf = require("nvconfig").ui.lsp

  local function opts(desc)
    return { buffer = bufnr, desc = "Custom LSP " .. desc }
  end
  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  --map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")

  map("n", "<leader>ra", function()
    require "nvchad.lsp.renamer"()
  end, opts "NvRenamer")

  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  --map("n", "gr", vim.lsp.buf.references, opts "Show references")

  -- setup signature popup
  if conf.signature and client.server_capabilities.signatureHelpProvider then
    require("nvchad.lsp.signature").setup(client, bufnr)
  end
end

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = custom_on_attach,
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
