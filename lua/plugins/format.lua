return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>fb",
                function()
                    require("conform").format({ async = true })
                end,
                mode = "",
                desc = "Format Buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                c = { "clang-format" },
                cpp = { "clang-format" },
                gdscript = {"gdformat"},
            },
            formatters = {
                ["clang-format"] = {
                    prepend_args = { "--style=file" },
                },
                gdformat = {
                    command = vim.fn.expand("~/.local/share/nvim/mason/packages/gdtoolkit/venv/bin/gdformat"),
                }
            },
            -- format_on_save = function(bufnr)
            --     local filetype = vim.bo[bufnr].filetype
            --
            --     -- Force clang-format to handle C/C++ without LSP interference
            --     if filetype == "c" or filetype == "cpp" then
            --         return { timeout_ms = 500, lsp_fallback = "never" }
            --     end
            --
            --     -- Fallback for other languages
            --     return {
            --         timeout_ms = 500,
            --         lsp_fallback = true,
            --     }
            -- end,
        },
    },
}
