return {
  "echasnovski/mini.move",
  version = "*",
  opts = {
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
      left = "H",
      right = "L",
      down = "J",
      up = "K",

      -- Move current line in Normal mode
      line_left = "<S-left>",
      line_right = "<S-right>",
      line_down = "<S-down>",
      line_up = "<S-up>",
    },
  },
}
