-- plugins/lsp/rust.lua
-- Loaded via rustaceanvim's `init` function BEFORE the plugin loads.
-- Returns a plain table → vim.g.rustaceanvim.
-- Do NOT require("rustaceanvim.*") here — plugin not loaded yet.

local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
  end

  -- Standard LSP
  map("gf",  "<cmd>Lspsaga finder<CR>",                   "LSP: Find references")
  map("gd",  "<cmd>Lspsaga peek_definition<CR>",          "LSP: Peek definition")
  map("gD",  "<cmd>lua vim.lsp.buf.definition()<CR>",     "LSP: Go to definition")
  map("gi",  "<cmd>lua vim.lsp.buf.implementation()<CR>", "LSP: Go to implementation")
  map("gr",  "<cmd>lua vim.lsp.buf.references()<CR>",     "LSP: References")
  map("<leader>ca", "<cmd>Lspsaga code_action<CR>",       "LSP: Code actions")
  map("<leader>rn", "<cmd>Lspsaga rename<CR>",            "LSP: Rename symbol")
  map("<leader>D",  "<cmd>Lspsaga show_line_diagnostics<CR>",   "LSP: Line diagnostics")
  map("<leader>d",  "<cmd>Lspsaga show_cursor_diagnostics<CR>", "LSP: Cursor diagnostics")
  map("[d",  "<cmd>Lspsaga diagnostic_jump_prev<CR>",     "LSP: Prev diagnostic")
  map("]d",  "<cmd>Lspsaga diagnostic_jump_next<CR>",     "LSP: Next diagnostic")
  map("K",   "<cmd>Lspsaga hover_doc<CR>",                "LSP: Hover docs")

  -- Rust-specific
  map("<leader>rr", "<cmd>RustLsp runnables<CR>",    "Rust: Runnables")
  map("<leader>rt", "<cmd>RustLsp testables<CR>",    "Rust: Testables")
  map("<leader>rd", "<cmd>RustLsp debuggables<CR>",  "Rust: Debuggables")
  map("<leader>re", "<cmd>RustLsp expandMacro<CR>",  "Rust: Expand macro")
  map("<leader>rc", "<cmd>RustLsp openCargo<CR>",    "Rust: Open Cargo.toml")
  map("<leader>rp", "<cmd>RustLsp parentModule<CR>", "Rust: Go to parent module")
  map("<leader>rk", "<cmd>RustLsp moveItem up<CR>",  "Rust: Move item up")
  map("<leader>rj", "<cmd>RustLsp moveItem down<CR>","Rust: Move item down")
  map("<leader>rh", "<cmd>RustLsp hover actions<CR>","Rust: Hover actions")
end

return {
  tools = {
    hover_actions    = { auto_focus = true },
    float_win_config = { border = "rounded" },
  },
  server = {
    on_attach = on_attach,
    default_settings = {
      ["rust-analyzer"] = {
        checkOnSave = { command = "clippy", extraArgs = { "--all-targets" } },
        cargo       = { allFeatures = true, loadOutDirsFromCheck = true },
        procMacro   = { enable = true },
        inlayHints  = {
          lifetimeElisionHints = { enable = "skip_trivial" },
          typeHints            = { enable = true },
          parameterHints       = { enable = true },
        },
      },
    },
  },
  -- dap: omitted — rustaceanvim auto-detects codelldb from mason
}
