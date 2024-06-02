local utils = require "custom.utils"


require("lazydev").setup {
  library = {
    vim.env.LAZY .. "/luvit-meta/library",
    vim.env.LAZY .. "/lazy.nvim"
  },
}

local servers = {
  clangd = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
      },
    },
  },
}
if utils.has_python then
  servers.pylsp = {
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = { enabled = false },
        },
      },
    },
  }
end
if utils.has_js then
  servers.tsserver = {
    treesitter = { "typescript" },
  }
  servers.eslint = {}
end
if utils.has_go then
  servers.gopls = {}
end
if utils.has_zig then
  servers.zls = {}
end

local capabilities = nil
if pcall(require, "cmp_nvim_lsp") then
  capabilities = require("cmp_nvim_lsp").default_capabilities()
end

require("mason").setup {}
require("mason-lspconfig").setup {
  ensure_installed = vim.tbl_keys(servers),
  handlers = {
    function(servername)
      local server = servers[servername] or {}

      require("lspconfig")[servername].setup {
        capabilities = capabilities,
        settings = server.settings or {},
      }
    end,
  },
}
