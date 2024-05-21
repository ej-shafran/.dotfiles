-- Formatting code

---@type LazySpec
return {
  {
    "stevearc/conform.nvim",
    lazy = false,
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang-format" },
        typescript = { { "prettierd", "prettier" } },
        javascript = { { "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
        markdown = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        yaml = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        go = { "gofmt" },
        python = { "black" },
        kotlin = { "ktlint" },
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
