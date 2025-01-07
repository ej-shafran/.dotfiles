local utils = require "custom.utils"

local ask_to_save = require("compile-mode.utils").ask_to_save
local builtin = require "telescope.builtin"
local xchange = require "substitute.exchange"
local cmp = require "cmp"
local conform = require "conform"
local harpoon = require "harpoon"
local gitsigns = require "gitsigns"
local dap = require "dap"
local dapui = require "dapui"
local dapvtext = require "nvim-dap-virtual-text"
local todo_comments = require "todo-comments"
local oil = require "oil"

local config_dir = vim.fn.stdpath "config"
local set = vim.keymap.set
local function with(cb, ...)
  local args = { ... }
  return function()
    cb(unpack(args))
  end
end
local function with_count(cmd, default)
  return function()
    local default_count = type(default) == "function" and default() or default
    local count = vim.v.count == 0 and default_count or vim.v.count
    return "<cmd>" .. count .. cmd .. "<cr>"
  end
end

-- Misc (Normal mode)
set("n", "<Esc>", "<Esc><cmd>noh<cr>")
set("n", "<C-h>", "<cmd>KittyNavigateLeft <cr>", { desc = "Move Window Left" })
set("n", "<C-j>", "<Cmd>KittyNavigateDown <cr>", { desc = "Move Window Down" })
set("n", "<C-k>", "<Cmd>KittyNavigateUp   <cr>", { desc = "Move Window Up" })
set("n", "<C-l>", "<Cmd>KittyNavigateRight<cr>", { desc = "Move Window Right" })
set("n", "cx", xchange.operator, { desc = "Substitute" })
set("n", "-", "<cmd>Oil<cr>", { desc = "Open File Explorer" })

set("i", "<C-f>", "<Right>")
set("i", "<C-/>", "<C-o>u")

set("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
set("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
set("x", "X", xchange.visual, { desc = "Substitute" })
set("x", "C", "<Plug>(abolish-coerce)")

set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })

set("c", "<Esc>b", "<S-Left>")
set("c", "<Esc>f", "<S-Right>")

set("!", "<C-n>", cmp.complete)
set("!", "<C-b>", "<Left>")
set("!", "<C-a>", "<Home>")
set("!", "<C-e>", "<End>")
set("!", "<C-d>", "<Delete>")

-- {{{ Buffer

set("n", "<leader>bb", builtin.buffers, { desc = "Browse Buffers" })
set("n", "<leader>bl", "<cmd>blast<cr>", { desc = "Last Buffer" })
set("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New Buffer" })
set("n", "<leader>bo", utils.kill_other_buffers, { desc = "New Buffer" })
set("n", "<leader>bq", "<cmd>bd|blast<cr>", { desc = "Delete Buffer" })
set("n", "<leader>bQ", "<cmd>bd!|blast<cr>", { desc = "Kill Buffer" })
set("n", "[b", "<cmd>bp<cr>", { desc = "Previous Buffer" })
set("n", "]b", "<cmd>bn<cr>", { desc = "Next Buffer" })

-- }}}

-- {{{ Code

set("n", "<leader>cc", "<cmd>Compile<cr>", { desc = "Compile" })
set("n", "<leader>ch", "<cmd>hide Compile<cr>", { desc = "Compile Without Opening Buffer" })
set("n", "<leader>cC", "<cmd>Recompile<cr>", { desc = "Recompile" })
set("n", "<leader>cq", "<cmd>QuickfixErrors<cr>", { desc = "Load Compilation Errors To Quickfix" })
set("n", "<leader>cH", "<cmd>hide Recompile<cr>", { desc = "Recompile Without Opening Buffer" })
set("n", "<leader>cf", with(conform.format, { async = true, lsp_fallback = true }), { desc = "Format" })
set("n", "<leader>ce", builtin.diagnostics, { desc = "List Errors" })
set("n", "<leader>cq", builtin.quickfix, { desc = "Browse Quickfix List" })
set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
set("v", "?", vim.lsp.buf.code_action, { desc = "Code Action" })
set("n", "<leader>ci", "<cmd>Telescope import<cr>", { desc = "Add Import" })
set("n", "<leader>cd", builtin.lsp_definitions, { desc = "Find Definition" })
set("n", "<leader>cI", builtin.lsp_implementations, { desc = "Find Implementation" })
set("n", "<leader>cj", builtin.lsp_document_symbols, { desc = "Jump To Symbol" })
set("n", "<leader>cJ", builtin.lsp_workspace_symbols, { desc = "Jump To Symbol (Workspace)" })
set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "LSP Rename" })
set("n", "<leader>ct", "<cmd>TodoTelescope<cr>", { desc = "Jump to TODO" })
set("n", "<leader>cx", "<cmd>.lua<cr>", { desc = "Execute Line" })
set("n", "<leader>cD", builtin.lsp_references, { desc = "Jump To References" })
set("n", "<leader>cX", "<cmd>so<cr>", { desc = "Execute Buffer" })
set("n", "<leader>cl", "<Plug>(Delog)", { desc = "Add Log Statement" })
set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
set("n", "gd", builtin.lsp_definitions, { desc = "Goto Definition" })
set("n", "gD", builtin.lsp_references, { desc = "Goto References" })
set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
set("n", "]]d", vim.diagnostic.open_float, { desc = "Open Diagnostic Float" })
set("n", "[e", with_count("PrevError", 1), { expr = true, desc = "Previous Error" })
set("n", "]e", with_count("NextError", 1), { expr = true, desc = "Next Error" })
set("n", "]]e", "<cmd>CurrentError<cr>", { desc = "Current Error" })
set("n", "[q", "<cmd>cp<cr>", { desc = "Previous Quickfix" })
set("n", "[Q", "<cmd>cNfile<cr>", { desc = "Previous Quickfix File" })
set("n", "]q", "<cmd>cn<cr>", { desc = "Next Quickfix" })
set("n", "]Q", "<cmd>cnfile<cr>", { desc = "Next Quickfix File" })
set("n", "[t", todo_comments.jump_prev, { desc = "Previous TODO" })
set("n", "]t", todo_comments.jump_next, { desc = "Next TODO" })

set({ "i", "s" }, "<C-l>", function()
  return vim.snippet.active { direction = 1 } and vim.snippet.jump(1)
end, { silent = true })
set({ "i", "s" }, "<C-h>", function()
  return vim.snippet.active { direction = -1 } and vim.snippet.jump(-1)
end, { silent = true })

--- }}}

-- {{{ Debug

set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
set("n", "<leader>dr", dap.run_to_cursor, { desc = "Run to Cursor" })
set("n", "<leader>d?", function()
  ---@diagnostic disable-next-line: missing-fields
  dapui.eval(nil, { enter = true })
end, { desc = "Eval Under Cursor" })
set("n", "<leader>dc", function()
  dap.continue()
  dapvtext.enable()
end, { desc = "Continue" })
set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
set("n", "<leader>do", dap.step_out, { desc = "Step Out" })
set("n", "<leader>dn", dap.step_over, { desc = "Step Over" })
set("n", "<leader>dp", dap.step_back, { desc = "Step Back" })
set("n", "<leader>dR", dap.restart, { desc = "Restart" })
set("n", "<leader>dq", function()
  dap.close()
  dapui.close()
  dapvtext.disable()
end, { desc = "Stop" })

-- }}}

-- {{{ Files

local hlist = harpoon:list()

local function harpoon_file_callback(num)
  return function()
    hlist:select(num)
  end
end
set("n", "<leader>f1", harpoon_file_callback(1), { desc = "Harpoon 1st" })
set("n", "<leader>f2", harpoon_file_callback(2), { desc = "Harpoon 2nd" })
set("n", "<leader>f3", harpoon_file_callback(3), { desc = "Harpoon 3rd" })
for i = 4, 9, 1 do
  set("n", "<leader>f" .. i, harpoon_file_callback(i), { desc = "Harpoon " .. i .. "th" })
end
set("n", "<leader>fa", function()
  hlist:add()
end, { desc = "Harpoon Append" })
set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
set("n", "<leader>fh", with(builtin.find_files, { hidden = true }), { desc = "Find Hidden Files" })
set("n", "<leader>fi", with(builtin.find_files, { hidden = true, no_ignore = true }), { desc = "Find Ignored Files" })
set("n", "<leader>fc", with(builtin.find_files, { hidden = true, cwd = config_dir }), { desc = "Find Config Files" })
set("n", "<leader>fo", function()
  builtin.find_files { cwd = oil.get_current_dir() }
end, { desc = "Find In Oil Directory" })
set("n", "<leader>fO", function()
  builtin.find_files { cwd = oil.get_current_dir(), hidden = true }
end, { desc = "Find Hidden In Oil Directory" })
set("n", "<leader>fg", builtin.git_files, { desc = "Find Git Files" })
set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent Files" })
set("n", "<leader>fl", function()
  harpoon.ui:toggle_quick_menu(hlist, {})
end, { desc = "Harpoon UI" })
set("n", "[h", function()
  hlist:prev()
end, { desc = "Harpoon Previous" })
set("n", "]h", function()
  hlist:next()
end, { desc = "Harpoon Next" })

-- }}}

-- {{{ Git

set("n", "<leader>gb", builtin.git_branches, { desc = "Choose Branch" })
set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diff/Merge View" })
set("n", "<leader>gC", builtin.git_commits, { desc = "Choose Commit" })
set("n", "<leader>gc", "<cmd>Neogit commit<cr>", { desc = "Create Commit" })
set("n", "<leader>gf", "<cmd>Neogit kind=floating<cr>", { desc = "Neogit (Floating)" })
set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" })
set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview Hunk" })
set("n", "<leader>ga", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Preview Hunk" })
set("n", "<leader>gs", builtin.git_status, { desc = "Browse Status" })
set("n", "<leader>ghr", "<cmd>DiffviewOpen origin/HEAD...HEAD --imply-local<cr>", { desc = "Review Pull Request" })
set(
  "n",
  "<leader>ghh",
  "<cmd>DiffviewFileHistory --range=origin/HEAD...HEAD --right-only --no-merges<cr>",
  { desc = "Review Pull Request (Commits)" }
)
set("n", "[c", function()
  if vim.wo.diff then
    return "[c"
  end
  vim.schedule(gitsigns.prev_hunk)
  return "<Ignore>"
end, { expr = true, desc = "Previous Hunk" })
set("n", "]c", function()
  if vim.wo.diff then
    return "]c"
  end
  vim.schedule(gitsigns.next_hunk)
  return "<Ignore>"
end, { expr = true, desc = "Next Hunk" })

-- }}}

-- {{{ Help

set("n", "<leader>hf", builtin.help_tags, { desc = "Find Help" })
set("n", "<leader>hm", builtin.man_pages, { desc = "Open Man Page" })
set("n", "<leader>hk", builtin.keymaps, { desc = "Browse Keymaps" })
set("n", "<leader>hq", "<cmd>helpclose<cr>", { desc = "Close Help Window" })

-- }}}

-- {{{ Input

set("n", "<leader>ia", "a <esc>", { desc = "Space After" })
set("n", "<leader>ii", "i <esc>", { desc = "Space Before" })
set("n", "<leader>io", "o<esc>", { desc = "New Line Down" })
set("n", "<leader>iO", "O<esc>", { desc = "New Line Up" })

local right_align = with_count("RightAlign", function()
  return vim.o.textwidth
end)
set("n", "<leader>i<tab>", right_align, { expr = true, desc = "Right Align" })

-- }}}

-- {{{ Open

set("n", "<leader>o-", "<cmd>Oil<cr>", { desc = "Open File Explorer" })
set("n", "<leader>ot", "<cmd>InspectTree<cr>", { desc = "Open Treesitter Tree" })
set("n", "<leader>oq", "<cmd>EditQuery<cr>", { desc = "Open Treesitter Query Editor" })
set("n", "<leader>od", function()
  vim.cmd "tabnew"
  vim.cmd "DBUI"
end, { desc = "Database UI" })

-- }}}

-- {{{ Plugin

set("n", "<leader>pp", "<cmd>Lazy<cr>", { desc = "Open Plugin Manager" })
set("n", "<leader>ps", "<cmd>Lazy sync<cr>", { desc = "Sync Plugins" })
set("n", "<leader>pr", "<cmd>LazyReloadPlugin<cr>", { desc = "Reload Plugin" })
set("n", "<leader>pt", function()
  ask_to_save {}
  vim.cmd "PlenaryBustedFile %"
end, { desc = "Test Current File" })
set("n", "<leader>ph", "<cmd>checkhealth<cr>", { desc = "Health Checks" })

-- }}}

-- {{{ Quit

set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit Neovim" })
set("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Quit Forcefully" })

-- }}}

-- {{{ Search

set("n", "<leader>sb", builtin.current_buffer_fuzzy_find, { desc = "Current Buffer" })
set("n", "<leader>sc", function()
  builtin.live_grep {
    cwd = vim.fn.stdpath "config",
    additional_args = function()
      return { "--hidden" }
    end,
  }
end, { desc = "Config Directory" })
set("n", "<leader>sd", builtin.live_grep, { desc = "Current Directory" })
set("n", "<leader>sh", function()
  builtin.live_grep {
    additional_args = function()
      return { "--hidden" }
    end,
  }
end, { desc = "Hidden Files" })
set("n", "<leader>sr", builtin.resume, { desc = "Resume Last" })
set("n", "<leader>ss", builtin.grep_string, { desc = "Text At Cursor" })
set("n", "<leader>sS", function()
  builtin.grep_string {
    additional_args = function()
      return { "--hidden" }
    end,
  }
end, { desc = "Text At Cursor (Hidden)" })
set("n", "<leader>sH", builtin.search_history, { desc = "Rerun From History" })
set("n", "<leader>so", function()
  builtin.live_grep { cwd = oil.get_current_dir() }
end, { desc = "Oil Directory" })
set("n", "<leader>so", function()
  builtin.live_grep {
    cwd = oil.get_current_dir(),
    additional_args = function()
      return { "--hidden" }
    end,
  }
end, { desc = "Oil Directory (Hidden)" })

-- }}}

-- {{{ Toggle

set("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Git Blame" })
set("n", "<leader>tc", "<cmd>TSContextToggle<cr>", { desc = "Code Context" })
set("n", "<leader>tl", "<cmd>set number! relativenumber!<cr>", { desc = "Line Numbers" })
set("n", "<leader>ts", "<cmd>set spell!<cr>", { desc = "Spell Checking" })
set("n", "<leader>tp", "<cmd>set paste!<cr>", { desc = "Paste Handling" })
set("n", "<leader>tj", "<cmd>set scrollbind!<cr>", { desc = "Scroll Binding" })
set("n", "<leader>tz", "<cmd>ZenMode<cr>", { desc = "Zen Mode" })
set("n", "<leader>tC", "<cmd>set cursorcolumn!<cr>", { desc = "Column Highlighting" })
set("n", "<leader>tt", "<cmd>tab term<cr>", { desc = "Terminal" })
set("n", "<leader>tw", "<cmd>set wrap!<cr>", { desc = "Line Wrapping" })
set("n", "<leader>tf", "<cmd>AutoformatToggle<cr>", { desc = "Format On Save (Buffer)" })
set("n", "<leader>tF", "<cmd>AutoformatToggle!<cr>", { desc = "Format On Save (Global)" })

-- }}}

-- {{{ Vim

set("n", "<leader>va", builtin.autocommands, { desc = "Browse Autocomands" })
set("n", "<leader>vc", builtin.commands, { desc = "Choose Command" })
set("n", "<leader>vf", builtin.filetypes, { desc = "Browse File Types" })
set("n", "<leader>vh", builtin.highlights, { desc = "Browse Highlights" })
set("n", "<leader>vj", builtin.jumplist, { desc = "Browse Jumplist" })
set("n", "<leader>vl", builtin.loclist, { desc = "Browse Location List" })
set("n", "<leader>vm", builtin.marks, { desc = "Browse Marks" })
set("n", "<leader>vo", builtin.vim_options, { desc = "Browse Vim Options" })
set("n", "<leader>vq", builtin.quickfixhistory, { desc = "Browse Quickfix History" })
set("n", "<leader>vr", builtin.registers, { desc = "Browse Register" })
set("n", "<leader>vs", builtin.search_history, { desc = "Browse Search History" })
set("n", "<leader>vt", builtin.colorscheme, { desc = "Browse Themes" })

-- }}}

-- {{{ Window

set("n", "<leader>ws", "<C-w>s", { desc = "Split Window" })
set("n", "<leader>wv", "<C-w>v", { desc = "Split Window Vertically" })
set("n", "<leader>ww", "<C-w>w", { desc = "Switch Windows" })
set("n", "<leader>wq", "<C-w>q", { desc = "Quit a Window" })
set("n", "<leader>wo", "<C-w>o", { desc = "Close All Other Windows" })
set("n", "<leader>wT", "<C-w>T", { desc = "Break Out Into a New Tab" })
set("n", "<leader>wx", "<C-w>x", { desc = "Swap Current With Next" })
set("n", "<leader>w-", "<C-w>-", { desc = "Decrease Height" })
set("n", "<leader>w+", "<C-w>+", { desc = "Increase Height" })
set("n", "<leader>w<lt>", "<C-w><lt>", { desc = "Decrease Width" })
set("n", "<leader>w>", "<C-w>>", { desc = "Increase Width" })
set("n", "<leader>w|", "<C-w>|", { desc = "Max Out the Width" })
set("n", "<leader>w_", "<C-w>_", { desc = "Max Out the Height" })
set("n", "<leader>w,", "<C-w>=", { desc = "Equally High and Wide" })
set("n", "<leader>wh", "<C-w>h", { desc = "Move left" })
set("n", "<leader>wj", "<C-w>j", { desc = "Move down" })
set("n", "<leader>wk", "<C-w>k", { desc = "Move up" })
set("n", "<leader>wl", "<C-w>l", { desc = "Move right" })
set("n", "<leader>wH", "<C-w>H", { desc = "Move window left" })
set("n", "<leader>wJ", "<C-w>J", { desc = "Move window down" })
set("n", "<leader>wK", "<C-w>K", { desc = "Move window up" })
set("n", "<leader>wL", "<C-w>L", { desc = "Move window right" })

-- }}}

-- {{{ Tab

set("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
set("n", "<leader><tab>q", "<cmd>tabclose<cr>", { desc = "Close Tab" })
set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close All Other Tabs" })
set("n", "[<tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
set("n", "]<tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })

-- }}}

-- vim: foldmethod=marker
