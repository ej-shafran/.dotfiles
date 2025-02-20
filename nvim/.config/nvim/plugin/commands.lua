local command = vim.api.nvim_create_user_command

command("LazyReloadPlugin", require("custom.pickers.lazy_reload_plugin").run, {})
command("Gitmoji", require("custom.pickers.gitmoji_commit").run, {})
command("RightAlign", "normal mc<count>A <esc>0<count>lDgelD`cP", { count = 80 })
command("DebugHighlights", require("custom.commands.debug_highlights").toggle, {})
command("AutoformatToggle", function(args)
  if args.bang then
    vim.g.disable_autoformat = not vim.g.disable_autoformat
  else
    vim.b.disable_autoformat = not vim.b.disable_autoformat
  end
end, {
  bang = true,
})
