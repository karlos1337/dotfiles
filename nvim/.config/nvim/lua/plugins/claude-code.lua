if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("claude-code").setup {
      window = {
        split_ratio = 0.4,
        position = "vertical",
      },
      command = "claude",
      shell = {
        pushd_cmd = "nu -c 'use std/dirs shells-aliases *; enter'", -- cadena completa
        popd_cmd = "nu -c 'use std/dirs shells-aliases *; dexit'",
        separator = ";",
      },
      keymaps = {
        toggle = {
          normal = "<C-\\>",
          terminal = "<C-\\>",
        },
      },
    }
  end,
}
