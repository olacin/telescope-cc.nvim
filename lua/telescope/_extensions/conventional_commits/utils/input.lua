return function(prompt, key, inputs)
    vim.ui.input({ prompt = prompt }, function(msg)
        inputs[key] = msg
    end)
end
