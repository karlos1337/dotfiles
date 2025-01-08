if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    {
      "<leader>a",
      "<cmd>CodeCompanionChat Toggle<cr>",
      mode = { "v", "n" },
      desc = "CodeCompanion Chat",
    },
  },
  config = function()
    require("codecompanion").setup {
      opts = {
        language = "Spanish",
      },
      strategies = {
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
      },
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = {
              api_key = "cmd:cat ~/Documentos/anthropic-api",
            },
          })
        end,
      },
    }
  end,
}
