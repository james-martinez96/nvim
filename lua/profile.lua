-- Profile a command
local start_time = vim.uv.hrtime()

vim.cmd("wincmd k")

local elapsed = (vim.uv.hrtime() - start_time) / 1e6
print("Elapsed time: " .. elapsed .. "ms")
