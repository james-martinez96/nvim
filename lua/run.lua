-- Debug
-- reload cached module
package.loaded["popup"] = nil

-- TODO:
-- compiler arguments
-- get filetypes based on vim filetypes and not the file extension
-- error handling
-- remove comments
-- make this a plugin

local popup = require("popup")
local log = require("log")

local file_types = {
  sh = "bash",
  lua = "lua",
  py = "python",
  lisp = "clisp",
  c = "gcc -o",
  cpp = "g++ -o",
  rb = "ruby",
  js = "node",
}

local stdout_data = {}
local stderr_data = {}
local on_exit_data = {}

-- the data param is an empty string if there is no output: { "" }
---@param job_id number
---@param data table
---@param event string
local function on_output(job_id, data, event)
  if data[2] ~= nil then
    for _, line in ipairs(data) do
      if line ~= "" then
        table.insert(stdout_data, line)
      end
    end
    popup.create_split(stdout_data, "output")
  end
end

---@param job_id number
---@param data table
---@param event string
local function on_error(job_id, data, event)
  if data[2] ~= nil then
    for _, line in ipairs(data) do
      table.insert(stderr_data, line)
    end
    popup.create_split(stderr_data, "error")
  end
end

---@param job_id number
---@param exit_code number
---@param event string
local function on_exit(job_id, exit_code, event)
  if on_exit_data ~= nil then
    table.insert(on_exit_data, exit_code)
    -- print("Job exited with code: " .. exit_code)
    log.debug("Job exited with code: " .. exit_code)
  end
end

---Run a program in the background
---@param program string
---@param args table
---@return number
local function run_program_in_background(program, args)
  -- reset the data tables
  stdout_data = {}
  stderr_data = {}
  on_exit_data = {}
  local job_id = vim.fn.jobstart(program, {
    args = args,
    -- detach = true,
    stdout_buffered = false,
    stderr_buffered = false,
    on_stdout = on_output,
    on_stderr = on_error,
    on_exit = on_exit,
  })

  -- print("Program started in the background with job ID: " .. job_id)
  log.debug("Program started in the background with job ID: " .. job_id)
  return job_id
end

-- vim.api.nvim_create_user_command("Stop", function ()
--   vim.fn.jobstop(job_id)
-- end, {})

local function run_script()
  local filename = vim.api.nvim_buf_get_name(0)
  local file_extension = vim.fn.expand("%:e")

  if filename == nil then
    print("No file found (buffer is unsaved or unnamed)")
    return
  elseif file_extension == "txt" then
    print("this is a text file")
  end

  if file_types[file_extension] then
    -- command is nil if the file extension is not in the file_types table
    local command = file_types[file_extension] .. " " .. vim.fn.shellescape(filename)

    ---Handle C files
    --this does not handle input yet
    if file_extension == "c" or file_extension == "cpp" then
      -- print("this is a c file")
      -- print("filename: ", filename)
      local c_file = vim.fn.expand("%:t")
      -- print("C file: ", c_file)
      -- local output_file = string.gsub(c_file, "%.%w+$", "")
      local output_file = c_file:match("(.+)%..+$") or c_file
      -- print("Output file: ", output_file)
      local compile_command = file_types[file_extension] .. " " .. output_file .. " " .. vim.fn.shellescape(c_file)
      -- print("compile command: ", compile_command)

      -- Compile C program
      local function compile()
        -- print(compile_command)
        local job_id = run_program_in_background(compile_command, {})

        local job_status = vim.fn.jobwait({ job_id })

        if job_status[1] == 0 then
          -- vim.inspect(stderr_data)
          -- Execute Binary
          -- print("Executing Binary")
          run_program_in_background("./" .. output_file, {})
        end
      end
      compile()
    else
      -- Run a script
      local job_id = run_program_in_background(command, {})
      local pid = vim.fn.jobpid(job_id)
      -- print(pid)
      log.info("Running: " .. command .. " with pid:" .. pid)
    end
  end
end

vim.api.nvim_create_user_command("Run", function()
  local success, err = pcall(run_script)
  if not success then
    log.error("Error: " ..  err)
    print("Error:", err)
    return
  end
end, {})
