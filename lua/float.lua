local state = {
    floating = {
        buf = -1,
        win = -1,
    },
}

--- Creates a floating window in Neovim
-- @param opts table|nil Optional configuration table with `width` and `height`
-- @return number Buffer ID of the created floating window
local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true) -- Create a scratch buffer
    end

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

local function resize_floating_window()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        return
    end
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)
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

vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
        resize_floating_window()
    end,
})

local toggle_terminal = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = create_floating_window({ buf = state.floating.buf })
        if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd.terminal()
        end
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end

vim.api.nvim_create_user_command("Fterm", toggle_terminal, {})
vim.keymap.set({ "n", "t" }, "<F2>", toggle_terminal)
