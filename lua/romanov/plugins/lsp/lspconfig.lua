-- plugins/lsp/lspconfig.lua
-- Uses vim.lsp.config / vim.lsp.enable (nvim 0.11+).
-- rust_analyzer: managed by rustaceanvim — do NOT add here.
-- sourcekit: macOS-only (Xcode ships it; not available on Debian).

local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_ok then return end

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
  map("<leader>rn", "<cmd>Lspsaga rename<CR>",            "LSP: Rename symbol")
  map("<leader>D",  "<cmd>Lspsaga show_line_diagnostics<CR>",   "LSP: Line diagnostics")
  map("<leader>d",  "<cmd>Lspsaga show_cursor_diagnostics<CR>", "LSP: Cursor diagnostics")
  map("[d",  "<cmd>Lspsaga diagnostic_jump_prev<CR>",     "LSP: Prev diagnostic")
  map("]d",  "<cmd>Lspsaga diagnostic_jump_next<CR>",     "LSP: Next diagnostic")
  map("K",   "<cmd>Lspsaga hover_doc<CR>",                "LSP: Hover docs")
  map("<leader>o", "<cmd>LSoutlineToggle<CR>",            "LSP: Toggle outline")

  vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help,
    vim.tbl_extend("force", opts, { desc = "LSP: Signature help" }))

  if client.name == "ts_ls" then
    map("<leader>oi", function()
      vim.lsp.buf.execute_command({
        command   = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
      })
    end, "TS: Organise imports")
  end

  -- Xcode keymaps only on Apple-platform filetypes (safe on Debian: ft never matches)
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

local capabilities = cmp_nvim_lsp.default_capabilities()

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
  virtual_text     = { prefix = "●" },
  severity_sort    = true,
  float            = { border = "rounded", source = "always" },
  update_in_insert = false,
})

local servers = {
  ts_ls   = {},
  eslint  = {},
  html    = {},
  cssls   = {},
  tailwindcss = {},
  emmet_ls = {
    filetypes = {
      "html", "typescriptreact", "javascriptreact",
      "css", "sass", "scss", "less", "svelte", "php",
    },
  },
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
  kotlin_language_server = {},
  clangd = {
    cmd = {
      "clangd", "--background-index", "--clang-tidy",
      "--completion-style=detailed", "--header-insertion=iwyu",
      "--suggest-missing-includes",
    },
    filetypes = { "c", "cpp", "objc", "objcpp" },
  },
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

-- sourcekit (Swift): macOS only
if vim.loop.os_uname().sysname == "Darwin" then
  servers["sourcekit"] = { filetypes = { "swift", "objective-c", "objective-cpp" } }
end

for name, cfg in pairs(servers) do
  vim.lsp.config(name, vim.tbl_deep_extend("force", {
    capabilities = capabilities,
    on_attach    = on_attach,
  }, cfg))
  vim.lsp.enable(name)
end
