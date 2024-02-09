local opts = { noremap = true, silent = true }

-- Wincmd
vim.api.nvim_set_keymap('n', '<leader>h', '<cmd>:wincmd h<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>j', '<cmd>:wincmd j<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>k', '<cmd>:wincmd k<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>l', '<cmd>:wincmd l<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>=', '<cmd>:wincmd =<CR>', opts)

-- Buffers
vim.api.nvim_set_keymap('n', '<leader>n', '<cmd>:tabnext<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>p', '<cmd>:tabprevious<CR>', opts)

