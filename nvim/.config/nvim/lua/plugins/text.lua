---@type LazySpec[]
return {
    -- {{{ Better indentation options
    "tpope/vim-sleuth",
    -- }}}

    -- {{{ Deal with word variants
    {
        "tpope/vim-abolish",
        config = function()
            local abolishes = {
                { "{despa,sepe}rat{e,es,ed,ing,ely,ion,ions,or}", "{despe,sepa}rat{}" },
                { "afterword{,s}", "afterward{}" },
                { "anomol{y,ies}", "anomal{}" },
                { "austrail{a,an,ia,ian}", "austral{ia,ian}" },
                { "cal{a,e}nder{,s}", "cal{e}ndar{}" },
                { "{c,m}arraige{,s}", "{}arriage{}" },
                { "{,in}consistan{cy,cies,t,tly}", "{}consisten{}" },
                { "destionation{,s}", "destination{}" },
                { "delimeter{,s}", "delimiter{}" },
                { "{,non}existan{ce,t}", "{}existen{}" },
                { "despara{te,tely,tion}", "despera{}" },
                { "d{e,i}screp{e,a}nc{y,ies}", "d{i}screp{a}nc{}" },
                { "euphamis{m,ms,tic,tically}", "euphemis{}" },
                { "hense", "hence" },
                { "{,re}impliment{,s,ing,ed,ation}", "{}implement{}" },
                { "improvment{,s}", "improvement{}" },
                { "inherant{,ly}", "inherent{}" },
                { "lastest", "latest" },
                { "{les,compar,compari}sion{,s}", "{les,compari,compari}son{}" },
                { "{,un}nec{ce,ces,e}sar{y,ily}", "{}nec{es}sar{}" },
                { "{,un}orgin{,al}", "{}origin{}" },
                { "persistan{ce,t,tly}", "persisten{}" },
                { "referesh{,es}", "refresh{}" },
                { "{,ir}releven{ce,cy,t,tly}", "{}relevan{}" },
                { "rec{co,com,o}mend{,s,ed,ing,ation}", "rec{om}mend{}" },
                { "reproducable", "reproducible" },
                { "resouce{,s}", "resource{}" },
                { "restraunt{,s}", "restaurant{}" },
                { "seperat{e,es,ed,ing,ely,ion,ions,or}", "separat{}" },
                { "reciev{e,ed,es,ing}", "receiv{}" },
            }

            for _, abolish in ipairs(abolishes) do
                vim.cmd("Abolish " .. abolish[1] .. " " .. abolish[2])
            end
        end,
    },
    -- }}}

    -- {{{ Swap things around
    {
        "gbprod/substitute.nvim",
        event = "VeryLazy",
        config = true,
    },
    -- }}}

    -- {{{ Surround things
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = true,
    },
    -- }}}

    -- {{{ Align things
    {
        "echasnovski/mini.align",
        version = "*",
        opts = {},
    },
    -- }}}
}

-- vim: foldmethod=marker
