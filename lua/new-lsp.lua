-- PATH for these are being set by "williamboman/mason.nvim"

local lsp_servers = {
  bashls = {},
  -- eslint = {},
  -- jdtls = {},
  gdtoolkit = {},
  clangd = {},
  -- cpptools = {},
  rust_analyzer = {},
  jedi_language_server = {},
  pyright = {},
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
    filetypes = { "html", "javascriptreact", "typescriptreact", "javascript" },
  },
  lua_ls = {
  cmd = {"lua-language-server"},
  filetypes = {"lua"},
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
}

--[[New Way]]
-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
--vim.print(capabilities)
-- vim.lsp.config("*", {
  -- capabilities = capabilities,
-- })

for name, cfg in pairs(lsp_servers) do
  vim.lsp.config(name, cfg)
  -- vim.print(name, cfg)
end
vim.lsp.enable(vim.tbl_keys(lsp_servers))

-- LSP keymaps
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup("UserLspConfig", {}),
--   callback = function(keys, func, desc)
--     vim.keymap.set("n", keys, func, {buffer = ev.buf, desc = "LSP: " .. desc})
--   end
-- })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method('textDocument/implementation') then
      -- Create a keymap for vim.lsp.buf.implementation ...
        local opts = { noremap = true, silent = true }
        vim.keymap.set( "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        vim.keymap.set( "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        vim.keymap.set( "n", "S", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        vim.keymap.set( "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        vim.keymap.set( "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        vim.keymap.set( "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
        vim.keymap.set( "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
        vim.keymap.set( "n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
        vim.keymap.set( "n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
        vim.keymap.set( "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        vim.keymap.set( "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        vim.keymap.set( "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        vim.keymap.set( "n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
        vim.keymap.set( "n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
        vim.keymap.set( "n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
        vim.keymap.set( "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
        vim.keymap.set( "n", "<leader>so", [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
        vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format()' ]])
    end

      vim.diagnostic.config({
              virtual_text = true,
              signs = true,
              update_in_insert = false,
              float = {
                  focusable = false,
                  style = "minimal",
                  border = "rounded",
                  source = "if_many",
                  header = "",
                  prefix = "",
              },
          })
    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    if client:supports_method('textDocument/completion') then
      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      -- client.server_capabilities.completionProvider.triggerCharacters = chars

      -- vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})

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

    end

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
