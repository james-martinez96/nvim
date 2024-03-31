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
  rb = "ruby",
  js = "node",
}

vim.api.nvim_create_user_command("Run", function()
  local function run_script()
    local filename = vim.api.nvim_buf_get_name(0)
    local file_extension = vim.fn.expand("%:e")

    if filename == nil then
      print("No file found (buffer is unsaved or unnamed)")
      return
    end

    if file_extension == file_extension then
      -- command is nil if the file extension is not in the file_types table
      local command = file_types[file_extension] .. " " .. vim.fn.shellescape(filename)

      ---Handle C files
      if file_extension == "c" then
        print("this is a c file")

        print("filename: ", filename)

        local c_file = vim.fn.expand("%t")
        print("C file: ", c_file)

        local output_file = string.gsub(c_file, ".c", "")
        print("Output file: ", output_file)

        local compile_command = file_types[file_extension] .. " " .. output_file.. " " .. vim.fn.shellescape(c_file)
        print("gcc command: ", compile_command)

        -- TODO compile c program
        local function compile()
          -- local handle = io.open(command, "r")
          -- handle:close()
          print('to be implemented')
          print('compiling...')
          vim.api.nvim_exec2("!" .. compile_command, {})
          print('done')

          local program_output = vim.fn.system("./"..output_file)
          print(program_output)

          local t_output = {}
          for line in program_output:gmatch("[^\r\n]+") do
            table.insert(t_output, line)
          end
          print("t: ", t_output)
          popup.create_split(t_output, file_extension)
        end

        local success, err = pcall(compile)
        if not success then
          print("Error", err)
        end
        return
      end

      -- print(command)
      local handle, err = io.popen(command, "r")

      local lines = {}

      if handle then
        local result = handle:read("*a")
        handle:close()

        for line in result:gmatch("[^\r\n]+") do
          table.insert(lines, line)
        end

        if next(lines) == nil then
          print("No data")
          return
        end

        popup.create_split(lines, file_extension)
      else
        print(err)
        return
      end
      if err then
        print(err)
        return
      end
    end
  end

  local success, err = pcall(run_script)
  if not success then
    print("Error:", err)
    return
  end
end, {})

-- local attach_to_buffer = function(output_bufnr, pattern, command)
--   vim.api.nvim_create_autocmd("BufWritePost", {
--     group = vim.api.nvim_create_augroup("MyAuGroup", { clear = true }),
--     pattern = pattern,
--     callback = function()
--       local append_data = function(_, data)
--         if data then
--           vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
--         end
--       end
--
--       vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, { "Bash Output:" })
--       vim.fn.jobstart(command, {
--         stdout_bufferd = true,
--         on_stdout = append_data,
--         on_stderr = append_data,
--       })
--     end,
--   })
-- end
--
-- vim.api.nvim_create_user_command("AutoRun", function()
--   print("Autorun starts now...")
--   vim.api.nvim_create_buf(false, true)
--   local bufnr = vim.api.nvim_get_current_buf()
--   local pattern = vim.fn.input("Pattern: ")
--   local command = vim.split(vim.fn.input("Command: "), " ")
--   attach_to_buffer(tonumber(bufnr), pattern, command)
-- end, {})
--
-- vim.api.nvim_create_user_command("AutoStop", function()
--   vim.api.nvim_create_augroup("MyAuGroup", { clear = true })
--   vim.cmd("autocmd! MyAuGroup")
-- end, {})
