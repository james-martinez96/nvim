-- Debug
-- reload cached module 
package.loaded["popup"] = nil

-- TODO:
-- get filetypes based on vim filetypes and not the file extension
-- error handling
-- make this a plugin

local popup = require("popup")

local file_types = {
  sh = "bash",
  lua = "lua",
  py = "python",
  lisp = "sbcl --script",
  c = "gcc -o",
  cpp = "g++ -o",
  rb = "ruby",
  js = "node",
}

---Run a program in the background
---@param program string
---@param args table
---@return number
local function run_program_in_background(program, args)
  local job_id = vim.fn.jobstart(program, {
    args = args,
    detach = true,
    stdout_bufferd = true,
    on_stdout = function(_, data, _)
      popup.create_split(data, "background data")
      -- table.insert(output, data)
    end,
    on_stderr = function(_, data, _)
      -- popup.create_split(data, "Error")
      print("Error", data)
    end,
    on_exit = function(_, data, _)
      print("Exit", data)
    end
  })

  print("Program started in the background with job ID: " .. job_id)
  return job_id
end

-- vim.api.nvim_create_user_command("Stop", function ()
--   vim.fn.jobstop(job_id)
-- end, {})

vim.api.nvim_create_user_command("Run", function()
  local function run_script()
    local filename = vim.api.nvim_buf_get_name(0)
    local file_extension = vim.fn.expand("%:e")

    if filename == nil then
      print("No file found (buffer is unsaved or unnamed)")
      return
    end

    if file_types[file_extension] then
      -- command is nil if the file extension is not in the file_types table
      local command = file_types[file_extension] .. " " .. vim.fn.shellescape(filename)

      ---Handle C files
      --this does not handle input yet
      if file_extension == "c" or file_extension == "cpp" then
        -- print("this is a c file")
        -- print("filename: ", filename)
        local c_file = vim.fn.expand("%t")
        -- print("C file: ", c_file)
        local output_file = string.gsub(c_file, ".c", "")
        -- print("Output file: ", output_file)
        local compile_command = file_types[file_extension] .. " " .. output_file.. " " .. vim.fn.shellescape(c_file)
        -- print("compile command: ", compile_command)

        -- Compile C program
        local function compile()
          -- local handle = io.open(command, "r")
          -- handle:close()
          -- print('to be implemented')
          -- print('compiling...')
          vim.api.nvim_exec2("!" .. compile_command, {})
          -- Run the compile step in the background
          -- local job_id = run_program_in_background("gcc -o", {output_file, c_file})
          -- print("PID: ", vim.fn.jobpid(job_id))
          -- print('done')

          -- Run the program and store the output
          local program_output = vim.fn.system("./"..output_file)
          -- print('Output>>>>>>>>>>>>>')
          -- print(program_output)
          -- print('End<<<<<<<<<<<<<<<<')

          local t_output = {}
          for line in program_output:gmatch("[^\r\n]+") do
            table.insert(t_output, line)
          end
          popup.create_split(t_output, file_extension)
        end

        local success, err = pcall(compile)
        if not success then
          print("Error", err)
        end
        return
      end

      -- print(command)
      -- local handle, err = io.popen(command, "r")
      local job_id = run_program_in_background(command, {})
      -- local pid = vim.fn.jobpid(job_id)
      -- print(pid)
    end
  end

  local success, err = pcall(run_script)
  if not success then
    print("Error:", err)
    return
  end
end, {})
