local M = {}

M.setup_lsp = function(attach, capabilities)
  local lspconfig = require "lspconfig"

  local servers = {
    "html",
    "cssls",
    "bashls",
    "emmet_ls",
    "tsserver",
    "clangd",
    "gopls",
    "pylsp",
    "sumneko_lua",
    "texlab",
  }

  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      on_attach = attach,
      capabilities = capabilities,
    }
  end
end

return M