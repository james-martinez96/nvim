-- Print lua table
-- local function print_table(table)
--   for key, value in pairs(table) do
--     print(key .. ": " .. tostring(value))
--   end
-- end

-- auto reloading lua files
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.fn.expand("~") .. ".config/nvim/*.lua" ,
  callback = function()
    vim.cmd("so %")
  end,
})

-- auto resizez splits
-- local auto_resize_group = vim.api.nvim_create_augroup("AutoResize", { clear = true })
-- vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
--   callback = function()
--     local win = vim.api.nvim_get_current_win()
--     local winwidth = vim.api.nvim_win_get_width(win)
--     -- local id = vim.api.nvim_create_augroup("AutoResize", {clear=true})
--     -- vim.api.nvim_del_augroup_by_id(id)
--     if winwidth <= 50 then
--       vim.cmd([[set winwidth=20]])
--     elseif winwidth >= 20 then
--       vim.cmd([[set winwidth=50]])
--       vim.cmd([[wincmd =]])
--     end
--   end,
-- })

-- Yank Highlight
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require("telescope.builtin").live_grep({
      search_dirs = { git_root },
    })
  end
end

vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})
vim.keymap.set("n", "<leader>sG", ":LiveGrepGitRoot<cr>", { desc = "[S]earch by [G]rep on Git Root" })

-- Source init.lua
local function source_utils()
  vim.api.nvim_command("source $HOME/.config/nvim/lua/utils.lua")
end
vim.api.nvim_create_user_command("SourceUtils", source_utils, {})
