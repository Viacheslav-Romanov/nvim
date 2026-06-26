-- plugins/lint.lua — async linting via nvim-lint
-- Each linter is guarded by vim.fn.executable so a missing binary produces
-- no error (previously shellcheck absence caused E5108 via nvim-tree's BufEnter).
--
-- Install via Mason: eslint_d, phpstan, ktlint, cppcheck
-- Install via brew:  shellcheck  (brew install shellcheck)

local ok, lint = pcall(require, "lint")
if not ok then return end

-- Only register a linter when its binary is actually on PATH
local function available(linter_name)
  local linter = lint.linters[linter_name]
  if not linter then return false end
  local cmd = type(linter.cmd) == "string" and linter.cmd or linter_name
  return vim.fn.executable(cmd) == 1
end

local function ft_linters(...)
  local out = {}
  for _, name in ipairs({ ... }) do
    if available(name) then table.insert(out, name) end
  end
  return out
end

lint.linters_by_ft = {
  javascript      = ft_linters("eslint_d"),
  typescript      = ft_linters("eslint_d"),
  javascriptreact = ft_linters("eslint_d"),
  typescriptreact = ft_linters("eslint_d"),
  svelte          = ft_linters("eslint_d"),
  vue             = ft_linters("eslint_d"),
  php             = ft_linters("phpstan"),
  kotlin          = ft_linters("ktlint"),
  c               = ft_linters("cppcheck"),
  cpp             = ft_linters("cppcheck"),
  sh              = ft_linters("shellcheck"),
  bash            = ft_linters("shellcheck"),
}

-- eslint_d: only run when a config file exists in the project tree
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
