local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    -- vim.fn.system({
    --   "git",
    --   "clone",
    --   "--filter=blob:none",
    --   "https://github.com/folke/lazy.nvim.git",
    --   "--branch=stable", -- latest stable release
    --   lazypath,
    -- })
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.gechar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

local opts = {}

require("header")
require("keymaps")
require("options")
require("utils")
require("session_manager")
require("run")
require("float")
require("lsp")
require("lazy").setup({
    spec = {
        { import = "plugins" }
    }
})
