-- Taking notes using Orgmode

---@type LazySpec
return {
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    opts = {
      org_agenda_files = "~/org/**/*",
      org_default_notes_file = "~/org/refile.org",
      mappings = {
        prefix = "<leader>m",
      },
    },
    init = function()
      vim.keymap.set("i", "<C-q>", function()
        require("orgmode").action "org_mappings.meta_return"
      end)
    end,
  },
}
