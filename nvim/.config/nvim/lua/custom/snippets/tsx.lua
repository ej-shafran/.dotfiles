require("luasnip.session.snippet_collection").clear_snippets "typescriptreact"

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
  return str:sub(1, 1):lower() .. str:sub(2, -1)
end

ls.add_snippets("typescriptreact", {
  s(
    "component",
    fmt(
      [[
      export declare namespace {comp}{{
        export interface Props {{
          {}
        }}
      }}

      export function {comp}({{{}}}: {comp}.Props) {{
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
    "html_component",
    fmt(
      [[
      import clsx from "clsx";
      import styles from "{}";

      export declare namespace {comp} {{
        export interface Props extends React.ComponentProps<"{}"> {{}}
      }}

      export function {comp}({{ className, ...rest }}: {comp}.Props) {{
        return <{} className={{clsx(className, styles.{})}} {{...rest}} />;
      }}

      {comp}.displayName = "{}";
      ]],
      {
        i(1),
        i(2),
        rep(2),
        i(3),
        i(4),
        comp = f(function()
          return to_pascal_case(vim.fn.expand "%:t:r")
        end),
      }
    )
  ),
  s(
    "base_ui_component",
    fmt(
      [[
      import {{ {} as BaseUI{parent} }} from "@base-ui-components/react";

      export declare namespace {comp} {{
        export interface Props extends BaseUI{parent}.{}.Props {{}}
      }}

      export function {comp}(props: {comp}.Props) {{
        return <BaseUI{parent}.{child} {{...props}} />;
      }}
      ]],
      {
        i(1),
        parent = rep(1),
        i(2),
        child = rep(2),
        comp = f(function()
          return to_pascal_case(vim.fn.expand "%:t:r")
        end),
      }
    )
  ),
  s(
    "styled_base_ui_component",
    fmt(
      [[
      import {{ {} as BaseUI{parent} }} from "@base-ui-components/react";
      import clsx from "clsx";
      import styles from "{}";

      export declare namespace {comp} {{
        export interface Props extends BaseUI{parent}.{}.Props {{}}
      }}

      export function {comp}({{ className, ...rest }}: {comp}.Props) {{
        return <BaseUI{parent}.{child} className={{clsx(className, styles.{})}} {{...rest}} />;
      }}
      ]],
      {
        i(1),
        parent = rep(1),
        i(2),
        i(3),
        child = rep(3),
        i(4),
        comp = f(function()
          return to_pascal_case(vim.fn.expand "%:t:r")
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
