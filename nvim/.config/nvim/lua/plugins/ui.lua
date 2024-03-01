---@type LazySpec[]
return {
    -- {{{ Colorscheme
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },
    -- }}}

    -- {{{ Starter screen
    {
        "echasnovski/mini.starter",
        version = "*",
        opts = {},
    },
    -- }}}

    -- {{{ Status line
    {
        "echasnovski/mini.statusline",
        version = "*",
        lazy = false,
        opts = {},
    },
    -- }}}

    -- {{{ Highlight comments
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },
    -- }}}
}

-- vim: foldmethod=marker
