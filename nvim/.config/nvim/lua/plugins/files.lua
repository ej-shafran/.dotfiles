---@type LazySpec[]
return {
    -- {{{ File explorer
    {
        "stevearc/oil.nvim",
        lazy = false,
        opts = {
            skip_confirm_for_simple_edits = true,
            columns = {
                "permissions",
                "size",
                "mtime",
            },
            keymaps = {
                ["<C-h>"] = false,
                ["<C-l>"] = false,
                ["<C-p>"] = false,
                ["<C-r>"] = "actions.refresh",
                ["g="] = "actions.preview",
            },
        },
    },
    -- }}}

    -- {{{ Jumping between files
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            local wk = require("which-key")

            harpoon:setup()

            harpoon:extend({
                UI_CREATE = function(cx)
                    wk.register({
                        ["<C-v>"] = {
                            function()
                                harpoon.ui:select_menu_item({ vsplit = true })
                            end,
                            "Vertical Split",
                        },
                        ["<C-x>"] = {
                            function()
                                harpoon.ui:select_menu_item({ vsplit = true })
                            end,
                            "Split",
                        },
                        ["C-t>"] = {
                            function()
                                harpoon.ui:select_menu_item({ tabedit = true })
                            end,
                            "New Tab",
                        },
                    }, { buffer = cx.bufnr })
                end,
            })
        end,
    },
    -- }}}
}

-- vim: foldmethod=marker
