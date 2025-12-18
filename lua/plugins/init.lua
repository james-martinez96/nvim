return {
    -- { "christoomey/vim-tmux-navigator" },
    { "windwp/nvim-autopairs", opts = {} },
    { "j-hui/fidget.nvim",     opts = {} },
    { "folke/which-key.nvim",  opts = {} },
    {
      "folke/todo-comments.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    },
    -- {
    --   "JoosepAlviste/nvim-ts-context-commentstring",
    --   opts = {
    --     enable_autocmd = false,
    --   },
    -- },
    {
        "numToStr/Comment.nvim",
        opts = {},
        -- JSX support
        -- dependencies = {"JoosepAlviste/nvim-ts-context-commentstring"},
        -- opts = { pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook() },
    },
    { "mbbill/undotree" },
    { "tpope/vim-fugitive" },
    -- { "tpope/vim-surround" },
    -- { "tpope/vim-sleuth" },

    -- {
    --   "nvim-flutter/flutter-tools.nvim",
    --   lazy = false,
    --   dependencies = {
    --       "nvim-lua/plenary.nvim",
    --       "stevearc/dressing.nvim", -- optional for vim.ui.select
    --   },
    --   config = true,
    -- },

    -- {
    --   -- Add indentation guides even on blank lines
    --   "lukas-reineke/indent-blankline.nvim",
    --   -- Enable `lukas-reineke/indent-blankline.nvim`
    --   -- See `:help ibl`
    --   main = "ibl",
    --   opts = {
    --     debounce = 100,
    --     indent = { char = "|" },
    --     whitespace = { highlight = { "Whitespace", "NonText" } },
    --     -- scope = { exclude = { language = { "lua" } } },
    --   },
    -- },

    -- Development
    -- { dir = "~/.config/nvim/test_plugin.nvim" },
    -- { dir = "/mnt/usb/nvim_plugins/flipper.nvim" },
    { "james-martinez96/texwatch.nvim" },
    { -- dir = "/mnt/usb/nvim_plugins/present.nvim",
        { "james-martinez96/present.nvim" },

        -- config = function ()
        --   require("present").setup()
        -- end
    },

    -- { dir = "/mnt/usb/nvim_plugins/markdown.nvim"},

    -- {
    --     "folke/snacks.nvim",
    --     priority = 1000,
    --     lazy = false,
    --     ---@type snacks.Config
    --     opts = {
    --         -- your configuration comes here
    --         -- or leave it empty to use the default settings
    --         -- refer to the configuration section below
    --         bigfile = { enabled = true },
    --         dashboard = { enabled = true },
    --         explorer = { enabled = true },
    --         indent = { enabled = true },
    --         input = { enabled = true },
    --         picker = { enabled = true },
    --         notifier = { enabled = true },
    --         quickfile = { enabled = true },
    --         scope = { enabled = true },
    --         scroll = { enabled = true },
    --         statuscolumn = { enabled = true },
    --         words = { enabled = true },
    --     },
    -- },
}
