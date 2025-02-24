-- Git-related plugins

---@type LazySpec[]
return {
  -- Git client
  {
    "NeogitOrg/neogit",
    branch = "master",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "ibhagwan/fzf-lua",
      {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen" },
      },
    },
    opts = {
      disable_hint = true,
      console_timeout = 7000,
    },
    cmd = "Neogit",
  },

  -- Git view in files
  {
    "lewis6991/gitsigns.nvim",
    cmd = "Gitsigns",
    event = "BufEnter",
    opts = {
      attach_to_untracked = true,
      current_line_blame_opts = {
        delay = 0,
      },
    },
  },

  -- Github code review/review
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      ssh_aliases = { gh = "github.com" },
      mappings_disable_default = false,
    },
    lazy = false,
  },
}
