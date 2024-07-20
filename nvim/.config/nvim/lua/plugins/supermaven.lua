return {
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<C-Tab>",
          clear_suggestion = "<C-S-Tab>",
        },
      })
    end,
  },
}
