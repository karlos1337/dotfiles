-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")
local lazyterm = function()
  Util.terminal(nil, { cwd = Util.root() })
end
vim.keymap.set("n", "<C-º>", lazyterm, { desc = "Terminal (root dir)" })
vim.keymap.set("t", "<C-º>", "<cmd>close<cr>", { desc = "Close terminal" })
