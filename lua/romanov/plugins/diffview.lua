-- plugins/diffview.lua
-- diffview.nvim: two-panel git diff + full file history viewer.
-- Far better than :Gdiff for reviewing changes and understanding history.
-- Critical for kernel work where you need to trace what changed and why.

local ok, diffview = pcall(require, "diffview")
if not ok then return end

diffview.setup({
  enhanced_diff_hl = true,   -- better diff highlighting
  use_icons        = true,
  view = {
    default = { layout = "diff2_horizontal", winbar_info = true },
    file_history = { layout = "diff2_horizontal", winbar_info = true },
  },
  file_panel = { listing_style = "tree", tree_options = { flatten_dirs = true } },
  hooks = {
    diff_buf_win_enter = function()
      -- Disable line numbers in diff panels (cleaner)
      vim.opt_local.number         = false
      vim.opt_local.relativenumber = false
    end,
  },
})

local km = vim.keymap.set
km("n", "<leader>gd", "<cmd>DiffviewOpen<cr>",
  { desc = "Git: Open diffview (staged + unstaged)" })
km("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>",
  { desc = "Git: Full project history" })
km("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",
  { desc = "Git: Current file history" })
km("n", "<leader>gX", "<cmd>DiffviewClose<cr>",
  { desc = "Git: Close diffview" })
km("n", "<leader>gM", "<cmd>DiffviewOpen HEAD~1<cr>",
  { desc = "Git: Diff vs last commit" })
