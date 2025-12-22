-- Hi! Welcome to my Neovim config
--
-- This is a minimal configuration that requires Neovim 12, which is a nightly version at the time of writing this.
-- I use `bob` to manage my Neovim versions: https://github.com/MordechaiHadad/bob
--
-- Enjoy :)

if not vim.fn.has "nvim-0.12.0" then
  error "This config requires version 0.12 or higher of Neovim :)"
end

-- {{{ Options

vim.g.mapleader = " " -- Set map leader
vim.g.maplocalleader = " " -- ...and local leader
vim.g.c_syntax_for_h = 1 -- Use C syntax for `.h` files instead of C++
vim.opt.undofile = true -- Save undo history
vim.opt.number = true -- Line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.laststatus = 3 -- One singular status bar
vim.opt.splitright = true -- Split right by default
vim.opt.splitbelow = true -- Split below by default
vim.opt.list = true -- Show extra whitespace
vim.opt.cursorline = true -- Highlight current line
vim.opt.hlsearch = true -- Search highlighting
vim.opt.incsearch = true -- Incremental search
vim.opt.ignorecase = true -- Ignore casing
vim.opt.smartcase = true -- ...unless there's an uppercase
vim.opt.swapfile = false -- Disable swapfile
vim.opt.winborder = "rounded" -- Nicer floating windows
vim.opt.completeopt = { "noselect", "menuone", "fuzzy" } -- Menu for autocompletion, always
vim.wo.signcolumn = "yes" -- Always keep sign column open
vim.diagnostic.config { jump = { float = true } } -- Show floating diagnostics when jumping to erro
vim.filetype.add {
  extension = {
    -- Use `gitcommit` filetype for `Neogit`
    NeogitCommitMessage = "gitcommit",
    lss = "xml",
  },
}

-- }}}

-- {{{ Plugins

-- Install plugins with native Neovim package manager (requires nvim 12+)
local plugins = {
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
  { src = "https://github.com/NeogitOrg/neogit" },
  { src = "https://github.com/sindrets/diffview.nvim" },
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
  { src = "https://github.com/tpope/vim-abolish" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/m00qek/baleia.nvim", version = "v1.3.0" },
}

-- Use local directories for plugins I developed
local compile_mode_path = vim.env.HOME .. "/plugins/compile-mode.nvim"

if vim.fn.isdirectory(compile_mode_path) == 1 then
  vim.opt.rtp:append(compile_mode_path)
else
  table.insert(plugins, { src = "https://github.com/ej-shafran/compile-mode.nvim" })
end

vim.pack.add(plugins)

-- Oil: file explorer
require("oil").setup {
  skip_confirm_for_simple_edits = true,
  columns = { "permissions", "size", "mtime" },
  keymaps = {
    ["<C-r>"] = "actions.refresh",
    ["g="] = "actions.preview",
    ["&"] = "actions.open_cmdline",
  },
  view_options = { show_hidden = true },
}

-- Telescope: pickers and fuzzy searches
require("telescope").setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_cursor {
        -- even more opts
      },
    },
  },
}
require("telescope").load_extension "ui-select"

-- Harpoon: jump between files
require("harpoon"):setup()
local hlist = require("harpoon"):list()

-- Neogit: Git client
require("neogit").setup { disable_hint = true, console_timeout = 7000 }

-- Diffview: Git diff client
require("diffview").setup { view = { merge_tool = { layout = "diff3_mixed" } } }

-- Gitsigns: in-file Git integration
require("gitsigns").setup {
  attach_to_untracked = true,
  current_line_blame_opts = { delay = 0 },
}

-- Conform: formatting
require("conform").setup {
  format_after_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end

    return { lsp_format = "fallback" }
  end,
  formatters_by_ft = {
    lua = { "stylua" },
    c = { "clang-format" },
    typescript = { "prettierd", "prettier" },
    javascript = { "prettierd", "prettier" },
    css = { "prettierd", "prettier" },
    scss = { "prettierd", "prettier" },
    markdown = { "prettierd", "prettier" },
    json = { "prettierd", "prettier" },
    jsonc = { "prettierd", "prettier" },
    yaml = { "prettierd", "prettier" },
    typescriptreact = { "prettierd", "prettier" },
    go = { "gofmt" },
    python = { "black" },
    kotlin = { "ktlint" },
  },
}

---@module "compile-mode"
---@type CompileModeOpts
vim.g.compile_mode = {
  baleia_setup = true,
  default_command = "",
  bang_expansion = true,
  error_regexp_table = {
    custom = {
      regex = "^\\%(\\[\\%(ERROR\\|\\(WARNING\\)\\|\\(INFO\\)\\)\\] \\)\\?\\([^\n :]\\+\\):\\([1-9][0-9]*\\): ",
      filename = 3,
      row = 4,
      type = { 1, 2 },
      priority = 2,
    },
    nodejs = {
      regex = "^\\s\\+at .\\+ (\\(.\\+\\):\\([1-9][0-9]*\\):\\([1-9][0-9]*\\))$",
      filename = 1,
      row = 2,
      col = 3,
      priority = 2,
    },
    typescript = {
      regex = "^\\(.\\+\\)(\\([1-9][0-9]*\\)[,:]\\([1-9][0-9]*\\)): error TS[1-9][0-9]*:",
      filename = 1,
      row = 2,
      col = 3,
    },
    kotlin = {
      regex = "^\\%(e\\|w\\): file://\\(.*\\):\\(\\d\\+\\):\\(\\d\\+\\) ",
      filename = 1,
      row = 2,
      col = 3,
    },
  },
}

-- Highlight TODO comments
require("todo-comments").setup {
  search = { pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]] },
  highlight = { pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]] },
}

-- Treesitter: syntax highlights + text-objects
require("nvim-treesitter.configs").setup {
  modules = {},
  auto_install = true,
  ensure_installed = {},
  ignore_install = {},
  sync_install = false,
  highlight = { enable = true, additional_vim_regex_highlighting = {} },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      include_surrounding_whitespace = true,
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "function" },
        ["if"] = { query = "@function.inner", desc = "function" },
        ["ac"] = { query = "@class.outer", desc = "class" },
        ["ic"] = { query = "@class.inner", desc = "class" },
        ["aP"] = { query = "@parameter.outer", desc = "arg" },
        ["iP"] = { query = "@parameter.inner", desc = "arg" },
        ["aa"] = { query = "@jsx_attr", desc = "JSX attribute" },
      },
    },
  },
}

-- Mason: install lsp servers
require("mason").setup {}

-- LuaSnip: snippets
local luasnip = require "luasnip"
luasnip.setup {
  enable_autosnippet = true,
  updateevents = { "TextChanged", "TextChangedI" },
}

require("luasnip.loaders.from_lua").load { paths = "./snippets/" }

-- Replace Vim snippet functionality with LuaSnip
vim.snippet.expand = luasnip.lsp_expand
vim.snippet.stop = luasnip.unlink_current

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.active = function(filter)
  filter = filter or {}
  filter.direction = filter.direction or 1

  if filter.direction == 1 then
    return luasnip.expand_or_jumpable()
  end

  return luasnip.jumpable(filter.direction)
end

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.jump = function(direction)
  if direction == 1 then
    if luasnip.expandable() then
      return luasnip.expand_or_jump()
    else
      return luasnip.jumpable(1) and luasnip.jump(1)
    end
  else
    return luasnip.jumpable(-1) and luasnip.jump(-1)
  end
end

-- }}}

-- {{{ Helpers

local function autoformat_toggle(global)
  if global then
    vim.g.disable_autoformat = not vim.g.disable_autoformat
  else
    vim.b.disable_autoformat = not vim.b.disable_autoformat
  end
end

local function get_parent_dir()
  local buffer = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer })

  if ft == "oil" then
    return require("oil").get_current_dir()
  else
    return vim.fn.expand "%:h"
  end
end

local function get_current_dir()
  local buffer = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer })

  if ft == "oil" then
    return require("oil").get_current_dir()
  else
    return vim.fn.getcwd()
  end
end

local function telescope_search(hidden)
  return function()
    require("telescope.builtin").live_grep {
      cwd = get_current_dir(),
      additional_args = function()
        if hidden then
          return { "--hidden" }
        end

        return {}
      end,
    }
  end
end

local function telescope_find_files(hidden)
  return function()
    require("telescope.builtin").find_files {
      cwd = get_current_dir(),
      hidden = hidden,
    }
  end
end

local function compile()
  vim.g.compilation_directory = get_current_dir()
  require("compile-mode").compile()
end

-- }}}

-- {{{ Commands

vim.api.nvim_create_user_command("AutoformatToggle", function(args)
  autoformat_toggle(args.bang)
end, { bang = true })

-- }}}

-- {{{ Autocommands

-- Highlight yanks
---@diagnostic disable-next-line: param-type-mismatch
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Set local settings for terminal buffers
---@diagnostic disable-next-line: param-type-mismatch
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", {}),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
  end,
})

-- Autocomplete using LSP
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method "textDocument/completion" then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })

      vim.keymap.set({ "i", "s" }, "<C-n>", vim.lsp.completion.get, { buffer = ev.buf })
    end
  end,
})

-- }}}

-- {{{ Keymaps

local set = vim.keymap.set

-- Leader + letter
set("n", "<leader>a", function()
  hlist:add()
end)
set("n", "<leader>A", function()
  hlist:prepend()
end)
set("n", "<leader>b", "<cmd>Telescope buffers<cr>")
set("n", "<leader>c", compile)
set("n", "<leader>C", "<cmd>Recompile<cr>")
set("n", "<leader>d", '"+d')
set("n", "<leader>f", telescope_find_files(false))
set("n", "<leader>F", telescope_find_files(true))
set("n", "<leader>g", "<cmd>Neogit<cr>")
set("n", "<leader>G", "<cmd>Neogit kind=floating<cr>")
set("n", "<leader>h", "<cmd>split<cr>")
set("n", "<leader>l", function()
  require("harpoon").ui:toggle_quick_menu(hlist, {})
end)
set("n", "<leader>n", "<cmd>enew<cr>")
set("n", "<leader>s", telescope_search(false))
set("n", "<leader>S", telescope_search(true))
set("n", "<leader>v", "<cmd>vsplit<cr>")
set("n", "<leader>w", "<cmd>write<cr>")
set("n", "<leader>p", vim.pack.update)
set("n", "<leader>q", "<cmd>quit<cr>")
set("n", "<leader>r", "<cmd>Telescope oldfiles<cr>")
set("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<cr>")
set("n", "<leader>td", function()
  if vim.fn.getcwd() == vim.fn.getcwd(-1, -1) then
    vim.cmd.lcd(get_parent_dir())
  else
    vim.cmd.lcd(vim.fn.getcwd(-1, -1))
  end
  vim.cmd "pwd"
end)
set("n", "<leader>ts", "<cmd>set spell!<cr>")
set("n", "<leader>tt", "<cmd>tab term<cr>")
set("n", "<leader>tw", "<cmd>set wrap!<cr>")
set("n", "<leader>tf", "<cmd>AutoformatToggle<cr>")
set("n", "<leader>tF", "<cmd>AutoformatToggle!<cr>")
set("n", "<leader>y", '"+y')

-- Leader + other
set({ "n", "v", "x" }, "<leader>.", function()
  vim.lsp.buf.code_action {
    filter = function(action)
      return action.disabled == nil
    end,
  }
end)
set({ "n", "v", "x" }, "<leader>,", function()
  vim.lsp.buf.code_action {
    apply = true,
    filter = function(action)
      return action.command ~= nil and action.command.command == "eslint.applyAllFixes"
    end,
  }
end)
set("n", "<leader>?", "<cmd>Telescope help_tags<cr>")
set("n", "<leader>`", "<cmd>Telescope resume<cr>")
for i = 1, 9 do
  set("n", "<leader>" .. i, function()
    hlist:select(i)
  end)
end
set("n", "<leader>!", "<cmd>update<cr><cmd>source<cr>")
set("n", "<leader>\\", "<cmd>e $MYVIMRC<cr>")
set("n", "<leader><tab>n", "<cmd>tabnew<cr>")
set("n", "<leader><tab>q", "<cmd>tabclose<cr>")
set("n", "<leader><tab>o", "<cmd>tabonly<cr>")

-- Single characters
set("n", "-", "<cmd>Oil<cr>")

-- Prev/next
set("n", "[<tab>", "<cmd>tabprevious<cr>")
set("n", "]<tab>", "<cmd>tabnext<cr>")
set("n", "[h", function()
  hlist:prev()
end)
set("n", "]h", function()
  hlist:next()
end)
set("n", "[e", "<cmd>PrevError<cr>")
set("n", "]e", "<cmd>NextError<cr>")

-- Visual
set("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
set("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
set("x", "C", "<Plug>(abolish-coerce)")

-- Insert/visual
set({ "i", "s" }, "<C-l>", function()
  return vim.snippet.active { direction = 1 } and vim.snippet.jump(1)
end, { silent = true })
set({ "i", "s" }, "<C-h>", function()
  return vim.snippet.active { direction = -1 } and vim.snippet.jump(-1)
end, { silent = true })

-- Override keymaps
set("t", "<Esc><Esc>", "<C-\\><C-n>")
set("n", "<Esc>", "<Esc><cmd>noh<cr>")
set("n", "[c", function()
  if vim.wo.diff then
    return "[c"
  end
  vim.schedule(function()
    ---@diagnostic disable-next-line: param-type-mismatch
    require("gitsigns").nav_hunk "prev"
  end)
  return "<Ignore>"
end, { expr = true, desc = "Previous Hunk" })
set("n", "]c", function()
  if vim.wo.diff then
    return "]c"
  end
  vim.schedule(function()
    ---@diagnostic disable-next-line: param-type-mismatch
    require("gitsigns").nav_hunk "next"
  end)
  return "<Ignore>"
end)
set("n", "gd", "<cmd>Telescope lsp_definitions<cr>")
set("n", "grr", "<cmd>Telescope lsp_references<cr>")
set({ "i", "s" }, "<Tab>", function()
  return "<Tab>"
end, { silent = true })

-- }}}

-- {{{ Colors

vim.cmd "colorscheme tokyonight-night"
vim.cmd "highlight clear Folded"

-- }}}

-- {{{ LSP

-- Get all configured LSP servers
local config_root = vim.fn.stdpath "config" .. "/lsp"
local config_files = (vim.fn.glob(config_root .. "/*", false, true))
local configured = vim.tbl_map(function(value)
  return vim.fn.fnamemodify(value, ":t:r")
end, config_files)

-- Install uninstalled servers on confirm
local installed = require("mason-registry").get_installed_package_names()
local uninstalled = vim.tbl_filter(function(server)
  return not vim.list_contains(installed, server)
end, vim.list_extend({ "shellcheck" }, configured))
if #uninstalled > 0 then
  local uninstalled_text = vim.fn.join(uninstalled, "\n")
  local choice = vim.fn.confirm(("These servers will be installed:\n\n%s\n"):format(uninstalled_text), "&Yes\n&No", 1)

  if choice == 1 then
    vim.cmd { cmd = "MasonInstall", args = uninstalled }
  else
    vim.notify("Installation not confirmed", vim.log.levels.ERROR)
  end
end

-- Enable servers
vim.lsp.enable(configured)

-- }}}

-- vim: foldmethod=marker
