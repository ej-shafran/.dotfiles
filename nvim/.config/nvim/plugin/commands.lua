local command = vim.api.nvim_create_user_command

command("LazyReloadPlugin", require("custom.pickers.lazy_reload_plugin").run, {})
command("RightAlign", "normal mc<count>A <esc>0<count>lDgelD`cP", { count = 80 })
