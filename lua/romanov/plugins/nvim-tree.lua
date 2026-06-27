local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then return end

vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

nvimtree.setup({
  renderer = {
    icons = {
      glyphs = {
        folder = { arrow_closed = "", arrow_open = "" },
      },
    },
    highlight_git    = true,
    indent_markers   = { enable = true },
  },

  actions = {
    open_file = {
      window_picker  = { enable = false },
      -- resize_window = true causes the tree to widen on open; keep it false.
      resize_window  = false,
      -- Quit the tree after opening a file (cleaner workflow)
      quit_on_open   = false,
    },
  },

  -- update_focused_file: when enable=true nvim-tree auto-reveals (and in some
  -- versions auto-opens) the tree whenever you switch buffers.  This is what
  -- was making the tree appear uninvited every time you opened a file.
  update_focused_file = {
    enable      = false,
    update_root = false,
  },

  git = {
    enable  = true,
    ignore  = false,
    timeout = 400,
  },

  filters = {
    dotfiles = false,
    custom   = { "^.git$" },
  },

  view = {
    -- Fixed width: the adaptive function was evaluated at open-time before the
    -- window layout settled, producing a different (wider) value on first open.
    width = 30,
    side  = "left",
  },
})
