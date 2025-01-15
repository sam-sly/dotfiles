return {
  "folke/zen-mode.nvim",
  lazy = true,
  keys = { "<leader>z" },
  opts = {
    window = {
      backdrop = 1.0,
      width = 0.6,
      height = 1,
      options = {
        signcolumn = "yes",
        number = true,
        relativenumber = true,
      },
      plugins = {
        gitsigns = { enabled = true },
        wezterm = {
          enabled = true,
          font = "+4",
        },
      },
    },
  },
}
