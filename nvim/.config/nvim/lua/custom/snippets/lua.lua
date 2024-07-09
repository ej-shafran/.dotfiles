require("luasnip.session.snippet_collection").clear_snippets "lua"

local ls = require "luasnip"
local s = ls.snippet
local f = ls.function_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

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
  s(
    "nmod",
    fmt(
      [[
      local {name} = {{}}

      {}

      return {name}
      ]],
      {
        i(0),
        name = f(function()
          return string.lower(vim.fn.expand "%:t:r")
        end),
      }
    )
  ),
})
