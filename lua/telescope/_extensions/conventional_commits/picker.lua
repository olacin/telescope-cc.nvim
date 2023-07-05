local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values

local cc_types = require("telescope._extensions.conventional_commits.types")

local picker = function(opts)
    opts = opts or {}

    pickers
        .new(opts, {
            prompt_title = "Conventional Commits",
            finder = finders.new_table({
                results = cc_types,
                entry_maker = function(entry)
                    return {
                        value = entry.value,
                        display = string.format("%-10s %s", entry.value, entry.description),
                        ordinal = entry.value,
                    }
                end,
            }),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    local entry = actions_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    opts.action(entry, opts.include_body_and_footer)
                end)
                return true
            end,
        })
        :find()
end

return picker
