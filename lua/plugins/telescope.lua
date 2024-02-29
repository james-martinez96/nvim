return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    'nvim-telescope/telescope-fzf-native.nvim'
  },
  opts = {
    defaults = {
      layout_strategy = 'horizontal',
      layout_config = { height = 0.95 },
      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,
        },
      },
      file_ignore_patterns = {
        ".png",
        ".jpeg",
        "^node_modules/"
      }
    },
   -- extensions = {
   --   ['ui-select'] = {
   --     require('telescope.themes').get_dropdown()
   --   }
   -- }
  },
  config = function()
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    local builtin = require("telescope.builtin")

    vim.keymap.set('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>sf', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>sh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]], { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>so', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]], { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })
  end
}
