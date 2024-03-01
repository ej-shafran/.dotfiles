return {
    -- {{{ Nice keymap experience
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            disable = {
                filetypes = { "vim" },
            },
        },
    },
    -- }}}

    -- {{{ Neovim-Kitty interop
    {
        "knubie/vim-kitty-navigator",
        lazy = false,
    },

    {
        "mikesmithgh/kitty-scrollback.nvim",
        enabled = true,
        lazy = true,
        cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
        event = { "User KittyScrollbackLaunch" },
        version = "*",
        config = true,
    },
    -- }}}

    -- {{{ Zen mode
    {
        "folke/zen-mode.nvim",
        event = "VeryLazy",
        cmd = { "ZenMode" },
    },
    -- }}}
}

-- vim: foldmethod=marker
