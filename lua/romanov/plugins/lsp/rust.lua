-- plugins/lsp/rust.lua
-- Returned as vim.g.rustaceanvim (set in plugins-setup.lua init function).
-- Standard LSP keymaps (gd, K, [d, etc.) are now handled by the global
-- LspAttach autocmd in lspconfig.lua — no need to repeat them here.
-- This file only adds Rust-specific rustaceanvim commands.

local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
  end

  -- Rust-specific (rustaceanvim only — not available from plain LSP)
  map("<leader>rr", "<cmd>RustLsp runnables<CR>",    "Rust: Runnables")
  map("<leader>rt", "<cmd>RustLsp testables<CR>",    "Rust: Testables")
  map("<leader>rd", "<cmd>RustLsp debuggables<CR>",  "Rust: Debuggables")
  map("<leader>re", "<cmd>RustLsp expandMacro<CR>",  "Rust: Expand macro")
  map("<leader>rc", "<cmd>RustLsp openCargo<CR>",    "Rust: Open Cargo.toml")
  map("<leader>rp", "<cmd>RustLsp parentModule<CR>", "Rust: Go to parent module")
  map("<leader>rk", "<cmd>RustLsp moveItem up<CR>",  "Rust: Move item up")
  map("<leader>rj", "<cmd>RustLsp moveItem down<CR>","Rust: Move item down")
  map("<leader>rh", "<cmd>RustLsp hover actions<CR>","Rust: Hover actions")
  -- <leader>rn: handled globally by inc-rename.lua (expr=true)
  -- gd, K, [d, ]d, etc.: handled by LspAttach autocmd in lspconfig.lua
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
        checkOnSave = true,
        check = {
          command   = "clippy",
          extraArgs = { "--all-targets" },
        },
        cargo = {
          allFeatures          = true,
          loadOutDirsFromCheck = true,
        },
        procMacro = { enable = true },
        inlayHints = {
          lifetimeElisionHints = { enable = "skip_trivial" },
          typeHints            = { enable = true },
          parameterHints       = { enable = true },
        },
      },
    },
  },
}
