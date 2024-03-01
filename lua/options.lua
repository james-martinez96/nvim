-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menuone,noselect"

vim.opt.clipboard = "unnamedplus"

--Set smarttab
vim.opt.smarttab = true

--Set expandtab
vim.opt.expandtab = true

--Set tabstop
vim.opt.tabstop = 8

--Set softtabstop
vim.opt.softtabstop = 2

--Set shiftwidth
vim.opt.shiftwidth = 2

--Set smartindent
vim.opt.smartindent = true

--Set highlight on search
vim.opt.hlsearch = false

--Make line numbers default
vim.wo.number = true

--Make relative line numbers default
vim.wo.relativenumber = false

--Enable mouse mode
vim.opt.mouse = "a"

--Enable break indent
vim.opt.breakindent = true

--Save undo history
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

--Decrease update time
vim.opt.updatetime = 50
vim.wo.signcolumn = "yes"

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
