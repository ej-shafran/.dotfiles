-- Harpoon - a plugin for easily jumping between files

local function ui_create(cx)
  local function set(keymap, cb)
    vim.keymap.set("n", keymap, cb, { buffer = cx.bufnr })
  end

  set("<C-v>", function()
    require("harpoon").ui:select_menu_item { vsplit = true }
  end)
  set("<C-x>", function()
    require("harpoon").ui:select_menu_item { split = true }
  end)
  set("<C-t>", function()
    require("harpoon").ui:select_menu_item { tabedit = true }
  end)
end

---@type LazySpec
return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require "harpoon"
      harpoon:setup()
      harpoon:extend { UI_CREATE = ui_create }
    end,
  },
}
