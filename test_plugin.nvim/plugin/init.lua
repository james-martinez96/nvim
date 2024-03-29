local function greet()
  print('long task started')
  vim.api.nvim_out_write("Hello from Lazy Example Plugin!\n")
end

vim.api.nvim_create_user_command("Greet", function()
  greet()
end, {})
