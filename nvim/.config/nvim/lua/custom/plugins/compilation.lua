-- Compilation mode, like in Emacs

---@type LazySpec
return {
  {
    "ej-shafran/compile-mode.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "m00qek/baleia.nvim", tag = "v1.3.0" },
    },
    event = "VeryLazy",
    cmd = { "Compile", "Recompile" },
    config = function()
      ---@module "compile-mode"

      ---@type CompileModeOpts
      vim.g.compile_mode = {
        same_window_errors = true,
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
          certain = {
            regex = "\\v^\\s+FAILED: (.+):(\\d+): ",
            filename = 1,
            row = 2,
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
            type = 1,
          },
        },
      }
    end,
  },
}
