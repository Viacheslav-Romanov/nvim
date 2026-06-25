-- plugins/comment.lua
-- ts-context-commentstring: correct token inside embedded languages (JSX, PHP, etc.)
local ok, comment = pcall(require, "Comment")
if not ok then return end

local ts_ok, ts_ctx = pcall(require, "ts_context_commentstring.integrations.comment_nvim")

comment.setup({
  pre_hook = ts_ok and ts_ctx.create_pre_hook() or nil,
  toggler  = { line = "gcc", block = "gbc" },
  opleader = { line = "gc",  block = "gb"  },
  extra    = { above = "gcO", below = "gco", eol = "gcA" },
})

-- Disable ts_context_commentstring's own autocmd; Comment.nvim calls it via pre_hook
vim.g.skip_ts_context_commentstring_module = true
