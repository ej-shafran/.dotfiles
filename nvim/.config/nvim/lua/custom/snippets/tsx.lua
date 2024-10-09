require("luasnip.session.snippet_collection").clear_snippets "typescriptreact"

local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

---@param str string
---@return string
local function to_pascal_case(str)
  return str:sub(1, 1):upper() .. str:sub(2, -1)
end

---@param str string
---@return string
local function to_camel_case(str)
  return str:sub(1, 1):lower() .. str:sub(2, -1)
end

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

        return to_pascal_case(state)
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
  s(
    "context",
    fmt(
      [[
      import {{ createContextHook }} from "@hilma/tools";
      import {{ createContext }} from "react";

      export interface {}Context {{
        {}
      }}

      export const {camel}Context = createContext<{Pascal}Context | null>(null);
      {camel}Context.displayName = "{Pascal}";
      export const use{Pascal} = createContextHook({camel}Context);
      ]],
      {
        i(1),
        i(0),
        Pascal = f(function(args)
          local state = args[1][1] --[[@as string]]
          return state
        end, { 1 }),
        camel = f(function(args)
          local state = args[1][1] --[[@as string]]

          if state:len() == 0 then
            return ""
          end

          return to_camel_case(state)
        end, { 1 }),
      }
    )
  ),
})
