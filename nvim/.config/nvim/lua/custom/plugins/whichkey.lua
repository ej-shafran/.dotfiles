-- Keymap hints

---@type LazySpec
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      local wk = require "which-key"

      wk.setup {
        disable = {
          filetypes = { "vim" },
        },
      }

      wk.add {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "files" },
        { "<leader>g", group = "git", icon = "" },
        { "<leader>h", group = "help", icon = "󰋖" },
        { "<leader>i", group = "input", icon = "" },
        { "<leader>m", group = "orgmode", icon = "" },
        { "<leader>o", group = "open", icon = "" },
        { "<leader>p", group = "plugin", icon = "" },
        { "<leader>q", group = "quit" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "toggle" },
        { "<leader>v", group = "vim", icon = "" },
        { "<leader>w", group = "window" },
        { "<leader><tab>", group = "tab" },
      }
    end,
  },
}
