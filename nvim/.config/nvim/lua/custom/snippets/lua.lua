require("luasnip.session.snippet_collection").clear_snippets "lua"

local ls = require "luasnip"
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

ls.add_snippets("lua", {
  s(
    "mmod",
    fmt(
      [[
      local M = {{}}

      {}

      return M
      ]],
      i(0)
    )
  ),
})
