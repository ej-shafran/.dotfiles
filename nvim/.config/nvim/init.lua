-- Hi! Welcome to my Neovim config
--
-- This is a minimal configuration that requires Neovim 12, which is a nightly version at the time of writing this.
-- I use `bob` to manage my Neovim versions: https://github.com/MordechaiHadad/bob
--
-- Enjoy :)

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
  },
}

-- }}}

-- {{{ Helpers + Commands

-- Command to toggle autoformatting on and off in current buffer -  use `!` to toggle globally
vim.api.nvim_create_user_command("AutoformatToggle", function(args)
  if args.bang then
    vim.g.disable_autoformat = not vim.g.disable_autoformat
  else
    vim.b.disable_autoformat = not vim.b.disable_autoformat
  end
end, { bang = true })

-- Function to get CWD, either from actual CWD or from Oil directory
local function get_cwd()
  local buffer = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_get_option_value("filetype", { buf = buffer })

  if ft == "oil" then
    return require("oil").get_current_dir()
  else
    return vim.fn.getcwd()
  end
end

-- Telescope live_grep in current directory based on `get_cwd`
local function telescope_search(hidden)
  return function()
    require("telescope.builtin").live_grep {
      cwd = get_cwd(),
      additional_args = function()
        if hidden then
          return { "--hidden" }
        end

        return {}
      end,
    }
  end
end

-- Telescope find_files in current directory based on `get_cwd`
local function telescope_find_files(hidden)
  return function()
    require("telescope.builtin").find_files {
      cwd = get_cwd(),
      hidden = hidden,
    }
  end
end

local function compile()
  vim.g.compilation_directory = get_cwd()
  require("compile-mode").compile()
end

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

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method "textDocument/completion" then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })

      vim.keymap.set({ "i", "s" }, "<C-n>", function()
        vim.lsp.completion.get()
      end)
    end
  end,
})

-- }}}

-- {{{ Plugins

-- Install plugins with native Neovim package manager (requires nvim 12+)
vim.pack.add {
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/folke/lazydev.nvim" },
  { src = "https://github.com/NeogitOrg/neogit" },
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/ej-shafran/compile-mode.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
}

-- Oil: file explorer
require("oil").setup {
  skip_confirm_for_simple_edits = true,
  columns = {
    "permissions",
    "size",
    "mtime",
  },
  keymaps = {
    ["<C-r>"] = "actions.refresh",
    ["g="] = "actions.preview",
    ["&"] = "actions.open_cmdline",
  },
  view_options = {
    show_hidden = true,
  },
}

-- Telescope: pickers and fuzzy searches
require("telescope").setup {}

-- Harpoon: jump between files
local harpoon = require "harpoon"
harpoon:setup()
harpoon:extend {
  UI_CREATE = function(cx)
    local function set(keymap, cb)
      vim.keymap.set("n", keymap, cb, { buffer = cx.bufnr })
    end

    set("<C-v>", function()
      require("harpoon").ui:select_menu_item { vsplit = true }
    end)
    set("<C-x>", function()
      require("harpoon").ui:select_menu_item { split = true }
    end)
    set("<C-t>", function()
      require("harpoon").ui:select_menu_item { tabedit = true }
    end)
  end,
}

local hlist = harpoon:list()

-- Neogit: Git client
require("neogit").setup {
  disable_hint = true,
  console_timeout = 7000,
}

-- Gitsigns: in-file Git integration
require("gitsigns").setup {
  attach_to_untracked = true,
  current_line_blame_opts = {
    delay = 0,
  },
}

-- Conform: formatting
require("conform").setup {
  format_after_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end

    return {
      lsp_format = "fallback",
    }
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

--- compile-mode: compilation
---@module "compile-mode"
---@type CompileModeOpts
vim.g.compile_mode = {
  default_command = "",
  bang_expansion = true,
  input_word_completion = true,
}

-- Treesitter: syntax highlights + text-objects
---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {},
  },
  ensure_installed = {
    "bash",
    "c",
    "gitcommit",
    "json",
    "jsonc",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "yaml",
    "python",
    "css",
    "scss",
    "html",
    "javascript",
    "typescript",
    "tsx",
    "go",
    "gomod",
    "gosum",
    "zig",
    "haskell",
    "terraform",
  },
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

-- Mason + LSPConfig: install and enable lsp servers
require("mason").setup {}
require("mason-lspconfig").setup {
  ensure_installed = {
    "lua_ls",
    "bashls",
    "clangd",
    "jsonls",
    "yamlls",
    "pylsp",
    "ts_ls",
    "html",
    "cssls",
    "eslint",
    "gopls",
    "zls",
    "terraformls",
  },
}

-- LuaSnip: snippets
local ls = require "luasnip"

vim.snippet.expand = ls.lsp_expand

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.active = function(filter)
  filter = filter or {}
  filter.direction = filter.direction or 1

  if filter.direction == 1 then
    return ls.expand_or_jumpable()
  else
    return ls.jumpable(filter.direction)
  end
end

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.jump = function(direction)
  if direction == 1 then
    if ls.expandable() then
      return ls.expand_or_jump()
    else
      return ls.jumpable(1) and ls.jump(1)
    end
  else
    return ls.jumpable(-1) and ls.jump(-1)
  end
end

vim.snippet.stop = ls.unlink_current

ls.config.set_config {
  keep_roots = true,
  link_roots = true,
  link_children = true,
  exit_roots = false,
  updateevents = { "TextChanged", "TextChangedI" },
}

for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("snippets/*.lua", true)) do
  loadfile(ft_path)()
end

-- lazydev: Lua dev environment
---@diagnostic disable-next-line: missing-fields
require("lazydev").setup {
  library = { "luvit-meta/library" },
}

-- }}}

-- {{{ Keymaps

vim.keymap.set("n", "-", "<cmd>Oil<cr>")
vim.keymap.set({ "n", "v", "x" }, "<leader>.", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>?", "<cmd>Telescope help_tags<cr>")
vim.keymap.set("n", "<leader>`", "<cmd>Telescope resume<cr>")
for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    hlist:select(i)
  end)
end
vim.keymap.set("n", "<leader>a", function()
  hlist:add()
end)
vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>c", compile)
vim.keymap.set("n", "<leader>C", "<cmd>Recompile<cr>")
vim.keymap.set("n", "<leader>d", '"+d')
vim.keymap.set("n", "<leader>f", telescope_find_files(false))
vim.keymap.set("n", "<leader>F", telescope_find_files(true))
vim.keymap.set("n", "<leader>g", "<cmd>Neogit<cr>")
vim.keymap.set("n", "<leader>h", "<cmd>split<cr>")
vim.keymap.set("n", "<leader>l", function()
  harpoon.ui:toggle_quick_menu(hlist, {})
end)
vim.keymap.set("n", "<leader>n", "<cmd>enew<cr>")
vim.keymap.set("n", "<leader>s", telescope_search(false))
vim.keymap.set("n", "<leader>S", telescope_search(true))
vim.keymap.set("n", "<leader>v", "<cmd>vsplit<cr>")
vim.keymap.set("n", "<leader>o", "<cmd>update<cr><cmd>source<cr>")
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>")
vim.keymap.set("n", "<leader>p", vim.pack.update)
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>")
vim.keymap.set("n", "<leader>r", "<cmd>Telescope oldfiles<cr>")
vim.keymap.set("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<cr>")
vim.keymap.set("n", "<leader>ts", "<cmd>set spell!<cr>")
vim.keymap.set("n", "<leader>tt", "<cmd>tab term<cr>")
vim.keymap.set("n", "<leader>tw", "<cmd>set wrap!<cr>")
vim.keymap.set("n", "<leader>tf", "<cmd>AutoformatToggle<cr>")
vim.keymap.set("n", "<leader>tF", "<cmd>AutoformatToggle!<cr>")
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnew<cr>")
vim.keymap.set("n", "<leader><tab>q", "<cmd>tabclose<cr>")
vim.keymap.set("n", "<leader><tab>o", "<cmd>tabonly<cr>")
vim.keymap.set("n", "[<tab>", "<cmd>tabprevious<cr>")
vim.keymap.set("n", "]<tab>", "<cmd>tabnext<cr>")
vim.keymap.set("n", "[h", function()
  hlist:prev()
end)
vim.keymap.set("n", "]h", function()
  hlist:next()
end)
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Snippet keymaps
vim.keymap.set({ "i", "s" }, "<C-l>", function()
  return vim.snippet.active { direction = 1 } and vim.snippet.jump(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-h>", function()
  return vim.snippet.active { direction = -1 } and vim.snippet.jump(-1)
end, { silent = true })

-- Override keymaps
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")
vim.keymap.set("n", "<Esc>", "<Esc><cmd>noh<cr>")
vim.keymap.set("n", "[c", function()
  if vim.wo.diff then
    return "[c"
  end
  vim.schedule(function()
    ---@diagnostic disable-next-line: param-type-mismatch
    require("gitsigns").nav_hunk "prev"
  end)
  return "<Ignore>"
end, { expr = true, desc = "Previous Hunk" })
vim.keymap.set("n", "]c", function()
  if vim.wo.diff then
    return "]c"
  end
  vim.schedule(function()
    ---@diagnostic disable-next-line: param-type-mismatch
    require("gitsigns").nav_hunk "next"
  end)
  return "<Ignore>"
end)
vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>")
vim.keymap.set("n", "grr", "<cmd>Telescope lsp_references<cr>")

-- }}}

-- {{{ Colors

vim.cmd "colorscheme tokyonight-night"
vim.cmd "highlight clear Folded"

-- }}}

-- vim: foldmethod=marker
