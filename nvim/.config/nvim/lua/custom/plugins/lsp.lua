-- Dealing with language servers for coding

---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/neodev.nvim",
      "williamboman/mason-lspconfig.nvim",
      "williamboman/mason.nvim",
      "j-hui/fidget.nvim",
    },
    config = function()
      require "custom.configs.lsp"
    end,
  },
}
