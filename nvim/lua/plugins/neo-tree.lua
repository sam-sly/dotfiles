return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      follow_current_file = {
        leave_dirs_open = true,
      },
    },
    buffers = {
      follow_current_file = {
        leave_dirs_open = true,
      },
    },
    window = {
      mappings = {
        ["Z"] = "expand_all_nodes",
      },
    },
  },
}
