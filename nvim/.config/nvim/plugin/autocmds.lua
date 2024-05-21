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
autocmd({ "BufWinEnter" }, {
  pattern = { "*.md" },
  callback = function()
    vim.wo.foldenable = false
  end,
})

-- Go back to original window when compiling
autocmd("FileType", {
  group = augroup("compile-mode", { clear = true }),
  pattern = "compilation",
  command = "wincmd w",
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
