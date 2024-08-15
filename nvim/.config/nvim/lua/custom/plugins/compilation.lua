-- Compilation mode, like in Emacs

---@type LazySpec
return {
  {
    "ej-shafran/compile-mode.nvim",
    branch = "nightly",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "m00qek/baleia.nvim", tag = "v1.3.0" },
    },
    event = "VeryLazy",
    cmd = { "Compile", "Recompile" },
    config = function()
      local compile_mode = require "compile-mode"

      ---@type CompileModeOpts
      vim.g.compile_mode = {
        baleia_setup = true,
        default_command = "",
        error_regexp_table = {
          nodejs = {
            regex = "^\\s\\+at .\\+ (\\(\\/.\\+\\):\\([1-9][0-9]*\\):\\([1-9][0-9]*\\))$",
            filename = 1,
            row = 2,
            col = 3,
          },
          typescript = {
            regex = "^\\(.\\+\\)(\\([1-9][0-9]*\\),\\([1-9][0-9]*\\)): error TS[1-9][0-9]*:",
            filename = 1,
            row = 2,
            col = 3,
          },
          gradlew = {
            regex = "^e:\\s\\+file://\\(.\\+\\):\\(\\d\\+\\):\\(\\d\\+\\) ",
            filename = 1,
            row = 2,
            col = 3,
          },
          ls_lint = {
            regex = "\\v^\\d{4}/\\d{2}/\\d{2} \\d{2}:\\d{2}:\\d{2} (.+) failed for rules: .+$",
            filename = 1,
          },
          sass = {
            regex = "\\s\\+\\(.\\+\\) \\(\\d\\+\\):\\(\\d\\+\\)  .*$",
            filename = 1,
            row = 2,
            col = 3,
            type = compile_mode.level.WARNING,
          },
        },
      }
    end,
  },
}
