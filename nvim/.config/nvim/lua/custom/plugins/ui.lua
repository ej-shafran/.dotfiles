-- UI/appearence-related plugins

---@type LazySpec
return {
  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "tokyonight-night"
      vim.cmd "highlight clear Folded"
    end,
  },

  -- Status line
  {
    "echasnovski/mini.statusline",
    version = "*",
    lazy = false,
    opts = {},
  },

  -- Highlighting comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
}
