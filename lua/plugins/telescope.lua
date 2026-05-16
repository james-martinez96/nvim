return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",

        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },

        -- Optional
        -- "nvim-telescope/telescope-ui-select.nvim",
    },

    opts = {
        defaults = {
            layout_strategy = "vertical",
            layout_config = {
                height = 0.95,
            },

            mappings = {
                i = {
                    ["<C-u>"] = false,
                    ["<C-d>"] = false,
                },
            },

            file_ignore_patterns = {
                "^node_modules/",
            },
        },

        -- extensions = {
        --     ["ui-select"] = {
        --         require("telescope.themes").get_dropdown(),
        --     },
        -- },
    },

    config = function(_, opts)
        local telescope = require("telescope")

        telescope.setup(opts)

        pcall(telescope.load_extension, "fzf")
        pcall(telescope.load_extension, "ui-select")

        local builtin = require("telescope.builtin")

        local function telescope_live_grep_open_files()
            builtin.live_grep({
                grep_open_files = true,
                prompt_title = "Live Grep in Open Files",
            })
        end

        vim.keymap.set(
            "n",
            "<leader>s/",
            telescope_live_grep_open_files,
            { desc = "[S]earch [/] in Open Files" }
        )

        vim.keymap.set(
            "n",
            "<leader><space>",
            builtin.buffers,
            { desc = "[ ] Find existing buffers" }
        )

        vim.keymap.set(
            "n",
            "<leader>?",
            builtin.oldfiles,
            { desc = "[?] Find recently opened file" }
        )

        vim.keymap.set("n", "<leader>sf", function()
            builtin.find_files({
                find_command = {
                    "rg",
                    "--files",

                    "--glob",
                    "!*.png",

                    "--glob",
                    "!*.jpeg",

                    "--glob",
                    "!*.jpg",

                    "--glob",
                    "!*.gd.uid",

                    "--glob",
                    "!node_modules/",
                },
            })
        end, { desc = "[S]earch [F]iles" })

        vim.keymap.set("n", "<leader>/sf", function()
            builtin.find_files({
                find_command = {
                    "rg",
                    "--files",
                    "--hidden",
                    "--no-ignore",
                },
            })
        end, { desc = "[S]earch [F]iles (all, hidden, no-ignore)" })

        vim.keymap.set(
            "n",
            "<leader>sb",
            builtin.current_buffer_fuzzy_find,
            { desc = "[S]earch [B]uffer" }
        )

        vim.keymap.set(
            "n",
            "<leader>sh",
            builtin.help_tags,
            { desc = "[S]earch [H]elp" }
        )

        vim.keymap.set(
            "n",
            "<leader>st",
            builtin.tags,
            { desc = "[S]earch [T]ags" }
        )

        vim.keymap.set(
            "n",
            "<leader>sd",
            builtin.grep_string,
            { desc = "[S]earch Current Word" }
        )

        vim.keymap.set(
            "n",
            "<leader>sp",
            builtin.live_grep,
            { desc = "[S]earch by [P]attern" }
        )

        vim.keymap.set("n", "<leader>/sp", function()
            builtin.live_grep({
                additional_args = function()
                    return {
                        "--hidden",
                        "--no-ignore",
                    }
                end,
            })
        end, { desc = "[S]earch [P]attern (hidden, no-ignore)" })
    end,
}
