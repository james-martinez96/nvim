return {
  { "christoomey/vim-tmux-navigator" },
  { "windwp/nvim-autopairs", opts = {} },
  { "j-hui/fidget.nvim", opts = {} },
  { "numToStr/Comment.nvim", opts = {} },
  { "folke/which-key.nvim", opts = {} },
  { "mbbill/undotree" },
  { "tpope/vim-fugitive" },
  { "tpope/vim-surround" },
  { "tpope/vim-sleuth" },
  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = "ibl",
    opts = {
      -- debounce = 100,
      -- indent = { char = "|" },
      -- whitespace = { highlight = { "Whitespace", "NonText" } },
      -- scope = { exclude = { language = { "lua" } } },
    },
  },
  { dir = "~/.config/nvim/test_plugin.nvim" }
}
