--Remap space as leader key
--vim.api.nvim_set_keymap('', '<Space>', '<Nop>', {})
--vim.g.mapleader = ' '
--vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local opts = {}

require("keymaps")
require("options")
require("utils")
require("session_manager")
require("run")
require("lazy").setup("plugins")

