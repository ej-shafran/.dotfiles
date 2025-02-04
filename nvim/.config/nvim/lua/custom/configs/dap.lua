local dap = require "dap"
local dapui = require "dapui"
local virtual_text = require "nvim-dap-virtual-text"

dapui.setup()
virtual_text.setup {}

dap.adapters.lldb = {
  id = "lldb",
  type = "executable",
  command = "lldb-dap",
  args = {},
}

dap.adapters.gdb = {
  id = "gdb",
  type = "executable",
  command = "gdb",
  args = { "--quiet", "--interpreter=dap" },
}

dap.configurations.c = {
  {
    name = "Run executable (GDB)",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
  },
  {
    name = "Run executable with arguments (GDB)",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    args = function()
      return vim.split(vim.fn.input "Arguments: ", " +")
    end,
    cwd = "${workspaceFolder}",
  },
  {
    name = "Attach to process (GDB)",
    type = "gdb",
    request = "attach",
    pid = require("dap.utils").pick_process,
  },
  {
    name = "Run executable (LLDB)",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
  },
  {
    name = "Run executable with arguments (LLDB)",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    args = function()
      return vim.split(vim.fn.input "Arguments: ", " +")
    end,
    cwd = "${workspaceFolder}",
  },
  {
    name = "Attach to process (LLDB)",
    type = "lldb",
    request = "attach",
    pid = require("dap.utils").pick_process,
  },
}
dap.configurations.zig = dap.configurations.c

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end
