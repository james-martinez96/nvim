-- Table to keep track of active job IDs: { [job_id] = task_name }
local active_jobs = {}

local function run_project_tasks_background()
    local filepath = vim.fn.getcwd() .. "/tasks.json"

    if vim.fn.filereadable(filepath) == 0 then
        vim.notify("tasks.json not found in " .. vim.fn.getcwd(), vim.log.levels.WARN)
        return
    end

    local content = vim.fn.readfile(filepath)
    local json_str = table.concat(content, "\n")

    -- Handle potential trailing commas in JSON gracefully
    json_str = json_str:gsub(",%s*}", "}"):gsub(",%s*]", "]")

    local ok, tasks = pcall(vim.json.decode, json_str, { skip_comments = true })

    if not ok or type(tasks) ~= "table" then
        vim.notify("Failed to parse tasks.json. Ensure it is valid JSON.", vim.log.levels.ERROR)
        return
    end

    for name, task in pairs(tasks) do
        local cmd, cwd

        if type(task) == "string" then
            cmd = task
        elseif type(task) == "table" and task.cmd then
            cmd = task.cmd
            cwd = task.cwd and vim.fn.fnamemodify(task.cwd, ":p")
        end

        if cmd then
            local buf = vim.api.nvim_create_buf(true, false)
            pcall(vim.api.nvim_buf_set_name, buf, "term://" .. name)

            local job_id = nil
            vim.api.nvim_buf_call(buf, function()
                vim.opt_local.number = false
                vim.opt_local.relativenumber = false
                job_id = vim.fn.jobstart(cmd, {
                    term = true,
                    cwd = cwd,
                    -- Remove job from tracking list when it exits naturally
                    on_exit = function(_, code)
                        if job_id then
                            active_jobs[job_id] = nil
                        end
                    end,
                })
            end)

            if job_id and job_id > 0 then
                active_jobs[job_id] = name
                vim.notify("Started background task: " .. name, vim.log.levels.INFO)
            else
                vim.notify("Failed to start task: " .. name, vim.log.levels.ERROR)
            end
        else
            vim.notify("Invalid task configuration for: " .. name, vim.log.levels.WARN)
        end
    end
end

-- Function to gracefully stop all running task processes
local function stop_all_tasks()
    for job_id, name in pairs(active_jobs) do
        pcall(vim.fn.jobstop, job_id)
    end
    active_jobs = {}
end

-- Automatically terminate all tasks when Neovim exits
local augroup = vim.api.nvim_create_augroup("BackgroundTaskCleanup", { clear = true })
vim.api.nvim_create_autocmd("VimLeavePre", {
    group = augroup,
    callback = stop_all_tasks,
})

-- Register Neovim commands
vim.api.nvim_create_user_command("RunTasksBg", run_project_tasks_background, {})
vim.api.nvim_create_user_command("StopTasksBg", stop_all_tasks, {})

-- NOTE: Example:
-- tasks.json
-- {
--     "proxy-server": "python ./proxy.py",
--     "docker-app": {
--         "cmd": "docker compose up",
--         "cwd": "./backend"
--     }
-- }

