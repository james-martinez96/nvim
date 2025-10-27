local M = {}

-- Compile the .tex file in the background
function M.compile_tex()
    local filename = vim.fn.expand("%:p")
    local dir = vim.fn.expand("%:p:h")

    -- use latexmk for continuous preview
    vim.fn.jobstart({ "latexmk", "-pdf", "-interaction=nonstopmode", "-synctex=1", filename }, {
        cwd = dir,
        -- on_stdout = function(_, data) if data then print(table.concat(data, "\n")) end end,
        on_stderr = function(_, data)
            if data then
                print(table.concat(data, "\n"))
            end
        end,
    })
end

-- Set up an autocmd to recompile on write
function M.setup()
    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.tex",
        callback = function()
            M.compile_tex()
        end,
    })
end

return M
