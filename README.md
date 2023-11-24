# telescope-cc.nvim

A Telescope integration of [Conventional Commits](https://www.conventionalcommits.org/).

![demo](./demo.gif)

## Installation

```
# vim-plug
Plug 'olacin/telescope-cc.nvim'

# packer
use 'olacin/telescope-cc.nvim'

# lazy.nvim
{ "olacin/telescope-cc.nvim" }
```

## Usage

```
# As a command
:Telescope conventional_commits

# As a lua function
require('telescope').extensions.conventional_commits.conventional_commits()
```

## Configuration

You can customize action on selection within Telescope `setup()` function.

```lua
telescope.setup({
    ...
    extensions = {
        conventional_commits = {
            theme = "ivy", -- custom theme
            action = function(entry)
                -- entry = {
                --     display = "feat       A new feature",
                --     index = 7,
                --     ordinal = "feat",
                --     value = feat"
                -- }
                vim.print(entry)
            include_body_and_footer = true, -- Add prompts for commit body and footer
            end,
        },
    },
})

telescope.load_extension("conventional_commits")
```

### Default action

Default action is `cc_actions.commit` and can be found [here](https://github.com/olacin/telescope-cc.nvim/blob/main/lua/telescope/_extensions/conventional_commits/actions.lua).

### Include body and footer

The easiest way is to add `include_body_and_footer` within telescope setup like shown above.

If however you wish to do something more advanced, you can create a command to initiate the extension with the `include_body_and_footer` flag.

```lua
local function create_conventional_commit()
    local actions = require("telescope._extensions.conventional_commits.actions")
    local picker = require("telescope._extensions.conventional_commits.picker")
    local themes = require("telescope.themes")

    -- if you use the picker directly you have to provide your theme manually
    picker({
        action = actions.prompt,
        include_body_and_footer = true,
        -- theme = themes["get_ivy"]() -- ivy theme
    })
end

vim.keymap.set(
  "n",
  "cc",
  create_conventional_commit,
  { desc = "Create conventional commit" }
)
```
