return {
    -- {{{ Starter screen
    {
        "echasnovski/mini.starter",
        version = "*",
        opts = {},
    },
    -- }}}

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

    -- {{{ Lua development for Neovim
    "folke/neodev.nvim",
    -- }}}

    -- {{{ Nice keymap experience
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {},
    },
    -- }}}

    -- {{{ Better indentation options
    "tpope/vim-sleuth",
    -- }}}

    -- {{{ Dealing with word variants
    "tpope/vim-abolish",
    -- }}}

    -- {{{ Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        event = "VeryLazy",
        cmd = "Telescope",
        config = function()
            local entry_makers = require("ej-shafran.utils.entry_makers")

            local file_theme = {
                theme = "dropdown",
                layout_config = {
                    height = 12,
                    width = 0.5,
                    anchor = "N",
                },
                previewer = false,
            }

            require("telescope").setup({
                pickers = {
                    buffers = file_theme,
                    find_files = vim.tbl_extend("force", file_theme, { entry_maker = entry_makers.file_entry_maker }),
                    oldfiles = vim.tbl_extend("force", file_theme, { entry_maker = entry_makers.file_entry_maker }),
                    git_files = vim.tbl_extend("force", file_theme, { entry_maker = entry_makers.file_entry_maker }),
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_cursor({}),
                    },
                },
            })

            require("telescope").load_extension("ui-select")
        end,
    },
    -- }}}

    -- {{{ Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        -- main = "nvim-treesitter.configs",
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
        opts = {
            ensure_installed = { "lua", "markdown", "typescript", "python" },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = {},
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    include_surrounding_whitespace = true,
                    keymaps = {
                        -- General
                        ["af"] = { query = "@function.outer", desc = "function" },
                        ["if"] = { query = "@function.inner", desc = "function" },
                        ["ac"] = { query = "@class.outer", desc = "class" },
                        ["ic"] = { query = "@class.inner", desc = "class" },

                        -- JSX specific
                        ["aa"] = { query = "@jsx_attr", desc = "JSX attribute" },
                    },
                },
            },
        },
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            {
                "nvim-treesitter/nvim-treesitter-context",
                event = "VeryLazy",
                opts = {
                    enable = false,
                },
                cmd = { "TSContextToggle" },
                keys = {
                    {
                        "<leader>tc",
                        "<cmd>TSContextToggle<cr>",
                        desc = "Code Context",
                    },
                },
            },
        },
    },
    -- }}}

    -- {{{ LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "williamboman/mason-lspconfig.nvim",
                opts = function()
                    local function on_attach(_, buffer)
                        local wk = require("which-key")

                        wk.register({
                            ["<leader>c"] = {
                                a = { vim.lsp.buf.code_action, "Code Action" },
                                d = { "<cmd>Telescope lsp_definitions<cr>", "Find Definition" },
                                i = { "<cmd>Telescope lsp_implementations<cr>", "Find Implementation" },
                                j = { "<cmd>Telescope lsp_document_symbols<cr>", "Jump To Symbol" },
                                r = { vim.lsp.buf.rename, "LSP Rename" },
                                x = { "<cmd>Telescope diagnostics<cr>", "List Errors" },
                                D = { "<cmd>Telescope lsp_references<cr>", "Jump To References" },
                                J = {
                                    "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
                                    "Jump To Symbol In Any Workspace",
                                },
                            },
                            ["K"] = { vim.lsp.buf.hover, "Hover Documentation" },
                            ["gd"] = { vim.lsp.buf.definition, "Goto Definition" },
                            ["[d"] = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
                            ["]d"] = { vim.diagnostic.goto_next, "Next Diagnostic" },
                        }, { buffer = buffer })
                    end

                    return {
                        ensure_installed = { "lua_ls", "tsserver", "pylsp" },
                        handlers = {
                            function(servername)
                                local capabilities = require("cmp_nvim_lsp").default_capabilities()

                                require("lspconfig")[servername].setup({
                                    capabilities = capabilities,
                                    on_attach = on_attach,
                                })
                            end,
                            ["pylsp"] = function()
                                local capabilities = require("cmp_nvim_lsp").default_capabilities()

                                require("lspconfig").pylsp.setup({
                                    capabilities = capabilities,
                                    on_attach = on_attach,
                                    settings = {
                                        pylsp = {
                                            plugins = {
                                                pycodestyle = { enabled = false },
                                            },
                                        },
                                    },
                                })
                            end,
                        },
                    }
                end,
                dependencies = {
                    {
                        "williamboman/mason.nvim",
                        opts = {},
                    },
                    {
                        "folke/neodev.nvim",
                        opts = {},
                    },
                    {
                        "j-hui/fidget.nvim",
                        opts = {},
                    },
                },
            },
        },
    },
    -- }}}

    -- {{{ Completion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            {
                "L3MON4D3/LuaSnip",
                config = function()
                    local ls = require("luasnip")
                    local s = ls.snippet
                    -- local sn = ls.snippet_node
                    -- local isn = ls.indent_snippet_node
                    local t = ls.text_node
                    local i = ls.insert_node
                    local f = ls.function_node
                    -- local c = ls.choice_node
                    -- local d = ls.dynamic_node
                    -- local r = ls.restore_node
                    -- local events = require("luasnip.util.events")
                    local ai = require("luasnip.nodes.absolute_indexer")
                    local extras = require("luasnip.extras")
                    local l = extras.lambda
                    -- local rep = extras.rep
                    -- local p = extras.partial
                    -- local m = extras.match
                    -- local n = extras.nonempty
                    -- local dl = extras.dynamic_lambda
                    -- local fmt = require("luasnip.extras.fmt").fmt
                    -- local fmta = require("luasnip.extras.fmt").fmta
                    -- local conds = require("luasnip.extras.expand_conditions")
                    local postfix = require("luasnip.extras.postfix").postfix
                    -- local types = require("luasnip.util.types")
                    -- local parse = require("luasnip.util.parser").parse_snippet
                    -- local ms = ls.multi_snippet
                    -- local k = require("luasnip.nodes.key_indexer").new_key

                    ls.add_snippets("c", {
                        s("header", {
                            f(function()
                                local header_name = vim.fn.expand("%:t:r")
                                local header_id = "_" .. string.upper(header_name) .. "_H"

                                return { "#ifndef " .. header_id, "#define " .. header_id, "", "" }
                            end),
                            i(0),
                            f(function()
                                local header_name = vim.fn.expand("%:t:r")
                                local header_id = "_" .. string.upper(header_name) .. "_H"

                                return { "", "", "#endif // " .. header_id }
                            end),
                        }),
                        postfix(".cpy!", {
                            i(1, "void *dest"),
                            t(" = memcpy("),
                            f(function(args)
                                return args[1][1]
                            end, { ai[1] }),
                            l(", " .. l.POSTFIX_MATCH .. ", "),
                            i(2, "size_t size"),
                            t(")"),
                        }),
                        postfix(".realloc!", {
                            l(l.POSTFIX_MATCH .. " = realloc(" .. l.POSTFIX_MATCH .. ", "),
                            i(1, "size_t size"),
                            t(")"),
                        }),
                        postfix(".free!", {
                            l("free(" .. l.POSTFIX_MATCH .. ")"),
                        }),
                    })
                end,
            },
            "saadparwaiz1/cmp_luasnip",
        },
        lazy = false,
        keys = {
            {
                "<C-n>",
                function()
                    require("cmp").complete()
                end,
                mode = "i",
                desc = "Autocomplete",
            },
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            luasnip.config.setup({})

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-2),
                    ["<C-d>"] = cmp.mapping.scroll_docs(2),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-y>"] = cmp.mapping.confirm({
                        select = true,
                    }),
                    ["<C-l>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<C-h>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                }),
            })

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "buffer" },
                }),
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "cmdline" },
                }),
            })
        end,
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

    -- {{{ Formatting
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                -- Customize or remove this keymap to your liking
                "<leader>cf",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                desc = "Format",
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                c = { "clang-format" },
                typescript = { { "prettierd", "prettier" } },
                javascript = { { "prettierd", "prettier" } },
                css = { { "prettierd", "prettier" } },
                markdown = { { "prettierd", "prettier" } },
                json = { { "prettierd", "prettier" } },
                yaml = { { "prettierd", "prettier" } },
                typescriptreact = { { "prettierd", "prettier" } },
                go = { "gofmt" },
                python = { "black" },
                kotlin = { "ktlint" },
            },
        },
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },

    -- }}}

    -- {{{ Git client for Neovim
    {
        "NeogitOrg/neogit",
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
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
            { "<leader>gf", "<cmd>Neogit kind=floating<cr>", desc = "Neogit (Floating)" },
        },
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
        keys = {
            { "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Git Blame" },
            {
                "[c",
                function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        require("gitsigns").prev_hunk()
                    end)
                    return "<Ignore>"
                end,
                desc = "Previous Hunk",
            },
            {
                "]c",
                function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        require("gitsigns").next_hunk()
                    end)
                    return "<Ignore>"
                end,
                desc = "Next Hunk",
            },
            { "<leader>gh", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk" },
        },
    },
    -- }}}

    -- {{{ Comments
    {
        "echasnovski/mini.comment",
        version = "*",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "gc", mode = { "n", "x" }, desc = "Comment" },
        },
    },
    -- }}}

    -- {{{ Swap things around
    {
        "gbprod/substitute.nvim",
        event = "VeryLazy",
        config = true,
        keys = {
            {
                "X",
                function()
                    require("substitute.exchange").visual()
                end,
                mode = "x",
                desc = "Substitute",
            },
            {
                "cx",
                function()
                    require("substitute.exchange").operator()
                end,
                desc = "Substitute",
            },
        },
    },
    -- }}}

    -- {{{ Surround things
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = true,
    },
    -- }}}

    -- {{{ Align things
    {
        "echasnovski/mini.align",
        version = "*",
        opts = {},
    },
    -- }}}

    -- {{{ Neovim-Kitty interop
    {
        "knubie/vim-kitty-navigator",
        lazy = false,
        keys = {
            { "<C-h>", "<cmd>KittyNavigateLeft<cr>", desc = "Move Window Left" },
            { "<C-j>", "<cmd>KittyNavigateDown<cr>", desc = "Move Window Down" },
            { "<C-k>", "<cmd>KittyNavigateUp<cr>", desc = "Move Window Up" },
            { "<C-l>", "<cmd>KittyNavigateRight<cr>", desc = "Move Window Right" },
        },
    },

    {
        "mikesmithgh/kitty-scrollback.nvim",
        enabled = true,
        lazy = true,
        cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
        event = { "User KittyScrollbackLaunch" },
        version = "*",
        config = function()
            require("kitty-scrollback").setup()
        end,
    },
    -- }}}

    -- {{{ Compilation
    {
        "ej-shafran/compile-mode.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "m00qek/baleia.nvim", tag = "v1.3.0" },
        },
        event = "VeryLazy",
        cmd = { "Compile", "Recompile" },
        keys = {
            { "<leader>cc", "<cmd>belowright vertical Compile<cr>", desc = "Compile" },
            { "<leader>cC", "<cmd>belowright vertical Recompile<cr>", desc = "Recompile" },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "compilation",
                command = "wincmd w",
            })
        end,
        opts = {
            same_window_errors = true,
            default_command = "",
            error_regexp_table = {
                nodejs = {
                    regex = "^\\s\\+at .\\+ (\\(\\/.\\+\\):\\([1-9][0-9]*\\):\\([1-9][0-9]*\\))$",
                    filename = 1,
                    row = 2,
                    col = 3,
                },
                typescript = {
                    regex = "^\\(.\\+\\)(\\([1-9][0-9]*\\),\\([1-9][0-9]*\\)): error TS[1-9][0-9]*:",
                    filename = 1,
                    row = 2,
                    col = 3,
                },
                gradlew = {
                    regex = "^e:\\s\\+file://\\(.\\+\\):\\(\\d\\+\\):\\(\\d\\+\\) ",
                    filename = 1,
                    row = 2,
                    col = 3,
                },
            },
        },
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

    -- {{{ Zen mode
    {
        "folke/zen-mode.nvim",
        event = "VeryLazy",
        cmd = { "ZenMode" },
        keys = {
            {
                "<leader>tz",
                "<cmd>ZenMode<cr>",
                desc = "Zen Mode",
            },
        },
    },
    -- }}}
}

-- vim: foldmethod=marker
