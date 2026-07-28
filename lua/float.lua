local M = {}

local state = {
    floating = {
        buf = -1,
        win = -1,
    },
}

--- Creates or reuses a floating window in Neovim
-- @param opts table|nil Configuration options (width, height, buf)
-- @return table { buf: number, win: number }
local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    -- Reuse existing buffer if valid, otherwise create a new scratch buffer
    local buf = (opts.buf and vim.api.nvim_buf_is_valid(opts.buf)) and opts.buf or vim.api.nvim_create_buf(false, true)

    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded", -- You can change this to "single", "double", etc.
        -- title = "Terminal",
        -- title_pos = "center",
    }

    local win = vim.api.nvim_open_win(buf, true, win_config)

    return { buf = buf, win = win }
end

--- Resizes the active floating window dynamically when Neovim resizes
local function resize_floating_window()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        return
    end

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    vim.api.nvim_win_set_config(state.floating.win, {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded",
    })
end

-- Auto-resize on window dimension changes
vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
        resize_floating_window()
    end,
})

--- Toggles or opens the terminal with an optional command
-- @param cmd string|table|nil Optional shell command to run (e.g., "love ./src ; $SHELL")
function M.toggle_terminal(cmd)
    -- If window is open AND no new command was requested, toggle it shut
    if vim.api.nvim_win_is_valid(state.floating.win) and not cmd then
        vim.api.nvim_win_hide(state.floating.win)
        return
    end

    -- If a new command was explicitly provided, wipe the old terminal buffer
    -- so jobstart/terminal creates a fresh process instead of reusing a finished shell
    if cmd and vim.api.nvim_buf_is_valid(state.floating.buf) then
        vim.api.nvim_buf_delete(state.floating.buf, { force = true })
        state.floating.buf = -1
    end

    -- Create or reuse floating window
    state.floating = create_floating_window({ buf = state.floating.buf })

    -- Spawn terminal if the buffer isn't active
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
        if cmd then
            vim.fn.jobstart(cmd, { term = true })
        else
            vim.cmd.terminal()
        end
    end

    vim.cmd("startinsert")
end

-- Commands & mappings
vim.api.nvim_create_user_command("Fterm", function(opts)
    M.toggle_terminal(opts.args ~= "" and opts.args or nil)
end, { nargs = "?" })

vim.keymap.set({ "n", "t" }, "<F2>", function()
    M.toggle_terminal()
end, { desc = "Toggle Floating Terminal" })

return M
