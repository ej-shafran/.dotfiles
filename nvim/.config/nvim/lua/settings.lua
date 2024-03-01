-- Settings & Configuration

-- {{{ Basic
vim.o.mouse = "a" -- Mouse usage
vim.o.clipboard = "unnamedplus" -- Use system clipboard
vim.o.showmode = false -- Don't show mode, it's in the statusline
vim.o.undofile = true -- Save undo history
-- }}}

-- {{{ UI
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.wo.signcolumn = "yes" -- Always keep sign column open
vim.opt.termguicolors = true -- Enable better ("termgui") colors
vim.opt.laststatus = 3 -- Only one status line at the bottom of the whole instance
vim.opt.splitright = true -- Split on the right by default
vim.opt.splitbelow = true -- Split below by default
vim.opt.list = true -- Show extra whitespace in the editor
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- Set nicer characters for `list`
vim.opt.inccommand = "split" -- Show substitutions live, even if not currently visible
vim.opt.cursorline = true -- Highlight current line
vim.opt.scrolloff = 10 -- Minimal number of lines above and below the cursor
-- }}}

-- {{{ Search
vim.o.hlsearch = true -- Search highlighting
vim.o.incsearch = true -- Incremental search
vim.o.ignorecase = true -- Ignore case
vim.o.smartcase = true -- ...unless there's an uppercase character
-- }}}

-- {{{ Completion
vim.o.completeopt = "menuone,noselect" -- Show a menu when using completion, even if only one option
-- }}}

-- {{{ Misc
vim.g.c_syntax_for_h = 1 -- Use C syntax for `.h` files, not C++
vim.g.markdown_folding = 1 -- Folding for Markdown
-- }}}

-- vim: foldmethod=marker
