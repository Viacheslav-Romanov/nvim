-- plugins/lint.lua — async linting via nvim-lint
-- Linters to install via :Mason:
--   eslint_d, phpstan, ktlint, cppcheck, shellcheck

local ok, lint = pcall(require, "lint")
if not ok then return end

lint.linters_by_ft = {
  javascript      = { "eslint_d" },
  typescript      = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  svelte          = { "eslint_d" },
  vue             = { "eslint_d" },
  php             = { "phpstan" },
  kotlin          = { "ktlint" },
  c               = { "cppcheck" },
  cpp             = { "cppcheck" },
  sh              = { "shellcheck" },
  bash            = { "shellcheck" },
}

-- Only run eslint_d when an eslint config file exists in the project
lint.linters.eslint_d = vim.tbl_extend("force", lint.linters.eslint_d or {}, {
  condition = function(ctx)
    return vim.fs.find(
      {
        ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json",
        ".eslintrc.yaml", ".eslintrc.yml",
        "eslint.config.js", "eslint.config.cjs", "eslint.config.mjs",
      },
      { path = ctx.filename, upward = true }
    )[1] ~= nil
  end,
})

local lint_group = vim.api.nvim_create_augroup("NvimLint", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
  group    = lint_group,
  callback = function()
    if vim.bo.buftype == "" then lint.try_lint() end
  end,
  desc = "Run linter",
})

vim.keymap.set("n", "<leader>ml", lint.try_lint, { desc = "Run linter" })
