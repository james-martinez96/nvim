-- Dap (Debug Adapter Protocol)
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-telescope/telescope-dap.nvim",
    -- Debuggers
    --  'jbyuki/one-small-step-for-vimkind' -- Neovim Lua
    "mfussenegger/nvim-dap-python", -- Python
  },
  config = function()
    -- local dap = require('dap')
    -- dap.configurations.python = {
    --   {
    --     -- The first three options are required by nvim-dap
    --     type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    --     request = 'launch';
    --     name = 'Launch file';

    --     -- Options below are for debugpy,
    --     -- see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
    --     -- for supported options

    --     program = '${file}';
    --     pythonPath = function()
    --       -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
    --       -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
    --       -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
    --       local cwd = vim.fn.getcwd()
    --       if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
    --         return cwd .. '/venv/bin/python'
    --       elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
    --         return cwd .. '.venv/bin/python'
    --       elseif vim.fn.executable(cwd .. '~/.config/nvim/debug-adapters/debugpy/bin/python') == 1 then
    --         return cwd .. '~/.config/nvim/debug-adapters/debugpy/bin/python'
    --       else
    --         return 'usr/bin/python'
    --       end
    --     end
    --   }
    -- }
    require("dap-python").setup("~/.config/nvim/debug-adapters/debugpy/bin/python")
    require("dapui").setup()

    -- local dap = require"dap"
    -- dap.configurations.lua = {
    --   {
    --     type = 'nlua',
    --     request = 'attach',
    --     name = "Attach to running Neovim instance",
    --     host = "127.0.0.1",
    --     port = 8086
    --   }
    -- }

    -- dap.adapters.nlua = function(callback, config)
    --   callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
    -- end
  end,
}
