---@param str string
---@return string
local function to_pascal_case(str)
  str = str:gsub("([-_]%w)", function(s)
    return s:sub(2, 2):upper()
  end)
  return str:sub(1, 1):upper() .. str:sub(2, -1)
end

---@param str string
---@return string
local function to_camel_case(str)
  return str:sub(1, 1):lower() .. str:sub(2, -1)
end

return {
  s(
    "component",
    fmta(
      [[
      export declare namespace <comp> {
        export interface Props {
          <>
        }
      }

      export function <comp>({<>}: <comp>.Props) {
        <>

        return <>;
      }
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
    fmta(
      [[
      import clsx from "clsx";
      import styles from "<>";

      export declare namespace <comp> {
        export interface Props extends React.ComponentProps<<"<>">> {}
      }}

      export function <comp>({ className, ...rest }: <comp>.Props) {
        return <<<> className={clsx(className, styles.<>)} {...rest} />>;
      }

      <comp>.displayName = "<>";
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
    fmta(
      [[
      import { <> as BaseUI<parent> } from "@base-ui-components/react";

      export declare namespace <comp> {
        export interface Props extends BaseUI<parent>.<>.Props {}
      }

      export function <comp>(props: <comp>.Props) {
        return <<BaseUI<parent>.<child> {...props} />>;
      }
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
    fmta(
      [[
      import { <> as BaseUI<parent> } from "@base-ui-components/react";
      import clsx from "clsx";
      import styles from "<>";

      export declare namespace <comp> {
        export interface Props extends BaseUI<parent>.<>.Props {}
      }

      export function <comp>({ className, ...rest }: <comp>.Props) {
        return <<BaseUI<parent>.<child> className={clsx(className, styles.<>)} {...rest} />>;
      }
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
      l(to_pascal_case(l._1), { 1 }),
      i(2),
    })
  ),

  s(
    "effect",
    fmta(
      [[
      useEffect(() =>> {
        <>
      }, [<>]);
      ]],
      {
        i(1),
        i(2),
      }
    )
  ),

  s(
    "context",
    fmta(
      [[
      import { createContextHook } from "@hilma/tools";
      import { createContext } from "react";

      export interface <>Context {
        <>
      }

      export const <camel>Context = createContext<<<Pascal>Context | null>>(null);
      <camel>Context.displayName = "<Pascal>";
      export const use<Pascal> = createContextHook(<camel>Context);
      ]],
      {
        i(1),
        i(0),
        Pascal = rep(1),
        camel = l(to_camel_case(l._1), { 1 }),
      }
    )
  ),
}
