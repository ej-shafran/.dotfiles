-- Dealing with comments in code files

---@type LazySpec
return {
  {
    "echasnovski/mini.comment",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has "nvim-0.10.0" == 1,
  },
}
