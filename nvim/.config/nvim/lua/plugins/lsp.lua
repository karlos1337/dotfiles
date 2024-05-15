return {
  "williamboman/mason-lspconfig",
  config = function()
    local lspconfig = require("lspconfig")
    lspconfig.harper_ls.setup({
      filetypes = { "markdown", "text", "lua" },
    })
  end,
}
