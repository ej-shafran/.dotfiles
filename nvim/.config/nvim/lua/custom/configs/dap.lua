local dap = require "dap"
local dapui = require "dapui"
local virtual_text = require "nvim-dap-virtual-text"

local has_lldb_dap = vim.fn.executable "lldb-dap" ~= 0
local has_gdb = vim.fn.executable "gdb" ~= 0

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

dap.configurations.c = {}

if has_gdb then
  table.insert(dap.configurations.c, {
    name = "Run executable (GDB)",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
  })
  table.insert(dap.configurations.c, {
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
  })
  table.insert(dap.configurations.c, {
    name = "Attach to process (GDB)",
    type = "gdb",
    request = "attach",
    pid = require("dap.utils").pick_process,
  })
end

if has_lldb_dap then
  table.insert(dap.configurations.c, {
    name = "Run executable (LLDB)",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
  })
  table.insert(dap.configurations.c, {
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
  })
  table.insert(dap.configurations.c, {
    name = "Attach to process (LLDB)",
    type = "lldb",
    request = "attach",
    pid = require("dap.utils").pick_process,
  })
end

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
