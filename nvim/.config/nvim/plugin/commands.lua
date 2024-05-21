local command = vim.api.nvim_create_user_command

command("LazyReloadPlugin", require("custom.pickers.lazy_reload_plugin").run, {})
