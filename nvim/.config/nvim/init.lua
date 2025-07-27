-- Options
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.laststatus = 3
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.winborder = 'rounded'
vim.wo.signcolumn = "yes"
vim.diagnostic.config({ jump = { float = true } })

local function get_cwd()
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
			cwd = get_cwd(),
			additional_args = function()
				if hidden then
					return { "--hidden" }
				end

				return {}
			end
		}
	end
end

local function telescope_find_files(hidden)
	return function()
		require("telescope.builtin").find_files {
			cwd = get_cwd(),
			hidden = hidden
		}
	end
end

-- Keymaps
vim.keymap.set("n", "<Esc>", "<Esc><cmd>noh<cr>")
vim.keymap.set("n", "-", "<cmd>Oil<cr>")
vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>?", "<cmd>Telescope help_tags<cr>")
vim.keymap.set("n", "<leader>c", "<cmd>Compile<cr>")
vim.keymap.set("n", "<leader>C", "<cmd>Recompile<cr>")
vim.keymap.set("n", "<leader>d", "<cmd>Telescope lsp_definitions<cr>")
vim.keymap.set("n", "<leader>f", telescope_find_files(false))
vim.keymap.set("n", "<leader>F", telescope_find_files(true))
vim.keymap.set("n", "<leader>g", "<cmd>Neogit<cr>")
vim.keymap.set("n", "<leader>h", "<cmd>split<cr>")
vim.keymap.set("n", "<leader>s", telescope_search(false))
vim.keymap.set("n", "<leader>S", telescope_search(true))
vim.keymap.set("n", "<leader>v", "<cmd>vsplit<cr>")
vim.keymap.set("n", "<leader>o", "<cmd>update<cr><cmd>source<cr>")
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>")

-- Autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- Plugins
vim.pack.add({
	{src = "https://github.com/stevearc/oil.nvim"},
	{src = "https://github.com/neovim/nvim-lspconfig"},
	{src = "https://github.com/nvim-lua/plenary.nvim"},
	{src = "https://github.com/nvim-telescope/telescope.nvim"},
	{src = "https://github.com/folke/lazydev.nvim"},
	{src = "https://github.com/NeogitOrg/neogit"},
	{src = "https://github.com/folke/tokyonight.nvim"},
	{src = "https://github.com/ej-shafran/compile-mode.nvim"},
	{src = "https://github.com/nvim-treesitter/nvim-treesitter"},
	{src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"},
})

-- Plugin configs
---@diagnostic disable-next-line: missing-fields
require("lazydev").setup({
	library = {"luvit-meta/library"}
})

require("telescope").setup({})

require("oil").setup({
	skip_confirm_for_simple_edits = true,
	columns = {
		"permissions",
		"size",
		"mtime"
	}
})

require("neogit").setup({
	disable_hint = true,
	console_timeout = 7000
})

require("nvim-treesitter.configs").setup {
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
      ["aa"] = { query = "@jsx_attr", desc = "JSX attribute" }
    },
  },
}
}

---@module "compile-mode"
---@type CompileModeOpts
vim.g.compile_mode = {
        default_command = "",
        bang_expansion = true,
        input_word_completion = true,
}

-- Colors
vim.cmd("colorscheme tokyonight-night")
vim.cmd("highlight clear Folded")

-- LSP
vim.lsp.enable({ "lua_ls" })
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end
})
vim.cmd("set completeopt+=noselect")
