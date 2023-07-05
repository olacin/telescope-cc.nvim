return function(initial_message, inputs)
    local scope = inputs.scope
    local msg = inputs.msg

    local commit_message = initial_message

    if scope ~= nil and scope ~= "" then
        commit_message = commit_message .. string.format("(%s)", scope)
    end

    commit_message = string.format("%s: %s", commit_message, msg)

    return commit_message
end
