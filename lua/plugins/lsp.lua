return {
  {
    "folke/neodev.nvim",
    config = true,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    -- opts = {
    --   ensure_installed = {
    --     "lua_ls",
    --     --[["tsserver",]]
    --     "cssls",
    --     "tailwindcss",
    --     "html",
    --     "jedi_language_server",
    --     "vimls",
    --     "clangd",
    --     "arduino_language_server",
    --   },
    -- },
  },

  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.eslint,
        },
      })

      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format File" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/nvim-cmp",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
      {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        -- config = function()
        --   require("typescript-tools").setup {}
        -- end,
      },
    },
    config = function()
      -- LSP settings
      local lspconfig = require("lspconfig")
      local on_attach = function(_, bufnr)
        local opts = { noremap = true, silent = true }
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
        vim.api.nvim_buf_set_keymap(
          bufnr,
          "n",
          "<leader>wr",
          "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
          opts
        )
        vim.api.nvim_buf_set_keymap(
          bufnr,
          "n",
          "<leader>wl",
          "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
          opts
        )
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
        vim.api.nvim_buf_set_keymap(
          bufnr,
          "n",
          "<leader>so",
          [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]],
          opts
        )
        vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format()' ]])
      end

      -- Example custom server
      -- Make runtime files discoverable to the server
      local runtime_path = vim.split(package.path, ";", { plain = true })
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      --Enable (broadcasting) snippet capability for completion
      --cssls
      -- capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- [[
      -- TODO figure out how to change the defaults for each lang server
      -- using this array and for loop
      -- ]]
      -- Enable the following language servers
      -- they are using default settings
      local servers = {
        --[['sumneko_lua',]]
        clangd = {},
        rust_analyzer = {},
        --[['pyright',]]
        jedi_language_server = {},
        --[['tsserver',]]
        --[['eslint',]]
        tailwindcss = {},
        cssls = {},
        cssmodules_ls = {},
        vimls = {},
        texlab = {},
        asm_lsp = {},
        arduino_language_server = {},
        html = {
          filetypes = { "html", "javascriptreact", "typscriptreact" },
        },
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
          settings = {
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      }

      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
      })
      mason_lspconfig.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
          })
        end,
      })

      -- for _, lsp in ipairs(servers) do
      --   lspconfig[lsp].setup({
      --     on_attach = on_attach,
      --     capabilities = capabilities,
      --   })
      -- end

      require("neodev").setup({})

      require("typescript-tools").setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          -- spawn additional tsserver instance to calculate diagnostics on it
          separate_diagnostic_server = true,
          -- "change"|"insert_leave" determine when the client asks the server about diagnostic
          publish_diagnostic_on = "insert_leave",
          -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
          -- "remove_unused_imports"|"organize_imports") -- or string "all"
          -- to include all supported code actions
          -- specify commands exposed as code_actions
          expose_as_code_action = {},
          -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
          -- not exists then standard path resolution strategy is applied
          tsserver_path = nil,
          -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
          -- (see 💅 `styled-components` support section)
          tsserver_plugins = {},
          -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
          -- memory limit in megabytes or "auto"(basically no limit)
          tsserver_max_memory = "auto",
          -- described below
          tsserver_format_options = {},
          tsserver_file_preferences = {},
          -- locale of all tsserver messages, supported locales you can find here:
          -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
          tsserver_locale = "en",
          -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
          complete_function_calls = false,
          include_completions_with_insert_text = true,
          -- CodeLens
          -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
          -- possible values: ("off"|"all"|"implementations_only"|"references_only")
          code_lens = "off",
          -- by default code lenses are displayed on all referencable values and for some of you it can
          -- be too much this option reduce count of them by removing member references from lenses
          disable_member_code_lens = true,
          -- JSXCloseTag
          -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-auto-tag,
          -- that maybe have a conflict if enable this feature. )
          jsx_close_tag = {
            enable = false,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        },
      })

      -- COMPLETION
      -- luasnip setup
      -- nvim-cmp setup
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup({})
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        -- the order of sources matter (by default). That gives the priority
        -- you can confugure:
        --    keyword_length
        --    priority
        --    max_item_count
        --    (more)
        sources = {
          { name = "nvim_lua" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
        },
      })
    end,
  },
}
