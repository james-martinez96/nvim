-- get the current nvim buffer
-- local bufnr = vim.api.nvim_get_current_buf()
-- get the current nvim window
-- local win = vim.api.nvim_get_current_win()

-- vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "hello", "world" })

-- vim.api.nvim_open_win(bufnr, true,
--   {relative='win', row=1, col=1, width=50, height=50})


local attach_to_buffer = function(output_bufnr, pattern, command)
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("MyAuGroup", { clear = true }),
    pattern = pattern,
    callback = function()
      local append_data = function(_, data)
        if data then
          vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
        end
      end

      vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, { "Output:" })
      vim.fn.jobstart(command, {
        stdout_bufferd = true,
        on_stdout = append_data,
        on_stderr = append_data,
      })
    end
  })
end

vim.api.nvim_create_user_command("AutoRun", function()
  print "Autorun starts now..."
  vim.api.nvim_create_buf()
  local bufnr = vim.api.nvim_get_current_buf()
  local pattern = vim.fn.input "Pattern: "
  local command = vim.split(vim.fn.input "Command: ", " ")
  attach_to_buffer(tonumber(bufnr), pattern, command)
end, {})

vim.api.nvim_create_user_command("AutoStop", function()
  vim.api.nvim_create_augroup("MyAuGroup", { clear = true })
end, {})
