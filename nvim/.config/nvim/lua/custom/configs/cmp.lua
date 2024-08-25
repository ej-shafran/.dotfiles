local cmp = require "cmp"

cmp.setup {
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  sources = cmp.config.sources {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    {
      name = "buffer",
      option = {
        get_bufnrs = vim.api.nvim_list_bufs,
      },
    },
    { name = "path" },
  },
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-y>"] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { "i", "c" }
    ),
  },
}

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources {
    {
      name = "cmdline",
      option = {
        ignore_commands = { "Man" },
      },
    },
  },
})

cmp.setup.cmdline("@", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources {
    { name = "cmdline-prompt" },
  },
})

cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "git" },
  }, {
    { name = "buffer" },
  }),
})
require("cmp_git").setup()

cmp.setup.filetype("org", {
  sources = cmp.config.sources {
    { name = "luasnip" },
    { name = "orgmode" },
    { name = "buffer" },
    { name = "path" },
  },
})

cmp.setup.filetype({ "mysql", "sql" }, {
  sources = cmp.config.sources {
    { name = "vim-dadbod-completion" },
    { name = "buffer" },
  },
})
