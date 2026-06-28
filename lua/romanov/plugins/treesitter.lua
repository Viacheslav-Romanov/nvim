-- plugins/treesitter.lua
-- nvim-treesitter was completely rewritten in 2024:
--   - nvim-treesitter.configs is GONE
--   - Highlighting is now nvim built-in (vim.treesitter.start), not a module
--   - Only use: require('nvim-treesitter').setup() for parser installation
--
-- nvim-treesitter-textobjects was also rewritten:
--   - No longer configured via nvim-treesitter.configs
--   - Keymaps set manually via its standalone API functions

-- ── 1. Parser installation ────────────────────────────────────────────────
local ok, ts = pcall(require, "nvim-treesitter")
if not ok then return end

ts.setup({
  ensure_installed = {
    "lua", "vim", "vimdoc", "regex", "query",
    "javascript", "typescript", "tsx", "html", "css", "json", "jsonc", "yaml",
    "graphql", "svelte",
    "php", "phpdoc",
    "rust", "c", "cpp",
    "kotlin", "java",
    "swift",
    "bash", "python",
    "markdown", "markdown_inline", "dockerfile", "toml",
    "comment",
  },
})

-- ── 2. Highlighting ───────────────────────────────────────────────────────
-- Enabling treesitter highlighting per filetype (nvim built-in API).
-- Skip files > 500KB to avoid slowdowns on large files.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TsHighlight", { clear = true }),
  callback = function(ev)
    local bufnr = ev.buf
    local ok2, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
    if ok2 and stats and stats.size > 500 * 1024 then return end
    pcall(vim.treesitter.start, bufnr)
  end,
  desc = "Enable treesitter highlighting",
})

-- ── 3. Indentation ────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TsIndent", { clear = true }),
  callback = function()
    if vim.treesitter.get_parser(0) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
  desc = "Enable treesitter indentation",
})

-- ── 4. Folding ────────────────────────────────────────────────────────────
vim.opt.foldmethod  = "expr"
vim.opt.foldexpr    = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel   = 99  -- open all folds by default

-- ── 5. Autotag ───────────────────────────────────────────────────────────
local autotag_ok, autotag = pcall(require, "nvim-ts-autotag")
if autotag_ok then
  autotag.setup({
    opts = {
      enable_close        = true,
      enable_rename       = true,
      enable_close_on_slash = false,
    },
  })
end

-- ── 6. Text objects ───────────────────────────────────────────────────────
-- nvim-treesitter-textobjects new standalone API.
-- select_textobject(query, query_group)
-- goto_next_start / goto_previous_start / etc.

local sel_ok,  ts_select = pcall(require, "nvim-treesitter-textobjects.select")
local move_ok, ts_move   = pcall(require, "nvim-treesitter-textobjects.move")
local swap_ok, ts_swap   = pcall(require, "nvim-treesitter-textobjects.swap")

-- Global config (lookahead, set_jumps)
local cfg_ok, ts_cfg = pcall(require, "nvim-treesitter-textobjects")
if cfg_ok then
  ts_cfg.setup({ select = { lookahead = true }, move = { set_jumps = true } })
end

-- Select text objects (visual + operator-pending)
if sel_ok then
  local sel_maps = {
    ["af"] = "@function.outer",
    ["if"] = "@function.inner",
    ["ac"] = "@class.outer",
    ["ic"] = "@class.inner",
    ["aa"] = "@parameter.outer",
    ["ia"] = "@parameter.inner",
    ["al"] = "@loop.outer",
    ["il"] = "@loop.inner",
    ["ai"] = "@conditional.outer",
    ["ii"] = "@conditional.inner",
  }
  for key, query in pairs(sel_maps) do
    vim.keymap.set({ "x", "o" }, key, function()
      ts_select.select_textobject(query, "textobjects")
    end, { desc = "Treesitter: " .. query })
  end
end

-- Move between nodes
if move_ok then
  local move_maps = {
    n = {
      ["]f"]  = { fn = ts_move.goto_next_start,     q = "@function.outer",  desc = "Next function start" },
      ["]F"]  = { fn = ts_move.goto_next_end,       q = "@function.outer",  desc = "Next function end"   },
      ["]c"]  = { fn = ts_move.goto_next_start,     q = "@class.outer",     desc = "Next class start"    },
      ["]C"]  = { fn = ts_move.goto_next_end,       q = "@class.outer",     desc = "Next class end"      },
      ["]a"]  = { fn = ts_move.goto_next_start,     q = "@parameter.inner", desc = "Next argument"       },
      ["[f"]  = { fn = ts_move.goto_previous_start, q = "@function.outer",  desc = "Prev function start" },
      ["[F"]  = { fn = ts_move.goto_previous_end,   q = "@function.outer",  desc = "Prev function end"   },
      ["[c"]  = { fn = ts_move.goto_previous_start, q = "@class.outer",     desc = "Prev class start"    },
      ["[C"]  = { fn = ts_move.goto_previous_end,   q = "@class.outer",     desc = "Prev class end"      },
      ["[a"]  = { fn = ts_move.goto_previous_start, q = "@parameter.inner", desc = "Prev argument"       },
    },
  }
  for mode, maps in pairs(move_maps) do
    for key, cfg in pairs(maps) do
      vim.keymap.set(mode, key, function()
        cfg.fn(cfg.q, "textobjects")
      end, { desc = "TS: " .. cfg.desc })
    end
  end
end

-- Swap arguments
if swap_ok then
  vim.keymap.set("n", "<leader>na", function()
    ts_swap.swap_next("@parameter.inner", "textobjects")
  end, { desc = "TS: Swap argument with next" })
  vim.keymap.set("n", "<leader>pa", function()
    ts_swap.swap_previous("@parameter.inner", "textobjects")
  end, { desc = "TS: Swap argument with prev" })
end
