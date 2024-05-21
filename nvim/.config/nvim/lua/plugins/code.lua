local has_python = vim.fn.executable("python3") ~= 0 or vim.fn.executable("python") ~= 0
local has_js = vim.fn.executable("node") ~= 0
local has_go = vim.fn.executable("go") ~= 0

-- {{{ LSP Servers
local servers = {
    clangd = {},
    lua_ls = {
        settings = {
            Lua = {
                completion = {
                    callSnippet = "Replace",
                },
            },
        },
    },
}

if has_python then
    servers.pylsp = {
        settings = {
            pylsp = {
                plugins = {
                    pycodestyle = { enabled = false },
                },
            },
        },
    }
end

if has_js then
    servers.tsserver = {
        treesitter = { "typescript" },
    }
    servers.eslint = {}
end

if has_go then
    servers.gopls = {}
end

-- }}}

-- {{{ Treesitter parsers

local parsers = { "lua", "c", "markdown" }

if has_python then
    table.insert(parsers, "python")
end

if has_js then
    table.insert(parsers, "typescript")
end

if has_go then
    table.insert(parsers, "go")
    table.insert(parsers, "gomod")
    table.insert(parsers, "gosum")
end

-- }}}

---@type LazySpec[]
return {
    -- {{{ Compilation
    {
        "ej-shafran/compile-mode.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "m00qek/baleia.nvim", tag = "v1.3.0" },
        },
        event = "VeryLazy",
        cmd = { "Compile", "Recompile" },
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

    -- {{{ Formatting
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
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

    -- {{{ Comments
    {
        "echasnovski/mini.comment",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },
    -- }}}

    -- {{{ Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        main = "nvim-treesitter.configs",
        opts = {
            ensure_installed = parsers,
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
                    return {
                        ensure_installed = vim.tbl_keys(servers),
                        handlers = {
                            function(servername)
                                local server = servers[servername] or {}

                                local capabilities = require("cmp_nvim_lsp").default_capabilities()

                                require("lspconfig")[servername].setup({
                                    capabilities = capabilities,
                                    settings = server.settings or {},
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

            { "folke/neodev.nvim", opts = {} },
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
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        lazy = false,
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

            cmp.setup.filetype("org", {
                sources = {
                    { name = "orgmode" },
                    { name = "buffer" },
                    { name = "path" },
                },
            })
        end,
    },
    -- }}}
}

-- vim: foldmethod=marker
