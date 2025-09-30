if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,
  opts = {
    provider = "claude",
    cursor_applying_provider = "groq",
    auto_suggestions_provider = "claude",
    providers = {
      claude = {
        model = "claude-sonnet-4-20250514",
        endpoint = "https://api.anthropic.com",
        extra_request_body = {
          temperature = 1,
          max_tokens = 20000,
        },
        thinking = {
          type = "enabled",
          budget_tokens = 2048,
        },
      },
      groq = {
        __inherited_from = "openai",
        api_key_name = "GROQ_API_KEY",
        endpoint = "https://api.groq.com/openai/v1",
        model = "llama-3.3-70b-versatile",
      },
      deepseek = {
        __inherited_from = "openai",
        endpoint = "https://api.deepseek.com/v1",
        model = "deepseek-reasoner",
        timeout = 30000,
        max_tokens = 4096,
        api_key_name = "DEEPSEEK_API_KEY",
        extra_request_body = {
          temperature = 0,
        },
      },
    },
    behaviour = {
      enable_claude_text_editor_tool_mode = true,
      enable_cursor_planning_mode = true,
    },
  },
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    -- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
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
