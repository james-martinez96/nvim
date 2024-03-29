local M = {}

---Create a floating window
---@param data table
function M.create_popup(data)
  -- Define the options for the popup window
  local popup_opts = {
    relative = "win",
    width = 40,
    height = #data + 2, -- Height adjusts based on content lines + padding
    row = 10,
    col = 10,
    border = "single",
    style = "minimal",
    title = "Output",
  }

  -- Create the popup window
  local popup_bufnr = vim.api.nvim_create_buf(false, true)
  local popup_winid = vim.api.nvim_open_win(popup_bufnr, true, popup_opts)
  -- print(popup_bufnr, popup_winid)

  -- Set the content of the popup window
  vim.api.nvim_buf_set_lines(popup_bufnr, 0, -1, false, data)

  -- Close the popup window when a key is pressed
  vim.api.nvim_buf_set_keymap(popup_bufnr, "n", "<Esc>", ":lua vim.api.nvim_win_close(".. tostring(popup_winid) ..", {force = true})<CR>", {noremap = true, silent = true})
  -- vim.api.nvim_buf_set_keymap(popup_bufnr, "n", "<Esc>", vim.api.nvim_win_close(popup_winid), {noremap = true, silent = true})
end

-- NOTE check buflisted()
---Create a split
---@param data table
---@param buf_name string
function M.create_split(data, buf_name)
  -- print(tonumber(buf_name))

    local bufnr = vim.fn.bufnr(buf_name)
    print(buf_name, bufnr)

    local function buffer_has_window()
      for _, winid in ipairs(vim.api.nvim_list_wins()) do
        local win_bufnr = vim.api.nvim_win_get_buf(winid)
        if win_bufnr == bufnr then
          -- print("true", winid)
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, data)
          return true
        else
          -- print("false", winid)
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, data)
          vim.api.nvim_command("vsplit")
          vim.api.nvim_command("buffer" .. bufnr)
          return false
        end
      end
    end
    buffer_has_window()

  if buffer_has_window() then
    print('a window is open to the buffer')
  else
    print('there is no window to this buffer')
  end


  -- if bufnr == nil then
  --   -- bufnr = vim.api.nvim_create_buf(true, true)
  --   -- vim.api.nvim_buf_set_option(bufnr, "filetype", buf_name)
  --   -- vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, data)
  --   -- vim.api.nvim_command("vsplit")
  --   -- vim.api.nvim_command("buffer" .. bufnr)
  -- elseif vim.api.nvim_buf_is_valid(bufnr) then
  --
  --
  --   -- for _, winid in ipairs(vim.api.nvim_list_wins()) do
  --   --   local win_bufnr = vim.api.nvim_win_get_buf(winid)
  --   --   if win_bufnr == bufnr then
  --   --     print('win open', win_bufnr)
  --   --     vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, data)
  --   --   else
  --   --     -- vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, data)
  --   --     -- vim.api.nvim_command("vsplit")
  --   --     -- vim.api.nvim_command("buffer" .. bufnr)
  --   --     print('else')
  --   --   end
  --   -- end
  -- else
  --   print('explode')
  -- end
end

return M
