local format_commit_message = require("telescope._extensions.conventional_commits.utils.format_commit_message")
local input = require("telescope._extensions.conventional_commits.utils.input")

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

    input("Is there a scope ? (optional) ", "scope", inputs)

    input("Enter commit message: ", "msg", inputs)

    if not inputs.msg then
        return
    end

    if not include_extra_steps then
        cc_actions.commit(entry.value, inputs)
        return
    end

    input("Enter the commit body: ", "body", inputs)

    input("Enter the commit footer: ", "footer", inputs)

    cc_actions.commit(entry.value, inputs)
end

return cc_actions
