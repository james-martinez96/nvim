return {
  -- { "christoomey/vim-tmux-navigator" },
  { "windwp/nvim-autopairs", opts = {} },
  { "j-hui/fidget.nvim", opts = {} },
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
  { "folke/which-key.nvim", opts = {} },
  { "mbbill/undotree" },
  { "tpope/vim-fugitive" },
  { "tpope/vim-surround" },
  { "tpope/vim-sleuth" },
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
  { dir = "~/.config/nvim/test_plugin.nvim" },

  { -- dir = "/mnt/usb/nvim_plugins/present.nvim",
    {"james-martinez96/present.nvim"}

    -- config = function ()
    --   require("present").setup()
    -- end
  },
}
