-- Editing text well

---@type LazySpec[]
return {
  -- Better indentation options
  "tpope/vim-sleuth",

  -- Deal with word variants
  {
    "tpope/vim-abolish",
    config = function()
      require "custom.configs.abolish"
    end,
  },

  -- Swap things around
  {
    "gbprod/substitute.nvim",
    event = "VeryLazy",
    config = true,
  },

  -- Surround things
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = true,
  },

  -- Align things
  {
    "echasnovski/mini.align",
    version = "*",
    opts = {},
  },
}
