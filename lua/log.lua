local M = {}
local log_file_path = vim.fn.stdpath("cache") .. "/my-log.log"

local log_levels = {
  DEBUG = "DEBUG",
  INFO = "INFO",
  WARN = "WARN",
  ERROR = "ERROR",
}

--- Write a log message to the log file.
---@param level string
---@param msg string
local function write_log(level, msg)
  local file = io.open(log_file_path, "a")
  if file then
    local time = os.date("%Y-%m-%d %H:%M:%S")
    file:write(string.format("[%s] [%s] %s\n", time, level, msg))
    file:close()
  else
    print("Error opening the file: " .. log_file_path)
  end
end

--- Log a debug message.
---@param msg string
function M.debug(msg)
  write_log(log_levels.DEBUG, msg)
end

--- Log a info message.
---@param msg string
function M.info(msg)
  write_log(log_levels.INFO, msg)
end

--- Log a warning message.
---@param msg string
function M.warn(msg)
  write_log(log_levels.WARN, msg)
end

--- Log a error message.
---@param msg string
function M.error(msg)
  write_log(log_levels.ERROR, msg)
end

--- Set the path to the log file.
---@param path string
function M.set_log_file(path)
  log_file_path = path
end

vim.api.nvim_create_user_command('ViewLog', function()
  vim.cmd('sp ' .. log_file_path)
end, {})

return M
