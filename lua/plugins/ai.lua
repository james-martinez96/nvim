return {
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            local system_instructions = "You are a versatile, language-agnostic expert systems software engineer."
                .. "The user will supply code from various parts of their Linux development environment."
                .. "CRITICAL: Do NOT assume the code is related to Neovim, text editor plugins, or Lua configs unless explicitly told so."
                .. "Analyze code strictly within its native project context."
                .. "Provide direct, accurate technical answers with zero hallucinated editor dependencies."
                .. "always remeber to close code fences (or code block markers)"
                .. "NO MISTAKES."

            require("codecompanion").setup({
                display = {
                    chat = {
                        intro_message = "Press ? for options",
                        separator = "─", -- The separator between the different messages in the chat buffer
                        show_context = true, -- Show context (from editor context and slash commands) in the chat buffer?
                        show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
                        show_settings = false, -- Show LLM settings at the top of the chat buffer?
                        show_token_count = true, -- Show the token count for each response?
                        show_tools_processing = true, -- Show the loading message when tools are being executed?
                        start_in_insert_mode = false, -- Open the chat buffer in insert mode?
                    },
                },
                strategies = {
                    chat = {
                        adapter = "openai",
                        opts = {
                            system_prompt = system_instructions,
                        },
                    },
                    inline = {
                        adapter = "openai",
                        opts = {
                            system_prompt = system_instructions,
                        },
                    },
                    cmd = {
                        adapter = "openai",
                        opts = {
                            system_prompt = system_instructions,
                        },
                    },
                },
                adapters = {
                    http = {
                        openai = function()
                            return require("codecompanion.adapters").extend("openai_compatible", {
                                env = {
                                    url = "http://127.0.0.1:8080",
                                    chat_url = "/v1/chat/completions",
                                    api_key = "local-no-key-required",
                                },
                                schema = {
                                    model = {
                                        default = "LFM2-8B-A1B",
                                    },
                                },
                            })
                        end,
                    },
                },
            })

            -- Keymaps
            vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI Chat Toggle" })
            vim.keymap.set({ "n", "v" }, "<leader>ai", "<cmd>CodeCompanion<cr>", { desc = "AI Inline Edit" })
            vim.keymap.set("v", "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI Action Palette" })
        end,
    },
}
