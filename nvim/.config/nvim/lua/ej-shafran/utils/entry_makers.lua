local M = {}

local entry_display = require("telescope.pickers.entry_display")
local devicons = require("nvim-web-devicons")

local fnamemodify = vim.fn.fnamemodify

local file_displayer = entry_display.create({
    separator = " ",
    items = {
        { width = 2 },
        { remaining = true },
        { remaining = true },
    },
})

local plugin_displayer = entry_display.create({
    separator = " ",
    items = {
        { remaining = true },
        { remaining = true },
    },
})

function M.file_entry_maker(path)
    local file_name = fnamemodify(path, ":t")
    local file_root = path:find("/") == nil and "" or (fnamemodify(path, ":h") .. "/")
    local file_ext = fnamemodify(path, ":e")

    local icons, highlight = devicons.get_icon(path, file_ext, { default = true })

    return {
        value = path,
        ordinal = path,
        display = function()
            return file_displayer({
                { icons, highlight },
                file_name,
                { file_root, "Comment" },
            })
        end,
    }
end

function M.plugin_entry_maker(plugin)
    local result = vim.fn.split(plugin[1], "/")
    local author = result[1]
    local name = result[2]

    return {
        value = { author = author, name = name },
        ordinal = name,
        display = function()
            return plugin_displayer({
                name,
                { author, "Comment" },
            })
        end,
    }
end
return M
