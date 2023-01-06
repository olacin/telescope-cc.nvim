local actions_state = require("telescope.actions.state")
local actions = require("telescope.actions")

local cc_actions = {}

cc_actions.commit = function(t, scope, msg)
    local cmd = ""
    local commit_message = t

    if scope ~= nil and scope ~= "" then
        commit_message = commit_message .. string.format("(%s)", scope)
    end
    commit_message = string.format("%s: %s", commit_message, msg)

    if vim.g.loaded_fugitive then
        cmd = string.format(':G commit -m "%s"', commit_message)
    else
        cmd = string.format(':!git commit -m "%s"', commit_message)
    end

    vim.cmd(cmd)
end

cc_actions.prompt = function(entry)
    vim.ui.input({ prompt = "Is there a scope ? (optional)" }, function(msg)
        local scope = msg
        vim.ui.input({ prompt = "Enter commit message: " }, function(msg)
            if not msg then
                return
            end
            cc_actions.commit(entry.value, scope, msg)
        end)
    end)
end

return cc_actions
