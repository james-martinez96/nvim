local header = {
    "███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄   ",
    "███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄ ",
    "███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███ ",
    "███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███ ",
    "███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███ ",
    "███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███ ",
    "███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███ ",
    " ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀  ",
}

-- Show the header when Neovim starts
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- do nothing if files were passed
        if vim.fn.argc() > 0 then
            return
        end
        vim.cmd("enew")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, header)

        vim.opt_local.buflisted = false
        vim.opt_local.buftype = "nofile"
        vim.opt_local.bufhidden = "hide"
        vim.opt_local.swapfile = false

        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.cursorline = false

        -- center the header vertically
        -- local height = vim.api.nvim_win_get_height(0)
        -- local padding = math.floor((height - #header) / 2)
        -- if padding > 0 then
        --     vim.api.nvim_buf_set_lines(0, 0, 0, false, vim.tbl_map(function() return "" end, vim.tbl_extend("force", {}, {}, {})))
        -- end
        --
    end,
})
