-- TODO: update treesitter to main branch
-- TODO: add nvim-treesitter-textobjects
-- TODO: automate tree-sitter-cli installation
return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "main",
        -- dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        build = ":TSUpdate",
        config = function(_, opts)
            local parsers = {
                "c",
                "cpp",
                "go",
                "lua",
                "python",
                "rust",
                "tsx",
                "jsx",
                "javascript",
                "typescript",
                "vimdoc",
                "vim",
                "bash",
                "gdscript",
                "godot_resource",
                "gdshader",
                "c_sharp",
                "tmux",
                "yaml",
                "json",
                "v",
            }
            local nvim_treesitter = require("nvim-treesitter")
            nvim_treesitter.setup({})
            nvim_treesitter.install(parsers)
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
            local ft_patterns = vim.tbl_extend("force", parsers, { "javascriptreact", "typescriptreact" })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = ft_patterns,
                callback = function()
                    -- syntax highlighting, provided by Neovim
                    vim.treesitter.start()
                    -- folds, provided by Neovim
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    -- indentation, provided by nvim-treesitter
                    -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    if vim.bo.filetype ~= "v" then -- vlang does not use ;
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
}
