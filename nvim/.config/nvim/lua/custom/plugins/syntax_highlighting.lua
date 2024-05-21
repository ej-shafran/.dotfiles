-- Syntax highlighting and other Treesitter features

---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require "custom.configs.treesitter"
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",

      {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
        opts = {
          enable = false,
        },
        cmd = { "TSContextToggle" },
      },
    },
  },
}
