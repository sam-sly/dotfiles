return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    -- refer to `:h file-pattern` for more examples
    "BufReadPre /Users/samsly/Documents/Obsidian Vault/*.md",
    "BufNewFile /Users/samsly/Documents/Obsidian Vault/*.md",
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
    "ibhagwan/fzf-lua",
    "nvim-treesitter/nvim-treesitter",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "Vault",
        path = "~/Documents/Obsidian Vault/",
      },
    },
    daily_notes = {
      folder = "Reviews/Day",
      template = "Day Review.md",
    },
    new_notes_location = "current_dir",
    templates = {
      folder = "Templates",
    },
    picker = {
      name = "fzf-lua",
      note_mappings = {
        -- Create a new note from your query.
        new = "<C-x>",
        -- Insert a link to the selected note.
        insert_link = "<C-l>",
      },
      tag_mappings = {
        -- Add tag(s) to current note.
        tag_note = "<C-x>",
        -- Insert a tag at the current location.
        insert_tag = "<C-l>",
      },
    },
  },
}
