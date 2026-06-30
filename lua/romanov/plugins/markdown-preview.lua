-- plugins/markdown-preview.lua
-- selimacerbas/markdown-preview.nvim: live browser preview for Markdown,
-- with Mermaid + KaTeX support. Pure Lua, zero external dependencies
-- (no npm, no Node.js, no Deno) — works identically on macOS and Debian.
--
-- This is the reliable fallback for mermaid viewing: unlike diagram.nvim
-- (terminal graphics, can be finicky over SSH/tmux), this opens a real
-- browser tab and renders with the actual mermaid.js library — always works
-- as long as you have a browser to point at the preview URL.
--
-- On a remote Debian session: the preview server binds to localhost on the
-- REMOTE machine. To view it from your local browser you need either:
--   a) SSH port forwarding:  ssh -L 8421:localhost:8421 web
--      then open http://localhost:8421 in your local browser, or
--   b) Add it to ~/.ssh/config as a LocalForward so it's automatic:
--        Host web
--          LocalForward 8421 localhost:8421
-- Locally on your Mac this just works with zero extra steps — open_browser
-- launches your default browser automatically.

local ok, mdpreview = pcall(require, "markdown_preview")
if not ok then return end

mdpreview.setup({
  instance_mode  = "takeover",  -- reuse one browser tab instead of spawning new ones
  port           = 8421,        -- fixed port so SSH -L forwarding is predictable
  open_browser   = true,
  default_theme  = "dark",      -- matches nightfly
  debounce_ms    = 300,
})

local km = vim.keymap.set
km("n", "<leader>mvo", "<cmd>MarkdownPreview<cr>",        { desc = "Markdown: Open preview" })
km("n", "<leader>mvr", "<cmd>MarkdownPreviewRefresh<cr>", { desc = "Markdown: Force refresh" })
km("n", "<leader>mvc", "<cmd>MarkdownPreviewStop<cr>",    { desc = "Markdown: Close preview" })
