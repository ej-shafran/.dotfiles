local wk = require "which-key"
local utils = require "custom.utils"

local set = vim.keymap.set

wk.register {
  ["<leader>"] = {
    b = { name = "buffer" },
    c = { name = "code" },
    f = { name = "files" },
    g = { name = "git" },
    h = { name = "help" },
    i = { name = "input" },
    m = { name = "orgmode" },
    o = { name = "open" },
    p = { name = "plugin" },
    q = { name = "quit" },
    t = { name = "toggle" },
    v = { name = "vim" },
    w = { name = "window" },
  },
}

set("n", "<Esc>", "<Esc><cmd>noh<cr>")
set("n", "<C-h>", "<C-w>h", { desc = "Move Window Left" })
set("n", "<C-j>", "<C-w>j", { desc = "Move Window Down" })
set("n", "<C-k>", "<C-w>k", { desc = "Move Window Up" })
set("n", "<C-l>", "<C-w>l", { desc = "Move Window Right" })
set("n", "cx", require("substitute.exchange").operator, { desc = "Substitute" })

set("i", "<C-n>", require("cmp").complete, { desc = "Autocomplete" })

set("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
set("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
set("x", "X", require("substitute.exchange").visual, { desc = "Substitute" })

set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })

-- {{{ Buffer

set("n", "<leader>bb", "<cmd>Telescope buffers<cr>", { desc = "Browse Buffers" })
set("n", "<leader>bl", "<cmd>blast<cr>", { desc = "Last Buffer" })
set("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New Buffer" })
set("n", "<leader>bo", utils.kill_other_buffers, { desc = "New Buffer" })
set("n", "<leader>bq", "<cmd>bd|blast<cr>", { desc = "Delete Buffer" })
set("n", "<leader>bQ", "<cmd>bd!|blast<cr>", { desc = "Kill Buffer" })
set("n", "[b", "<cmd>bp<cr>", { desc = "Previous Buffer" })
set("n", "]b", "<cmd>bn<cr>", { desc = "Next Buffer" })

-- }}}

-- {{{ Code

set("n", "<leader>cc", "<cmd>belowright vertical Compile<cr>", { desc = "Compile" })
set("n", "<leader>cC", "<cmd>belowright vertical Recompile<cr>", { desc = "Recompile" })
set("n", "<leader>cf", function()
  require("conform").format { async = true, lsp_fallback = true }
end, { desc = "Format" })
set("n", "<leader>ce", "<cmd>Telescope diagnostics<cr>", { desc = "List Errors" })
set("n", "<leader>cq", "<cmd>Telescope quickfix<cr>", { desc = "Browse Quickfix List" })
set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
set("n", "<leader>cd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Find Definition" })
set("n", "<leader>ci", "<cmd>Telescope lsp_implementations<cr>", { desc = "Find Implementation" })
set("n", "<leader>cj", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Jump To Symbol" })
set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "LSP Rename" })
set("n", "<leader>cx", "<cmd>.lua<cr>", { desc = "Execute Line" })
set("n", "<leader>cD", "<cmd>Telescope lsp_references<cr>", { desc = "Jump To References" })
set("n", "<leader>cX", "<cmd>so<cr>", { desc = "Execute Buffer" })
set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Goto Definition" })
set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
set("n", "[e", "<cmd>PrevError<cr>", { desc = "Previous Error" })
set("n", "]e", "<cmd>NextError<cr>", { desc = "Next Error" })
set("n", "[q", "<cmd>cp<cr>", { desc = "Previous Quickfix" })
set("n", "]q", "<cmd>cn<cr>", { desc = "Next Quickfix" })

set({ "i", "s" }, "<C-l>", function()
  return vim.snippet.active { direction = 1 } and vim.snippet.jump(1)
end, { silent = true })
set({ "i", "s" }, "<C-h>", function()
  return vim.snippet.active { direction = -1 } and vim.snippet.jump(-1)
end, { silent = true })

--- }}}

-- {{{ Files

local function harpoon_file_callback(num)
  return function()
    require("harpoon"):list():select(num)
  end
end
set("n", "<leader>f1", harpoon_file_callback(1), { desc = "Harpoon 1st" })
set("n", "<leader>f2", harpoon_file_callback(2), { desc = "Harpoon 2nd" })
set("n", "<leader>f3", harpoon_file_callback(3), { desc = "Harpoon 3rd" })
for i = 4, 10, 1 do
  set("n", "<leader>f" .. i, harpoon_file_callback(i), { desc = "Harpoon " .. i .. "th" })
end
set("n", "<leader>fa", function()
  require("harpoon"):list():add()
end, { desc = "Harpoon Append" })
set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
set("n", "<leader>fh", "<cmd>Telescope find_files hidden=true<cr>", { desc = "Find Files" })
set("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "Find Git Files" })
set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })
set("n", "[h", function()
  require("harpoon"):list():prev()
end, { desc = "Harpoon Previous" })
set("n", "]h", function()
  require("harpoon"):list():next()
end, { desc = "Harpoon Next" })

-- }}}

-- {{{ Git

set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Choose Branch" })
set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diff/Merge View" })
set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Choose Commit" })
set("n", "<leader>gf", "<cmd>Neogit kind=floating<cr>", { desc = "Neogit (Floating)" })
set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" })
set("n", "<leader>gh", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview Hunk" })
set("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Browse Status" })
set("n", "[c", function()
  if vim.wo.diff then
    return "[c"
  end
  vim.schedule(function()
    require("gitsigns").prev_hunk()
  end)
  return "<Ignore>"
end, { desc = "Previous Hunk" })
set("n", "]c", function()
  if vim.wo.diff then
    return "]c"
  end
  vim.schedule(function()
    require("gitsigns").next_hunk()
  end)
  return "<Ignore>"
end, { desc = "Next Hunk" })

-- }}}

-- {{{ Help

set("n", "<leader>hf", "<cmd>Telescope help_tags<cr>", { desc = "Find Help" })
set("n", "<leader>hm", "<cmd>Telescope man_pages<cr>", { desc = "Open Man Page" })
set("n", "<leader>hk", "<cmd>Telescope keymaps<cr>", { desc = "Browse Keymaps" })
set("n", "<leader>hq", "<cmd>helpclose<cr>", { desc = "Close Help Window" })

-- }}}

-- {{{ Input

set("n", "<leader>ia", "a <esc>", { desc = "Space After" })
set("n", "<leader>ii", "i <esc>", { desc = "Space Before" })
set("n", "<leader>io", "o<esc>", { desc = "New Line Down" })
set("n", "<leader>iO", "O<esc>", { desc = "New Line Up" })

-- }}}

-- {{{ Open

set("n", "<leader>o-", "<cmd>Oil<cr>", { desc = "Open File Explorer" })
set("n", "<leader>ot", "<cmd>InspectTree<cr>", { desc = "Open Treesitter Tree" })
set("n", "<leader>oq", "<cmd>EditQuery<cr>", { desc = "Open Treesitter Query Editor" })

-- }}}

-- {{{ Plugin

set("n", "<leader>pp", "<cmd>Lazy<cr>", { desc = "Open Plugin Manager" })
set("n", "<leader>ps", "<cmd>Lazy sync<cr>", { desc = "Sync Plugins" })
set("n", "<leader>pr", "<cmd>LazyReloadPlugin<cr>", { desc = "Reload Plugin" })

-- }}}

-- {{{ Quit

set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit Neovim" })
set("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Quit Forcefully" })

-- }}}

-- {{{ Search

local builtin = require "telescope.builtin"

set("n", "<leader>sb", builtin.current_buffer_fuzzy_find, { desc = "Search Buffer" })
set("n", "<leader>sd", builtin.live_grep, { desc = "Search Current Directory" })
set("n", "<leader>sh", function()
  builtin.live_grep {
    additional_args = function()
      return { "--hidden" }
    end,
  }
end, { desc = "Search Hidden Files" })
set("n", "<leader>sr", builtin.resume, { desc = "Resume Last Search" })
set("n", "<leader>ss", builtin.grep_string, { desc = "Search Workspace For Text At Cursor" })
set("n", "<leader>sH", builtin.search_history, { desc = "Rerun Search From History" })

-- }}}

-- {{{ Toggle

set("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Git Blame" })
set("n", "<leader>tc", "<cmd>TSContextToggle<cr>", { desc = "Code Context" })
set("n", "<leader>tl", "<cmd>set number! relativenumber!<cr>", { desc = "Line Numbers" })
set("n", "<leader>ts", "<cmd>set spell!<cr>", { desc = "Spell Checking" })
set("n", "<leader>tp", "<cmd>set paste!<cr>", { desc = "Paste Handling" })
set("n", "<leader>tj", "<cmd>set scrollbind!<cr>", { desc = "Scroll Binding" })
set("n", "<leader>tz", "<cmd>ZenMode<cr>", { desc = "Zen Mode" })

-- }}}

-- {{{ Vim

set("n", "<leader>va", "<cmd>Telescope autocommands<cr>", { desc = "Browse Autocomands" })
set("n", "<leader>vc", "<cmd>Telescope commands<cr>", { desc = "Choose Command" })
set("n", "<leader>vf", "<cmd>Telescope filetypes<cr>", { desc = "Browse File Types" })
set("n", "<leader>vh", "<cmd>Telescope highlights<cr>", { desc = "Browse Highlights" })
set("n", "<leader>vj", "<cmd>Telescope jumplist<cr>", { desc = "Browse Jumplist" })
set("n", "<leader>vl", "<cmd>Telescope loclist<cr>", { desc = "Browse Location List" })
set("n", "<leader>vm", "<cmd>Telescope marks<cr>", { desc = "Browse Marks" })
set("n", "<leader>vo", "<cmd>Telescope vim_options<cr>", { desc = "Browse Vim Options" })
set("n", "<leader>vq", "<cmd>Telescope quickfixhistory<cr>", { desc = "Browse Quickfix History" })
set("n", "<leader>vr", "<cmd>Telescope registers<cr>", { desc = "Browse Register" })
set("n", "<leader>vs", "<cmd>Telescope search_history<cr>", { desc = "Browse Search History" })
set("n", "<leader>vt", "<cmd>Telescope colorscheme<cr>", { desc = "Browse Themes" })

-- }}}

-- {{{ Window

set("n", "<leader>ws", "<C-w>s", { desc = "Split window" })
set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
set("n", "<leader>ww", "<C-w>w", { desc = "Switch windows" })
set("n", "<leader>wq", "<C-w>q", { desc = "Quit a window" })
set("n", "<leader>wo", "<C-w>o", { desc = "Close all other windows" })
set("n", "<leader>wT", "<C-w>T", { desc = "Break out into a new tab" })
set("n", "<leader>wx", "<C-w>x", { desc = "Swap current with next" })
set("n", "<leader>w-", "<C-w>-", { desc = "Decrease height" })
set("n", "<leader>w+", "<C-w>+", { desc = "Increase height" })
set("n", "<leader>w<lt>", "<C-w><lt>", { desc = "Decrease width" })
set("n", "<leader>w>", "<C-w>>", { desc = "Increase width" })
set("n", "<leader>w|", "<C-w>|", { desc = "Max out the width" })
set("n", "<leader>w_", "<C-w>_", { desc = "Max out the height" })
set("n", "<leader>w,", "<C-w>=", { desc = "Equally high and wide" })
set("n", "<leader>wh", "<C-w>h", { desc = "Go to the left window" })
set("n", "<leader>wl", "<C-w>l", { desc = "Go to the right window" })
set("n", "<leader>wk", "<C-w>k", { desc = "Go to the up window" })
set("n", "<leader>wj", "<C-w>j", { desc = "Go to the down window" })

-- }}}

-- vim: foldmethod=marker
