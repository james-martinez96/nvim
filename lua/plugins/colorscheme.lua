return {
  --  'Yagua/nebulous.nvim',
  --  priority = 1000,
  --  config = function()
  --   require("nebulous").setup {
  --    variant = "night",
  --    disable = {
  --      background = true,
  --      endOfBuffer = false,
  --      terminal_colors = false,
  --    },
  --    italic = {
  --      comments   = false,
  --      keywords   = false,
  --      functions  = false,
  --      variables  = false,
  --    },
  --    custom_colors = { -- this table can hold any group of colors with their respective values
  --      -- LineNr = { fg = "#5BBBDA", bg = "NONE", style = "NONE" },
  --      LineNr = { fg = "magenta", bg = "NONE", style = "NONE" },
  --      CursorLineNr = { fg = "#E1CD6C", bg = "NONE", style = "NONE" },
  --      -- Comment = { fg = "#EA6739", bg = "NONE", style = "NONE" },
  --      Comment = { fg = "#5BBBDA", bg = "NONE", style = "NONE" },
  --
  --      -- it is possible to specify only the element to be changed
  --      TelescopePreviewBorder = { fg = "#A13413" },
  --      LspDiagnosticsDefaultError = { bg = "#E11313" },
  --      TSTagDelimiter = { style = "bold,italic" },
  --    }
  --  }
  --  -- temp fix for comment color because of treesitter highlighting overwriting some highlight groups
  --  vim.api.nvim_set_hl(0, '@comment', {fg = '#5BBBDA' })
  --  vim.api.nvim_set_hl(0, 'TabLine', {fg = 'white', bg='grey' })
  --  end,
  "folke/tokyonight.nvim",
  lazy = false,
  -- opts = {
  --   transparent = true,
  -- },
  config = function()
    require("tokyonight").setup({
      transparent = true,
    })
    vim.cmd.colorscheme("tokyonight-night")
    vim.cmd.hi("Comment gui=none")
  end,
}
