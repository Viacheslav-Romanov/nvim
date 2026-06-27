-- plugins/lsp/lspconfig.lua
-- Uses the traditional require("lspconfig").xxx.setup() API so that configs
-- are available at checkhealth time regardless of lazy-load order.
-- vim.lsp.config()/vim.lsp.enable() (new nvim 0.12 built-in API) requires
-- eager execution; lspconfig.setup() handles timing correctly on its own.
--
-- rust_analyzer: managed by rustaceanvim — do NOT add here.
-- sourcekit: macOS-only, conditionally registered at the bottom.

local lsp_ok, lspconfig = pcall(require, "lspconfig")
if not lsp_ok then return end

local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_ok then return end

-- ── Shared on_attach ─────────────────────────────────────────────────────
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
  end

  map("gf",  "<cmd>Lspsaga finder<CR>",                   "LSP: Find references")
  map("gd",  "<cmd>Lspsaga peek_definition<CR>",          "LSP: Peek definition")
  map("gD",  "<cmd>lua vim.lsp.buf.definition()<CR>",     "LSP: Go to definition")
  map("gi",  "<cmd>lua vim.lsp.buf.implementation()<CR>", "LSP: Go to implementation")
  map("gr",  "<cmd>lua vim.lsp.buf.references()<CR>",     "LSP: References")
  map("gt",  "<cmd>lua vim.lsp.buf.type_definition()<CR>","LSP: Type definition")
  map("<leader>ca", "<cmd>Lspsaga code_action<CR>",       "LSP: Code actions")
  -- <leader>rn: global inc-rename binding in plugins/inc-rename.lua (expr=true)
  map("<leader>D",  "<cmd>Lspsaga show_line_diagnostics<CR>",   "LSP: Line diagnostics")
  map("<leader>d",  "<cmd>Lspsaga show_cursor_diagnostics<CR>", "LSP: Cursor diagnostics")
  map("[d",  "<cmd>Lspsaga diagnostic_jump_prev<CR>",     "LSP: Prev diagnostic")
  map("]d",  "<cmd>Lspsaga diagnostic_jump_next<CR>",     "LSP: Next diagnostic")
  map("K",   "<cmd>Lspsaga hover_doc<CR>",                "LSP: Hover docs")
  map("<leader>o", "<cmd>LSoutlineToggle<CR>",            "LSP: Toggle outline")

  vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help,
    vim.tbl_extend("force", opts, { desc = "LSP: Signature help" }))

  -- TypeScript: organise imports
  if client.name == "ts_ls" then
    map("<leader>oi", function()
      vim.lsp.buf.execute_command({
        command   = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
      })
    end, "TS: Organise imports")
  end

  -- Xcode keymaps only on Apple-platform filetypes (safe on Debian)
  local ft = vim.bo[bufnr].filetype
  if ft == "swift" or ft == "objc" or ft == "objcpp" then
    map("<leader>xl", "<cmd>XcodebuildToggleLogs<cr>",             "Xcode: Toggle logs")
    map("<leader>xb", "<cmd>XcodebuildBuild<cr>",                  "Xcode: Build")
    map("<leader>xr", "<cmd>XcodebuildBuildRun<cr>",               "Xcode: Build & run")
    map("<leader>xt", "<cmd>XcodebuildTest<cr>",                   "Xcode: Run tests")
    map("<leader>xT", "<cmd>XcodebuildTestClass<cr>",              "Xcode: Test class")
    map("<leader>X",  "<cmd>XcodebuildPicker<cr>",                 "Xcode: All actions")
    map("<leader>xd", "<cmd>XcodebuildSelectDevice<cr>",           "Xcode: Select device")
    map("<leader>xp", "<cmd>XcodebuildSelectTestPlan<cr>",         "Xcode: Test plan")
    map("<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>",     "Xcode: Toggle coverage")
  end
end

-- ── Capabilities ─────────────────────────────────────────────────────────
local capabilities = cmp_nvim_lsp.default_capabilities()

-- ── Diagnostic display ───────────────────────────────────────────────────
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  vim.fn.sign_define("DiagnosticSign" .. type,
    { text = icon, texthl = "DiagnosticSign" .. type, numhl = "" })
end

vim.diagnostic.config({
  virtual_text     = { prefix = "●" },
  severity_sort    = true,
  float            = { border = "rounded", source = "always" },
  update_in_insert = false,
})

-- ── Server definitions ────────────────────────────────────────────────────
local servers = {
  -- JavaScript / TypeScript
  ts_ls  = {},
  eslint = {},

  -- Web
  html        = {},
  cssls       = {},
  tailwindcss = {},
  emmet_ls    = {
    filetypes = {
      "html", "typescriptreact", "javascriptreact",
      "css", "sass", "scss", "less", "svelte", "php",
    },
  },

  -- PHP
  intelephense = {
    settings = {
      intelephense = {
        stubs = {
          "apache", "bcmath", "bz2", "calendar", "Core", "ctype", "curl",
          "date", "dom", "exif", "fileinfo", "filter", "gd", "hash", "iconv",
          "intl", "json", "mbstring", "mysqli", "openssl", "pcre", "PDO",
          "pdo_mysql", "pgsql", "Phar", "posix", "readline", "Reflection",
          "session", "SimpleXML", "SPL", "sqlite3", "standard", "tokenizer",
          "xml", "xmlreader", "xmlwriter", "xsl", "zip", "zlib", "wordpress",
        },
        diagnostics = { enable = true },
        format      = { enable = false },
      },
    },
  },

  -- Kotlin
  kotlin_language_server = {},

  -- C / C++
  clangd = {
    cmd = {
      "clangd", "--background-index", "--clang-tidy",
      "--completion-style=detailed", "--header-insertion=iwyu",
      "--suggest-missing-includes",
    },
    filetypes = { "c", "cpp", "objc", "objcpp" },
  },

  -- Lua (for editing this config)
  lua_ls = {
    settings = {
      Lua = {
        diagnostics  = { globals = { "vim" } },
        workspace    = {
          library         = {
            [vim.fn.expand("$VIMRUNTIME/lua")]   = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
          checkThirdParty = false,
        },
        telemetry = { enable = false },
        format    = { enable = false },
      },
    },
  },
}

-- ── Apply shared config and setup each server ─────────────────────────────
for name, cfg in pairs(servers) do
  lspconfig[name].setup(vim.tbl_deep_extend("force", {
    on_attach    = on_attach,
    capabilities = capabilities,
  }, cfg))
end

-- sourcekit (Swift): macOS only — Xcode ships it, not available on Debian
if vim.loop.os_uname().sysname == "Darwin" then
  lspconfig.sourcekit.setup({
    on_attach    = on_attach,
    capabilities = capabilities,
    filetypes    = { "swift", "objc", "objcpp" },
  })
end
