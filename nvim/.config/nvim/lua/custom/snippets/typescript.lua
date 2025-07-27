require("luasnip.session.snippet_collection").clear_snippets "typescript"

local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

---@param str string
---@return string
local function to_pascal_case(str)
  str = vim.fn.substitute(str, [[-\([a-z]\)]], [[\u\1]], "g")
  return str:sub(1, 1):upper() .. str:sub(2, -1)
end

---@param str string
---@return string
local function to_camel_case(str)
  str = vim.fn.substitute(str, [[-\([a-z]\)]], [[\u\1]], "g")
  return str:sub(1, 1):lower() .. str:sub(2, -1)
end

ls.add_snippets("typescript", {
  s(
    "query",
    fmt(
      [[
    {}
    import {{ type QueryFunctionContext, useQuery }} from "@tanstack/react-query";
    import axios from "axios";

    function {keyFunction}({}) {{
      return [{}] as const;
    }}

    type {queryName}QueryKey = ReturnType<typeof {keyFunction}>;

    async function {}{queryName}({{
      queryKey: [, {}],
      signal,
    }}: QueryFunctionContext<{queryName}QueryKey>) {{
      const {{ data }} = await axios.{method}<{}>("{}", {});

      return data;
    }}

    export function use{queryName}Query({paramTypes}) {{
      return useQuery({{
        queryKey: {keyFunction}({params}),
        queryFn: {method}{queryName},
        {},
      }});
    }}
    ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(5),
        i(6),
        i(7),
        i(8),
        i(9),
        paramTypes = rep(2),
        method = rep(4),
        params = rep(5),
        keyFunction = f(function()
          local file_name = (vim.fn.expand "%:t:r")
          local query_name = file_name:gsub("use%-", ""):gsub("%-query", "")
          return to_camel_case(query_name) .. "QueryKey"
        end),
        queryName = f(function()
          local file_name = (vim.fn.expand "%:t:r")
          local query_name = file_name:gsub("use%-", ""):gsub("%-query", "")
          return to_pascal_case(query_name)
        end),
      }
    )
  ),
})
