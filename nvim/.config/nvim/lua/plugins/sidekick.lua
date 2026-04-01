return {
  {
    "folke/sidekick.nvim",
    opts = {
      nes = { enabled = false },
      cli = {
        picker = "snacks",
        win = {
          layout = "right",
          split = { width = 80 },
        },
      },
    },
    keys = {
      { "<leader>a", nil, desc = "󰚩 AI" },
      {
        "<c-.>",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle "claude" end,
        desc = "Toggle Claude Code",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        desc = "Select CLI tool",
      },
      {
        "<leader>ad",
        function() require("sidekick.cli").detach() end,
        desc = "Detach session",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send() end,
        desc = "Send selection",
        mode = { "n", "x" },
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send_file() end,
        desc = "Send file",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        desc = "Prompt",
      },
    },
  },
}
