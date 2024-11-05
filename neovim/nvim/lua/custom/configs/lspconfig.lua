local config = require("plugins.configs.lspconfig")

local on_attach = config.on_attach
local capabilities = config.capabilities

local lspconfig = require("lspconfig")

lspconfig["ruff_lsp"].setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"python"},
})

lspconfig["pyright"].setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"python"},

  settings = {
    pyright = {
      disableOrganizeImports = true, -- Using Ruff for import organization
    },
    python = {
      analysis = {
        ignore = { '*' }, -- Using Ruff for linting
        typeCheckingMode = 'off', -- Optional: if using mypy for type checking
      },
    },
  },
})
