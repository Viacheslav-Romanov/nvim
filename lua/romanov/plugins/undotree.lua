-- plugins/undotree.lua
-- undotree: visual branching undo history — never lose work again.
-- Especially useful when you want to recover code you deleted 10 edits ago
-- or explore an alternative approach without committing.

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle,
  { desc = "Undotree: Toggle" })
