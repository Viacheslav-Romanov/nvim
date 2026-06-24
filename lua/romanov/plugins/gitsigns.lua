local setup, gitsigns = pcall(require, "gitsigns")
if not setup then
  return
end

-- IMPROVED: added keymaps for hunk navigation and staging — the default
-- gitsigns.setup() leaves these unbound, which wastes most of the plugin's value.
gitsigns.setup({
  signs = {
    add          = { text = "│" },
    change       = { text = "│" },
    delete       = { text = "_" },
    topdelete    = { text = "‾" },
    changedelete = { text = "~" },
    untracked    = { text = "┆" },
  },
  current_line_blame = false, -- set to true if you want inline blame annotations
  current_line_blame_opts = {
    delay = 800,
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- Navigation: jump between hunks
    map("n", "]h", function()
      if vim.wo.diff then return "]h" end
      vim.schedule(function() gs.next_hunk() end)
      return "<Ignore>"
    end, "Next git hunk")

    map("n", "[h", function()
      if vim.wo.diff then return "[h" end
      vim.schedule(function() gs.prev_hunk() end)
      return "<Ignore>"
    end, "Prev git hunk")

    -- Actions
    map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
    map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
    map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage selected hunk")
    map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset selected hunk")
    map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
    map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
    map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
    map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line (full)")
    map("n", "<leader>hd", gs.diffthis, "Diff this file")
    map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff against last commit")

    -- Toggle
    map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle line blame")
    map("n", "<leader>td", gs.toggle_deleted, "Toggle deleted lines")

    -- Text object: ih = inner hunk
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk (text obj)")
  end,
})
