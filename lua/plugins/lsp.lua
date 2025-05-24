return {
  -- {
  --   "folke/neodev.nvim",
  --   config = true,
  -- },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
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

  -- Deprecated
  -- {
  --   "williamboman/mason-lspconfig.nvim",
  -- },

  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.black,
          -- null_ls.builtins.formatting.prettierd,
          require("none-ls.diagnostics.eslint_d"),
          require("none-ls.formatting.eslint_d"),
          require("none-ls.code_actions.eslint_d"),
          -- require("none-ls.builtins.formatting.prettier"),
          -- require("none-ls.builtins.formatting.eslint_d"),
          -- require("none-ls.builtins.code_actions.refactor"),
        },
      })

      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format File" })
    end,
  },

  {
    -- TODO:
    -- remove lspconfig
    -- not all language servers are set up yet.
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
      -- LSP keymaps
      local on_attach = function(client, buffer)
        local opts = { noremap = true, silent = true }
        vim.api.nvim_buf_set_keymap(buffer, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        vim.api.nvim_buf_set_keymap(buffer, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        vim.api.nvim_buf_set_keymap(buffer, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        vim.api.nvim_buf_set_keymap(buffer, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        vim.api.nvim_buf_set_keymap(buffer, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
        vim.api.nvim_buf_set_keymap(
          buffer,
          "n",
          "<leader>wr",
          "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
          opts
        )
        vim.api.nvim_buf_set_keymap(
          buffer,
          "n",
          "<leader>wl",
          "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
          opts
        )
        vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
        vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        vim.api.nvim_buf_set_keymap(buffer, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
        vim.api.nvim_buf_set_keymap(buffer, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
        vim.api.nvim_buf_set_keymap(buffer, "n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
        vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
        vim.api.nvim_buf_set_keymap(
          buffer,
          "n",
          "<leader>so",
          [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]],
          opts
        )
        vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format()' ]])
      end

      -- Make runtime files discoverable to the server
      local runtime_path = vim.split(package.path, ";", { plain = true })
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")

      -- vim.lsp.set_log_level(vim.log.levels.INFO)
      -- vim.diagnostic.config({virtual_text = true})
      -- vim.diagnostic.enable(true)
      -- vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN})
      -- vim.diagnostic.config {
      --       severity_sort = true,
      --       float = { border = 'rounded', source = 'if_many' },
      --       underline = { severity = vim.diagnostic.severity.ERROR },
      --       signs = vim.g.have_nerd_font and {
      --         text = {
      --           [vim.diagnostic.severity.ERROR] = '󰅚 ',
      --           [vim.diagnostic.severity.WARN] = '󰀪 ',
      --           [vim.diagnostic.severity.INFO] = '󰋽 ',
      --           [vim.diagnostic.severity.HINT] = '󰌶 ',
      --         },
      --       } or {},
      --       virtual_text = {
      --         source = 'if_many',
      --         spacing = 2,
      --         format = function(diagnostic)
      --           local diagnostic_message = {
      --             [vim.diagnostic.severity.ERROR] = diagnostic.message,
      --             [vim.diagnostic.severity.WARN] = diagnostic.message,
      --             [vim.diagnostic.severity.INFO] = diagnostic.message,
      --             [vim.diagnostic.severity.HINT] = diagnostic.message,
      --           }
      --           return diagnostic_message[diagnostic.severity]
      --         end,
      --       },
      --     }

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- require("neodev").setup({})
      --Enable (broadcasting) snippet capability for completion
      --cssls
      -- capabilities.textDocument.completion.completionItem.snippetSupport = true

      ---TODO:
      --- fix me
      local lsp_servers = {
        -- eslint = {},
        -- jdtls = {},
        gdtoolkit = {},
        clangd = {},
        -- cpptools = {},
        rust_analyzer = {},
        jedi_language_server = {},
        -- pyright = {},
        ts_ls = {},
        kotlin_language_server = {},
        -- eslint = {},
        -- tailwindcss = {},
        cssls = {},
        cssmodules_ls = {},
        vimls = {},
        texlab = {},
        asm_lsp = {},
        arduino_language_server = {},
        html = {
          filetypes = { "html", "javascriptreact", "typescriptreact", "javascript", "lua" },
        },
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT"
              },
              diagnostics = {
                globals = { "vim"},
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  '${3rd}/luv/library',
                  unpack(vim.api.nvim_get_runtime_file('', true)),
                }
              },
              completion = {
                callSnippet = "Replace",
              },
              -- telemetry = { enable = false },
            },
          }
        },
      }

      -- Auto Setup
      -- local mason_lspconfig = require("mason-lspconfig")
      -- mason_lspconfig.setup({
      --   ensure_installed = {},
      --   automatic_enable = true,
      -- })

      -- Get installed servers
      -- installed_servers = mason_lspconfig.get_installed_servers()
      -- for _, pkgs in ipairs(installed_servers) do
      --   print(pkgs)
      -- end

      -- local function to_named_config_list(servers)
      --   local list = {}
      --   for name, config in pairs(servers) do
      --     table.insert(list, {
      --       name = name,
      --       config = config,
      --     })
      --   end
      --   return list
      -- end
      --
      -- local named_configs = to_named_config_list(lsp_servers)
      -- for _, entry in ipairs(named_configs) do
      --   print("Name:", entry.name)
      --   print("Config:", vim.inspect_pos(entry.configs))
      -- end

      -- New Way
      vim.lsp.config('*', {
          -- capabilities = capabilities,
          on_attach = on_attach,
      })

      -- Loop through each server and register the config
      for name, cfg in pairs(lsp_servers) do
        vim.lsp.config(name, cfg)
        -- vim.print(name, cfg)
      end
      vim.lsp.enable(vim.tbl_keys(lsp_servers))
      -- vim.print(vim.tbl_keys(lsp_servers))
      -- local cfg = vim.lsp.config.lua_ls
      -- vim.print(cfg)

      --Deprecated: setup_handlers has been removed.
      -- require("mason-lspconfig").setup_handlers({
      --   function(server_name)
      --     require("lspconfig")[server_name].setup({
      --       capabilities = capabilities,
      --       on_attach = on_attach,
      --       settings = lsp_servers[server_name],
      --       filetypes = (lsp_servers[server_name] or {}).filetypes,
      --     })
      --     -- print("LSP: " .. server_name .. " setup")
      --     -- print(vim.inspect(mason_lspconfig.get_installed_servers()))
      --   end,
      -- })

      -- Diagnostics
      -- vim.diagnostic.config({
      --         virtual_text = true,
      --         signs = true,
      --         update_in_insert = false,
      --         float = {
      --             focusable = false,
      --             style = "minimal",
      --             border = "rounded",
      --             source = "if_many",
      --             header = "",
      --             prefix = "",
      --         },
      --     })
      --
      -- require("lspconfig").gdscript.setup(capabilities)

      -- COMPLETION
      -- luasnip setup
      -- nvim-cmp setup
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      -- cmp.setup.cmdline(':', {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = cmp.config.sources({
      --     {name='path'},
      --   })
      -- })
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
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path"},
          -- { name = "nvim_lua" },
          -- { name = "copilot" },
        },
      })
    end,
  },
}
