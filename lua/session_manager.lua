local session_path = vim.fn.stdpath("state") .. "/sessions/session_manager/"
local cwd = vim.fn.getcwd()

-- check to see if session_manager directory exists.
local function verify_path(path)
  if vim.fn.isdirectory(path) == 1 then
    return true
  else
    return false
  end
end

-- create the session manager directory
-- print("session folder exists:", verify_path(session_path))
if verify_path(session_path) == false then
  local input = vim.fn.input("Session directory does not exist. Create it? (y/n): ")
  if input:lower() == "y" then
    print("\n")
    vim.fn.mkdir(session_path, "p")
    print("Directory created: " .. session_path)
  elseif input:lower() == "n" then
    print("\n")
    print("Directory not created.")
  end
end

-- check to see if session file exists.
local function file_exists(path)
  vim.fn.filereadable(path)
  return vim.fn.isdirectory(path) == 1
end

-- Load a session.
local function load_session()
  -- TODO: change "@" to "%" to be more consistent
  local filename = cwd:gsub("/", "@")
  local session_file = string.format("%s%s.vim", session_path, filename)

  if file_exists(session_path) then
    vim.cmd("source" .. session_file)
  else
    print("Session not found: " .. session_file)
    return
  end
end

-- Save a session.
local function save_session()
  local filename = cwd:gsub("/", "@")
  local session_file = session_path .. "" .. filename .. ".vim"

  if file_exists(session_path) then
    vim.cmd("mksession!" .. session_file)
  else
    print("No session file found.")
  end
end

-- vim.api.nvim_create_autocmd({"BufEnter", "WinEnter"}, {
--   pattern = {"*.lua"},
--   callback = function ()
--     load_session()
--   end
-- })

vim.api.nvim_create_user_command("SaveSession", function()
  save_session()
end, {})

vim.api.nvim_create_user_command("LoadSession", function()
  load_session()
end, {})
