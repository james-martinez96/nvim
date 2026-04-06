-- Define PopUp menu items in a Lua table
local popup_menus = {
    { mode = "n", name = "PopUp.Go to definition", cmd = "<Cmd>lua vim.lsp.buf.definition()<CR>" },
    { mode = "a", name = "PopUp.Hover", cmd = "<Cmd>lua vim.lsp.buf.hover()<CR>"},
    { mode = "n", name = "PopUp.Open in web browser", cmd = "gx" },
    { mode = "n", name = "PopUp.Inspect", cmd = "<Cmd>Inspect<CR>" },
    { mode = "v", name = "PopUp.Cut", cmd = '"+x' },
    { mode = "v", name = "PopUp.Copy", cmd = '"+y' },
    { mode = "n", name = "PopUp.Paste", cmd = '"+gP' },
    { mode = "v", name = "PopUp.Paste", cmd = '"+P' },
    { mode = "v", name = "PopUp.Delete", cmd = '"_x' },
    { mode = "n", name = "PopUp.Select All", cmd = "ggVG" },
    { mode = "v", name = "PopUp.Select All", cmd = "gg0oG$" },
    { mode = "i", name = "PopUp.Select All", cmd = "<C-Home><C-O>VG" },
    { mode = "n", name = "PopUp.How-to disable mouse", cmd = "<Cmd>help disable-mouse<CR>" },
}

-- Helper to safely create menu items
local function create_menu(menu)
    local cmd_str = string.format("%snoremenu %s %s", menu.mode, menu.name:gsub(" ", "\\ "), menu.cmd)
    vim.cmd(cmd_str)
end

-- Create all menus
for _, m in ipairs(popup_menus) do
    create_menu(m)
end

-- Safe enable/disable wrapper
local function safe_menu(action, name)
    local ok, _ = pcall(vim.cmd, string.format("amenu %s %s", action, name))
    return ok
end

-- Autocmd group
local group = vim.api.nvim_create_augroup("nvim_popupmenu", { clear = true })

vim.api.nvim_create_autocmd("MenuPopUp", {
    pattern = "*",
    group = group,
    desc = "Dynamic PopUp Setup",
    callback = function()
        -- Disable all LSP/URL dependent menus initially
        safe_menu("disable", "PopUp.Go\\ to\\ definition")
        safe_menu("disable", "PopUp.References")
        safe_menu("disable", "PopUp.Hover")
        safe_menu("disable", "PopUp.URL")

        -- Enable menus if LSP client supports them
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
            if client.supports_method("textDocument/definition") then
                safe_menu("enable", "PopUp.Go\\ to\\ definition")
            end
            if client.supports_method("textDocument/references") then
                safe_menu("enable", "PopUp.References")
            end
            if client.supports_method("textDocument/hover") then
                safe_menu("enable", "PopUp.Hover")
            end
        end

        -- Enable URL menu if URL exists under cursor
        local ok, ui = pcall(require, "vim.ui")
        if ok and ui._get_urls then
            local urls = ui._get_urls()
            if type(urls) == "table" and urls[1] and urls[1]:match("^https?://") then
                safe_menu("enable", "PopUp.URL")
            end
        end
    end,
})
