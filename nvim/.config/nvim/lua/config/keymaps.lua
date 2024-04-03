-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>fB", ":Telescope file_browser<CR>", { desc = "File browser", noremap = true })
vim.keymap.set(
  "n",
  "<leader>fb",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { desc = "File browser (Buffer)", noremap = true }
)
vim.keymap.set("n", "<leader>k", "<cmd>LazyDocker<CR>", { desc = "LazyDocker", noremap = true, silent = true })
vim.keymap.del("n", "<leader>/")
vim.keymap.set(
  "n",
  "<leader>/",
  require("telescope.builtin").current_buffer_fuzzy_find,
  { desc = "Buffer find", noremap = true }
)
