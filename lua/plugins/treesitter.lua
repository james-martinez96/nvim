-- TODO: update treesitter to main branch
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "master",
    -- dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    build = ":TSUpdate",
    opts = {
      highlight = { enable = true },
      ensure_installed = {
        "c", "cpp", "go", "lua", "python", "rust",
        "tsx", "javascript", "typescript", "vimdoc",
        "vim", "bash", "gdscript", "godot_resource", "gdshader", "c_sharp",
      },
      -- auto_install = true,
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- register local duckyscript parser
      -- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      -- parser_config.duckyscript = {
      --   install_info = {
      --     url = "/mnt/usb/flipper/duckyscript/tree-sitter-duckyscript",
      --     files = { "src/parser.c" },
      --     branch = "main",
      --   },
      --   filetype = "duckyscript",
      -- }
      -- vim.filetype.add({
      --   extension = {
      --     duckyscript = "duckyscript",
      --     duck = "duckyscript",
      --     ds = "duckyscript",
      --   },
      -- })
    end,
  },
  -- {
    -- "nvim-treesitter/nvim-treesitter-textobjects",
    -- branch = "main",
    -- build = ":TSUpdate",
    -- dependencies = { "nvim-treesitter/nvim-treesitter" },
    -- config = function()
    --   require("nvim-treesitter-textobjects").setup({
    --     textobjects = {
    --       select = {
    --         enable = true,
    --         lookahead = true,
    --         keymaps = {
    --           ["aa"] = "@parameter.outer",
    --           ["ia"] = "@parameter.inner",
    --           ["af"] = "@function.outer",
    --           ["if"] = "@function.inner",
    --           ["ac"] = "@class.outer",
    --           ["ic"] = "@class.inner",
    --         },
    --       },
    --       move = {
    --         enable              = true,
    --         set_jumps           = true,
    --         goto_next_start     = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
    --         goto_next_end       = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
    --         goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
    --         goto_previous_end   = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
    --       },
    --       swap = {
    --         enable = true,
    --         swap_next = { ["<leader>a"] = "@parameter.inner" },
    --         swap_previous = { ["<leader>A"] = "@parameter.inner" },
    --       },
    --     },
    --   })
    -- end,
  -- },
}
