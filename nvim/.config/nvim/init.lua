-- Basic setup
vim.g.mapleader = " "
vim.g.localmapleader = " "

-- Setup lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("ej-shafran.plugins", {
    dev = {
        path = "~/plugins",
        patterns = { "ej-shafran" },
        fallback = true,
    },
    install = {
        colorscheme = { "tokyonight-night" },
    },
})

require("ej-shafran.settings")
require("ej-shafran.keymaps")
