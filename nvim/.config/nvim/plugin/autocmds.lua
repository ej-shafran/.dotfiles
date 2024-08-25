-- Autocmds (see `autocmd`)

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight yanks
autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Don't fold automatically when markdown buffer is loaded
autocmd("BufWinEnter", {
  pattern = { "*.md" },
  callback = function()
    vim.wo.foldenable = false
  end,
})

-- Set local settings for terminal buffers
autocmd("TermOpen", {
  group = augroup("custom-term-open", {}),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
  end,
})

-- Custom command window settings
autocmd("User", {
  group = augroup("custom-command-window", {}),
  pattern = { "CmdbufNew" },
  callback = function(args)
    require("custom.configs.cmdbuf").setup(args.buf)
  end,
})
