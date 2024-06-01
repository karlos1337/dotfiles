return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.inlay_hints.enabled = false
    opts.setup.rust_analyzer = function()
      return true
    end
  end,
}
