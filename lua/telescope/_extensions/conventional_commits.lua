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

local function create_commit_message_form()
    local input = vim.fn.input("Commit message: ")
    local body = vim.fn.input("Commit body: ")
    local footer = vim.fn.input("Commit footer: ")

    local commit_message = input
    if body ~= "" then
        commit_message = commit_message .. "\n\n" .. body
    end
    if footer ~= "" then
        commit_message = commit_message .. "\n\n" .. footer
    end

    return commit_message
end

local search = function(opts)
    opts = opts or {}

    local defaults = {
        action = action,
        include_body_and_footer = include_body_and_footer,
    }

    opts = vim.tbl_extend("force", defaults, opts)
    opts = vim.tbl_extend("force", defaults, theme)

    local commit_message = create_commit_message_form()
    if commit_message then
        opts.commit_message = commit_message
        cc_picker(opts)
    end
end

return telescope.register_extension({
    setup = function(cfg)
        action = cfg.action or cc_actions.prompt
        include_body_and_footer = cfg.include_body_and_footer or false

        if cfg.theme and cfg.theme ~= "" then
            if not themes["get_" .. cfg.theme] then
                vim.notify(
                    string.format("Could not apply provided telescope theme: '%s'", cfg.theme),
                    vim.log.levels.WARN,
                    { title = "telescope-cc.nvim" }
                )
            else
                theme = themes["get_" .. cfg.theme]()
            end
        end
    end,
    exports = {
        conventional_commits = search,
    },
    health = function()
        local ok = vim.health.ok
        local warn = vim.health.warn
        local error = vim.health.error

        -- check for git installation
        if vim.fn.executable("git") == 0 then
            error("git is not installed")
        else
            ok("git is installed")
        end

        -- check for fugitive installation
        if vim.g.loaded_fugitive == nil then
            warn("fugitive.vim is not loaded")
        else
            ok("fugitive.vim is loaded")
        end
    end,
})
