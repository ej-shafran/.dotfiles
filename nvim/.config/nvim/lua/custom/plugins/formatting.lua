-- Formatting code

---@type LazySpec
return {
  {
    "stevearc/conform.nvim",
    lazy = false,
    cmd = { "ConformInfo" },
    opts = {
      format_after_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        return {
          lsp_format = "fallback",
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang-format" },
        typescript = { "prettierd", "prettier" },
        javascript = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        scss = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        go = { "gofmt" },
        python = { "black" },
        kotlin = { "ktlint" },
      },
    },
  },
}
