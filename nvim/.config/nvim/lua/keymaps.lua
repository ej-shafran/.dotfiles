local wk = require("which-key")

-- {{{ Basic
wk.register({
    ["<Esc>"] = { "<Esc>:noh<CR>", "which_key_ignore" },
    ["<C-w>h"] = { "<cmd>KittyNavigateLeft<cr>", "Move Window Left" },
    ["<C-w>j"] = { "<cmd>KittyNavigateDown<cr>", "Move Window Down" },
    ["<C-w>k"] = { "<cmd>KittyNavigateUp<cr>", "Move Window Up" },
    ["<C-w>l"] = { "<cmd>KittyNavigateRight<cr>", "Move Window Right" },
    ["cx"] = { require("substitute.exchange").operator, "Substitute" },
})

wk.register({
    ["<C-n>"] = { require("cmp").complete, "Autocomplete" },
}, { mode = "i" })

wk.register({
    gc = "Comment",
}, { mode = { "n", "x" } })

wk.register({
    J = { ":m '>+1<CR>gv=gv", "Move selection down" },
    K = { ":m '<-2<CR>gv=gv", "Move selection up" },
    X = { require("substitute.exchange").visual, "Substitute" },
}, { mode = "x" })

wk.register({
    ["<Esc><Esc>"] = { "<C-\\><C-n>", "Exit Terminal Mode" },
}, { mode = "t" })

-- }}}

-- {{{ Buffers
wk.register({
    ["<leader>b"] = {
        name = "buffer",
        b = { "<cmd>Telescope buffers<cr>", "Browse Buffers" },
        l = { "<cmd>blast<cr>", "Last Buffer" },
        n = { "<cmd>enew<cr>", "New Buffer" },
        o = {
            function()
                local buffer = vim.api.nvim_get_current_buf()
                local bufinfos = vim.fn.getbufinfo({ bufloaded = true, buflisted = true }) --[[@as table]]
                local count = 0
                for _, bufinfo in ipairs(bufinfos) do
                    if bufinfo.bufnr ~= buffer then
                        count = count + 1
                        vim.api.nvim_buf_delete(bufinfo.bufnr, {})
                    end
                end

                vim.notify(count .. " buffer" .. (count == 1 and "" or "s") .. " deleted")
            end,
            "Kill Other Buffers",
        },
        q = { "<cmd>bd|blast<cr>", "Delete Buffer" },
        Q = { "<cmd>bd!|blast<cr>", "Kill Buffer" },
    },
    ["[b"] = { "<cmd>bp<cr>", "Previous Buffer" },
    ["]b"] = { "<cmd>bn<cr>", "Next Buffer" },
})
-- }}}

-- {{{ Code
wk.register({
    ["<leader>c"] = {
        name = "code",
        c = { "<cmd>belowright vertical Compile<cr>", "Compile" },
        C = { "<cmd>belowright vertical Recompile<cr>", "Recompile" },
        f = {
            function()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            "Format",
        },
        e = { "<cmd>so<cr>", "Evaluate Buffer" },
        q = { "<cmd>Telescope quickfix<cr>", "Browse Quickfix List" },
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
    ["gd"] = { "<cmd>Telescope lsp_definitions<cr>", "Goto Definition" },
    ["[d"] = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
    ["]d"] = { vim.diagnostic.goto_next, "Next Diagnostic" },
    ["[e"] = { "<cmd>PrevError<cr>", "Previous Error" },
    ["]e"] = { "<cmd>NextError<cr>", "Next Error" },
    ["[q"] = { "<cmd>cp<cr>", "Previous Quickfix" },
    ["]q"] = { "<cmd>cn<cr>", "Next Quickfix" },
})
-- }}}

-- {{{ Docker

wk.register({
    ["<leader>d"] = {
        name = "docker",
        i = { "<cmd>DockerImages<cr>", "Attach to Docker Image" },
    },
})

-- }}}

-- {{{ Files
wk.register({
    ["<leader>f"] = {
        name = "file",
        ["1"] = {
            function()
                require("harpoon"):list():select(1)
            end,
            "🎣 1st File",
        },
        ["2"] = {
            function()
                require("harpoon"):list():select(2)
            end,
            "🎣 2nd File",
        },
        ["3"] = {
            function()
                require("harpoon"):list():select(3)
            end,
            "🎣 3rd File",
        },
        ["4"] = {
            function()
                require("harpoon"):list():select(4)
            end,
            "🎣 4th File",
        },
        a = {
            function()
                require("harpoon"):list():add()
            end,
            "🎣 Add File",
        },
        h = {
            function()
                local harpoon = require("harpoon")
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            "🎣 Harpooned Files",
        },
        f = { "<cmd>Telescope find_files<cr>", "Find Files" },
        g = { "<cmd>Telescope git_files<cr>", "Find Git Files" },
        r = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
    },
    ["[h"] = {
        function()
            require("harpoon"):list():prev()
        end,
        "🎣 Previous",
    },
    ["]h"] = {
        function()
            require("harpoon"):list():next()
        end,
        "🎣 Previous",
    },
})
-- }}}

-- {{{ Git
wk.register({
    ["<leader>g"] = {
        name = "git",
        b = { "<cmd>Telescope git_branches<cr>", "Choose Branch" },
        d = { "<cmd>DiffviewOpen<cr>", "Diff/Merge View" },
        c = { "<cmd>Telescope git_commits<cr>", "Choose Commit" },
        f = { "<cmd>Neogit kind=floating<cr>", "Neogit (Floating)" },
        g = { "<cmd>Neogit<cr>", "Neogit" },
        h = { "<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk" },
        s = { "<cmd>Telescope git_status<cr>", "Browse Status" },
    },
    ["[c"] = {
        function()
            if vim.wo.diff then
                return "[c"
            end
            vim.schedule(function()
                require("gitsigns").prev_hunk()
            end)
            return "<Ignore>"
        end,
        "Previous Hunk",
    },
    ["]c"] = {
        function()
            if vim.wo.diff then
                return "]c"
            end
            vim.schedule(function()
                require("gitsigns").next_hunk()
            end)
            return "<Ignore>"
        end,
        "Next Hunk",
    },
})
-- }}}

-- {{{ Help
wk.register({
    ["<leader>h"] = {
        name = "help",
        f = { "<cmd>Telescope help_tags<cr>", "Find Help" },
        m = { "<cmd>Telescope man_pages<cr>", "Open Man Page" },
        k = { "<cmd>Telescope keymaps<cr>", "Browse Keymaps" },
    },
})
-- }}}

-- {{{ Input
wk.register({
    ["<leader>i"] = {
        name = "input",
        a = { "a <esc>", "Space After" },
        i = { "i <esc>", "Space Before" },
        o = { "o<esc>", "New Line Down" },
        O = { "O<esc>", "New Line Up" },
    },
})
-- }}}

-- {{{ Orgmode
wk.register({
    ["<leader>m"] = {
        name = "orgmode",
    },
})
-- }}}

-- {{{ Open
wk.register({
    ["<leader>o"] = {
        name = "open",
        ["-"] = { "<cmd>Oil<cr>", "Open File Explorer" },
        t = { "<cmd>InspectTree<cr>", "Open Treesitter Tree" },
        q = { "<cmd>EditQuery<cr>", "Open Treesitter Query Editor" },
    },
})
-- }}}

-- {{{ Plugins
wk.register({
    ["<leader>p"] = {
        name = "plugins",
        p = { "<cmd>Lazy<cr>", "Open Plugin Manager" },
        s = { "<cmd>Lazy sync<cr>", "Sync Plugins" },
        r = { "<cmd>LazyReloadPlugin<cr>", "Reload Plugin" },
    },
})
-- }}}

-- {{{ Quit
wk.register({
    ["<leader>q"] = {
        name = "quit",
        q = { "<cmd>qa<cr>", "Quit Neovim" },
        Q = { "<cmd>qa!<cr>", "Quit Forcefully" },
    },
})
-- }}}

-- {{{ Search
wk.register({
    ["<leader>s"] = {
        name = "search",
        d = { "<cmd>Telescope live_grep<cr>", "Search Current Directory" },
        b = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Search Buffer" },
        r = { "<cmd>Telescope resume<cr>", "Resume Last Search" },
        s = { "<cmd>Telescope grep_string<cr>", "Search Workspace For Text At Cursor" },
        h = { "<cmd>Telescope search_history<cr>", "Rerun Search From History" },
    },
})
-- }}}

-- {{{ Toggle
wk.register({
    ["<leader>t"] = {
        name = "toggle",
        b = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Git Blame" },
        c = { "<cmd>TSContextToggle<cr>", "Code Context" },
        l = { "<cmd>set number! relativenumber!<cr>", "Line Numbers" },
        s = { "<cmd>set spell!<cr>", "Spell Checking" },
        p = { "<cmd>set paste!<cr>", "Paste Handling" },
        j = { "<cmd>set scrollbind!<cr>", "Scroll Binding" },
        z = { "<cmd>ZenMode<cr>", "Zen Mode" },
    },
})
-- }}}

-- {{{ Vim
wk.register({
    ["<leader>v"] = {
        name = "vim",
        a = { "<cmd>Telescope autocommands<cr>", "Browse Autocomands" },
        c = { "<cmd>Telescope commands<cr>", "Choose Command" },
        f = { "<cmd>Telescope filetypes<cr>", "Browse File Types" },
        h = { "<cmd>Telescope highlights<cr>", "Browse Highlights" },
        j = { "<cmd>Telescope jumplist<cr>", "Browse Jumplist" },
        l = { "<cmd>Telescope loclist<cr>", "Browse Location List" },
        m = { "<cmd>Telescope marks<cr>", "Browse Marks" },
        o = { "<cmd>Telescope vim_options<cr>", "Browse Vim Options" },
        q = { "<cmd>Telescope quickfixhistory<cr>", "Browse Quickfix History" },
        r = { "<cmd>Telescope registers<cr>", "Browse Register" },
        s = { "<cmd>Telescope search_history<cr>", "Browse Search History" },
        t = { "<cmd>Telescope colorscheme<cr>", "Browse Themes" },
    },
})
-- }}}

-- {{{ Windows
wk.register({
    ["<leader>w"] = {
        name = "window",
        s = { "<C-w>s", "Split window" },
        v = { "<C-w>v", "Split window vertically" },
        w = { "<C-w>w", "Switch windows" },
        q = { "<C-w>q", "Quit a window" },
        o = { "<C-w>o", "Close all other windows" },
        T = { "<C-w>T", "Break out into a new tab" },
        x = { "<C-w>x", "Swap current with next" },
        ["-"] = { "<C-w>-", "Decrease height" },
        ["+"] = { "<C-w>+", "Increase height" },
        ["<lt>"] = { "<C-w><lt>", "Decrease width" },
        [">"] = { "<C-w>>", "Increase width" },
        ["|"] = { "<C-w>|", "Max out the width" },
        ["_"] = { "<C-w>_", "Max out the height" },
        ["="] = { "<C-w>=", "Equally high and wide" },
        h = { "<C-w>h", "Go to the left window" },
        l = { "<C-w>l", "Go to the right window" },
        k = { "<C-w>k", "Go to the up window" },
        j = { "<C-w>j", "Go to the down window" },
    },
})
-- }}}

-- {{{ Tabs
wk.register({
    ["<leader><tab>"] = {
        name = "tab",
        ["<tab>"] = { "<cmd>tabs<cr>", "Browse Tabs" },
        l = { "<cmd>tablast<cr>", "Last Tab" },
        n = { "<cmd>tabnew<cr>", "New Tab" },
        o = { "<cmd>tabonly<cr>", "Kill Other Tabs" },
        q = { "<cmd>tabclose<cr>", "Delete Tab" },
        Q = { "<cmd>tabclose!<cr>", "Kill Tab" },
    },
    ["[<tab>"] = { "<cmd>tabprevious<cr>", "Previous Tab" },
    ["]<tab>"] = { "<cmd>tabNext<cr>", "Next Tab" },
})
-- }}}

-- vim: foldmethod=marker
