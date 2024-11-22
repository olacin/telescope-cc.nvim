local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
    error("telescope-cc.nvim requires telescope.nvim - https://github.com/nvim-telescope/telescope.nvim")
end

local cc_actions = require("telescope._extensions.conventional_commits.actions")
local cc_picker = require("telescope._extensions.conventional_commits.picker")
local themes = require("telescope.themes")

local action = cc_actions.prompt
local include_body_and_footer = false
local theme = {}

local function create_commit_message_form(callback)
    local input = ""
    local body = ""
    local footer = ""

    local function on_submit()
        local commit_message = input
        if body ~= "" then
            commit_message = commit_message .. "\n\n" .. body
        end
        if footer ~= "" then
            commit_message = commit_message .. "\n\n" .. footer
        end
        callback(commit_message)
    end

    telescope.pickers
        .new({}, {
            prompt_title = "Create Commit Message",
            finder = telescope.finders.new_table({
                results = {
                    {
                        "Commit message:",
                        function(val)
                            input = val
                        end,
                    },
                    {
                        "Commit body:",
                        function(val)
                            body = val
                        end,
                    },
                    {
                        "Commit footer:",
                        function(val)
                            footer = val
                        end,
                    },
                },
                entry_maker = function(entry)
                    return {
                        value = entry[1],
                        display = entry[1],
                        ordinal = entry[1],
                        on_input = entry[2],
                    }
                end,
            }),
            sorter = telescope.config.values.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
                local function set_input()
                    local entry = telescope.actions.get_selected_entry()
                    local val = vim.fn.input(entry.value)
                    entry.on_input(val)
                    telescope.actions.close(prompt_bufnr)
                end

                map("i", "<CR>", set_input)
                map("n", "<CR>", set_input)
                return true
            end,
        })
        :find()
end

local search = function(opts)
    opts = opts or {}

    local defaults = {
        action = action,
        include_body_and_footer = include_body_and_footer,
    }

    opts = vim.tbl_extend("force", defaults, opts)
    opts = vim.tbl_extend("force", defaults, theme)

    create_commit_message_form(function(commit_message)
        if commit_message then
            opts.commit_message = commit_message
            cc_picker(opts)
        end
    end)
end
