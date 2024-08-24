local M = {}

local highlights_ns = vim.api.nvim_create_namespace "highlight_debugs"

---@type table<integer, boolean>
local bufnr_is_debugging = {}

local function show(bufnr)
  local extmarks = vim.api.nvim_buf_get_extmarks(bufnr, -1, 0, -1, {
    details = true,
  })

  ---@type vim.Diagnostic[]
  local diagnostics = {}
  for _, extmark in ipairs(extmarks) do
    local row = extmark[2]
    local col = extmark[3] --[[@as integer]]
    ---@type vim.api.keyset.extmark_details
    local details = extmark[4]

    if details.hl_group then
      ---@type vim.Diagnostic
      local diagnostic = {
        bufnr = bufnr,
        col = col,
        end_col = details.end_col,
        end_lnum = details.end_row,
        message = details.hl_group,
        lnum = row,
        namespace = highlights_ns,
        severity = vim.diagnostic.severity.HINT,
      }

      table.insert(diagnostics, diagnostic)
    end
  end

  bufnr_is_debugging[bufnr] = #diagnostics > 0
  if #diagnostics > 0 then
    vim.diagnostic.set(highlights_ns, bufnr, diagnostics, {})
  end
end

local function hide(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, highlights_ns, 0, -1)
  bufnr_is_debugging[bufnr] = false
end

function M.toggle()
  local bufnr = vim.api.nvim_get_current_buf()
  if bufnr_is_debugging[bufnr] then
    hide(bufnr)
  else
    show(bufnr)
  end
end

return M
