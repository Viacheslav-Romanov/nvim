local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
  return
end

treesitter.setup({
  -- Syntax highlighting
  highlight = {
    enable = true,
    -- Disable for large files to avoid slowdowns
    disable = function(_, buf)
      local max_filesize = 500 * 1024 -- 500 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },

  -- Indentation
  indent = { enable = true },

  -- Auto-close/rename HTML tags (nvim-ts-autotag)
  autotag = { enable = true },

  -- Ensure these parsers are always present
  ensure_installed = {
    "json",
    "javascript",
    "typescript",
    "tsx",
    "yaml",
    "html",
    "css",
    "markdown",
    "markdown_inline",
    "svelte",
    "graphql",
    "bash",
    "lua",
    "vim",
    "vimdoc", -- ADDED: replaces old "help" parser name
    "dockerfile",
    "gitignore",
    "kotlin",
    "swift",
    "c",
    "cpp",
    "python", -- ADDED: you have pylsp configured
    "regex",  -- ADDED: useful for syntax-aware regex editing
    "query",  -- ADDED: for editing treesitter queries themselves
  },

  auto_install = true,
})

-- IMPROVED: enable treesitter-based folding
-- Options.lua sets foldlevelstart = 99 so all folds start open.
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
