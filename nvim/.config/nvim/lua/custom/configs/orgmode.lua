local orgmode = require "orgmode"
local Menu = require "org-modern.menu"
local bullets = require "org-bullets"
local checkbox = require "orgcheckbox"

checkbox.setup { lhs = "<leader>mC" }
bullets.setup()
orgmode.setup {
  org_agenda_files = "~/org/**/*",
  org_default_notes_file = "~/org/refile.org",
  mappings = {
    prefix = "<leader>m",
  },
  ui = {
    menu = {
      handler = function(data)
        Menu:new({
          window = {
            margin = { 1, 0, 1, 0 },
            padding = { 0, 1, 0, 1 },
            title_pos = "center",
            border = "single",
            zindex = 1000,
          },
          icons = {
            separator = "➜",
          },
        }):open(data)
      end,
    },
  },
}
