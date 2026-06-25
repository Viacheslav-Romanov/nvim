-- plugins/dap/dap.lua
-- DAP adapters installed/registered by mason-nvim-dap default handlers.
-- This file: UI, virtual text, signs, keymaps, TS config extension.

local dap_ok, dap = pcall(require, "dap")
if not dap_ok then return end

local dapui_ok, dapui = pcall(require, "dapui")
if not dapui_ok then return end

local vtext_ok, vtext = pcall(require, "nvim-dap-virtual-text")
if vtext_ok then
  vtext.setup({ enabled = true, highlight_changed_variables = true, all_frames = false })
end

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  layouts = {
    {
      elements = {
        { id = "scopes",      size = 0.33 },
        { id = "breakpoints", size = 0.17 },
        { id = "stacks",      size = 0.25 },
        { id = "watches",     size = 0.25 },
      },
      size = 0.30, position = "left",
    },
    {
      elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } },
      size = 0.27, position = "bottom",
    },
  },
  controls = {
    enabled = true, element = "repl",
    icons = {
      pause = "", play = "", step_into = "", step_over = "",
      step_out = "", run_last = "↺", terminate = "□", disconnect = "⏏",
    },
  },
  floating = { border = "rounded" },
})

dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end

vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticSignWarn"  })
vim.fn.sign_define("DapBreakpointRejected",  { text = "○", texthl = "DiagnosticSignInfo"  })
vim.fn.sign_define("DapLogPoint",            { text = "◎", texthl = "DiagnosticSignHint"  })
vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DiagnosticSignWarn", linehl = "DapStoppedLine" })

-- Extend JS configs from mason-nvim-dap to cover TS/JSX/TSX
vim.defer_fn(function()
  if dap.configurations.javascript then
    for _, lang in ipairs({ "typescript", "typescriptreact", "javascriptreact" }) do
      if not dap.configurations[lang] then
        dap.configurations[lang] = vim.deepcopy(dap.configurations.javascript)
      end
    end
  end
end, 100)

local km = vim.keymap.set
km("n", "<leader>db", dap.toggle_breakpoint,  { desc = "DAP: Toggle breakpoint" })
km("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Condition: "))
end, { desc = "DAP: Conditional breakpoint" })
km("n", "<leader>dl", function()
  dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
end, { desc = "DAP: Log point" })
km("n", "<leader>dc", dap.continue,           { desc = "DAP: Continue / Start" })
km("n", "<leader>ds", dap.step_over,          { desc = "DAP: Step over" })
km("n", "<leader>di", dap.step_into,          { desc = "DAP: Step into" })
km("n", "<leader>do", dap.step_out,           { desc = "DAP: Step out" })
km("n", "<leader>dq", dap.terminate,          { desc = "DAP: Terminate" })
km("n", "<leader>dr", dap.repl.open,          { desc = "DAP: Open REPL" })
km("n", "<leader>dL", dap.run_last,           { desc = "DAP: Re-run last" })
km("n", "<leader>du", dapui.toggle,           { desc = "DAP: Toggle UI" })
km("n", "<leader>de", function() dapui.eval(nil, { enter = true }) end, { desc = "DAP: Eval expression" })
km("n", "<leader>dw", require("dap.ui.widgets").hover, { desc = "DAP: Hover value" })
km("n", "<leader>dx", dap.clear_breakpoints,  { desc = "DAP: Clear all breakpoints" })
