local session_path = vim.fn.stdpath("state") .. "/sessions/session_manager/"

local function file_exists(path)
  return vim.fn.isdirectory(path) == 1
end

local function load_session()
  local cwd = vim.fn.getcwd()
  local filename = string.gsub(cwd, "/", "@")
  local session_file = session_path .. "" .. filename .. ".vim"

  if file_exists(session_path) then
    -- vim.cmd('mksession!' .. session_file)
    vim.cmd("source" .. session_file)
    -- print(session_file)
  else
    print("session not found")
    return
  end
end

local function save_session()
  local cwd = vim.fn.getcwd()
  local filename = string.gsub(cwd, "/", "@")
  print(filename)
  local session_file = session_path .. "" .. filename .. ".vim"
  print(session_file)

  if file_exists(session_path) then
    vim.cmd("mksession!" .. session_file)
  else
    vim.fn.mkdir(session_path)
  end
end

vim.api.nvim_create_user_command("SaveSession", function()
  save_session()
end, {})

vim.api.nvim_create_user_command("LoadSession", function()
  load_session()
end, {})
