local M = {}

local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local entry_display = require "telescope.pickers.entry_display"
local conf = require("telescope.config").values

local lazy = require "lazy"

local plugin_displayer = entry_display.create {
  separator = " ",
  items = {
    { remaining = true },
    { remaining = true },
  },
}

local function plugin_entry_maker(plugin)
  local result = vim.fn.split(plugin[1], "/")
  local author = result[1]
  local name = result[2]

  return {
    value = { author = author, name = name },
    ordinal = name,
    display = function()
      return plugin_displayer {
        name,
        { author, "Comment" },
      }
    end,
  }
end

function M.run(opts)
  opts = opts or {}

  local plugins = lazy.plugins()

  pickers
    .new(opts, {
      finder = finders.new_table {
        results = plugins,
        entry_maker = function(plugin)
          return plugin_entry_maker(plugin)
        end,
      },
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
