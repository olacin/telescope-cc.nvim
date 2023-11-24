local format_commit_message = require("telescope._extensions.conventional_commits.utils.format_commit_message")

local cc_actions = {}

cc_actions.commit = function(t, inputs)
    local body = inputs.body or ""
    local footer = inputs.footer or ""

    local cmd = ""

    local commit_message = format_commit_message(t, inputs)

    if vim.g.loaded_fugitive then
        cmd = string.format(':G commit -m "%s"', commit_message)
    else
        cmd = string.format(':!git commit -m "%s"', commit_message)
    end

    if body ~= nil and body ~= "" then
        cmd = cmd .. string.format(' -m "%s"', body)
    end

    if footer ~= nil and footer ~= "" then
        cmd = cmd .. string.format(' -m "%s"', footer)
    end

    vim.cmd(cmd)
end

cc_actions.prompt = function(entry, include_extra_steps)
    local inputs = {}

    -- HACK: dressing.nvim is asynchronous which makes this "callback hell" mandatory
    -- It does not affect standard vim.ui.input.
    vim.ui.input({ prompt = "Is there a scope ? (optional) " }, function(scope)
        inputs["scope"] = scope

        vim.ui.input({ prompt = "Enter commit message: " }, function(msg)
            inputs["msg"] = msg

            if not inputs.msg then
                return
            end

            if not include_extra_steps then
                cc_actions.commit(entry.value, inputs)
                return
            end

            vim.ui.input({ prompt = "Enter the commit body: " }, function(body)
                inputs["body"] = body

                vim.ui.input({ prompt = "Enter the commit footer: " }, function(footer)
                    inputs["footer"] = footer

                    cc_actions.commit(entry.value, inputs)
                end)
            end)
        end)
    end)
end

return cc_actions
