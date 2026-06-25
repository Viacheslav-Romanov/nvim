-- plugins/treesitter.lua
local ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not ok then return end

treesitter.setup({
  ensure_installed = {
    "lua", "vim", "vimdoc", "regex", "query",
    "javascript", "typescript", "tsx", "html", "css", "json", "jsonc", "yaml",
    "graphql", "svelte",
    "php", "phpdoc",
    "rust", "c", "cpp",
    "kotlin", "java",
    "swift",
    "bash", "python",
    "markdown", "markdown_inline", "dockerfile", "gitignore", "toml",
    "comment",
  },
  auto_install = true,
  highlight = {
    enable  = true,
    disable = function(_, buf)
      local ok2, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      return ok2 and stats and stats.size > 500 * 1024
    end,
  },
  indent  = { enable = true },
  autotag = { enable = true },

  textobjects = {
    select = {
      enable    = true,
      lookahead = true,
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "outer function" },
        ["if"] = { query = "@function.inner", desc = "inner function" },
        ["ac"] = { query = "@class.outer",    desc = "outer class" },
        ["ic"] = { query = "@class.inner",    desc = "inner class" },
        ["aa"] = { query = "@parameter.outer",desc = "outer argument" },
        ["ia"] = { query = "@parameter.inner",desc = "inner argument" },
        ["al"] = { query = "@loop.outer",     desc = "outer loop" },
        ["il"] = { query = "@loop.inner",     desc = "inner loop" },
        ["ai"] = { query = "@conditional.outer", desc = "outer conditional" },
        ["ii"] = { query = "@conditional.inner", desc = "inner conditional" },
      },
    },
    move = {
      enable    = true,
      set_jumps = true,
      goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
      goto_next_end       = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
      goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
      goto_previous_end   = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
    },
    swap = {
      enable        = true,
      swap_next     = { ["<leader>na"] = "@parameter.inner" },
      swap_previous = { ["<leader>pa"] = "@parameter.inner" },
    },
  },
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr   = "nvim_treesitter#foldexpr()"
