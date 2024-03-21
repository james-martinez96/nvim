local function print_table(table)
  for key, value in pairs(table) do
    print(key .. ": " .. tostring(value))
  end
end

local popup_content = {
  "Hello, this is a popup window!",
  "You can put any content here.",
  "Feel free to customize it as you wish!",
  "Hello, this is a popup window!",
  "Hello, this is a popup window!",
  "Hello, this is a popup window!",
  "Hello, this is a popup window!",
  "Hello, this is a popup window!",
  "You can put any content here.",
  "Feel free to customize it as you wish!",
  "You can put any content here.",
  "Feel free to customize it as you wish!",
  "You can put any content here.",
  "Feel free to customize it as you wish!",
  "You can put any content here.",
  "Feel free to customize it as you wish!",
  "You can put any content here.",
  "Feel free to customize it as you wish!",
}

-- Define the options for the popup window
local popup_opts = {
  relative = "win",
  width = 40,
  height = #popup_content + 2, -- Height adjusts based on content lines + padding
  row = 10,
  col = 10,
  border = "single",
  style = "minimal",
}

-- Create the popup window
local popup_winid = vim.api.nvim_open_win(4, true, popup_opts)
local popup_bufnr = vim.api.nvim_win_get_buf(popup_winid)
print(popup_bufnr, popup_winid)

-- Set the content of the popup window
vim.api.nvim_buf_set_lines(popup_bufnr, 0, -1, false, popup_content)

-- Close the popup window when a key is pressed
vim.api.nvim_buf_set_keymap(popup_bufnr, "n", "<Esc>", ":lua vim.api.nvim_win_close(".. tostring(popup_winid) ..", {force = true})<CR>", {noremap = true, silent = true})
-- vim.api.nvim_buf_set_keymap(popup_bufnr, "n", "<Esc>", vim.api.nvim_win_close(popup_winid), {noremap = true, silent = true})



























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
