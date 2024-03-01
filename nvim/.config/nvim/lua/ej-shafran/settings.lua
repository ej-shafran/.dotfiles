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
-- Don't fold automatically when buffer is loaded
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    pattern = { "*.md" },
    callback = function()
        vim.wo.foldenable = false
    end,
})
-- }}}

-- {{{ Abolish
local abolishes = {
    { "{despa,sepe}rat{e,es,ed,ing,ely,ion,ions,or}", "{despe,sepa}rat{}" },
    { "afterword{,s}", "afterward{}" },
    { "anomol{y,ies}", "anomal{}" },
    { "austrail{a,an,ia,ian}", "austral{ia,ian}" },
    { "cal{a,e}nder{,s}", "cal{e}ndar{}" },
    { "{c,m}arraige{,s}", "{}arriage{}" },
    { "{,in}consistan{cy,cies,t,tly}", "{}consisten{}" },
    { "destionation{,s}", "destination{}" },
    { "delimeter{,s}", "delimiter{}" },
    { "{,non}existan{ce,t}", "{}existen{}" },
    { "despara{te,tely,tion}", "despera{}" },
    { "d{e,i}screp{e,a}nc{y,ies}", "d{i}screp{a}nc{}" },
    { "euphamis{m,ms,tic,tically}", "euphemis{}" },
    { "hense", "hence" },
    { "{,re}impliment{,s,ing,ed,ation}", "{}implement{}" },
    { "improvment{,s}", "improvement{}" },
    { "inherant{,ly}", "inherent{}" },
    { "lastest", "latest" },
    { "{les,compar,compari}sion{,s}", "{les,compari,compari}son{}" },
    { "{,un}nec{ce,ces,e}sar{y,ily}", "{}nec{es}sar{}" },
    { "{,un}orgin{,al}", "{}origin{}" },
    { "persistan{ce,t,tly}", "persisten{}" },
    { "referesh{,es}", "refresh{}" },
    { "{,ir}releven{ce,cy,t,tly}", "{}relevan{}" },
    { "rec{co,com,o}mend{,s,ed,ing,ation}", "rec{om}mend{}" },
    { "reproducable", "reproducible" },
    { "resouce{,s}", "resource{}" },
    { "restraunt{,s}", "restaurant{}" },
    { "seperat{e,es,ed,ing,ely,ion,ions,or}", "separat{}" },
    { "reciev{e,ed,es,ing}", "receiv{}" },
}

for _, abolish in ipairs(abolishes) do
    vim.cmd("Abolish " .. abolish[1] .. " " .. abolish[2])
end
-- }}}

-- {{{ Autocmds

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- }}}

-- vim: foldmethod=marker
