local utils = require "custom.utils"

local parsers = { "lua", "c", "markdown" }
if utils.has_python then
  table.insert(parsers, "python")
end
if utils.has_js then
  table.insert(parsers, "typescript")
  table.insert(parsers, "tsx")
end
if utils.has_go then
  table.insert(parsers, "go")
  table.insert(parsers, "gomod")
  table.insert(parsers, "gosum")
end
if utils.has_zig then
  table.insert(parsers, "zig")
end
if utils.has_haskell then
  table.insert(parsers, "haskell")
end

local textobjects = {
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
    },
  },
}
if utils.has_js then
  textobjects.select.keymaps["aa"] = { query = "@jsx_attr", desc = "JSX attribute" }
end

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup {
  textobjects = textobjects,
  ensure_installed = parsers,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {},
  },
}
