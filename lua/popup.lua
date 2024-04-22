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
  vim.api.nvim_buf_set_keymap(
    popup_bufnr,
    "n",
    "<Esc>",
    ":lua vim.api.nvim_win_close(" .. tostring(popup_winid) .. ", {force = true})<CR>",
    { noremap = true, silent = true }
  )
  -- vim.api.nvim_buf_set_keymap(popup_bufnr, "n", "<Esc>", vim.api.nvim_win_close(popup_winid), {noremap = true, silent = true})
end

---Create a split
---@param data table
---@param buf_name string
function M.create_split(data, buf_name)
  local buf = vim.fn.bufadd(buf_name)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')  -- Set buftype to 'nofile' to indicate it's not associated with a file
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')  -- Set bufhidden to 'wipe' to automatically close the buffer when it's no longer visible
  vim.api.nvim_buf_set_option(buf, 'swapfile', false) -- Set swapfile to false

  -- local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  -- print('lines:',vim.tbl_flatten(lines))

  ---Check to see if a buffer has a window
  ---returns true if there is a window to the buffer
  ---@return boolean
  local function buffer_has_window()
    local windows = vim.api.nvim_list_wins()
    local has_window = false

    for win, winid in ipairs(windows) do
      local win_bufnr = vim.api.nvim_win_get_buf(winid)
      -- print("win: " .. win, "id: " .. winid, "buf: " .. win_bufnr)

      if buf == win_bufnr then
        has_window = true
        return true
      end
    end
    return has_window
  end

  if buffer_has_window() then
    -- print("a window is open to the buffer")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, data)
    -- vim.api.nvim_buf_get_lines()
  else
    -- print("there is no window to this buffer")
    -- print("creating one")
    vim.api.nvim_buf_set_lines(buf, -2, -1, false, data)
    vim.api.nvim_command("vsplit")
    vim.api.nvim_command("buffer" .. buf)
  end
end

return M
