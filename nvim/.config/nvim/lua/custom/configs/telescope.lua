local telescope = require "telescope"

telescope.setup {
  extensions = {
    wrap_results = true,

    fzf = {},
    ["ui-select"] = {
      require("telescope.themes").get_cursor {},
    },
  },
}

pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "ui-select")
telescope.load_extension "import"
