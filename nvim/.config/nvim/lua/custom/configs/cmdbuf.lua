local M = {}

function M.setup(bufnr)
  local cmdbuf = require "cmdbuf"

  local function set(mode, lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts or {}, { buffer = bufnr }))
  end

  vim.bo.bufhidden = "wipe"
  set("n", "q", "<CMD>q<CR>", { nowait = true })
  set("n", "dd", cmdbuf.delete)
  set({ "n", "i" }, "<C-c>", cmdbuf.cmdline_expr, { expr = true })

  local ctx = cmdbuf.get_context { bufnr = bufnr }

  ---@type table<CmdbufHandlerType, string[]>
  local ignore_table = {
    ["vim/cmd"] = { "q", "wq", "w" },
  }

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local replacement = vim
    .iter(lines)
    :filter(function(line)
      local ignore_list = ignore_table[ctx.type]

      if not ignore_list then
        return true
      end

      return not vim.tbl_contains(ignore_list, line)
    end)
    :totable()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, replacement)
end

return M
