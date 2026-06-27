-- plugins/lsp/lspconfig.lua
-- nvim 0.12 API: vim.lsp.config() + vim.lsp.enable()
-- require("lspconfig").xxx.setup() is deprecated since nvim-lspconfig v2,
-- will be removed in v3. This file uses only the built-in vim.lsp.* API.
--
-- Keymaps use LspAttach autocmd — cleaner than on_attach callbacks because:
--   1. Applies to EVERY server automatically (including auto-enabled ones)
--   2. Works correctly regardless of which server attaches first
--   3. No need to thread on_attach through every vim.lsp.config() call

local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_ok then return end

local capabilities = cmp_nvim_lsp.default_capabilities()

-- ── Keymaps: LspAttach autocmd ───────────────────────────────────────────
vim.api.nvim_create_autocmd("LspAttach", {
  group    = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local opts   = { noremap = true, silent = true, buffer = bufnr }
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
    end

    -- Navigation
    map("gf",  "<cmd>Lspsaga finder<CR>",                   "LSP: Find references")
    map("gd",  "<cmd>Lspsaga peek_definition<CR>",          "LSP: Peek definition")
    map("gD",  "<cmd>lua vim.lsp.buf.definition()<CR>",     "LSP: Go to definition")
    map("gi",  "<cmd>lua vim.lsp.buf.implementation()<CR>", "LSP: Go to implementation")
    map("gr",  "<cmd>lua vim.lsp.buf.references()<CR>",     "LSP: References")
    map("gt",  "<cmd>lua vim.lsp.buf.type_definition()<CR>","LSP: Type definition")

    -- Actions
    map("<leader>ca", "<cmd>Lspsaga code_action<CR>",  "LSP: Code actions")

    -- Diagnostics
    map("<leader>D",  "<cmd>Lspsaga show_line_diagnostics<CR>",   "LSP: Line diagnostics")
    map("<leader>d",  "<cmd>Lspsaga show_cursor_diagnostics<CR>", "LSP: Cursor diagnostics")
    map("[d",         "<cmd>Lspsaga diagnostic_jump_prev<CR>",    "LSP: Prev diagnostic")
    map("]d",         "<cmd>Lspsaga diagnostic_jump_next<CR>",    "LSP: Next diagnostic")

    -- Hover / outline
    map("K",          "<cmd>Lspsaga hover_doc<CR>",  "LSP: Hover docs")
    map("<leader>o",  "<cmd>LSoutlineToggle<CR>",     "LSP: Toggle outline")

    -- Signature help (insert mode)
    vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help,
      vim.tbl_extend("force", opts, { desc = "LSP: Signature help" }))

    -- TypeScript: organise imports
    if client and client.name == "ts_ls" then
      map("<leader>oi", function()
        vim.lsp.buf.execute_command({
          command   = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
        })
      end, "TS: Organise imports")
    end

    -- Xcode keymaps: only on Apple-platform filetypes (safe no-op on Debian)
    local ft = vim.bo[bufnr].filetype
    if ft == "swift" or ft == "objc" or ft == "objcpp" then
      map("<leader>xl", "<cmd>XcodebuildToggleLogs<cr>",            "Xcode: Toggle logs")
      map("<leader>xb", "<cmd>XcodebuildBuild<cr>",                 "Xcode: Build")
      map("<leader>xr", "<cmd>XcodebuildBuildRun<cr>",              "Xcode: Build & run")
      map("<leader>xt", "<cmd>XcodebuildTest<cr>",                  "Xcode: Run tests")
      map("<leader>xT", "<cmd>XcodebuildTestClass<cr>",             "Xcode: Test class")
      map("<leader>X",  "<cmd>XcodebuildPicker<cr>",                "Xcode: All actions")
      map("<leader>xd", "<cmd>XcodebuildSelectDevice<cr>",          "Xcode: Select device")
      map("<leader>xp", "<cmd>XcodebuildSelectTestPlan<cr>",        "Xcode: Test plan")
      map("<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>",    "Xcode: Toggle coverage")
    end
  end,
  desc = "Apply LSP keymaps on attach",
})

-- ── Diagnostic display ────────────────────────────────────────────────────
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

-- ── Server configurations ─────────────────────────────────────────────────
-- vim.lsp.config() merges WITH nvim-lspconfig's built-in lsp/ defaults.
-- We only need to add what differs from those defaults.

-- Simple servers: just add capabilities
for _, name in ipairs({ "ts_ls", "eslint", "html", "cssls", "kotlin_language_server" }) do
  vim.lsp.config(name, { capabilities = capabilities })
  vim.lsp.enable(name)
end

-- emmet_ls: trim filetypes to what we use
vim.lsp.config("emmet_ls", {
  capabilities = capabilities,
  filetypes    = {
    "html", "typescriptreact", "javascriptreact",
    "css", "sass", "scss", "less", "svelte", "php",
  },
})
vim.lsp.enable("emmet_ls")

-- tailwindcss: trim to common filetypes — eliminates 19 "unknown filetype" warnings
-- (the default includes astro-markdown, django-html, njk, slim, postcss, etc.)
vim.lsp.config("tailwindcss", {
  capabilities = capabilities,
  filetypes    = {
    "html", "css", "scss", "sass", "less",
    "javascript", "javascriptreact",
    "typescript", "typescriptreact",
    "svelte", "vue", "php",
  },
})
vim.lsp.enable("tailwindcss")

-- intelephense: PHP with stubs
vim.lsp.config("intelephense", {
  capabilities = capabilities,
  settings     = {
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
})
vim.lsp.enable("intelephense")

-- clangd: extra flags + restrict filetypes (removes c.doxygen/cpp.doxygen warnings)
vim.lsp.config("clangd", {
  capabilities = vim.tbl_deep_extend("force", capabilities, {
    offsetEncoding = { "utf-8" },
  }),
  cmd      = {
    "clangd", "--background-index", "--clang-tidy",
    "--completion-style=detailed", "--header-insertion=iwyu",
    "--suggest-missing-includes",
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
})
vim.lsp.enable("clangd")

-- lua_ls: vim globals + workspace
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings     = {
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
})
vim.lsp.enable("lua_ls")

-- sourcekit (Swift): macOS only — Xcode ships the binary
if vim.loop.os_uname().sysname == "Darwin" then
  vim.lsp.config("sourcekit", {
    capabilities = capabilities,
    filetypes    = { "swift", "objc", "objcpp" },
  })
  vim.lsp.enable("sourcekit")
end
