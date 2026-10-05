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
    },

    opts = {
        defaults = {
            layout_strategy = "flex",
            layout_config = {
                flex = {
                    flip_columns = 150, -- Switches to vertical below 120 columns
                },
                horizontal = {
                    width = 0.90,
                    height = 0.85,
                    preview_width = 0.55,
                },
                vertical = {
                    width = 0.95,
                    height = 0.95,
                    preview_height = 0.5,
                },
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
    },

    config = function(_, opts)
        local telescope = require("telescope")
        local action_state = require("telescope.actions.state")

        telescope.setup(opts)

        -- Force Telescope to recalculate layout live during real-time tmux pane resizing
        vim.api.nvim_create_autocmd("VimResized", {
            group = vim.api.nvim_create_augroup("TelescopeRealtimeResize", { clear = true }),
            callback = function()
                local current_buf = vim.api.nvim_get_current_buf()
                if vim.bo[current_buf].filetype == "TelescopePrompt" then
                    local picker = action_state.get_current_picker(current_buf)
                    if picker then
                        picker:full_layout_update()
                    end
                end
            end,
        })

        pcall(telescope.load_extension, "fzf")

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
