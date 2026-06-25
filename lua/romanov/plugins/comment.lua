-- plugins/comment.lua
-- nvim-ts-context-commentstring v0.8+ requires its own setup() call with
-- enable_autocmd = false before the Comment.nvim integration will work.
-- Without this, gcc falls back to a generic comment string and ignores context.

local comment_ok, comment = pcall(require, "Comment")
if not comment_ok then return end

-- Step 1: initialise ts_context_commentstring (must happen before Comment.setup)
local ts_setup_ok, ts_commentstring = pcall(require, "ts_context_commentstring")
if ts_setup_ok then
  ts_commentstring.setup({ enable_autocmd = false })
end

-- Step 2: wire the pre_hook so Comment.nvim asks ts_context_commentstring
--         for the right token on every gcc / gbc call
local ts_integration_ok, ts_integration =
  pcall(require, "ts_context_commentstring.integrations.comment_nvim")

comment.setup({
  pre_hook = ts_integration_ok and ts_integration.create_pre_hook() or nil,
  toggler  = { line = "gcc", block = "gbc" },
  opleader = { line = "gc",  block = "gb"  },
  extra    = { above = "gcO", below = "gco", eol = "gcA" },
})
