-- plugins/inc-rename.lua
-- inc-rename.nvim: rename symbol with live preview — every occurrence updates
-- as you type the new name. Replaces lspsaga rename for a much better UX.

local ok, inc_rename = pcall(require, "inc_rename")
if not ok then return end

inc_rename.setup({
  input_buffer_type = "dressing",  -- use dressing.nvim input if available, else built-in
})

-- Overrides <leader>rn set in lspconfig.lua / rust.lua
vim.keymap.set("n", "<leader>rn", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "LSP: Rename (live preview)" })
