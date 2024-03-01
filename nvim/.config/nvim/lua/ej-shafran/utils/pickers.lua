local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local lazy = require("lazy")
local conf = require("telescope.config").values
local entry_makers = require("ej-shafran.utils.entry_makers")

function M.reload_plugin(opts)
    opts = opts or {}

    local plugins = lazy.plugins()

    pickers
        .new(opts, {
            finder = finders.new_table({
                results = plugins,
                entry_maker = function(plugin)
                    return entry_makers.plugin_entry_maker(plugin)
                end,
            }),
            results_title = "Plugins",
            prompt_title = false,
            attach_mappings = function(buffer)
                actions.select_default:replace(function()
                    actions.close(buffer)
                    local selection = action_state.get_selected_entry()
                    vim.cmd("Lazy reload " .. selection.value.name)
                end)
                return true
            end,
            sorter = conf.generic_sorter(opts),
        })
        :find()
end

return M
