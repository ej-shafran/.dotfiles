-- Setup leader key
vim.g.mapleader = " "
vim.g.localmapleader = " "

-- Setup lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ import = "custom/plugins" }, {
  dev = {
    path = "~/plugins",
    patterns = { "ej-shafran" },
    fallback = true,
  },
  install = {
    colorscheme = { "tokyonight-night" },
  },
  change_detection = {
    notify = false,
  },
})
