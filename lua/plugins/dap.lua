-- Dap (Debug Adapter Protocol)
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-telescope/telescope-dap.nvim",
    -- Debuggers
    --  'jbyuki/one-small-step-for-vimkind' -- Neovim Lua
    "mfussenegger/nvim-dap-python", -- Python
  },
  config = function()
    local dap = require('dap')
    local dapui = require("dapui")
    dapui.setup()
    require("nvim-dap-virtual-text").setup()
    require("telescope").load_extension("dap")

    vim.keymap.set("n", "<leader>duo", dapui.open, { desc = "open dap ui" })
    vim.keymap.set("n", "<leader>duc", dapui.close, { desc = "close dap ui" })
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Dap breakpoint" })
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Dap continue" })
    vim.keymap.set("n", "<leader>dsi", dap.step_into, { desc = "Dap step into" })
    vim.keymap.set("n", "<leader>dso", dap.step_over, { desc = "Dap step over" })
    vim.keymap.set("n", "<leader>dsO", dap.step_out, { desc = "Dap step out" })
    vim.keymap.set("n", "<leader>dsb", dap.step_back, { desc = "Dap step back" })
    vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Dap restart" })
    vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Dap terminate" })

    vim.keymap.set("n", "<leader>drc", dap.run_to_cursor, { desc = "Dap run to cursor" })

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
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

    -- require("dap").adapters["pwa-node"] = {
    --   type = "server",
    --   host = "localhost",
    --   port = "5032",
    --   executable = {
    --     command = "node",
    --     -- 💀 Make sure to update this path to point to your installation
    --     args = { "/home/casper/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
    --     -- args = { "~/.local/share/nvim/mason/packages/js-debug-adapter/, "${port}" },
    --   },
    -- }
    --
    -- require("dap").configurations.javascript = {
    --   {
    --     type = "pwa-node",
    --     request = "launch",
    --     name = "Launch file",
    --     program = "${file}",
    --     cwd = "${workspaceFolder}",
    --   },
    -- }

    require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")

    dap.adapters.bashdb = {
      type = "executable",
      command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
      name = "bashdb",
    }
    dap.configurations.sh = {
      {
        type = "bashdb",
        request = "launch",
        name = "Launch file",
        showDebugOutput = true,
        pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
        pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
        trace = true,
        file = "${file}",
        program = "${file}",
        cwd = "${workspaceFolder}",
        pathCat = "cat",
        pathBash = "/bin/bash",
        pathMkfifo = "mkfifo",
        pathPkill = "pkill",
        args = {},
        env = {},
        terminalKind = "integrated",
      },
    }

    -- dap.adapters.lldb = {
    --   type = "executable",
    --   -- command = "/usr/bin/lldb-vscode", -- adjust as needed, must be absolute path
    --   command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb", -- adjust as needed, must be absolute path
    --   name = "lldb",
    -- }

    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        -- CHANGE THIS to your path!
        command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
        args = { "--port", "${port}" },

        -- On windows you may have to uncomment this:
        -- detached = false,
      },
    }

    dap.configurations.cpp = {
      {
        name = "Launch",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},

        -- 💀
        -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
        --
        --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        --
        -- Otherwise you might get the following error:
        --
        --    Error on launch: Failed to attach to the target process
        --
        -- But you should be aware of the implications:
        -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
        -- runInTerminal = false,
      },
    }
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp

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
