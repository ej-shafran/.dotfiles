-- Settings, Options & Configuration

local opt = vim.opt
local wo = vim.wo
local g = vim.g

-- Basic

opt.mouse = "a" -- Mouse usage
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.showmode = false -- Don't show mode, it's in the statusline
opt.undofile = true -- Save undo history
opt.formatoptions:remove "o" -- Don't have `o` add a comment

-- UI

wo.signcolumn = "yes" -- Always keep sign column open

opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.termguicolors = true -- Enable better ("termgui") colors
opt.laststatus = 3 -- Only one status line at the bottom of the whole instance
opt.splitright = true -- Split on the right by default
opt.splitbelow = true -- Split below by default
opt.list = true -- Show extra whitespace in the editor
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- Set nicer characters for `list`
opt.inccommand = "split" -- Show substitutions live, even if not currently visible
opt.cursorline = true -- Highlight current line
opt.scrolloff = 3 -- Minimal number of lines above and below the cursor

-- Search

opt.hlsearch = true -- Search highlighting
opt.incsearch = true -- Incremental search
opt.ignorecase = true -- Ignore case
opt.smartcase = true -- ...unless there's an uppercase character

-- Completion

opt.completeopt = "menuone,noselect" -- Show a menu when using completion, even if only one option

-- Misc

g.c_syntax_for_h = 1 -- Use C syntax for `.h` files, not C++
g.markdown_folding = 1 -- Folding for Markdown

vim.filetype.add {
  extension = {
    NeogitCommitMessage = "gitcommit"
  },
  filename = {
    ["flake.lock"] = "json",
  }
}
