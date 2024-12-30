local M = {}

M.has_python = vim.fn.executable "python3" ~= 0 or vim.fn.executable "python" ~= 0
M.has_nodejs = vim.fn.executable "node" ~= 0
M.has_go = vim.fn.executable "go" ~= 0
M.has_zig = vim.fn.executable "zig" ~= 0
M.has_haskell = vim.fn.executable "ghc" ~= 0
M.has_terraform = vim.fn.executable "terraform" ~= 0

function M.kill_other_buffers()
  local buffer = vim.api.nvim_get_current_buf()
  local bufinfos = vim.fn.getbufinfo { bufloaded = 1, buflisted = 1 }
  local count = 0
  for _, bufinfo in ipairs(bufinfos) do
    if bufinfo.bufnr ~= buffer then
      count = count + 1
      vim.api.nvim_buf_delete(bufinfo.bufnr, {})
    end
  end

  vim.notify(count .. " buffer" .. (count == 1 and "" or "s") .. " deleted")
end

return M
