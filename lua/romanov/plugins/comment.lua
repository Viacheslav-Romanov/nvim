-- plugins/comment.lua
-- ts_context_commentstring returns nil for filetypes without embedded languages
-- (e.g. plain .js, .ts, .rs). Passing nil straight to Comment.nvim causes the
-- "[Comment.nvim] nil" error because it has no commentstring to work with.
-- Fix: fall back to vim.bo.commentstring explicitly when the hook returns nil.

local comment_ok, comment = pcall(require, "Comment")
if not comment_ok then return end

local pre_hook = nil

do
  -- ts_context_commentstring v0.8+ requires its own setup() with enable_autocmd=false
  -- so it does not overwrite vim.bo.commentstring via its own BufEnter autocmd.
  local ts_ok, ts = pcall(require, "ts_context_commentstring")
  if ts_ok then
    ts.setup({ enable_autocmd = false })

    local int_ok, integration =
      pcall(require, "ts_context_commentstring.integrations.comment_nvim")

    if int_ok then
      local inner_hook = integration.create_pre_hook()

      pre_hook = function(ctx)
        -- Ask ts_context_commentstring for a context-aware string (e.g. {/* */} in JSX).
        local ok, cs = pcall(inner_hook, ctx)

        -- If it returned a valid template (contains %s), use it.
        if ok and type(cs) == "string" and cs:find("%%s") then
          return cs
        end

        -- Otherwise fall back to the filetype's native commentstring
        -- so gcc always works (e.g. "// %s" for JS, "-- %s" for Lua, etc.)
        local fallback = vim.bo.commentstring
        return (fallback and fallback ~= "") and fallback or nil
      end
    end
  end
end

comment.setup({
  pre_hook = pre_hook,
  toggler  = { line = "gcc", block = "gbc" },
  opleader = { line = "gc",  block = "gb"  },
  extra    = { above = "gcO", below = "gco", eol = "gcA" },
})
