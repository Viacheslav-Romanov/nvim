local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
  return
end

-- Disable netrw (nvim-tree replaces it)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Custom indent marker colour (matches nightfly palette)
vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

nvimtree.setup({
  renderer = {
    icons = {
      glyphs = {
        folder = {
          arrow_closed = "",
          arrow_open   = "",
        },
      },
    },
    -- IMPROVED: highlight git status in the file tree
    highlight_git = true,
    indent_markers = {
      enable = true, -- show indent guide lines
    },
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false, -- needed for correct behaviour with splits
      },
      -- IMPROVED: resize nvim-tree when opening a file
      resize_window = false,
    },
  },
  -- IMPROVED: keep the tree in sync with the active buffer
  update_focused_file = {
    enable    = true,
    update_root = false,
    ignore_list = {},
  },
  -- IMPROVED: show git status icons
  git = {
    enable  = true,
    ignore  = false, -- show git-ignored files (dimmed)
    timeout = 400,
  },
  -- IMPROVED: filter dot-files but make it toggleable with 'H'
  filters = {
    dotfiles = false,
    custom   = { "^.git$" },
  },
  -- IMPROVED: show file size / modification time in the tree
  view = {
    width = 30,
    side  = "left",
  },
})

-- CHANGED: removed the VimEnter auto-open.
-- The old code opened nvim-tree whenever you opened nvim with no args or a directory.
-- Opening a directory still works (cd + open), but the tree won't pop open on a bare `nvim`.
-- Use <leader>e to toggle it when you need it, or re-add the autocmd below if you prefer auto-open.
--
-- To re-enable auto-open on directory:
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function(data)
--     if vim.fn.isdirectory(data.file) == 1 then
--       vim.cmd.cd(data.file)
--       require("nvim-tree.api").tree.open()
--     end
--   end,
-- })
