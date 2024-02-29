return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
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
    -- local opts = { noremap = true, silent = true }

    local function telescope_live_grep_open_files()
      require('telescope.builtin').live_grep {
	grep_open_files = true,
	prompt_title = 'Live Grep in Open Files',
      }
    end

    vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers,  { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles,  { desc = '[?] Find recently opoend file' })
    vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
    vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files,  { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sb', require('telescope.builtin').current_buffer_fuzzy_find,  { desc =  '[S]earch [B]uffer' })
    vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>st', require('telescope.builtin').tags, { desc = '[S]earch [T]ags'} )
    vim.keymap.set('n', '<leader>sd', require('telescope.builtin').grep_string, { desc = 'Search Tags'})
    vim.keymap.set('n', '<leader>sp', require('telescope.builtin').live_grep, { desc = 'Live Grep'} )
    -- vim.keymap.set('n', '<leader>so', require('telescope.builtin').tags{ only_current_buffer = true }, )
  end
}
