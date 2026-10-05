local M = {}

---Create a floating popup window
---@param data string[] Lines to display in the buffer
function M.create_popup(data)
    local buf = vim.api.nvim_create_buf(false, true)

    -- Set buffer content
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, data)

    local opts = {
        relative = "win",
        width = 40,
        height = math.max(#data, 1),
        row = 10,
        col = 10,
        border = "single",
        style = "minimal",
        title = "Output",
    }

    local winid = vim.api.nvim_open_win(buf, true, opts)

    -- Disable line numbers for the popup window
    vim.wo[winid].number = false
    vim.wo[winid].relativenumber = false

    -- Close popup on <Esc> using a Lua callback
    vim.keymap.set("n", "<Esc>", function()
        if vim.api.nvim_win_is_valid(winid) then
            vim.api.nvim_win_close(winid, true)
        end
    end, { buffer = buf, noremap = true, silent = true })
end

---Create or reuse a split window for a named buffer without stealing focus
---@param data string[] Lines to insert into the buffer
---@param buf_name string Buffer identifier name
function M.create_split(data, buf_name)
    local buf = vim.fn.bufadd(buf_name)

    -- Set buffer options cleanly
    local buf_opts = { buftype = "nofile", bufhidden = "wipe", swapfile = false }
    for key, val in pairs(buf_opts) do
        vim.api.nvim_set_option_value(key, val, { buf = buf })
    end

    local win = vim.fn.bufwinid(buf)

    if win ~= -1 then
        -- Buffer is already open in a window: update lines without moving cursor
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, data)
    else
        -- Save current window so we can restore focus after splitting
        local current_win = vim.api.nvim_get_current_win()

        -- Update lines and create split
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, data)
        vim.cmd.vsplit()
        vim.api.nvim_set_current_buf(buf)
        win = vim.api.nvim_get_current_win()

        -- Disable line numbers on the new split
        vim.wo[win].number = false
        vim.wo[win].relativenumber = false

        -- Restore focus back to the original window
        vim.api.nvim_set_current_win(current_win)
    end
end

return M
