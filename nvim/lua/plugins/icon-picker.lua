return {
  "ziontee113/icon-picker.nvim",
  keys = {
    -- disable tab key in insert mode
    { "<Tab>", mode = "i", false },
    { "<leader>i", mode = "n", "<cmd>IconPickerNormal<cr>" },
    { "<C-i>", mode = "i", "<cmd>IconPickerInsert<cr>" },
  },
  config = function()
    require("icon-picker").setup({ disable_legacy_commands = true })

    local opts = { noremap = true, silent = true }

    vim.keymap.set("n", "<leader>i", "<cmd>IconPickerNormal<cr>", opts)
    vim.keymap.set("i", "<C-i>", "<cmd>IconPickerInsert<cr>", opts)
  end,
}
