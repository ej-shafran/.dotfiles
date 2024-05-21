-- File explorer the Vim way

---@type LazySpec[]
return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      skip_confirm_for_simple_edits = true,
      columns = {
        "permissions",
        "size",
        "mtime",
      },
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-p>"] = false,
        ["<C-r>"] = "actions.refresh",
        ["g="] = "actions.preview",
        ["&"] = "actions.open_cmdline",
      },
      view_options = {
        show_hidden = true,
      },
    },
  },
}
