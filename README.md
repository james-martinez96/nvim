This is my configuration for Neovim.
which includes a set of plugins and keymaps.

## > [!WARNING]
> this is a personal project to learn more about Lua and Neovim.

> this config auto installs things.

> use at your own risk.

> may not work on windows.

## Structure

The project is structured as follows:

- `init.lua`: This is the main entry point of the configuration.
- `test_plugin.nvim`: Ignore this.
- `lua/`: This directory contains the Lua scripts.
  - `plugins/`: Contains the configuration for various plugins loaded with Lazy.nvim plugin manager.
    - `colorscheme.lua`: just a basic theme plugin with custom highlights.
    - `copilot.lua`: copilot plugin.
    - `dap.lua`: some configurations for nvim-dap.
    - `gitsigns.lua`: Gitsigns is a plugin for Neovim that provides integration with Git.
    - `init.lua`: contains more plugins using there default configuration.
    - `lsp.lua`: configuration for Neovim's language server protocol.
    - `lualine.lua`: better looking status line using lualine.nvim.
    - `neo-tree.lua`: displays a tree structures for browsing the filesystem.
    - `telescope.lua`: a configuration for Telescope.nvim for fuzzy finding.
    - `treesitter.lua`: configuration for nvim-treesitter.
  - `keymaps.lua`: keymaps.
  - `options.lua`: options for neovim.
  - `utils.lua`: basic utility functions.
  - `session_manager.lua`: Manages sessions in Neovim.
  - `run.lua`: Contains basic plugin that just runs a file and displays the output in a buffer.
    - execute the ":Run" command in a supported file to see the output.

## Setup

To set up this configuration, clone the repository and copy the configuration files to your Neovim configuration directory.

```sh
git clone https://github.com/james-martinez96/nvim.git
cp -r nvim ~/.config/nvim
