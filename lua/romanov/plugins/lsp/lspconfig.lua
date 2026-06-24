-- lspconfig.lua
-- Uses vim.lsp.config / vim.lsp.enable (nvim 0.11+) instead of the deprecated
-- require('lspconfig')[server].setup() call. nvim-lspconfig v3 will remove the old API.
--
-- nvim-lspconfig is still needed as a dependency — it ships the default server
-- configurations (cmd, root_dir, filetypes, etc.) that vim.lsp.config inherits.

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
  return
end

local keymap = vim.keymap

-- ── Keybinds active only when an LSP attaches to a buffer ─────────────────
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local function map(lhs, rhs, desc)
    keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
  end

  -- Navigation
  map("gf",         "<cmd>Lspsaga finder<CR>",                   "LSP: Find references")
  map("gd",         "<cmd>Lspsaga peek_definition<CR>",          "LSP: Peek definition")
  map("gD",         "<cmd>lua vim.lsp.buf.definition()<CR>",     "LSP: Go to definition")
  map("gi",         "<cmd>lua vim.lsp.buf.implementation()<CR>", "LSP: Go to implementation")
  map("gr",         "<cmd>lua vim.lsp.buf.references()<CR>",     "LSP: References")

  -- Code actions / rename
  map("<leader>ca", "<cmd>Lspsaga code_action<CR>",              "LSP: Code actions")
  map("<leader>rn", "<cmd>Lspsaga rename<CR>",                   "LSP: Rename symbol")

  -- Diagnostics
  map("<leader>D",  "<cmd>Lspsaga show_line_diagnostics<CR>",    "LSP: Line diagnostics")
  map("<leader>d",  "<cmd>Lspsaga show_cursor_diagnostics<CR>",  "LSP: Cursor diagnostics")
  map("[d",         "<cmd>Lspsaga diagnostic_jump_prev<CR>",     "LSP: Prev diagnostic")
  map("]d",         "<cmd>Lspsaga diagnostic_jump_next<CR>",     "LSP: Next diagnostic")

  -- Hover / outline
  map("K",          "<cmd>Lspsaga hover_doc<CR>",                "LSP: Hover docs")
  map("<leader>o",  "<cmd>LSoutlineToggle<CR>",                  "LSP: Toggle outline")

  -- Xcodebuild keymaps
  map("<leader>xl", "<cmd>XcodebuildToggleLogs<cr>",              "Xcode: Toggle logs")
  map("<leader>xb", "<cmd>XcodebuildBuild<cr>",                   "Xcode: Build")
  map("<leader>xr", "<cmd>XcodebuildBuildRun<cr>",                "Xcode: Build & run")
  map("<leader>xt", "<cmd>XcodebuildTest<cr>",                    "Xcode: Run tests")
  map("<leader>xT", "<cmd>XcodebuildTestClass<cr>",               "Xcode: Run test class")
  map("<leader>X",  "<cmd>XcodebuildPicker<cr>",                  "Xcode: All actions")
  map("<leader>xd", "<cmd>XcodebuildSelectDevice<cr>",            "Xcode: Select device")
  map("<leader>xp", "<cmd>XcodebuildSelectTestPlan<cr>",          "Xcode: Select test plan")
  map("<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>",      "Xcode: Toggle coverage")
  map("<leader>xC", "<cmd>XcodebuildShowCodeCoverageReport<cr>",  "Xcode: Coverage report")
  map("<leader>xq", "<cmd>Telescope quickfix<cr>",                "Xcode: QuickFix list")

  -- TypeScript: organise imports via native LSP execute command
  if client.name == "ts_ls" then
    map("<leader>oi", function()
      vim.lsp.buf.execute_command({
        command   = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
      })
    end, "TS: Organise imports")
  end
end

-- ── Capabilities ──────────────────────────────────────────────────────────
local capabilities = cmp_nvim_lsp.default_capabilities()

-- ── Diagnostic signs & display ────────────────────────────────────────────
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
  virtual_text  = { prefix = "●" },
  severity_sort = true,
  float         = { border = "rounded", source = "always" },
})

-- ── Register configs with the new vim.lsp.config API ──────────────────────
-- vim.lsp.config(name, cfg) merges cfg with the defaults shipped by nvim-lspconfig.
-- vim.lsp.enable(name) activates the server for matching filetypes.

local servers = {
  ts_ls     = {},
  html      = {},
  cssls     = {},
  tailwindcss = {},
  emmet_ls  = {
    filetypes = { "html", "typescriptreact", "javascriptreact", "css",
                  "sass", "scss", "less", "svelte" },
  },
  lua_ls    = {
    settings = {
      Lua = {
        diagnostics  = { globals = { "vim" } },
        workspace    = {
          library      = {
            [vim.fn.expand("$VIMRUNTIME/lua")]          = true,
            [vim.fn.stdpath("config") .. "/lua"]        = true,
          },
          checkThirdParty = false,
        },
        telemetry    = { enable = false },
      },
    },
  },
  kotlin_language_server = {},
  clangd    = {},
  pylsp     = {},
  sourcekit = {},  -- ships with Xcode, no mason install needed
}

for name, cfg in pairs(servers) do
  vim.lsp.config(name, vim.tbl_deep_extend("force", {
    capabilities = capabilities,
    on_attach    = on_attach,
  }, cfg))
  vim.lsp.enable(name)
end
