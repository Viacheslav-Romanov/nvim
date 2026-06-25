-- plugins/conform.lua — format on save (replaces none-ls)
-- Formatters to install via :Mason:
--   prettier/prettierd, stylua, clang-format, ktfmt, php-cs-fixer, shfmt
-- rustfmt ships with rustup; swiftformat via: brew install swiftformat

local ok, conform = pcall(require, "conform")
if not ok then return end

conform.setup({
  formatters_by_ft = {
    javascript      = { "prettierd", "prettier", stop_after_first = true },
    typescript      = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    svelte          = { "prettierd", "prettier", stop_after_first = true },
    vue             = { "prettierd", "prettier", stop_after_first = true },
    html            = { "prettierd", "prettier", stop_after_first = true },
    css             = { "prettierd", "prettier", stop_after_first = true },
    scss            = { "prettierd", "prettier", stop_after_first = true },
    json            = { "prettierd", "prettier", stop_after_first = true },
    jsonc           = { "prettierd", "prettier", stop_after_first = true },
    yaml            = { "prettierd", "prettier", stop_after_first = true },
    markdown        = { "prettierd", "prettier", stop_after_first = true },
    php             = { "php_cs_fixer" },
    kotlin          = { "ktfmt" },
    swift           = { "swiftformat" },
    rust            = { "rustfmt" },
    c               = { "clang_format" },
    cpp             = { "clang_format" },
    lua             = { "stylua" },
    sh              = { "shfmt" },
    bash            = { "shfmt" },
  },

  format_on_save = function(bufnr)
    if vim.g.disable_autoformat then return nil end
    local ok2, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
    if ok2 and stats and stats.size > 500 * 1024 then return nil end
    if vim.api.nvim_buf_get_name(bufnr):match("^/tmp/") then return nil end
    return { timeout_ms = 3000, lsp_fallback = true }
  end,

  formatters = {
    stylua = {
      prepend_args = function(_, ctx)
        local cfg = vim.fn.findfile("stylua.toml", ctx.dirname .. ";")
        return cfg ~= "" and { "--config-path", cfg } or {}
      end,
    },
    clang_format = {
      prepend_args = function(_, ctx)
        local cfg = vim.fn.findfile(".clang-format", ctx.dirname .. ";")
        return cfg == "" and { "--style=LLVM" } or {}
      end,
    },
    ktfmt = { prepend_args = { "--google-style" } },
  },

  notify_on_error = true,
})

vim.g.disable_autoformat = false

vim.keymap.set({ "n", "v" }, "<leader>mp", function()
  conform.format({ lsp_fallback = true, async = false, timeout_ms = 3000 })
end, { desc = "Format file / selection" })

vim.keymap.set("n", "<leader>tf", function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify(
    "Format on save: " .. (vim.g.disable_autoformat and "OFF" or "ON"),
    vim.log.levels.INFO, { title = "conform.nvim" }
  )
end, { desc = "Toggle format-on-save" })
