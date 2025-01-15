local snacks = require("snacks.input")

local M = {}

-- Ensure that a directory and its parent directories exist, creating them if necessary
local function ensure_directory_exists(dir)
  local uv = vim.loop
  local stat = uv.fs_stat(dir)

  if not stat then
    local parent_dir = vim.fn.fnamemodify(dir, ":h")
    if parent_dir ~= dir then
      -- Recursively ensure parent directories exist
      if not ensure_directory_exists(parent_dir) then
        return false
      end
    end

    -- Attempt to create the current directory
    local success, err = uv.fs_mkdir(dir, 511) -- Permissions: 0777
    if not success then
      vim.notify("Failed to create directory: " .. err, vim.log.levels.ERROR)
      return false
    end
  end

  return true
end

-- Create a new file in the specified directory, creating subdirectories if necessary
local function create_new_file(base_path)
  local original_cwd = vim.fn.getcwd() -- Save current working directory
  vim.fn.chdir(base_path) -- Temporarily change to the target directory

  -- Get the name of the current directory for the prompt
  local dir_name = vim.fn.fnamemodify(base_path, ":t")
  local prompt = "Create new file in " .. dir_name .. "/: "

  snacks.input({
    prompt = prompt,
    completion = "file",
  }, function(input)
    vim.fn.chdir(original_cwd) -- Restore original directory

    if input and input ~= "" then
      if input:match('[:*?"<>|]') then
        vim.notify("Invalid filename: " .. input, vim.log.levels.ERROR)
        return
      end

      local new_filepath = vim.fn.fnamemodify(base_path .. "/" .. input, ":p")
      local dir = vim.fn.fnamemodify(new_filepath, ":h")

      if not ensure_directory_exists(dir) then
        return
      end

      local fd = vim.loop.fs_open(new_filepath, "w", 420) -- Permissions: 0644
      if fd then
        vim.loop.fs_close(fd)
        vim.cmd("edit " .. new_filepath)
        vim.notify("Created and opened file: " .. new_filepath, vim.log.levels.INFO)
      else
        vim.notify("Failed to create file: " .. new_filepath, vim.log.levels.ERROR)
      end
    else
      vim.notify("New file creation cancelled", vim.log.levels.WARN)
    end
  end)
end

-- Recursively delete directories if they are empty
local function delete_empty_directories(directory)
  local uv = vim.loop
  while directory and directory ~= "" do
    local entries = uv.fs_scandir(directory)
    local is_empty = true

    if entries then
      -- Iterate through the entries to check if the directory is empty
      local name = uv.fs_scandir_next(entries)
      if name then
        is_empty = false -- Directory is not empty
      end
    end

    if is_empty then
      local success, err = uv.fs_rmdir(directory)
      if not success then
        vim.notify("Failed to delete directory: " .. err, vim.log.levels.ERROR)
        return
      end
      vim.notify("Deleted empty directory: " .. directory, vim.log.levels.INFO)
      directory = vim.fn.fnamemodify(directory, ":h") -- Move up the directory tree
    else
      break -- Stop if the directory is not empty
    end
  end
end

-- Delete the current file and optionally delete empty directories
local function delete_current_file(delete_dirs)
  local filepath = vim.fn.expand("%:p")
  local file_dir = vim.fn.fnamemodify(filepath, ":h")

  if vim.fn.filereadable(filepath) == 0 then
    vim.notify("File does not exist: " .. filepath, vim.log.levels.ERROR)
    return
  end

  vim.ui.input({ prompt = "Delete file? (y/n): " }, function(input)
    if input == "y" then
      local current_buf = vim.api.nvim_get_current_buf()
      local success, err = os.remove(filepath)
      if success then
        vim.cmd("bnext")
        if vim.api.nvim_buf_is_valid(current_buf) then
          vim.cmd("bdelete! " .. current_buf)
        end
        vim.notify("Deleted file: " .. filepath, vim.log.levels.INFO)

        if delete_dirs then
          delete_empty_directories(file_dir)
        end
      else
        vim.notify("Failed to delete file: " .. err, vim.log.levels.ERROR)
      end
    else
      vim.notify("File deletion cancelled", vim.log.levels.WARN)
    end
  end)
end

-- Exported functions
M.create_new_file_in_current_dir = function()
  local base_path = vim.fn.expand("%:p:h") -- Directory of the current buffer
  create_new_file(base_path)
end

M.create_new_file_in_project_root = function()
  local base_path = vim.fn.getcwd() -- Project root directory
  create_new_file(base_path)
end

M.delete_current_file = function()
  delete_current_file(false) -- Do not delete empty directories
end

M.delete_current_file_and_empty_dirs = function()
  delete_current_file(true) -- Delete empty directories
end

return M
