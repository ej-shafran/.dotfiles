---@type LazySpec[]
return {
    -- {{{ Git client
    {
        "NeogitOrg/neogit",
        branch = "nightly",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "ibhagwan/fzf-lua",
            {
                "sindrets/diffview.nvim",
                cmd = { "DiffviewOpen" },
            },
        },
        config = true,
        cmd = "Neogit",
    },
    -- }}}

    -- {{{ Git view in files
    {
        "lewis6991/gitsigns.nvim",
        cmd = "Gitsigns",
        event = "BufEnter",
        opts = {
            attach_to_untracked = true,
            current_line_blame_opts = {
                delay = 0,
            },
        },
    },
    -- }}}
}

-- vim: foldmethod=marker
