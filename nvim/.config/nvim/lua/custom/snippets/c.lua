require("luasnip.session.snippet_collection").clear_snippets "c"

local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local ai = require "luasnip.nodes.absolute_indexer"
local extras = require "luasnip.extras"
local l = extras.lambda
local fmt = require("luasnip.extras.fmt").fmt
local postfix = require("luasnip.extras.postfix").postfix

ls.add_snippets("c", {
  s(
    "header",
    fmt(
      [[
      #ifndef {header}
      #define {header}

      {}

      #endif // {header}
      ]],
      {
        i(0),
        header = f(function()
          return string.upper(vim.fn.expand "%:t:r") .. "_H_"
        end),
      }
    )
  ),
  postfix(
    ".cpy!",
    fmt("{} memcpy({}, {}, {})", {
      i(1, "void *dest"),
      f(function(args)
        return args[1][1]
      end, { ai[1] }),
      l(l.POSTFIX_MATCH),
      i(2, "size_t size"),
    })
  ),
  postfix(
    ".realloc!",
    fmt("{target} = realloc({target}, {})", {
      i(1, "size_t size"),
      target = l(l.POSTFIX_MATCH),
    })
  ),
  postfix(
    ".free!",
    fmt("free({})", {
      l(l.POSTFIX_MATCH),
    })
  ),
})
