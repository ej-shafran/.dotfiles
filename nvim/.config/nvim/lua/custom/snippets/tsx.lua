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
  s(
    "state",
    fmt("const [{}, set{}] = useState({});", {
      i(1),
      f(function(args)
        local state = args[1][1] --[[@as string]]

        if state:len() == 0 then
          return ""
        end

        return state:sub(1, 1):upper() .. state:sub(2, -1)
      end, { 1 }),
      i(2),
    })
  ),
  s(
    "effect",
    fmt(
      [[
      useEffect(() => {{
        {}
      }}, [{}]);
      ]],
      {
        i(1),
        i(2),
      }
    )
  ),
})
