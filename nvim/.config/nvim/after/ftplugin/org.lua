local orgmode = require "orgmode"

local set = vim.keymap.set

set("i", "<C-q>", function()
  orgmode.action "org_mappings.meta_return"
end)
