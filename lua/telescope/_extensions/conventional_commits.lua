local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
    error("telescope-cc.nvim requires telescope.nvim - https://github.com/nvim-telescope/telescope.nvim")
end

local cc_actions = require("telescope._extensions.conventional_commits.actions")
local cc_picker = require("telescope._extensions.conventional_commits.picker")
local cc_types = require("telescope._extensions.conventional_commits.types")

local action = cc_actions.prompt

local search = function(opts)
    opts = opts or {}

    defaults = {
        action = action,
    }

    cc_picker(vim.tbl_extend("force", defaults, opts))
end

return telescope.register_extension({
    setup = function(cfg)
        action = cfg.action or cc_actions.prompt
    end,
    exports = {
        conventional_commits = search,
    },
})
