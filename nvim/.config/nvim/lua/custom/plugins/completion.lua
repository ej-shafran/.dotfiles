-- Autocomplete and snippets

---@type LazySpec
return {
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    priority = 100,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "teramako/cmp-cmdline-prompt.nvim",
      "hrsh7th/cmp-buffer",
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        config = function()
          require "custom.configs.snippets"
        end,
      },
      "saadparwaiz1/cmp_luasnip",
      "petertriho/cmp-git",
    },
    config = function()
      require "custom.configs.cmp"
    end,
  },
}
