local library = { vim.env.VIMRUNTIME .. "/lua" }

local plugins = vim.fn.glob(vim.fn.stdpath "data" .. "/site/pack/core/opt/*/lua", false, true)

vim.list_extend(library, plugins)

---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  settings = {
    Lua = {
      ["runtime.version"] = "LuaJIT",
      ["workspace.library"] = library,
    },
  },
}
