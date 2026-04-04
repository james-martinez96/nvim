local diagnostic = require("vim.diagnostic")
local lsp = require("vim.lsp")

-- Default configs for these are being set by "williamboman/mason.nvim"
local lsp_servers = {
    -- LSP for duckyscript
    -- ducky = {
    --   cmd = {"python", "/mnt/usb/flipper/duckyscript/ducky_lsp.py"},
    --   filetypes = {"duckyscript"},
    --   root_dir = vim.fn.getcwd(),
    -- },
    stylua = {}, -- need to setup
    bashls = {},
    -- jdtls = {},
    gdscript = {},
    clangd = {},
    -- cpptools = {},
    rust_analyzer = {},
    jedi_language_server = {},
    pyright = {},
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
        settings = {
            ltex = {
                language = "en-AU",
            },
        },
    },
    asm_lsp = {},
    arduino_language_server = {},
    html = {
        -- filetypes = { "html", "javascriptreact", "typescriptreact", "javascript" },
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
                        unpack(vim.api.nvim_get_runtime_file("", true)),
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
    -- vim.print(name, cfg)
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
            vim.keymap.set(
                "n",
                "[d",
                function ()
                    diagnostic.jump({count=-1, float=true})
                end,
                vim.tbl_extend("force", opts, { desc = "Move to prev diagnostic" })
            )
            vim.keymap.set(
                "n",
                "]d",

                function ()
                    diagnostic.jump({count=1, float=true})
                end,
                vim.tbl_extend("force", opts, { desc = "Move to next diagnostic" })
            )
            -- vim.keymap.set( "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
            vim.keymap.set(
                "n",
                "<leader>so",
                require("telescope.builtin").lsp_document_symbols,
                { desc = "document symbols" }
            )
            -- vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format()' ]])
            vim.api.nvim_create_user_command("Format", function()
                vim.lsp.buf.format()
            end, {})
        end

        -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
        -- if client:supports_method('textDocument/completion') then
        -- Optional: trigger autocompletion on EVERY keypress. May be slow!
        -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
        -- client.server_capabilities.completionProvider.triggerCharacters = chars

        -- vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})

        -- local cmp = require("cmp")
        -- local luasnip = require("luasnip")
        -- require("luasnip.loaders.from_vscode").lazy_load()
        -- -- cmp.setup.cmdline(':', {
        -- --   mapping = cmp.mapping.preset.cmdline(),
        -- --   sources = cmp.config.sources({
        -- --     {name='path'},
        -- --   })
        -- -- })
        -- luasnip.config.setup({})
        -- cmp.setup({
        --   snippet = {
        --     expand = function(args)
        --       luasnip.lsp_expand(args.body)
        --     end,
        --   },
        --   completion = {
        --     completeopt = "menu,menuone,noinsert",
        --   },
        --   mapping = cmp.mapping.preset.insert({
        --     ["<C-p>"] = cmp.mapping.select_prev_item(),
        --     ["<C-n>"] = cmp.mapping.select_next_item(),
        --     ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        --     ["<C-f>"] = cmp.mapping.scroll_docs(4),
        --     ["<C-Space>"] = cmp.mapping.complete(),
        --     ["<C-e>"] = cmp.mapping.close(),
        --     ["<CR>"] = cmp.mapping.confirm({
        --       behavior = cmp.ConfirmBehavior.Replace,
        --       select = true,
        --     }),
        --     ["<Tab>"] = cmp.mapping(function(fallback)
        --       if cmp.visible() then
        --         cmp.select_next_item()
        --       elseif luasnip.expand_or_locally_jumpable() then
        --         luasnip.expand_or_jump()
        --       else
        --         fallback()
        --       end
        --     end, { "i", "s" }),
        --     ["<S-Tab>"] = cmp.mapping(function(fallback)
        --       if cmp.visible() then
        --         cmp.select_prev_item()
        --       elseif luasnip.locally_jumpable(-1) then
        --         luasnip.jump(-1)
        --       else
        --         fallback()
        --       end
        --     end, { "i", "s" }),
        --   }),
        --   -- the order of sources matter (by default). That gives the priority
        --   -- you can confugure:
        --   --    keyword_length
        --   --    priority
        --   --    max_item_count
        --   --    (more)
        --   sources = {
        --     { name = "nvim_lsp" },
        --     { name = "luasnip" },
        --     { name = "buffer" },
        --     { name = "path"},
        --     -- { name = "nvim_lua" },
        --     -- { name = "copilot" },
        --   },
        -- })

        -- end

        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        -- if not client:supports_method('textDocument/willSaveWaitUntil')
        --     and client:supports_method('textDocument/formatting') then
        --   vim.api.nvim_create_autocmd('BufWritePre', {
        --     group = vim.api.nvim_create_augroup('my.lsp', {clear=false}),
        --     buffer = args.buf,
        --     callback = function()
        --       vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        --     end,
        --   })
        -- end
    end,
})
