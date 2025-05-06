return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,
  opts = {
    provider = "claude",
    cursor_applying_provider = "groq",
    auto_suggestions_provider = "claude",
    claude = {
      model = "claude-3-7-sonnet-latest",
      endpoint = "https://api.anthropic.com",
      temperature = 1,
      max_tokens = 20000,
    },
    behaviour = {
      enable_claude_text_editor_tool_mode = true,
      enable_cursor_planning_mode = true,
    },
    vendors = {
      groq = {
        __inherited_from = "openai",
        api_key_name = "GROQ_API_KEY",
        endpoint = "https://api.groq.com/openai/v1",
        model = "llama-3.3-70b-versatile",
      },
      claude_thought = {
        __inherited_from = "claude",
        model = "claude-3-7-sonnet-latest",
        thinking = {
          type = "enabled",
          budget_tokens = 2048,
        },
      },
      deepseek = {
        __inherited_from = "openai",
        endpoint = "https://api.deepseek.com/v1",
        model = "deepseek-reasoner",
        timeout = 30000,
        temperature = 0,
        max_tokens = 4096,
        api_key_name = "DEEPSEEK_API_KEY",
      },
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
