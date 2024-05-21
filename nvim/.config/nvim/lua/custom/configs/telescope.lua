require("telescope").setup {
  extensions = {
    wrap_results = true,

    fzf = {},
    ["ui-select"] = {
      require("telescope.themes").get_cursor {},
    },
  },
}

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")
