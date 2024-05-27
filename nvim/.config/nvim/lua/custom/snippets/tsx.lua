require("luasnip.session.snippet_collection").clear_snippets "typescriptreact"

local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("typescriptreact", {
  s(
    "component",
    fmt(
      [[
      interface {comp}Props {{
        {}
      }}

      export function {comp}({{{}}}: {comp}Props) {{
        {}

        return {};
      }}
      ]],
      {
        i(1),
        i(2),
        i(3),
        i(0),
        comp = f(function()
          return vim.fn.expand "%:t:r"
        end),
      }
    )
  ),
})
