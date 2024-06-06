-- Taking notes using Orgmode

---@type LazySpec
return {
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    dependencies = {
      "akinsho/org-bullets.nvim",
      "massix/org-checkbox.nvim",
      "danilshvalov/org-modern.nvim",
    },
    config = function()
      require "custom.configs.orgmode"
    end,
  },
}
