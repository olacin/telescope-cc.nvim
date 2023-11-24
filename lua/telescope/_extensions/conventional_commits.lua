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

local search = function(opts)
    opts = opts or {}

    local defaults = {
        action = action,
        include_body_and_footer = include_body_and_footer,
    }

    opts = vim.tbl_extend("force", defaults, opts)
    opts = vim.tbl_extend("force", defaults, theme)

    cc_picker(opts)
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
})
