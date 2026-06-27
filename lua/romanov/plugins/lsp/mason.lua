-- plugins/lsp/mason.lua
-- NOTE: rust_analyzer omitted — rustaceanvim manages it automatically.
-- NOTE: sourcekit ships with Xcode, not available via Mason.

local mason_ok, mason = pcall(require, "mason")
if not mason_ok then return end

local mlsp_ok, mlsp = pcall(require, "mason-lspconfig")
if not mlsp_ok then return end

local mdap_ok, mdap = pcall(require, "mason-nvim-dap")
if not mdap_ok then return end

mason.setup({
  ui = {
    border = "rounded",
    icons  = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
  },
})

mlsp.setup({
  ensure_installed = {
    "ts_ls",           -- TypeScript / JavaScript
    "eslint",          -- ESLint language server
    "html", "cssls", "tailwindcss", "emmet_ls",
    "intelephense",    -- PHP (full PHP 8 + WordPress stubs)
    "kotlin_language_server",
    "clangd",          -- C / C++
    "lua_ls",
  },
  automatic_installation = true,
})

-- DAP adapters: default handlers register adapter + basic configs automatically.
mdap.setup({
  ensure_installed = {
    "codelldb",  -- Rust, C, C++ (LLDB-based)
    "php",       -- PHP (xdebug)
    "js",        -- JavaScript / TypeScript
    "kotlin",
  },
  automatic_installation = true,
  handlers = {},
})
