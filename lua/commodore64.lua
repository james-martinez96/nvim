-- Commodore 64 Development
local vice_job_id = nil

-- Compile and Run C64 assembly directly in VICE
-- vim.keymap.set("n", "<leader>r", function()
--     -- Save the current file first
--     vim.cmd("write")
--
--     local file = vim.fn.expand("%:p") -- Full path to current .c64 file
--     local output = vim.fn.expand("%:p:r") .. ".prg" -- Output Commodore .prg binary
--
--     -- Standard ACME compilation command
--     local compile_cmd = { "acme", "-f", "cbm", "-o", output, file }
--     local result = vim.fn.system(compile_cmd)
--
--     if vim.v.shell_error ~= 0 then
--         -- Print compilation error directly to the Neovim echo area
--         print("Compilation Failed:\n" .. result)
--     else
--         print("Compilation successful! Launching VICE...")
--
--         -- If an old instance of VICE is still running from a previous build, close it
--         if vice_job_id then
--             vim.fn.jobstop(vice_job_id)
--         end
--
--         -- Launch x64sc detached in the background with the compiled program
--         vice_job_id = vim.fn.jobstart({ "x64sc", "+confirmonexit", output }, { detach = true })
--     end
-- end, { desc = "Compile .c64 and run in VICE" })

-- Compile and Run C64 assembly directly in vice with labels
vim.keymap.set("n", "<leader>rv", function()
    vim.cmd("write")

    local file = vim.fn.expand("%:p")
    local base_path = vim.fn.expand("%:p:r")
    local output = base_path .. ".prg"
    local labels = base_path .. ".vic"

    -- Use vim.fn.systemlist with a table instead of string.format to auto-escape spaces safely
    local compile_cmd = { "acme", "-f", "cbm", "--vicelabels", labels, "-o", output, file }
    local result = vim.fn.system(compile_cmd)

    if vim.v.shell_error ~= 0 then
        -- Just use result directly since it's already a string!
        print("Compilation Failed:\n" .. result)
    else
        print("Compilation successful! Launching VICE with labels...")

        -- Kill the previous instance if it's still running so you don't stack windows
        if vice_job_id then
            vim.fn.jobstop(vice_job_id)
        end

        -- Launch and save the job ID
        vice_job_id = vim.fn.jobstart({ "x64sc", "+confirmonexit", "-moncommands", labels, output }, { detach = true })
    end
end, { desc = "Compile .c64 with VICE labels and run" })

-- Helper function to safely output text into a dedicated scratch buffer
local function display_in_buffer(text)
    local buf_name = "*VICE Monitor*"
    local buf = vim.fn.bufnr(buf_name)

    -- If the buffer doesn't exist, create it (not listed, scratch buffer)
    if buf == -1 then
        buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_name(buf, buf_name)
    end

    -- Set options so it's a transient, read-only scratchpad
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
    vim.api.nvim_set_option_value("bufhidden", "hide", { buf = buf })
    vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
    vim.api.nvim_set_option_value("filetype", "text", { buf = buf })

    -- Split text into lines
    local lines = {}
    for line in string.gmatch(text .. "\n", "(.-)\r?\n") do
        table.insert(lines, line)
    end

    -- Inject text into the buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- If the buffer isn't currently visible in any window, open a split
    local win = vim.fn.bufwinid(buf)
    if win == -1 then
        vim.cmd("botright horizontal split")
        win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, buf)
        -- Set a reasonable default height for the split
        vim.api.nvim_win_set_height(win, 12)
    end

    -- Auto-scroll the window to the bottom to see fresh execution steps
    vim.api.nvim_win_set_cursor(win, { #lines, 0 })
end

-- Vice monitor with buffer capture
local function send_to_vice(command)
    if not command or command == "" then
        return
    end

    local client = vim.uv.new_tcp()
    if not client then
        vim.schedule(function()
            print("Error: Failed to initialize TCP handle")
        end)
        return
    end

    local response_chunks = {}

    client:connect("127.0.0.1", 6510, function(connect_err)
        if connect_err then
            vim.schedule(function()
                print("Failed to connect to VICE: " .. tostring(connect_err))
            end)
            if not client:is_closing() then
                client:close()
            end
            return
        end

        if client:is_closing() then
            return
        end

        client:read_start(function(read_err, data)
            if read_err then
                if not client:is_closing() then
                    client:close()
                end
                return
            end

            if data then
                table.insert(response_chunks, data)
            else
                client:read_stop()
                if not client:is_closing() then
                    client:close()
                end

                local final_output = table.concat(response_chunks)

                -- Strip binary protocol junk (keep tabs, newlines, carriage returns)
                final_output = final_output:gsub("[%c]", function(c)
                    return (c == "\n" or c == "\r" or c == "\t") and c or ""
                end)

                -- Safely pipe text into our buffer on the main loop thread
                vim.schedule(function()
                    if final_output ~= "" then
                        display_in_buffer(final_output)
                    else
                        print("Command sent (No output returned)")
                    end
                end)
            end
        end)

        client:write(command .. "\n", function(write_err)
            if write_err then
                if not client:is_closing() then
                    client:close()
                end
                return
            end

            if not client:is_closing() then
                client:shutdown()
            end
        end)
    end)
end

-- Send a raw binary packet to force-pause the running emulator
-- local function force_pause_vice()
--     local client = vim.uv.new_tcp()
--     if not client then return end
--
--     client:connect("127.0.0.1", 6510, function(err)
--         if err then
--             if not client:is_closing() then client:close() end
--             return
--         end
--
--         -- VICE Binary Protocol Remote Monitor Header for a "Pause" request:
--         -- Packet Structure: 
--         -- [0x02] (Header Magic)
--         -- [0x02] (API Version)
--         -- [0x00, 0x00, 0x00, 0x00] (Body Length: 0 bytes)
--         -- [0x01, 0x00, 0x00, 0x00] (Request ID: 1)
--         -- [0x01] (Command ID: 0x01 is the binary code for PAUSE)
--         -- [0x00] (Resource ID / Padding)
--         local pause_packet = string.char(0x02, 0x02, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00)
--
--         if not client:is_closing() then
--             client:write(pause_packet, function()
--                 -- Keep the socket open for a split second to let VICE transition states, then close
--                 vim.defer_fn(function()
--                     if not client:is_closing() then client:close() end
--                 end, 50)
--             end)
--         end
--     end)
-- end
--
-- -- 1. Use this when the game is RUNNING to freeze it and open the monitor
-- vim.api.nvim_create_user_command("VicePause", function()
--     force_pause_vice()
--     -- Automatically trigger a register read right after to populate your buffer
--     vim.defer_fn(function()
--         vim.cmd("Vice r")
--     end, 100)
-- end, {})

-- Safely wrap the user command
-- Example: Vice d .start
-- must be enable in vice Settings
-- Setting -> Host -> Monitor -> Enable remote monitor
vim.api.nvim_create_user_command("Vice", function(opts)
    local cmd = (opts.args and opts.args ~= "") and opts.args or "r"
    send_to_vice(cmd)
end, { nargs = "?" })
