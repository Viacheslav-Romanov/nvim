local setup, null_ls = pcall(require, "null-ls")
if not setup then
  return
end

local formatting  = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local augroup     = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
  sources = {
    formatting.prettier,
    formatting.stylua,

    -- IMPROVED: also detect eslint.config.js / .eslintrc.json / .eslintrc.cjs
    require("none-ls.diagnostics.eslint_d").with({
      condition = function(utils)
        return utils.root_has_file({
          ".eslintrc.js",
          ".eslintrc.cjs",
          ".eslintrc.json",
          ".eslintrc.yaml",
          ".eslintrc.yml",
          "eslint.config.js",
          "eslint.config.cjs",
          "eslint.config.mjs",
        })
      end,
    }),
  },

  -- Format on save
  on_attach = function(current_client, bufnr)
    if current_client:supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group    = augroup,
        buffer   = bufnr,
        callback = function()
          vim.lsp.buf.format({
            -- Only use null-ls for formatting (not the language server itself)
            filter = function(client)
              return client.name == "null-ls"
            end,
            bufnr   = bufnr,
            timeout_ms = 3000, -- IMPROVED: give formatter a bit more time
          })
        end,
      })
    end
  end,
})
