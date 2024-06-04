require("luasnip.session.snippet_collection").clear_snippets "bi"

local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local ai = require "luasnip.nodes.absolute_indexer"
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("bi", {
  s(
    ":b",
    fmt(
      [[
      :b {} {}
      {}{}
      ]],
      {
        i(1, "name"),
        f(function(args)
          return tostring(string.len(vim.fn.join(args[1], "\n")))
        end, { ai[2] }),
        i(2, "value"),
        i(0),
      }
    )
  ),

  s(
    ":i",
    fmt(":i {} {}{}", {
      i(1, "name"),
      i(2, "value"),
      i(0),
    })
  ),
})
