require("luasnip.session.snippet_collection").clear_snippets "markdown"

local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("markdown", {
  s(
    "commits",
    fmt(
      [[
      > [!NOTE]
      >
      > Code-review for this PR can be done by commits.

      {}
      ]],
      i(0)
    )
  ),
})
