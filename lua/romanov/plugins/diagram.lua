-- plugins/diagram.lua
-- 3rd/diagram.nvim: renders mermaid (and plantuml/d2/gnuplot) diagrams
-- inline as images using image.nvim + a terminal graphics protocol
-- (Kitty graphics protocol or Überzug++).
--
-- IMPORTANT — works over SSH too, in principle:
-- The Kitty graphics protocol is just terminal escape sequences. If your
-- local terminal (iTerm2, Kitty, WezTerm) understands them, it doesn't
-- matter whether nvim is running locally or on a remote Debian server via
-- SSH — the escapes pass through the SSH session unmodified and your local
-- terminal renders the image. No GUI is required on the remote host.
--
-- What CAN break it on a remote/Debian session:
--   1. The remote machine needs `image.nvim`'s chosen processor available
--      (ImageMagick `magick`/`convert`, or stick with the kitty backend
--      which needs no external binary at all — just the protocol).
--   2. tmux: by default tmux strips graphics escape codes. If you use tmux
--      on the server, you need tmux >= 3.3 with `allow-passthrough on` set
--      in .tmux.conf, or images will silently not render (no crash though).
--   3. iTerm2: supports the kitty protocol natively as of recent versions —
--      no extra config needed locally.
--
-- If diagrams don't render in a given session, the plugin fails silently
-- (no error) — you'll just see the raw code fence. That's expected on
-- non-graphics-capable terminals.

local ok_diag, diagram = pcall(require, "diagram")
if not ok_diag then return end

diagram.setup({
  integrations = {
    require("diagram.integrations.markdown"),
  },
  events = {
    render_buffer = { "InsertLeave", "BufWinEnter", "TextChanged" },
    clear_buffer  = { "BufLeave" },
  },
  renderer_options = {
    mermaid = {
      background = "transparent",
      theme      = "dark",   -- matches nightfly's dark palette
      scale      = 2,        -- crisper rendering on retina displays
    },
  },
})

-- Manual render/clear keymaps (useful when auto-render-on-events misses something,
-- e.g. you just pasted a diagram and haven't left insert mode yet)
vim.keymap.set("n", "<leader>dgr", function()
  require("diagram").render()
end, { desc = "Diagram: Render under cursor" })

vim.keymap.set("n", "<leader>dgc", function()
  require("diagram").clear()
end, { desc = "Diagram: Clear rendered images" })

vim.keymap.set("n", "<leader>dgt", function()
  -- Toggle: clear if rendered, render if not — handled internally by the plugin
  require("diagram").clear()
  require("diagram").render()
end, { desc = "Diagram: Re-render" })
