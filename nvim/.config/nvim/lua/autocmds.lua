-- Autocmds (see :h autocmd)

-- {{{ Highlight yanks
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
-- }}}

-- {{{ Don't fold automatically when markdown buffer is loaded
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    pattern = { "*.md" },
    callback = function()
        vim.wo.foldenable = false
    end,
})
-- }}}

-- {{ Go back to original file when compiling
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("compile-mode", { clear = true }),
    pattern = "compilation",
    command = "wincmd w",
})
-- }}}

-- vim: foldmethod=marker
