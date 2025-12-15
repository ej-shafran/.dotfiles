---@param str string
---@return string
local function to_pascal_case(str)
  str = str:gsub("([-_]%w)", function(s)
    return s:sub(2, 2):upper()
  end)
  return str:sub(1, 1):upper() .. str:sub(2, -1)
end

return {
  s(
    "query",
    fmta(
      [[
      import { useQuery, type QueryFunctionContext } from "@tanstack/react-query";
      import axios from "axios";

      function <>QueryKey(options: Use<Query>QueryOptions) {
          return [<>] as const;
      }
      type <Query>QueryKey = ReturnType<<typeof <query>QueryKey>>;

      async function <><Query>({ signal, queryKey: [<>] }: QueryFunctionContext<<<Query>QueryKey>>) {
          const { data } = await axios.<method><<<>>>(<>);
          return data;
      }

      interface Use<Query>QueryOptions {
          <>
      }

      export function use<Query>Query(options: Use<Query>QueryOptions) {
          return useQuery({
              queryKey: <query>QueryKey(options),
              queryFn: <method><Query>,
              <>
          })
      }
      ]],
      {
        i(1, "query"),
	i(4, "/* Query key */"),
        i(2, "method"),
        i(5, "/* Destructured query key */"),
        i(6, "/* Data type */"),
        i(7, "/* URL and options */"),
        i(3, "// Option fields"),
        i(0, "// Other options"),
        query = rep(1),
        method = rep(2),
        Query = l(to_pascal_case(l._1), { 1 }),
      }
    )
  ),

  s(
    "infinitequery",
    fmta(
      [[
      import { useInfiniteQuery, type QueryFunctionContext } from "@tanstack/react-query";
      import axios from "axios";

      function <>QueryKey(options: Use<Query>QueryOptions) {
          return [<>] as const;
      }
      type <Query>QueryKey = ReturnType<<typeof <query>QueryKey>>;

      async function <><Query>({ signal, queryKey: [<>], pageParam }: QueryFunctionContext<<<Query>QueryKey, <>>>) {
          const { data } = await axios.<method><<<>>>(<>);
          return data;
      }

      interface Use<Query>QueryOptions {
          <>
      }

      export function use<Query>InfiniteQuery(options: Use<Query>QueryOptions) {
          return useInfiniteQuery({
              queryKey: <query>QueryKey(options),
	      initialPageParam: <>,
              queryFn: <method><Query>,
	      getNextPageParam: (lastPage, allPages) =>> <>,
              <>
          })
      }
      ]],
      {
        i(1, "query"),
	i(4, "/* Query key */"),
        i(2, "method"),
        i(5, "/* Destructured query key */"),
	i(6, "number"),
        i(7, "/* Data type */"),
        i(8, "/* URL and options */"),
        i(3, "// Option fields"),
        i(9, "0"),
        i(10, "undefined"),
        i(0, "// Other options"),
        query = rep(1),
        method = rep(2),
        Query = l(to_pascal_case(l._1), { 1 }),
      }
    )
  ),
}
