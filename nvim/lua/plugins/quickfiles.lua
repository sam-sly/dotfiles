return {
  "sam-sly/quickfiles.nvim",
  lazy = true,
  keys = {
    { "<leader>fd", "<cmd>QuickFilesDeleteFile<CR>", desc = "Delete File" },
    { "<leader>fD", "<cmd>QuickFilesDeleteFileAndEmptyDirs<CR>", desc = "Delete File and Empty Dirs" },
    { "<leader>fn", "<cmd>QuickFilesNewFileAtBufferDir<CR>", desc = "New File at Buffer Dir" },
    { "<leader>fN", "<cmd>QuickFilesNewFileAtCwd<CR>", desc = "New File at CWD" },
  },
}
