local M = {}

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
  }

  -- Create the popup window
  local popup_bufnr = vim.api.nvim_create_buf(false, true)
  local popup_winid = vim.api.nvim_open_win(popup_bufnr, true, popup_opts)
  print(popup_bufnr, popup_winid)

  -- Set the content of the popup window
  vim.api.nvim_buf_set_lines(popup_bufnr, 0, -1, false, data)

  -- Close the popup window when a key is pressed
  vim.api.nvim_buf_set_keymap(popup_bufnr, "n", "<Esc>", ":lua vim.api.nvim_win_close(".. tostring(popup_winid) ..", {force = true})<CR>", {noremap = true, silent = true})
  -- vim.api.nvim_buf_set_keymap(popup_bufnr, "n", "<Esc>", vim.api.nvim_win_close(popup_winid), {noremap = true, silent = true})
end

return M
