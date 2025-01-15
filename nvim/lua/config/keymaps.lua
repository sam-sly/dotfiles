-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- local file_utils = require("config.utils.file")

-- windows
vim.keymap.set("n", "<leader>L", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>J", "<C-W>s", { desc = "Split Window Below", remap = true })

-- smart-splits
vim.keymap.set("n", "<C-A-h>", require("smart-splits").resize_left, { desc = "Resize pane left" })
vim.keymap.set("n", "<C-A-j>", require("smart-splits").resize_down, { desc = "Resize pane down" })
vim.keymap.set("n", "<C-A-k>", require("smart-splits").resize_up, { desc = "Resize pane up" })
vim.keymap.set("n", "<C-A-l>", require("smart-splits").resize_right, { desc = "Resize pane right" })
-- moving between splits
vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left, { desc = "Select window left" })
vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down, { desc = "Select window down" })
vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up, { desc = "Select window up" })
vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right, { desc = "Select window right" })

-- zen mode
vim.keymap.set("n", "<leader>z", require("zen-mode").toggle, { desc = "Zen Mode" })

-- create/delete files
-- vim.keymap.set(
--   "n",
--   "<leader>fn",
--   file_utils.create_new_file_in_current_dir,
--   { desc = "New File in Current Buffer's Directory" }
-- )
-- vim.keymap.set(
--   "n",
--   "<leader>fN",
--   file_utils.create_new_file_in_project_root,
--   { desc = "New File in Project Root Directory" }
-- )
-- vim.keymap.set("n", "<leader>fd", file_utils.delete_current_file, { desc = "Delete Current File" })
-- vim.keymap.set(
--   "n",
--   "<leader>fD",
--   file_utils.delete_current_file_and_empty_dirs,
--   { desc = "Delete File and Empty Directories" }
-- )

-- include copilot in completion list
vim.api.nvim_set_keymap(
  "i",
  "<C-Space>",
  [[lua require('blink.cmp').trigger_source('copilot')]],
  { noremap = true, silent = true, expr = true }
)
