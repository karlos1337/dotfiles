return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = "*", -- set this to "*" if you want to always pull the latest change, false to update on release
  opts = {
    provider = "claude",
    auto_suggestions_provider = "claude",
    claude = {
      model = "claude-3-7-sonnet-20250219",
      endpoint = "https://api.anthropic.com",
      temperature = 0,
      max_tokens = 4096,
    },
    openai = {
      endpoint = "https://api.deepseek.com/v1",
      model = "deepseek-reasoner",
      timeout = 30000,
      temperature = 0,
      max_tokens = 4096,
      api_key_name = "DEEPSEEK_API_KEY",
    },
  },
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
    { "AstroNvim/astrocore", opts = function(_, opts) opts.mappings.n["<Leader>a"] = { desc = " Avante" } end },
  },
}
