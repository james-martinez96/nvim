vim.cmd([[
  aunmenu PopUp
  anoremenu PopUp.Inpect        <cmd>Inspect<CR>
  amenu PopUp.-1-               <NOP>
  anoremenu PopUp.Definition    <cmd>lua vim.lsp.buf.definition()<CR>
  anoremenu PopUp.Refrences     <cmd>Telescope lsp_references<CR>
  anoremenu PopUp.Back          <C-t>
  amenu PopUp.-2-               <NOP>
  amenu PopUp.URL               gx
]])

-- https://terminal.shop

local group = vim.api.nvim_create_augroup("nvim_popupmenu", { clear = true })
print(group)
vim.api.nvim_create_autocmd("MenuPopUp", {
  pattern = "*",
  group = group,
  desc = "Custom PopUp Setup",
  callback = function()
    vim.cmd([[
      amenu disable PopUp.Definition
      amenu disable PopUp.Refrences
      amenu disable PopUp.URL
    ]])
    if vim.lsp.get_clients({ bufnr = 0 })[1] then
      vim.cmd([[
        amenu enable PopUp.Definition
        amenu enable PopUp.Refrences
      ]])
    end

    -- Fix ME
    local urls = require("vim.ui")._get_urls()
    if vim.startswith(urls[1], "http") then
      vim.cmd([[amenu enable PopUp.URL]])
    end
  end,
})
