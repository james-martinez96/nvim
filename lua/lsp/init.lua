-- TODO: move lsp servers to their own .lua files
local diagnostic = require("vim.diagnostic")
local lsp = require("vim.lsp")

-- Default configs for these are being set by "williamboman/mason.nvim"
-- TODO: upload lsp or something
local lsp_servers = {
    -- LSP for Commodore64 and vice
    -- c64_lsp = {
    --     cmd = {"python", "/mnt/usb/C64 lsp/c64_lsp.py"},
    --     filetypes = {"c64asm"},
    --     root_dir = vim.fn.getcwd(),
    -- },
    -- LSP for duckyscript
    -- ducky = {
    --   cmd = {"python", "/mnt/usb/flipper/duckyscript/ducky_lsp.py"},
    --   filetypes = {"duckyscript"},
    --   root_dir = vim.fn.getcwd(),
    -- },
    bashls = {},
    -- jdtls = {},
    gdscript = {},
    clangd = {
        on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end,
    },
    -- cpptools = {},
    rust_analyzer = {},
    jedi_language_server = {},
    pyright = {
        -- cmd = { "pyright-langserver", "--stdio" },
        -- filetypes = { "python" }
    },
    ts_ls = {
        -- Note: typescript-tools.nvim will handle TypeScript if you're using it
        -- You might want to disable this if using typescript-tools
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
            javascript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
        },
    },
    -- kotlin_language_server = {},
    kotlin_lsp = {},
    -- eslint = {},
    tailwindcss = {},
    cssls = {},
    cssmodules_ls = {},
    vimls = {},
    texlab = {},
    ltex_plus = {
        filetypes = { "tex", "gitcommit" },
        settings = {
            ltex = {
                language = "en-AU",
            },
        },
    },
    -- asm_lsp = {},
    arduino_language_server = {},
    html = {
        filetypes = { "html" },
    },
    lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        "${3rd}/luv/library",
                        unpack(vim.api.nvim_get_runtime_file("lua", true)),
                    },
                },
                completion = {
                    callSnippet = "Replace",
                },
                -- telemetry = { enable = false },
            },
        },
    },
    nginx_language_server = {},
    -- csharp_ls = {},
    -- copilot = {},
    v_analyzer = {},
}

-- Get capabilities from nvim-cmp
local capabilities = lsp.protocol.make_client_capabilities()
local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
    capabilities = cmp_lsp.default_capabilities(capabilities)
end

for name, config in pairs(lsp_servers) do
    config.capabilities = capabilities
    lsp.config(name, config)
    -- vim.print(name, config)
end
lsp.enable(vim.tbl_keys(lsp_servers))

-- LSP keymaps
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup("UserLspConfig", {}),
--   callback = function(keys, func, desc)
--     vim.keymap.set("n", keys, func, {buffer = ev.buf, desc = "LSP: " .. desc})
--   end
-- })

-- Configure diagnostics
diagnostic.config({
    virtual_text = {
        -- prefix = "●",
        source = "if_many",
    },
    -- signs = true,
    signs = {
        text = {
            [diagnostic.severity.ERROR] = "󰅚",
            [diagnostic.severity.WARN] = "󰀪",
            [diagnostic.severity.HINT] = "󰌶",
            [diagnostic.severity.INFO] = "󰋽",
        },
        linehl = {
            -- [vim.diagnostic.severity.ERROR] = 'DiagnosticSign',
        },
        numhl = {
            -- [vim.diagnostic.severity.WARN] = 'DiagnosticSign',
        },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
    },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("my.lsp", {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local opts = { noremap = true, silent = true }
        -- print(client:supports_method('textDocument/implementation'))
        vim.keymap.set(
            "n",
            "<leader>q",
            diagnostic.setloclist,
            vim.tbl_extend("force", opts, { desc = "Send all diagnostics to qfix list" })
        )

        if client:supports_method("textDocument/implementation") then
            -- Create a keymap for vim.lsp.buf.implementation ...
            vim.keymap.set("n", "gD", lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "goto declaration" }))
            vim.keymap.set("n", "gd", lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "goto definition" }))
            vim.keymap.set("n", "S", lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "hover info" }))
            vim.keymap.set(
                "n",
                "gi",
                lsp.buf.implementation,
                vim.tbl_extend("force", opts, { desc = "goto implementation" })
            )
            vim.keymap.set(
                "n",
                "<C-k>",
                lsp.buf.signature_help,
                vim.tbl_extend("force", opts, { desc = "signature info" })
            )
            vim.keymap.set(
                "n",
                "<leader>wa",
                lsp.buf.add_workspace_folder,
                vim.tbl_extend("force", opts, { desc = "add workspace folder" })
            )
            vim.keymap.set(
                "n",
                "<leader>wr",
                lsp.buf.remove_workspace_folder,
                vim.tbl_extend("force", opts, { desc = "remove workspace folder" })
            )
            vim.keymap.set(
                "n",
                "<leader>wl",
                "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
                vim.tbl_extend("force", opts, { desc = "list workspace folders" })
            )
            vim.keymap.set(
                "n",
                "<leader>D",
                lsp.buf.type_definition,
                vim.tbl_extend("force", opts, { desc = "goto type definition" })
            )
            vim.keymap.set("n", "<leader>rn", lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP rename" }))
            vim.keymap.set(
                "n",
                "gr",
                lsp.buf.references,
                vim.tbl_extend("force", opts, { desc = "list all references" })
            )
            vim.keymap.set(
                "n",
                "<leader>ca",
                lsp.buf.code_action,
                vim.tbl_extend("force", opts, { desc = "LSP: code action" })
            )
            vim.keymap.set(
                "n",
                "<leader>e",
                diagnostic.open_float,
                vim.tbl_extend("force", opts, { desc = "show diagnostics" })
            )
            vim.keymap.set("n", "[d", function()
                diagnostic.jump({ count = -1, float = true })
            end, vim.tbl_extend("force", opts, { desc = "Move to prev diagnostic" }))
            vim.keymap.set("n", "]d", function()
                diagnostic.jump({ count = 1, float = true })
            end, vim.tbl_extend("force", opts, { desc = "Move to next diagnostic" }))
            vim.keymap.set(
                "n",
                "<leader>so",
                require("telescope.builtin").lsp_document_symbols,
                { desc = "document symbols" }
            )
        end
    end,
})
