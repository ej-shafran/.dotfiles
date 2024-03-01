local ls = require("luasnip")
local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
-- local rep = extras.rep
-- local p = extras.partial
-- local m = extras.match
-- local n = extras.nonempty
-- local dl = extras.dynamic_lambda
-- local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
-- local types = require("luasnip.util.types")
-- local parse = require("luasnip.util.parser").parse_snippet
-- local ms = ls.multi_snippet
-- local k = require("luasnip.nodes.key_indexer").new_key

ls.add_snippets("c", {
    s("header", {
        f(function()
            local header_name = vim.fn.expand("%:t:r")
            local header_id = "_" .. string.upper(header_name) .. "_H"

            return { "#ifndef " .. header_id, "#define " .. header_id, "", "" }
        end),
        i(0),
        f(function()
            local header_name = vim.fn.expand("%:t:r")
            local header_id = "_" .. string.upper(header_name) .. "_H"

            return { "", "", "#endif // " .. header_id }
        end),
    }),
    postfix(".cpy!", {
        i(1, "void *dest"),
        t(" = memcpy("),
        f(function(args)
            return args[1][1]
        end, { ai[1] }),
        l(", " .. l.POSTFIX_MATCH .. ", "),
        i(2, "size_t size"),
        t(")"),
    }),
    postfix(".realloc!", {
        l(l.POSTFIX_MATCH .. " = realloc(" .. l.POSTFIX_MATCH .. ", "),
        i(1, "size_t size"),
        t(")"),
    }),
    postfix(".free!", {
        l("free(" .. l.POSTFIX_MATCH .. ")"),
    }),
})
