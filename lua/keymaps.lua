local opts = { noremap = true, silent = true }

--Remap space as leader key
vim.keymap.set("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Esc remap
vim.keymap.set("i", "jj", "<ESC>", opts)

-- Spell checking
-- vim.keymap.set('i', '<leader>cs', 'C-X_C-L', opts)

-- Terminal
vim.keymap.set("t", "jj", "<C-\\><C-n>", opts)
vim.keymap.set("n", "<leader>t", [[:term<CR>]], opts)
vim.keymap.set("n", "<leader>vt", [[:vs +term<CR>]], opts)
-- vim.keymap.set('n', '<leader>ht', [[:sp +term<CR>]], opts)

-- Wincmd
vim.keymap.set("n", "<leader>h", "<cmd>:wincmd h<CR>", opts)
vim.keymap.set("n", "<leader>j", "<cmd>:wincmd j<CR>", opts)
vim.keymap.set("n", "<leader>k", "<cmd>:wincmd k<CR>", opts)
vim.keymap.set("n", "<leader>l", "<cmd>:wincmd l<CR>", opts)
vim.keymap.set("n", "<leader>=", "<cmd>:wincmd =<CR>", opts)

-- Buffers
vim.keymap.set("n", "<leader>n", "<cmd>:tabnext<CR>", opts)
vim.keymap.set("n", "<leader>p", "<cmd>:tabprevious<CR>", opts)

-- Session
-- vim.keymap.set("n", "<leader>s", "<cmd>:mksession<CR>", opts)

-- Git
vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<cmd>", opts)

-- Debbugging for dap
vim.keymap.set("n", "<F5>", "<cmd>lua require'dap'.continue()<CR>", opts)
vim.keymap.set("n", "<F10>", "<cmd>lua require'dap'.step_over()<CR>", opts)
vim.keymap.set("n", "<F11>", "<cmd>lua require'dap'.step_into()<CR>", opts)
vim.keymap.set("n", "<F12>", "<cmd>lua require'dap'.step_out()<CR>", opts)
vim.keymap.set("n", "<leader>b", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
vim.keymap.set(
  "n",
  "<leader>B",
  "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  opts
)
-- vim.keymap.set('n', '<leader>lp', "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opts) -- interfers with window movements
vim.keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.open()<CR>", opts)
vim.keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<CR>", opts)
vim.keymap.set("n", "<leader>do", "<cmd>lua require'dapui'.open()<CR>", opts)
vim.keymap.set("n", "<leader>dc", "<cmd>lua require'dapui'.close()<CR>", opts)

-- remove trailing whitespace
-- also deletes trailing whitespace in multiline strings
-- vim.cmd [[ command! RemovePostspace execute '<cmd>:%s/\s\+$//e<cmd>' ]]

-- vim.keymap.set('n', '<leader>s', '<cmd>lua require("my-plugin").createFloatingWindow().onResize()<CR>', opts)
